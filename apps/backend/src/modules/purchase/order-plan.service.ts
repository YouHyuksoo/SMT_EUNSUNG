/**
 * @file src/modules/purchase/order-plan.service.ts
 * @description 478 자재발주계획 — PB w_mat_purchase_order_plan_master 이식 (쓰기)
 *
 * PB 원본은 4,252줄이지만 SQL 은 몇 개 되지 않는다. 같은 문장이 화면 체크박스
 * 조합마다 복붙돼 있을 뿐이다 — 실측으로 `IM_ITEM_INVENTORY_GEN` INSERT 40개가
 * **전부 같은 5컬럼**이고, 달라지는 것은 UNION ALL 가지 다섯 개의 켬/끔이다.
 * 웹은 그 다섯을 불리언으로 받아 한 문장을 만든다.
 *
 * 처리 순서 (PB cb_gen_po / cb_gen_do):
 *   1. 계획 원천에서 BOM 을 펴 `IM_ITEM_PURCHASE_REQUIR_ORDER` 를 만든다 (생성기 5종)
 *   2. 발주잔량·도착분·재고를 `*_GEN` 표에 모은다
 *   3. 소요량에서 그것들을 순서대로 차감해 `IM_ITEM_PURCHASE_ORDER_PLAN` 을 만든다
 *   4. 확정하면 계획이 실제 주문(`IM_ITEM_PURCHASE_ORDER`)이 된다
 *
 * 차감은 순서가 결과를 바꾸므로 집합 연산으로 바꾸지 않고 PB 와 같은 커서 순회를
 * 유지한다. 다만 커서는 PowerBuilder 가 아니라 **익명 PL/SQL 블록 안**에서 돈다.
 */
import { Injectable, BadRequestException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { InjectDataSource } from '@nestjs/typeorm';
import { ROW_LIMIT } from '../../shared/row-limit';
import type {
  OrderPlanGenerateDto,
  OrderPlanPurchaseDto,
  OrderPlanQueryDto,
  PriceResetDto,
} from './purchase.dto';

/**
 * 계획 원천. PB 는 라디오버튼으로 골랐고 각각 전용 PB 함수를 불렀다
 * (`f_gen_purchase_order_plan_by_*`). 다섯의 차이는 **커서 원천뿐**이라
 * 여기서는 SELECT 문 하나씩만 둔다.
 *
 * `byTime` 계열은 계획일에 시:분을 붙여 같은 날 안에서도 순서를 가른다.
 */
const PLAN_SOURCES = {
  /** 수기로 넣은 발주 기준계획. */
  manual: {
    label: '수기계획',
    sql: `SELECT ITEM_CODE, PLAN_DATE, ORDER_QTY AS QTY
            FROM IM_ITEM_MASTER_PLAN_4_PO
           WHERE TRUNC(PLAN_DATE) BETWEEN v_from AND v_to
             AND ITEM_CODE LIKE v_item
             AND ORGANIZATION_ID = :organizationId`,
  },
  /** 생산계획(MI). 남은 수량 = 계획 - 실적. */
  productionPlan: {
    label: '생산계획',
    sql: `SELECT ITEM_CODE, PLAN_DATE, PLAN_QTY - NVL(ACTUAL_QTY, 0) AS QTY
            FROM IP_PRODUCT_MI_PLAN
           WHERE TRUNC(PLAN_DATE) BETWEEN v_from AND v_to
             AND NVL(PLAN_QTY, 0) - NVL(ACTUAL_QTY, 0) > 0
             AND ITEM_CODE LIKE v_item
             AND ORGANIZATION_ID = :organizationId`,
  },
  /** 생산계획을 시간까지 나눠 본다 (PLAN_PRIORITY 3~7자리가 HHMI). */
  productionPlanByTime: {
    label: '생산계획(시간별)',
    sql: `SELECT ITEM_CODE,
                 TO_DATE(TO_CHAR(PLAN_DATE, 'YYYYMMDD') || ' '
                         || SUBSTR(PLAN_PRIORITY, 3, 5), 'YYYYMMDD HH24:MI') AS PLAN_DATE,
                 PLAN_QTY - NVL(ACTUAL_QTY, 0) AS QTY
            FROM IP_PRODUCT_MI_PLAN
           WHERE TRUNC(PLAN_DATE) BETWEEN v_from AND v_to
             AND NVL(PLAN_QTY, 0) - NVL(ACTUAL_QTY, 0) > 0
             AND ITEM_CODE LIKE v_item
             AND ORGANIZATION_ID = :organizationId`,
  },
  /** 납품계획. 남은 수량에서 지시번호로 잡힌 실적까지 뺀다. */
  salePlan: {
    label: '납품계획',
    sql: `SELECT ITEM_CODE, PLAN_DATE,
                 PLAN_QTY - (NVL(ACTUAL_QTY, 0)
                   + F_GET_PLAN_ACTUAL_QTY_BY_ONO(WORK_ORDER_NO, ORGANIZATION_ID)) AS QTY
            FROM IP_PRODUCT_DELIVERY_PLAN
           WHERE TRUNC(PLAN_DATE) BETWEEN v_from AND v_to
             AND ITEM_CODE LIKE v_item
             AND ORGANIZATION_ID = :organizationId`,
  },
  salePlanByTime: {
    label: '납품계획(시간별)',
    sql: `SELECT ITEM_CODE,
                 TO_DATE(TO_CHAR(PLAN_DATE, 'YYYYMMDD') || ' '
                         || PLAN_PRIORITY, 'YYYYMMDD HH24:MI:SS') AS PLAN_DATE,
                 PLAN_QTY - NVL(ACTUAL_QTY, 0) AS QTY
            FROM IP_PRODUCT_DELIVERY_PLAN
           WHERE TRUNC(PLAN_DATE) BETWEEN v_from AND v_to
             AND ITEM_CODE LIKE v_item
             AND ORGANIZATION_ID = :organizationId`,
  },
} as const;

export type PlanSource = keyof typeof PLAN_SOURCES;

/**
 * 재고 집계에 넣을 원천. PB 는 체크박스 다섯의 조합마다 INSERT 를 따로 적어
 * 두었다(실측 40개, 컬럼은 전부 동일). 여기서는 켜진 가지만 UNION ALL 로 잇는다.
 */
const INVENTORY_ARMS = {
  /** 자재창고 재고. PB 도 `LOCATION_CODE = 'M01'` 만 본다. */
  inventory: `SELECT ITEM_CODE, LINE_TYPE, ORGANIZATION_ID, SUM(INVENTORY_QTY) AS QTY
                FROM IM_ITEM_INVENTORY
               WHERE ORGANIZATION_ID = :organizationId
                 AND LOCATION_CODE = 'M01'
               GROUP BY ITEM_CODE, LINE_TYPE, ORGANIZATION_ID`,
  /** 아직 안 들어온 발주잔량. */
  order: `SELECT ITEM_CODE, LINE_TYPE, ORGANIZATION_ID, SUM(ORDER_QTY) AS QTY
            FROM IM_ITEM_PURCHASE_ORDER_GEN
           WHERE ORGANIZATION_ID = :organizationId
           GROUP BY ITEM_CODE, LINE_TYPE, ORGANIZATION_ID`,
  /** 도착했지만 입고 전인 물량. */
  arrival: `SELECT ITEM_CODE, LINE_TYPE, ORGANIZATION_ID, ARRIVAL_QTY AS QTY
              FROM IM_ITEM_ARRIVAL_GEN
             WHERE ORGANIZATION_ID = :organizationId`,
  /**
   * 공정에 깔려 있는 재고.
   *
   * PB 는 이 표에서 `LINE_TYPE` 을 읽는데, **이 스키마의
   * `IM_ITEM_WORKSTAGE_INVENTORY` 에는 그 컬럼이 없다** (`LINE_CODE` 뿐, 실측).
   * PB 에서 이 체크박스를 켜면 ORA-00904 로 떨어진다. 다른 가지들과 묶으려면
   * 거래유형이 있어야 하므로, 이미 같은 문장이 걸고 있는 `ID_ITEM` 에서 가져온다.
   */
  workstageInventory: `SELECT W.ITEM_CODE, I.LINE_TYPE, W.ORGANIZATION_ID,
                              SUM(W.INVENTORY_QTY) AS QTY
                         FROM IM_ITEM_WORKSTAGE_INVENTORY W
                         JOIN ID_ITEM I
                           ON I.ITEM_CODE = W.ITEM_CODE
                          AND I.ORGANIZATION_ID = W.ORGANIZATION_ID
                          AND I.ITEM_DIVISION IN ('R', 'S')
                          AND I.DATESET <= TRUNC(SYSDATE)
                          AND I.DATEEND >= TRUNC(SYSDATE)
                        WHERE W.ORGANIZATION_ID = :organizationId
                        GROUP BY W.ITEM_CODE, I.LINE_TYPE, W.ORGANIZATION_ID`,
  /** 무상재고. PB 도 원자재·부자재(`ITEM_DIVISION` R·S)만 센다. */
  freeInventory: `SELECT ITEM_CODE, LINE_TYPE, ORGANIZATION_ID, SUM(INVENTORY_QTY) AS QTY
                    FROM IM_ITEM_FREE_INVENTORY
                   WHERE ORGANIZATION_ID = :organizationId
                     AND ITEM_CODE IN (SELECT ITEM_CODE FROM ID_ITEM
                                        WHERE ITEM_DIVISION IN ('R', 'S')
                                          AND ORGANIZATION_ID = :organizationId)
                   GROUP BY ITEM_CODE, LINE_TYPE, ORGANIZATION_ID`,
} as const;

export type InventoryArm = keyof typeof INVENTORY_ARMS;

/** BOM 전개 결과에서 소요량으로 잡지 않는 거래유형. PB 원본 그대로다. */
const EXCLUDED_LINE_TYPES = ["'A'", "'T'"];

interface Paged<T> {
  data: T[];
  total: number;
  truncated: boolean;
}

@Injectable()
export class OrderPlanService {
  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

  // ─────────────────────────────── 조회

  /** dw_1 발주계획 목록. */
  async findOrderPlans(
    query: OrderPlanQueryDto,
    organizationId: number,
  ): Promise<Paged<Record<string, unknown>>> {
    const binds: Record<string, unknown> = {
      organizationId,
      rowLimit: ROW_LIMIT + 1,
    };
    let filter = '';
    if (query.supplierCode) {
      filter += ' AND A.SUPPLIER_CODE = :supplierCode';
      binds.supplierCode = query.supplierCode;
    }
    if (query.itemCode) {
      filter += ' AND A.ITEM_CODE LIKE :itemCode';
      binds.itemCode = `%${query.itemCode}%`;
    }
    if (query.lineType) {
      filter += ' AND A.LINE_TYPE = :lineType';
      binds.lineType = query.lineType;
    }
    if (query.dateFrom && query.dateTo) {
      filter += ` AND A.DELIVERY_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
                  AND A.DELIVERY_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1`;
      binds.dateFrom = query.dateFrom;
      binds.dateTo = query.dateTo;
    }
    /** 주문으로 넘어간 계획을 뺀다 (ORDER_NO 가 채워진 행). */
    if (query.pendingOnly) {
      filter += ' AND A.PURCHASE_ORDER_QTY > 0';
    }

    const rows = await this.dataSource.query(
      `SELECT * FROM (
         SELECT A.ITEM_CODE            AS "itemCode",
                I.ITEM_NAME            AS "itemName",
                I.ITEM_SPEC            AS "itemSpec",
                I.ITEM_UOM             AS "itemUom",
                A.LINE_TYPE            AS "lineType",
                A.SUPPLIER_CODE        AS "supplierCode",
                S.SUPPLIER_NAME        AS "supplierName",
                A.ORDER_NO             AS "orderNo",
                A.PURCHASE_ORDER_DATE  AS "purchaseOrderDate",
                A.DELIVERY_DATE        AS "deliveryDate",
                A.ORDER_QTY            AS "orderQty",
                A.INVENTORY_QTY        AS "inventoryQty",
                A.TOTAL_INVENTORY_QTY  AS "totalInventoryQty",
                A.PURCHASE_ORDER_QTY   AS "purchaseOrderQty",
                A.ARRIVAL_QTY          AS "arrivalQty",
                A.UNIT_PRICE           AS "unitPrice",
                NVL(A.UNIT_PRICE, 0) * NVL(A.PURCHASE_ORDER_QTY, 0) AS "orderAmt",
                A.CURRENCY             AS "currency",
                A.DELIVERY             AS "delivery",
                A.PURCHASE_ORDER_STATUS AS "purchaseOrderStatus",
                A.MFS                  AS "mfs",
                A.ENTER_BY             AS "enterBy",
                A.ENTER_DATE           AS "enterDate"
           FROM IM_ITEM_PURCHASE_ORDER_PLAN A
           LEFT JOIN ID_ITEM I
             ON I.ITEM_CODE = A.ITEM_CODE
            AND I.ORGANIZATION_ID = A.ORGANIZATION_ID
           LEFT JOIN ICOM_SUPPLIER S
             ON S.SUPPLIER_CODE = A.SUPPLIER_CODE
            AND S.ORGANIZATION_ID = A.ORGANIZATION_ID
          WHERE A.ORGANIZATION_ID = :organizationId
            ${filter}
          ORDER BY A.ITEM_CODE, A.LINE_TYPE, A.DELIVERY_DATE
       ) WHERE ROWNUM <= :rowLimit`,
      binds as unknown as unknown[],
    );
    return this.page(rows);
  }

  /** 발주계획을 만들기 전 단계인 소요량. 전개 결과를 그대로 본다. */
  async findRequirementOrders(
    organizationId: number,
  ): Promise<Paged<Record<string, unknown>>> {
    const rows = await this.dataSource.query(
      `SELECT * FROM (
         SELECT A.REQUIRMENT_PLAN_DATE AS "requirementPlanDate",
                A.PLAN_DATE            AS "planDate",
                A.ITEM_CODE            AS "itemCode",
                I.ITEM_NAME            AS "itemName",
                I.ITEM_UOM             AS "itemUom",
                A.LINE_TYPE            AS "lineType",
                A.SUPPLIER_CODE        AS "supplierCode",
                S.SUPPLIER_NAME        AS "supplierName",
                A.MFS                  AS "mfs",
                A.REQUIRMENT_QTY       AS "requirementQty"
           FROM IM_ITEM_PURCHASE_REQUIR_ORDER A
           LEFT JOIN ID_ITEM I
             ON I.ITEM_CODE = A.ITEM_CODE
            AND I.ORGANIZATION_ID = A.ORGANIZATION_ID
           LEFT JOIN ICOM_SUPPLIER S
             ON S.SUPPLIER_CODE = A.SUPPLIER_CODE
            AND S.ORGANIZATION_ID = A.ORGANIZATION_ID
          WHERE A.ORGANIZATION_ID = :organizationId
          ORDER BY A.ITEM_CODE, A.PLAN_DATE
       ) WHERE ROWNUM <= :rowLimit`,
      { organizationId, rowLimit: ROW_LIMIT + 1 } as unknown as unknown[],
    );
    return this.page(rows);
  }

  // ─────────────────────────────── 발주계획 생성 (cb_gen_po / cb_gen_do)

  /**
   * 계획 원천 → BOM 전개 → 재고 차감 → 발주계획.
   *
   * PB 가 라디오버튼·체크박스로 갈라 두었던 것을 인자로 받는다.
   * 체크박스 하나하나가 계산에 실제로 관여하므로 기본값을 두지 않고 전부 받는다.
   */
  async generate(
    dto: OrderPlanGenerateDto,
    organizationId: number,
    userId: string,
  ): Promise<{ requirementRows: number; planRows: number }> {
    const source = PLAN_SOURCES[dto.source as PlanSource];
    if (!source) throw new BadRequestException('계획 원천이 올바르지 않습니다.');

    const arms = (dto.inventorySources ?? []).filter(
      (name): name is InventoryArm => name in INVENTORY_ARMS,
    );

    return this.dataSource.transaction(async (manager) => {
      // ① 계획을 BOM 으로 펴서 소요량을 만든다.
      await manager.query(
        `DECLARE
           v_from        DATE := TRUNC(TO_DATE(:dateFrom, 'YYYY-MM-DD'));
           v_to          DATE := TRUNC(TO_DATE(:dateTo, 'YYYY-MM-DD'));
           v_item        VARCHAR2(100) := :itemPattern;
           v_req_session NUMBER;
           v_bom_session NUMBER;
         BEGIN
           v_req_session := SEQ_REQUIRMENT_PLAN.NEXTVAL;

           FOR c IN (${source.sql}) LOOP
             IF c.QTY IS NULL THEN
               RAISE_APPLICATION_ERROR(-20010, 'QTY_NULL:' || c.ITEM_CODE);
             END IF;

             v_bom_session := PKG_DESIGN.BOM_EXPLOSION(c.ITEM_CODE, c.PLAN_DATE, :organizationId);
             IF v_bom_session < 0 THEN
               RAISE_APPLICATION_ERROR(-20011, 'BOM_FAIL:' || c.ITEM_CODE);
             END IF;

             INSERT INTO IM_ITEM_REQUIRMENT_PLAN_TEMP
               (SESSION_ID, REQUIRMENT_PLAN_DATE, MFS, ITEM_CODE, LINE_TYPE, SUPPLIER_CODE,
                ORGANIZATION_ID, PLAN_DATE, REQUIRMENT_QTY, ENTER_BY, ENTER_DATE,
                LAST_MODIFY_BY, LAST_MODIFY_DATE)
             SELECT v_req_session, TRUNC(SYSDATE), '*', CHILD_ITEM_CODE, LINE_TYPE, '*',
                    ORGANIZATION_ID, c.PLAN_DATE, MODEL_UNIT_QTY * c.QTY,
                    :userId, SYSDATE, :userId, SYSDATE
               FROM ID_ENG_BOM_TEMP
              WHERE SESSION_ID = v_bom_session
                AND LINE_TYPE NOT IN (${EXCLUDED_LINE_TYPES.join(', ')});

             DELETE FROM ID_ENG_BOM_TEMP WHERE SESSION_ID = v_bom_session;
           END LOOP;

           -- 소요량은 조직 단위로 통째로 갈아끼운다. PB 도 그렇게 한다.
           DELETE FROM IM_ITEM_PURCHASE_REQUIR_ORDER
            WHERE ORGANIZATION_ID = :organizationId;

           INSERT INTO IM_ITEM_PURCHASE_REQUIR_ORDER
             (REQUIRMENT_PLAN_DATE, MFS, ITEM_CODE, SUPPLIER_CODE, ORGANIZATION_ID,
              PLAN_DATE, REQUIRMENT_QTY, LINE_TYPE, ENTER_BY, ENTER_DATE,
              LAST_MODIFY_BY, LAST_MODIFY_DATE)
           SELECT REQUIRMENT_PLAN_DATE, MFS, ITEM_CODE,
                  F_GET_MAX_SUPPLIER_BY_ITEM(ITEM_CODE, ORGANIZATION_ID),
                  ORGANIZATION_ID, PLAN_DATE, SUM(REQUIRMENT_QTY), LINE_TYPE,
                  MAX(ENTER_BY), MAX(ENTER_DATE), MAX(LAST_MODIFY_BY), MAX(LAST_MODIFY_DATE)
             FROM IM_ITEM_REQUIRMENT_PLAN_TEMP
            WHERE SESSION_ID = v_req_session
              AND LINE_TYPE <> 'T'
            GROUP BY REQUIRMENT_PLAN_DATE, MFS, ITEM_CODE, LINE_TYPE, SUPPLIER_CODE,
                     ORGANIZATION_ID, PLAN_DATE;

           DELETE FROM IM_ITEM_REQUIRMENT_PLAN_TEMP WHERE SESSION_ID = v_req_session;
         END;`,
        {
          dateFrom: dto.dateFrom,
          dateTo: dto.dateTo,
          itemPattern: dto.itemCode ? `%${dto.itemCode}%` : '%',
          organizationId,
          userId,
        } as unknown as unknown[],
      ).catch((error: unknown) => {
        const message = error instanceof Error ? error.message : String(error);
        const qtyNull = /QTY_NULL:(\S+)/.exec(message);
        if (qtyNull) {
          throw new BadRequestException(
            `${qtyNull[1]} 의 계획수량이 비어 있습니다. 계획을 먼저 확인하세요.`,
          );
        }
        const bomFail = /BOM_FAIL:(\S+)/.exec(message);
        if (bomFail) {
          throw new BadRequestException(`${bomFail[1]} 의 BOM 을 펼 수 없습니다.`);
        }
        throw error;
      });

      // ② 발주잔량·도착분을 모으고, ③ 켜진 재고 가지를 합친다.
      await this.buildGenTables(manager, organizationId, arms);

      // ④ 소요량에서 차감해 발주계획을 만든다.
      await this.netRequirements(manager, organizationId, dto, userId);

      const [{ REQ }] = await manager.query(
        `SELECT COUNT(*) AS REQ FROM IM_ITEM_PURCHASE_REQUIR_ORDER
          WHERE ORGANIZATION_ID = :organizationId`,
        { organizationId } as unknown as unknown[],
      );
      const [{ PLN }] = await manager.query(
        `SELECT COUNT(*) AS PLN FROM IM_ITEM_PURCHASE_ORDER_PLAN
          WHERE ORGANIZATION_ID = :organizationId`,
        { organizationId } as unknown as unknown[],
      );
      return { requirementRows: Number(REQ), planRows: Number(PLN) };
    });
  }

  /** 발주잔량·도착분·재고를 `*_GEN` 표에 모은다. */
  private async buildGenTables(
    manager: { query: (sql: string, binds?: unknown[]) => Promise<unknown> },
    organizationId: number,
    arms: InventoryArm[],
  ): Promise<void> {
    const binds = { organizationId } as unknown as unknown[];

    await manager.query(
      `DELETE FROM IM_ITEM_PURCHASE_ORDER_GEN WHERE ORGANIZATION_ID = :organizationId`,
      binds,
    );
    await manager.query(
      `INSERT INTO IM_ITEM_PURCHASE_ORDER_GEN
         (ITEM_CODE, LINE_TYPE, ORGANIZATION_ID, DELIVERY_DATE, ORDER_QTY)
       SELECT ITEM_CODE, LINE_TYPE, ORGANIZATION_ID, DELIVERY_DATE,
              SUM(ORDER_QTY - NVL(ARRIVAL_QTY, 0))
         FROM IM_ITEM_PURCHASE_ORDER
        WHERE ORDER_QTY - NVL(ARRIVAL_QTY, 0) > 0
          AND ORGANIZATION_ID = :organizationId
        GROUP BY ITEM_CODE, LINE_TYPE, DELIVERY_DATE, ORGANIZATION_ID`,
      binds,
    );

    await manager.query(
      `DELETE FROM IM_ITEM_ARRIVAL_GEN WHERE ORGANIZATION_ID = :organizationId`,
      binds,
    );
    await manager.query(
      `INSERT INTO IM_ITEM_ARRIVAL_GEN
         (ITEM_CODE, LINE_TYPE, ORGANIZATION_ID, ARRIVAL_QTY)
       SELECT ITEM_CODE, LINE_TYPE, ORGANIZATION_ID, SUM(ARRIVAL_QTY)
         FROM IM_ITEM_ARRIVAL
        WHERE ARRIVAL_TYPE = 'A'
          AND ARRIVAL_STATUS = 'N'
          AND ORGANIZATION_ID = :organizationId
        GROUP BY ITEM_CODE, LINE_TYPE, ORGANIZATION_ID`,
      binds,
    );

    await manager.query(
      `DELETE FROM IM_ITEM_INVENTORY_GEN WHERE ORGANIZATION_ID = :organizationId`,
      binds,
    );
    if (arms.length === 0) return;

    // PB 가 조합마다 따로 적어 둔 INSERT 를 여기서는 켜진 가지만 이어 만든다.
    const union = arms.map((name) => INVENTORY_ARMS[name]).join('\n UNION ALL\n');
    await manager.query(
      `INSERT INTO IM_ITEM_INVENTORY_GEN
         (ITEM_CODE, LINE_TYPE, ORGANIZATION_ID, INVENTORY_QTY, PURCHASE_ORDER_QTY)
       SELECT ITEM_CODE, LINE_TYPE, ORGANIZATION_ID, SUM(QTY), 0
         FROM (${union})
        GROUP BY ITEM_CODE, LINE_TYPE, ORGANIZATION_ID`,
      binds,
    );
  }

  /**
   * 소요량에서 재고를 차감해 발주계획을 만든다.
   *
   * 차감 순서가 결과를 바꾸므로 PB 와 같은 순회를 유지한다 (품목·거래유형·납기).
   * `F_GET_ORDER_PROPERTY` 는 DB 에 없는 PB 함수라 블록 안에 그대로 옮겼다 —
   * 최소주문량·포장단위·불량율을 `IM_ITEM_MASTER` 에서 읽어 주문량을 올린다.
   */
  private async netRequirements(
    manager: { query: (sql: string, binds?: unknown[]) => Promise<unknown> },
    organizationId: number,
    dto: OrderPlanGenerateDto,
    userId: string,
  ): Promise<void> {
    await manager.query(
      `DECLARE
         v_remain    NUMBER;
         v_pool      NUMBER;
         v_rowid     ROWID;
         v_applied   NUMBER;
         v_calc      NUMBER;
         v_min_qty   NUMBER;
         v_pack_qty  NUMBER;
         v_bad_rate  NUMBER;
         v_uom       VARCHAR2(20);
         v_bad_qty   NUMBER;
       BEGIN
         DELETE FROM IM_ITEM_PURCHASE_ORDER_PLAN WHERE ORGANIZATION_ID = :organizationId;

         -- PB 원문 그대로다. 소요량의 계획일이 곧 납기가 되고, 주문량은 협력사별
         -- 발주비율(IM_ITEM_MASTER.ORDER_RATE)로 조정된다. 대상은 발주규칙이 'O'
         -- 인 유효 품목뿐이다.
         INSERT INTO IM_ITEM_PURCHASE_ORDER_PLAN
           (ORDER_NO, PURCHASE_ORDER_DATE, ORGANIZATION_ID, SUPPLIER_CODE, ITEM_CODE,
            DELIVERY_DATE, DELIVERY, LINE_TYPE, ORDER_TYPE, ORDER_QTY,
            PURCHASE_ORDER_QTY, UNIT_PRICE, CURRENCY, INVENTORY_QTY, ARRIVAL_QTY,
            PRE_ORDER_QTY, MFS, PURCHASE_ORDER_STATUS, PAYMENT_TYPE,
            ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE,
            SET_ITEM_CODE, PARENT_ITEM_CODE)
         SELECT TO_CHAR(A.ORGANIZATION_ID) || TO_CHAR(SYSDATE, 'YYMMDD') || ROWNUM,
                TRUNC(TO_DATE(:orderDate, 'YYYY-MM-DD')),
                A.ORGANIZATION_ID, NVL(B.SUPPLIER_CODE, '*'), A.ITEM_CODE,
                A.DELIVERY_DATE, '1', A.LINE_TYPE, 'O',
                DECODE(B.ORDER_RATE, NULL, A.ORDER_QTY, A.ORDER_QTY * B.ORDER_RATE / 100),
                DECODE(B.ORDER_RATE, NULL, A.ORDER_QTY, A.ORDER_QTY * B.ORDER_RATE / 100),
                0, '*', 0, 0, 0, A.MFS, 'N', NVL(B.PAYMENT_TYPE, '*'),
                :userId, SYSDATE, :userId, SYSDATE,
                A.SET_ITEM_CODE, A.PARENT_ITEM_CODE
           FROM (SELECT ORGANIZATION_ID, ITEM_CODE, PLAN_DATE AS DELIVERY_DATE, LINE_TYPE,
                        SUM(REQUIRMENT_QTY) AS ORDER_QTY, MFS, SET_ITEM_CODE,
                        MAX(PARENT_ITEM_CODE) AS PARENT_ITEM_CODE
                   FROM IM_ITEM_PURCHASE_REQUIR_ORDER
                  WHERE ORGANIZATION_ID = :organizationId
                    AND ITEM_CODE IN (SELECT ITEM_CODE FROM ID_ITEM
                                       WHERE DATESET <= TRUNC(SYSDATE)
                                         AND DATEEND >= TRUNC(SYSDATE)
                                         AND NVL(ORDER_RULE, '*') = 'O'
                                         AND ORGANIZATION_ID = :organizationId)
                  GROUP BY MFS, PLAN_DATE, SET_ITEM_CODE, ITEM_CODE, LINE_TYPE,
                           ORGANIZATION_ID) A
           LEFT JOIN IM_ITEM_MASTER B
             ON A.ITEM_CODE = B.ITEM_CODE
            AND A.ORGANIZATION_ID = B.ORGANIZATION_ID
            AND B.DATESET <= TRUNC(SYSDATE)
            AND B.DATEEND >= TRUNC(SYSDATE);

         -- 품목·거래유형·납기 순서로 앞에서부터 재고를 떼어 준다.
         FOR p IN (
           SELECT SUPPLIER_CODE, ITEM_CODE, LINE_TYPE, ORDER_QTY, ROWID AS RID
             FROM IM_ITEM_PURCHASE_ORDER_PLAN
            WHERE ORGANIZATION_ID = :organizationId
            ORDER BY ITEM_CODE, LINE_TYPE, DELIVERY_DATE, ORGANIZATION_ID
         ) LOOP
           v_remain := NVL(p.ORDER_QTY, 0);
           v_applied := 0;

           FOR g IN (
             SELECT NVL(INVENTORY_QTY, 0) AS QTY, ROWID AS RID
               FROM IM_ITEM_INVENTORY_GEN
              WHERE ITEM_CODE = p.ITEM_CODE
                AND LINE_TYPE = p.LINE_TYPE
                AND NVL(INVENTORY_QTY, 0) > 0
                AND ORGANIZATION_ID = :organizationId
              ORDER BY ITEM_CODE, LINE_TYPE, ORGANIZATION_ID
           ) LOOP
             EXIT WHEN v_remain <= 0;
             v_pool := g.QTY;
             v_rowid := g.RID;
             IF v_remain > v_pool THEN
               v_remain := v_remain - v_pool;
               v_applied := v_applied + v_pool;
               UPDATE IM_ITEM_INVENTORY_GEN SET INVENTORY_QTY = 0 WHERE ROWID = v_rowid;
             ELSE
               v_applied := v_applied + v_remain;
               UPDATE IM_ITEM_INVENTORY_GEN
                  SET INVENTORY_QTY = v_pool - v_remain
                WHERE ROWID = v_rowid;
               v_remain := 0;
             END IF;
           END LOOP;

           -- 발주속성(최소주문량·포장단위·불량율) 적용. PB f_get_order_property 'A'.
           v_calc := v_remain;
           IF :applyOrderRule = 'Y' AND v_remain > 0 THEN
             BEGIN
               SELECT NVL(MIM_ORDER_QTY, 0), NVL(PACKING_QTY, 0), NVL(ORDER_BAD_RATE, 0)
                 INTO v_min_qty, v_pack_qty, v_bad_rate
                 FROM IM_ITEM_MASTER
                WHERE SUPPLIER_CODE = p.SUPPLIER_CODE
                  AND ITEM_CODE = p.ITEM_CODE
                  AND DATESET <= TRUNC(SYSDATE)
                  AND DATEEND >= TRUNC(SYSDATE)
                  AND ORGANIZATION_ID = :organizationId;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 v_min_qty := 0; v_pack_qty := 0; v_bad_rate := 0;
               WHEN TOO_MANY_ROWS THEN
                 v_min_qty := 0; v_pack_qty := 0; v_bad_rate := 0;
             END;

             IF v_bad_rate = 0 THEN
               v_bad_qty := 0;
             ELSE
               BEGIN
                 SELECT ITEM_UOM INTO v_uom FROM ID_ITEM
                  WHERE ITEM_CODE = p.ITEM_CODE
                    AND DATESET <= TRUNC(SYSDATE)
                    AND DATEEND >= TRUNC(SYSDATE)
                    AND ORGANIZATION_ID = :organizationId;
               EXCEPTION WHEN OTHERS THEN v_uom := NULL;
               END;
               -- 개수로 세는 단위는 소수점을 두지 않는다. PB 와 같은 자릿수다.
               IF v_uom IN ('EA', 'SET') THEN
                 v_bad_qty := ROUND(v_bad_rate * v_remain / 100, 0);
               ELSE
                 v_bad_qty := ROUND(v_bad_rate * v_remain / 100, 4);
               END IF;
             END IF;

             v_calc := v_remain + v_bad_qty;
             IF v_min_qty > 0 AND v_calc < v_min_qty THEN
               v_calc := v_min_qty;
             END IF;
             IF v_pack_qty > 0 THEN
               IF v_calc > v_pack_qty THEN
                 IF MOD(v_calc, v_pack_qty) > 0 THEN
                   v_calc := TRUNC(v_calc / v_pack_qty) * v_pack_qty + v_pack_qty;
                 END IF;
               ELSE
                 v_calc := v_pack_qty;
               END IF;
             END IF;
           END IF;

           UPDATE IM_ITEM_PURCHASE_ORDER_PLAN
              SET ORDER_NO = CASE WHEN v_calc > 0
                                  THEN 'TA' || TO_CHAR(SYSDATE, 'YYMMDD') || SEQ_ORDER_NO.NEXTVAL
                                  ELSE ORDER_NO END,
                  INVENTORY_QTY = v_applied,
                  TOTAL_INVENTORY_QTY = v_applied,
                  PURCHASE_ORDER_QTY = v_calc
            WHERE ROWID = p.RID;
         END LOOP;

         -- 단가·납품구분·통화를 단가 기준정보에서 한 번에 붙인다 (PB cb_price_reset).
         -- 금액 컬럼은 이 표에 없다 — 화면이 단가 x 수량으로 보여 준다.
         IF :applyUnitPrice = 'Y' THEN
           UPDATE IM_ITEM_PURCHASE_ORDER_PLAN A
              SET (A.DELIVERY, A.UNIT_PRICE, A.CURRENCY) =
                  (SELECT B.DELIVERY, B.UNIT_PRICE, B.CURRENCY
                     FROM IM_ITEM_UNIT_PRICE B
                    WHERE A.SUPPLIER_CODE = B.SUPPLIER_CODE
                      AND A.ITEM_CODE = B.ITEM_CODE
                      AND A.LINE_TYPE = B.LINE_TYPE
                      AND B.DATESET <= TRUNC(SYSDATE)
                      AND B.DATEEND >= TRUNC(SYSDATE)
                      AND A.ORGANIZATION_ID = B.ORGANIZATION_ID)
            WHERE A.ORGANIZATION_ID = :organizationId
              AND (A.SUPPLIER_CODE, A.ITEM_CODE, A.LINE_TYPE, A.ORGANIZATION_ID) IN
                  (SELECT B.SUPPLIER_CODE, B.ITEM_CODE, B.LINE_TYPE, B.ORGANIZATION_ID
                     FROM IM_ITEM_UNIT_PRICE B
                    WHERE B.DATESET <= TRUNC(SYSDATE)
                      AND B.DATEEND >= TRUNC(SYSDATE)
                      AND B.ORGANIZATION_ID = :organizationId);
         END IF;

         -- 리드타임을 켜면 납기를 뒤로 민다 (F_GET_DELIVERY_DATE, DB 함수).
         IF :applyLeadTime = 'Y' THEN
           UPDATE IM_ITEM_PURCHASE_ORDER_PLAN
              SET DELIVERY_DATE = F_GET_DELIVERY_DATE(ITEM_CODE, SUPPLIER_CODE,
                                                      DELIVERY_DATE, ORGANIZATION_ID)
            WHERE ORGANIZATION_ID = :organizationId;
         END IF;
       END;`,
      {
        organizationId,
        userId,
        orderDate: dto.orderDate,
        applyOrderRule: dto.applyOrderRule ? 'Y' : 'N',
        applyUnitPrice: dto.applyUnitPrice ? 'Y' : 'N',
        applyLeadTime: dto.applyLeadTime ? 'Y' : 'N',
      } as unknown as unknown[],
    );
  }

  // ─────────────────────────────── 단가 재설정 (cb_price_reset)

  /** 기준정보 단가를 계획에 다시 붙이고 금액을 다시 센다. */
  async resetPrice(
    dto: PriceResetDto,
    organizationId: number,
  ): Promise<{ updated: number }> {
    return this.dataSource.transaction(async (manager) => {
      const binds: Record<string, unknown> = { organizationId };
      let filter = '';
      if (dto.supplierCode) {
        filter = ' AND A.SUPPLIER_CODE = :supplierCode';
        binds.supplierCode = dto.supplierCode;
      }
      const result = await manager.query(
        `UPDATE IM_ITEM_PURCHASE_ORDER_PLAN A
            SET (A.DELIVERY, A.UNIT_PRICE, A.CURRENCY) =
                (SELECT B.DELIVERY, B.UNIT_PRICE, B.CURRENCY
                   FROM IM_ITEM_UNIT_PRICE B
                  WHERE A.SUPPLIER_CODE = B.SUPPLIER_CODE
                    AND A.ITEM_CODE = B.ITEM_CODE
                    AND A.LINE_TYPE = B.LINE_TYPE
                    AND B.DATESET <= TRUNC(SYSDATE)
                    AND B.DATEEND >= TRUNC(SYSDATE)
                    AND A.ORGANIZATION_ID = B.ORGANIZATION_ID)
          WHERE A.ORGANIZATION_ID = :organizationId${filter}
            AND (A.SUPPLIER_CODE, A.ITEM_CODE, A.LINE_TYPE, A.ORGANIZATION_ID) IN
                (SELECT B.SUPPLIER_CODE, B.ITEM_CODE, B.LINE_TYPE, B.ORGANIZATION_ID
                   FROM IM_ITEM_UNIT_PRICE B
                  WHERE B.DATESET <= TRUNC(SYSDATE)
                    AND B.DATEEND >= TRUNC(SYSDATE)
                    AND B.ORGANIZATION_ID = :organizationId)`,
        binds as unknown as unknown[],
      );
      return {
        updated: Number((result as { rowsAffected?: number })?.rowsAffected ?? 0),
      };
    });
  }

  // ─────────────────────────────── 발주 확정 (cb_purchase_po / cb_purchase_do)

  /**
   * 발주계획을 실제 주문으로 넘긴다.
   *
   * PB 는 고른 줄마다 주문번호를 채번해 한 건씩 INSERT 했다. 웹도 같은 순서를
   * 지키되, 넘어간 계획은 다시 넘어가지 않도록 **계획에서 지운다** (PB 동작).
   */
  async purchase(
    dto: OrderPlanPurchaseDto,
    organizationId: number,
    userId: string,
  ): Promise<{ created: number }> {
    if (dto.itemCodes.length === 0) return { created: 0 };

    return this.dataSource.transaction(async (manager) => {
      let created = 0;
      for (const key of dto.itemCodes) {
        const result = await manager.query(
          `INSERT INTO IM_ITEM_PURCHASE_ORDER
             (ORDER_NO, PURCHASE_ORDER_DATE, ORGANIZATION_ID, SUPPLIER_CODE, ITEM_CODE,
              DELIVERY_DATE, LINE_TYPE, ORDER_QTY, UNIT_PRICE, ORDER_AMT,
              ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
           SELECT TO_CHAR(A.ORGANIZATION_ID) || TO_CHAR(SYSDATE, 'YYMMDD')
                    || SEQ_PURCHASE_ORDER_NO.NEXTVAL,
                  TRUNC(TO_DATE(:orderDate, 'YYYY-MM-DD')),
                  A.ORGANIZATION_ID, NVL(A.SUPPLIER_CODE, '*'), A.ITEM_CODE,
                  A.DELIVERY_DATE, A.LINE_TYPE, A.PURCHASE_ORDER_QTY,
                  A.UNIT_PRICE, A.ORDER_AMT,
                  :userId, SYSDATE, :userId, SYSDATE
             FROM IM_ITEM_PURCHASE_ORDER_PLAN A
            WHERE A.ORGANIZATION_ID = :organizationId
              AND A.ITEM_CODE = :itemCode
              AND A.LINE_TYPE = :lineType
              AND NVL(A.PURCHASE_ORDER_QTY, 0) > 0`,
          {
            orderDate: dto.orderDate,
            userId,
            organizationId,
            itemCode: key.itemCode,
            lineType: key.lineType,
          } as unknown as unknown[],
        );
        const affected = Number(
          (result as { rowsAffected?: number })?.rowsAffected ?? 0,
        );
        created += affected;
        if (affected > 0) {
          await manager.query(
            `DELETE FROM IM_ITEM_PURCHASE_ORDER_PLAN
              WHERE ORGANIZATION_ID = :organizationId
                AND ITEM_CODE = :itemCode
                AND LINE_TYPE = :lineType`,
            {
              organizationId,
              itemCode: key.itemCode,
              lineType: key.lineType,
            } as unknown as unknown[],
          );
        }
      }
      return { created };
    });
  }

  // ─────────────────────────────── 보조

  private page<T>(rows: T[]): Paged<T> {
    const truncated = rows.length > ROW_LIMIT;
    const data = truncated ? rows.slice(0, ROW_LIMIT) : rows;
    return { data, total: data.length, truncated };
  }
}

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
 *      (PB Generate PO — 주문유형 F, 단가 기준정보가 없으면 상태 P 로 확정에서 뺀다)
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
import { affectedRows } from '../../common/utils/affected-rows.util';
import {
  ITEM_LINE_TYPE_SQL,
  LEAF_ONLY_SQL,
  SKIPPED_ASSIGN_SQL,
  SKIPPED_DECLARE_SQL,
  parseSkipped,
  skipNoBomSql,
  skippedOutBind,
} from './bom-requirement.sql';

/**
 * 계획 원천. PB 는 라디오버튼으로 골랐고 각각 전용 PB 함수를 불렀다
 * (`f_gen_purchase_order_plan_by_*`). 다섯의 차이는 **커서 원천뿐**이라
 * 여기서는 SELECT 문 하나씩만 둔다.
 *
 * `byTime` 계열은 계획일에 시:분을 붙여 같은 날 안에서도 순서를 가른다.
 */
const PLAN_SOURCES = {
  /** 수기로 넣은 발주 기준계획. 소요전개 기준일은 원천 값을 그대로 쓴다. */
  manual: {
    label: '수기계획',
    explodeAll: false,
    sql: `SELECT ITEM_CODE, PLAN_DATE, ORDER_QTY AS QTY, '*' AS MFS,
                 REQUIRMENT_PLAN_DATE AS REQ_DATE
            FROM IM_ITEM_MASTER_PLAN_4_PO
           WHERE TRUNC(PLAN_DATE) BETWEEN v_from AND v_to
             AND ITEM_CODE LIKE v_item
             AND ORGANIZATION_ID = :organizationId`,
  },
  /** 생산계획(MI). 남은 수량 = 계획 - 실적. MFS 에 작업지시번호를 남긴다. */
  productionPlan: {
    label: '생산계획',
    explodeAll: false,
    sql: `SELECT ITEM_CODE, PLAN_DATE, PLAN_QTY - NVL(ACTUAL_QTY, 0) AS QTY,
                 NVL(WORK_ORDER_NO, '*') AS MFS, TRUNC(SYSDATE) AS REQ_DATE
            FROM IP_PRODUCT_MI_PLAN
           WHERE TRUNC(PLAN_DATE) BETWEEN v_from AND v_to
             AND NVL(PLAN_QTY, 0) - NVL(ACTUAL_QTY, 0) > 0
             AND ITEM_CODE LIKE v_item
             AND ORGANIZATION_ID = :organizationId`,
  },
  /** 생산계획을 시간까지 나눠 본다 (PLAN_PRIORITY 3~7자리가 HHMI). */
  productionPlanByTime: {
    label: '생산계획(시간별)',
    explodeAll: false,
    sql: `SELECT ITEM_CODE,
                 TO_DATE(TO_CHAR(PLAN_DATE, 'YYYYMMDD') || ' '
                         || SUBSTR(PLAN_PRIORITY, 3, 5), 'YYYYMMDD HH24:MI') AS PLAN_DATE,
                 PLAN_QTY - NVL(ACTUAL_QTY, 0) AS QTY,
                 NVL(WORK_ORDER_NO, '*') AS MFS, TRUNC(SYSDATE) AS REQ_DATE
            FROM IP_PRODUCT_MI_PLAN
           WHERE TRUNC(PLAN_DATE) BETWEEN v_from AND v_to
             AND NVL(PLAN_QTY, 0) - NVL(ACTUAL_QTY, 0) > 0
             AND ITEM_CODE LIKE v_item
             AND ORGANIZATION_ID = :organizationId`,
  },
  /** 납품계획. 남은 수량에서 지시번호로 잡힌 실적까지 뺀다. */
  salePlan: {
    label: '납품계획',
    explodeAll: false,
    sql: `SELECT ITEM_CODE, PLAN_DATE,
                 PLAN_QTY - (NVL(ACTUAL_QTY, 0)
                   + F_GET_PLAN_ACTUAL_QTY_BY_ONO(WORK_ORDER_NO, ORGANIZATION_ID)) AS QTY,
                 NVL(WORK_ORDER_NO, '*') AS MFS, TRUNC(SYSDATE) AS REQ_DATE
            FROM IP_PRODUCT_DELIVERY_PLAN
           WHERE TRUNC(PLAN_DATE) BETWEEN v_from AND v_to
             AND NVL(PLAN_QTY, 0) - NVL(ACTUAL_QTY, 0) > 0
             AND ITEM_CODE LIKE v_item
             AND ORGANIZATION_ID = :organizationId`,
  },
  /**
   * 납품계획(시간별). 은성 설정(SALE_UPLOAD_DIVISION=SAMSUNG)에서 PB 가 실제로 쓰던 경로다.
   * 전개는 반제품 전개여부와 관계없이 전 단계를 편다 (`BOM_EXPLOSION_ALL`).
   * 발주규칙 E(PO제외) 제품은 뺀다.
   */
  salePlanByTime: {
    label: '납품계획(시간별)',
    explodeAll: true,
    sql: `SELECT ITEM_CODE,
                 TO_DATE(TO_CHAR(PLAN_DATE, 'YYYYMMDD') || ' '
                         || PLAN_PRIORITY, 'YYYYMMDD HH24:MI:SS') AS PLAN_DATE,
                 PLAN_QTY - NVL(ACTUAL_QTY, 0) AS QTY,
                 NVL(WORK_ORDER_NO, '*') AS MFS, TRUNC(SYSDATE) AS REQ_DATE
            FROM IP_PRODUCT_DELIVERY_PLAN
           WHERE TRUNC(PLAN_DATE) BETWEEN v_from AND v_to
             AND NVL(PLAN_QTY, 0) - NVL(ACTUAL_QTY, 0) > 0
             AND ITEM_CODE LIKE v_item
             AND ITEM_CODE NOT IN (SELECT ITEM_CODE FROM ID_ITEM
                                    WHERE ORDER_RULE = 'E'
                                      AND ORGANIZATION_ID = :organizationId)
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

/**
 * 발주계획 대상 품목. 발주속성 적용(PB Auto Order Rule)을 켜면 `:orderRule` 이 'A%'
 * (발주규칙 A=자동), 끄면 '%' (전 품목)이다.
 */
const ORDER_RULE_ITEMS_SQL = `SELECT ITEM_CODE FROM ID_ITEM
                 WHERE DATESET <= TRUNC(SYSDATE)
                   AND DATEEND >= TRUNC(SYSDATE)
                   AND NVL(ORDER_RULE, '*') LIKE :orderRule
                   AND ORGANIZATION_ID = :organizationId`;

/**
 * 품목별 발주 공급처와 발주비율 (`IM_ITEM_MASTER`, 비율 0 초과 100 이하).
 * 비율이 나뉘어 있으면(예: 60/40) 공급처마다 그 비율로 나눠 발주한다.
 * 비율 100 이 둘 이상이면 같은 수량이 공급처마다 통째로 발주되므로, 주거래선
 * 한 곳만 남긴다 (사용자 결정 2026-10-02). 은성 데이터는 MAIN_VENDOR_YN 이 전부
 * Y 라 그 컬럼으로는 가릴 수 없어, 아래 순서로 고른다:
 *   1. 품목 기준정보 공급처(ID_ITEM.SUPPLIER_CODE)와 같은 공급처
 *   2. 단가 기준정보가 등록된 공급처
 *   3. 공급처코드 순
 */
const ORDER_SUPPLIER_SQL = `SELECT ITEM_CODE, ORGANIZATION_ID, SUPPLIER_CODE, ORDER_RATE, PAYMENT_TYPE
  FROM (
    SELECT M.ITEM_CODE, M.ORGANIZATION_ID, M.SUPPLIER_CODE, M.ORDER_RATE, M.PAYMENT_TYPE,
           ROW_NUMBER() OVER (
             PARTITION BY M.ITEM_CODE, M.ORGANIZATION_ID,
                          DECODE(M.ORDER_RATE, 100, '*', M.SUPPLIER_CODE)
             ORDER BY CASE WHEN M.SUPPLIER_CODE = (SELECT MAX(I.SUPPLIER_CODE) FROM ID_ITEM I
                                                    WHERE I.ITEM_CODE = M.ITEM_CODE
                                                      AND I.ORGANIZATION_ID = M.ORGANIZATION_ID)
                           THEN 0 ELSE 1 END,
                      CASE WHEN EXISTS (SELECT 'X' FROM IM_ITEM_UNIT_PRICE P
                                         WHERE P.SUPPLIER_CODE = M.SUPPLIER_CODE
                                           AND P.ITEM_CODE = M.ITEM_CODE
                                           AND P.ORGANIZATION_ID = M.ORGANIZATION_ID
                                           AND P.DATESET <= TRUNC(SYSDATE)
                                           AND P.DATEEND >= TRUNC(SYSDATE))
                           THEN 0 ELSE 1 END,
                      M.SUPPLIER_CODE) AS RN
      FROM IM_ITEM_MASTER M
     WHERE M.ORDER_RATE > 0
       AND M.ORDER_RATE <= 100
       AND M.DATESET <= TRUNC(SYSDATE)
       AND M.DATEEND >= TRUNC(SYSDATE)
       AND M.ORGANIZATION_ID = :organizationId)
 WHERE RN = 1`;

/**
 * 단가 재설정 (PB cb_price_reset). PL/SQL 블록 안에 넣는다. `filter` 는 별칭 A 조건.
 *   1. 단가가 안 붙은 계획(납품구분 없음)과 공급처 미지정(*) 계획은 상태 P — 확정에서 빠진다.
 *      공급처가 * 이면 단가표에 * 단가가 있어도 붙이지 않는다 (거래처를 모른다).
 *   2. 공급처·품목·거래유형이 맞는 단가를 붙인다 (단가 0 도 등록이면 붙는다).
 *   3. 아직 P 인데 공급처·품목으로는 단가가 있으면 그 거래유형으로 맞춰 다시 붙인다.
 *   4. 납품구분이 생긴 P 는 N 으로 돌린다.
 */
const priceResetSql = (filter: string) => `
  UPDATE IM_ITEM_PURCHASE_ORDER_PLAN A
     SET A.PURCHASE_ORDER_STATUS = 'P',
         A.DELIVERY = DECODE(A.SUPPLIER_CODE, '*', NULL, A.DELIVERY)
   WHERE A.PURCHASE_ORDER_STATUS = 'N'
     AND (A.DELIVERY IS NULL OR A.SUPPLIER_CODE = '*')
     AND A.ORGANIZATION_ID = :organizationId${filter};

  UPDATE IM_ITEM_PURCHASE_ORDER_PLAN A
     SET A.LINE_TYPE = (SELECT MIN(B.LINE_TYPE) FROM IM_ITEM_UNIT_PRICE B
                         WHERE B.SUPPLIER_CODE = A.SUPPLIER_CODE
                           AND B.ITEM_CODE = A.ITEM_CODE
                           AND B.DATESET <= TRUNC(SYSDATE)
                           AND B.DATEEND >= TRUNC(SYSDATE)
                           AND B.ORGANIZATION_ID = A.ORGANIZATION_ID)
   WHERE A.PURCHASE_ORDER_STATUS = 'P'
     AND A.SUPPLIER_CODE <> '*'
     AND A.ORGANIZATION_ID = :organizationId${filter}
     AND NOT EXISTS (SELECT 'X' FROM IM_ITEM_UNIT_PRICE B
                      WHERE B.SUPPLIER_CODE = A.SUPPLIER_CODE
                        AND B.ITEM_CODE = A.ITEM_CODE
                        AND B.LINE_TYPE = A.LINE_TYPE
                        AND B.DATESET <= TRUNC(SYSDATE)
                        AND B.DATEEND >= TRUNC(SYSDATE)
                        AND B.ORGANIZATION_ID = A.ORGANIZATION_ID)
     AND EXISTS (SELECT 'X' FROM IM_ITEM_UNIT_PRICE B
                  WHERE B.SUPPLIER_CODE = A.SUPPLIER_CODE
                    AND B.ITEM_CODE = A.ITEM_CODE
                    AND B.DATESET <= TRUNC(SYSDATE)
                    AND B.DATEEND >= TRUNC(SYSDATE)
                    AND B.ORGANIZATION_ID = A.ORGANIZATION_ID);

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
   WHERE A.ORGANIZATION_ID = :organizationId${filter}
     AND NVL(A.PURCHASE_ORDER_STATUS, 'N') <> 'Y'
     AND A.SUPPLIER_CODE <> '*'
     AND (A.SUPPLIER_CODE, A.ITEM_CODE, A.LINE_TYPE, A.ORGANIZATION_ID) IN
         (SELECT B.SUPPLIER_CODE, B.ITEM_CODE, B.LINE_TYPE, B.ORGANIZATION_ID
            FROM IM_ITEM_UNIT_PRICE B
           WHERE B.DATESET <= TRUNC(SYSDATE)
             AND B.DATEEND >= TRUNC(SYSDATE)
             AND B.ORGANIZATION_ID = :organizationId);

  UPDATE IM_ITEM_PURCHASE_ORDER_PLAN A
     SET A.PURCHASE_ORDER_STATUS = 'N'
   WHERE A.PURCHASE_ORDER_STATUS = 'P'
     AND A.DELIVERY IS NOT NULL
     AND A.ORGANIZATION_ID = :organizationId${filter};`;


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
    // 아직 발주할 것만: 수량이 남아 있고 확정되지 않은 계획.
    // 확정하면 계획을 지우지 않고 상태만 'Y' 가 되므로 상태도 같이 걸러야 한다.
    if (query.pendingOnly) {
      filter += " AND NVL(A.PURCHASE_ORDER_QTY, 0) > 0"
        + " AND NVL(A.PURCHASE_ORDER_STATUS, 'N') <> 'Y'";
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
                TO_CHAR(A.PURCHASE_ORDER_DATE, 'YYYY-MM-DD')  AS "purchaseOrderDate",
                -- 시간별 원천이면 계획일(=납기)에 시:분이 붙는다. 자정이면 날짜만.
                CASE WHEN A.DELIVERY_DATE = TRUNC(A.DELIVERY_DATE)
                     THEN TO_CHAR(A.DELIVERY_DATE, 'YYYY-MM-DD')
                     ELSE TO_CHAR(A.DELIVERY_DATE, 'YYYY-MM-DD HH24:MI') END AS "deliveryDate",
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
                TO_CHAR(A.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')           AS "enterDate"
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
         SELECT TO_CHAR(A.REQUIRMENT_PLAN_DATE, 'YYYY-MM-DD') AS "requirementPlanDate",
                CASE WHEN A.PLAN_DATE = TRUNC(A.PLAN_DATE)
                     THEN TO_CHAR(A.PLAN_DATE, 'YYYY-MM-DD')
                     ELSE TO_CHAR(A.PLAN_DATE, 'YYYY-MM-DD HH24:MI') END AS "planDate",
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
   * BOM 이 없는 계획은 그 줄만 건너뛰고 나머지로 만든다. 건너뛴 품목은 `skippedItems` 로 돌려준다.
   */
  async generate(
    dto: OrderPlanGenerateDto,
    organizationId: number,
    userId: string,
  ): Promise<{ requirementRows: number; planRows: number; skippedItems: string[] }> {
    const source = PLAN_SOURCES[dto.source as PlanSource];
    if (!source) throw new BadRequestException('계획 원천이 올바르지 않습니다.');

    const arms = (dto.inventorySources ?? []).filter(
      (name): name is InventoryArm => name in INVENTORY_ARMS,
    );
    const explode = source.explodeAll ? 'PKG_DESIGN.BOM_EXPLOSION_ALL' : 'PKG_DESIGN.BOM_EXPLOSION';

    return this.dataSource.transaction(async (manager) => {
      // ① 계획을 BOM 으로 펴서 소요량을 만든다.
      const out = await manager.query(
        `DECLARE
           v_from        DATE := TRUNC(TO_DATE(:dateFrom, 'YYYY-MM-DD'));
           v_to          DATE := TRUNC(TO_DATE(:dateTo, 'YYYY-MM-DD'));
           v_item        VARCHAR2(100) := :itemPattern;
           v_req_session NUMBER;
           v_bom_session NUMBER;
           ${SKIPPED_DECLARE_SQL}
         BEGIN
           v_req_session := SEQ_REQUIRMENT_PLAN.NEXTVAL;

           FOR c IN (${source.sql}) LOOP
             IF c.QTY IS NULL THEN
               RAISE_APPLICATION_ERROR(-20010, 'QTY_NULL:' || c.ITEM_CODE);
             END IF;

             v_bom_session := ${explode}(c.ITEM_CODE, c.PLAN_DATE, :organizationId);
             ${skipNoBomSql('c.ITEM_CODE')}

             -- MFS 에 작업지시번호, SET_ITEM_CODE 에 계획 제품을 남긴다 (PB 와 같다).
             INSERT INTO IM_ITEM_REQUIRMENT_PLAN_TEMP
               (SESSION_ID, REQUIRMENT_PLAN_DATE, MFS, ITEM_CODE, LINE_TYPE, SUPPLIER_CODE,
                ORGANIZATION_ID, PLAN_DATE, REQUIRMENT_QTY, ENTER_BY, ENTER_DATE,
                LAST_MODIFY_BY, LAST_MODIFY_DATE, SET_ITEM_CODE, PARENT_ITEM_CODE)
             SELECT v_req_session, c.REQ_DATE, c.MFS, T.CHILD_ITEM_CODE,
                    ${ITEM_LINE_TYPE_SQL}, '*',
                    T.ORGANIZATION_ID, c.PLAN_DATE, NVL(T.MODEL_UNIT_QTY, 0) * c.QTY,
                    :userId, SYSDATE, :userId, SYSDATE, c.ITEM_CODE, T.PARENT_ITEM_CODE
               FROM ID_ENG_BOM_TEMP T
              WHERE T.SESSION_ID = v_bom_session
                -- PB 는 LINE_TYPE NOT IN ('A','T') 로 걸렀다. 구매구분은 보지 않는다.
                AND ${LEAF_ONLY_SQL};

             DELETE FROM ID_ENG_BOM_TEMP WHERE SESSION_ID = v_bom_session;
           END LOOP;

           -- 소요량은 조직 단위로 통째로 갈아끼운다. PB 도 그렇게 한다.
           DELETE FROM IM_ITEM_PURCHASE_REQUIR_ORDER
            WHERE ORGANIZATION_ID = :organizationId;

           INSERT INTO IM_ITEM_PURCHASE_REQUIR_ORDER
             (REQUIRMENT_PLAN_DATE, MFS, ITEM_CODE, SUPPLIER_CODE, ORGANIZATION_ID,
              PLAN_DATE, REQUIRMENT_QTY, LINE_TYPE, ENTER_BY, ENTER_DATE,
              LAST_MODIFY_BY, LAST_MODIFY_DATE, SET_ITEM_CODE, PARENT_ITEM_CODE)
           SELECT REQUIRMENT_PLAN_DATE, MFS, ITEM_CODE,
                  F_GET_MAX_SUPPLIER_BY_ITEM(ITEM_CODE, ORGANIZATION_ID),
                  ORGANIZATION_ID, PLAN_DATE, SUM(REQUIRMENT_QTY), LINE_TYPE,
                  MAX(ENTER_BY), MAX(ENTER_DATE), MAX(LAST_MODIFY_BY), MAX(LAST_MODIFY_DATE),
                  MAX(SET_ITEM_CODE), MAX(PARENT_ITEM_CODE)
             FROM IM_ITEM_REQUIRMENT_PLAN_TEMP
            WHERE SESSION_ID = v_req_session
            GROUP BY REQUIRMENT_PLAN_DATE, MFS, ITEM_CODE, LINE_TYPE, SUPPLIER_CODE,
                     ORGANIZATION_ID, PLAN_DATE;

           DELETE FROM IM_ITEM_REQUIRMENT_PLAN_TEMP WHERE SESSION_ID = v_req_session;
           ${SKIPPED_ASSIGN_SQL}
         END;`,
        {
          dateFrom: dto.dateFrom,
          dateTo: dto.dateTo,
          itemPattern: dto.itemCode ? `%${dto.itemCode}%` : '%',
          organizationId,
          userId,
          skipped: skippedOutBind(),
        } as unknown as unknown[],
      ).catch((error: unknown) => {
        const message = error instanceof Error ? error.message : String(error);
        const qtyNull = /QTY_NULL:(\S+)/.exec(message);
        if (qtyNull) {
          throw new BadRequestException(
            `${qtyNull[1]} 의 계획수량이 비어 있습니다. 계획을 먼저 확인하세요.`,
          );
        }
        throw error;
      });

      // ② 발주잔량·도착분을 모으고, ③ 켜진 재고 가지를 합친다.
      await this.buildGenTables(manager, organizationId, arms);

      // ④ 소요량에서 차감해 발주계획을 만들고, ⑤ 단가를 붙인다.
      await this.netRequirements(manager, organizationId, dto, userId, arms.length > 0);
      await manager.query(
        `BEGIN ${priceResetSql('')} END;`,
        { organizationId } as unknown as unknown[],
      );

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
      return {
        requirementRows: Number(REQ),
        planRows: Number(PLN),
        skippedItems: parseSkipped(out),
      };
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
   * 소요량에서 재고를 차감해 발주계획을 만든다 (PB cb_gen_po).
   *
   * - 대상 품목: 발주속성 적용(Auto Order Rule)을 켜면 발주규칙 A(자동) 품목만, 끄면 전 품목.
   * - 같은 품목·거래유형을 한 줄로 합칠지(Distinct MFS)는 옵션이다. 합치면 납기는 가장 이른 날.
   * - 차감은 순서가 결과를 바꾸므로 PB 와 같은 순회를 유지한다 (품목·거래유형·납기).
   *   재고 가지를 하나도 안 켜면 차감도 발주속성도 건너뛴다 (PB: Apply Inventory 끔).
   * - `F_GET_ORDER_PROPERTY` 는 DB 에 없는 PB 함수라 블록 안에 그대로 옮겼다.
   * - 납품구분·단가는 비워 두고, 끝에서 단가 재설정({@link priceResetSql})이 채운다.
   */
  private async netRequirements(
    manager: { query: (sql: string, binds?: unknown[]) => Promise<unknown> },
    organizationId: number,
    dto: OrderPlanGenerateDto,
    userId: string,
    applyInventory: boolean,
  ): Promise<void> {
    const reqGroup = dto.distinctMfs
      ? `SELECT ORGANIZATION_ID, ITEM_CODE, MIN(PLAN_DATE) AS DELIVERY_DATE, LINE_TYPE,
                SUM(REQUIRMENT_QTY) AS ORDER_QTY, '*' AS MFS,
                MAX(SET_ITEM_CODE) AS SET_ITEM_CODE, MAX(PARENT_ITEM_CODE) AS PARENT_ITEM_CODE
           FROM IM_ITEM_PURCHASE_REQUIR_ORDER
          WHERE ORGANIZATION_ID = :organizationId
            AND ITEM_CODE IN (${ORDER_RULE_ITEMS_SQL})
          GROUP BY ITEM_CODE, LINE_TYPE, ORGANIZATION_ID`
      : `SELECT ORGANIZATION_ID, ITEM_CODE, PLAN_DATE AS DELIVERY_DATE, LINE_TYPE,
                SUM(REQUIRMENT_QTY) AS ORDER_QTY, MFS,
                MAX(SET_ITEM_CODE) AS SET_ITEM_CODE, MAX(PARENT_ITEM_CODE) AS PARENT_ITEM_CODE
           FROM IM_ITEM_PURCHASE_REQUIR_ORDER
          WHERE ORGANIZATION_ID = :organizationId
            AND ITEM_CODE IN (${ORDER_RULE_ITEMS_SQL})
          GROUP BY MFS, PLAN_DATE, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID`;

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
         v_surplus   NUMBER;
       BEGIN
         DELETE FROM IM_ITEM_PURCHASE_ORDER_PLAN WHERE ORGANIZATION_ID = :organizationId;

         -- 소요량의 계획일이 곧 납기가 되고, 주문량은 협력사별 발주비율로 나뉜다.
         -- 주문유형 F, 납품구분은 비워 둔다 — 단가 재설정이 단가 기준정보에서 채운다.
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
                A.DELIVERY_DATE, NULL, A.LINE_TYPE, 'F',
                DECODE(B.ORDER_RATE, NULL, A.ORDER_QTY, A.ORDER_QTY * B.ORDER_RATE / 100),
                DECODE(B.ORDER_RATE, NULL, A.ORDER_QTY, A.ORDER_QTY * B.ORDER_RATE / 100),
                0, '*', 0, 0, 0, A.MFS, 'N', NVL(B.PAYMENT_TYPE, '*'),
                :userId, SYSDATE, :userId, SYSDATE,
                A.SET_ITEM_CODE, A.PARENT_ITEM_CODE
           FROM (${reqGroup}) A
           LEFT JOIN (${ORDER_SUPPLIER_SQL}) B
             ON A.ITEM_CODE = B.ITEM_CODE
            AND A.ORGANIZATION_ID = B.ORGANIZATION_ID;

         IF :applyInventory = 'Y' THEN
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
           -- 소요량이 0 이하인 줄은 발주하지 않는다 (PB 도 0 으로 둔다).
           IF v_calc < 0 THEN
             v_calc := 0;
           END IF;

           -- 최소주문량·포장단위로 올린 만큼은 남는 물량이다. 재고 풀에 다시 써 넣어,
           -- 같은 자재의 뒤 계획줄이 그만큼 덜 발주하게 한다. PB 는 재고 행이 없는
           -- 자재에서 이 물량을 버려 줄마다 올림이 반복됐다 — 웹은 행을 만들어 남긴다.
           v_surplus := v_calc - v_remain;
           IF v_remain > 0 AND v_surplus > 0 THEN
             UPDATE IM_ITEM_INVENTORY_GEN
                SET INVENTORY_QTY = NVL(INVENTORY_QTY, 0) + v_surplus
              WHERE ITEM_CODE = p.ITEM_CODE
                AND LINE_TYPE = p.LINE_TYPE
                AND ORGANIZATION_ID = :organizationId
                AND ROWNUM = 1;
             IF SQL%ROWCOUNT = 0 THEN
               INSERT INTO IM_ITEM_INVENTORY_GEN
                 (ITEM_CODE, LINE_TYPE, ORGANIZATION_ID, INVENTORY_QTY, PURCHASE_ORDER_QTY)
               VALUES (p.ITEM_CODE, p.LINE_TYPE, :organizationId, v_surplus, 0);
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
         END IF;

         -- 리드타임은 납기를 **앞으로 당긴다**. 자재가 생산 시작 전에 들어와야 하므로
         -- 제조 리드타임만큼 먼저 받는다 (PB: DELIVERY_DATE - MANUFACTURE_LEADTIME).
         IF :applyLeadTime = 'Y' THEN
           UPDATE IM_ITEM_PURCHASE_ORDER_PLAN A
              SET A.DELIVERY_DATE = A.DELIVERY_DATE -
                  (SELECT NVL(B.MANUFACTURE_LEADTIME, 0) FROM ID_ITEM B
                    WHERE B.ITEM_CODE = A.ITEM_CODE
                      AND B.ORGANIZATION_ID = A.ORGANIZATION_ID
                      AND B.DATESET <= TRUNC(SYSDATE)
                      AND B.DATEEND >= TRUNC(SYSDATE))
            WHERE A.ORGANIZATION_ID = :organizationId
              AND EXISTS (SELECT 'X' FROM ID_ITEM B
                           WHERE B.ITEM_CODE = A.ITEM_CODE
                             AND B.ORGANIZATION_ID = A.ORGANIZATION_ID
                             AND B.DATESET <= TRUNC(SYSDATE)
                             AND B.DATEEND >= TRUNC(SYSDATE));
         END IF;

         -- 작업일 보정은 리드타임과 별개 단계다 (PB cbx_apply_calendar).
         -- 당긴 납기가 휴무일이면 일하는 날로 옮긴다. PB 와 같이 인자 두 개다.
         IF :applyCalendar = 'Y' THEN
           UPDATE IM_ITEM_PURCHASE_ORDER_PLAN
              SET DELIVERY_DATE = NVL(F_GET_DELIVERY_DATE(DELIVERY_DATE, ORGANIZATION_ID),
                                      PURCHASE_ORDER_DATE - 1)
            WHERE PURCHASE_ORDER_STATUS = 'N'
              AND ORGANIZATION_ID = :organizationId;
         END IF;

         -- 소수 4자리 반올림 (PB cbx_round).
         IF :roundQty = 'Y' THEN
           UPDATE IM_ITEM_PURCHASE_ORDER_PLAN
              SET PURCHASE_ORDER_QTY = ROUND(PURCHASE_ORDER_QTY, 4),
                  ORDER_QTY = ROUND(ORDER_QTY, 4)
            WHERE PURCHASE_ORDER_STATUS = 'N'
              AND ORGANIZATION_ID = :organizationId;
         END IF;
       END;`,
      {
        organizationId,
        userId,
        orderDate: dto.orderDate,
        orderRule: dto.applyOrderRule ? 'A%' : '%',
        applyInventory: applyInventory ? 'Y' : 'N',
        applyOrderRule: dto.applyOrderRule ? 'Y' : 'N',
        applyLeadTime: dto.applyLeadTime ? 'Y' : 'N',
        applyCalendar: dto.applyCalendar ? 'Y' : 'N',
        roundQty: dto.roundQty ? 'Y' : 'N',
      } as unknown as unknown[],
    );
  }

  // ─────────────────────────────── 단가 재설정 (cb_price_reset)

  /**
   * 단가 기준정보를 계획에 다시 붙인다. 생성 끝에서도 같은 문장을 돈다.
   * 단가가 0 이어도 등록돼 있으면 붙고 확정할 수 있다. 등록이 없으면 상태 P 로 남아
   * 확정되지 않는다 — 단가가 없다는 것은 거래처를 확정할 수 없다는 뜻이다.
   */
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
      await manager.query(`BEGIN ${priceResetSql(filter)} END;`, binds as unknown as unknown[]);
      const [{ CNT }] = await manager.query(
        `SELECT COUNT(*) AS CNT FROM IM_ITEM_PURCHASE_ORDER_PLAN A
          WHERE A.ORGANIZATION_ID = :organizationId${filter}
            AND A.DELIVERY IS NOT NULL`,
        binds as unknown as unknown[],
      );
      return { updated: Number(CNT) };
    });
  }

  // ─────────────────────────────── 발주 확정 (cb_purchase_po / cb_purchase_do)

  /**
   * 발주계획을 실제 주문으로 넘긴다.
   *
   * PB 원문과 맞춘 것 네 가지 — 처음 구현은 넷 다 어긋나 있었다:
   *
   * 1. **계획을 지우지 않는다.** `PURCHASE_ORDER_STATUS` 를 `'Y'` 로 바꿀 뿐이다.
   *    지우면 어느 계획에서 나온 주문인지 되짚을 수 없고, 다시 확정되는 것을
   *    막을 근거도 사라진다. 480 주문예정도 같은 이유로 기록을 남긴다.
   * 2. **주문번호는 계획이 이미 들고 있는 `ORDER_NO` 를 그대로 쓴다.** 생성 때
   *    `TA+YYMMDD+일련번호` 로 붙여 둔 값이다. 새로 채번하면 계획과 주문이 끊긴다.
   * 3. **`ORDER_GROUP_NO` 를 채운다** (`yyyymmdd` + 3자리 일련번호). 한 번의 확정이
   *    한 묶음이다. 481 자재주문관리가 이 값으로 발주그룹 합계를 낸다 — 비어 있으면
   *    그 화면의 그룹 집계가 나오지 않는다.
   * 4. **넘길 수 없는 계획을 막는다.** `DELIVERY` 가 채워진 것만 넘어간다.
   *    납품구분이 없으면 단가·통화가 안 붙은 계획이라는 뜻이다. PB 는 `LINE_TYPE <> 'T'`
   *    도 걸었지만 구매구분은 보지 않기로 해 뺐다 (bom-requirement.sql 참고).
   */
  async purchase(
    dto: OrderPlanPurchaseDto,
    organizationId: number,
    userId: string,
  ): Promise<{ created: number; skipped: number }> {
    if (dto.itemCodes.length === 0) return { created: 0, skipped: 0 };

    return this.dataSource.transaction(async (manager) => {
      // 이번 확정을 한 묶음으로 묶는 발주그룹 번호. PB 와 같은 형태다.
      const [{ GRP }] = await manager.query(
        `SELECT TO_CHAR(SYSDATE, 'YYYYMMDD')
                || TO_CHAR(SEQ_PURCHASE_ORDER_NO.NEXTVAL, 'FM000') AS GRP FROM DUAL`,
      );
      const orderGroupNo = String(GRP);

      let created = 0;
      let candidates = 0;
      for (const key of dto.itemCodes) {
        const binds = {
          orderGroupNo,
          orderDate: dto.orderDate,
          userId,
          organizationId,
          itemCode: key.itemCode,
          lineType: key.lineType,
        } as unknown as unknown[];

        const [{ CNT }] = await manager.query(
          `SELECT COUNT(*) AS CNT FROM IM_ITEM_PURCHASE_ORDER_PLAN
            WHERE ORGANIZATION_ID = :organizationId
              AND ITEM_CODE = :itemCode
              AND LINE_TYPE = :lineType
              AND NVL(PURCHASE_ORDER_STATUS, 'N') <> 'Y'
              AND NVL(PURCHASE_ORDER_QTY, 0) > 0`,
          { organizationId, itemCode: key.itemCode, lineType: key.lineType } as unknown as unknown[],
        );
        candidates += Number(CNT);

        const result = await manager.query(
          `INSERT INTO IM_ITEM_PURCHASE_ORDER
             (ORDER_NO, ORDER_GROUP_NO, ORGANIZATION_ID, PURCHASE_ORDER_DATE,
              SUPPLIER_CODE, ITEM_CODE, DELIVERY_DATE, DELIVERY, LINE_TYPE, ORDER_TYPE,
              ORDER_QTY, UNIT_PRICE, CURRENCY, ARRIVAL_QTY, MFS,
              ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
           SELECT ORDER_NO, :orderGroupNo, ORGANIZATION_ID,
                  TRUNC(TO_DATE(:orderDate, 'YYYY-MM-DD')),
                  NVL(SUPPLIER_CODE, '*'), ITEM_CODE, DELIVERY_DATE,
                  NVL(DELIVERY, '1'), LINE_TYPE, ORDER_TYPE,
                  PURCHASE_ORDER_QTY, UNIT_PRICE, CURRENCY, NVL(ARRIVAL_QTY, 0), MFS,
                  :userId, SYSDATE, :userId, SYSDATE
             FROM IM_ITEM_PURCHASE_ORDER_PLAN
            WHERE ORGANIZATION_ID = :organizationId
              AND ITEM_CODE = :itemCode
              AND LINE_TYPE = :lineType
              AND DELIVERY IS NOT NULL
              AND NVL(PURCHASE_ORDER_STATUS, 'N') <> 'Y'
              AND NVL(PURCHASE_ORDER_QTY, 0) > 0`,
          binds,
        );
        const affected = Number(
          (result as { rowsAffected?: number })?.rowsAffected ?? 0,
        );
        created += affected;

        if (affected > 0) {
          // 지우지 않고 확정 표시만 남긴다.
          await manager.query(
            `UPDATE IM_ITEM_PURCHASE_ORDER_PLAN
                SET PURCHASE_ORDER_STATUS = 'Y',
                    LAST_MODIFY_BY = :userId,
                    LAST_MODIFY_DATE = SYSDATE
              WHERE ORGANIZATION_ID = :organizationId
                AND ITEM_CODE = :itemCode
                AND LINE_TYPE = :lineType
                AND DELIVERY IS NOT NULL
                AND NVL(PURCHASE_ORDER_STATUS, 'N') <> 'Y'
                AND NVL(PURCHASE_ORDER_QTY, 0) > 0`,
            {
              userId,
              organizationId,
              itemCode: key.itemCode,
              lineType: key.lineType,
            } as unknown as unknown[],
          );
        }
      }
      // 납품구분이 없어 넘어가지 못한 계획 수.
      return { created, skipped: Math.max(candidates - created, 0) };
    });
  }

  // ─────────────────────────────── 보조

  private page<T>(rows: T[]): Paged<T> {
    const truncated = rows.length > ROW_LIMIT;
    const data = truncated ? rows.slice(0, ROW_LIMIT) : rows;
    return { data, total: data.length, truncated };
  }
}

/**
 * @file src/modules/purchase/order-plan.service.ts
 * @description 478 자재발주계획 — PB w_mat_purchase_order_plan_master 이식 (쓰기)
 *
 * 발주량 = (계획잔량 × BOM 누적수량) − 가용재고 → 발주속성 올림 → 공급처 비율 → 납기 보정 → 단가.
 * 옵션(계획 원천·뺄 재고·발주속성·합치기·리드타임·작업일·반올림)은 이 식의 각 항을 켜고 끈다.
 *
 * PB 는 작업 테이블(_TEMP·_GEN·REQUIR_ORDER)에 썼다 지우며 커서로 한 줄씩 돌았다.
 * 웹은 이렇게 나눈다:
 *   - 계산: SQL 한 문장(order-plan.sql.ts) + 순서가 결과를 바꾸는 차감·올림(order-plan.netting.ts)
 *   - 미리보기: 계산만 한다. 아무것도 쓰지 않는다.
 *   - 생성: 계산 결과로 소요량표·발주계획을 조직 단위로 갈아끼운다 (PB 와 같다).
 *   - 확정: 계획이 실제 주문(`IM_ITEM_PURCHASE_ORDER`)이 된다.
 * 단가 기준정보가 없거나 공급처가 * 인 계획은 상태 P — 확정되지 않는다.
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
import { clobBind } from '../../common/services/oracle.service';
import {
  ARM_COLUMNS,
  INVENTORY_ARMS,
  PLAN_SOURCES,
  nullQtySql,
  orderLinesSql,
  pickBinds,
  requirementCtes,
  skippedItemsSql,
  type InventoryArm,
  type PlanSource,
} from './order-plan.sql';
import { netOrderLines, roundHalfUp } from './order-plan.netting';

/** 발주 줄 — 미리보기와 저장이 같이 쓴다 */
export interface OrderPlanLine {
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  /** 저장되는 거래유형 (단가표에 맞춘 값) */
  lineType: string;
  /** 재고 차감에 쓴 거래유형 (품목 기준정보) */
  netLineType: string;
  supplierCode: string;
  supplierName: string | null;
  paymentType: string;
  orderRate: number | null;
  mfs: string;
  setItemCode: string | null;
  parentItemCode: string | null;
  /** 소요가 생긴 날 (보정 전 납기) */
  planDate: string;
  /** 리드타임·작업일 보정 후 납기 */
  deliveryDate: string;
  /** 비율 적용 전 소요량 */
  requirementQty: number;
  /** 비율 적용 후 소요량 */
  orderQty: number;
  invStock: number;
  invOrder: number;
  invArrival: number;
  invWorkstage: number;
  invFree: number;
  appliedQty: number;
  badQty: number;
  roundUpQty: number;
  purchaseQty: number;
  delivery: string | null;
  unitPrice: number;
  currency: string;
  status: 'N' | 'P';
  statusReason: string | null;
}

interface ComputeResult {
  lines: OrderPlanLine[];
  skippedItems: string[];
  binds: Record<string, unknown>;
  applyInventory: boolean;
}

type QueryRunnerLike = { query: (sql: string, binds?: unknown[]) => Promise<unknown> };

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

  // ─────────────────────────────── 발주량 계산 · 미리보기 · 생성 (cb_gen_po)

  /**
   * 발주량을 계산한다. **DB 에 아무것도 쓰지 않는다.**
   * SQL 한 문장이 계획 → BOM 전개 → 소요량 → 발주 줄(공급처·재고·속성·납기·단가)을 만들고,
   * 순서가 결과를 바꾸는 재고 차감·올림만 netOrderLines 가 한다.
   */
  private async compute(
    runner: QueryRunnerLike,
    dto: OrderPlanGenerateDto,
    organizationId: number,
  ): Promise<ComputeResult> {
    const source = dto.source as PlanSource;
    if (!PLAN_SOURCES[source]) throw new BadRequestException('계획 원천이 올바르지 않습니다.');
    const arms = (dto.inventorySources ?? []).filter(
      (name): name is InventoryArm => name in INVENTORY_ARMS,
    );
    const binds: Record<string, unknown> = {
      dateFrom: dto.dateFrom.slice(0, 10),
      dateTo: dto.dateTo.slice(0, 10),
      itemPattern: dto.itemCode ? `%${dto.itemCode}%` : '%',
      organizationId,
      orderRule: dto.applyOrderRule ? 'A%' : '%',
      orderDate: dto.orderDate.slice(0, 10),
    };
    const run = (sql: string) => runner.query(sql, pickBinds(sql, binds) as unknown as unknown[]);

    const [nullQty] = await run(nullQtySql(source)) as { itemCode: string | null }[];
    if (nullQty?.itemCode) {
      throw new BadRequestException(
        `${nullQty.itemCode} 의 계획수량이 비어 있습니다. 계획을 먼저 확인하세요.`,
      );
    }
    const skippedItems = (await run(skippedItemsSql(source)) as { itemCode: string }[])
      .map((row) => row.itemCode);

    const rows = await run(orderLinesSql({
      source,
      arms,
      distinctMfs: dto.distinctMfs,
      applyLeadTime: dto.applyLeadTime,
      applyCalendar: dto.applyCalendar,
    })) as Record<string, unknown>[];

    const num = (value: unknown) => Number(value ?? 0) || 0;
    const armCols = Object.values(ARM_COLUMNS);
    const pools = new Map<string, number>();
    for (const row of rows) {
      const key = `${row.itemCode}|${row.lineType}`;
      if (!pools.has(key)) pools.set(key, armCols.reduce((sum, col) => sum + num(row[col]), 0));
    }
    const netted = netOrderLines(
      rows.map((row) => ({
        itemCode: String(row.itemCode),
        lineType: String(row.lineType),
        qty: num(row.orderQty),
        minQty: num(row.minQty),
        packQty: num(row.packQty),
        badRate: num(row.badRate),
        countUnit: row.orderUom === 'EA' || row.orderUom === 'SET',
      })),
      pools,
      { applyInventory: arms.length > 0, applyOrderRule: dto.applyOrderRule },
    );

    const round = (value: number) => (dto.roundQty ? roundHalfUp(value, 4) : value);
    const lines: OrderPlanLine[] = rows.map((row, i) => {
      const n = netted[i];
      const delivery = (row.delivery as string | null) ?? null;
      return {
        itemCode: String(row.itemCode),
        itemName: (row.itemName as string | null) ?? null,
        itemSpec: (row.itemSpec as string | null) ?? null,
        itemUom: (row.itemUom as string | null) ?? null,
        lineType: String(row.priceLineType ?? row.lineType),
        netLineType: String(row.lineType),
        supplierCode: String(row.supplierCode),
        supplierName: (row.supplierName as string | null) ?? null,
        paymentType: String(row.paymentType),
        orderRate: row.orderRate == null ? null : num(row.orderRate),
        mfs: String(row.mfs),
        setItemCode: (row.setItemCode as string | null) ?? null,
        parentItemCode: (row.parentItemCode as string | null) ?? null,
        planDate: String(row.planDate),
        deliveryDate: String(row.deliveryDate),
        requirementQty: num(row.requirementQty),
        orderQty: round(num(row.orderQty)),
        invStock: num(row.INV_STOCK),
        invOrder: num(row.INV_ORDER),
        invArrival: num(row.INV_ARRIVAL),
        invWorkstage: num(row.INV_WORKSTAGE),
        invFree: num(row.INV_FREE),
        appliedQty: n.applied,
        badQty: n.badQty,
        roundUpQty: n.roundUpQty,
        purchaseQty: round(n.purchaseQty),
        delivery,
        unitPrice: num(row.unitPrice),
        currency: (row.currency as string | null) ?? '*',
        status: delivery ? 'N' : 'P',
        statusReason: delivery ? null
          : row.supplierCode === '*' ? '공급처 미지정' : '단가 기준정보 없음',
      };
    });
    return { lines, skippedItems, binds, applyInventory: arms.length > 0 };
  }

  /** 미리보기 — 계산만 하고 저장하지 않는다. */
  async preview(dto: OrderPlanGenerateDto, organizationId: number): Promise<{
    lines: OrderPlanLine[];
    skippedItems: string[];
    summary: { lines: number; orderLines: number; heldLines: number; purchaseQty: number };
  }> {
    const { lines, skippedItems } = await this.compute(this.dataSource, dto, organizationId);
    return {
      lines,
      skippedItems,
      summary: {
        lines: lines.length,
        orderLines: lines.filter((l) => l.status === 'N' && l.purchaseQty > 0).length,
        heldLines: lines.filter((l) => l.status === 'P').length,
        purchaseQty: lines.reduce((sum, l) => sum + l.purchaseQty, 0),
      },
    };
  }

  /**
   * 생성 — 계산한 결과로 소요량표와 발주계획을 조직 단위로 갈아끼운다 (PB 와 같다).
   * 작업 테이블(_TEMP·_GEN)은 쓰지 않는다. 한 트랜잭션.
   */
  async generate(
    dto: OrderPlanGenerateDto,
    organizationId: number,
    userId: string,
  ): Promise<{ requirementRows: number; planRows: number; skippedItems: string[] }> {
    return this.dataSource.transaction(async (manager) => {
      const { lines, skippedItems, binds, applyInventory } = await this.compute(
        manager, dto, organizationId,
      );
      const all = { ...binds, userId };

      await manager.query(
        `DELETE FROM IM_ITEM_PURCHASE_REQUIR_ORDER WHERE ORGANIZATION_ID = :organizationId`,
        { organizationId } as unknown as unknown[],
      );
      const reqSql = `INSERT INTO IM_ITEM_PURCHASE_REQUIR_ORDER
          (REQUIRMENT_PLAN_DATE, MFS, ITEM_CODE, SUPPLIER_CODE, ORGANIZATION_ID,
           PLAN_DATE, REQUIRMENT_QTY, LINE_TYPE, ENTER_BY, ENTER_DATE,
           LAST_MODIFY_BY, LAST_MODIFY_DATE, SET_ITEM_CODE, PARENT_ITEM_CODE)
        WITH ${requirementCtes(dto.source as PlanSource)}
        SELECT REQ_DATE, MFS, ITEM_CODE, F_GET_MAX_SUPPLIER_BY_ITEM(ITEM_CODE, :organizationId),
               :organizationId, PLAN_DATE, REQ_QTY, LINE_TYPE, :userId, SYSDATE, :userId, SYSDATE,
               SET_ITEM_CODE, PARENT_ITEM_CODE
          FROM REQO`;
      await manager.query(reqSql, pickBinds(reqSql, all) as unknown as unknown[]);

      await manager.query(
        `DELETE FROM IM_ITEM_PURCHASE_ORDER_PLAN WHERE ORGANIZATION_ID = :organizationId`,
        { organizationId } as unknown as unknown[],
      );
      if (lines.length > 0) {
        // 줄이 수백~수천이라 한 문장으로 넣는다 (JSON_TABLE).
        // 주문번호: 재고 차감을 거쳐 발주량이 생긴 줄은 TA+YYMMDD+일련번호 (PB 와 같다).
        const json = JSON.stringify(lines.map((l) => ({
          s: l.supplierCode, i: l.itemCode, d: l.deliveryDate, dv: l.delivery, lt: l.lineType,
          oq: l.orderQty, pq: l.purchaseQty, up: l.unitPrice, cu: l.currency,
          iq: l.appliedQty, mfs: l.mfs, st: l.status, pt: l.paymentType,
          si: l.setItemCode, pi: l.parentItemCode,
          ta: applyInventory && l.purchaseQty > 0 ? 'Y' : 'N',
        })));
        await manager.query(
          `INSERT INTO IM_ITEM_PURCHASE_ORDER_PLAN
             (ORDER_NO, PURCHASE_ORDER_DATE, ORGANIZATION_ID, SUPPLIER_CODE, ITEM_CODE,
              DELIVERY_DATE, DELIVERY, LINE_TYPE, ORDER_TYPE, ORDER_QTY,
              PURCHASE_ORDER_QTY, UNIT_PRICE, CURRENCY, INVENTORY_QTY, TOTAL_INVENTORY_QTY,
              ARRIVAL_QTY, PRE_ORDER_QTY, MFS, PURCHASE_ORDER_STATUS, PAYMENT_TYPE,
              ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE,
              SET_ITEM_CODE, PARENT_ITEM_CODE)
           SELECT CASE WHEN J.TA = 'Y'
                       THEN 'TA' || TO_CHAR(SYSDATE, 'YYMMDD') || SEQ_ORDER_NO.NEXTVAL
                       ELSE TO_CHAR(:organizationId) || TO_CHAR(SYSDATE, 'YYMMDD') || ROWNUM END,
                  TO_DATE(:orderDate, 'YYYY-MM-DD'), :organizationId, J.S, J.I,
                  TO_DATE(J.D, 'YYYY-MM-DD HH24:MI:SS'), J.DV, J.LT, 'F', J.OQ,
                  J.PQ, J.UP, J.CU, J.IQ, J.IQ,
                  0, 0, J.MFS, J.ST, J.PT,
                  :userId, SYSDATE, :userId, SYSDATE,
                  J.SI, J.PI
             FROM JSON_TABLE(:planJson, '$[*]' COLUMNS (
                    S   VARCHAR2(100)  PATH '$.s',
                    I   VARCHAR2(100)  PATH '$.i',
                    D   VARCHAR2(19)   PATH '$.d',
                    DV  VARCHAR2(20)   PATH '$.dv',
                    LT  VARCHAR2(20)   PATH '$.lt',
                    OQ  NUMBER         PATH '$.oq',
                    PQ  NUMBER         PATH '$.pq',
                    UP  NUMBER         PATH '$.up',
                    CU  VARCHAR2(20)   PATH '$.cu',
                    IQ  NUMBER         PATH '$.iq',
                    MFS VARCHAR2(100)  PATH '$.mfs',
                    ST  VARCHAR2(1)    PATH '$.st',
                    PT  VARCHAR2(20)   PATH '$.pt',
                    SI  VARCHAR2(100)  PATH '$.si',
                    PI  VARCHAR2(100)  PATH '$.pi',
                    TA  VARCHAR2(1)    PATH '$.ta')) J`,
          {
            planJson: clobBind(json),
            organizationId,
            orderDate: binds.orderDate,
            userId,
          } as unknown as unknown[],
        );
      }

      const [{ REQ }] = await manager.query(
        `SELECT COUNT(*) AS REQ FROM IM_ITEM_PURCHASE_REQUIR_ORDER
          WHERE ORGANIZATION_ID = :organizationId`,
        { organizationId } as unknown as unknown[],
      );
      return { requirementRows: Number(REQ), planRows: lines.length, skippedItems };
    });
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

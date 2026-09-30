/**
 * @file src/modules/purchase/purchase-order.service.ts
 * @description 480 자재주문예정관리 · 481 자재주문관리 — PB
 *   `w_mat_forecast_order_master` · `w_mat_purchase_order_master` 이식 (**쓰기**)
 *
 * 초보자 가이드:
 * 1. **자재를 사 오는 흐름의 앞부분이다.** 주문예정(`_WAIT`)에 후보를 담아 두고,
 *    승인되면 주문(`IM_ITEM_PURCHASE_ORDER`)으로 넘긴다. 그 뒤가 출발(483)·도착(484)이고,
 *    도착한 것이 입고(253)로 이어진다.
 * 2. **두 표는 컬럼이 거의 같다.** 예정표에 `CONFIRM_YN`/`CONFIRM_DATE`/`CONFIRM_BY`
 *    세 칸만 더 있다 (실측). 그래서 확정은 컬럼을 하나씩 옮겨 담는 것이 아니라
 *    **`INSERT … SELECT` 한 문장**으로 한다 — 컬럼이 늘어도 빠뜨릴 일이 없다.
 * 3. **승인 단계는 세 가지다** (공통코드 `CONFIRM YN` 실측):
 *        `'N'` 아니오 · `'W'` 대기 · `'Y'` 예
 *    PB 의 Request 버튼이 고른 줄을 `'W'`(대기)로 바꾼다. 확정은 `'Y'` 로 가면서
 *    주문표에 행을 만든다.
 * 4. **주문번호는 시퀀스에서 받는다** (`SEQ_PURCHASE_ORDER_NO`).
 * 5. **이 표들은 지금 전부 비어 있다** (실측 0행). 자재는 입고 150만건으로 들어오는데
 *    발주 기록은 MES 에 없다 — ERP 나 수기로 하고 있다는 뜻이다. 그래서 **조회로
 *    맞춰볼 자료가 없고 쓰기는 parse 까지만 검증했다.** 현장 확인이 반드시 필요하다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import {
  ForecastConfirmDto,
  ForecastOrderQueryDto,
  PurchaseOrderDeleteDto,
  PurchaseOrderQueryDto,
  PurchaseOrderSaveDto,
} from './purchase.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';

type Row = Record<string, unknown>;

/** 주문번호 채번. PB 와 같은 시퀀스를 쓴다. */
const SEQUENCE = 'SEQ_PURCHASE_ORDER_NO';

/** 공통코드 `CONFIRM YN` 실측값. */
export const CONFIRM = { no: 'N', wait: 'W', yes: 'Y' } as const;

/**
 * 두 표가 함께 가진 컬럼. 확정(`INSERT … SELECT`)과 저장이 이 목록을 공유한다.
 * 예정표에만 있는 `CONFIRM_*` 세 칸은 여기 없다 — 주문표에는 그 칸이 없기 때문이다.
 */
const SHARED_COLUMNS = [
  'ORDER_GROUP_NO', 'SUPPLIER_CODE', 'PURCHASE_ORDER_DATE', 'DELIVERY_DATE',
  'DELIVERY', 'LINE_TYPE', 'INCIDENTAL_EXPENSE_CODE', 'ORIGIN_NATION_CODE',
  'ORDER_TYPE', 'DELIVERY_PLACE', 'ORDER_QTY', 'UNIT_PRICE', 'DELIVERY_METHOD',
  'CURRENCY', 'ARRIVAL_QTY', 'MFS', 'ITEM_CODE', 'SHIPMENT_COMMENT',
  'ATTN_NAME', 'CC_NAME', 'MATERIAL_MFS', 'ORDER_AMT', 'ORIGIN_MFS',
] as const;

@Injectable()
export class PurchaseOrderService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 조회

  /**
   * 481 주문 목록 (PB `d_mat_purchase_order_lst`).
   *
   * PB 는 `FROM A, B, C, D` 에 조건으로 붙이는 옛 문법이라 품목·협력사가 없으면
   * 주문이 **통째로 사라진다.** 여기서는 LEFT JOIN 으로 바꿔 기준정보가 빠져도
   * 주문은 보이게 했다 — 발주 자료를 잃는 것보다 이름 칸이 비는 편이 낫다.
   */
  async findOrders(query: PurchaseOrderQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `${this.orderSelect('o', 'IM_ITEM_PURCHASE_ORDER')}
        WHERE o.ORGANIZATION_ID = :organizationId
          AND o.PURCHASE_ORDER_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND o.PURCHASE_ORDER_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(o.SUPPLIER_CODE, '*') LIKE :supplierCode
          AND NVL(o.ITEM_CODE, '*') LIKE :itemCode
          AND NVL(o.ORDER_GROUP_NO, '*') LIKE :orderGroupNo
          AND NVL(o.ORDER_TYPE, '*') LIKE :orderType
        ORDER BY o.PURCHASE_ORDER_DATE DESC, o.ORDER_NO DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      this.listBinds(query, organizationId) as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /** 480 주문예정 목록. 주문 목록과 같은 모양에 승인 칸이 더 붙는다. */
  async findForecasts(query: ForecastOrderQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `${this.orderSelect('o', 'IM_ITEM_PURCHASE_ORDER_WAIT', true)}
        WHERE o.ORGANIZATION_ID = :organizationId
          AND o.PURCHASE_ORDER_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND o.PURCHASE_ORDER_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(o.SUPPLIER_CODE, '*') LIKE :supplierCode
          AND NVL(o.ITEM_CODE, '*') LIKE :itemCode
          AND NVL(o.ORDER_GROUP_NO, '*') LIKE :orderGroupNo
          AND NVL(o.ORDER_TYPE, '*') LIKE :orderType
          AND NVL(o.CONFIRM_YN, 'N') LIKE :confirmYn
        ORDER BY o.PURCHASE_ORDER_DATE DESC, o.ORDER_NO DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        ...this.listBinds(query, organizationId),
        confirmYn: this.like(query.confirmYn),
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /** 발주그룹별 합계 (PB `d_mat_purchase_order_group_lst`). */
  async findOrderGroups(query: PurchaseOrderQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT o.ORDER_GROUP_NO   AS "orderGroupNo",
              o.SUPPLIER_CODE    AS "supplierCode",
              MAX(sp.SUPPLIER_NAME) AS "supplierName",
              MIN(TO_CHAR(o.PURCHASE_ORDER_DATE, 'YYYY-MM-DD')) AS "orderDateFrom",
              MAX(TO_CHAR(o.PURCHASE_ORDER_DATE, 'YYYY-MM-DD')) AS "orderDateTo",
              COUNT(*)           AS "orderCount",
              SUM(NVL(o.ORDER_QTY, 0))   AS "orderQty",
              SUM(NVL(o.ARRIVAL_QTY, 0)) AS "arrivalQty",
              SUM(NVL(o.ORDER_AMT, 0))   AS "orderAmt"
         FROM IM_ITEM_PURCHASE_ORDER o
         LEFT JOIN ICOM_SUPPLIER sp
                ON sp.SUPPLIER_CODE = o.SUPPLIER_CODE
               AND sp.ORGANIZATION_ID = o.ORGANIZATION_ID
        WHERE o.ORGANIZATION_ID = :organizationId
          AND o.PURCHASE_ORDER_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND o.PURCHASE_ORDER_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(o.SUPPLIER_CODE, '*') LIKE :supplierCode
          AND NVL(o.ITEM_CODE, '*') LIKE :itemCode
          AND NVL(o.ORDER_GROUP_NO, '*') LIKE :orderGroupNo
          AND NVL(o.ORDER_TYPE, '*') LIKE :orderType
        GROUP BY o.ORDER_GROUP_NO, o.SUPPLIER_CODE
        ORDER BY 4 DESC, 1
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      this.listBinds(query, organizationId) as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 주문 등록·수정 (쓰기)

  /**
   * 481 주문을 넣거나 고친다 (**쓰기**).
   *
   * `orderNo` 가 있으면 수정, 없으면 새 주문이다. **이미 도착 수량이 잡힌 주문은
   * 고치지 않는다** — 발주를 줄이면 도착분과 어긋난다.
   */
  async saveOrder(dto: PurchaseOrderSaveDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      if (dto.orderNo) {
        const updated = await qr.query(
          `UPDATE IM_ITEM_PURCHASE_ORDER
              SET SUPPLIER_CODE = :supplierCode,
                  PURCHASE_ORDER_DATE = TO_DATE(:purchaseOrderDate, 'YYYY-MM-DD'),
                  DELIVERY_DATE = TO_DATE(:deliveryDate, 'YYYY-MM-DD'),
                  DELIVERY = :delivery,
                  LINE_TYPE = :lineType,
                  ORDER_TYPE = :orderType,
                  ORDER_QTY = :orderQty,
                  UNIT_PRICE = :unitPrice,
                  ORDER_AMT = :orderAmt,
                  CURRENCY = :currency,
                  DELIVERY_METHOD = :deliveryMethod,
                  DELIVERY_PLACE = :deliveryPlace,
                  ORIGIN_NATION_CODE = :originNationCode,
                  INCIDENTAL_EXPENSE_CODE = :incidentalExpenseCode,
                  ITEM_CODE = :itemCode,
                  ORDER_GROUP_NO = :orderGroupNo,
                  SHIPMENT_COMMENT = :shipmentComment,
                  ATTN_NAME = :attnName,
                  CC_NAME = :ccName,
                  LAST_MODIFY_BY = :userId,
                  LAST_MODIFY_DATE = SYSDATE
            WHERE ORDER_NO = :orderNo
              AND ORGANIZATION_ID = :organizationId
              -- 도착분이 잡힌 주문은 손대지 않는다.
              AND NVL(ARRIVAL_QTY, 0) = 0`,
          this.saveBinds(dto, organizationId, userId) as unknown as unknown[],
        );
        const affected = Number(
          affectedRows(updated) ?? 0,
        );
        if (affected !== 1) {
          throw new BadRequestException(
            '고칠 수 없는 주문입니다 (없거나 이미 도착분이 잡혔습니다).',
          );
        }
        return { orderNo: dto.orderNo, created: false };
      }

      const seqRows = (await qr.query(
        `SELECT TO_CHAR(${SEQUENCE}.NEXTVAL) AS "orderNo" FROM DUAL`,
      )) as Row[];
      const orderNo = String(seqRows[0]?.orderNo ?? '');
      if (!orderNo) {
        throw new BadRequestException('주문번호를 만들지 못했습니다.');
      }

      await qr.query(
        `INSERT INTO IM_ITEM_PURCHASE_ORDER
           (ORDER_NO, ORGANIZATION_ID, ORDER_GROUP_NO, SUPPLIER_CODE,
            PURCHASE_ORDER_DATE, DELIVERY_DATE, DELIVERY, LINE_TYPE,
            INCIDENTAL_EXPENSE_CODE, ORIGIN_NATION_CODE, ORDER_TYPE, DELIVERY_PLACE,
            ORDER_QTY, UNIT_PRICE, DELIVERY_METHOD, CURRENCY, ARRIVAL_QTY,
            ITEM_CODE, ORDER_AMT, SHIPMENT_COMMENT, ATTN_NAME, CC_NAME,
            ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
         VALUES
           (:orderNo, :organizationId, :orderGroupNo, :supplierCode,
            TO_DATE(:purchaseOrderDate, 'YYYY-MM-DD'),
            TO_DATE(:deliveryDate, 'YYYY-MM-DD'), :delivery, :lineType,
            :incidentalExpenseCode, :originNationCode, :orderType, :deliveryPlace,
            :orderQty, :unitPrice, :deliveryMethod, :currency, 0,
            :itemCode, :orderAmt, :shipmentComment, :attnName, :ccName,
            SYSDATE, :userId, SYSDATE, :userId)`,
        {
          ...this.saveBinds(dto, organizationId, userId),
          orderNo,
        } as unknown as unknown[],
      );
      return { orderNo, created: true };
    });
  }

  /** 481 주문을 지운다 (**쓰기**). 도착분이 잡혔으면 지우지 않는다. */
  async deleteOrder(dto: PurchaseOrderDeleteDto, organizationId: number) {
    return this.tx.run(async (qr) => {
      const deleted = await qr.query(
        `DELETE FROM IM_ITEM_PURCHASE_ORDER o
          WHERE o.ORDER_NO = :orderNo
            AND o.ORGANIZATION_ID = :organizationId
            AND NVL(o.ARRIVAL_QTY, 0) = 0
            -- 출발·도착 기록이 붙은 주문도 지우지 않는다.
            AND NOT EXISTS (
                  SELECT 1 FROM IM_ITEM_ARRIVAL a
                   WHERE a.ORDER_NO = o.ORDER_NO
                     AND a.ORGANIZATION_ID = o.ORGANIZATION_ID)`,
        { orderNo: dto.orderNo, organizationId } as unknown as unknown[],
      );
      const affected = Number(
        affectedRows(deleted) ?? 0,
      );
      if (affected !== 1) {
        throw new BadRequestException(
          '지울 수 없는 주문입니다 (없거나 도착·출발 기록이 붙어 있습니다).',
        );
      }
      return { orderNo: dto.orderNo, deletedRows: affected };
    });
  }

  // ───────────────────────────────── 주문예정 승인 (쓰기)

  /**
   * 480 주문예정의 승인 단계를 바꾼다 (**쓰기**).
   *
   * PB 의 Request 버튼이 고른 줄을 `'W'`(대기)로 바꾸던 것을 일반화했다 —
   * `'W'` 요청 · `'N'` 취소 · `'Y'` 확정. `'Y'` 로 갈 때는
   * **주문표에 행을 만들면서** 함께 움직인다 (`confirmToOrder`).
   */
  async setForecastConfirm(
    dto: ForecastConfirmDto,
    organizationId: number,
    userId: string,
  ) {
    if (dto.confirmYn === CONFIRM.yes) {
      return this.confirmToOrder(dto, organizationId, userId);
    }
    return this.tx.run(async (qr) => {
      const updated = await qr.query(
        `UPDATE IM_ITEM_PURCHASE_ORDER_WAIT
            SET CONFIRM_YN = :confirmYn,
                CONFIRM_DATE = SYSDATE,
                CONFIRM_BY = :userId,
                LAST_MODIFY_BY = :userId,
                LAST_MODIFY_DATE = SYSDATE
          WHERE ORDER_NO IN (${this.inList(dto.orderNos, 'n')})
            AND ORGANIZATION_ID = :organizationId
            -- 이미 확정된 건은 되돌리지 않는다.
            AND NVL(CONFIRM_YN, 'N') <> 'Y'`,
        {
          confirmYn: dto.confirmYn,
          userId,
          organizationId,
          ...this.inBinds(dto.orderNos, 'n'),
        } as unknown as unknown[],
      );
      return {
        confirmYn: dto.confirmYn,
        changedRows: Number(
          affectedRows(updated) ?? 0,
        ),
      };
    });
  }

  /**
   * 주문예정을 주문으로 확정한다 (**쓰기**).
   *
   * **컬럼을 손으로 옮겨 담지 않는다.** 두 표가 같은 이름의 칸을 갖고 있어
   * `INSERT … SELECT` 한 문장으로 옮긴다 — 칸이 늘어도 빠뜨리지 않는다.
   * 주문번호는 예정번호를 그대로 쓴다 (PB 와 같다). 이미 같은 번호의 주문이
   * 있으면 넣지 않는다.
   */
  private async confirmToOrder(
    dto: ForecastConfirmDto,
    organizationId: number,
    userId: string,
  ) {
    const cols = SHARED_COLUMNS.join(', ');
    const srcCols = SHARED_COLUMNS.map((c) => `w.${c}`).join(', ');

    return this.tx.run(async (qr) => {
      const inserted = await qr.query(
        `INSERT INTO IM_ITEM_PURCHASE_ORDER
           (ORDER_NO, ORGANIZATION_ID, ${cols},
            ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
         SELECT w.ORDER_NO, w.ORGANIZATION_ID, ${srcCols},
                SYSDATE, :userId, SYSDATE, :userId
           FROM IM_ITEM_PURCHASE_ORDER_WAIT w
          WHERE w.ORDER_NO IN (${this.inList(dto.orderNos, 'n')})
            AND w.ORGANIZATION_ID = :organizationId
            AND NVL(w.CONFIRM_YN, 'N') <> 'Y'
            AND NOT EXISTS (
                  SELECT 1 FROM IM_ITEM_PURCHASE_ORDER x
                   WHERE x.ORDER_NO = w.ORDER_NO
                     AND x.ORGANIZATION_ID = w.ORGANIZATION_ID)`,
        {
          userId,
          organizationId,
          ...this.inBinds(dto.orderNos, 'n'),
        } as unknown as unknown[],
      );
      const created = Number(
        affectedRows(inserted) ?? 0,
      );
      if (created === 0) {
        throw new BadRequestException(
          '확정할 주문예정이 없습니다 (이미 확정됐거나 같은 번호의 주문이 있습니다).',
        );
      }

      // 예정표에 확정 표시를 남긴다. 예정 기록 자체는 지우지 않는다 — 어디서
      // 넘어온 주문인지 되짚을 수 있어야 한다.
      await qr.query(
        `UPDATE IM_ITEM_PURCHASE_ORDER_WAIT
            SET CONFIRM_YN = 'Y',
                CONFIRM_DATE = SYSDATE,
                CONFIRM_BY = :userId,
                LAST_MODIFY_BY = :userId,
                LAST_MODIFY_DATE = SYSDATE
          WHERE ORDER_NO IN (${this.inList(dto.orderNos, 'n')})
            AND ORGANIZATION_ID = :organizationId`,
        {
          userId,
          organizationId,
          ...this.inBinds(dto.orderNos, 'n'),
        } as unknown as unknown[],
      );

      return { confirmYn: CONFIRM.yes, createdOrders: created };
    });
  }

  // ───────────────────────────────── 공통

  /** 주문·예정 목록이 함께 쓰는 SELECT. 예정은 승인 칸이 더 붙는다. */
  private orderSelect(alias: string, table: string, withConfirm = false) {
    return `SELECT ${alias}.ORDER_NO        AS "orderNo",
              ${alias}.ORDER_GROUP_NO       AS "orderGroupNo",
              ${alias}.SUPPLIER_CODE        AS "supplierCode",
              sp.SUPPLIER_NAME              AS "supplierName",
              ${alias}.ITEM_CODE            AS "itemCode",
              i.ITEM_NAME                   AS "itemName",
              i.ITEM_SPEC                   AS "itemSpec",
              i.ITEM_UOM                    AS "itemUom",
              ${alias}.LINE_TYPE            AS "lineType",
              ${alias}.ORDER_TYPE           AS "orderType",
              ${alias}.ORDER_QTY            AS "orderQty",
              ${alias}.ARRIVAL_QTY          AS "arrivalQty",
              NVL(${alias}.ORDER_QTY, 0) - NVL(${alias}.ARRIVAL_QTY, 0) AS "remainQty",
              ${alias}.UNIT_PRICE           AS "unitPrice",
              ${alias}.ORDER_AMT            AS "orderAmt",
              ${alias}.CURRENCY             AS "currency",
              ${alias}.DELIVERY             AS "delivery",
              ${alias}.DELIVERY_METHOD      AS "deliveryMethod",
              ${alias}.DELIVERY_PLACE       AS "deliveryPlace",
              ${alias}.ORIGIN_NATION_CODE   AS "originNationCode",
              ${alias}.INCIDENTAL_EXPENSE_CODE AS "incidentalExpenseCode",
              ${alias}.MFS                  AS "mfs",
              ${alias}.MATERIAL_MFS         AS "materialMfs",
              ${alias}.SHIPMENT_COMMENT     AS "shipmentComment",
              ${alias}.ATTN_NAME            AS "attnName",
              ${alias}.CC_NAME              AS "ccName",
              ${alias}.ENTER_BY             AS "enterBy",
              ${withConfirm
                ? `NVL(${alias}.CONFIRM_YN, 'N')  AS "confirmYn",
              ${alias}.CONFIRM_BY           AS "confirmBy",
              TO_CHAR(${alias}.CONFIRM_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "confirmDate",`
                : ''}
              TO_CHAR(${alias}.PURCHASE_ORDER_DATE, 'YYYY-MM-DD') AS "purchaseOrderDate",
              TO_CHAR(${alias}.DELIVERY_DATE, 'YYYY-MM-DD')       AS "deliveryDate",
              TO_CHAR(${alias}.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "enterDate"
         FROM ${table} ${alias}
         -- PB 는 옛 조인 문법이라 품목·협력사가 없으면 주문이 통째로 사라졌다.
         -- 발주 자료를 잃는 것보다 이름 칸이 비는 편이 낫다.
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = ${alias}.ITEM_CODE
               AND i.ORGANIZATION_ID = ${alias}.ORGANIZATION_ID
         LEFT JOIN ICOM_SUPPLIER sp
                ON sp.SUPPLIER_CODE = ${alias}.SUPPLIER_CODE
               AND sp.ORGANIZATION_ID = ${alias}.ORGANIZATION_ID`;
  }

  private listBinds(query: PurchaseOrderQueryDto, organizationId: number) {
    return {
      organizationId,
      dateFrom: query.dateFrom,
      dateTo: query.dateTo,
      supplierCode: this.like(query.supplierCode),
      itemCode: this.like(query.itemCode),
      orderGroupNo: this.like(query.orderGroupNo),
      orderType: this.like(query.orderType),
    };
  }

  private saveBinds(
    dto: PurchaseOrderSaveDto,
    organizationId: number,
    userId: string,
  ) {
    return {
      orderNo: dto.orderNo ?? null,
      organizationId,
      userId,
      orderGroupNo: dto.orderGroupNo,
      supplierCode: dto.supplierCode,
      purchaseOrderDate: dto.purchaseOrderDate,
      deliveryDate: dto.deliveryDate,
      delivery: dto.delivery,
      lineType: dto.lineType,
      orderType: dto.orderType ?? null,
      orderQty: dto.orderQty,
      unitPrice: dto.unitPrice ?? null,
      // PB 는 화면에서 수량×단가를 채워 넣었다. 비면 여기서 같은 값을 만든다.
      orderAmt: dto.orderAmt ?? (dto.unitPrice ? dto.orderQty * dto.unitPrice : null),
      currency: dto.currency ?? null,
      deliveryMethod: dto.deliveryMethod ?? null,
      deliveryPlace: dto.deliveryPlace ?? null,
      originNationCode: dto.originNationCode ?? null,
      incidentalExpenseCode: dto.incidentalExpenseCode ?? null,
      itemCode: dto.itemCode,
      shipmentComment: dto.shipmentComment ?? null,
      attnName: dto.attnName ?? null,
      ccName: dto.ccName ?? null,
    };
  }

  /**
   * `IN (:n0, :n1, …)` 을 만든다.
   * 값을 SQL 에 직접 붙이지 않는다 — 주문번호가 사용자 입력이기 때문이다.
   */
  private inList(values: string[], prefix: string) {
    return values.map((_, i) => `:${prefix}${i}`).join(', ');
  }

  private inBinds(values: string[], prefix: string) {
    return Object.fromEntries(values.map((v, i) => [`${prefix}${i}`, v]));
  }

  private like(value?: string) {
    const trimmed = (value ?? '').trim();
    return trimmed ? `%${trimmed}%` : '%';
  }
}

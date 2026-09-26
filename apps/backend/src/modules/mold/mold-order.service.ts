/**
 * @file src/modules/mold/mold-order.service.ts
 * @description S-PARTS 주문 — PB w_mcn_mold_purchase_order_master 이식
 *
 * 초보자 가이드:
 * 1. **주문번호 규칙은 PB 와 같다** — `주문일자(YYYYMMDD) + SEQ_PURCHASE_ORDER_NO(최소 3자리)`.
 *    PB 가 `string(date,'yyyymmdd') + string(f_get_sequence('SEQ_PURCHASE_ORDER_NO'),'000')`
 *    으로 만들던 것이다. 시퀀스를 웹에서 새로 만들면 PB 와 번호가 갈리므로 같은 시퀀스를 쓴다.
 * 2. **단가는 비워두면 서버가 채운다.** PB 도 공급처·S-PARTS 가 바뀌면
 *    f_get_mold_unit_price 로 단가를 끌어왔다. 그 함수는
 *    PKG_MES_MAC.F_GET_MOLD_UNIT_PRICE 로 전환돼 있어 SQL 안에서 바로 부른다.
 *    단가가 없으면 그 함수가 -2 를 돌려주므로 0 으로 바꿔 넣는다.
 * 3. 주문금액(ORDER_AMT)은 저장하는 값이다 — 수량 × 단가로 서버가 계산한다.
 * 4. **입고된 주문은 지우지 않는다.** RECEIPT_QTY 가 0 보다 크면 삭제를 막는다.
 */
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  MoldOrderCreateDto,
  MoldOrderKeyDto,
  MoldOrderQueryDto,
  MoldOrderUpdateDto,
} from './mold-order.dto';

type OracleRow = Record<string, unknown>;

/** 수정에서 사용자가 값을 넣는 컬럼. 키·감사·입고수량은 여기에 없다. */
const UPDATABLE: Array<[column: string, field: keyof MoldOrderUpdateDto]> = [
  ['ORDER_QTY', 'orderQty'], ['UNIT_PRICE', 'unitPrice'], ['CURRENCY', 'currency'],
  ['LINE_TYPE', 'lineType'], ['DELIVERY_METHOD', 'deliveryMethod'],
  ['DELIVERY_PLACE', 'deliveryPlace'], ['ATTN_NAME', 'attnName'], ['CC_NAME', 'ccName'],
  ['INCIDENTAL_EXPENSE_CODE', 'incidentalExpenseCode'],
];

@Injectable()
export class MoldOrderService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** 목록 — PB d_mcn_mold_purchase_order_lst (납기일 기간) */
  async find(query: MoldOrderQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      dateFrom: query.dateFrom.slice(0, 10),
      dateTo: query.dateTo.slice(0, 10),
      supplierCode: this.like(query.supplierCode),
      moldCode: this.like(query.moldCode),
    };
    const body = `
      SELECT o.ORDER_NO AS "orderNo", o.ORDER_GROUP_NO AS "orderGroupNo",
             o.PURCHASE_ORDER_DATE AS "purchaseOrderDate",
             o.DELIVERY_DATE AS "deliveryDate",
             o.MOLD_CODE AS "moldCode",
             m.MOLD_NAME AS "moldName", m.MOLD_SPEC AS "moldSpec",
             o.SUPPLIER_CODE AS "supplierCode", sup.SUPPLIER_NAME AS "supplierName",
             o.ORDER_QTY AS "orderQty", o.RECEIPT_QTY AS "receiptQty",
             o.ORDER_QTY - NVL(o.RECEIPT_QTY, 0) AS "remainQty",
             o.UNIT_PRICE AS "unitPrice", o.ORDER_AMT AS "orderAmt",
             o.CURRENCY AS "currency", cur.CODE_MEAN_KOR AS "currencyName",
             o.LINE_TYPE AS "lineType", lnt.CODE_MEAN_KOR AS "lineTypeName",
             o.DELIVERY_METHOD AS "deliveryMethod", dvm.CODE_MEAN_KOR AS "deliveryMethodName",
             o.DELIVERY_PLACE AS "deliveryPlace",
             o.ATTN_NAME AS "attnName", o.CC_NAME AS "ccName",
             o.INCIDENTAL_EXPENSE_CODE AS "incidentalExpenseCode",
             o.ENTER_BY AS "enterBy", o.ENTER_DATE AS "enterDate",
             o.LAST_MODIFY_BY AS "lastModifyBy", o.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IMCN_MOLD_PURCHASE_ORDER o
        JOIN IMCN_MOLD m
          ON m.MOLD_CODE = o.MOLD_CODE AND m.ORGANIZATION_ID = o.ORGANIZATION_ID
        LEFT JOIN ICOM_SUPPLIER sup
               ON sup.SUPPLIER_CODE = o.SUPPLIER_CODE
              AND sup.ORGANIZATION_ID = o.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE cur
               ON cur.CODE_TYPE = 'CURRENCY' AND cur.CODE_NAME = o.CURRENCY
              AND cur.ORGANIZATION_ID = o.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE lnt
               ON lnt.CODE_TYPE = 'LINE TYPE' AND lnt.CODE_NAME = o.LINE_TYPE
              AND lnt.ORGANIZATION_ID = o.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE dvm
               ON dvm.CODE_TYPE = 'DELIVERY METHOD' AND dvm.CODE_NAME = o.DELIVERY_METHOD
              AND dvm.ORGANIZATION_ID = o.ORGANIZATION_ID
       WHERE NVL(o.SUPPLIER_CODE, '*') LIKE :supplierCode
         AND o.MOLD_CODE LIKE :moldCode
         AND o.DELIVERY_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
         AND o.DELIVERY_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
         AND o.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      { ...binds } as unknown as unknown[],
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "deliveryDate" DESC, "orderNo"
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset: (page - 1) * limit, limit } as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /**
   * 주문그룹 집계 — PB d_mcn_mold_purchase_order_group_lst.
   * 같은 주문그룹번호의 건수·수량·금액을 묶어 본다.
   */
  async findGroups(query: MoldOrderQueryDto, organizationId: number) {
    return this.dataSource.query(
      `SELECT o.ORDER_GROUP_NO AS "orderGroupNo",
              o.SUPPLIER_CODE AS "supplierCode", sup.SUPPLIER_NAME AS "supplierName",
              MIN(o.PURCHASE_ORDER_DATE) AS "purchaseOrderDate",
              MIN(o.DELIVERY_DATE) AS "deliveryDateFrom",
              MAX(o.DELIVERY_DATE) AS "deliveryDateTo",
              COUNT(*) AS "orderCount",
              SUM(o.ORDER_QTY) AS "orderQty",
              SUM(NVL(o.RECEIPT_QTY, 0)) AS "receiptQty",
              SUM(NVL(o.ORDER_AMT, 0)) AS "orderAmt"
         FROM IMCN_MOLD_PURCHASE_ORDER o
         LEFT JOIN ICOM_SUPPLIER sup
                ON sup.SUPPLIER_CODE = o.SUPPLIER_CODE
               AND sup.ORGANIZATION_ID = o.ORGANIZATION_ID
        WHERE NVL(o.SUPPLIER_CODE, '*') LIKE :supplierCode
          AND o.MOLD_CODE LIKE :moldCode
          AND o.DELIVERY_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND o.DELIVERY_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND o.ORGANIZATION_ID = :organizationId
        GROUP BY o.ORDER_GROUP_NO, o.SUPPLIER_CODE, sup.SUPPLIER_NAME
        ORDER BY MIN(o.DELIVERY_DATE) DESC, o.ORDER_GROUP_NO`,
      {
        organizationId,
        dateFrom: query.dateFrom.slice(0, 10),
        dateTo: query.dateTo.slice(0, 10),
        supplierCode: this.like(query.supplierCode),
        moldCode: this.like(query.moldCode),
      } as unknown as unknown[],
    ) as Promise<OracleRow[]>;
  }

  /**
   * 등록 — 주문번호는 PB 규칙으로 서버가 만든다.
   * 단가를 안 주면 유효한 구매단가를 끌어온다(PB f_get_mold_unit_price 와 같은 오브젝트).
   */
  async create(dto: MoldOrderCreateDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const exists = await qr.query(
        `SELECT PKG_MES_MAC.F_CHECK_MOLD_EXISTS(:moldCode, :organizationId) AS "cnt" FROM DUAL`,
        { moldCode: dto.moldCode, organizationId } as unknown as unknown[],
      ) as OracleRow[];
      if (Number(exists[0]?.cnt ?? -1) < 0) {
        throw new BadRequestException(`등록되지 않은 S-PARTS 입니다 (${dto.moldCode}).`);
      }
      const supplier = await qr.query(
        `SELECT PKG_MES_MAC.F_CHECK_SUPPLIER_EXISTS(:supplierCode, :organizationId) AS "cnt"
           FROM DUAL`,
        { supplierCode: dto.supplierCode, organizationId } as unknown as unknown[],
      ) as OracleRow[];
      if (Number(supplier[0]?.cnt ?? -1) < 0) {
        throw new BadRequestException(`등록되지 않은 공급처입니다 (${dto.supplierCode}).`);
      }

      // PB 규칙: 주문일자(YYYYMMDD) + 시퀀스. 시퀀스가 3자리보다 짧으면 0 을 채운다.
      const generated = await qr.query(
        `SELECT TO_CHAR(TO_DATE(:orderDate, 'YYYY-MM-DD'), 'YYYYMMDD')
                || LPAD(TO_CHAR(SEQ_PURCHASE_ORDER_NO.NEXTVAL), 3, '0') AS "orderNo"
           FROM DUAL`,
        { orderDate: dto.purchaseOrderDate.slice(0, 10) } as unknown as unknown[],
      ) as OracleRow[];
      const orderNo = String(generated[0]?.orderNo ?? '');

      await qr.query(
        `INSERT INTO IMCN_MOLD_PURCHASE_ORDER (
           ORDER_NO, ORGANIZATION_ID, ORDER_GROUP_NO, SUPPLIER_CODE, MOLD_CODE,
           PURCHASE_ORDER_DATE, DELIVERY_DATE, ORDER_QTY, RECEIPT_QTY,
           UNIT_PRICE, CURRENCY, ORDER_AMT,
           DELIVERY_METHOD, DELIVERY_PLACE, ATTN_NAME, CC_NAME,
           INCIDENTAL_EXPENSE_CODE, LINE_TYPE,
           ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE
         )
         SELECT :orderNo, :organizationId, :orderGroupNo, :supplierCode, :moldCode,
                TO_DATE(:purchaseOrderDate, 'YYYY-MM-DD'),
                TO_DATE(:deliveryDate, 'YYYY-MM-DD'),
                :orderQty, 0,
                resolved.UNIT_PRICE, :currency, :orderQty * resolved.UNIT_PRICE,
                :deliveryMethod, :deliveryPlace, :attnName, :ccName,
                :incidentalExpenseCode, :lineType,
                :userId, SYSDATE, :userId, SYSDATE
           FROM (SELECT GREATEST(
                          NVL(:unitPrice,
                              PKG_MES_MAC.F_GET_MOLD_UNIT_PRICE(
                                :supplierCode, :moldCode, :organizationId)),
                          0) AS UNIT_PRICE
                   FROM DUAL) resolved`,
        {
          orderNo,
          organizationId,
          orderGroupNo: dto.orderGroupNo ?? null,
          supplierCode: dto.supplierCode,
          moldCode: dto.moldCode,
          purchaseOrderDate: dto.purchaseOrderDate.slice(0, 10),
          deliveryDate: dto.deliveryDate.slice(0, 10),
          orderQty: dto.orderQty,
          currency: dto.currency ?? null,
          deliveryMethod: dto.deliveryMethod ?? null,
          deliveryPlace: dto.deliveryPlace ?? null,
          attnName: dto.attnName ?? null,
          ccName: dto.ccName ?? null,
          incidentalExpenseCode: dto.incidentalExpenseCode ?? null,
          lineType: dto.lineType ?? null,
          unitPrice: dto.unitPrice ?? null,
          userId,
        } as unknown as unknown[],
      );
      return { orderNo };
    });
  }

  /** 수정 — 주문금액은 수량 × 단가로 다시 계산한다. */
  async update(dto: MoldOrderUpdateDto, organizationId: number, userId: string) {
    const sets: string[] = [];
    const binds: OracleRow = { orderNo: dto.orderNo, organizationId, userId };
    for (const [column, field] of UPDATABLE) {
      if (dto[field] === undefined) continue;
      sets.push(`${column} = :${field}`);
      binds[field] = dto[field] ?? null;
    }
    if (dto.deliveryDate !== undefined) {
      sets.push(`DELIVERY_DATE = TO_DATE(:deliveryDate, 'YYYY-MM-DD')`);
      binds.deliveryDate = dto.deliveryDate.slice(0, 10);
    }
    sets.push('ORDER_AMT = NVL(ORDER_QTY, 0) * NVL(UNIT_PRICE, 0)');
    sets.push('LAST_MODIFY_BY = :userId', 'LAST_MODIFY_DATE = SYSDATE');

    const result = await this.dataSource.query(
      `UPDATE IMCN_MOLD_PURCHASE_ORDER SET ${sets.join(', ')}
        WHERE ORDER_NO = :orderNo AND ORGANIZATION_ID = :organizationId`,
      binds as unknown as unknown[],
    ) as unknown;
    void result;
    if (!await this.exists(dto.orderNo, organizationId)) {
      throw new NotFoundException(`주문을 찾을 수 없습니다 (${dto.orderNo}).`);
    }
    return { orderNo: dto.orderNo };
  }

  private async exists(orderNo: string, organizationId: number) {
    const rows = await this.dataSource.query(
      `SELECT COUNT(*) AS "cnt" FROM IMCN_MOLD_PURCHASE_ORDER
        WHERE ORDER_NO = :orderNo AND ORGANIZATION_ID = :organizationId`,
      { orderNo, organizationId } as unknown as unknown[],
    ) as OracleRow[];
    return Number(rows[0]?.cnt ?? 0) > 0;
  }

  /** 삭제 — 이미 입고가 잡힌 주문은 막는다. */
  async remove(dto: MoldOrderKeyDto, organizationId: number) {
    const rows = await this.dataSource.query(
      `SELECT NVL(RECEIPT_QTY, 0) AS "receiptQty" FROM IMCN_MOLD_PURCHASE_ORDER
        WHERE ORDER_NO = :orderNo AND ORGANIZATION_ID = :organizationId`,
      { orderNo: dto.orderNo, organizationId } as unknown as unknown[],
    ) as OracleRow[];
    if (rows.length === 0) {
      throw new NotFoundException(`주문을 찾을 수 없습니다 (${dto.orderNo}).`);
    }
    if (Number(rows[0]?.receiptQty ?? 0) > 0) {
      throw new BadRequestException('이미 입고된 주문은 삭제할 수 없습니다.');
    }
    await this.dataSource.query(
      `DELETE FROM IMCN_MOLD_PURCHASE_ORDER
        WHERE ORDER_NO = :orderNo AND ORGANIZATION_ID = :organizationId`,
      { orderNo: dto.orderNo, organizationId } as unknown as unknown[],
    );
    return { deleted: true };
  }
}

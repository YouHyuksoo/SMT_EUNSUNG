/**
 * @file src/modules/mold/mold-receipt.service.ts
 * @description S-PARTS 입고 — PB w_mcn_mold_receipt_master 이식
 *
 * 초보자 가이드:
 * 1. **입고항번은 SEQ_MAT_RECEIPT 로 채번한다.** PB 가 자재 입고 시퀀스를 그대로 썼다.
 *    웹에서 새 시퀀스를 만들면 PB 와 번호가 갈리므로 같은 것을 쓴다.
 * 2. **PB 가 박아둔 기본값**: 입고일=오늘, 입출고구분='1'(1입고), 입고상태='N'(정상).
 * 3. **단가는 승인된 단가만 끌어온다.** PB 는 f_get_mold_unit_price_by_confirm 을 썼다 —
 *    PKG_MES_MAC.F_GET_MOLD_UNIT_PRICE(..., 'Y') 가 같은 일을 한다.
 * 4. **취소는 행을 지우지 않는다.** PKG_MES_MAC.SP_MOLD_RECEIPT_CANCEL 이
 *    원본을 'C' 로 바꾸고 부호를 뒤집은 상계행을 새로 넣는다(역분개).
 * 5. **이 DB 의 IMCN_MOLD_RECEIPT 에는 COMMENTS 컬럼이 없다.**
 *    PB 소스(다른 사이트 기준)에는 있어서 비고 컬럼은 이관 대상에서 뺐다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../shared/transaction.service';
import {
  MoldReceiptCancelDto,
  MoldReceiptCreateDto,
  MoldReceiptQueryDto,
  MoldReceiptTargetQueryDto,
} from './mold-receipt.dto';
import { namedBinds } from '../../common/utils/named-binds.util';

type OracleRow = Record<string, unknown>;

@Injectable()
export class MoldReceiptService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** 목록 — PB d_mcn_mold_receipt_lst (입고일 기간, TRUNC 비교) */
  async find(query: MoldReceiptQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      dateFrom: query.dateFrom.slice(0, 10),
      dateTo: query.dateTo.slice(0, 10),
      moldCode: this.like(query.moldCode),
      supplierCode: this.like(query.supplierCode),
    };
    const body = `
      SELECT r.RECEIPT_DATE AS "receiptDate", r.RECEIPT_SEQUENCE AS "receiptSequence",
             r.MOLD_CODE AS "moldCode",
             m.MOLD_NAME AS "moldName", m.MOLD_SPEC AS "moldSpec",
             r.MOLD_VERSION AS "moldVersion", r.MOLD_SET_SERIAL AS "moldSetSerial",
             r.MOLD_VERSION_SPEC AS "moldVersionSpec",
             r.SUPPLIER_CODE AS "supplierCode", sup.SUPPLIER_NAME AS "supplierName",
             r.INVOICE_NO AS "invoiceNo", r.ORDER_NO AS "orderNo",
             r.RECEIPT_DEFICIT AS "receiptDeficit", dft.CODE_MEAN_KOR AS "receiptDeficitName",
             r.RECEIPT_QTY AS "receiptQty", r.UNIT_PRICE AS "unitPrice",
             r.RECEIPT_AMT AS "receiptAmt",
             r.CURRENCY AS "currency", cur.CODE_MEAN_KOR AS "currencyName",
             r.RECEIPT_STATUS AS "receiptStatus", stt.CODE_MEAN_KOR AS "receiptStatusName",
             r.LOCATION_CODE AS "locationCode",
             r.LINE_TYPE AS "lineType", lnt.CODE_MEAN_KOR AS "lineTypeName",
             r.ENTER_BY AS "enterBy", r.ENTER_DATE AS "enterDate",
             r.LAST_MODIFY_BY AS "lastModifyBy", r.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IMCN_MOLD_RECEIPT r
        LEFT JOIN IMCN_MOLD m
               ON m.MOLD_CODE = r.MOLD_CODE AND m.ORGANIZATION_ID = r.ORGANIZATION_ID
        LEFT JOIN ICOM_SUPPLIER sup
               ON sup.SUPPLIER_CODE = r.SUPPLIER_CODE
              AND sup.ORGANIZATION_ID = r.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE dft
               ON dft.CODE_TYPE = 'RECEIPT DEFICIT' AND dft.CODE_NAME = r.RECEIPT_DEFICIT
              AND dft.ORGANIZATION_ID = r.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE stt
               ON stt.CODE_TYPE = 'RECEIPT STATUS' AND stt.CODE_NAME = r.RECEIPT_STATUS
              AND stt.ORGANIZATION_ID = r.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE cur
               ON cur.CODE_TYPE = 'CURRENCY' AND cur.CODE_NAME = r.CURRENCY
              AND cur.ORGANIZATION_ID = r.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE lnt
               ON lnt.CODE_TYPE = 'LINE TYPE' AND lnt.CODE_NAME = r.LINE_TYPE
              AND lnt.ORGANIZATION_ID = r.ORGANIZATION_ID
       WHERE TRUNC(r.RECEIPT_DATE) >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
         AND TRUNC(r.RECEIPT_DATE) <= TO_DATE(:dateTo, 'YYYY-MM-DD')
         AND r.MOLD_CODE LIKE :moldCode
         AND NVL(r.SUPPLIER_CODE, '*') LIKE :supplierCode
         AND r.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      namedBinds({ ...binds }),
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "receiptDate" DESC, "receiptSequence" DESC
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      namedBinds({ ...binds, offset: (page - 1) * limit, limit }),
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /**
   * 입고 대상 목록 — PB d_mcn_mold_4_receipt_lst.
   * 입고할 S-PARTS 를 고르는 목록이다. 승인된 구매단가를 같이 내려 화면이 단가를 바로 보여준다.
   */
  async findTargets(query: MoldReceiptTargetQueryDto, organizationId: number) {
    return this.dataSource.query<OracleRow[]>(
      `SELECT m.MOLD_CODE AS "moldCode", m.MOLD_NAME AS "moldName",
              m.MOLD_SPEC AS "moldSpec",
              m.MOLD_GROUP AS "moldGroup", grp.CODE_MEAN_KOR AS "moldGroupName",
              m.MOLD_UOM AS "moldUom",
              m.SUPPLIER_CODE AS "supplierCode", sup.SUPPLIER_NAME AS "supplierName",
              m.SAFETY_INVENTORY AS "safetyInventory",
              m.ORDER_LEADTIME AS "orderLeadtime",
              m.LAST_RECEIPT_DATE AS "lastReceiptDate",
              inv.MOLD_VERSION AS "moldVersion", inv.MOLD_SET_SERIAL AS "moldSetSerial",
              inv.INVENTORY_QTY AS "inventoryQty", inv.LOCATION_CODE AS "locationCode",
              PKG_MES_MAC.F_GET_MOLD_UNIT_PRICE(
                m.SUPPLIER_CODE, m.MOLD_CODE, m.ORGANIZATION_ID, 'Y') AS "confirmedUnitPrice",
              PKG_MES_MAC.F_GET_MOLD_UNIT_PRICE_CURR(
                m.SUPPLIER_CODE, m.MOLD_CODE, m.ORGANIZATION_ID, 'Y') AS "confirmedCurrency"
         FROM IMCN_MOLD m
         LEFT JOIN IMCN_MOLD_INVENTORY inv
                ON inv.MOLD_CODE = m.MOLD_CODE AND inv.ORGANIZATION_ID = m.ORGANIZATION_ID
         LEFT JOIN ICOM_SUPPLIER sup
                ON sup.SUPPLIER_CODE = m.SUPPLIER_CODE
               AND sup.ORGANIZATION_ID = m.ORGANIZATION_ID
         LEFT JOIN ISYS_BASECODE grp
                ON grp.CODE_TYPE = 'MOLD GROUP' AND grp.CODE_NAME = m.MOLD_GROUP
               AND grp.ORGANIZATION_ID = m.ORGANIZATION_ID
        WHERE m.MOLD_CODE LIKE :moldCode
          AND NVL(m.SUPPLIER_CODE, '*') LIKE :supplierCode
          AND m.MOLD_CODE <> '*'
          AND m.ORGANIZATION_ID = :organizationId
        ORDER BY m.MOLD_CODE, inv.MOLD_VERSION, inv.MOLD_SET_SERIAL`,
      namedBinds({
        moldCode: this.like(query.moldCode),
        supplierCode: this.like(query.supplierCode),
        organizationId,
      }),
    );
  }

  /** 등록 — PB 기본값(입고일=오늘, 구분='1', 상태='N')을 그대로 쓴다. */
  async create(dto: MoldReceiptCreateDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const checks = await qr.query(
        `SELECT PKG_MES_MAC.F_CHECK_MOLD_EXISTS(:moldCode, :organizationId) AS "mold",
                PKG_MES_MAC.F_CHECK_SUPPLIER_EXISTS(:supplierCode, :organizationId) AS "supplier"
           FROM DUAL`,
        namedBinds({
          moldCode: dto.moldCode,
          supplierCode: dto.supplierCode,
          organizationId,
        }),
      ) as OracleRow[];
      if (Number(checks[0]?.mold ?? -1) < 0) {
        throw new BadRequestException(`등록되지 않은 S-PARTS 입니다 (${dto.moldCode}).`);
      }
      if (Number(checks[0]?.supplier ?? -1) < 0) {
        throw new BadRequestException(`등록되지 않은 공급처입니다 (${dto.supplierCode}).`);
      }

      const seq = await qr.query(
        `SELECT SEQ_MAT_RECEIPT.NEXTVAL AS "seq" FROM DUAL`, [],
      ) as OracleRow[];
      const receiptSequence = Number(seq[0]?.seq ?? 0);

      await qr.query(
        `INSERT INTO IMCN_MOLD_RECEIPT (
           RECEIPT_DATE, RECEIPT_SEQUENCE, ORGANIZATION_ID,
           SUPPLIER_CODE, MOLD_CODE, INVOICE_NO, ORDER_NO,
           RECEIPT_DEFICIT, RECEIPT_QTY, UNIT_PRICE, RECEIPT_AMT, CURRENCY,
           RECEIPT_STATUS, LOCATION_CODE, LINE_TYPE,
           MOLD_VERSION, MOLD_SET_SERIAL, MOLD_VERSION_SPEC,
           ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE
         )
         SELECT NVL(TO_DATE(:receiptDate, 'YYYY-MM-DD'), TRUNC(SYSDATE)),
                :receiptSequence, :organizationId,
                :supplierCode, :moldCode, :invoiceNo, :orderNo,
                '1', :receiptQty, resolved.UNIT_PRICE,
                :receiptQty * resolved.UNIT_PRICE,
                NVL(:currency, resolved.CURRENCY),
                'N', :locationCode, :lineType,
                :moldVersion, :moldSetSerial, :moldVersionSpec,
                :userId, SYSDATE, :userId, SYSDATE
           FROM (SELECT GREATEST(
                          NVL(:unitPrice,
                              PKG_MES_MAC.F_GET_MOLD_UNIT_PRICE(
                                :supplierCode, :moldCode, :organizationId, 'Y')),
                          0) AS UNIT_PRICE,
                        PKG_MES_MAC.F_GET_MOLD_UNIT_PRICE_CURR(
                          :supplierCode, :moldCode, :organizationId, 'Y') AS CURRENCY
                   FROM DUAL) resolved`,
        namedBinds({
          receiptDate: dto.receiptDate ? dto.receiptDate.slice(0, 10) : null,
          receiptSequence,
          organizationId,
          supplierCode: dto.supplierCode,
          moldCode: dto.moldCode,
          invoiceNo: dto.invoiceNo ?? null,
          orderNo: dto.orderNo ?? null,
          receiptQty: dto.receiptQty,
          currency: dto.currency ?? null,
          locationCode: dto.locationCode ?? null,
          lineType: dto.lineType ?? null,
          moldVersion: dto.moldVersion ?? null,
          moldSetSerial: dto.moldSetSerial ?? null,
          moldVersionSpec: dto.moldVersionSpec ?? null,
          unitPrice: dto.unitPrice ?? null,
          userId,
        }),
      );
      return { receiptSequence };
    });
  }

  /**
   * 취소 — PB f_mcn_mold_receipt_cancel → PKG_MES_MAC.SP_MOLD_RECEIPT_CANCEL 전환.
   * 원본을 'C' 로 바꾸고 부호를 뒤집은 상계행을 오늘 날짜로 새로 넣는다.
   */
  async cancel(dto: MoldReceiptCancelDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      await qr.query(
        `DECLARE
           v_result NUMBER;
         BEGIN
           PKG_MES_MAC.SP_MOLD_RECEIPT_CANCEL(
             TO_DATE(:receiptDate, 'YYYY-MM-DD'), :receiptSequence,
             :organizationId, :userId, v_result);
           IF v_result < 0 THEN
             RAISE_APPLICATION_ERROR(-20012, 'MOLD_RECEIPT_CANCEL_FAILED:' || v_result);
           END IF;
         END;`,
        namedBinds({
          receiptDate: dto.receiptDate.slice(0, 10),
          receiptSequence: dto.receiptSequence,
          organizationId,
          userId,
        }),
      ).catch((error: unknown) => {
        const message = error instanceof Error ? error.message : String(error);
        const matched = /MOLD_RECEIPT_CANCEL_FAILED:(-?\d+)/.exec(message);
        if (!matched) throw error;
        throw new BadRequestException(
          matched[1] === '-2'
            ? '이미 취소된 입고건입니다.'
            : '입고건을 찾을 수 없습니다.',
        );
      });
      // 상계행의 항번은 프로시저가 채번한다 — 저장된 결과를 다시 읽어 돌려준다.
      const rows = await qr.query(
        `SELECT MAX(RECEIPT_SEQUENCE) AS "cancelSequence"
           FROM IMCN_MOLD_RECEIPT
          WHERE RECEIPT_DATE = TRUNC(SYSDATE) AND RECEIPT_STATUS = 'C'
            AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ organizationId }),
      ) as OracleRow[];
      return { cancelSequence: Number(rows[0]?.cancelSequence ?? 0) };
    });
  }
}

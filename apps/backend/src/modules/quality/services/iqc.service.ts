/**
 * @file src/modules/quality/services/iqc.service.ts
 * @description IQC 관리 — PB w_qc_iqc_master 이식
 *
 * 초보자 가이드:
 * 1. **판정 단위는 바코드가 아니라 입고전표(RECEIPT_SLIP_NO)다.** 전표 하나를 판정하면
 *    그 전표에 딸린 바코드 전부가 같은 판정을 받고, 바코드마다 검사이력 1건이 생긴다.
 * 2. **목록 2개는 조건 하나만 다르다** — 대기는 `INSPECT_RESULT NOT IN ('P','R')`,
 *    취소대상은 `IN ('P','R')`. PB 도 탭 두 개로 같은 DataWindow 를 나눠 썼다.
 * 3. **`IM_ITEM_RECEIPT_BARCODE` 는 190만 행이다.** 조회는 반드시 `SCAN_DATE` 범위로 좁힌다
 *    (INDXIM_ITEM_RECEIPT_BARCODE3 가 SCAN_DATE 인덱스다). 그래서 기간을 필수로 받는다.
 * 4. **ESD 점검주기가 10 이면 합격 판정을 막는다.** PB 가 화면에서 막던 규칙이다.
 *    값은 SQL 안에서 `F_GET_ESD_CHECK_CYCLE_VALUE` 로 읽는다 — 이미 있는 DB 함수다.
 * 5. 판정·취소·ESD점검 로직은 이 서비스가 아니라 PKG_MES_QC 에 있다.
 *    PB 화면과 웹이 같은 DB 오브젝트를 호출해야 결과가 갈리지 않는다.
 */
import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../../shared/transaction.service';
import {
  IqcCancelDto,
  IqcEsdCheckDto,
  IqcHistoryQueryDto,
  IqcJudgeDto,
  IqcTargetQueryDto,
} from '../dto/iqc.dto';

type OracleRow = Record<string, unknown>;

/** PB 가 합격 판정을 막는 ESD 점검주기 임계값 */
const ESD_CHECK_LIMIT = 10;

@Injectable()
export class IqcService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** PB 규약: 빈 값이면 '%' 가 되어 전체를 조회한다. */
  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /**
   * 판정 대상 목록 — PB d_mat_rceipt_barcode_4_iqc_wait_lst / _cancel_lst.
   * ESD 점검주기를 같이 내려 화면이 합격 버튼을 막을 수 있게 한다.
   */
  async findTargets(query: IqcTargetQueryDto, organizationId: number) {
    const judged = query.mode === 'cancel';
    const binds = {
      organizationId,
      dateFrom: query.dateFrom.slice(0, 10),
      dateTo: query.dateTo.slice(0, 10),
      itemCode: this.like(query.itemCode),
      itemName: this.like(query.itemName),
      itemBarcode: this.like(query.itemBarcode),
      receiptSlipNo: this.like(query.receiptSlipNo),
      // PB 는 두 목록에서 이 조건의 연산자가 다르다 —
      // 대기목록은 '=' (기본 'N' 입고대기), 취소대상은 LIKE (기본 전체).
      receiptCompareYn: judged
        ? this.like(query.receiptCompareYn)
        : (query.receiptCompareYn ?? 'N').trim(),
    };
    const body = `
      SELECT b.ITEM_BARCODE AS "itemBarcode", b.SUPPLIER_BARCODE AS "supplierBarcode",
             b.RECEIPT_SLIP_NO AS "receiptSlipNo",
             b.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName",
             i.ITEM_SPEC AS "itemSpec",
             i.ITEM_CLASS AS "itemClass", cls.CODE_MEAN_KOR AS "itemClassName",
             b.SUPPLIER_CODE AS "supplierCode", sup.SUPPLIER_NAME AS "supplierName",
             b.SUPPLIER_ITEM_CODE AS "supplierItemCode",
             b.SCAN_DATE AS "scanDate", b.SCAN_QTY AS "scanQty",
             b.LOT_NO AS "lotNo",
             b.INSPECT_RESULT AS "inspectResult", res.CODE_MEAN_KOR AS "inspectResultName",
             b.RECEIPT_COMPARE_YN AS "receiptCompareYn",
             cmp.CODE_MEAN_KOR AS "receiptCompareName",
             b.RECEIPT_COMPARE_DATE AS "receiptCompareDate",
             b.RECEIPT_COMPARE_BY AS "receiptCompareBy",
             b.BARCODE_STATUS AS "barcodeStatus", bst.CODE_MEAN_KOR AS "barcodeStatusName",
             b.RECEIPT_TYPE AS "receiptType", b.LABEL_TYPE AS "labelType",
             b.LOT_DIVIDE_YN AS "lotDivideYn",
             b.ORIGIN_ITEM_BARCODE AS "originItemBarcode",
             b.MANUFACTURE_WEEK AS "manufactureWeek",
             b.MANUFACTURE_DATE AS "manufactureDate",
             b.PCB_COATING_DATE AS "pcbCoatingDate",
             i.LOCATION_ADDRESS AS "locationAddress", i.MSL_LEVEL AS "mslLevel",
             F_GET_ESD_CHECK_CYCLE_VALUE(b.SUPPLIER_CODE, b.ITEM_CODE, b.ORGANIZATION_ID)
               AS "esdCheckCycleValue",
             b.ENTER_BY AS "enterBy", b.ENTER_DATE AS "enterDate",
             b.LAST_MODIFY_BY AS "lastModifyBy", b.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IM_ITEM_RECEIPT_BARCODE b
        LEFT JOIN ID_ITEM i
               ON i.ITEM_CODE = b.ITEM_CODE AND i.ORGANIZATION_ID = b.ORGANIZATION_ID
        LEFT JOIN ICOM_SUPPLIER sup
               ON sup.SUPPLIER_CODE = b.SUPPLIER_CODE
              AND sup.ORGANIZATION_ID = b.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE res
               ON res.CODE_TYPE = 'INSPECT RESULT' AND res.CODE_NAME = b.INSPECT_RESULT
              AND res.ORGANIZATION_ID = b.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE cmp
               ON cmp.CODE_TYPE = 'RECEIPT COMPARE YN'
              AND cmp.CODE_NAME = b.RECEIPT_COMPARE_YN
              AND cmp.ORGANIZATION_ID = b.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE bst
               ON bst.CODE_TYPE = 'BARCODE STATUS' AND bst.CODE_NAME = b.BARCODE_STATUS
              AND bst.ORGANIZATION_ID = b.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE cls
               ON cls.CODE_TYPE = 'ITEM CLASS' AND cls.CODE_NAME = i.ITEM_CLASS
              AND cls.ORGANIZATION_ID = b.ORGANIZATION_ID
       WHERE b.SCAN_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
         AND b.SCAN_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
         AND b.RECEIPT_SLIP_NO LIKE :receiptSlipNo
         AND NVL(b.INSPECT_RESULT, 'N') ${judged ? 'IN' : 'NOT IN'} ('P', 'R')
         AND b.BARCODE_STATUS <> 'C'
         AND NVL(b.ITEM_CODE, '*') LIKE :itemCode
         AND b.ITEM_BARCODE LIKE :itemBarcode
         AND b.RECEIPT_COMPARE_YN ${judged ? 'LIKE' : '='} :receiptCompareYn
         AND NVL(i.ITEM_NAME, '*') LIKE :itemName
         AND b.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      { ...binds } as unknown as unknown[],
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "scanDate" DESC, "receiptSlipNo", "itemBarcode"
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset: (page - 1) * limit, limit } as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /** 검사이력 — PB d_qc_iqc_lst */
  async findHistory(query: IqcHistoryQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      dateFrom: query.dateFrom.slice(0, 10),
      dateTo: query.dateTo.slice(0, 10),
      itemCode: this.like(query.itemCode),
      iqcInspectNo: this.like(query.iqcInspectNo),
    };
    const body = `
      SELECT q.INSPECT_DATE AS "inspectDate", q.INSPECT_SEQUENCE AS "inspectSequence",
             q.IQC_INSPECT_NO AS "iqcInspectNo",
             q.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName",
             q.MFS AS "mfs",
             q.INSPECT_RESULT AS "inspectResult", res.CODE_MEAN_KOR AS "inspectResultName",
             q.BAD_REASON_CODE AS "badReasonCode", bad.CODE_MEAN_KOR AS "badReasonName",
             q.SUPPLIER_CODE AS "supplierCode", sup.SUPPLIER_NAME AS "supplierName",
             q.ARRIVAL_QTY AS "arrivalQty", q.ARRIVAL_DATE AS "arrivalDate",
             q.INSPECT_LOT_QTY AS "inspectLotQty",
             q.INSPECT_BAD_LOT_QTY AS "inspectBadLotQty",
             q.INSPECT_QTY AS "inspectQty", q.INSPECT_BAD_QTY AS "inspectBadQty",
             q.DESTROY_QTY AS "destroyQty",
             q.INSPECT_BY AS "inspectBy", q.IQC_IMPROVE_NO AS "iqcImproveNo",
             q.COMMENTS AS "comments",
             q.ENTER_BY AS "enterBy", q.ENTER_DATE AS "enterDate",
             q.LAST_MODIFY_BY AS "lastModifyBy", q.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IQ_ITEM_IQC q
        LEFT JOIN ID_ITEM i
               ON i.ITEM_CODE = q.ITEM_CODE AND i.ORGANIZATION_ID = q.ORGANIZATION_ID
        LEFT JOIN ICOM_SUPPLIER sup
               ON sup.SUPPLIER_CODE = q.SUPPLIER_CODE
              AND sup.ORGANIZATION_ID = q.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE res
               ON res.CODE_TYPE = 'INSPECT RESULT' AND res.CODE_NAME = q.INSPECT_RESULT
              AND res.ORGANIZATION_ID = q.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE bad
               ON bad.CODE_TYPE = 'BAD REASON CODE' AND bad.CODE_NAME = q.BAD_REASON_CODE
              AND bad.ORGANIZATION_ID = q.ORGANIZATION_ID
       WHERE q.INSPECT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
         AND q.INSPECT_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
         AND q.ITEM_CODE LIKE :itemCode
         AND q.IQC_INSPECT_NO LIKE :iqcInspectNo
         AND q.ORGANIZATION_ID = :organizationId`;
    const page = query.page ?? 1;
    const limit = query.limit ?? 500;
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      { ...binds } as unknown as unknown[],
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ORDER BY "inspectDate" DESC, "inspectSequence" DESC
       OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset: (page - 1) * limit, limit } as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /**
   * 판정 — PB b_ok / b_ng → PKG_MES_QC.SP_IQC_JUDGE 전환.
   *
   * 합격 판정 전에 ESD 점검주기를 본다. PB 가 화면에서 막던 규칙이라 서버에서도 막는다 —
   * 화면만 막으면 API 를 직접 부르는 경로가 규칙을 우회한다.
   */
  async judge(dto: IqcJudgeDto, organizationId: number, userId: string) {
    const badReasonCode = dto.inspectResult === 'P'
      ? 'GOOD'
      : (dto.badReasonCode ?? '').trim();
    if (dto.inspectResult === 'R' && !badReasonCode) {
      throw new BadRequestException('불합격이면 불량원인을 고르세요.');
    }

    if (dto.inspectResult === 'P') {
      const blocked = await this.dataSource.query(
        `SELECT COUNT(*) AS "cnt"
           FROM IM_ITEM_RECEIPT_BARCODE b
          WHERE b.RECEIPT_SLIP_NO = :receiptSlipNo
            AND b.ORGANIZATION_ID = :organizationId
            AND F_GET_ESD_CHECK_CYCLE_VALUE(b.SUPPLIER_CODE, b.ITEM_CODE, b.ORGANIZATION_ID)
                >= :limit`,
        {
          receiptSlipNo: dto.receiptSlipNo,
          organizationId,
          limit: ESD_CHECK_LIMIT,
        } as unknown as unknown[],
      ) as OracleRow[];
      if (Number(blocked[0]?.cnt ?? 0) > 0) {
        throw new BadRequestException(
          'ESD 점검주기가 되었습니다. ESD 점검을 먼저 처리하세요.',
        );
      }
    }

    return this.tx.run(async (qr) => {
      await qr.query(
        `DECLARE
           v_result NUMBER;
         BEGIN
           PKG_MES_QC.SP_IQC_JUDGE(
             :receiptSlipNo, :inspectResult, :badReasonCode,
             :organizationId, :userId, v_result);
           IF v_result < 0 THEN
             RAISE_APPLICATION_ERROR(-20020, 'IQC_JUDGE_FAILED:' || v_result);
           END IF;
         END;`,
        {
          receiptSlipNo: dto.receiptSlipNo,
          inspectResult: dto.inspectResult,
          badReasonCode,
          organizationId,
          userId,
        } as unknown as unknown[],
      ).catch((error: unknown) => {
        const message = error instanceof Error ? error.message : String(error);
        const matched = /IQC_JUDGE_FAILED:(-?\d+)/.exec(message);
        if (!matched) throw error;
        if (matched[1] === '-2') {
          throw new BadRequestException('이미 판정된 전표입니다.');
        }
        if (matched[1] === '-3') {
          throw new BadRequestException('판정값이 올바르지 않습니다.');
        }
        throw new NotFoundException(`입고전표를 찾을 수 없습니다 (${dto.receiptSlipNo}).`);
      });
      // 만든 검사이력 건수는 프로시저가 채운다 — 저장된 결과를 다시 읽어 돌려준다.
      const rows = await qr.query(
        `SELECT COUNT(*) AS "created" FROM IQ_ITEM_IQC
          WHERE IQC_INSPECT_NO = :receiptSlipNo AND ORGANIZATION_ID = :organizationId
            AND INSPECT_DATE >= TRUNC(SYSDATE)`,
        { receiptSlipNo: dto.receiptSlipNo, organizationId } as unknown as unknown[],
      ) as OracleRow[];
      return {
        receiptSlipNo: dto.receiptSlipNo,
        inspectResult: dto.inspectResult,
        created: Number(rows[0]?.created ?? 0),
      };
    });
  }

  /**
   * 판정취소 — PB b_cancel → PKG_MES_QC.SP_IQC_JUDGE_CANCEL 전환.
   * 검사이력은 지우지 않는다. PB 도 DELETE 를 주석 처리해 이력을 남겼다.
   */
  async cancel(dto: IqcCancelDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      await qr.query(
        `DECLARE
           v_result NUMBER;
         BEGIN
           PKG_MES_QC.SP_IQC_JUDGE_CANCEL(
             :receiptSlipNo, :organizationId, :userId, v_result);
           IF v_result < 0 THEN
             RAISE_APPLICATION_ERROR(-20021, 'IQC_CANCEL_FAILED');
           END IF;
         END;`,
        {
          receiptSlipNo: dto.receiptSlipNo,
          organizationId,
          userId,
        } as unknown as unknown[],
      ).catch((error: unknown) => {
        const message = error instanceof Error ? error.message : String(error);
        if (message.includes('IQC_CANCEL_FAILED')) {
          throw new NotFoundException(`입고전표를 찾을 수 없습니다 (${dto.receiptSlipNo}).`);
        }
        throw error;
      });
      const rows = await qr.query(
        `SELECT COUNT(*) AS "reverted" FROM IM_ITEM_RECEIPT_BARCODE
          WHERE RECEIPT_SLIP_NO = :receiptSlipNo AND ORGANIZATION_ID = :organizationId
            AND INSPECT_RESULT = 'W'`,
        { receiptSlipNo: dto.receiptSlipNo, organizationId } as unknown as unknown[],
      ) as OracleRow[];
      return {
        receiptSlipNo: dto.receiptSlipNo,
        reverted: Number(rows[0]?.reverted ?? 0),
      };
    });
  }

  /** ESD 점검 완료 — PB b_esd_check → PKG_MES_QC.SP_IQC_ESD_CHECK_DONE 전환 */
  async esdCheckDone(dto: IqcEsdCheckDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      await qr.query(
        `DECLARE
           v_result NUMBER;
         BEGIN
           PKG_MES_QC.SP_IQC_ESD_CHECK_DONE(
             :supplierCode, :itemCode, :organizationId, :userId, v_result);
           IF v_result < 0 THEN
             RAISE_APPLICATION_ERROR(-20022, 'IQC_ESD_NOT_FOUND');
           END IF;
         END;`,
        {
          supplierCode: dto.supplierCode,
          itemCode: dto.itemCode,
          organizationId,
          userId,
        } as unknown as unknown[],
      ).catch((error: unknown) => {
        const message = error instanceof Error ? error.message : String(error);
        if (message.includes('IQC_ESD_NOT_FOUND')) {
          throw new NotFoundException(
            `공급처·품목의 구매정보를 찾을 수 없습니다 (${dto.supplierCode}/${dto.itemCode}).`,
          );
        }
        throw error;
      });
      return { supplierCode: dto.supplierCode, itemCode: dto.itemCode, reset: true };
    });
  }
}

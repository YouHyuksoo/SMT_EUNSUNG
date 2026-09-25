/**
 * @file src/modules/material/services/receipt-cancel.service.ts
 * @description 자재입고취소 — PB w_mat_receipt_cancel_master + f_mat_receipt_cancel 이식
 *
 * 취소는 행 삭제가 아니라 **상계(역분개)** 다. 그 로직은 이 서비스가 아니라
 * **PKG_MES_MAT.SP_RECEIPT_CANCEL** 에 있다 (PB f_mat_receipt_cancel 전환, 2026-09-25).
 * PB 화면과 웹이 같은 DB 오브젝트를 호출해야 상계 결과가 갈리지 않는다.
 * 이 서비스가 담당하는 것은 화면 단위 규칙이다: 중복 제거, 전월 이월분 스킵, 일괄 롤백.
 *
 * PB 원본에서 이미 주석 처리돼 있던 f_get_free_assy_issue_cost 호출과,
 * 합의로 제외한 인터페이스 연동(interface_yn 분기)은 이식하지 않았다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource, QueryRunner } from 'typeorm';
import { parseDateEnd, parseDateStart } from '../../../shared/date.util';
import { TransactionService } from '../../../shared/transaction.service';
import {
  ReceiptCancelExecuteDto,
  ReceiptCancelQueryDto,
  ReceiptCancelTargetDto,
} from '../dto/receipt-cancel.dto';

type OracleRow = Record<string, unknown>;

@Injectable()
export class ReceiptCancelService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  async find(query: ReceiptCancelQueryDto, organizationId: number) {
    const binds: Record<string, unknown> = {
      organizationId,
      itemCode: this.like(query.itemCode),
      materialMfs: this.like(query.materialMfs),
      supplierCode: this.like(query.supplierCode),
      locationCode: this.like(query.locationCode),
      invoiceNo: this.like(query.invoiceNo),
      // 'YYYY-MM-DD' 를 new Date() 로 바로 넘기면 UTC 자정으로 해석돼 KST 기준 +9시간 밀린다.
      dateFrom: parseDateStart(query.dateFrom) ?? new Date(1900, 0, 1),
      dateTo: parseDateEnd(query.dateTo) ?? new Date(9999, 11, 31),
    };
    const from = query.mode === 'HISTORY' ? this.historyFrom() : this.cancelFrom();
    const select = `${this.selectList(query.mode)} ${from}
      ORDER BY rcp.RECEIPT_DATE DESC, rcp.RECEIPT_SEQUENCE DESC
      OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`;
    const count = `SELECT COUNT(*) AS "total" ${from}`;
    const offset = (query.page - 1) * query.limit;
    const rows = await this.dataSource.query(
      select,
      { ...binds, offset, limit: query.limit } as unknown as unknown[],
    ) as OracleRow[];
    const totals = await this.dataSource.query(count, binds as unknown as unknown[]) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page: query.page, limit: query.limit };
  }

  /** PB d_mat_receipt_cancel_lst — 취소대상만. 바코드는 LEFT JOIN 이라 1:N 으로 행이 늘어난다(PB 동작 유지). */
  private cancelFrom(): string {
    return `
      FROM IM_ITEM_RECEIPT rcp
      LEFT JOIN ID_ITEM item
        ON item.ITEM_CODE = rcp.ITEM_CODE AND item.ORGANIZATION_ID = rcp.ORGANIZATION_ID
      LEFT JOIN ICOM_SUPPLIER sup
        ON sup.SUPPLIER_CODE = rcp.SUPPLIER_CODE AND sup.ORGANIZATION_ID = rcp.ORGANIZATION_ID
      LEFT JOIN IM_ITEM_RECEIPT_BARCODE bar
        ON bar.ITEM_CODE = rcp.ITEM_CODE AND bar.LOT_NO = rcp.MATERIAL_MFS
      WHERE rcp.ORGANIZATION_ID = :organizationId
        AND rcp.ITEM_CODE LIKE :itemCode
        AND NVL(rcp.MATERIAL_MFS, '*') LIKE :materialMfs
        AND NVL(rcp.SUPPLIER_CODE, '*') LIKE :supplierCode
        AND NVL(rcp.LOCATION_CODE, '*') LIKE :locationCode
        AND NVL(rcp.INVOICE_NO, '*') LIKE :invoiceNo
        AND rcp.RECEIPT_DATE BETWEEN :dateFrom AND :dateTo
        AND rcp.LINE_TYPE <> 'M'
        AND rcp.RECEIPT_STATUS = 'N'`;
  }

  /** PB d_mat_receipt_hst — 상태 무관 전체 이력. 바코드 조인 없음. */
  private historyFrom(): string {
    return `
      FROM IM_ITEM_RECEIPT rcp
      LEFT JOIN ID_ITEM item
        ON item.ITEM_CODE = rcp.ITEM_CODE AND item.ORGANIZATION_ID = rcp.ORGANIZATION_ID
      LEFT JOIN ICOM_SUPPLIER sup
        ON sup.SUPPLIER_CODE = rcp.SUPPLIER_CODE AND sup.ORGANIZATION_ID = rcp.ORGANIZATION_ID
      WHERE rcp.ORGANIZATION_ID = :organizationId
        AND rcp.ITEM_CODE LIKE :itemCode
        AND NVL(rcp.MATERIAL_MFS, '*') LIKE :materialMfs
        AND NVL(rcp.SUPPLIER_CODE, '*') LIKE :supplierCode
        AND NVL(rcp.LOCATION_CODE, '*') LIKE :locationCode
        AND NVL(rcp.INVOICE_NO, '*') LIKE :invoiceNo
        AND rcp.RECEIPT_DATE BETWEEN :dateFrom AND :dateTo`;
  }

  private selectList(mode: ReceiptCancelQueryDto['mode']): string {
    const barcode = mode === 'CANCEL'
      ? `, bar.ITEM_BARCODE AS "itemBarcode", bar.SCAN_QTY AS "scanQty"`
      : `, CAST(NULL AS VARCHAR2(100)) AS "itemBarcode", CAST(NULL AS NUMBER) AS "scanQty"`;
    return `
      SELECT rcp.RECEIPT_DATE AS "receiptDate",
             rcp.RECEIPT_SEQUENCE AS "receiptSequence",
             rcp.RECEIPT_STATUS AS "receiptStatus",
             rcp.RECEIPT_TYPE AS "receiptType",
             rcp.LOCATION_CODE AS "locationCode",
             rcp.LINE_TYPE AS "lineType",
             rcp.ITEM_CODE AS "itemCode",
             item.ITEM_NAME AS "itemName",
             item.ITEM_SPEC AS "itemSpec",
             rcp.MATERIAL_MFS AS "materialMfs",
             rcp.SUPPLIER_CODE AS "supplierCode",
             sup.SUPPLIER_NAME AS "supplierName",
             rcp.INVOICE_NO AS "invoiceNo",
             rcp.RECEIPT_QTY AS "receiptQty",
             rcp.UNIT_PRICE AS "unitPrice",
             rcp.RECEIPT_AMT AS "receiptAmt",
             rcp.CURRENCY AS "currency",
             rcp.RECEIPT_LOT_NO AS "receiptLotNo",
             rcp.ORDER_NO AS "orderNo",
             rcp.INTERFACE_YN AS "interfaceYn",
             rcp.COMMENTS AS "comments",
             rcp.ENTER_BY AS "enterBy",
             rcp.ENTER_DATE AS "enterDate",
             rcp.ORGANIZATION_ID AS "organizationId"${barcode}`;
  }

  /**
   * 일괄 취소 — PB cb_batch.clicked 이식.
   * 한 건이라도 실패하면 전체 롤백한다 (PB 의 `rollback; return` 과 동일).
   */
  async cancel(dto: ReceiptCancelExecuteDto, organizationId: number, userId: string) {
    const targets = this.dedupe(dto.targets);
    if (targets.length === 0) throw new BadRequestException('취소할 입고건이 없습니다.');
    const cancelDate = parseDateStart(dto.cancelDate) ?? new Date(NaN);
    if (Number.isNaN(cancelDate.getTime())) throw new BadRequestException('취소일자가 올바르지 않습니다.');

    return this.tx.run(async (qr) => {
      const firstDay = await this.firstDayOfMonth(qr);
      const cancelled: ReceiptCancelTargetDto[] = [];
      const skipped: ReceiptCancelTargetDto[] = [];

      for (const target of targets) {
        const receiptDate = new Date(target.receiptDate);
        // PB: Gvs_allow_last_mm_receipt_cancel 이 'Y' 가 아니면 전월 이월분은 건너뛴다
        if (dto.allowLastMonth !== 'Y' && receiptDate < firstDay) {
          skipped.push(target);
          continue;
        }
        await this.cancelOne(qr, target, receiptDate, cancelDate, organizationId, userId);
        cancelled.push(target);
      }

      if (cancelled.length === 0) {
        throw new BadRequestException('전월 이월 입고분이라 취소된 건이 없습니다. 전월 취소 허용을 체크하세요.');
      }
      return { cancelled: cancelled.length, skipped: skipped.length, skippedTargets: skipped };
    });
  }

  /**
   * f_mat_receipt_cancel 1건 처리 — PB f_mat_receipt_cancel → PKG_MES_MAT.SP_RECEIPT_CANCEL 전환.
   *
   * 상계 로직(상태 'C' + 부호 반전 행 INSERT)은 DB 프로시저가 단일 출처다.
   * PB 화면과 웹이 같은 오브젝트를 호출하므로 두 시스템이 갈리지 않는다.
   * 결과코드: 1 성공 / -1 조회·INSERT 실패 / -2 이미 취소됨 / -3 UPDATE 실패
   */
  private async cancelOne(
    qr: QueryRunner,
    target: ReceiptCancelTargetDto,
    receiptDate: Date,
    cancelDate: Date,
    organizationId: number,
    userId: string,
  ): Promise<void> {
    // OUT 바인드를 쓰면 서비스에서 oracledb 드라이버를 직접 import 해야 하므로,
    // 익명 블록에서 결과코드를 Oracle 오류로 바꿔 던지게 한다 (PB 의 rollback; return 과 동일).
    try {
      await qr.query(
        `DECLARE
           v_result NUMBER;
         BEGIN
           PKG_MES_MAT.SP_RECEIPT_CANCEL(:receiptDate, :receiptSequence, :cancelDate,
                                         :organizationId, :userId, v_result);
           IF v_result <> 1 THEN
             RAISE_APPLICATION_ERROR(-20001, 'RECEIPT_CANCEL_FAILED:' || v_result);
           END IF;
         END;`,
        {
          receiptDate,
          receiptSequence: target.receiptSequence,
          cancelDate,
          organizationId,
          userId,
        } as unknown as unknown[],
      );
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : String(error);
      const matched = /RECEIPT_CANCEL_FAILED:(-?\d+)/.exec(message);
      if (!matched) throw error;
      const reason =
        matched[1] === '-2' ? '이미 취소된 입고건입니다'
        : matched[1] === '-3' ? '입고건 상태 변경에 실패했습니다'
        : '입고건을 찾을 수 없습니다';
      throw new BadRequestException(`${reason} (순번 ${target.receiptSequence}).`);
    }
  }

  /** PB f_get_first_day() — 당월 1일 */
  private async firstDayOfMonth(qr: QueryRunner): Promise<Date> {
    const rows = await qr.query(
      `SELECT TO_DATE(TO_CHAR(SYSDATE, 'YYYYMM') || '01', 'YYYYMMDD') AS "firstDay" FROM DUAL`,
    ) as OracleRow[];
    return new Date(String(rows[0]?.firstDay));
  }

  /** 바코드 LEFT JOIN 으로 같은 입고건이 여러 행으로 보일 수 있어 PK 기준으로 중복을 제거한다 */
  private dedupe(targets: ReceiptCancelTargetDto[]): ReceiptCancelTargetDto[] {
    const seen = new Map<string, ReceiptCancelTargetDto>();
    for (const target of targets) {
      seen.set(`${new Date(target.receiptDate).getTime()}|${target.receiptSequence}`, target);
    }
    return [...seen.values()];
  }

  private like(value?: string): string {
    const trimmed = value?.trim();
    return trimmed ? `${trimmed}%` : '%';
  }
}

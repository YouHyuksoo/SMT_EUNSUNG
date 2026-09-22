/**
 * @file src/modules/material/services/receipt-cancel.service.ts
 * @description 자재입고취소 — PB w_mat_receipt_cancel_master + f_mat_receipt_cancel 이식
 *
 * 취소는 행 삭제가 아니라 **상계(역분개)** 다:
 * 1. 원본 입고행의 RECEIPT_STATUS 를 'C' 로 바꾼다.
 * 2. SEQ_MAT_RECEIPT.NEXTVAL 로 새 순번을 받아 수량·금액을 음수로 뒤집은 행을 INSERT 한다.
 *    (RECEIPT_DEFICIT 는 1↔2 로 뒤집고, 입고일자는 사용자가 지정한 취소일자를 쓴다)
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

/** 상계 INSERT 시 부호를 뒤집는 수량/금액 컬럼 */
const NEGATED = ['RECEIPT_QTY', 'MATERIAL_COST', 'MATERIAL_COST_AMT', 'RECEIPT_AMT', 'FOREIGN_RECEIPT_AMT'];

/** 원본에서 그대로 복사하는 컬럼 (부호 반전·값 대체 대상 제외) */
const COPIED = [
  'LOCATION_CODE', 'DELIVERY', 'LINE_TYPE', 'UNIT_PRICE', 'INVOICE_NO', 'EXCHANGE_RATE',
  'CONFIRM_YN', 'CONFIRM_DATE', 'RECEIPT_TYPE', 'MATERIAL_MFS', 'MFS', 'SUPPLIER_CODE',
  'COMMENTS', 'CURRENCY', 'BARCODE', 'ITEM_CODE', 'ARRIVAL_DATE', 'ARRIVAL_SEQ_NO',
  'ORGANIZATION_ID', 'VIRTUAL_RECEIPT_YN', 'WORK_ORDER_NO', 'INTERFACE_YN', 'INTERFACE_DATE',
  'RECEIPT_LOT_NO', 'INCIDENTAL_EXPENSE_CODE', 'RECEIPT_EXPENSE_COST', 'INTERFACE_WORK_NO',
  'TARIFF_RATE', 'TARIFF_AMT', 'ORDER_NO', 'ORIGIN_MFS', 'ORIGIN_SUPPLIER_CODE',
  'INVOICE_OPEN_YN', 'INVOICE_OPEN_SEQUENCE', 'INVENTORY_TYPE',
];

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

  /** f_mat_receipt_cancel 1건 처리: 원본 상태 'C' → 상계 행 INSERT */
  private async cancelOne(
    qr: QueryRunner,
    target: ReceiptCancelTargetDto,
    receiptDate: Date,
    cancelDate: Date,
    organizationId: number,
    userId: string,
  ): Promise<void> {
    const key = { receiptDate, receiptSequence: target.receiptSequence, organizationId };
    const current = await qr.query(
      `SELECT RECEIPT_STATUS AS "status" FROM IM_ITEM_RECEIPT
        WHERE RECEIPT_DATE = :receiptDate AND RECEIPT_SEQUENCE = :receiptSequence
          AND ORGANIZATION_ID = :organizationId FOR UPDATE`,
      key as unknown as unknown[],
    ) as OracleRow[];
    if (current.length !== 1) {
      throw new BadRequestException(`입고건을 찾을 수 없습니다 (순번 ${target.receiptSequence}).`);
    }
    if (current[0].status === 'C') {
      throw new BadRequestException(`이미 취소된 입고건입니다 (순번 ${target.receiptSequence}).`);
    }

    await qr.query(
      `UPDATE IM_ITEM_RECEIPT SET RECEIPT_STATUS = 'C'
        WHERE RECEIPT_DATE = :receiptDate AND RECEIPT_SEQUENCE = :receiptSequence
          AND ORGANIZATION_ID = :organizationId`,
      key as unknown as unknown[],
    );

    const copied = COPIED.join(', ');
    const negated = NEGATED.map((column) => `${column} * -1`).join(', ');
    await qr.query(
      `INSERT INTO IM_ITEM_RECEIPT (
         RECEIPT_SEQUENCE, RECEIPT_DATE, RECEIPT_DEFICIT, RECEIPT_STATUS,
         ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE,
         ${NEGATED.join(', ')}, ${copied}
       )
       SELECT SEQ_MAT_RECEIPT.NEXTVAL, TRUNC(:cancelDate), DECODE(RECEIPT_DEFICIT, '1', '2', '2', '1'), 'C',
              :userId, SYSDATE, :userId, SYSDATE,
              ${negated}, ${copied}
         FROM IM_ITEM_RECEIPT
        WHERE RECEIPT_DATE = :receiptDate AND RECEIPT_SEQUENCE = :receiptSequence
          AND ORGANIZATION_ID = :organizationId`,
      { cancelDate, userId, ...key } as unknown as unknown[],
    );
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

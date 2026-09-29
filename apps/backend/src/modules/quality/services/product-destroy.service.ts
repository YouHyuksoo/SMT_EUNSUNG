/**
 * @file src/modules/quality/services/product-destroy.service.ts
 * @description 공정폐기관리 — PB w_pln_product_pcb_destroy_master 이식
 *
 * 폐기는 행 삭제가 아니라 **이력 적재**다. IP_PRODUCT_WORK_QC 에
 * QC_INSPECT_HANDLING='D'(폐기), RECEIPT_DEFICIT='1'(입고) 행을 시리얼당 1건 INSERT 한다.
 * 같은 테이블을 공정수리이력조회(repair-history)도 쓴다.
 *
 * PB 원본과의 의도적 차이 (사용자 합의):
 * - Issue Cancel 이 원본에서는 WHERE 에 QC_SEQUENCE 가 빠져 있어 해당 시리얼의 모든 행이
 *   되돌아갔다. Issue 와 대칭이 되도록 QC_SEQUENCE 조건을 넣었다.
 * - 폐기이력 종료일이 원본에서는 `QC_DATE <= :dateEnd`(자정)라 종료일 당일이 빠졌다.
 *   공정수리이력조회와 동일하게 `< :dateEnd + 1` 로 맞춰 종료일을 포함한다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource, QueryRunner } from 'typeorm';
import { parseDateStart } from '../../../shared/date.util';
import { TransactionService } from '../../../shared/transaction.service';
import {
  ProductDestroyExecuteDto,
  ProductDestroyHistoryQueryDto,
  ProductDestroyIssueDto,
} from '../dto/product-destroy.dto';

type OracleRow = Record<string, unknown>;

/** 시리얼 단건 조회 결과에서 쓰는 불량구분 — 1=입고(폐기대상), 2=반품(Issue 처리됨) */
const DEFICIT_RECEIPT = '1';
const DEFICIT_ISSUE = '2';

export interface DestroyOutcome {
  serialNo: string;
  status: 'OK' | 'SKIP' | 'FAIL';
  reason?: string;
  qcSequence?: number;
}

@Injectable()
export class ProductDestroyService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  /** PB d_pln_product_destroy_hst — 폐기이력 */
  async findHistory(query: ProductDestroyHistoryQueryDto, organizationId: number) {
    const binds: Record<string, unknown> = {
      organizationId,
      lineCode: this.like(query.lineCode),
      workstageCode: this.like(query.workstageCode),
      modelName: this.like(query.modelName),
      serialNo: this.like(query.serialNo),
      dateFrom: parseDateStart(query.dateFrom) ?? new Date(1900, 0, 1),
      dateTo: parseDateStart(query.dateTo) ?? new Date(9999, 11, 30),
    };
    const from = `
      FROM IP_PRODUCT_WORK_QC qc
      WHERE qc.ORGANIZATION_ID = :organizationId
        AND qc.QC_INSPECT_HANDLING = 'D'
        AND NVL(qc.LINE_CODE, '*') LIKE :lineCode
        AND NVL(qc.WORKSTAGE_CODE, '*') LIKE :workstageCode
        AND NVL(qc.MODEL_NAME, '*') LIKE :modelName
        AND NVL(qc.SERIAL_NO, '*') LIKE :serialNo
        AND qc.QC_DATE >= :dateFrom
        AND qc.QC_DATE < :dateTo + 1`;
    const select = `${this.selectList()} ${from}
      ORDER BY qc.QC_DATE DESC, qc.QC_SEQUENCE DESC
      OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`;
    const offset = (query.page - 1) * query.limit;
    const rows = await this.dataSource.query(
      select, { ...binds, offset, limit: query.limit } as unknown as unknown[],
    ) as OracleRow[];
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" ${from}`, binds as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page: query.page, limit: query.limit };
  }

  /** PB dw_1 / dw_2 — 시리얼 하나의 폐기(1) / 반품(2) 현황 */
  async findBySerial(serialNo: string, organizationId: number) {
    const binds = { organizationId, serialNo: this.like(serialNo) };
    const load = async (deficit: string): Promise<OracleRow[]> => await this.dataSource.query(
      `${this.selectList()}
       FROM IP_PRODUCT_WORK_QC qc
       WHERE qc.ORGANIZATION_ID = :organizationId
         AND qc.SERIAL_NO LIKE :serialNo
         AND qc.RECEIPT_DEFICIT = '${deficit}'
       ORDER BY qc.QC_SEQUENCE`,
      binds as unknown as unknown[],
    ) as OracleRow[];
    const [destroyList, issueList] = await Promise.all([load(DEFICIT_RECEIPT), load(DEFICIT_ISSUE)]);
    return { destroyList, issueList };
  }

  /**
   * PB cb_2(Destroy) — 시리얼 목록을 순회하며 폐기 이력을 등록한다.
   * PB 는 행마다 OK/FAIL 을 찍고 계속 진행하므로 전체 롤백하지 않는다.
   * 다만 시리얼 1건의 처리는 트랜잭션으로 묶어 부분 저장을 막는다.
   */
  async destroy(dto: ProductDestroyExecuteDto, organizationId: number, userId: string) {
    const serials = [...new Set(dto.serialNos.map(s => s.trim().toUpperCase()).filter(Boolean))];
    if (serials.length === 0) throw new BadRequestException('폐기할 시리얼이 없습니다.');

    const results: DestroyOutcome[] = [];
    for (const serialNo of serials) {
      try {
        results.push(await this.tx.run(qr => this.destroyOne(qr, serialNo, dto, organizationId, userId)));
      } catch (error: unknown) {
        results.push({ serialNo, status: 'FAIL', reason: this.message(error) });
      }
    }
    return {
      ok: results.filter(r => r.status === 'OK').length,
      skip: results.filter(r => r.status === 'SKIP').length,
      fail: results.filter(r => r.status === 'FAIL').length,
      results,
    };
  }

  private async destroyOne(
    qr: QueryRunner,
    serialNo: string,
    dto: ProductDestroyExecuteDto,
    organizationId: number,
    userId: string,
  ): Promise<DestroyOutcome> {
    // PB: dw_1.retrieve 결과가 있으면 이미 처리된 것으로 보고 건너뛴다
    const existing = await qr.query(
      `SELECT QC_SEQUENCE AS "qcSequence" FROM IP_PRODUCT_WORK_QC
        WHERE ORGANIZATION_ID = :organizationId AND SERIAL_NO = :serialNo
          AND RECEIPT_DEFICIT = '${DEFICIT_RECEIPT}'`,
      { organizationId, serialNo } as unknown as unknown[],
    ) as OracleRow[];
    if (existing.length > 0) {
      return { serialNo, status: 'SKIP', reason: '이미 폐기 처리된 시리얼입니다.' };
    }

    // PB: IP_PRODUCT_2D_BARCODE 에서 품목/모델을 가져온다. 없으면 진행 불가.
    const barcode = await qr.query(
      `SELECT DISTINCT ITEM_CODE AS "itemCode", MODEL_NAME AS "modelName", MODEL_SUFFIX AS "modelSuffix"
         FROM IP_PRODUCT_2D_BARCODE
        WHERE SERIAL_NO = :serialNo AND ORGANIZATION_ID = :organizationId`,
      { serialNo, organizationId } as unknown as unknown[],
    ) as OracleRow[];
    if (barcode.length === 0) {
      return { serialNo, status: 'FAIL', reason: '시리얼의 품목/모델 정보를 찾을 수 없습니다.' };
    }

    // PB: 최신 공정이력(MAX(WIP_SEQ))의 라인/공정. 없으면 화면 드롭다운 값, 그것도 없으면 '*'
    const io = await qr.query(
      `SELECT LINE_CODE AS "lineCode", WORKSTAGE_CODE AS "workstageCode"
         FROM IP_PRODUCT_WORKSTAGE_IO
        WHERE SERIAL_NO = :serialNo
          AND WIP_SEQ = (SELECT MAX(WIP_SEQ) FROM IP_PRODUCT_WORKSTAGE_IO WHERE SERIAL_NO = :serialNo)`,
      { serialNo } as unknown as unknown[],
    ) as OracleRow[];
    const lineCode = String(io[0]?.lineCode ?? this.fallback(dto.fallbackLineCode));
    const workstageCode = String(io[0]?.workstageCode ?? this.fallback(dto.fallbackWorkstageCode));

    await qr.query(
      `INSERT INTO IP_PRODUCT_WORK_QC (
         QC_SEQUENCE, SERIAL_NO, ORGANIZATION_ID,
         ITEM_CODE, MODEL_NAME, MODEL_SUFFIX,
         LINE_CODE, WORKSTAGE_CODE, MACHINE_CODE,
         REPAIR_LINE_CODE, REPAIR_WORKSTAGE_CODE, LOCATION_CODE,
         BAD_REASON_CODE, QC_RESULT, RECEIPT_DEFICIT, QC_INSPECT_HANDLING,
         BAD_QTY, DEFECT_QTY, QC_DATE, SHIFT_CODE,
         CHARGER, REPAIR_BY, ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE
       ) VALUES (
         SEQ_QC_REPAIR_SEQUENCE.NEXTVAL, :serialNo, :organizationId,
         :itemCode, :modelName, :modelSuffix,
         :lineCode, :workstageCode, '*',
         '*', '*', '* *',
         :badReasonCode, 'N', '${DEFICIT_RECEIPT}', 'D',
         1, 1, SYSDATE, NVL(F_GET_WORK_SHIFT_CODE(SYSDATE), '1'),
         :userId, :userId, :userId, SYSDATE, :userId, SYSDATE
       )`,
      {
        serialNo, organizationId,
        itemCode: barcode[0].itemCode, modelName: barcode[0].modelName, modelSuffix: barcode[0].modelSuffix,
        lineCode, workstageCode, badReasonCode: dto.badReasonCode, userId,
      } as unknown as unknown[],
    );

    const created = await qr.query(
      `SELECT MAX(QC_SEQUENCE) AS "qcSequence" FROM IP_PRODUCT_WORK_QC
        WHERE SERIAL_NO = :serialNo AND ORGANIZATION_ID = :organizationId
          AND RECEIPT_DEFICIT = '${DEFICIT_RECEIPT}'`,
      { serialNo, organizationId } as unknown as unknown[],
    ) as OracleRow[];
    return { serialNo, status: 'OK', qcSequence: Number(created[0]?.qcSequence ?? 0) };
  }

  /** PB cb_4(Issue) — 반품 처리 */
  async issue(dto: ProductDestroyIssueDto, organizationId: number) {
    return this.toggleDeficit(dto, organizationId, DEFICIT_ISSUE, 'SYSDATE');
  }

  /** PB cb_5(Issue Cancel) — 반품 취소. 원본과 달리 QC_SEQUENCE 로 1건만 되돌린다. */
  async issueCancel(dto: ProductDestroyIssueDto, organizationId: number) {
    return this.toggleDeficit(dto, organizationId, DEFICIT_RECEIPT, 'NULL');
  }

  private async toggleDeficit(
    dto: ProductDestroyIssueDto,
    organizationId: number,
    deficit: string,
    repairDate: 'SYSDATE' | 'NULL',
  ) {
    const key = { serialNo: dto.serialNo, qcSequence: dto.qcSequence, organizationId };
    const found = await this.dataSource.query(
      `SELECT RECEIPT_DEFICIT AS "deficit" FROM IP_PRODUCT_WORK_QC
        WHERE SERIAL_NO = :serialNo AND QC_SEQUENCE = :qcSequence AND ORGANIZATION_ID = :organizationId`,
      key as unknown as unknown[],
    ) as OracleRow[];
    if (found.length === 0) throw new BadRequestException('대상 이력을 찾을 수 없습니다.');
    if (found[0].deficit === deficit) throw new BadRequestException('이미 해당 상태입니다.');

    await this.dataSource.query(
      `UPDATE IP_PRODUCT_WORK_QC
          SET RECEIPT_DEFICIT = '${deficit}', REPAIR_DATE = ${repairDate}
        WHERE SERIAL_NO = :serialNo AND QC_SEQUENCE = :qcSequence AND ORGANIZATION_ID = :organizationId`,
      key as unknown as unknown[],
    );
    return { serialNo: dto.serialNo, qcSequence: dto.qcSequence, receiptDeficit: deficit };
  }

  private selectList(): string {
    return `
      SELECT qc.QC_SEQUENCE AS "qcSequence",
             qc.SERIAL_NO AS "serialNo",
             qc.ITEM_CODE AS "itemCode",
             qc.MODEL_NAME AS "modelName",
             qc.MODEL_SUFFIX AS "modelSuffix",
             qc.LINE_CODE AS "lineCode",
             qc.WORKSTAGE_CODE AS "workstageCode",
             qc.BAD_REASON_CODE AS "badReasonCode",
             qc.QC_RESULT AS "qcResult",
             qc.RECEIPT_DEFICIT AS "receiptDeficit",
             qc.QC_INSPECT_HANDLING AS "qcInspectHandling",
             qc.BAD_QTY AS "badQty",
             qc.DEFECT_QTY AS "defectQty",
             qc.QC_DATE AS "qcDate",
             qc.REPAIR_DATE AS "repairDate",
             qc.SHIFT_CODE AS "shiftCode",
             qc.CHARGER AS "charger",
             qc.REPAIR_BY AS "repairBy",
             qc.LOCATION_CODE AS "locationCode",
             qc.COMMENTS AS "comments",
             qc.ENTER_BY AS "enterBy",
             qc.ENTER_DATE AS "enterDate",
             qc.ORGANIZATION_ID AS "organizationId"`;
  }

  /** PB: 드롭다운이 비었거나 전체('%')면 '*' 를 쓴다 */
  private fallback(value?: string): string {
    const trimmed = value?.trim();
    return !trimmed || trimmed === '%' ? '*' : trimmed;
  }

  private like(value?: string): string {
    const trimmed = value?.trim();
    return trimmed ? `${trimmed}%` : '%';
  }

  private message(error: unknown): string {
    if (error instanceof BadRequestException) return error.message;
    return error instanceof Error ? error.message : '알 수 없는 오류';
  }
}

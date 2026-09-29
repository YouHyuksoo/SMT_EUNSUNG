/**
 * @file src/modules/quality/services/repair-query.service.ts
 * @description 281 공정수리이력조회 — PB `w_pln_product_pcb_repair_query` 의 요약 뷰 이식
 *
 * 초보자 가이드:
 * 1. **이력 목록은 이미 있다.** `/quality/repair-history` 가 같은 표
 *    (`IP_PRODUCT_WORK_QC`)의 이력을 그대로 낸다 — PB 의 `d_pln_product_work_qc_hst_q`
 *    와 같은 DataWindow 다. 그래서 **목록은 다시 만들지 않고** 이 파일은
 *    그 화면에 없던 **요약 두 가지**만 더한다.
 * 2. **일별요약**: 날짜 × 불량사유로 불량수량을 모은다.
 *    **위치별요약**: 위치(LOCATION_CODE) × 불량사유로 모은다 — 같은 자리에서
 *    같은 불량이 반복되는지 보는 것이 이 화면의 목적이다.
 * 3. **PB 는 DataWindow 크로스탭으로 모았다.** 웹은 SQL 에서 모은다 — 행 수가
 *    줄어 화면이 가볍고, 합계가 잘린 창 안에서 계산되는 일이 없다.
 * 4. **불량사유 이름은 DB 함수가 낸다** (`F_GET_CODE_MASTER`). SQL 안에서 부르던
 *    것이라 그대로 호출한다 — 코드표를 TypeScript 에 복사하지 않는다.
 * 5. 조회 전용이다. 실측 `IP_PRODUCT_WORK_QC` 72,870건, 마지막이 어제다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { limited, ROW_LIMIT } from '../../../shared/row-limit';
import { RepairQueryDto } from '../dto/repair-query.dto';

type Row = Record<string, unknown>;

@Injectable()
export class RepairQueryService {
  constructor(private readonly dataSource: DataSource) {}

  /** 일별 × 불량사유 요약 (PB `d_pln_product_work_qc_4_daily_summary_lst_q`). */
  async findDailySummary(query: RepairQueryDto, organizationId: number) {
    return this.summary(query, organizationId, 'daily');
  }

  /** 위치별 × 불량사유 요약 (PB `d_pln_product_work_qc_4_position_summary_lst_q`). */
  async findPositionSummary(query: RepairQueryDto, organizationId: number) {
    return this.summary(query, organizationId, 'position');
  }

  /**
   * 두 요약은 묶는 기준만 다르다 — 날짜냐 위치냐. 조건·집계·함수 호출이 같아
   * 한 곳에서 만든다.
   */
  private async summary(
    query: RepairQueryDto,
    organizationId: number,
    kind: 'daily' | 'position',
  ) {
    const groupKey = kind === 'daily'
      ? `TO_CHAR(TRUNC(qc.QC_DATE), 'YYYY-MM-DD')`
      : `NVL(qc.LOCATION_CODE, '-')`;

    const rows = (await this.dataSource.query(
      `SELECT ${groupKey}           AS "groupKey",
              qc.MODEL_NAME         AS "modelName",
              qc.BAD_REASON_CODE    AS "badReasonCode",
              -- 코드 이름은 DB 함수가 낸다 (PB 가 SQL 안에서 부르던 것 그대로).
              F_GET_CODE_MASTER('WQC BAD REASON CODE', qc.BAD_REASON_CODE,
                                :lang, qc.ORGANIZATION_ID) AS "badReasonName",
              COUNT(*)              AS "qcCount",
              SUM(NVL(qc.BAD_QTY, 0)) AS "badQty"
         FROM IP_PRODUCT_WORK_QC qc
        WHERE qc.ORGANIZATION_ID = :organizationId
          AND qc.QC_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND qc.QC_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(qc.LINE_CODE, '*') LIKE :lineCode
          AND NVL(qc.MODEL_NAME, '*') LIKE :modelName
        GROUP BY ${groupKey}, qc.MODEL_NAME, qc.BAD_REASON_CODE, qc.ORGANIZATION_ID
        ORDER BY 1 DESC, 6 DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        organizationId,
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        lineCode: this.like(query.lineCode),
        modelName: this.like(query.modelName),
        lang: query.lang ?? 'KOR',
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  private like(value?: string) {
    const trimmed = (value ?? '').trim();
    return trimmed ? `%${trimmed}%` : '%';
  }
}

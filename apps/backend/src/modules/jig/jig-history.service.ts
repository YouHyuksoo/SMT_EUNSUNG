/**
 * @file src/modules/jig/jig-history.service.ts
 * @description 지그·샘플 이력조회 3종 — PB DataWindow 의 retrieve SQL 을 그대로 옮긴다.
 *
 * 원본:
 *   d_mcn_jig_input_history_query        (w_mcn_jig_input_history_master)
 *   d_mcn_sample_input_history_query     (w_mcn_sample_input_history_master)
 *   d_mcn_sample_bcr_input_history_query (w_mcn_sample_bcr_input_history_master)
 *
 * PB 는 조회조건을 `값 + '%'` 로 만들어 LIKE 에 넘긴다. 빈 값이면 '%' 가 되어 전체 조회다.
 * 웹도 같은 규약을 쓴다 — 조건을 IS NULL 분기로 바꾸면 PB 와 결과가 달라진다.
 * 코드컬럼(JIG_TYPE/SAMPLE_TYPE/LINE_CODE)은 그리드에 코드가 아니라 뜻이 보이도록
 * ISYS_BASECODE·IP_PRODUCT_LINE 을 조인해 이름을 함께 내린다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import {
  JigInputHistoryQueryDto,
  SampleBcrHistoryQueryDto,
  SampleInputHistoryQueryDto,
} from './jig-history.dto';

type OracleRow = Record<string, unknown>;

const DEFAULT_LIMIT = 500;

@Injectable()
export class JigHistoryService {
  constructor(private readonly dataSource: DataSource) {}

  /** PB 규약: 빈 값이면 '%' 가 되어 전체를 조회한다. */
  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  private async page(body: string, orderBy: string, binds: OracleRow, page: number, limit: number) {
    const totals = await this.dataSource.query(
      `SELECT COUNT(*) AS "total" FROM (${body}) source_rows`,
      { ...binds } as unknown as unknown[],
    ) as OracleRow[];
    const rows = await this.dataSource.query(
      `${body} ${orderBy} OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY`,
      { ...binds, offset: (page - 1) * limit, limit } as unknown as unknown[],
    ) as OracleRow[];
    return { data: rows, total: Number(totals[0]?.total ?? 0), page, limit };
  }

  /** 라인·기초코드 이름 조인 (코드만 뿌리지 않기 위해) */
  private nameJoins(alias: string, typeColumn: string, codeType: string) {
    return `
      LEFT JOIN IP_PRODUCT_LINE ln
             ON ln.LINE_CODE = ${alias}.LINE_CODE
            AND ln.ORGANIZATION_ID = ${alias}.ORGANIZATION_ID
      LEFT JOIN ISYS_BASECODE bc
             ON bc.CODE_TYPE = '${codeType}'
            AND bc.CODE_NAME = ${alias}.${typeColumn}
            AND bc.ORGANIZATION_ID = ${alias}.ORGANIZATION_ID`;
  }

  /** 지그 투입이력 — d_mcn_jig_input_history_query */
  async findJigInputHistory(query: JigInputHistoryQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      dateFrom: query.dateFrom ?? '1900-01-01',
      dateTo: query.dateTo ?? '2999-12-31',
      lineCode: this.like(query.lineCode),
      jigType: this.like(query.jigType),
      jigLotNo: this.like(query.jigLotNo),
      modelItem: this.like(query.modelItem),
    };
    const body = `
      SELECT h.INPUT_DATE AS "inputDate",
             h.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
             h.JIG_TYPE AS "jigType", bc.CODE_MEAN_KOR AS "jigTypeName",
             h.JIG_CODE AS "jigCode", h.JIG_LOT_NO AS "jigLotNo",
             j.JIG_SPEC AS "jigSpec", j.SOLDER_TYPE AS "solderType",
             h.CURRENT_HIT_VALUE AS "currentHitValue",
             r.RUN_NO AS "runNo", r.ITEM_CODE AS "itemCode", r.MODEL_NAME AS "modelName",
             h.MODEL_NAME AS "inputModelName",
             h.ENTER_BY AS "enterBy", h.ENTER_DATE AS "enterDate",
             h.LAST_MODIFY_BY AS "lastModifyBy", h.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IMCN_JIG_INPUT_HIST h
        JOIN IP_PRODUCT_RUN_CARD r
          ON h.RUN_NO = r.RUN_NO AND h.ORGANIZATION_ID = r.ORGANIZATION_ID
        JOIN IMCN_JIG j
          ON h.JIG_CODE = j.JIG_CODE AND h.JIG_LOT_NO = j.JIG_LOT_NO
         AND h.ORGANIZATION_ID = j.ORGANIZATION_ID
        ${this.nameJoins('h', 'JIG_TYPE', 'JIG TYPE')}
       WHERE h.INPUT_DATE >= TRUNC(TO_DATE(:dateFrom, 'YYYY-MM-DD'))
         AND h.INPUT_DATE < TRUNC(TO_DATE(:dateTo, 'YYYY-MM-DD')) + 1
         AND h.LINE_CODE LIKE :lineCode
         AND h.JIG_TYPE LIKE :jigType
         AND h.JIG_LOT_NO LIKE :jigLotNo
         AND r.ITEM_CODE LIKE :modelItem
         AND h.ORGANIZATION_ID = :organizationId`;
    return this.page(body, 'ORDER BY "inputDate" DESC, "jigCode", "jigLotNo"',
      binds, query.page ?? 1, query.limit ?? DEFAULT_LIMIT);
  }

  /** 샘플마스터 장착이력 — d_mcn_sample_input_history_query */
  async findSampleInputHistory(query: SampleInputHistoryQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      dateFrom: query.dateFrom ?? '1900-01-01',
      dateTo: query.dateTo ?? '2999-12-31',
      lineCode: this.like(query.lineCode),
      sampleType: this.like(query.sampleType),
      sampleLotNo: this.like(query.sampleLotNo),
      modelItem: this.like(query.modelItem),
    };
    const body = `
      SELECT h.INPUT_DATE AS "inputDate",
             h.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
             h.SAMPLE_TYPE AS "sampleType", bc.CODE_MEAN_KOR AS "sampleTypeName",
             h.SAMPLE_CODE AS "sampleCode", h.SAMPLE_LOT_NO AS "sampleLotNo",
             j.SAMPLE_SPEC AS "sampleSpec",
             h.CURRENT_APPLY_DATE AS "currentApplyDate", j.SAMPLE_APPLY_DATE AS "sampleApplyDate",
             r.RUN_NO AS "runNo", r.ITEM_CODE AS "itemCode", r.MODEL_NAME AS "modelName",
             h.MODEL_NAME AS "inputModelName",
             h.ENTER_BY AS "enterBy", h.ENTER_DATE AS "enterDate",
             h.LAST_MODIFY_BY AS "lastModifyBy", h.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IMCN_SAMPLE_INPUT_HIST h
        JOIN IP_PRODUCT_RUN_CARD r
          ON h.RUN_NO = r.RUN_NO AND h.ORGANIZATION_ID = r.ORGANIZATION_ID
        JOIN IMCN_SAMPLE j
          ON h.SAMPLE_CODE = j.SAMPLE_CODE AND h.SAMPLE_LOT_NO = j.SAMPLE_LOT_NO
         AND h.ORGANIZATION_ID = j.ORGANIZATION_ID
        ${this.nameJoins('h', 'SAMPLE_TYPE', 'SAMPLE TYPE')}
       WHERE h.INPUT_DATE >= TRUNC(TO_DATE(:dateFrom, 'YYYY-MM-DD'))
         AND h.INPUT_DATE < TRUNC(TO_DATE(:dateTo, 'YYYY-MM-DD')) + 1
         AND h.LINE_CODE LIKE :lineCode
         AND h.SAMPLE_TYPE LIKE :sampleType
         AND h.SAMPLE_LOT_NO LIKE :sampleLotNo
         AND r.ITEM_CODE LIKE :modelItem
         AND h.ORGANIZATION_ID = :organizationId`;
    return this.page(body, 'ORDER BY "inputDate" DESC, "sampleCode", "sampleLotNo"',
      binds, query.page ?? 1, query.limit ?? DEFAULT_LIMIT);
  }

  /**
   * 샘플마스터 투입이력(BCR) — d_mcn_sample_bcr_input_history_query
   * PB 의 rb_ng 모드는 같은 테이블에서 판정결과가 NG 인 행만 본다.
   */
  async findSampleBcrHistory(query: SampleBcrHistoryQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      dateFrom: query.dateFrom ?? '1900-01-01',
      dateTo: query.dateTo ?? '2999-12-31',
      lineCode: this.like(query.lineCode),
      sampleType: this.like(query.sampleType),
      sampleLotNo: this.like(query.sampleLotNo),
    };
    const ngOnly = query.mode === 'NG' ? "AND UPPER(h.INSPECT_RESULT) = 'NG'" : '';
    const body = `
      SELECT h.INPUT_DATE AS "inputDate",
             h.LINE_CODE AS "lineCode", ln.LINE_NAME AS "lineName",
             h.WORKSTAGE_CODE AS "workstageCode", ws.WORKSTAGE_NAME AS "workstageName",
             h.RUN_NO AS "runNo", h.MODEL_NAME AS "modelName",
             h.SAMPLE_TYPE AS "sampleType", bc.CODE_MEAN_KOR AS "sampleTypeName",
             h.SAMPLE_SECTION AS "sampleSection",
             h.SAMPLE_LOT_NO AS "sampleLotNo", h.SAMPLE_BARCODE AS "sampleBarcode",
             h.INSPECT_RESULT AS "inspectResult"
        FROM IMCN_SAMPLE_BCR_INPUT_HIST h
        LEFT JOIN IP_PRODUCT_WORKSTAGE ws
               ON ws.WORKSTAGE_CODE = h.WORKSTAGE_CODE
              AND ws.ORGANIZATION_ID = h.ORGANIZATION_ID
        ${this.nameJoins('h', 'SAMPLE_TYPE', 'SAMPLE TYPE')}
       WHERE h.INPUT_DATE >= TRUNC(TO_DATE(:dateFrom, 'YYYY-MM-DD'))
         AND h.INPUT_DATE < TRUNC(TO_DATE(:dateTo, 'YYYY-MM-DD')) + 1
         AND h.LINE_CODE LIKE :lineCode
         AND h.SAMPLE_TYPE LIKE :sampleType
         AND h.SAMPLE_LOT_NO LIKE :sampleLotNo
         AND h.ORGANIZATION_ID = :organizationId
         ${ngOnly}`;
    return this.page(body, 'ORDER BY "inputDate" DESC, "sampleLotNo"',
      binds, query.page ?? 1, query.limit ?? DEFAULT_LIMIT);
  }
}

/**
 * @file src/modules/quality/services/iqc-history.service.ts
 * @description IQC 이력등록관리 — PB w_qc_iqc_inspect_history_master 이식
 *
 * 초보자 가이드:
 * 1. **이 테이블에는 기본키 제약이 없다.** 서버가 (검사일시 + 검사항번 + ORGANIZATION_ID)를
 *    키로 다룬다. 그래서 등록할 때 그 셋을 반드시 서버가 채워야 한다.
 *    수정·삭제는 검사일시를 ISO 로 왕복시키지 않고 목록이 내려준 불투명 키
 *    TO_CHAR(INSPECT_DATE,'YYYYMMDDHH24MISS') 로 잡는다 — JSON 직렬화가 Date 를 UTC 로
 *    바꿔 KST 저장값과 9시간 밀리기 때문이다(실측 확인).
 * 2. **PB 는 두 모드로 갈려 있었다** — 상세/집계. 같은 테이블에 컬럼 집합만 달랐고,
 *    집계 모드에서만 검사일시·항번을 채워줬다. 상세 모드는 사용자 입력에 맡겨
 *    키가 빈 행이 생길 수 있었다. 웹은 한 경로로 합치고 항상 서버가 채운다.
 * 3. **항번은 SEQ_IQC_INSPECT_HISTORY_SEQ 로 채번한다.** PB 가 부르던 시퀀스인데
 *    이 DB 에 없어서 등록이 안 됐다. 2026-09-27 에 만들었다
 *    (MAXVALUE 999999 / CYCLE — 이 DB 의 기존 순환 시퀀스 관행).
 *    항번이 999999 에서 1 로 돌아도 검사일시가 함께 키라서 충돌하지 않는다.
 * 4. **품목코드 기본값은 '*' 다** — PB 집계 모드가 그렇게 넣었다. 비워 보내면 '*' 로 들어간다.
 */
import { Injectable, NotFoundException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { TransactionService } from '../../../shared/transaction.service';
import {
  IqcInspectHistoryCreateDto,
  IqcInspectHistoryKeyDto,
  IqcInspectHistoryQueryDto,
  IqcInspectHistoryUpdateDto,
} from '../dto/iqc-history.dto';

type OracleRow = Record<string, unknown>;

/** 등록·수정에서 사용자가 값을 넣는 컬럼. 키·감사컬럼은 여기에 없다. */
const EDITABLE: Array<[column: string, field: keyof IqcInspectHistoryCreateDto]> = [
  ['MODEL_NAME', 'modelName'], ['MODEL_SUFFIX', 'modelSuffix'],
  ['ITEM_CLASS', 'itemClass'], ['LOT_NO', 'lotNo'],
  ['DEFECT_CODE', 'defectCode'], ['INSPECT_TYPE', 'inspectType'],
  ['INSPECT_RESULT', 'inspectResult'], ['BAD_REASON_CODE', 'badReasonCode'],
  ['SUPPLIER_CODE', 'supplierCode'],
  ['INSPECTOR', 'inspector'], ['INSPECTOR_NAME', 'inspectorName'],
  ['COMMENTS', 'comments'],
  ['INSPECT_QTY', 'inspectQty'], ['DEFECT_QTY', 'defectQty'],
];

@Injectable()
export class IqcHistoryService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  private like(value?: string): string {
    return `${(value ?? '').trim()}%`;
  }

  /** 목록 — PB d_iq_iqc_insepct_history / _summary_history */
  async find(query: IqcInspectHistoryQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      dateFrom: query.dateFrom.slice(0, 10),
      dateTo: query.dateTo.slice(0, 10),
      modelName: this.like(query.modelName),
      itemCode: this.like(query.itemCode),
      itemClass: this.like(query.itemClass),
      inspectType: this.like(query.inspectType),
      inspectResult: this.like(query.inspectResult),
      lotNo: this.like(query.lotNo),
    };
    const body = `
      SELECT h.INSPECT_DATE AS "inspectDate", h.INSPECT_SEQUENCE AS "inspectSequence",
             -- 수정·삭제가 쓰는 불투명 키. DATE 를 ISO 로 왕복시키면 시간대가 밀린다.
             TO_CHAR(h.INSPECT_DATE, 'YYYYMMDDHH24MISS') AS "inspectDateKey",
             h.MODEL_NAME AS "modelName", h.MODEL_SUFFIX AS "modelSuffix",
             h.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName",
             h.ITEM_CLASS AS "itemClass", cls.CODE_MEAN_KOR AS "itemClassName",
             h.LOT_NO AS "lotNo",
             h.DEFECT_CODE AS "defectCode",
             h.INSPECT_TYPE AS "inspectType",
             h.INSPECT_RESULT AS "inspectResult", res.CODE_MEAN_KOR AS "inspectResultName",
             h.BAD_REASON_CODE AS "badReasonCode", bad.CODE_MEAN_KOR AS "badReasonName",
             h.SUPPLIER_CODE AS "supplierCode", sup.SUPPLIER_NAME AS "supplierName",
             h.SHIFT_CODE AS "shiftCode",
             h.INSPECT_QTY AS "inspectQty", h.DEFECT_QTY AS "defectQty",
             h.INSPECTOR AS "inspector", h.INSPECTOR_NAME AS "inspectorName",
             h.COMMENTS AS "comments",
             h.ATTRIBUTE01 AS "attribute01", h.ATTRIBUTE02 AS "attribute02",
             h.ATTRIBUTE03 AS "attribute03", h.ATTRIBUTE04 AS "attribute04",
             h.ATTRIBUTE05 AS "attribute05",
             h.ENTER_BY AS "enterBy", h.ENTER_DATE AS "enterDate",
             h.LAST_MODIFY_BY AS "lastModifyBy", h.LAST_MODIFY_DATE AS "lastModifyDate"
        FROM IQ_IQC_INSPECT_HISTORY h
        LEFT JOIN ID_ITEM i
               ON i.ITEM_CODE = h.ITEM_CODE AND i.ORGANIZATION_ID = h.ORGANIZATION_ID
        LEFT JOIN ICOM_SUPPLIER sup
               ON sup.SUPPLIER_CODE = h.SUPPLIER_CODE
              AND sup.ORGANIZATION_ID = h.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE res
               ON res.CODE_TYPE = 'INSPECT RESULT' AND res.CODE_NAME = h.INSPECT_RESULT
              AND res.ORGANIZATION_ID = h.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE bad
               ON bad.CODE_TYPE = 'BAD REASON CODE' AND bad.CODE_NAME = h.BAD_REASON_CODE
              AND bad.ORGANIZATION_ID = h.ORGANIZATION_ID
        LEFT JOIN ISYS_BASECODE cls
               ON cls.CODE_TYPE = 'ITEM CLASS' AND cls.CODE_NAME = h.ITEM_CLASS
              AND cls.ORGANIZATION_ID = h.ORGANIZATION_ID
       WHERE h.INSPECT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
         AND h.INSPECT_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
         AND NVL(h.MODEL_NAME, '*') LIKE :modelName
         AND NVL(h.ITEM_CODE, '*') LIKE :itemCode
         AND NVL(h.ITEM_CLASS, '*') LIKE :itemClass
         AND NVL(h.INSPECT_TYPE, '*') LIKE :inspectType
         AND NVL(h.INSPECT_RESULT, '*') LIKE :inspectResult
         AND NVL(h.LOT_NO, '*') LIKE :lotNo
         AND h.ORGANIZATION_ID = :organizationId`;
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
   * 등록 — 검사일시는 지금, 항번은 SEQ_IQC_INSPECT_HISTORY_SEQ 로 서버가 채운다.
   * 교대코드도 F_GET_WORK_SHIFT_CODE 로 채운다 (PB 가 이 화면에서 쓰던 함수다).
   */
  async create(
    dto: IqcInspectHistoryCreateDto,
    organizationId: number,
    userId: string,
  ) {
    return this.tx.run(async (qr) => {
      const seq = await qr.query(
        `SELECT SEQ_IQC_INSPECT_HISTORY_SEQ.NEXTVAL AS "seq" FROM DUAL`, [],
      ) as OracleRow[];
      const inspectSequence = Number(seq[0]?.seq ?? 0);

      const columns = [
        'INSPECT_DATE', 'INSPECT_SEQUENCE', 'ORGANIZATION_ID', 'ITEM_CODE', 'SHIFT_CODE',
      ];
      const values = [
        'SYSDATE', ':inspectSequence', ':organizationId',
        `NVL(:itemCode, '*')`, 'F_GET_WORK_SHIFT_CODE(SYSDATE)',
      ];
      const binds: OracleRow = {
        inspectSequence,
        organizationId,
        itemCode: dto.itemCode?.trim() || null,
        userId,
      };
      for (const [column, field] of EDITABLE) {
        if (column === 'ITEM_CODE') continue;   // 위에서 '*' 기본값으로 이미 넣었다
        columns.push(column);
        values.push(`:${field}`);
        binds[field] = dto[field] ?? null;
      }
      columns.push('ENTER_BY', 'ENTER_DATE', 'LAST_MODIFY_BY', 'LAST_MODIFY_DATE');
      values.push(':userId', 'SYSDATE', ':userId', 'SYSDATE');

      await qr.query(
        `INSERT INTO IQ_IQC_INSPECT_HISTORY (${columns.join(', ')})
         VALUES (${values.join(', ')})`,
        binds as unknown as unknown[],
      );
      return { inspectSequence };
    });
  }

  private async exists(dto: IqcInspectHistoryKeyDto, organizationId: number) {
    const rows = await this.dataSource.query(
      `SELECT COUNT(*) AS "cnt" FROM IQ_IQC_INSPECT_HISTORY
        WHERE TO_CHAR(INSPECT_DATE, 'YYYYMMDDHH24MISS') = :inspectDateKey
          AND INSPECT_SEQUENCE = :inspectSequence
          AND ORGANIZATION_ID = :organizationId`,
      {
        inspectDateKey: dto.inspectDateKey,
        inspectSequence: dto.inspectSequence,
        organizationId,
      } as unknown as unknown[],
    ) as OracleRow[];
    return Number(rows[0]?.cnt ?? 0) > 0;
  }

  /** 수정 — 키(검사일시·항번)는 바꿀 수 없다 */
  async update(
    dto: IqcInspectHistoryUpdateDto,
    organizationId: number,
    userId: string,
  ) {
    if (!await this.exists(dto, organizationId)) {
      throw new NotFoundException('검사이력을 찾을 수 없습니다.');
    }
    const sets: string[] = [`ITEM_CODE = NVL(:itemCode, '*')`];
    const binds: OracleRow = {
      inspectDateKey: dto.inspectDateKey,
      inspectSequence: dto.inspectSequence,
      organizationId,
      itemCode: dto.itemCode?.trim() || null,
      userId,
    };
    for (const [column, field] of EDITABLE) {
      if (column === 'ITEM_CODE') continue;
      sets.push(`${column} = :${field}`);
      binds[field] = dto[field] ?? null;
    }
    sets.push('LAST_MODIFY_BY = :userId', 'LAST_MODIFY_DATE = SYSDATE');

    await this.dataSource.query(
      `UPDATE IQ_IQC_INSPECT_HISTORY SET ${sets.join(', ')}
        WHERE TO_CHAR(INSPECT_DATE, 'YYYYMMDDHH24MISS') = :inspectDateKey
          AND INSPECT_SEQUENCE = :inspectSequence
          AND ORGANIZATION_ID = :organizationId`,
      binds as unknown as unknown[],
    );
    return { inspectSequence: dto.inspectSequence };
  }

  /** 삭제 — PB 도 행을 바로 지웠다 */
  async remove(dto: IqcInspectHistoryKeyDto, organizationId: number) {
    if (!await this.exists(dto, organizationId)) {
      throw new NotFoundException('검사이력을 찾을 수 없습니다.');
    }
    await this.dataSource.query(
      `DELETE FROM IQ_IQC_INSPECT_HISTORY
        WHERE TO_CHAR(INSPECT_DATE, 'YYYYMMDDHH24MISS') = :inspectDateKey
          AND INSPECT_SEQUENCE = :inspectSequence
          AND ORGANIZATION_ID = :organizationId`,
      {
        inspectDateKey: dto.inspectDateKey,
        inspectSequence: dto.inspectSequence,
        organizationId,
      } as unknown as unknown[],
    );
    return { deleted: true };
  }
}

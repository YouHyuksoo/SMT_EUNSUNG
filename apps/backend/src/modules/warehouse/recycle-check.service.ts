/**
 * @file src/modules/warehouse/recycle-check.service.ts
 * @description 266 SMT 공릴체크 — PB w_smt_recycle_check_rpt 이식
 *
 * 초보자 가이드:
 * 1. **다 쓴 릴(공릴)을 버리기 전에 맞는지 확인한 기록이다.** 작업자가 릴 바코드를
 *    찍으면 시스템이 "정말 다 썼나" 를 판정하고 그 결과를 여기에 남긴다.
 * 2. **조회 전용이다.** PB 에 `dw_1.update()` + commit 이 있지만 DataWindow 의
 *    12개 컬럼이 **모두 `tabsequence=32766`(편집 불가)** 이라 바뀔 값이 없다 —
 *    무동작이다 (실측). 340 라인설비바코드와 같은 유형이다.
 * 3. **판정 결과가 이 화면의 핵심이다.** 실측 분포는 'P' 통과 419건 · 'E' 오류 158건
 *    (전체 577건). 오류 건의 `CHECK_MSG` 에 사유가 들어 있다.
 * 4. **CHECK_DATE 에 인덱스가 없다** (SCAN_PARTNAME 단독뿐 — 실측). 표가 577행이라
 *    전체 스캔이어도 무관하다. 기간을 필수로 둔 것은 성능이 아니라 화면의 뜻이다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { RecycleCheckQueryDto } from './warehouse.dto';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;

@Injectable()
export class RecycleCheckService {
  constructor(private readonly dataSource: DataSource) {}

  /**
   * 공릴체크 이력.
   *
   * 기간은 `>= 시작일` · `< 종료일 + 1` 로 건다. PB 는 `to_date(:arg,'...hh24:mi:ss')`
   * 로 받아 화면이 시각까지 만들어 넘겼는데, 날짜만 받아 종료일 하루를 온전히
   * 포함하는 쪽이 리포트로서 맞다.
   */
  async find(query: RecycleCheckQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(r.CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "checkDate",
              r.CHECK_SEQUENCE                          AS "checkSequence",
              r.CHECK_STATUS                            AS "checkStatus",
              r.CHECK_MSG                               AS "checkMsg",
              r.CHECK_BY                                AS "checkBy",
              r.SCAN_PARTNAME                           AS "scanPartName",
              r.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(r.LINE_CODE, :organizationId) AS "lineName",
              r.MODEL_NAME                              AS "modelName",
              r.LOCATION_CODE                           AS "locationCode",
              TO_CHAR(r.FEEDING_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "feedingDate",
              TO_CHAR(r.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "enterDate"
         FROM IB_RECYCLE_CHECKHIST r
        WHERE r.CHECK_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND r.CHECK_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          -- 라인코드는 NULL 인 행이 있어 NVL 이 필요하다. 벗기면 그 행이
          -- NULL LIKE '%' = NULL 로 탈락한다.
          AND NVL(r.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(r.CHECK_STATUS, '*') LIKE :checkStatus ESCAPE '\\'
          AND NVL(r.SCAN_PARTNAME, '*') LIKE :scanPartName ESCAPE '\\'
          AND r.ORGANIZATION_ID = :organizationId
        ORDER BY r.CHECK_DATE DESC, r.CHECK_SEQUENCE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        lineCode: likePrefix(query.lineCode),
        checkStatus: likePrefix(query.checkStatus),
        scanPartName: likePrefix(query.scanPartName),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }
}

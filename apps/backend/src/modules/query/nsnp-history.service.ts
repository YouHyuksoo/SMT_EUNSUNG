/**
 * @file src/modules/query/nsnp-history.service.ts
 * @description 335 NSNP 처리이력조회 — PB w_pln_product_nsnp_history_query 이식
 *
 * 초보자 가이드:
 * 1. **위쪽은 라인 상태, 아래쪽은 이력이다.** 라인마다 지금 NSNP 가 잠겼는지,
 *    설비를 쓰는지(use_status)를 보고, 아래에서 그 라인의 발생 이력을 본다.
 * 2. **이력은 두 원장을 합친다** (PB UNION ALL 그대로):
 *      IQ_MACHINE_INSPECT_NSNP     오삽 감지·잠금 이력
 *      IB_SMT_LINE_ONOFF_HISTORY   라인 ON/OFF 이력
 *    라인이 꺼져 있던 구간을 함께 봐야 '왜 안 잡혔나' 를 판단할 수 있다.
 * 3. **제어 버튼은 NsnpControlService 가 한다** — 321·329 와 같은 동작이다.
 *    잠금/해제/사용/미사용/이력초기화 다섯 가지 모두 사용자 레벨 8 이상이다.
 * 4. **PB 의 `DW_1.UPDATE()` 는 무동작이었다.** 라인 상태 DataWindow
 *    (`d_pln_product_line_status_4_nsnp_lst`)에 갱신 대상 테이블이 지정돼 있지
 *    않고 update=yes 컬럼도 없다 (실측). 위쪽 표는 조회 전용이다.
 * 5. **라인 상태 DataWindow 는 PBSELECT 였다.** 선언된 조인
 *    (IP_PRODUCT_LINE 좌외부조인 IMCN_MACHINE, MACHINE_TYPE='NSNP',
 *     MES_DISPLAY_YN='Y')을 근거로 SQL 을 새로 썼다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { NsnpHistoryQueryDto } from './query.dto';

type Row = Record<string, unknown>;

const ROW_LIMIT = 5000;

@Injectable()
export class NsnpHistoryService {
  constructor(private readonly dataSource: DataSource) {}

  /** 위쪽 표 — 모니터링에 표시되는 라인의 현재 상태 */
  async findLineStatus(organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT l.LINE_CODE                               AS "lineCode",
              l.LINE_NAME                               AS "lineName",
              l.LINE_STATUS                             AS "lineStatus",
              ls.CODE_MEAN_KOR                          AS "lineStatusName",
              l.NSNP_STATUS                             AS "nsnpStatus",
              TO_CHAR(l.NSNP_START_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "nsnpStartDate",
              l.MODEL_NAME                              AS "modelName",
              l.MODEL_SUFFIX                            AS "modelSuffix",
              TO_CHAR(l.FULL_CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "fullCheckDate",
              TO_CHAR(l.CCS_DATE, 'YYYY-MM-DD HH24:MI:SS')         AS "ccsDate",
              TO_CHAR(l.REFLOW_CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "reflowCheckDate",
              TO_CHAR(l.PCB_SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS')    AS "pcbScanDate",
              m.USE_STATUS                              AS "useStatus",
              m.IP_ADDRESS                              AS "ipAddress",
              -- 이력 초기화 버튼이 몇 건을 지우는지 화면이 먼저 보여줄 수 있어야 한다.
              ( SELECT COUNT(*) FROM IQ_MACHINE_INSPECT_NSNP n
                 WHERE n.LINE_CODE = l.LINE_CODE
                   AND n.ORGANIZATION_ID = l.ORGANIZATION_ID ) AS "historyRows"
         FROM IP_PRODUCT_LINE l
         LEFT JOIN IMCN_MACHINE m
                ON m.LINE_CODE = l.LINE_CODE
               AND m.ORGANIZATION_ID = l.ORGANIZATION_ID
               AND m.MACHINE_TYPE = 'NSNP'
         LEFT JOIN ISYS_BASECODE ls
                ON ls.CODE_TYPE = 'LINE STATUS' AND ls.CODE_NAME = l.LINE_STATUS
        WHERE l.MES_DISPLAY_YN = 'Y'
          AND l.ORGANIZATION_ID = :organizationId
        ORDER BY l.LINE_CODE`,
      { organizationId } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length };
  }

  /**
   * 아래쪽 표 — NSNP 이력과 라인 ON/OFF 이력을 시간순으로 합친다.
   *
   * PB 는 두 갈래를 UNION ALL 했다. ON/OFF 쪽에는 NSNP 사유 컬럼이 없어 LINE_ONOFF
   * 값을 사유 자리에 넣었다 — 그 관례를 유지하고 `sourceKind` 로 어느 원장인지
   * 구분해 준다 (PB 는 구분할 방법이 없어 화면에서 섞여 보였다).
   */
  async findHistory(query: NsnpHistoryQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT 'NSNP'                                    AS "sourceKind",
              n.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(n.LINE_CODE, :organizationId) AS "lineName",
              n.MACHINE_CODE                            AS "machineCode",
              n.MODEL_NAME                              AS "modelName",
              n.MODEL_SUFFIX                            AS "modelSuffix",
              n.ACTION_CODE                             AS "actionCode",
              n.NSNP_REASON                             AS "nsnpReason",
              n.NSNP_ERROR_MESSAGE                      AS "nsnpErrorMessage",
              n.ENTER_BY                                AS "enterBy",
              TO_CHAR(n.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')       AS "enterDate",
              n.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(n.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastModifyDate"
         FROM IQ_MACHINE_INSPECT_NSNP n
        WHERE NVL(n.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(n.MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
          AND n.ENTER_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND n.ENTER_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND n.ORGANIZATION_ID = :organizationId
       UNION ALL
       SELECT 'LINE_ONOFF'                              AS "sourceKind",
              h.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(h.LINE_CODE, :organizationId) AS "lineName",
              '*'                                       AS "machineCode",
              h.MODEL_NAME                              AS "modelName",
              NULL                                      AS "modelSuffix",
              NULL                                      AS "actionCode",
              h.LINE_ONOFF                              AS "nsnpReason",
              NULL                                      AS "nsnpErrorMessage",
              h.ENTER_BY                                AS "enterBy",
              TO_CHAR(h.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')       AS "enterDate",
              h.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(h.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastModifyDate"
         FROM IB_SMT_LINE_ONOFF_HISTORY h
        WHERE NVL(h.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(h.MODEL_NAME, '*') LIKE :modelName ESCAPE '\\'
          AND h.ENTER_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND h.ENTER_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND h.ORGANIZATION_ID = :organizationId
        ORDER BY "enterDate" DESC
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        lineCode: likePrefix(query.lineCode),
        modelName: likePrefix(query.modelName),
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length };
  }
}

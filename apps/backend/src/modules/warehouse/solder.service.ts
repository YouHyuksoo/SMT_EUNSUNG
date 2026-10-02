/**
 * @file src/modules/warehouse/solder.service.ts
 * @description 솔더 페이스트 2화면
 *              244 w_mat_solder_receipt_issue_master  솔더입출고조회 (**쓰기 있음**)
 *              245 w_mat_solder_input_move_query      솔더라인투입이력조회 (조회 전용)
 *
 * 초보자 가이드:
 * 1. **솔더 한 통의 생애를 쫓는 화면이다.** `IM_ITEM_SOLDER_MASTER` 한 행이 통 하나이고
 *    날짜 컬럼들이 단계를 나타낸다:
 *        RECEIPT_DATE 입고(냉장고에 넣음) → ISSUE_DATE 출고(꺼냄)
 *        → UNFREEZING_START/END 해동 → MIX_START/END 교반
 *        → VISCOSITY_START/END 점도측정 → INPUT_DATE 라인투입
 *        → RETURN_DATE 반납 또는 DESTROY_DATE 폐기
 *    솔더는 굳으면 못 쓰므로 **각 단계에 머문 시간**이 이 화면의 핵심이다.
 * 2. **Running / All 두 탭의 SQL 차이는 딱 두 조건이다** (실측):
 *    Running 은 `ISSUE_DATE IS NOT NULL AND DESTROY_DATE IS NULL` 을 더 건다 —
 *    꺼냈고 아직 버리지 않은 통, 즉 지금 쓰이는 것이다. 그래서 메서드는 하나다.
 * 3. **PB 의 교반시간 표시는 24시간을 버린다.** `TO_CHAR(날짜차, 'HH24:MI:SS')` 라
 *    하루를 넘기면 나머지만 보인다 — 실측 최대 **163.2시간**이 `19:12` 로 찍힌다.
 *    나머지 시간 열이 모두 쓰는 `F_GET_TIME_STR` 로 통일했다 (추적 대분류에서
 *    같은 결함을 같은 방법으로 고쳤다).
 * 4. **입고·출고는 쓰기다.** PB `wf_insert(롯트, 'R'|'I')` 를 그대로 옮겼다:
 *        'R' 입고 — 자재 바코드 표에서 품목코드를 찾고, 이미 있는 롯트면 거절,
 *                   없으면 새 통을 등록한다 (RECEIPT_DATE = 지금)
 *        'I' 출고 — 그 통이 없으면 거절, 있으면 ISSUE_DATE = 지금
 *    **실행하지 않고 parse 로만 검증했다** — 운영 원장이라 사용자 승인 없이
 *    테스트 데이터를 넣지 않는다. 현장 확인이 필요하다.
 * 5. **이 표는 display 31(솔더 페이스트 관리)도 읽는다.** 그쪽은 경고 목록과 NG
 *    건수만 보는 모니터링이고, 이 화면은 입고·출고를 하는 업무 화면이다 — 중복이 아니다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TransactionService } from '../../shared/transaction.service';
import {
  SolderInputHistoryQueryDto,
  SolderListQueryDto,
  SolderScanDto,
  SolderStageCountQueryDto,
} from './warehouse.dto';
import { affectedRows } from '../../common/utils/affected-rows.util';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;

@Injectable()
export class SolderService {
  constructor(
    private readonly dataSource: DataSource,
    private readonly tx: TransactionService,
  ) {}

  // ───────────────────────────────── 244 조회

  /**
   * 단계별 대기 수량 — 어느 단계에 몇 통이 멈춰 있나.
   *
   * PB 집계를 그대로 옮겼다. 대상은 **아직 라인에 안 들어갔고 버리지도 않은 통**
   * (`INPUT_DATE IS NULL AND DESTROY_DATE IS NULL`) 이다.
   * 실측 현황: 냉장고 105 · 해동중 10 · 교반중 0 · 점도대기 0 · 투입대기 0 (진행중 115통).
   */
  async findStageCounts(query: SolderStageCountQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT MACHINE_CODE                              AS "machineCode",
              F_GET_MACHINE_NAME(MACHINE_CODE)          AS "machineName",
              LINE_CODE                                 AS "lineCode",
              F_GET_LINE_NAME(LINE_CODE, :organizationId) AS "lineName",
              SOLDER_TYPE                               AS "solderType",
              SUM(REFRIGERATOR_CNT)                     AS "refrigeratorCnt",
              SUM(UNFREEZING_CNT)                       AS "unfreezingCnt",
              SUM(MIX_CNT)                              AS "mixCnt",
              SUM(VISCOSITY_WAIT_CNT)                   AS "viscosityWaitCnt",
              SUM(INPUT_WAIT_CNT)                       AS "inputWaitCnt"
         FROM ( SELECT MACHINE_CODE, LINE_CODE, SOLDER_TYPE,
                       -- 넣었고 아직 안 꺼낸 통 = 냉장고에 있는 것
                       CASE WHEN RECEIPT_DATE IS NOT NULL AND ISSUE_DATE IS NULL
                            THEN 1 ELSE 0 END           AS REFRIGERATOR_CNT,
                       CASE WHEN UNFREEZING_START_DATE IS NOT NULL
                             AND UNFREEZING_END_DATE IS NULL
                            THEN 1 ELSE 0 END           AS UNFREEZING_CNT,
                       CASE WHEN MIX_START_DATE IS NOT NULL AND MIX_END_DATE IS NULL
                            THEN 1 ELSE 0 END           AS MIX_CNT,
                       -- 교반은 끝났는데 점도측정이 안 끝난 것
                       CASE WHEN MIX_END_DATE IS NOT NULL AND VISCOSITY_END_DATE IS NULL
                            THEN 1 ELSE 0 END           AS VISCOSITY_WAIT_CNT,
                       -- 점도까지 끝났는데 라인에 안 들어간 것
                       CASE WHEN MIX_END_DATE IS NOT NULL
                             AND VISCOSITY_END_DATE IS NOT NULL
                             AND INPUT_DATE IS NULL
                            THEN 1 ELSE 0 END           AS INPUT_WAIT_CNT
                  FROM IM_ITEM_SOLDER_MASTER
                 -- PB 고정조건: 라인에 들어갔거나 버린 통은 세지 않는다.
                 WHERE INPUT_DATE IS NULL
                   AND DESTROY_DATE IS NULL
                   AND NVL(MACHINE_CODE, '*') LIKE :machineCode ESCAPE '\\'
                   AND ORGANIZATION_ID = :organizationId )
        GROUP BY MACHINE_CODE, LINE_CODE, SOLDER_TYPE
        ORDER BY MACHINE_CODE, LINE_CODE, SOLDER_TYPE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        machineCode: likePrefix(query.machineCode),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 솔더 통 목록.
   *
   * 시간 열은 전부 `F_GET_TIME_STR` 로 낸다 (PB 와 같은 함수). 교반시간만 PB 가
   * `TO_CHAR(..., 'HH24:MI:SS')` 를 써서 24시간을 버렸는데, 같은 함수로 통일했다 —
   * 파일 머리 3번 참고.
   *
   * `runningOnly` 를 켜면 PB Running 탭과 같아진다.
   */
  async findSolders(query: SolderListQueryDto, organizationId: number) {
    // PB Running 탭의 두 조건. 꺼냈고 아직 버리지 않은 통만 본다.
    const runningWhere = query.runningOnly
      ? `AND s.ISSUE_DATE IS NOT NULL
          AND s.DESTROY_DATE IS NULL`
      : '';
    /**
     * 두 시각의 차이를 '몇 시간 몇 분' 문자열로. PB 와 같은 DB 함수를 쓴다.
     *
     * `clampNegative` 는 PB 의 `DECODE(SIGN(...), -1, 0, ...)` 가드다.
     * 폐기일이 시작일보다 이른 비정상 행에서 **PB 는 0 을 보여준다** — 그 열에만
     * 가드가 붙어 있으므로(점도 후·최초투입 후·개봉 후) 그대로 맞춘다.
     * 가드가 없는 열(해동 소요·교반 소요·출고 후)에는 붙이지 않는다.
     */
    const elapsed = (from: string, to: string, clampNegative = false) => {
      const hours = `ROUND(NVL(NVL(${to}, SYSDATE) - NVL(${from}, SYSDATE), 0) * 24, 3)`;
      return clampNegative
        ? `F_GET_TIME_STR(DECODE(SIGN(${hours}), -1, 0, ${hours}))`
        : `F_GET_TIME_STR(${hours})`;
    };

    const rows = (await this.dataSource.query(
      `SELECT s.ITEM_CODE                               AS "itemCode",
              s.SOLDER_LOT_NO                           AS "solderLotNo",
              s.ITEM_BARCODE                            AS "itemBarcode",
              s.SOLDER_TYPE                             AS "solderType",
              s.MODEL_NAME                              AS "modelName",
              s.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(s.LINE_CODE, :organizationId) AS "lineName",
              s.WORKSTAGE_CODE                          AS "workstageCode",
              s.MACHINE_CODE                            AS "machineCode",
              s.RUN_NO                                  AS "runNo",
              TO_CHAR(s.RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS')         AS "receiptDate",
              TO_CHAR(s.ISSUE_DATE, 'YYYY-MM-DD HH24:MI:SS')           AS "issueDate",
              TO_CHAR(s.OPEN_DATE, 'YYYY-MM-DD HH24:MI:SS')            AS "openDate",
              TO_CHAR(s.UNFREEZING_START_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "unfreezingStartDate",
              TO_CHAR(s.UNFREEZING_END_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "unfreezingEndDate",
              TO_CHAR(s.MIX_START_DATE, 'YYYY-MM-DD HH24:MI:SS')       AS "mixStartDate",
              TO_CHAR(s.MIX_END_DATE, 'YYYY-MM-DD HH24:MI:SS')         AS "mixEndDate",
              TO_CHAR(s.VISCOSITY_START_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "viscosityStartDate",
              TO_CHAR(s.VISCOSITY_END_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "viscosityEndDate",
              TO_CHAR(s.INPUT_DATE, 'YYYY-MM-DD HH24:MI:SS')           AS "inputDate",
              TO_CHAR(s.FIRST_LINE_INPUT_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "firstLineInputDate",
              TO_CHAR(s.RETURN_DATE, 'YYYY-MM-DD HH24:MI:SS')          AS "returnDate",
              TO_CHAR(s.DESTROY_DATE, 'YYYY-MM-DD HH24:MI:SS')         AS "destroyDate",
              TO_CHAR(s.VALID_DATE, 'YYYY-MM-DD')                      AS "validDate",
              -- 유효기한까지 남은 일수. 버린 통은 버린 날 기준이다 (PB 와 같다).
              ROUND(s.VALID_DATE
                    - DECODE(s.DESTROY_DATE, NULL, SYSDATE, s.DESTROY_DATE), 0)
                                                        AS "validCount",
              s.FREEZER_IN_TEMP                         AS "freezerInTemp",
              s.UNFREEZING_START_TEMP                   AS "unfreezingStartTemp",
              s.UNFREEZING_END_TEMP                     AS "unfreezingEndTemp",
              s.VISCOSITY                               AS "viscosity",
              s.VISCOSITY_OPERATOR                      AS "viscosityOperator",
              s.VISCOSITY_FILE_NAME                     AS "viscosityFileName",
              s.RPM                                     AS "rpm",
              s."TIME"                                  AS "mixTime",
              s.TEMP                                    AS "temp",
              -- 해동에 걸린 시간 (아직 끝나지 않았으면 지금까지).
              ${elapsed('s.UNFREEZING_START_DATE', 's.UNFREEZING_END_DATE')}
                                                        AS "unfreezingWaitTime",
              -- 교반에 걸린 시간. **PB 는 여기서 24시간을 버렸다** (파일 머리 3번).
              ${elapsed('s.MIX_START_DATE', 's.MIX_END_DATE')}
                                                        AS "mixWaitTime",
              -- 점도측정 뒤 지난 시간. 점도측정을 안 했으면 라인투입 시각부터 센다.
              ${elapsed(
                `NVL(s.VISCOSITY_END_DATE, s.INPUT_DATE)`,
                's.DESTROY_DATE',
                true,
              )}                                        AS "afterViscosityTime",
              -- 냉장고에서 꺼낸 뒤 지난 시간. 솔더는 이 시간이 수명을 깎는다.
              ${elapsed('s.ISSUE_DATE', 's.DESTROY_DATE')} AS "afterIssueTime",
              -- 처음 라인에 올린 뒤 지난 시간.
              ${elapsed('s.FIRST_LINE_INPUT_DATE', 's.DESTROY_DATE', true)}
                                                        AS "afterFirstInputTime",
              -- 개봉(점도측정 시작, 없으면 최초투입, 없으면 투입) 뒤 지난 시간.
              ${elapsed(
                `NVL(s.VISCOSITY_START_DATE, NVL(s.FIRST_LINE_INPUT_DATE, s.INPUT_DATE))`,
                's.DESTROY_DATE',
                true,
              )}                                        AS "afterOpenTime",
              -- 이 통이 투입된 라인 목록 (PB 와 같은 DB 함수).
              F_GET_SOLDER_INPUT_LIST(s.ITEM_BARCODE)   AS "solderInputLine",
              s.ENTER_BY                                AS "enterBy",
              TO_CHAR(s.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')           AS "enterDate",
              s.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(s.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "lastModifyDate"
         FROM IM_ITEM_SOLDER_MASTER s
        WHERE s.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND s.RECEIPT_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND s.SOLDER_LOT_NO LIKE :solderLotNo ESCAPE '\\'
          AND NVL(s.ITEM_BARCODE, '*') LIKE :itemBarcode ESCAPE '\\'
          AND NVL(s.LINE_CODE, '*') LIKE :lineCode ESCAPE '\\'
          AND NVL(s.SOLDER_TYPE, '*') LIKE :solderType ESCAPE '\\'
          AND NVL(s.MACHINE_CODE, '*') LIKE :machineCode ESCAPE '\\'
          AND s.ORGANIZATION_ID = :organizationId
          ${runningWhere}
        ORDER BY s.RECEIPT_DATE DESC, s.SOLDER_LOT_NO
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        solderLotNo: likePrefix(query.solderLotNo),
        itemBarcode: likePrefix(query.itemBarcode),
        lineCode: likePrefix(query.lineCode),
        solderType: likePrefix(query.solderType),
        machineCode: likePrefix(query.machineCode),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 244 쓰기

  /**
   * 입고·출고 스캔 (**쓰기** — PB `wf_insert`).
   *
   * 'R' 입고: 자재 바코드 표에서 품목코드를 찾아 새 통을 등록한다.
   *           **이미 있는 롯트면 거절한다** (PB 813 메시지). 그 판정을 빼면
   *           같은 통이 두 번 등록돼 단계 집계가 두 배로 잡힌다.
   * 'I' 출고: 그 통이 없으면 거절한다 (PB 815 메시지).
   *
   * 품목코드 조회는 PB 가 `SELECT ... INTO` 를 썼다 — 롯트가 중복이면 Oracle 이
   * ORA-01422 로 터진다. 실측상 중복은 0건이지만 제약이 아니라 우연이므로,
   * **중복이면 분명한 오류를 내는 쪽**을 유지한다 (아무거나 고르면 잘못된 품목으로
   * 등록된다).
   */
  async scan(dto: SolderScanDto, organizationId: number, userId: string) {
    return this.tx.run(async (qr) => {
      const lotBinds = { solderLotNo: dto.solderLotNo, organizationId };

      if (dto.scanType === 'R') {
        // 자재 바코드 표에서 품목코드를 얻는다. 입고되지 않은 자재는 솔더로 등록할 수 없다.
        const items = (await qr.query(
          `SELECT DISTINCT b.ITEM_CODE AS "itemCode"
             FROM IM_ITEM_RECEIPT_BARCODE b
            WHERE b.LOT_NO = :solderLotNo
              AND b.ORGANIZATION_ID = :organizationId`,
          namedBinds(lotBinds),
        )) as Row[];
        if (items.length === 0) {
          throw new BadRequestException(
            `자재 바코드에 없는 롯트입니다: ${dto.solderLotNo}`
            + ' (자재 입고가 먼저 되어 있어야 합니다.)',
          );
        }
        if (items.length > 1) {
          throw new BadRequestException(
            `롯트 ${dto.solderLotNo} 에 품목코드가 ${items.length}개 있습니다`
            + ' — 어느 품목으로 등록할지 정할 수 없습니다.',
          );
        }

        const exists = (await qr.query(
          `SELECT COUNT(*) AS "cnt"
             FROM IM_ITEM_SOLDER_MASTER
            WHERE SOLDER_LOT_NO = :solderLotNo
              AND ORGANIZATION_ID = :organizationId`,
          namedBinds(lotBinds),
        )) as Row[];
        if (Number(exists[0]?.cnt ?? 0) > 0) {
          throw new BadRequestException(`이미 입고된 솔더입니다: ${dto.solderLotNo}`);
        }

        const result = await qr.query(
          `INSERT INTO IM_ITEM_SOLDER_MASTER
             (ITEM_CODE, SOLDER_LOT_NO, RECEIPT_DATE,
              ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY, ORGANIZATION_ID)
           VALUES
             (:itemCode, :solderLotNo, SYSDATE,
              SYSDATE, :userId, SYSDATE, :userId, :organizationId)`,
          namedBinds({
            itemCode: items[0].itemCode,
            solderLotNo: dto.solderLotNo,
            userId,
            organizationId,
          }),
        );
        return {
          scanType: 'R' as const,
          solderLotNo: dto.solderLotNo,
          itemCode: items[0].itemCode as string,
          affected: Number(affectedRows(result) ?? 0),
        };
      }

      // 'I' 출고 — 냉장고에서 꺼낸 시각을 적는다.
      const result = await qr.query(
        `UPDATE IM_ITEM_SOLDER_MASTER
            SET ISSUE_DATE = SYSDATE,
                LAST_MODIFY_DATE = SYSDATE,
                LAST_MODIFY_BY = :userId
          WHERE SOLDER_LOT_NO = :solderLotNo
            AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ ...lotBinds, userId }),
      );
      const affected = Number(affectedRows(result) ?? 0);
      if (affected === 0) {
        // PB 는 UPDATE 전에 COUNT 로 확인했다. 결과는 같고 왕복이 한 번 줄어든다.
        throw new BadRequestException(`입고되지 않은 솔더입니다: ${dto.solderLotNo}`);
      }
      return {
        scanType: 'I' as const,
        solderLotNo: dto.solderLotNo,
        itemCode: null,
        affected,
      };
    });
  }

  // ───────────────────────────────── 245 솔더라인투입이력조회

  /**
   * 솔더가 어느 라인·설비에 언제 투입됐는지.
   *
   * **조회 전용이다.** PB 에 244 에서 복붙한 `wf_insert` 가 남아 있지만 **호출부가
   * 없고**, `dw_1.update()` 도 주석 처리돼 있다 (실측). DataWindow 9개 컬럼 전부
   * 편집 불가이므로 갱신 대상도 없다.
   *
   * 롯트번호로 솔더 마스터를 붙여 품목·종류를 함께 낸다 — PB 는 롯트번호만 보여줘
   * 무슨 솔더인지 알 수 없었다.
   */
  async findInputHistory(query: SolderInputHistoryQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(h.INPUT_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "inputDate",
              h.SOLDER_LOT_NO                           AS "solderLotNo",
              h.RUN_NO                                  AS "runNo",
              h.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(h.LINE_CODE, :organizationId) AS "lineName",
              h.MACHINE_CODE                            AS "machineCode",
              F_GET_MACHINE_NAME(h.MACHINE_CODE)        AS "machineName",
              -- PB 는 롯트번호만 보여줘 무슨 솔더인지 알 수 없었다.
              s.ITEM_CODE                               AS "itemCode",
              s.SOLDER_TYPE                             AS "solderType",
              s.ITEM_BARCODE                            AS "itemBarcode",
              h.ENTER_BY                                AS "enterBy",
              TO_CHAR(h.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')           AS "enterDate",
              h.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(h.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "lastModifyDate"
         FROM IM_ITEM_SOLDER_INPUT_HIST h
         -- 이력 표에는 조직 컬럼이 없다 (실측 9컬럼). 마스터를 붙여 조직으로 거른다.
         LEFT JOIN IM_ITEM_SOLDER_MASTER s
                ON s.SOLDER_LOT_NO = h.SOLDER_LOT_NO
               AND s.ORGANIZATION_ID = :organizationId
        WHERE h.INPUT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND h.INPUT_DATE <  TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND h.SOLDER_LOT_NO LIKE :solderLotNo ESCAPE '\\'
          AND NVL(h.MACHINE_CODE, '*') LIKE :machineCode ESCAPE '\\'
        ORDER BY h.INPUT_DATE DESC, h.SOLDER_LOT_NO
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        solderLotNo: likePrefix(query.solderLotNo),
        machineCode: likePrefix(query.machineCode),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }
}

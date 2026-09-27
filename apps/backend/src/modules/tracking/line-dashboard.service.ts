/**
 * @file src/modules/tracking/line-dashboard.service.ts
 * @description 321 생산현황데쉬보드 — PB w_com_production_status_dashboard 이식
 *
 * 초보자 가이드:
 * 1. **라인 하나를 골라 그 라인의 지금 상태를 본다.** 위쪽은 라인 요약
 *    (IRPT_PRODUCT_LINE_DASHBOARD 뷰 한 줄), 아래쪽은 그 라인의 진행 롯트에 대한
 *    9개 탭이다.
 * 2. **요약은 뷰다 — 실시간이다.** IRPT_PRODUCT_LINE_DASHBOARD 는 VIEW 이고
 *    MATERIALIZED VIEW 가 아니다 (실측). 그래서 60초 자동갱신이 실제로 새 값을
 *    가져온다. MV 였다면 화면이 갱신 주기를 거짓으로 말하게 된다.
 * 3. **탭 9개를 한 번에 받아온다.** PB 는 '상세조회' 한 번에 DataWindow 9개를
 *    각각 retrieve 했다. 웹에서 9번 왕복하면 라인을 고를 때마다 요청이 9개 뜬다.
 * 4. **NSNP 잠금/해제는 NsnpControlService 가 한다.** 같은 동작을 피더별 모니터링
 *    (329)·NSNP 처리이력조회(335)도 쓰기 때문에 한 곳에 뒀다 — PB 는 세 창에
 *    복붙해 둬서 한 창에서만 가드가 고쳐질 수 있었다.
 * 5. **이 화면은 트랙 A(업무화면)다.** Timer 자동갱신만 보면 display 같지만
 *    쓰기 동작과 사용자 레벨 가드가 있고 PB 메뉴(M_PRODUCTIONSTATUSDASHBOARD)에
 *    등록된 화면이다. display 셸에는 로그인 사용자 맥락이 없어 잠금을 걸 수 없다.
 *
 * PB 결함 2건을 여기서 고쳤다 (아래 각 메서드 주석에 근거를 적었다).
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { LineDashboardDetailQueryDto, LineDashboardQueryDto } from './tracking.dto';

type Row = Record<string, unknown>;

const TAB_ROW_LIMIT = 2000;

@Injectable()
export class LineDashboardService {
  constructor(private readonly dataSource: DataSource) {}

  /**
   * 위쪽 라인 요약. 뷰가 컬럼마다 이름값(..._NAME)을 이미 들고 있어 코드표 조인이 없다.
   *
   * TARGET_QTY·REAL_ST 는 PB DataWindow 가 SELECT 절에서 계산한 파생값이다
   * (뷰 컬럼이 아니다). 계산식을 그대로 옮겼다 — 목표수량과 실제 택트를
   * 프론트에서 다시 계산하면 PB 화면과 숫자가 갈린다.
   *
   * **뷰의 점검일시 9개는 DATE 가 아니라 VARCHAR2 다** — MASK/SQUEEZE/CCS/FULL/
   * XRAY/SPEC/SAMPLE/NOZZLE/BACKUPBLOCK_CHECK_DATE. TO_CHAR 로 감싸면
   * Oracle 이 숫자 변환으로 알아듣고 ORA-01722 가 난다 (실측). 그대로 내보낸다.
   * 반면 ACTUAL_DATE·NSNP_START_DATE·RUNNING_RUN_DATE·RUN_DATE·SOLDER_CHECK_DATE
   * 는 진짜 DATE 라 TO_CHAR 가 필요하다. 이름만 보고 뭉치면 안 된다.
   */
  async findLineStatus(query: LineDashboardQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT v.LINE_CODE                               AS "lineCode",
              v.LINE_NAME                               AS "lineName",
              v.ORGANIZATION_NAME                       AS "organizationName",
              TO_CHAR(v.ACTUAL_DATE, 'YYYY-MM-DD')      AS "actualDate",
              v.WORK_SHIFT_CODE                         AS "workShiftCode",
              v.LINE_STATUS                             AS "lineStatus",
              v.LINE_STATUS_NAME                        AS "lineStatusName",
              v.LINE_STATUS_CODE                        AS "lineStatusCode",
              v.LINE_STATUS_CODE_NAME                   AS "lineStatusCodeName",
              v.NSNP_LOCK_TYPE                          AS "nsnpLockType",
              v.NSNP_LOCK_TYPE_NAME                     AS "nsnpLockTypeName",
              v.NSNP_REASON                             AS "nsnpReason",
              TO_CHAR(v.NSNP_START_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "nsnpStartDate",
              v.NSNP_STATUS                             AS "nsnpStatus",
              v.NSNP_STATUS_NAME                        AS "nsnpStatusName",
              v.RUNNING_RUN_NO                          AS "runningRunNo",
              v.RUNNING_MODEL_NAME                      AS "runningModelName",
              TO_CHAR(v.RUNNING_RUN_DATE, 'YYYY-MM-DD') AS "runningRunDate",
              v.RUN_NO_CHANGED_BY                       AS "runNoChangedBy",
              v.RUNNING_LOT_PLAN_QTY                    AS "planQty",
              v.RUNNING_LOT_INPUT_QTY                   AS "inputQty",
              v.RUNNING_LOT_ACTUAL_QTY                  AS "actualQty",
              v.RUNNING_LOT_NG_QTY                      AS "ngQty",
              v.PCB_INPUT_QTY                           AS "pcbInputQty",
              v.ITEM_CODE                               AS "itemCode",
              v.MODEL_NAME                              AS "modelName",
              v.CUSTOMER_MODEL_NAME                     AS "customerModelName",
              v.CUSTOMER_NAME                           AS "customerName",
              v.PRODUCT_CLASS                           AS "productClass",
              v.RUN_STATUS                              AS "runStatus",
              v.RUN_STATUS_NAME                         AS "runStatusName",
              v.PRODUCT_RUN_TYPE                        AS "productRunType",
              v.PRODUCT_RUN_TYPE_NAME                   AS "productRunTypeName",
              v.CARRIER_SIZE                            AS "carrierSize",
              v.PCB_ITEM                                AS "pcbItem",
              v.SOLDER_TYPE                             AS "solderType",
              v.SOLDER_LOT_NO                           AS "solderLotNo",
              TO_CHAR(v.SOLDER_CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "solderCheckDate",
              v.SOLDER_CHECK                            AS "solderCheck",
              v.SOLDER_CHECK_VAL                        AS "solderCheckVal",
              v.SOLDER_CHECK_HOUR                       AS "solderCheckHour",
              v.SOLDER_REMAIN_TIME                      AS "solderRemainTime",
              v.MASK_LOT_NO                             AS "maskLotNo",
              v.MASK_LOT_NO2                            AS "maskLotNo2",
              v.MASK_CHECK                              AS "maskCheck",
              v.MASK_CHECK_DATE                                     AS "maskCheckDate",
              v.MASK_BREAK_VALUE                        AS "maskBreakValue",
              v.MASK_HIT_VALUE                          AS "maskHitValue",
              v.MASK_BREAK_VALUE2                       AS "maskBreakValue2",
              v.MASK_HIT_VALUE2                         AS "maskHitValue2",
              v.SQUEEZE_LOT_NO                          AS "squeezeLotNo",
              v.SQUEEZE_LOT_NO2                         AS "squeezeLotNo2",
              v.SQUEEZE_CHECK                           AS "squeezeCheck",
              v.SQUEEZE_CHECK_DATE                                   AS "squeezeCheckDate",
              v.SQUEEZE_BREAK_VALUE                     AS "squeezeBreakValue",
              v.SQUEEZE_HIT_VALUE                       AS "squeezeHitValue",
              v.SQUEEZE_BREAK_VALUE2                    AS "squeezeBreakValue2",
              v.SQUEEZE_HIT_VALUE2                      AS "squeezeHitValue2",
              v.CCS_CHECK                               AS "ccsCheck",
              v.CCS_CHECK_DATE                                      AS "ccsCheckDate",
              v.FULL_CHECK                              AS "fullCheck",
              v.FULL_CHECK_DATE                                     AS "fullCheckDate",
              v.XRAY_CHECK                              AS "xrayCheck",
              v.XRAY_CHECK_DATE                                     AS "xrayCheckDate",
              v.SPEC_CHECK                              AS "specCheck",
              v.SPEC_CHECK_DATE                                     AS "specCheckDate",
              v.SAMPLE_CHECK                            AS "sampleCheck",
              v.SAMPLE_CHECK_DATE                                   AS "sampleCheckDate",
              v.NOZZLE_CHECK                            AS "nozzleCheck",
              v.NOZZLE_CHECK_DATE                                   AS "nozzleCheckDate",
              v.BACKUPBLOCK_CHECK                       AS "backupBlockCheck",
              v.BACKUPBLOCK_CHECK_DATE                                   AS "backupBlockCheckDate",
              v.QC_COMMENTS                             AS "qcComments",
              v.AOI_PASS_RATE                           AS "aoiPassRate",
              v.SPI_PASS_RATE                           AS "spiPassRate",
              v.SPI_COUNT                               AS "spiCount",
              v.AOI_COUNT                               AS "aoiCount",
              v.SENSOR_COUNT                            AS "sensorCount",
              v.MODEL_ST                                AS "modelSt",
              v.FIRST_SPI_DATE                          AS "firstSpiDate",
              v.FIRST_AOI_DATE                          AS "firstAoiDate",
              v.FIRST_MARKING_DATE                      AS "firstMarkingDate",
              v.LAST_MARKING_DATE                       AS "lastMarkingDate",
              v.MES_DISPLAY_GROUP                       AS "mesDisplayGroup",
              v.MES_DISPLAY_YN                          AS "mesDisplayYn",
              v.MES_DISPLAY_SEQUENCE                    AS "mesDisplaySequence",
              DECODE(v.MODEL_ST, 0, 0,
                     ROUND((SYSDATE - TO_DATE(v.FIRST_SPI_DATE, 'YYYY/MM/DD HH24:MI:SS'))
                           * 24 * 60 * 60 / v.MODEL_ST, 1))        AS "targetQty",
              DECODE(v.RUNNING_LOT_ACTUAL_QTY, 0, 0,
                     ROUND((SYSDATE - TO_DATE(v.FIRST_MARKING_DATE, 'YYYY/MM/DD HH24:MI:SS'))
                           * 24 * 60 * 60 / v.RUNNING_LOT_ACTUAL_QTY, 1)) AS "realSt",
              TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')            AS "readAt"
         FROM IRPT_PRODUCT_LINE_DASHBOARD v
        WHERE v.LINE_CODE = :lineCode
          AND v.ORGANIZATION_ID = :organizationId`,
      { lineCode: query.lineCode, organizationId } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length };
  }

  /**
   * 오늘 업무일의 라인별 픽업률 (PB 'Pickup rate (BASE)' 탭).
   *
   * 업무일 판정은 F_GET_WORK_ACTUAL_DATE(sysdate,'A') 가 한다 — 자정이 아니라
   * 교대 기준이라 TypeScript 로 다시 계산하면 안 된다.
   * 경고 기준도 PB 원본 그대로다: 라인 양품률 99.60% 이하면 'W',
   * 노즐 위치별로 투입 500개 이상 + 불량률 1% 이상이면 'S'.
   *
   * **업무일은 한 번만 구해 바인드로 넘긴다.** PB 는 WHERE 절 안에서
   * F_GET_WORK_ACTUAL_DATE 를 직접 불렀는데, 그러면 Oracle 이 (ACTUAL_DATE,
   * ACTUAL_TIME, LINE_CODE) 인덱스의 구간을 추정하지 못해 1,400만행을 전부 훑는다.
   * 실측: 함수 인라인 10.99s → 바인드 0.32s (같은 결과). 판정 주체는 그대로
   * DB 함수다 — 값만 미리 받아 온다.
   */
  async findPickupRate(query: LineDashboardQueryDto, organizationId: number) {
    const dateRows = (await this.dataSource.query(
      `SELECT F_GET_WORK_ACTUAL_DATE(SYSDATE, 'A') AS "workDate" FROM DUAL`,
    )) as Row[];
    const workDate = dateRows[0]?.workDate ?? null;

    const pickupBase = `
      SELECT T.LINE_CODE, T.ACTUAL_DATE, T.ACTUAL_TIME, T.MACHINE_CODE, T.PROGRAM_NAME,
             T.ADDRESS, T.SUB_ADDRESS, T.ITEM_CODE, T.DATA_TYPE, T.HEAD_SUM,
             DECODE(NVL(T.MACHINE_TYPE, 'CM'), 'NPM', T.HEAD_SUM,
                    T.HEAD_SUM - LAG(T.HEAD_SUM) OVER (
                      PARTITION BY T.LINE_CODE, T.MACHINE_CODE, T.PROGRAM_NAME,
                                   T.ADDRESS, T.SUB_ADDRESS, T.ITEM_CODE, T.DATA_TYPE
                          ORDER BY T.LINE_CODE, T.MACHINE_CODE, T.PROGRAM_NAME,
                                   T.ADDRESS, T.SUB_ADDRESS, T.ITEM_CODE, T.DATA_TYPE,
                                   T.ACTUAL_DATE, T.ACTUAL_TIME)) AS SIM_COUNT
        FROM IQ_MACHINE_INSPECT_PICKUP_RATE T
       WHERE ( T.ACTUAL_DATE = :workDate
               OR ( T.ACTUAL_DATE = :workDate - 1 AND T.ACTUAL_TIME = 'J' ) )
         AND T.ITEM_CODE <> 'HEAD'
         AND T.LINE_CODE = :lineCode`;
    const cnt = (type: string) =>
      `SUM(DECODE(DATA_TYPE, '${type}',`
      + ` DECODE(SIGN(SIM_COUNT), -1, HEAD_SUM, NVL(SIM_COUNT, HEAD_SUM)), 0))`;

    const rows = (await this.dataSource.query(
      `SELECT M.LINE_CODE                               AS "lineCode",
              M.LINE_NAME                               AS "lineName",
              M.T_CNT                                   AS "totalCount",
              M.M_CNT                                   AS "missCount",
              M.R_CNT                                   AS "rejectCount",
              M.GOOD_RATE                               AS "goodRate",
              M.PPM                                     AS "ppm",
              M.LINE_WARNING_SIGN                       AS "lineWarningSign",
              D.NG_POSITION                             AS "ngPosition",
              D.ITEM_WARNING_SIGN                       AS "itemWarningSign"
         FROM ( SELECT LINE_CODE,
                       F_GET_LINE_NAME(LINE_CODE, :organizationId) AS LINE_NAME,
                       T_CNT, M_CNT, R_CNT,
                       DECODE(T_CNT, 0, NULL,
                              ROUND(100 - (M_CNT + R_CNT) / T_CNT * 100, 2)) AS GOOD_RATE,
                       DECODE(T_CNT, 0, NULL,
                              ROUND((M_CNT + R_CNT) / T_CNT * 1000000))      AS PPM,
                       CASE WHEN DECODE(T_CNT, 0, NULL,
                                        ROUND(100 - (M_CNT + R_CNT) / T_CNT * 100, 2))
                                 <= 99.60 THEN 'W' END                       AS LINE_WARNING_SIGN
                  FROM ( SELECT LINE_CODE, ${cnt('T')} T_CNT, ${cnt('M')} M_CNT,
                                ${cnt('R')} R_CNT
                           FROM (${pickupBase})
                          WHERE ACTUAL_DATE = :workDate
                          GROUP BY LINE_CODE ) ) M
         LEFT JOIN
              ( SELECT LINE_CODE,
                       LISTAGG('[' || MACHINE_CODE || '-' || ADDRESS || '-' || SUB_ADDRESS
                               || ' : ' || TO_CHAR(M_CNT + R_CNT) || ']')
                         WITHIN GROUP (ORDER BY MACHINE_CODE || '-' || ADDRESS || '-'
                                       || SUB_ADDRESS || TO_CHAR(M_CNT + R_CNT)) AS NG_POSITION,
                       'S' AS ITEM_WARNING_SIGN
                  FROM ( SELECT LINE_CODE, MACHINE_CODE, ADDRESS, SUB_ADDRESS, ITEM_CODE,
                                ${cnt('T')} T_CNT, ${cnt('M')} M_CNT, ${cnt('R')} R_CNT
                           FROM (${pickupBase})
                          WHERE ACTUAL_DATE = :workDate
                          GROUP BY LINE_CODE, MACHINE_CODE, ADDRESS, SUB_ADDRESS, ITEM_CODE )
                 WHERE T_CNT > 500
                   AND DECODE(T_CNT, 0, NULL, (M_CNT + R_CNT) / T_CNT) >= 0.01
                 GROUP BY LINE_CODE ) D
             ON D.LINE_CODE = M.LINE_CODE
        WHERE M.LINE_CODE = :lineCode
        ORDER BY M.LINE_NAME`,
      { lineCode: query.lineCode, organizationId, workDate } as unknown as unknown[],
    )) as Row[];
    return { data: rows, total: rows.length, workDate };
  }

  /**
   * 상세 9개 탭을 한 번에. PB '상세조회' 버튼이 하던 일을 한 요청으로 묶었다.
   *
   * PB 결함 1건을 고쳤다 — 인터록 이력 탭(dw_tab_9)은 DataWindow 가
   * `IQ_MACHINE_INSPECT_NSNP.LINE_CODE like :arg_run_no` 인데 PB 는 거기에
   * **Run No 를 넘겼다.** Run No 가 라인코드와 같을 수 없으므로 이 탭은 PB 에서
   * **항상 0행**이었다. 라인코드로 찾도록 바꿨다 (컬럼이 원하는 값이 그것이다).
   */
  async findDetailTabs(query: LineDashboardDetailQueryDto, organizationId: number) {
    const [solder, mask, squeeze, msl, pcb, sample, reel, interlock] = await Promise.all([
      this.findSolder(query.solderLotNo),
      this.findMaskCheck(query.maskLotNo),
      this.findSqueezeCheck(query.squeezeLotNo, query.squeezeLotNo2),
      this.findMslWatch(query.lineCode, organizationId),
      this.findPcbInput(query.runNo),
      this.findSampleInput(query.runNo, organizationId),
      this.findReelChange(query.runNo),
      this.findInterlockHistory(query.lineCode, organizationId),
    ]);
    return { solder, mask, squeeze, msl, pcb, sample, reel, interlock };
  }

  /**
   * 솔더 탭 — 이 롯트에 쓰인 솔더 페이스트 한 통의 전 이력.
   *
   * **PB 에서 실행되지 않던 쿼리다.** DataWindow
   * `d_mat_solder_receipt_issue_lst_4_dashboard` 의 SELECT 절 안에 `//` 로 주석
   * 처리한 줄이 들어 있는데 Oracle 은 `//` 를 주석으로 모른다 — retrieve 할 때마다
   * ORA-00936 이 났다 (parse 로 실측: 그 줄만 지우면 통과). 주석줄을 빼고 옮겼다.
   *
   * 경과시간 계산은 PB 식 그대로 F_GET_TIME_STR 로 한다. 해동·점도 이후 경과시간은
   * 솔더 폐기 판정에 쓰는 값이라 계산식이 갈리면 안 된다.
   *
   * **교반시간만 PB 식을 버렸다.** PB 는 여기만 `TO_CHAR(..., 'MI:SS')` 를 썼는데
   * 그 마스크는 시간 성분을 버려서 65분이 '05:00' 으로 보인다. 실측: MIX 구간이 있는
   * 35,261행 중 906행(2.6%)이 1시간을 넘고 최대 163시간이다 — 표시가 거짓이 된다.
   * 형제 컬럼과 같이 F_GET_TIME_STR 로 맞췄다. 이 탭은 PB 에서 한 번도 실행된 적이
   * 없어(위 '//' 결함) 맞출 기준 화면도 없다.
   */
  private async findSolder(itemBarcode?: string) {
    if (!itemBarcode) return [];
    const since = (from: string) =>
      `F_GET_TIME_STR(ROUND(NVL(NVL(s.DESTROY_DATE, SYSDATE) - NVL(${from}, SYSDATE), 0) * 24, 3))`;
    return (await this.dataSource.query(
      `SELECT s.ITEM_CODE                               AS "itemCode",
              s.ITEM_BARCODE                            AS "itemBarcode",
              s.SOLDER_LOT_NO                           AS "solderLotNo",
              s.SOLDER_TYPE                             AS "solderType",
              s.MODEL_NAME                              AS "modelName",
              s.LINE_CODE                               AS "lineCode",
              s.WORKSTAGE_CODE                          AS "workstageCode",
              s.MACHINE_CODE                            AS "machineCode",
              s.RUN_NO                                  AS "runNo",
              TO_CHAR(s.RECEIPT_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "receiptDate",
              TO_CHAR(s.ISSUE_DATE, 'YYYY-MM-DD HH24:MI:SS')    AS "issueDate",
              TO_CHAR(s.OPEN_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "openDate",
              TO_CHAR(s.RETURN_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "returnDate",
              TO_CHAR(s.INPUT_DATE, 'YYYY-MM-DD HH24:MI:SS')    AS "inputDate",
              TO_CHAR(s.FIRST_LINE_INPUT_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "firstLineInputDate",
              TO_CHAR(s.DESTROY_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "destroyDate",
              TO_CHAR(s.VALID_DATE, 'YYYY-MM-DD')               AS "validDate",
              ROUND(s.VALID_DATE - DECODE(s.DESTROY_DATE, NULL, SYSDATE, s.DESTROY_DATE), 0)
                                                        AS "validCount",
              TO_CHAR(s.UNFREEZING_START_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "unfreezingStartDate",
              TO_CHAR(s.UNFREEZING_END_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "unfreezingEndDate",
              s.FREEZER_IN_TEMP                         AS "freezerInTemp",
              s.UNFREEZING_START_TEMP                   AS "unfreezingStartTemp",
              s.UNFREEZING_END_TEMP                     AS "unfreezingEndTemp",
              F_GET_TIME_STR(ROUND(NVL(NVL(s.UNFREEZING_END_DATE, SYSDATE)
                                       - NVL(s.UNFREEZING_START_DATE, SYSDATE), 0) * 24, 3))
                                                        AS "unfreezingWaitTime",
              TO_CHAR(s.MIX_START_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "mixStartDate",
              TO_CHAR(s.MIX_END_DATE, 'YYYY-MM-DD HH24:MI:SS')    AS "mixEndDate",
              F_GET_TIME_STR(ROUND(NVL(NVL(s.MIX_END_DATE, SYSDATE)
                                       - NVL(s.MIX_START_DATE, SYSDATE), 0) * 24, 3))
                                                        AS "mixWaitTime",
              TO_CHAR(s.VISCOSITY_START_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "viscosityStartDate",
              TO_CHAR(s.VISCOSITY_END_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "viscosityEndDate",
              s.VISCOSITY                               AS "viscosity",
              s.VISCOSITY_OPERATOR                      AS "viscosityOperator",
              s.VISCOSITY_FILE_NAME                     AS "viscosityFileName",
              s.RPM                                     AS "rpm",
              s."TIME"                                  AS "mixTime",
              s.TEMP                                    AS "temp",
              ${since(`DECODE(s.VISCOSITY_START_DATE, NULL, s.INPUT_DATE, s.VISCOSITY_END_DATE)`)}
                                                        AS "afterViscosityTime",
              ${since('s.ISSUE_DATE')}                  AS "afterIssueTime",
              ${since('s.FIRST_LINE_INPUT_DATE')}       AS "afterFirstLineInputTime"
         FROM IM_ITEM_SOLDER_MASTER s
        WHERE s.ITEM_BARCODE LIKE :itemBarcode ESCAPE '\\'
        ORDER BY s.INPUT_DATE DESC
        FETCH FIRST ${TAB_ROW_LIMIT} ROWS ONLY`,
      { itemBarcode: likePrefix(itemBarcode) } as unknown as unknown[],
    )) as Row[];
  }

  /** 마스크 점검 탭 — 이 마스크 지그 롯트의 점검 이력 */
  private async findMaskCheck(jigLotNo?: string) {
    if (!jigLotNo) return [];
    return (await this.dataSource.query(
      `SELECT c.JIG_CODE                                AS "jigCode",
              c.JIG_LOT_NO                              AS "jigLotNo",
              c.JIG_CHECK_SEQUENCE                      AS "checkSequence",
              TO_CHAR(c.JIG_CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "checkDate",
              c.JIG_CHECK_STATUS                        AS "checkStatus",
              c.LINE_CODE                               AS "lineCode",
              c.USED_QTY                                AS "usedQty",
              c.ACTUAL_VALUE                            AS "actualValue",
              c.USED_BY                                 AS "usedBy",
              c.CLEAN_YN                                AS "cleanYn",
              c.TENSION_CHECK1                          AS "tension1",
              c.TENSION_CHECK2                          AS "tension2",
              c.TENSION_CHECK3                          AS "tension3",
              c.TENSION_CHECK4                          AS "tension4",
              c.TENSION_CHECK5                          AS "tension5",
              c.MAX_TENSION                             AS "maxTension",
              c.BREAK_VALUE                             AS "breakValue",
              c.HIT_VALUE                               AS "hitValue",
              c.RETURN_BY                               AS "returnBy",
              c.CONFIRM_YN                              AS "confirmYn",
              TO_CHAR(c.CONFIRM_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "confirmDate",
              c.COMMENTS                                AS "comments",
              c.ENTER_BY                                AS "enterBy",
              TO_CHAR(c.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "enterDate"
         FROM IMCN_JIG_MASK_CHECK c
        WHERE c.JIG_LOT_NO = :jigLotNo
        ORDER BY c.JIG_CHECK_DATE DESC
        FETCH FIRST ${TAB_ROW_LIMIT} ROWS ONLY`,
      { jigLotNo } as unknown as unknown[],
    )) as Row[];
  }

  /** 스퀴지 점검 탭 — PB 는 스퀴지 롯트 2개를 OR 로 본다 (전·후면) */
  private async findSqueezeCheck(jigLotNo?: string, jigLotNo2?: string) {
    const lots = [jigLotNo, jigLotNo2].filter((v): v is string => Boolean(v));
    if (lots.length === 0) return [];
    const placeholders = lots.map((_, i) => `:lot${i}`).join(', ');
    const binds: Record<string, unknown> = {};
    lots.forEach((v, i) => {
      binds[`lot${i}`] = v;
    });
    return (await this.dataSource.query(
      `SELECT c.JIG_CODE                                AS "jigCode",
              c.JIG_LOT_NO                              AS "jigLotNo",
              c.JIG_CHECK_SEQUENCE                      AS "checkSequence",
              TO_CHAR(c.JIG_CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "checkDate",
              c.JIG_CHECK_STATUS                        AS "checkStatus",
              c.LINE_CODE                               AS "lineCode",
              c.CLEAN_YN                                AS "cleanYn",
              c.PIN_HOLE_YN                             AS "pinHoleYn",
              c.BREAK_VALUE                             AS "breakValue",
              c.HIT_VALUE                               AS "hitValue",
              c.CONFIRM_YN                              AS "confirmYn",
              TO_CHAR(c.CONFIRM_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "confirmDate",
              c.COMMENTS                                AS "comments",
              c.ENTER_BY                                AS "enterBy",
              TO_CHAR(c.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "enterDate"
         FROM IMCN_JIG_SQUEZE_CHECK c
        WHERE c.JIG_LOT_NO IN (${placeholders})
        ORDER BY c.JIG_CHECK_DATE DESC
        FETCH FIRST ${TAB_ROW_LIMIT} ROWS ONLY`,
      binds as unknown as unknown[],
    )) as Row[];
  }

  /**
   * MSL 탭 — 이 라인에 물려 있는 자재 중 MSL 경과율이 높은 것.
   *
   * PB 는 (라인, '%', 경과율 0, MSL 레벨 '2') 를 넘겼다. 그 상수를 유지한다 —
   * MSL 2 이상만 관리 대상이고, 경과율 0 은 '전부 보여준다' 는 뜻이다.
   */
  private async findMslWatch(lineCode: string, organizationId: number) {
    const checkhist = (expr: string) =>
      `( SELECT ${expr} FROM IB_SMT_CHECKHIST WHERE LOT_NO = v.LOT_NO )`;
    return (await this.dataSource.query(
      `SELECT v.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(v.LINE_CODE, :organizationId) AS "lineName",
              v.LOCATION_CODE                           AS "locationCode",
              v.PCB_ITEM                                AS "pcbItem",
              v.CCS_YN                                  AS "ccsYn",
              v.MODEL_NAME                              AS "modelName",
              v.ITEM_CODE                               AS "itemCode",
              v.ITEM_NAME                               AS "itemName",
              v.ITEM_SPEC                               AS "itemSpec",
              v.PART_NO                                 AS "partNo",
              v.ITEM_BARCODE                            AS "itemBarcode",
              v.LOT_NO                                  AS "lotNo",
              v.SCAN_QTY                                AS "scanQty",
              v.NEW_SCAN_QTY                            AS "newScanQty",
              v.ISSUE_COMPARE_YN                        AS "issueCompareYn",
              TO_CHAR(v.ISSUE_COMPARE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "issueCompareDate",
              TO_CHAR(v.CHANGE_DATE, 'YYYY-MM-DD HH24:MI:SS')        AS "changeDate",
              v.MSL_LEVEL                               AS "mslLevel",
              v.MSL_MAX_TIME                            AS "mslMaxTime",
              TRUNC(v.PASSED_TIME, 2)                   AS "mslPassedHour",
              TRUNC(v.MSL_MAX_TIME - v.PASSED_TIME, 2)  AS "mslRemainHour",
              TRUNC(v.MSL_PRE_PASSED_TIME, 2)           AS "mslPrePassedTime",
              v.PASSED_RATE                             AS "passedRate",
              TO_CHAR(v.BAKING_START_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "bakingStartDate",
              TO_CHAR(v.BAKING_END_DATE, 'YYYY-MM-DD HH24:MI:SS')    AS "bakingEndDate",
              ${checkhist('SUM(1)')}                    AS "checkCount",
              TO_CHAR(${checkhist('MIN(CHECK_DATE)')}, 'YYYY-MM-DD HH24:MI:SS')
                                                        AS "checkMinTime",
              TO_CHAR(${checkhist('MAX(CHECK_DATE)')}, 'YYYY-MM-DD HH24:MI:SS')
                                                        AS "checkMaxTime",
              ( SELECT NVL(SUM(1), 0) FROM IM_ITEM_BAKING_MASTER
                 WHERE LOT_NO = v.LOT_NO AND CHAMBER_TYPE = 'B' ) AS "bakingCount"
         FROM IM_ITEM_MSL_CHECK_VIEW v
        WHERE v.LINE_CODE = :lineCode
          AND v.MSL_LEVEL >= '2'
          AND v.MSL_MAX_TIME > 0
        ORDER BY v.PASSED_RATE DESC, v.LOCATION_CODE
        FETCH FIRST ${TAB_ROW_LIMIT} ROWS ONLY`,
      { lineCode, organizationId } as unknown as unknown[],
    )) as Row[];
  }

  /** PCB 투입 탭 — 이 롯트에 스캔된 PCB */
  private async findPcbInput(runNo: string) {
    return (await this.dataSource.query(
      `SELECT m.RUN_NO                                  AS "runNo",
              m.MODEL_NAME                              AS "modelName",
              m.LINE_CODE                               AS "lineCode",
              m.MACHINE_CODE                            AS "machineCode",
              m.WORKSTAGE_CODE                          AS "workstageCode",
              TO_CHAR(m.SCAN_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "scanDate",
              m.SCAN_BY                                 AS "scanBy",
              m.PCB_BARCODE                             AS "pcbBarcode",
              m.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              m.LOT_QTY                                 AS "lotQty",
              m.SUPPLIER_CODE                           AS "supplierCode",
              m.RECEIPT_STATUS                          AS "receiptStatus",
              b.SUPPLIER_BARCODE                        AS "supplierBarcode",
              b.ITEM_BARCODE                            AS "itemBarcode",
              b.MANUFACTURE_WEEK                        AS "manufactureWeek",
              i.PCB_COATING_TYPE                        AS "pcbCoatingType",
              i.PCB_COATING_MAX_DAY                     AS "pcbCoatingMaxDay",
              TO_CHAR(b.PCB_COATING_DATE, 'YYYY-MM-DD')  AS "pcbCoatingDate"
         FROM IP_PRODUCT_PCB_SCAN_MASTER m
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = m.ITEM_CODE AND i.ORGANIZATION_ID = m.ORGANIZATION_ID
         LEFT JOIN IM_ITEM_RECEIPT_BARCODE b ON b.ITEM_BARCODE = m.PCB_BARCODE
        WHERE m.RUN_NO = :runNo
        ORDER BY m.SCAN_DATE
        FETCH FIRST ${TAB_ROW_LIMIT} ROWS ONLY`,
      { runNo } as unknown as unknown[],
    )) as Row[];
  }

  /** 샘플 탭 — 이 롯트에 투입된 샘플(치공구) */
  private async findSampleInput(runNo: string, organizationId: number) {
    return (await this.dataSource.query(
      `SELECT TO_CHAR(h.INPUT_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "inputDate",
              h.LINE_CODE                               AS "lineCode",
              F_GET_LINE_NAME(h.LINE_CODE, :organizationId) AS "lineName",
              h.SAMPLE_TYPE                             AS "sampleType",
              h.SAMPLE_CODE                             AS "sampleCode",
              h.SAMPLE_LOT_NO                           AS "sampleLotNo",
              j.SAMPLE_SPEC                             AS "sampleSpec",
              TO_CHAR(j.SAMPLE_APPLY_DATE, 'YYYY-MM-DD') AS "sampleApplyDate",
              TO_CHAR(h.CURRENT_APPLY_DATE, 'YYYY-MM-DD') AS "currentApplyDate",
              r.RUN_NO                                  AS "runNo",
              r.ITEM_CODE                               AS "itemCode",
              r.MODEL_NAME                              AS "modelName",
              h.ENTER_BY                                AS "enterBy",
              TO_CHAR(h.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "enterDate"
         FROM IMCN_SAMPLE_INPUT_HIST h
         JOIN IP_PRODUCT_RUN_CARD r
              ON r.RUN_NO = h.RUN_NO AND r.ORGANIZATION_ID = h.ORGANIZATION_ID
         JOIN IMCN_SAMPLE j
              ON j.SAMPLE_CODE = h.SAMPLE_CODE
             AND j.SAMPLE_LOT_NO = h.SAMPLE_LOT_NO
             AND j.ORGANIZATION_ID = h.ORGANIZATION_ID
        WHERE r.RUN_NO = :runNo
        ORDER BY h.INPUT_DATE
        FETCH FIRST ${TAB_ROW_LIMIT} ROWS ONLY`,
      { runNo, organizationId } as unknown as unknown[],
    )) as Row[];
  }

  /** 릴교환 탭 — 이 롯트의 SMT 자재 투입·교환 이력 */
  private async findReelChange(runNo: string) {
    return (await this.dataSource.query(
      `SELECT F_GET_CCS_OK_COUNT(c.LINE_CODE)           AS "ccsOkCount",
              TO_CHAR(c.CHECK_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "checkDate",
              c.CHECK_SEQUENCE                          AS "checkSequence",
              c.FULL_CHECK_SEQUENCE                     AS "fullCheckSequence",
              TO_CHAR(c.PLAN_DATE, 'YYYY-MM-DD')        AS "planDate",
              c.PLAN_DATE_SEQUENCE                      AS "planDateSequence",
              c.LOT_NAME                                AS "lotName",
              c.LINE_CODE                               AS "lineCode",
              c.MACHINE                                 AS "machine",
              c.FEEDER_SHAFT                            AS "feederShaft",
              c.TABLE_ID                                AS "tableId",
              c.LOCATION_CODE                           AS "locationCode",
              c.PCB_ITEM                                AS "pcbItem",
              c.PARTNAME                                AS "partName",
              c.CHIPNAME                                AS "chipName",
              c.SCAN_PARTNAME                           AS "scanPartName",
              c.SCAN_SUPPLIER_PARTNAME                  AS "scanSupplierPartName",
              c.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.MSL_LEVEL                               AS "mslLevel",
              i.MSL_MAX_TIME                            AS "mslMaxTime",
              c.CHECK_TYPE                              AS "checkType",
              ct.CODE_MEAN_KOR                          AS "checkTypeName",
              c.CHECK_STATUS                            AS "checkStatus",
              cs.CODE_MEAN_KOR                          AS "checkStatusName",
              c.CHECK_MSG                               AS "checkMsg",
              c.CHECK_BY                                AS "checkBy",
              c.NG_REASON                               AS "ngReason",
              c.NG_TYPE                                 AS "ngType",
              c.COMMENTS                                AS "comments",
              c.SMT_MODEL_NAME                          AS "smtModelName",
              c.LOT_NO                                  AS "lotNo",
              c.OLD_BARCODE                             AS "oldBarcode",
              c.SUPPLIER_BARCODE_ORIGIN                 AS "supplierBarcodeOrigin",
              c.OUR_BARCODE_ORIGIN                      AS "ourBarcodeOrigin",
              TO_CHAR(c.VALID_DATE, 'YYYY-MM-DD')       AS "validDate",
              c.LOT_SERIAL                              AS "lotSerial",
              TO_CHAR(c.CCS_END_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "ccsEndDate",
              c.UNLOCK_BY                               AS "unlockBy",
              TO_CHAR(c.UNLOCK_DATE, 'YYYY-MM-DD HH24:MI:SS')  AS "unlockDate",
              b.SCAN_QTY                                AS "scanQty",
              b.SUPPLIER_CODE                           AS "supplierCode",
              b.BARCODE_STATUS                          AS "barcodeStatus",
              TO_CHAR(b.RECEIPT_COMPARE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "receiptCompareDate",
              TO_CHAR(b.ISSUE_COMPARE_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS "issueCompareDate",
              NVL(b.LOT_DIVIDE_YN, 'N')                 AS "lotDivideYn",
              TO_CHAR(b.LOT_DIVIDE_DATE, 'YYYY-MM-DD HH24:MI:SS')      AS "lotDivideDate"
         FROM IB_SMT_CHECKHIST c
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = c.PARTNAME
         LEFT JOIN IM_ITEM_RECEIPT_BARCODE b ON b.LOT_NO = c.LOT_NO
         LEFT JOIN ISYS_BASECODE ct
                ON ct.CODE_TYPE = 'CHECK TYPE' AND ct.CODE_NAME = c.CHECK_TYPE
         LEFT JOIN ISYS_BASECODE cs
                ON cs.CODE_TYPE = 'CHECK STATUS' AND cs.CODE_NAME = c.CHECK_STATUS
        WHERE c.RUN_NO = :runNo
        ORDER BY c.CHECK_DATE DESC
        FETCH FIRST ${TAB_ROW_LIMIT} ROWS ONLY`,
      { runNo } as unknown as unknown[],
    )) as Row[];
  }

  /**
   * 인터록 탭 — 이 라인의 NSNP(오삽 방지) 이력.
   *
   * PB 는 여기에 Run No 를 넘겼는데 DataWindow 는 LINE_CODE 로 걸러서
   * **항상 0행이었다.** 라인코드로 찾는다.
   */
  private async findInterlockHistory(lineCode: string, organizationId: number) {
    return (await this.dataSource.query(
      `SELECT n.LINE_CODE                               AS "lineCode",
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
        WHERE n.LINE_CODE = :lineCode
          AND n.ORGANIZATION_ID = :organizationId
        ORDER BY n.ENTER_DATE DESC
        FETCH FIRST ${TAB_ROW_LIMIT} ROWS ONLY`,
      { lineCode, organizationId } as unknown as unknown[],
    )) as Row[];
  }
}

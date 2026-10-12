/**
 * @file src/modules/planning/result.service.ts
 * @description 기간별 생산실적 조회 + 생산일보 리포트
 *              PB w_pln_product_pcb_result_query / w_pln_product_pcb_result_report 이식
 *
 * 초보자 가이드:
 * 1. **실적의 원천은 IP_PRODUCT_WORKSTAGE_IO 다** (245,717행). PID 한 장이 공정을
 *    지날 때마다 한 줄 쌓인다. 그래서 세 단계로 좁혀 본다:
 *      기간 집계 → 작업지시별 공정 집계 → 그 공정의 PID 목록
 *    PB 도 DataWindow 세 개로 같은 순서였다.
 * 2. **PB 의 필터 컬럼과 집계 컬럼이 다르다.** 기간은 ACTUAL_DATE 로 걸고
 *    최초·최종 시각은 IO_DATE 에서 뽑는다. 헷갈리기 쉬운데 PB 그대로 유지한다 —
 *    ACTUAL_DATE 는 업무일이고 IO_DATE 는 실제 통과 시각이다.
 * 3. **생산일보는 OEE 계산이다.** 시간가동률 × 성능가동률 × 양품률 = 종합효율.
 *    계산에 쓰는 여섯 함수는 SQL 안에서 그대로 부른다 — 휴게·로스 시간과
 *    실적·불량 수량 판정이 PB 와 갈리면 일보 숫자가 전부 틀린다.
 *      F_GET_RUN_LINE_ACTUAL_QTY / F_GET_RUN_NG_QTY
 *      F_GET_RUN_LINE_PDA_ON / F_GET_RUN_LINE_PDA_OFF
 *      F_GET_WORK_BREAKTIME_MIN / F_GET_WORK_LOSSTIME_MIN
 * 4. **솔더유형은 코드표를 조인한다.** PB 는 `DECODE(solder_type,'F','무연','유연')`
 *    로 한글을 SQL 에 박아 뒀다. ISYS_BASECODE 'SOLDER TYPE' 에 F=무연 / P=유연이
 *    있으므로 조인해서 쓴다 — 코드가 늘어도 화면이 따라간다.
 * 5. **비율은 소수 한 자리까지 내린다.** PB 는 `round(x*100)` 으로 정수로 끊었다.
 *    같은 행이 PB 에서 55%, 웹에서 55.3% 로 보인다 — 값이 다른 것이 아니라
 *    자리수가 다른 것이다. 정수로 끊으면 55.4 와 54.6 이 같은 55 가 되어
 *    라인 간 비교가 무의미해진다. 검산: 종합효율 = 시간가동 × 성능 × 양품
 *    (2026-09-19 실측 1행에서 55.3% = 100% × 55.3% × 100% 로 일치).
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import {
  DailyReportQueryDto,
  ResultByRunQueryDto,
  ResultQueryDto,
  ResultSerialQueryDto,
} from './result.dto';
import { like } from './plan-shared';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;

/** PID 목록은 한 공정에 수천 건이 될 수 있어 상한을 둔다. */
const SERIAL_LIMIT = 5000;

@Injectable()
export class ResultService {
  constructor(private readonly dataSource: DataSource) {}

  /** 기간 집계 — PB d_pln_product_pcb_result_lst. */
  async findByPeriod(query: ResultQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT io.MODEL_NAME AS "modelName", io.RUN_NO AS "runNo",
              io.LINE_CODE AS "lineCode", pl.LINE_NAME AS "lineName",
              io.WORKSTAGE_CODE AS "workstageCode",
              F_GET_RUN_LOT_QTY(io.RUN_NO) AS "lotQty",
              SUM(io.IO_QTY) AS "resultQty",
              COUNT(*) AS "rowCount",
              MIN(io.IO_DATE) AS "firstDate",
              MAX(io.IO_DATE) AS "lastDate"
         FROM IP_PRODUCT_WORKSTAGE_IO io
         LEFT JOIN IP_PRODUCT_LINE pl
                ON pl.LINE_CODE = io.LINE_CODE
               AND pl.ORGANIZATION_ID = io.ORGANIZATION_ID
        WHERE io.ORGANIZATION_ID = :organizationId
          AND io.ACTUAL_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
          AND io.ACTUAL_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
          AND NVL(io.MODEL_NAME, '*') LIKE :modelName
          AND NVL(io.RUN_NO, '*') LIKE :runNo
          AND NVL(io.LINE_CODE, '*') LIKE :lineCode
          AND NVL(io.WORKSTAGE_CODE, '*') LIKE :workstageCode
        GROUP BY io.MODEL_NAME, io.RUN_NO, io.LINE_CODE, pl.LINE_NAME,
                 io.WORKSTAGE_CODE
        ORDER BY io.MODEL_NAME, io.RUN_NO, io.LINE_CODE, io.WORKSTAGE_CODE`,
      namedBinds({
        organizationId,
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        modelName: like(query.modelName),
        runNo: like(query.runNo),
        lineCode: like(query.lineCode),
        workstageCode: like(query.workstageCode),
      }),
    )) as Row[];
    return { data: rows, total: rows.length };
  }

  /** 작업지시별 공정 집계 — PB d_pln_product_pcb_run_result_lst. */
  async findByRun(query: ResultByRunQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT io.RUN_NO AS "runNo",
              io.LINE_CODE AS "lineCode", pl.LINE_NAME AS "lineName",
              io.WORKSTAGE_CODE AS "workstageCode",
              SUM(io.IO_QTY) AS "resultQty",
              COUNT(*) AS "rowCount",
              MIN(io.IO_DATE) AS "firstDate",
              MAX(io.IO_DATE) AS "lastDate"
         FROM IP_PRODUCT_WORKSTAGE_IO io
         LEFT JOIN IP_PRODUCT_LINE pl
                ON pl.LINE_CODE = io.LINE_CODE
               AND pl.ORGANIZATION_ID = io.ORGANIZATION_ID
        WHERE io.RUN_NO = :runNo
          AND io.ORGANIZATION_ID = :organizationId
        GROUP BY io.RUN_NO, io.LINE_CODE, pl.LINE_NAME, io.WORKSTAGE_CODE
        ORDER BY io.LINE_CODE, io.WORKSTAGE_CODE`,
      namedBinds({ runNo: query.runNo.trim(), organizationId }),
    )) as Row[];
    return { data: rows, total: rows.length };
  }

  /**
   * 그 공정을 지난 PID 목록 — PB d_pln_product_pcb_serial_lst.
   * 상한을 넘으면 잘렸다고 알려 준다 — 잘린 목록을 "그게 전부" 로 읽으면 안 된다.
   */
  async findSerials(query: ResultSerialQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT io.IO_DATE AS "ioDate", io.SERIAL_NO AS "serialNo",
              io.IO_QTY AS "ioQty"
         FROM IP_PRODUCT_WORKSTAGE_IO io
        WHERE io.RUN_NO = :runNo
          AND io.LINE_CODE = :lineCode
          AND io.WORKSTAGE_CODE = :workstageCode
          AND io.ORGANIZATION_ID = :organizationId
        ORDER BY io.IO_DATE, io.SERIAL_NO
        FETCH FIRST ${SERIAL_LIMIT + 1} ROWS ONLY`,
      namedBinds({
        runNo: query.runNo.trim(),
        lineCode: query.lineCode.trim(),
        workstageCode: query.workstageCode.trim(),
        organizationId,
      }),
    )) as Row[];
    const truncated = rows.length > SERIAL_LIMIT;
    return {
      data: truncated ? rows.slice(0, SERIAL_LIMIT) : rows,
      total: truncated ? SERIAL_LIMIT : rows.length,
      truncated,
      limit: SERIAL_LIMIT,
    };
  }

  /**
   * 생산일보 — PB d_pln_product_pcb_result_report(_actual_date).
   *
   * PB 의 4단 중첩 인라인뷰를 그대로 유지한다. 각 단이 앞 단의 계산 결과를
   * 다시 쓰기 때문에 한 단으로 펼치면 같은 함수를 여러 번 부르게 된다.
   *   ① 함수 호출로 실적·불량·시작·종료를 구한다
   *   ② 불량PPM·생산시간·휴게시간·로스시간
   *   ③ 가용시간 = 생산 - 휴게, 실가동 = 가용 - 로스
   *   ④ 시간가동률·성능가동률·양품률 → 종합효율
   */
  async findDailyReport(query: DailyReportQueryDto, organizationId: number) {
    // PB 는 DataWindow 두 개로 기준일 조건만 바꿨다. 실제 조건은 이렇다:
    //   작업지시일 기준 : c.RUN_DATE 가 그 날
    //   실생산일 기준   : PDA ON(생산시작) 시각의 날짜가 그 날
    //
    // 'c.ACTUAL_DATE' 라는 컬럼은 없다. DataWindow 이름이 _actual_date 라서
    // 컬럼명으로 착각하기 쉽다 — IP_PRODUCT_RUN_CARD 에는 RUN_DATE 만 있다.
    //
    // **PB 창을 대칭으로 넓혔다.** PB 는 `run_date >= d - 30 AND run_date <= d` 로
    // 한쪽만 봤다. 작업지시일보다 생산이 먼저 시작되는 일이 실제로 있어서
    // 그런 행이 조용히 빠진다 — 최근 180일 실측:
    //     같은 날 1,140건 / 지시일보다 이름 195건(최대 10일) / 지시일 후 172건(최대 10일)
    // 13%(195건)를 놓치는 셈이라 ±30일로 바꿨다. 관측된 편차 ±10일에 여유를 뒀고,
    // RUN_DATE 범위 조건은 그대로 남아 함수 호출 대상을 좁히는 역할을 계속한다.
    const dateCondition = query.dateBasis === 'actual'
      ? `c.RUN_DATE >= TRUNC(TO_DATE(:reportDate, 'YYYY-MM-DD')) - 30
                          AND c.RUN_DATE < TRUNC(TO_DATE(:reportDate, 'YYYY-MM-DD')) + 31
                          AND TRUNC(F_GET_RUN_LINE_PDA_ON(c.RUN_NO, c.LINE_CODE,
                                                          c.ORGANIZATION_ID))
                              = TRUNC(TO_DATE(:reportDate, 'YYYY-MM-DD'))`
      : `c.RUN_DATE >= TO_DATE(:reportDate, 'YYYY-MM-DD')
                          AND c.RUN_DATE < TO_DATE(:reportDate, 'YYYY-MM-DD') + 1`;
    const rows = (await this.dataSource.query(
      `SELECT lineCode AS "lineCode", lineName AS "lineName",
              runDate AS "runDate", runNo AS "runNo",
              pcbItem AS "pcbItem", modelName AS "modelName",
              lotSize AS "lotSize", carrierSize AS "carrierSize",
              solderType AS "solderType", solderTypeName AS "solderTypeName",
              resultQty AS "resultQty", badQty AS "badQty",
              ROUND(badPpm) AS "badPpm",
              productStart AS "productStart", productEnd AS "productEnd",
              ROUND(productTime) AS "productTime",
              ROUND(restTime) AS "restTime",
              ROUND(lossTime) AS "lossTime",
              ROUND(availableTime) AS "availableTime",
              ROUND(actualTime) AS "actualTime",
              ROUND(timeRate * 100, 1) AS "timeWorkingRate",
              ROUND(performanceRate * 100, 1) AS "performanceWorkingRate",
              ROUND(goodRate * 100, 1) AS "goodProductRate",
              ROUND(timeRate * performanceRate * goodRate * 100, 1) AS "overallEfficiency"
         FROM (
           SELECT lineCode, lineName, runDate, runNo, pcbItem, modelName,
                  lotSize, carrierSize, solderType, solderTypeName,
                  resultQty, badQty, badPpm, productStart, productEnd,
                  productTime, restTime, lossTime, availableTime, actualTime,
                  DECODE(availableTime, 0, 0, actualTime / availableTime) timeRate,
                  DECODE(actualTime * carrierSize, 0, 0,
                         resultQty / (actualTime * carrierSize)) performanceRate,
                  DECODE(resultQty, 0, 0, 1 - (badQty / resultQty)) goodRate
             FROM (
               SELECT lineCode, lineName, runDate, runNo, pcbItem, modelName,
                      lotSize, carrierSize, solderType, solderTypeName,
                      resultQty, badQty, badPpm, productStart, productEnd,
                      productTime, restTime, lossTime,
                      (productTime - restTime) availableTime,
                      (productTime - restTime - lossTime) actualTime
                 FROM (
                   SELECT lineCode, lineName, runDate, runNo, pcbItem, modelName,
                          lotSize, carrierSize, solderType, solderTypeName,
                          resultQty, badQty, productStart, productEnd,
                          DECODE(resultQty, 0, 0, (badQty / resultQty) * 1000000) badPpm,
                          DECODE(productEnd, NULL, 0,
                                 (productEnd - productStart) * (24 * 60)) productTime,
                          F_GET_WORK_BREAKTIME_MIN(productStart, productEnd) restTime,
                          F_GET_WORK_LOSSTIME_MIN(lineCode, productStart, productEnd) lossTime
                     FROM (
                       SELECT c.LINE_CODE lineCode, pl.LINE_NAME lineName,
                              c.RUN_DATE runDate, c.RUN_NO runNo,
                              c.PCB_ITEM pcbItem, c.MODEL_NAME modelName,
                              c.LOT_SIZE lotSize, m.CARRIER_SIZE carrierSize,
                              m.SOLDER_TYPE solderType, st.CODE_MEAN_KOR solderTypeName,
                              F_GET_RUN_LINE_ACTUAL_QTY(c.RUN_NO, c.LINE_CODE,
                                                        c.ORGANIZATION_ID) resultQty,
                              F_GET_RUN_NG_QTY(c.RUN_NO, c.ORGANIZATION_ID) badQty,
                              F_GET_RUN_LINE_PDA_ON(c.RUN_NO, c.LINE_CODE,
                                                    c.ORGANIZATION_ID) productStart,
                              F_GET_RUN_LINE_PDA_OFF(c.RUN_NO, c.LINE_CODE,
                                                     c.ORGANIZATION_ID) productEnd
                         FROM IP_PRODUCT_RUN_CARD c
                         LEFT JOIN IP_PRODUCT_MODEL_MASTER m
                                ON m.MODEL_NAME = c.MODEL_NAME
                               AND m.ORGANIZATION_ID = c.ORGANIZATION_ID
                         LEFT JOIN IP_PRODUCT_LINE pl
                                ON pl.LINE_CODE = c.LINE_CODE
                               AND pl.ORGANIZATION_ID = c.ORGANIZATION_ID
                         LEFT JOIN ISYS_BASECODE st
                                ON st.CODE_TYPE = 'SOLDER TYPE'
                               AND st.CODE_NAME = m.SOLDER_TYPE
                        WHERE ${dateCondition}
                          AND c.ORGANIZATION_ID = :organizationId
                          AND NVL(c.LINE_CODE, '*') LIKE :lineCode
                          AND NVL(c.MODEL_NAME, '*') LIKE :modelName
                          AND NVL(c.RUN_NO, '*') LIKE :runNo
                     )
                 )
             )
         )
        ORDER BY "lineCode", "modelName", "runNo"`,
      namedBinds({
        reportDate: query.reportDate,
        organizationId,
        lineCode: like(query.lineCode),
        modelName: like(query.modelName),
        runNo: like(query.runNo),
      }),
    )) as Row[];
    return { data: rows, total: rows.length };
  }
}

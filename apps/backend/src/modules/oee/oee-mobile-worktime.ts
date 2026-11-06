/**
 * @file src/modules/oee/oee-mobile-worktime.ts
 * @description OEE 비가동 입력의 현재 업무일·근무구간 — DB 시각으로 정한다.
 *
 * 초보자 가이드:
 * 1. **지금 시각은 DB 의 SYSDATE 다.** 앱 서버 시계를 쓰지 않는다 — 저장되는 시작·종료시각도 같은 값이다.
 * 2. **업무일은 DB 함수 F_GET_WORK_ACTUAL_DATE(SYSDATE, 'A')** — ICOM_WORKTIME_RANGES 의
 *    SMTWORKTIME A 시작시각(08:30) 전이면 전날이다. 생산보드와 같은 기준이다.
 * 3. **근무구간은 ICOM_WORKTIME_RANGES 의 A~J 중 지금을 포함하는 한 칸이다.**
 *    ATTRIBUTE01/02 는 시작·종료가 업무일에서 며칠 뒤인지(0/1)다. A~E 는 주간(DAY), F~J 는 야간(NIGHT).
 */
import { BadRequestException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { namedBinds } from '../../common/utils/named-binds.util';

export const OEE_MOBILE_WORK_SEGMENTS = ['DAY', 'NIGHT'] as const;
export type OeeMobileWorkSegment = (typeof OEE_MOBILE_WORK_SEGMENTS)[number];

export interface OeeMobileWorkContext {
  /** 업무일 'YYYY-MM-DD' */
  workDate: string;
  /** 업무일 0시 (DB DATE 그대로 — WORK_DATE 컬럼에 저장할 값) */
  workDay: Date;
  workSegment: OeeMobileWorkSegment;
  /** DB 지금 시각 (SYSDATE) */
  now: Date;
  /** 업무일 시작 시각 — 업무일 + A 구간 시작 */
  workStart: Date;
}

/** 'HHMI[SS]' 문자열 + 날짜 offset → 업무일 기준 일수 */
const offsetExpr = (time: string, dayOffset: string) =>
  `NVL(TO_NUMBER(${dayOffset}), 0) + TO_NUMBER(SUBSTR(${time}, 1, 2)) / 24 + TO_NUMBER(SUBSTR(${time}, 3, 2)) / 1440`;

export const OEE_WORK_CONTEXT_SQL = `
  WITH w AS (
    SELECT SYSDATE AS NOW, F_GET_WORK_ACTUAL_DATE(SYSDATE, 'A') AS WORK_DATE FROM DUAL
  ), r AS (
    SELECT WORK_TYPE,
           ${offsetExpr('START_TIME', 'ATTRIBUTE01')} AS START_OFFSET,
           ${offsetExpr('END_TIME', 'ATTRIBUTE02')} AS END_OFFSET
      FROM ICOM_WORKTIME_RANGES
     WHERE RANGE_TYPE = :rangeType AND ORGANIZATION_ID = :organizationId
  )
  SELECT TO_CHAR(w.WORK_DATE, 'YYYY-MM-DD') AS "workDate", w.WORK_DATE AS "workDay",
         r.WORK_TYPE AS "workType",
         w.NOW AS "now",
         w.WORK_DATE + (SELECT a.START_OFFSET FROM r a WHERE a.WORK_TYPE = 'A') AS "workStart"
    FROM w
    JOIN r ON w.NOW >= w.WORK_DATE + r.START_OFFSET AND w.NOW < w.WORK_DATE + r.END_OFFSET`;

/** SMT 는 SMTWORKTIME, 그 외 공정은 WORKTIME 구간을 쓴다 */
export function worktimeRangeType(processCode: string): string {
  return processCode === 'SMT' ? 'SMTWORKTIME' : 'WORKTIME';
}

export function mapSourceWorkType(workType: string): OeeMobileWorkSegment {
  return 'ABCDE'.includes(workType) ? 'DAY' : 'NIGHT';
}

/** 지금(DB 시각)의 업무일·근무구간 */
export async function findOeeWorkContext(
  dataSource: Pick<DataSource, 'query'>,
  processCode: string,
  organizationId: number,
): Promise<OeeMobileWorkContext> {
  const rows = (await dataSource.query(
    OEE_WORK_CONTEXT_SQL,
    namedBinds({ rangeType: worktimeRangeType(processCode), organizationId }),
  )) as Array<{ workDate: string; workDay: Date; workType: string; now: Date; workStart: Date | null }>;

  if (rows.length === 0) throw new BadRequestException('현재 업무시간 구간이 없습니다.');
  if (rows.length > 1) {
    throw new BadRequestException(`겹치는 업무구간이 있습니다: ${rows.map((row) => row.workType).join(',')}`);
  }
  const [row] = rows;
  if (!row.workStart) throw new BadRequestException('업무시간 A 구간이 없습니다.');
  return {
    workDate: row.workDate,
    workDay: new Date(row.workDay),
    workSegment: mapSourceWorkType(row.workType),
    now: new Date(row.now),
    workStart: new Date(row.workStart),
  };
}

/** DB 지금 시각 (SYSDATE, 초 단위) */
export async function findDbNow(dataSource: Pick<DataSource, 'query'>): Promise<Date> {
  const rows = (await dataSource.query(`SELECT SYSDATE AS "now" FROM DUAL`, [])) as Array<{ now: Date }>;
  return new Date(rows[0].now);
}

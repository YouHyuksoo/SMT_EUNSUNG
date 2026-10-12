/**
 * @file src/modules/monitoring/services/production-board.service.ts
 * @description 생산 보드(TV) 집계 서비스 — 작업일 기준 생산계획 행 + 시간대별 실적
 *
 * 초보자 가이드:
 * 1. 은성에는 작업지시 테이블이 없어서 "계획 행"이 보드의 한 줄(order)이다.
 *    SMD 계획(IP_PRODUCT_SMD_PLAN)과 제품 계획(IP_PRODUCT_MI_PLAN)을 합쳐 내려준다.
 *    - orderNo     : 계획의 WORK_ORDER_NO (없으면 'SMD-순번'/'MI-순번')
 *    - processCode : 'SMD' | 'MI' (어느 계획 테이블 행인지)
 *    - equipCode   : 라인코드 (은성은 설비가 아니라 라인 단위로 계획한다)
 * 2. "오늘" = 작업일. 은성 작업일은 08:30 에 시작하므로(ICOM_WORKTIME_RANGES SMTWORKTIME 'A' 시작)
 *    00:00~08:30 에는 아직 전날 작업일이다. DB 함수 F_GET_WORK_ACTUAL_DATE(SYSDATE,'A') 를 한 번만 조회해
 *    바인드로 쓴다(WHERE 안에서 직접 부르면 뷰 인덱스를 못 타 10초 걸린다).
 * 3. 실적은 시간대 뷰의 A~J 10칸 합이다 (계획 테이블 ACTUAL_QTY 는 갱신되지 않아 0).
 *    - SMD: IP_ASSEMBLY_ACTUAL_TIME_V (날짜·라인·모델·서픽스·PCB 면으로 계획과 맞춘다)
 *    - 제품: IP_PRODUCT_ACTUAL_TIME_V (날짜·라인·모델·공정으로 맞춘다 — 계획 화면의 PB 조인과 동일)
 *    같은 키의 계획이 여러 줄이면 실적은 우선순위·순번이 가장 앞선 한 줄에만 붙인다(이중 집계 방지).
 * 4. KPI 의 계획/실적 합은 대시보드(getSummary)와 같은 정의다 — 실적은 계획과 못 맞춘 뷰 행도 포함한다.
 * 5. 상태(status)는 계획 테이블 PLAN_STATUS 가 항상 'W' 라 쓸 수 없어서 실적 대비로 파생한다.
 *    실적 0 → WAITING / 계획 이상 → DONE / 그 사이 → RUNNING (SMD 는 마지막 실적이 1시간 넘게 멈췄으면 WAITING).
 *    HOLD 는 근거 데이터가 없어 쓰지 않는다. startAt/endAt/updatedAt 도 근거가 없어 null,
 *    lastResultAt 은 SMD 만 센서 실적(IP_PRODUCT_SENSOR_ACTUAL_TIME.LAST_RECEIPT_DATE)으로 채운다.
 * 6. 불량은 IP_PRODUCT_WORK_QC 의 QC_RESULT='N'(진성불량) 건수다(대시보드 '진성'과 같은 기준, 작업일 08:30 창).
 *    행별 불량은 라인·모델·서픽스가 맞는 SMD 계획 행에만 붙인다. 제품(MI) 행은 매칭 근거가 없어 0.
 * 7. hourly 는 항상 10칸(A~J). hour = 칸 시작 시각 'HH:MM', label = 'HH:MM~HH:MM'.
 *    칸 정의는 ICOM_WORKTIME_RANGES(SMTWORKTIME)에서 읽고, 없으면 기본값을 쓴다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { namedBinds } from '../../../common/utils/named-binds.util';
import { DASHBOARD_ACTUAL_SUM } from '../../dashboard/dashboard-insights.sql';

export interface ProductionBoardOrder {
  orderNo: string;
  itemCode: string;
  itemName: string | null;
  processCode: string | null;
  equipCode: string | null;
  status: string;
  planQty: number;
  goodQty: number;
  defectQty: number;
  achieveRate: number;
  priority: number;
  startAt: Date | null;
  endAt: Date | null;
  updatedAt: Date | null;
  lastResultAt: Date | null;
}

export interface HourlyPoint {
  hour: string;
  /** 'HH:MM~HH:MM' 표시용 라벨 (은성 추가 필드) */
  label: string;
  goodQty: number;
  defectQty: number;
}

type Num = string | number | null;

interface PlanRow {
  planSequence: Num;
  workOrderNo: string | null;
  priority: Num;
  lineCode: string | null;
  itemCode: string | null;
  itemName: string | null;
  modelName: string | null;
  planQty: Num;
  goodQty: Num;
  defectQty: Num;
  lastResultAt: Date | null;
}

interface SlotRange {
  key: string;
  start: string;
  end: string;
}

interface SlotSumRow {
  a: Num; b: Num; c: Num; d: Num; e: Num; f: Num; g: Num; h: Num; i: Num; j: Num;
}

interface QcMinuteRow {
  hhmm: string;
  cnt: Num;
}

const ORG = 1;
const SLOT_KEYS = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'] as const;

/** ICOM_WORKTIME_RANGES(SMTWORKTIME)를 못 읽을 때 쓰는 기본 시간대 (현재 DB 값과 같다) */
export const DEFAULT_SLOTS: SlotRange[] = [
  { key: 'A', start: '0830', end: '1030' },
  { key: 'B', start: '1030', end: '1240' },
  { key: 'C', start: '1240', end: '1530' },
  { key: 'D', start: '1530', end: '1740' },
  { key: 'E', start: '1740', end: '2030' },
  { key: 'F', start: '2030', end: '2230' },
  { key: 'G', start: '2230', end: '0030' },
  { key: 'H', start: '0030', end: '0330' },
  { key: 'I', start: '0330', end: '0530' },
  { key: 'J', start: '0530', end: '0830' },
];

/** SMD 계획이 마지막 실적 후 이 시간(분) 넘게 조용하면 진행 중이 아니라고 본다 */
export const STALE_MINUTES = 60;

const STATUS_RANK: Record<string, number> = { RUNNING: 0, HOLD: 1, WAITING: 2, DONE: 3 };

const n = (v: Num | undefined): number => Number(v ?? 0);
const rate = (good: number, plan: number): number => (plan > 0 ? Math.round((good / plan) * 1000) / 10 : 0);

const hhmm = (s: string): string => `${s.slice(0, 2)}:${s.slice(2, 4)}`;

/** 실적 대비 상태 파생 (HOLD 는 쓰지 않는다) */
export function deriveStatus(planQty: number, goodQty: number, lastResultAt: Date | null, now: Date): string {
  if (goodQty <= 0) return 'WAITING';
  if (planQty > 0 && goodQty >= planQty) return 'DONE';
  if (lastResultAt && now.getTime() - new Date(lastResultAt).getTime() > STALE_MINUTES * 60_000) return 'WAITING';
  return 'RUNNING';
}

/** HHMM 이 속한 시간대 칸 인덱스(0~9). 자정을 넘는 칸(G: 2230~0030)도 처리. 못 찾으면 -1 */
export function slotIndexOf(time: string, slots: SlotRange[]): number {
  return slots.findIndex((s) => (s.start <= s.end ? time >= s.start && time < s.end : time >= s.start || time < s.end));
}

/** 시간대 SQL 의 A~J 합 한 줄 → 10칸 배열 */
function slotValues(r: SlotSumRow | undefined): number[] {
  if (!r) return SLOT_KEYS.map(() => 0);
  return [r.a, r.b, r.c, r.d, r.e, r.f, r.g, r.h, r.i, r.j].map((v) => n(v));
}

/**
 * 작업일·작업 시작 시각은 getBoard() 가 먼저 한 번 조회해 바인드(:day, :startFrac)로 넘긴다.
 * F_GET_WORK_ACTUAL_DATE 를 WHERE 안에서 직접 부르면 비결정 함수라 뷰 인덱스를 못 타고
 * IP_PRODUCT_ACTUAL_TIME_V 조회가 10초 가까이 걸린다(실측: 바인드/상수는 0.2초).
 */
const WORK_DAY = `TO_DATE(:day, 'YYYY-MM-DD')`;
const WORK_START_FRACTION = ':startFrac';

/** 작업일(YYYY-MM-DD)과 작업 시작 시각(일 단위 소수; 'A' 칸 시작 HHMM, 없으면 08:30) */
export const WORK_DAY_SQL = `
  SELECT TO_CHAR(F_GET_WORK_ACTUAL_DATE(SYSDATE, 'A'), 'YYYY-MM-DD') AS "day",
         NVL((SELECT (TO_NUMBER(SUBSTR(r.START_TIME, 1, 2)) + TO_NUMBER(SUBSTR(r.START_TIME, 3, 2)) / 60) / 24
                FROM ICOM_WORKTIME_RANGES r WHERE r.RANGE_TYPE = 'SMTWORKTIME' AND r.WORK_TYPE = 'A'), 8.5 / 24) AS "startFrac"
    FROM DUAL`;

export const SMD_PLAN_SQL = `
  WITH wd AS (SELECT ${WORK_DAY} AS day FROM DUAL),
  act AS (
    SELECT v.LINE_CODE, v.MODEL_NAME, NVL(v.MODEL_SUFFIX, '*') AS MODEL_SUFFIX, NVL(v.PCB_ITEM, '*') AS PCB_ITEM,
           SUM(${DASHBOARD_ACTUAL_SUM}) AS QTY
      FROM IP_ASSEMBLY_ACTUAL_TIME_V v, wd
     WHERE v.RECEIPT_DATE >= wd.day AND v.RECEIPT_DATE < wd.day + 1
     GROUP BY v.LINE_CODE, v.MODEL_NAME, NVL(v.MODEL_SUFFIX, '*'), NVL(v.PCB_ITEM, '*')
  ), lastres AS (
    SELECT s.LINE_CODE, s.MODEL_NAME, NVL(s.MODEL_SUFFIX, '*') AS MODEL_SUFFIX, NVL(s.PCB_ITEM, '*') AS PCB_ITEM,
           MAX(s.LAST_RECEIPT_DATE) AS LAST_AT
      FROM IP_PRODUCT_SENSOR_ACTUAL_TIME s, wd
     WHERE s.ORGANIZATION_ID = ${ORG} AND s.RECEIPT_DATE >= wd.day AND s.RECEIPT_DATE < wd.day + 1
     GROUP BY s.LINE_CODE, s.MODEL_NAME, NVL(s.MODEL_SUFFIX, '*'), NVL(s.PCB_ITEM, '*')
  ), qc AS (
    SELECT q.LINE_CODE, q.MODEL_NAME, NVL(q.MODEL_SUFFIX, '*') AS MODEL_SUFFIX, COUNT(*) AS CNT
      FROM IP_PRODUCT_WORK_QC q, wd
     WHERE q.ORGANIZATION_ID = ${ORG} AND q.QC_RESULT = 'N'
       AND q.QC_DATE >= wd.day + ${WORK_START_FRACTION} AND q.QC_DATE < wd.day + 1 + ${WORK_START_FRACTION}
     GROUP BY q.LINE_CODE, q.MODEL_NAME, NVL(q.MODEL_SUFFIX, '*')
  ), plan AS (
    SELECT p.PLAN_SEQUENCE, p.WORK_ORDER_NO, p.PLAN_PRIORITY, p.LINE_CODE, p.ITEM_CODE, p.MODEL_NAME,
           NVL(p.MODEL_SUFFIX, '*') AS MODEL_SUFFIX, NVL(p.PCB_ITEM, '*') AS PCB_ITEM, NVL(p.PLAN_QTY, 0) AS PLAN_QTY,
           ROW_NUMBER() OVER (PARTITION BY p.LINE_CODE, p.MODEL_NAME, NVL(p.MODEL_SUFFIX, '*'), NVL(p.PCB_ITEM, '*')
                              ORDER BY p.PLAN_PRIORITY, p.PLAN_SEQUENCE) AS RN_ACT,
           ROW_NUMBER() OVER (PARTITION BY p.LINE_CODE, p.MODEL_NAME, NVL(p.MODEL_SUFFIX, '*')
                              ORDER BY p.PLAN_PRIORITY, p.PLAN_SEQUENCE) AS RN_QC
      FROM IP_PRODUCT_SMD_PLAN p, wd
     WHERE p.ORGANIZATION_ID = ${ORG} AND p.PLAN_DATE >= wd.day AND p.PLAN_DATE < wd.day + 1
  )
  SELECT p.PLAN_SEQUENCE AS "planSequence", p.WORK_ORDER_NO AS "workOrderNo", p.PLAN_PRIORITY AS "priority",
         p.LINE_CODE AS "lineCode", p.ITEM_CODE AS "itemCode", NVL(i.ITEM_NAME, p.MODEL_NAME) AS "itemName",
         p.MODEL_NAME AS "modelName", p.PLAN_QTY AS "planQty",
         CASE WHEN p.RN_ACT = 1 THEN NVL(a.QTY, 0) ELSE 0 END AS "goodQty",
         CASE WHEN p.RN_QC = 1 THEN NVL(q.CNT, 0) ELSE 0 END AS "defectQty",
         CASE WHEN p.RN_ACT = 1 THEN l.LAST_AT ELSE NULL END AS "lastResultAt"
    FROM plan p
    LEFT JOIN act a ON a.LINE_CODE = p.LINE_CODE AND a.MODEL_NAME = p.MODEL_NAME
                   AND a.MODEL_SUFFIX = p.MODEL_SUFFIX AND a.PCB_ITEM = p.PCB_ITEM
    LEFT JOIN lastres l ON l.LINE_CODE = p.LINE_CODE AND l.MODEL_NAME = p.MODEL_NAME
                       AND l.MODEL_SUFFIX = p.MODEL_SUFFIX AND l.PCB_ITEM = p.PCB_ITEM
    LEFT JOIN qc q ON q.LINE_CODE = p.LINE_CODE AND q.MODEL_NAME = p.MODEL_NAME AND q.MODEL_SUFFIX = p.MODEL_SUFFIX
    LEFT JOIN ID_ITEM i ON i.ITEM_CODE = p.ITEM_CODE AND i.ORGANIZATION_ID = ${ORG}
   ORDER BY p.LINE_CODE, p.PLAN_PRIORITY, p.PLAN_SEQUENCE`;

export const MI_PLAN_SQL = `
  WITH wd AS (SELECT ${WORK_DAY} AS day FROM DUAL),
  act AS (
    SELECT v.LINE_CODE, v.MODEL_NAME, NVL(v.WORKSTAGE_CODE, '*') AS WORKSTAGE_CODE, SUM(${DASHBOARD_ACTUAL_SUM}) AS QTY
      FROM IP_PRODUCT_ACTUAL_TIME_V v, wd
     WHERE v.ACTUAL_DATE >= wd.day AND v.ACTUAL_DATE < wd.day + 1
     GROUP BY v.LINE_CODE, v.MODEL_NAME, NVL(v.WORKSTAGE_CODE, '*')
  ), plan AS (
    SELECT p.PLAN_SEQUENCE, p.WORK_ORDER_NO, p.PLAN_PRIORITY, p.LINE_CODE, p.ITEM_CODE, p.MODEL_NAME,
           NVL(p.WORKSTAGE_CODE, '*') AS WORKSTAGE_CODE, NVL(p.PLAN_QTY, 0) AS PLAN_QTY,
           ROW_NUMBER() OVER (PARTITION BY p.LINE_CODE, p.MODEL_NAME, NVL(p.WORKSTAGE_CODE, '*')
                              ORDER BY p.PLAN_PRIORITY, p.PLAN_SEQUENCE) AS RN_ACT
      FROM IP_PRODUCT_MI_PLAN p, wd
     WHERE p.ORGANIZATION_ID = ${ORG} AND p.PLAN_DATE >= wd.day AND p.PLAN_DATE < wd.day + 1
  )
  SELECT p.PLAN_SEQUENCE AS "planSequence", p.WORK_ORDER_NO AS "workOrderNo", p.PLAN_PRIORITY AS "priority",
         p.LINE_CODE AS "lineCode", p.ITEM_CODE AS "itemCode", NVL(i.ITEM_NAME, p.MODEL_NAME) AS "itemName",
         p.MODEL_NAME AS "modelName", p.PLAN_QTY AS "planQty",
         CASE WHEN p.RN_ACT = 1 THEN NVL(a.QTY, 0) ELSE 0 END AS "goodQty",
         0 AS "defectQty", CAST(NULL AS DATE) AS "lastResultAt"
    FROM plan p
    LEFT JOIN act a ON a.LINE_CODE = p.LINE_CODE AND a.MODEL_NAME = p.MODEL_NAME AND a.WORKSTAGE_CODE = p.WORKSTAGE_CODE
    LEFT JOIN ID_ITEM i ON i.ITEM_CODE = p.ITEM_CODE AND i.ORGANIZATION_ID = ${ORG}
   ORDER BY p.LINE_CODE, p.PLAN_PRIORITY, p.PLAN_SEQUENCE`;

/** 작업일 총계: 계획 합(SMD+제품)·시간대별 실적 합(두 뷰, 계획과 못 맞춘 행 포함) */
export const SLOT_SUM_SQL = (view: string, dateCol: string) => `
  SELECT ${SLOT_KEYS.map((k) => `NVL(SUM(v.${k}_TIME_ACTUAL), 0) AS "${k.toLowerCase()}"`).join(', ')}
    FROM ${view} v
   WHERE v.${dateCol} >= ${WORK_DAY} AND v.${dateCol} < ${WORK_DAY} + 1`;

/** 작업일 진성불량(QC_RESULT='N')을 분(HHMM) 단위로 집계 — 시간대 칸 배정은 JS 에서 한다 */
export const QC_MINUTE_SQL = `
  SELECT TO_CHAR(q.QC_DATE, 'HH24MI') AS "hhmm", COUNT(*) AS "cnt"
    FROM IP_PRODUCT_WORK_QC q
   WHERE q.ORGANIZATION_ID = ${ORG} AND q.QC_RESULT = 'N'
     AND q.QC_DATE >= ${WORK_DAY} + ${WORK_START_FRACTION}
     AND q.QC_DATE < ${WORK_DAY} + 1 + ${WORK_START_FRACTION}
   GROUP BY TO_CHAR(q.QC_DATE, 'HH24MI')`;

export const SLOT_RANGE_SQL = `
  SELECT r.WORK_TYPE AS "key", r.START_TIME AS "start", r.END_TIME AS "end"
    FROM ICOM_WORKTIME_RANGES r
   WHERE r.RANGE_TYPE = 'SMTWORKTIME' AND r.WORK_TYPE IN ('A','B','C','D','E','F','G','H','I','J')
   ORDER BY r.WORK_TYPE`;

@Injectable()
export class ProductionBoardService {
  constructor(private readonly dataSource: DataSource) {}

  /** 작업일 계획 행 + KPI + 시간대별 실적. 작업일 조회 후 쿼리를 두 묶음으로 나눠 실행한다. */
  async getBoard() {
    const now = new Date();
    // 0단계: 작업일(가벼움) — 이후 쿼리는 이 값을 바인드로 쓴다
    const wdRows = (await this.dataSource.query(WORK_DAY_SQL)) as Array<{ day: string; startFrac: Num }>;
    const day = wdRows[0].day;
    const startFrac = n(wdRows[0].startFrac) || 8.5 / 24;
    const dayBind = namedBinds({ day });
    const dayStartBind = namedBinds({ day, startFrac });

    // 1묶음: 계획 행 2개 쿼리
    const [smdRows, miRows] = await Promise.all([
      this.dataSource.query(SMD_PLAN_SQL, dayStartBind) as Promise<PlanRow[]>,
      this.dataSource.query(MI_PLAN_SQL, dayBind) as Promise<PlanRow[]>,
    ]);
    // 2묶음: 시간대 총계·불량·칸 정의 (커넥션 풀 보호를 위해 묶음을 나눈다)
    const [smdSlots, miSlots, qcRows, slotRows] = await Promise.all([
      this.dataSource.query(SLOT_SUM_SQL('IP_ASSEMBLY_ACTUAL_TIME_V', 'RECEIPT_DATE'), dayBind) as Promise<SlotSumRow[]>,
      this.dataSource.query(SLOT_SUM_SQL('IP_PRODUCT_ACTUAL_TIME_V', 'ACTUAL_DATE'), dayBind) as Promise<SlotSumRow[]>,
      this.dataSource.query(QC_MINUTE_SQL, dayStartBind) as Promise<QcMinuteRow[]>,
      this.dataSource.query(SLOT_RANGE_SQL) as Promise<SlotRange[]>,
    ]);

    const orders = this.buildOrders(smdRows, miRows, now);

    const smdSum = slotValues(smdSlots[0]);
    const miSum = slotValues(miSlots[0]);
    const goodBySlot = smdSum.map((v, i) => v + miSum[i]);
    const slots = this.normalizeSlots(slotRows);

    const defectBySlot = SLOT_KEYS.map(() => 0);
    let defectTotal = 0;
    for (const q of qcRows) {
      const cnt = n(q.cnt);
      defectTotal += cnt;
      const idx = slotIndexOf(String(q.hhmm), slots);
      if (idx >= 0) defectBySlot[idx] += cnt;
    }

    const planQty = orders.reduce((s, o) => s + o.planQty, 0);
    const goodQty = goodBySlot.reduce((s, v) => s + v, 0);
    const kpi = {
      planQty,
      goodQty,
      defectQty: defectTotal,
      achieveRate: rate(goodQty, planQty),
      runningCount: orders.filter((o) => o.status === 'RUNNING').length,
      totalCount: orders.length,
    };

    const hourly: HourlyPoint[] = slots.map((s, i) => ({
      hour: hhmm(s.start),
      label: `${hhmm(s.start)}~${hhmm(s.end)}`,
      goodQty: goodBySlot[i],
      defectQty: defectBySlot[i],
    }));

    return { kpi, orders, hourly };
  }

  /** DB 칸 정의가 A~J 10칸을 다 갖췄을 때만 쓰고, 아니면 기본값 */
  private normalizeSlots(rows: SlotRange[]): SlotRange[] {
    const byKey = new Map(rows.map((r) => [String(r.key), r]));
    const complete = SLOT_KEYS.every((k) => {
      const r = byKey.get(k);
      return !!r && /^\d{4}$/.test(String(r.start)) && /^\d{4}$/.test(String(r.end));
    });
    if (!complete) return DEFAULT_SLOTS;
    return SLOT_KEYS.map((k) => ({ key: k, start: String(byKey.get(k)!.start), end: String(byKey.get(k)!.end) }));
  }

  /** SMD+제품 계획 행 → 보드 order. 정렬: 진행 → 대기 → 완료, 같은 상태면 SMD 먼저 → 라인 → 우선순위 */
  private buildOrders(smdRows: PlanRow[], miRows: PlanRow[], now: Date): ProductionBoardOrder[] {
    const used = new Set<string>();
    const make = (r: PlanRow, type: 'SMD' | 'MI'): ProductionBoardOrder => {
      const planQty = n(r.planQty);
      const goodQty = n(r.goodQty);
      let orderNo = r.workOrderNo?.trim() || `${type}-${r.planSequence}`;
      if (used.has(orderNo)) orderNo = `${orderNo}-${type}${r.planSequence}`;
      used.add(orderNo);
      return {
        orderNo,
        itemCode: r.itemCode ?? r.modelName ?? '',
        itemName: r.itemName ?? null,
        processCode: type,
        equipCode: r.lineCode ?? null,
        status: deriveStatus(planQty, goodQty, r.lastResultAt ?? null, now),
        planQty,
        goodQty,
        defectQty: n(r.defectQty),
        achieveRate: rate(goodQty, planQty),
        priority: n(r.priority ?? 5),
        startAt: null,
        endAt: null,
        updatedAt: null,
        lastResultAt: r.lastResultAt ?? null,
      };
    };

    const smd = smdRows.map((r) => make(r, 'SMD'));
    const mi = miRows.map((r) => make(r, 'MI'));
    const typeRank = (o: ProductionBoardOrder) => (o.processCode === 'SMD' ? 0 : 1);
    return [...smd, ...mi].sort(
      (a, b) =>
        (STATUS_RANK[a.status] ?? 9) - (STATUS_RANK[b.status] ?? 9) ||
        typeRank(a) - typeRank(b) ||
        (a.equipCode ?? '').localeCompare(b.equipCode ?? '') ||
        a.priority - b.priority ||
        a.orderNo.localeCompare(b.orderNo),
    );
  }
}

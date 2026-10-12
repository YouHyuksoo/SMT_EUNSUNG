/**
 * @file src/app/(authenticated)/monitoring/equipment-board/components/types.ts
 * @description 설비가동 보드 타입/헬퍼 — GET /monitoring/boards/equipment 단일 응답.
 *
 * 초보자 가이드:
 * 1. HANES 는 /equipment/equips 와 /production/progress 를 프론트에서 조인하지만, 은성은 백엔드가
 *    { equips, runningJobs } 를 한 번에 준다 (equipment-board.service.ts 머리 주석 참고).
 * 2. 설비 상태(status)는 NORMAL(정상) / STOP(진행중 비가동) / UNUSED(미사용) 세 가지다.
 *    은성에는 점검(MAINT)·인터록(INTERLOCK) 데이터가 없어 HANES 의 두 상태는 뺐다.
 * 3. 설비별 작업지시가 없어 작업(RunningJob)은 "라인 단위"다. 설비의 lineCode 와
 *    runningJobs[].lineCode 가 같은 정상 설비를 작업중(RUN)으로 본다 (page.tsx 에서 jobMap 생성).
 */

/** GET /monitoring/boards/equipment 의 equips 항목 */
export interface EquipCard {
  id: string;
  equipCode: string;
  equipName: string;
  /** 설비 유형명(MOUNTER, AOI 등 — 코드표 MACHINE TYPE) */
  equipType: string | null;
  lineCode: string | null;
  lineName: string | null;
  processCode: string | null;
  processName: string | null;
  status: "NORMAL" | "STOP" | "UNUSED" | string;
  ipAddress: string | null;
  modelName: string | null;
}

/** 라인에서 현재 생산 중인 모델 요약 (runningJobs 항목은 lineCode 를 더 가진다) */
export interface RunningJob {
  orderNo: string;
  itemName: string | null;
  planQty: number;
  goodQty: number;
  defectQty: number;
}

/** GET /monitoring/boards/equipment 의 runningJobs 항목 */
export interface LineRunningJob extends RunningJob {
  lineCode: string;
  /** 센서 실적이 마지막으로 기록된 시각 (YYYY-MM-DD HH24:MI) */
  lastActualAt: string | null;
}

export interface EquipmentBoardData {
  equips: EquipCard[];
  runningJobs: LineRunningJob[];
}

export interface EquipStatusCounts {
  NORMAL: number;
  STOP: number;
  UNUSED: number;
}

/** 스킨 공통 props — page.tsx가 필터·조인된 데이터와 순환 설정을 내려준다 */
export interface EquipSkinProps {
  equips: EquipCard[];
  jobMap: Map<string, RunningJob>;
  counts: EquipStatusCounts;
  workingCount: number;
  rollingSec: number;
  paused: boolean;
  updatedAt: string;
}

/** 표시 상태: 정상+작업중(RUN) / 정상+대기(IDLE) / 정지 / 미사용 */
export type EquipVisualState = "RUN" | "IDLE" | "STOP" | "UNUSED";

export function visualState(e: EquipCard, job: RunningJob | undefined): EquipVisualState {
  if (e.status === "STOP") return "STOP";
  if (e.status === "UNUSED") return "UNUSED";
  return job ? "RUN" : "IDLE";
}

export const STATE_COLOR: Record<EquipVisualState, string> = {
  RUN: "#34d399",
  IDLE: "#38bdf8",
  STOP: "#ef4444",
  UNUSED: "#9ca3af",
};

/** 달성률(%) — 계획 0이면 0 */
export function achieveRate(job: RunningJob | undefined): number {
  if (!job || job.planQty <= 0) return 0;
  return Math.round((job.goodQty / job.planQty) * 100);
}

/** 라인 표시명 — 라인명이 있으면 이름, 없으면 코드, 미배정이면 "—" */
export function lineLabel(e: Pick<EquipCard, "lineCode" | "lineName">): string {
  return e.lineName ?? e.lineCode ?? "—";
}

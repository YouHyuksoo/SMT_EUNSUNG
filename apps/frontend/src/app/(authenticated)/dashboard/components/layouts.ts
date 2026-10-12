/**
 * @file src/app/(authenticated)/dashboard/components/layouts.ts
 * @description 대시보드 "형태" 4종 레지스트리 — 색상(skins.ts)과는 별개 축이다.
 *
 * 형태 = 같은 데이터를 다른 구조로 읽는 화면. 색상 = 같은 구조에 다른 팔레트.
 * 두 축은 독립이라 4 × 4(스킨 A/B/C/D) 조합이 전부 동작한다.
 *
 *   cockpit  콕핏   : 오늘의 한 줄 → 공정 흐름 리본 → 리듬/라인 레일 → 조치 큐 (기본)
 *   board    전광판 : 좌측 초대형 숫자 + 중앙 오늘 생산 계획 전광판(자동 순환) + 우측 조치 큐
 *   map      노선도 : 지하철 노선도처럼 공정 라인·설비 라인의 "역"을 눌러 그 단계의 조치만 본다
 *   charts   차트   : 설비·생산·솔더/MSL·불량 판정 차트 + 7일 추이·라인별 실적 + 보드 기반 차트(recharts)
 *
 * 새 형태를 추가할 때: 여기 항목 하나 + 레이아웃 컴포넌트 하나 + i18n dashboard.layout.{id} 4언어.
 */
import type { LucideIcon } from "lucide-react";
import { BarChart3, LayoutPanelTop, Route, Table2 } from "lucide-react";
import type { AttentionItem, DashboardData } from "./types";

export type DashboardLayoutId = "cockpit" | "board" | "map" | "charts";

export const DASHBOARD_LAYOUT_IDS = ["cockpit", "board", "map", "charts"] as const;

export interface DashboardLayoutDef {
  id: DashboardLayoutId;
  /** 전환 버튼 툴팁·aria — i18n 키 */
  titleKey: string;
  icon: LucideIcon;
}

export const DASHBOARD_LAYOUTS: readonly DashboardLayoutDef[] = [
  { id: "cockpit", titleKey: "dashboard.layout.cockpit", icon: LayoutPanelTop },
  { id: "board", titleKey: "dashboard.layout.board", icon: Table2 },
  { id: "map", titleKey: "dashboard.layout.map", icon: Route },
  { id: "charts", titleKey: "dashboard.layout.charts", icon: BarChart3 },
];

export const DASHBOARD_LAYOUT_STORAGE_KEY = "dashboard:layout";
export const DASHBOARD_DEFAULT_LAYOUT: DashboardLayoutId = "cockpit";

/** 모든 형태 컴포넌트가 받는 동일한 props — page.tsx 가 한 번만 계산해 내려준다 */
export interface DashboardLayoutProps {
  data: DashboardData;
  attention: AttentionItem[];
  attentionCount: number;
  /** 현재 시(0~23). 시계 틱마다 리렌더되지 않도록 시 단위 값만 내려준다. SSR/초기에는 null */
  nowHour: number | null;
}

/**
 * @file src/config/workflowConfig.ts
 * @description 워크플로우 정의 — 7개 업무 프로세스의 노드, 분기, 메뉴 경로 설정
 *
 * 초보자 가이드:
 * 1. WorkflowNode: 각 단계 (노드명, 경로, 색상, 역분개 경로)
 * 2. WorkflowBranch: 분기 조건 (합격/불합격 등)
 * 3. WorkflowDefinition: 워크플로우 전체 정의 (노드 배열 + 분기)
 * 4. workflowConfigs: 7개 워크플로우 배열
 * 5. icon은 lucide-react 컴포넌트 (사이드 메뉴와 동일 스타일)
 */
import {
  Package, Wrench, Building2,
} from "lucide-react";

export interface WorkflowNode {
  id: string;
  labelKey: string;
  statusKey: string;
  path: string;
  color: string;
  reversePath?: string;
  reverseKey?: string;
}

export interface WorkflowBranch {
  afterNodeId: string;
  conditions: Array<{
    labelKey: string;
    type: "pass" | "fail";
  }>;
}

export interface WorkflowDefinition {
  id: string;
  titleKey: string;
  icon: React.ComponentType<{ className?: string }>;
  accent: string;
  badgeColor: string;
  nodes: WorkflowNode[];
  branches?: WorkflowBranch[];
  fullWidth?: boolean;
}

export const workflowConfigs: WorkflowDefinition[] = [
  {
    id: "MATERIAL",
    titleKey: "workflow.material.title",
    icon: Package,
    accent: "border-green-500",
    badgeColor: "bg-green-500",
    nodes: [
      { id: "ARRIVAL", labelKey: "workflow.material.arrival", statusKey: "workflow.status.pending", path: "/material/arrival", color: "text-green-500" },
      { id: "LABEL", labelKey: "workflow.material.label", statusKey: "workflow.status.issuing", path: "/material/receive-label", color: "text-cyan-500" },
      { id: "RECEIVE", labelKey: "workflow.material.receive", statusKey: "workflow.status.done", path: "/material/receive", color: "text-violet-500", reversePath: "/material/receipt-cancel", reverseKey: "workflow.action.cancelReceipt" },
      { id: "REQUEST", labelKey: "workflow.material.request", statusKey: "workflow.status.requesting", path: "/material/request", color: "text-amber-500" },
      { id: "ISSUE", labelKey: "workflow.material.issue", statusKey: "workflow.status.done", path: "/material/issue", color: "text-purple-500" },
    ],
  },
  {
    id: "EQUIPMENT",
    titleKey: "workflow.equipment.title",
    icon: Wrench,
    accent: "border-violet-500",
    badgeColor: "bg-violet-500",
    nodes: [
      { id: "PM_PLAN", labelKey: "workflow.equipment.pmPlan", statusKey: "workflow.status.planning", path: "/equipment/pm-plan", color: "text-blue-500" },
      { id: "PM_CALENDAR", labelKey: "workflow.equipment.pmCalendar", statusKey: "workflow.status.scheduled", path: "/equipment/pm-calendar", color: "text-amber-500" },
      { id: "PM_RESULT", labelKey: "workflow.equipment.pmResult", statusKey: "workflow.status.executing", path: "/equipment/pm-result", color: "text-green-500" },
      { id: "DAILY", labelKey: "workflow.equipment.daily", statusKey: "workflow.status.inspecting", path: "/equipment/inspect-calendar", color: "text-cyan-500" },
      { id: "PERIODIC", labelKey: "workflow.equipment.periodic", statusKey: "workflow.status.inspecting", path: "/equipment/periodic-inspect-calendar", color: "text-violet-500" },
      { id: "HISTORY", labelKey: "workflow.equipment.history", statusKey: "workflow.status.done", path: "/equipment/inspect-history", color: "text-purple-500" },
    ],
  },
  {
    id: "OUTSOURCING",
    titleKey: "workflow.outsourcing.title",
    icon: Building2,
    accent: "border-emerald-500",
    badgeColor: "bg-emerald-500",
    nodes: [
      { id: "VENDOR", labelKey: "workflow.outsourcing.vendor", statusKey: "workflow.status.master", path: "/outsourcing/vendor", color: "text-green-500" },
      { id: "ORDER", labelKey: "workflow.outsourcing.order", statusKey: "workflow.status.ordering", path: "/outsourcing/order", color: "text-amber-500" },
      { id: "RECEIVE", labelKey: "workflow.outsourcing.receive", statusKey: "workflow.status.receiving", path: "/outsourcing/receive", color: "text-emerald-500" },
    ],
  },
];

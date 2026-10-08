/**
 * @file src/app/(authenticated)/dashboard/components/buildAttention.ts
 * @description "조치 필요" 큐 생성 — API 데이터에서 예외 항목만 뽑아 심각도 순으로 정렬한다.
 *
 * 초보자 가이드:
 * 1. 순수 함수. 화면 상태/훅에 의존하지 않아 단독 검증이 가능하다.
 * 2. 심각도: critical(설비 비가동) > high(솔더/MSL NG·불량 판정대기·진성 미수리·기한초과·보류 재고)
 *            > medium(안전재고 미달·기한임박·라인 달성률 저조)
 * 3. 건수 0 인 항목은 큐에 넣지 않는다. 큐가 비면 "정상" 이다.
 * 4. 은성 DB 에 데이터가 없는 항목(일상/정기점검·PM, 소모품 안전재고, 작업지시 보류)은 판정하지 않는다.
 * 5. 라인 달성률 저조는 "하루 종료 전" 이라는 시간 문제가 있어 단순화한 기준을 쓴다 — 아래 상수 참고.
 */
import type { AttentionDetail, AttentionItem, AttentionSeverity, DashboardData, InsightsLine } from "./types";

const SEVERITY_ORDER: Record<AttentionSeverity, number> = { critical: 0, high: 1, medium: 2, low: 3 };

/**
 * 라인 달성률 저조 판정 기준 (단순화 기준 — 현장 운영 기준이 정해지면 이 두 값만 바꾼다)
 * - 계획이 있는 라인(planQty > 0) 중 실적/계획이 LOW_ACHIEVE_PCT 미만이면 저조로 본다.
 * - 아침에는 모든 라인이 낮으므로 LOW_ACHIEVE_AFTER_HOUR 시 이후에만 판정한다 (그 전엔 항목을 만들지 않는다).
 */
export const LOW_ACHIEVE_PCT = 50;
export const LOW_ACHIEVE_AFTER_HOUR = 15;

function samplesOf(names: Array<string | null | undefined>, max = 3): string[] {
  return names.filter((n): n is string => !!n).slice(0, max);
}

/** 상세 목록에서 접힌 상태용 대표 이름 3개를 뽑는다 — 두 표현이 어긋나지 않게 한 곳에서 만든다 */
function fromDetails(details: AttentionDetail[]) {
  return { details, samples: samplesOf(details.map((d) => d.name)) };
}

function lowAchieveDetails(lines: InsightsLine[], type: "SMD" | "MI"): AttentionDetail[] {
  return lines
    .filter((l) => l.productionType === type && l.planQty > 0 && (l.actualQty / l.planQty) * 100 < LOW_ACHIEVE_PCT)
    .map((l): AttentionDetail => ({
      code: l.lineCode,
      name: l.lineName || l.lineCode,
      meta: `${l.actualQty.toLocaleString()} / ${l.planQty.toLocaleString()} (${((l.actualQty / l.planQty) * 100).toFixed(1)}%)`,
    }));
}

export function buildAttention(data: DashboardData, nowHour: number | null): AttentionItem[] {
  const items: AttentionItem[] = [];
  const { summary, insights, inventory } = data;

  if (summary) {
    if (summary.equip.down > 0) {
      items.push({ key: "equipDown", severity: "critical", count: summary.equip.down, samples: [], details: [], href: "/oee/equip-ops-status" });
    }
    if (summary.material.solderNg > 0) {
      items.push({ key: "solderNg", severity: "high", count: summary.material.solderNg, samples: [], details: [], href: "/warehouse/solder" });
    }
    if (summary.material.mslNg > 0) {
      items.push({ key: "mslNg", severity: "high", count: summary.material.mslNg, samples: [], details: [], href: "/warehouse/msl-check" });
    }
    if (summary.defect.pending > 0) {
      items.push({ key: "defectPending", severity: "high", count: summary.defect.pending, samples: [], details: [], href: "/quality/repair-query" });
    }
    if (summary.defect.unrepaired > 0) {
      items.push({ key: "defectUnrepaired", severity: "high", count: summary.defect.unrepaired, samples: [], details: [], href: "/quality/repair-history" });
    }
  }

  if (insights && nowHour !== null && nowHour >= LOW_ACHIEVE_AFTER_HOUR) {
    const smd = lowAchieveDetails(insights.lines, "SMD");
    if (smd.length > 0) {
      items.push({ key: "lowAchieveSmd", severity: "medium", count: smd.length, ...fromDetails(smd), href: "/tracking/line-dashboard" });
    }
    const product = lowAchieveDetails(insights.lines, "MI");
    if (product.length > 0) {
      items.push({ key: "lowAchieveProduct", severity: "medium", count: product.length, ...fromDetails(product), href: "/tracking/line-dashboard" });
    }
  }

  if (inventory) {
    // 잔여일은 부호 그대로 보여준다(D+3 = 3일 지남, D-5 = 5일 남음)
    const lotDetail = (e: (typeof inventory.expiry)[number]): AttentionDetail =>
      ({ code: e.matUid, name: e.itemName ?? e.itemCode, meta: `D${e.daysLeft >= 0 ? "-" : "+"}${Math.abs(e.daysLeft)} · ${e.expireDate}` });
    const expired = inventory.expiry.filter((e) => e.daysLeft < 0).map(lotDetail);
    if (expired.length > 0) {
      items.push({ key: "expiredLot", severity: "high", count: expired.length, ...fromDetails(expired), href: "/monitoring/inventory-board" });
    }
    if (inventory.holds.length > 0) {
      const holds = inventory.holds.map((h): AttentionDetail => ({ code: h.ref, name: h.itemName ?? h.itemCode, meta: h.reason }));
      items.push({ key: "holdStock", severity: "high", count: holds.length, ...fromDetails(holds), href: "/quality/inventory-hold" });
    }
    if (inventory.shortages.length > 0) {
      const shortages = inventory.shortages.map((s): AttentionDetail =>
        ({ code: s.itemCode, name: s.itemName ?? s.itemCode, meta: `${s.qty.toLocaleString()} / ${s.safetyStock.toLocaleString()}` }));
      items.push({ key: "shortage", severity: "medium", count: shortages.length, ...fromDetails(shortages), href: "/material/current-inventory" });
    }
    const near = inventory.expiry.filter((e) => e.daysLeft >= 0).map(lotDetail);
    if (near.length > 0) {
      items.push({ key: "nearExpiry", severity: "medium", count: near.length, ...fromDetails(near), href: "/monitoring/inventory-board" });
    }
  }

  return items.sort((a, b) => SEVERITY_ORDER[a.severity] - SEVERITY_ORDER[b.severity] || b.count - a.count);
}

export function attentionTotal(items: AttentionItem[]): number {
  return items.reduce((s, i) => s + i.count, 0);
}

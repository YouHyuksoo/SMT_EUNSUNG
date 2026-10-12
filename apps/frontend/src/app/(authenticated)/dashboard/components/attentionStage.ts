/**
 * @file src/app/(authenticated)/dashboard/components/attentionStage.ts
 * @description 조치 항목 → "역(단계)" 매핑. 노선도 형태가 단계별로 조치를 나눠 보여줄 때 쓰는 순수 함수.
 *
 * 공정 라인 5역(재고 → 자재(솔더·MSL) → SMD → 제품 → 품질)과 설비 라인 3역(사용중/비가동/미사용)은
 * 은성 데이터로 뒷받침되는 흐름만 둔다. 설비 비가동만 조치 대상이라 비가동 역에 압력이 걸린다.
 */
import type { AttentionItem } from "./types";

export type FlowStage = "stock" | "material" | "smd" | "product" | "quality";
export type EquipStage = "inUse" | "down" | "notUsed";
export type Station = FlowStage | EquipStage;

export const FLOW_STAGES: readonly FlowStage[] = ["stock", "material", "smd", "product", "quality"];
export const EQUIP_STAGES: readonly EquipStage[] = ["inUse", "down", "notUsed"];

const STATION_OF_KEY: Record<string, Station> = {
  expiredLot: "stock",
  nearExpiry: "stock",
  shortage: "stock",
  holdStock: "stock",
  solderNg: "material",
  mslNg: "material",
  lowAchieveSmd: "smd",
  lowAchieveProduct: "product",
  defectPending: "quality",
  defectUnrepaired: "quality",
  equipDown: "down",
};

export function stationOf(item: AttentionItem): Station {
  return STATION_OF_KEY[item.key] ?? "stock";
}

export const isFlowStation = (id: Station): id is FlowStage => (FLOW_STAGES as readonly string[]).includes(id);

/** 역별 압력(조치 건수 합) — 0 인 역은 키가 없다 */
export function pressureByStation(items: AttentionItem[]): Partial<Record<Station, number>> {
  const out: Partial<Record<Station, number>> = {};
  for (const item of items) {
    const st = stationOf(item);
    out[st] = (out[st] ?? 0) + item.count;
  }
  return out;
}

/** 압력 → 의미 톤 클래스 접미(success/warning/error). 6건 이상이면 빨강, 1건 이상 노랑 */
export function pressureTone(pressure: number): "success" | "warning" | "error" {
  return pressure >= 6 ? "error" : pressure > 0 ? "warning" : "success";
}

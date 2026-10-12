"use client";

/**
 * @file src/app/(authenticated)/monitoring/equipment-board/page.tsx
 * @description 설비가동 보드(현장 TV) — 스킨 3종 전환:
 *              A 노선도(다크 네온, 라인 레일+진행률 링) / B 출발 전광판(앰버 모노, 문제 설비 상단) / C 트리맵(다크 편집, 계획수량 비례).
 *
 * 초보자 가이드:
 * 1. 설정 모달에서 모니터링 설비·재조회 주기·롤링 주기를 지정(localStorage 저장). 미선택 시 전체 설비.
 * 2. 데이터는 GET /monitoring/boards/equipment 하나로 조회한다 ({ equips, runningJobs }).
 *    설비별 작업지시가 없어, 설비의 lineCode 와 runningJobs[].lineCode 가 같은 정상 설비를 "작업중"으로 본다.
 * 3. 스킨/TV모드/플로팅 컨트롤은 공통 BoardSkinFrame + useBoardSkin 이 담당 (5개 보드 동일)
 * 4. HANES 의 관리자호출 패널은 은성에 대응 기능이 없어 이식하지 않았다.
 */

import { useState, useMemo } from "react";
import { useTranslation } from "react-i18next";
import { useApiQuery } from "@/hooks/useApi";
import {
  BoardSkinFrame, MonitoringSettingsModal, useBoardSkin, useMonitoringConfig, useTvMode,
  type BoardSkinOption,
} from "@/components/monitoring";
import LineMapSkin from "./components/skins/LineMapSkin";
import DepartureBoardSkin from "./components/skins/DepartureBoardSkin";
import TreemapSkin from "./components/skins/TreemapSkin";
import type { EquipmentBoardData, EquipStatusCounts, RunningJob } from "./components/types";

type SkinId = "linemap" | "departure" | "treemap";

const SKIN_IDS = ["linemap", "departure", "treemap"] as const;
const SKINS: BoardSkinOption<SkinId>[] = [
  { id: "linemap", label: "A", title: "노선도" },
  { id: "departure", label: "B", title: "출발 전광판" },
  { id: "treemap", label: "C", title: "트리맵" },
];

export default function EquipmentBoardPage() {
  const { t } = useTranslation();
  const { config, setConfig, loaded } = useMonitoringConfig("monitoring:equip-status");
  const [settingsOpen, setSettingsOpen] = useState(false);
  const [paused, setPaused] = useState(false);
  const { skin, setSkin } = useBoardSkin<SkinId>("monitoring:equipment-board:skin", SKIN_IDS, "linemap");
  const { tvMode, toggleTvMode } = useTvMode();

  const { data: response, isLoading, refetch, dataUpdatedAt } = useApiQuery<EquipmentBoardData>(
    ["monitoring", "board", "equipment"],
    "/monitoring/boards/equipment",
    { refetchInterval: Math.max(5, config.refetchSec) * 1000, enabled: loaded },
  );
  const board = response?.data;
  const equipments = useMemo(() => board?.equips ?? [], [board]);

  // 라인코드 → 현재 가동 작업. 설비는 자기 라인의 작업을 따른다(정지/미사용 설비는 visualState 가 걸러낸다).
  const jobMap = useMemo(() => {
    const byLine = new Map<string, RunningJob>();
    for (const j of board?.runningJobs ?? []) {
      byLine.set(j.lineCode, {
        orderNo: j.orderNo,
        itemName: j.itemName,
        planQty: Number(j.planQty ?? 0),
        goodQty: Number(j.goodQty ?? 0),
        defectQty: Number(j.defectQty ?? 0),
      });
    }
    const m = new Map<string, RunningJob>();
    for (const e of equipments) {
      const job = e.lineCode ? byLine.get(e.lineCode) : undefined;
      if (job && e.status === "NORMAL") m.set(e.equipCode, job);
    }
    return m;
  }, [board, equipments]);

  const filtered = useMemo(() => {
    if (config.selectedCodes.length === 0) return equipments;
    const set = new Set(config.selectedCodes);
    return equipments.filter((e) => set.has(e.equipCode));
  }, [equipments, config.selectedCodes]);

  const workingCount = useMemo(
    () => filtered.filter((e) => jobMap.has(e.equipCode)).length,
    [filtered, jobMap],
  );

  const counts = useMemo<EquipStatusCounts>(() => {
    const c: EquipStatusCounts = { NORMAL: 0, STOP: 0, UNUSED: 0 };
    filtered.forEach((e) => {
      if (e.status in c) c[e.status as keyof EquipStatusCounts] += 1;
    });
    return c;
  }, [filtered]);

  const options = useMemo(
    () => equipments.map((e) => ({ code: e.equipCode, label: e.equipName, sub: e.lineName ?? e.lineCode ?? undefined })),
    [equipments],
  );

  const updatedAt = dataUpdatedAt ? new Date(dataUpdatedAt).toLocaleTimeString() : "—";

  const skinProps = {
    equips: filtered,
    jobMap,
    counts,
    workingCount,
    rollingSec: config.rollingSec,
    paused,
    updatedAt,
  };

  return (
    <>
      <BoardSkinFrame
        skins={SKINS}
        skin={skin}
        onSkinChange={setSkin}
        tvMode={tvMode}
        onToggleTv={toggleTvMode}
        onRefresh={() => refetch()}
        refreshing={isLoading}
        onSettings={() => setSettingsOpen(true)}
        paused={paused}
        onTogglePause={() => setPaused((p) => !p)}
      >
        {skin === "linemap" && <LineMapSkin {...skinProps} />}
        {skin === "departure" && <DepartureBoardSkin {...skinProps} />}
        {skin === "treemap" && <TreemapSkin {...skinProps} />}
      </BoardSkinFrame>

      <MonitoringSettingsModal
        isOpen={settingsOpen}
        onClose={() => setSettingsOpen(false)}
        targetLabel={t("master.equip.title", "설비")}
        options={options}
        value={config}
        onSave={setConfig}
        showGrid={false}
      />
    </>
  );
}

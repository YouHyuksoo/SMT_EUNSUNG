"use client";

/**
 * @file oee/overall-status/page.tsx
 * @description OEE 종합 현황(현장 TV) — 모니터링 보드 공통 프레임(BoardSkinFrame)과 다크 전광판 스킨.
 *
 * 초보자 가이드:
 * 1. 아직 목업이다. 수치는 _lib/mock.ts 상수이고 스킨 헤더에 목업 표식을 상시 노출한다.
 *    산식을 붙일 때는 mock 상수 자리에 API 응답을 넣으면 스킨은 그대로 쓴다.
 * 2. 우상단 플로팅 컨트롤(일시정지·새로고침·설정·TV 모드)은 다른 모니터링 보드와 같은 위치·순서다.
 * 3. 설정 모달에서 표시할 라인과 롤링 주기를 고른다(localStorage). 미선택이면 전체 라인.
 * 4. 라인은 소속 설비에 정지가 하나라도 있으면 정지로 본다.
 */
import { useEffect, useMemo, useState } from "react";
import { useTranslation } from "react-i18next";
import { useIsTabActive } from "@/hooks/useTabActive";
import {
  BoardSkinFrame, MonitoringSettingsModal, useMonitoringConfig, useTvMode,
  type BoardSkinOption,
} from "@/components/monitoring";
import OeeControlSkin, { type OeeBoardLine } from "./components/OeeControlSkin";
import { MOCK_ALERT, MOCK_FACTORY_KPIS, MOCK_LINES, MOCK_MACHINES } from "./_lib/mock";

type SkinId = "control";
const SKINS: BoardSkinOption<SkinId>[] = [{ id: "control", label: "A", title: "관제" }];

export default function OeeOverallStatusPage() {
  const { t } = useTranslation();
  const { config, setConfig } = useMonitoringConfig("monitoring:oee-overall-status");
  const [settingsOpen, setSettingsOpen] = useState(false);
  const [paused, setPaused] = useState(false);
  const { tvMode, toggleTvMode } = useTvMode();
  // 목업 단계라 새로고침은 화면 시각만 갱신한다 — API 연결 시 refetch 로 바꾼다
  const [loadedAt, setLoadedAt] = useState(() => new Date());
  const [now, setNow] = useState<Date | null>(null);

  // 시계는 1초마다. 탭을 벗어나면 멈춰 keep-alive 상태에서 계속 돌지 않게 한다(페이지 순환도 함께 멈춘다).
  const tabActive = useIsTabActive();
  useEffect(() => {
    // 브라우저 탭이 가려졌거나 앱 탭이 숨겨졌으면 시계를 멈춘다
    const tick = () => setNow(document.hidden || !tabActive ? null : new Date());
    tick();
    if (!tabActive) return;
    const id = setInterval(tick, 1000);
    document.addEventListener("visibilitychange", tick);
    return () => {
      clearInterval(id);
      document.removeEventListener("visibilitychange", tick);
    };
  }, [tabActive]);

  const lines = useMemo<OeeBoardLine[]>(() => {
    const selected = new Set(config.selectedCodes);
    return MOCK_LINES
      .filter((l) => selected.size === 0 || selected.has(l.lineCode))
      .map((l) => {
        const machines = MOCK_MACHINES[l.lineCode] ?? [];
        const displayStatus = machines.some((m) => m.status === "STOP") ? "STOP" : l.status;
        return { ...l, machines, displayStatus };
      });
  }, [config.selectedCodes]);

  const options = useMemo(
    () => MOCK_LINES.map((l) => ({ code: l.lineCode, label: l.lineName, sub: l.lineCode })),
    [],
  );

  return (
    <>
      <BoardSkinFrame
        skins={SKINS}
        skin="control"
        onSkinChange={() => undefined}
        tvMode={tvMode}
        onToggleTv={toggleTvMode}
        onRefresh={() => setLoadedAt(new Date())}
        onSettings={() => setSettingsOpen(true)}
        paused={paused}
        onTogglePause={() => setPaused((p) => !p)}
      >
        <OeeControlSkin
          factoryKpis={MOCK_FACTORY_KPIS}
          lines={lines}
          alert={MOCK_ALERT}
          rollingSec={config.rollingSec}
          paused={paused || !tabActive}
          now={now}
          updatedAt={loadedAt.toLocaleTimeString()}
        />
      </BoardSkinFrame>

      <MonitoringSettingsModal
        isOpen={settingsOpen}
        onClose={() => setSettingsOpen(false)}
        targetLabel={t("oee.overallStatus.lineSection")}
        options={options}
        value={config}
        onSave={setConfig}
        showGrid={false}
      />
    </>
  );
}

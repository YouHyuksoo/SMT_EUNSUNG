"use client";

import Link from "next/link";
import { useMemo, useState } from "react";
import type { LucideIcon } from "lucide-react";
import {
  Activity,
  ArrowRight,
  BarChart3,
  Boxes,
  CheckCircle2,
  ClipboardList,
  Database,
  Factory,
  Gauge,
  Layers3,
  Monitor,
  PackageCheck,
  RadioTower,
  Settings2,
  ShieldCheck,
  TimerReset,
  Truck,
} from "lucide-react";

type ModuleKey = "material" | "oee" | "master";

interface ModuleOption {
  key: ModuleKey;
  title: string;
  caption: string;
  href: string;
  icon: LucideIcon;
  accent: string;
  border: string;
  background: string;
  metrics: Array<{ label: string; value: string }>;
  actions: string[];
}

const modules: ModuleOption[] = [
  {
    key: "material",
    title: "수불관리",
    caption: "입고부터 공정 투입, 재고 이동, 출하까지 LOT 흐름을 잡습니다.",
    href: "/material",
    icon: Boxes,
    accent: "text-cyan-700",
    border: "border-cyan-300",
    background: "bg-cyan-50",
    metrics: [
      { label: "입고 대기", value: "18 LOT" },
      { label: "공정 투입", value: "42 건" },
      { label: "재고 차이", value: "3 건" },
    ],
    actions: ["자재 입고", "LOT 이동", "공정 투입", "재고 실사"],
  },
  {
    key: "oee",
    title: "OEE 관리",
    caption: "가동률, 성능, 품질 손실을 설비와 라인 기준으로 추적합니다.",
    href: "/oee",
    icon: Gauge,
    accent: "text-emerald-700",
    border: "border-emerald-300",
    background: "bg-emerald-50",
    metrics: [
      { label: "가동률", value: "88.4%" },
      { label: "성능", value: "91.2%" },
      { label: "품질", value: "97.8%" },
    ],
    actions: ["라인 OEE", "비가동 등록", "성능 손실", "품질 손실"],
  },
  {
    key: "master",
    title: "기준정보",
    caption: "품목, 공정, 설비, 거래처 기준을 은성전장 DB에 맞춥니다.",
    href: "/master",
    icon: Database,
    accent: "text-amber-700",
    border: "border-amber-300",
    background: "bg-amber-50",
    metrics: [
      { label: "품목 기준", value: "PCB" },
      { label: "공정 기준", value: "SMT" },
      { label: "설비 기준", value: "Line" },
    ],
    actions: ["품목 기준", "공정 기준", "설비 기준", "검사 기준"],
  },
];

const processSteps = [
  { name: "자재입고", code: "MAT", icon: Truck, text: "협력사 입고와 LOT 식별" },
  { name: "SMT", code: "SMT", icon: Factory, text: "인쇄, 실장, 리플로우 흐름" },
  { name: "검사", code: "IQC", icon: ShieldCheck, text: "SPI, AOI, 기능검사 결과" },
  { name: "라우팅", code: "RTG", icon: Layers3, text: "공정 이동과 재공 위치" },
  { name: "조립", code: "ASM", icon: Settings2, text: "PCB 조립 및 부품 체결" },
  { name: "포장", code: "PKG", icon: PackageCheck, text: "최종 검사와 출하 준비" },
];

const operationLinks = [
  { title: "모니터링", href: "/monitoring", icon: Monitor, detail: "별도 화면 메뉴" },
  { title: "AI 분석", href: "/ai-chat", icon: Activity, detail: "SQL 질의 지원" },
  { title: "화면 도움말", href: "/help", icon: ClipboardList, detail: "운영 가이드" },
];

export function LandingWorkbench() {
  const [activeKey, setActiveKey] = useState<ModuleKey>("material");
  const [activeStep, setActiveStep] = useState(1);
  const activeModule = useMemo(
    () => modules.find((module) => module.key === activeKey) ?? modules[0],
    [activeKey],
  );
  const ActiveIcon = activeModule.icon;
  const step = processSteps[activeStep];
  const StepIcon = step.icon;

  return (
    <main className="min-h-screen overflow-hidden">
      <header className="border-b border-zinc-200 bg-white/95 backdrop-blur">
        <div className="mx-auto flex h-16 max-w-7xl items-center justify-between px-6">
          <div className="flex items-center gap-3">
            <span className="flex h-10 w-10 items-center justify-center rounded-md bg-zinc-950 text-white">
              <Factory className="h-5 w-5" />
            </span>
            <div>
              <p className="text-xs font-semibold uppercase tracking-[0.18em] text-zinc-500">
                EUNSUNG SMT MES
              </p>
              <h1 className="text-lg font-bold text-zinc-950">은성전장 MES</h1>
            </div>
          </div>
          <nav className="flex items-center gap-2">
            <Link
              href="/monitoring"
              className="inline-flex h-10 items-center gap-2 rounded-md border border-zinc-300 bg-white px-4 text-sm font-semibold text-zinc-800 hover:border-cyan-400 hover:text-cyan-800"
            >
              <Monitor className="h-4 w-4" />
              모니터링
            </Link>
            <Link
              href="/settings/cards"
              className="inline-flex h-10 items-center gap-2 rounded-md bg-zinc-950 px-4 text-sm font-semibold text-white hover:bg-zinc-800"
            >
              <Settings2 className="h-4 w-4" />
              설정
            </Link>
          </nav>
        </div>
      </header>

      <section className="relative border-b border-zinc-200 bg-[#f9fafb]">
        <div className="absolute inset-0 opacity-[0.55] [background-image:linear-gradient(#d4d4d8_1px,transparent_1px),linear-gradient(90deg,#d4d4d8_1px,transparent_1px)] [background-size:36px_36px]" />
        <div className="relative mx-auto grid max-w-7xl gap-6 px-6 py-8 xl:grid-cols-[0.92fr_1.08fr]">
          <div className="flex min-h-[520px] flex-col justify-between rounded-lg border border-zinc-200 bg-white p-6 shadow-sm">
            <div>
              <div className="mb-6 flex items-center justify-between">
                <p className="text-sm font-semibold text-cyan-700">SMT 생산 고도화 프로젝트</p>
                <span className="rounded-full border border-zinc-200 px-3 py-1 text-xs font-semibold text-zinc-600">
                  Frontend first
                </span>
              </div>
              <h2 className="text-4xl font-black leading-tight text-zinc-950">
                수불과 OEE를 한 화면에서 설계하는 은성전장 업무 허브
              </h2>
              <p className="mt-5 max-w-xl text-base leading-7 text-zinc-600">
                PCB 생산 흐름을 기준으로 업무 메뉴를 재배치하고, 모니터링은 별도 라우트에서
                독립적으로 운영합니다.
              </p>
            </div>

            <div className="mt-8 grid grid-cols-3 gap-2 rounded-lg border border-zinc-200 bg-zinc-50 p-2">
              {modules.map((module) => {
                const Icon = module.icon;
                const active = module.key === activeKey;
                return (
                  <button
                    key={module.key}
                    type="button"
                    onClick={() => setActiveKey(module.key)}
                    className={`flex h-28 flex-col justify-between rounded-md border bg-white p-3 text-left transition ${
                      active ? `${module.border} shadow-sm` : "border-transparent hover:border-zinc-300"
                    }`}
                  >
                    <Icon className={`h-5 w-5 ${active ? module.accent : "text-zinc-500"}`} />
                    <span>
                      <span className="block text-sm font-bold text-zinc-950">{module.title}</span>
                      <span className="mt-1 block text-xs text-zinc-500">{module.caption}</span>
                    </span>
                  </button>
                );
              })}
            </div>
          </div>

          <div className="grid min-h-[520px] gap-4 lg:grid-cols-[1fr_0.78fr]">
            <section className={`rounded-lg border ${activeModule.border} bg-white p-5 shadow-sm`}>
              <div className="mb-5 flex items-start justify-between">
                <div className="flex items-center gap-3">
                  <span className={`flex h-12 w-12 items-center justify-center rounded-md ${activeModule.background} ${activeModule.accent}`}>
                    <ActiveIcon className="h-6 w-6" />
                  </span>
                  <div>
                    <h3 className="text-2xl font-black text-zinc-950">{activeModule.title}</h3>
                    <p className="mt-1 text-sm text-zinc-600">{activeModule.caption}</p>
                  </div>
                </div>
                <span className="rounded-full bg-zinc-100 px-3 py-1 text-xs font-semibold text-zinc-600">
                  설계중
                </span>
              </div>

              <div className="grid grid-cols-3 gap-2">
                {activeModule.metrics.map((metric) => (
                  <div key={metric.label} className="rounded-md border border-zinc-200 bg-zinc-50 p-3">
                    <p className="text-xs font-semibold text-zinc-500">{metric.label}</p>
                    <p className="mt-2 text-lg font-black text-zinc-950">{metric.value}</p>
                  </div>
                ))}
              </div>

              <div className="mt-5 grid gap-2">
                {activeModule.actions.map((action, index) => (
                  <div
                    key={action}
                    className="flex h-12 items-center justify-between rounded-md border border-zinc-200 bg-white px-3"
                  >
                    <span className="flex items-center gap-3 text-sm font-semibold text-zinc-800">
                      <span className="flex h-6 w-6 items-center justify-center rounded bg-zinc-100 text-xs text-zinc-600">
                        {index + 1}
                      </span>
                      {action}
                    </span>
                    <CheckCircle2 className="h-4 w-4 text-zinc-400" />
                  </div>
                ))}
              </div>

              <Link
                href={activeModule.href}
                className="mt-5 inline-flex h-11 items-center gap-2 rounded-md bg-zinc-950 px-4 text-sm font-semibold text-white hover:bg-zinc-800"
              >
                업무 화면으로 이동
                <ArrowRight className="h-4 w-4" />
              </Link>
            </section>

            <aside className="grid gap-4">
              <div className="rounded-lg border border-zinc-200 bg-white p-5 shadow-sm">
                <div className="mb-4 flex items-center justify-between">
                  <h3 className="text-sm font-black uppercase tracking-[0.16em] text-zinc-500">
                    Process map
                  </h3>
                  <RadioTower className="h-4 w-4 text-cyan-700" />
                </div>
                <div className="grid grid-cols-2 gap-2">
                  {processSteps.map((item, index) => {
                    const Icon = item.icon;
                    const active = index === activeStep;
                    return (
                      <button
                        key={item.code}
                        type="button"
                        onClick={() => setActiveStep(index)}
                        className={`h-20 rounded-md border p-3 text-left transition ${
                          active
                            ? "border-cyan-300 bg-cyan-50"
                            : "border-zinc-200 bg-white hover:border-zinc-300"
                        }`}
                      >
                        <div className="flex items-center justify-between">
                          <Icon className={`h-4 w-4 ${active ? "text-cyan-700" : "text-zinc-500"}`} />
                          <span className="font-mono text-[11px] font-bold text-zinc-500">{item.code}</span>
                        </div>
                        <p className="mt-2 text-sm font-bold text-zinc-950">{item.name}</p>
                      </button>
                    );
                  })}
                </div>
                <div className="mt-4 rounded-md border border-cyan-200 bg-cyan-50 p-3">
                  <div className="flex items-center gap-2 text-sm font-bold text-cyan-900">
                    <StepIcon className="h-4 w-4" />
                    {step.name}
                  </div>
                  <p className="mt-2 text-sm leading-6 text-cyan-900/75">{step.text}</p>
                </div>
              </div>

              <div className="rounded-lg border border-zinc-200 bg-white p-5 shadow-sm">
                <div className="mb-4 flex items-center justify-between">
                  <h3 className="text-sm font-black uppercase tracking-[0.16em] text-zinc-500">
                    Operations
                  </h3>
                  <TimerReset className="h-4 w-4 text-emerald-700" />
                </div>
                <div className="grid gap-2">
                  {operationLinks.map((item) => {
                    const Icon = item.icon;
                    return (
                      <Link
                        key={item.title}
                        href={item.href}
                        className="flex h-14 items-center justify-between rounded-md border border-zinc-200 bg-white px-3 hover:border-emerald-300"
                      >
                        <span className="flex items-center gap-3">
                          <Icon className="h-4 w-4 text-emerald-700" />
                          <span>
                            <span className="block text-sm font-bold text-zinc-950">{item.title}</span>
                            <span className="block text-xs text-zinc-500">{item.detail}</span>
                          </span>
                        </span>
                        <ArrowRight className="h-4 w-4 text-zinc-400" />
                      </Link>
                    );
                  })}
                </div>
              </div>
            </aside>
          </div>
        </div>
      </section>

      <section className="mx-auto grid max-w-7xl gap-4 px-6 py-6 lg:grid-cols-4">
        {["ESDB 연결", "SMT 공정", "별도 모니터링", "HANES 구조 확장"].map((label, index) => (
          <div key={label} className="rounded-lg border border-zinc-200 bg-white p-4 shadow-sm">
            <p className="font-mono text-xs font-bold text-zinc-400">0{index + 1}</p>
            <p className="mt-2 text-sm font-bold text-zinc-950">{label}</p>
          </div>
        ))}
      </section>
    </main>
  );
}

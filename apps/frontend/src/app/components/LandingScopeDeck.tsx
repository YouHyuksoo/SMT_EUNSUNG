"use client";

/**
 * @file src/app/components/LandingScopeDeck.tsx
 * @description 히어로 우측 "관리 범위" 카드 덱 - 부채꼴 펼침 + 자동 순환 + 클릭 선택
 *
 * 초보자 가이드:
 * 1. **등장**: 마운트 직후 세 카드가 한 장으로 겹쳐 있다가 부채꼴로 펼쳐진다 (CSS transition)
 * 2. **순환**: 4초마다 앞 카드가 다음 카드로 바뀐다. 마우스를 올리면 멈추고 부채가 더 넓게 펼쳐진다
 * 3. **선택**: 카드나 하단 탭을 누르면 그 카드가 앞으로 온다
 * 4. **접근성**: prefers-reduced-motion 이면 펼침 애니메이션·자동 순환을 끈다
 */

import { useEffect, useState } from "react";
import type { LucideIcon } from "lucide-react";
import { Cpu, Package, ScanLine } from "lucide-react";

interface ScopeCard {
  key: string;
  label: string;
  en: string;
  icon: LucideIcon;
  items: { name: string; desc: string }[];
}

/** 관리 범위 - 회사 홈페이지(생산기술·제품) 및 MES 모니터링 화면(검사) 기준 */
const CARDS: ScopeCard[] = [
  {
    key: "tech",
    label: "생산 기술",
    en: "Production",
    icon: Cpu,
    items: [
      { name: "SMT", desc: "Surface Mounted Technology" },
      { name: "Soldering", desc: "솔더링" },
      { name: "Welding", desc: "웰딩" },
    ],
  },
  {
    key: "inspect",
    label: "검사",
    en: "Inspection",
    icon: ScanLine,
    items: [
      { name: "SPI", desc: "Solder Paste Inspection" },
      { name: "AOI", desc: "Automated Optical Inspection" },
      { name: "FCT", desc: "Functional Test" },
      { name: "VISION", desc: "비전 검사" },
    ],
  },
  {
    key: "product",
    label: "제품",
    en: "Products",
    icon: Package,
    items: [
      { name: "PCB Ass'y", desc: "자동차 전장용 PCB 조립품" },
      { name: "Brushcard Ass'y", desc: "브러시카드 조립품" },
    ],
  },
];

const ROTATE_MS = 4000;

/** 앞 카드 기준 상대 위치(0=앞, 1=오른쪽 뒤, 2=왼쪽 뒤)별 변환값 */
function poseOf(slot: number, opened: boolean, spread: boolean) {
  if (!opened) return "translateX(0) translateY(16px) rotate(0deg) scale(0.92)";
  const angle = spread ? 14 : 8;
  const shift = spread ? 72 : 40;
  if (slot === 0) return "translateX(0) translateY(0) rotate(0deg) scale(1)";
  if (slot === 1) return `translateX(${shift}px) translateY(14px) rotate(${angle}deg) scale(0.93)`;
  return `translateX(-${shift}px) translateY(14px) rotate(-${angle}deg) scale(0.93)`;
}

export default function LandingScopeDeck() {
  const [active, setActive] = useState(0);
  const [opened, setOpened] = useState(false);
  const [hover, setHover] = useState(false);
  const [reduced, setReduced] = useState(false);

  // 펼침 시작 (reduced-motion 이면 즉시 펼친 상태)
  useEffect(() => {
    const isReduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    setReduced(isReduced);
    if (isReduced) {
      setOpened(true);
      return;
    }
    const timer = window.setTimeout(() => setOpened(true), 450);
    return () => window.clearTimeout(timer);
  }, []);

  // 자동 순환: 앞 카드의 진행 막대 애니메이션이 끝나면 다음 카드로 (hover 중엔 막대가 멈춤)
  const next = () => setActive((i) => (i + 1) % CARDS.length);

  return (
    <div onMouseEnter={() => setHover(true)} onMouseLeave={() => setHover(false)}>
      <div className="relative h-[18rem] mx-auto max-w-sm [perspective:1200px]">
        {CARDS.map((card, i) => {
          const slot = (i - active + CARDS.length) % CARDS.length;
          const isFront = slot === 0;
          const Icon = card.icon;
          return (
            <div
              key={card.key}
              role="button"
              onClick={() => setActive(i)}
              onKeyDown={(e) => {
                if (e.key === "Enter" || e.key === " ") {
                  e.preventDefault();
                  setActive(i);
                }
              }}
              aria-label={`${card.label} 카드 보기`}
              aria-pressed={isFront}
              tabIndex={isFront ? -1 : 0}
              style={{
                transform: poseOf(slot, opened, hover),
                transformOrigin: "50% 110%",
                zIndex: 30 - slot * 10,
                transition: reduced
                  ? "none"
                  : `transform 700ms cubic-bezier(0.22, 1, 0.36, 1) ${opened ? 0 : slot * 60}ms, box-shadow 500ms, border-color 300ms`,
              }}
              className={`absolute inset-0 text-left rounded-xl border bg-card p-5 flex flex-col
                ${isFront
                  ? "border-primary/40 shadow-xl shadow-primary/10 cursor-default"
                  : "border-border shadow-md hover:border-primary/30 cursor-pointer"}`}
            >
              {/* 카드 머리 */}
              <div className="flex items-center justify-between mb-5">
                <div className="flex items-center gap-3">
                  <span className="w-9 h-9 rounded-lg bg-primary/10 text-primary flex items-center justify-center">
                    <Icon className="w-5 h-5" strokeWidth={1.75} />
                  </span>
                  <span className="flex flex-col leading-tight">
                    <span className="text-base font-semibold text-text">{card.label}</span>
                    <span className="text-[11px] tracking-[0.14em] text-text-muted uppercase">{card.en}</span>
                  </span>
                </div>
                <span className="text-xs font-mono text-text-muted">
                  {String(i + 1).padStart(2, "0")} / {String(CARDS.length).padStart(2, "0")}
                </span>
              </div>

              {/* 항목: 앞 카드가 될 때마다 순차 등장 */}
              <ul key={isFront ? `front-${active}` : card.key} className="flex-1 divide-y divide-border">
                {card.items.map((item, k) => (
                  <li
                    key={item.name}
                    className="flex items-baseline justify-between gap-3 py-2.5"
                    style={
                      isFront && !reduced
                        ? { animation: `scopeItemIn 480ms cubic-bezier(0.22,1,0.36,1) ${120 + k * 70}ms both` }
                        : undefined
                    }
                  >
                    <span className="text-sm font-semibold text-text">{item.name}</span>
                    <span className="text-xs text-text-muted text-right truncate">{item.desc}</span>
                  </li>
                ))}
              </ul>

              {/* 순환 진행 막대 (앞 카드만) */}
              <div className="mt-4 h-0.5 rounded-full bg-border overflow-hidden">
                {isFront && opened && !reduced && (
                  <div
                    key={`bar-${active}`}
                    className="h-full bg-primary origin-left"
                    onAnimationEnd={next}
                    style={{
                      animation: `scopeProgress ${ROTATE_MS}ms linear both`,
                      animationPlayState: hover ? "paused" : "running",
                    }}
                  />
                )}
              </div>
            </div>
          );
        })}
      </div>

      {/* 탭 */}
      <div role="tablist" aria-label="관리 범위" className="mt-14 flex justify-center gap-2">
        {CARDS.map((card, i) => (
          <button
            key={card.key}
            type="button"
            role="tab"
            aria-selected={active === i}
            onClick={() => setActive(i)}
            className={`px-3 py-1.5 rounded-full text-xs font-medium border transition-colors
              ${active === i
                ? "bg-primary text-white border-primary"
                : "bg-card text-text-muted border-border hover:text-text"}`}
          >
            {card.label}
          </button>
        ))}
      </div>

      <style>{`
        @keyframes scopeItemIn { from { opacity: 0; transform: translateX(-10px); } to { opacity: 1; transform: none; } }
        @keyframes scopeProgress { from { transform: scaleX(0); } to { transform: scaleX(1); } }
      `}</style>
    </div>
  );
}

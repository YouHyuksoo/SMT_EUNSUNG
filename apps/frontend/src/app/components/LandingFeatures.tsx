"use client";

/**
 * @file src/app/components/LandingFeatures.tsx
 * @description 랜딩페이지 주요 기능 소개 섹션
 *
 * 초보자 가이드:
 * 1. **Feature Cards**: 6개 핵심 기능을 카드 형태로 소개
 * 2. **아이콘**: lucide-react 아이콘 사용
 * 3. **반응형 그리드**: 모바일 1열 → 태블릿 2열 → 데스크톱 3열
 * 4. **인터랙션**: gsap 스크롤 리빌 + 마우스 3D 틸트
 */

import { useEffect, useRef } from "react";
import type { LucideIcon } from "lucide-react";
import {
  Boxes,
  Database,
  Factory,
  Gauge,
  Monitor,
  ScanLine,
} from "lucide-react";
import gsap from "gsap";

interface Feature {
  icon: LucideIcon;
  title: string;
  description: string;
  color: string;
}

const features: Feature[] = [
  {
    icon: Database,
    title: "기준정보",
    description: "품목, 라우팅, 설비, 작업자, 공정 조건을 ESDB 기준으로 관리",
    color: "bg-blue-500/10 text-blue-600 dark:text-blue-400",
  },
  {
    icon: Boxes,
    title: "수불관리",
    description: "입고, 출고, 재고, LOT 흐름을 공정 투입과 실시간 연결",
    color: "bg-amber-500/10 text-amber-600 dark:text-amber-400",
  },
  {
    icon: Factory,
    title: "SMT 생산",
    description: "PCB 투입부터 조립 공정 실적과 재공 상태를 라인별로 추적",
    color: "bg-green-500/10 text-green-600 dark:text-green-400",
  },
  {
    icon: Gauge,
    title: "OEE 관리",
    description: "설비 가동, 성능, 품질 지표를 집계해 병목과 손실을 분석",
    color: "bg-purple-500/10 text-purple-600 dark:text-purple-400",
  },
  {
    icon: ScanLine,
    title: "품질추적",
    description: "SPI, AOI, FCT, VISION 검사 결과와 LOT 추적성을 통합 조회",
    color: "bg-red-500/10 text-red-600 dark:text-red-400",
  },
  {
    icon: Monitor,
    title: "현장 모니터링",
    description: "대형 현황판은 별도 모니터링 라우트에서 독립적으로 운영",
    color: "bg-cyan-500/10 text-cyan-600 dark:text-cyan-400",
  },
];

function FeatureCard({ feature }: { feature: Feature }) {
  const ref = useRef<HTMLDivElement>(null);
  const Icon = feature.icon;

  function onMove(e: React.MouseEvent) {
    const el = ref.current;
    if (!el) return;
    const r = el.getBoundingClientRect();
    const px = (e.clientX - r.left) / r.width - 0.5;
    const py = (e.clientY - r.top) / r.height - 0.5;
    el.style.transform = `perspective(900px) rotateX(${py * -5}deg) rotateY(${px * 7}deg) translateY(-4px)`;
  }
  function reset() {
    if (ref.current) ref.current.style.transform = "";
  }

  return (
    <div
      ref={ref}
      data-feature-card
      onMouseMove={onMove}
      onMouseLeave={reset}
      className="
        group p-6 rounded-lg
        bg-card border border-border
        [transform-style:preserve-3d] will-change-transform
        transition-[box-shadow,border-color] duration-300
        hover:border-primary/30 hover:shadow-lg
      "
    >
      <div className={`
        w-11 h-11 rounded-lg flex items-center justify-center mb-4
        ${feature.color}
      `}>
        <Icon className="w-5 h-5" />
      </div>
      <h3 className="text-lg font-semibold text-text mb-2">
        {feature.title}
      </h3>
      <p className="text-sm text-text-muted leading-relaxed">
        {feature.description}
      </p>
    </div>
  );
}

export default function LandingFeatures() {
  const rootRef = useRef<HTMLElement>(null);

  useEffect(() => {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
    // 마운트 시 1회 스태거 등장. ScrollTrigger를 쓰지 않으므로 gsap가
    // 실행되지 않아도 카드는 CSS 기본(가시) 상태로 남아 영구 숨김이 없다.
    const ctx = gsap.context(() => {
      gsap.from("[data-feature-card]", {
        opacity: 0,
        y: 26,
        duration: 0.6,
        ease: "power3.out",
        stagger: 0.08,
      });
    }, rootRef);
    return () => ctx.revert();
  }, []);

  return (
    <section ref={rootRef} className="py-20 lg:py-28 bg-surface/50 border-t border-border">
      <div className="max-w-7xl mx-auto px-6">
        {/* Section Header */}
        <div className="text-center mb-14">
          <h2 className="text-3xl lg:text-4xl font-bold text-text mb-4">
            SMT 제조의 <span className="text-primary">모든 공정</span>을 관리합니다
          </h2>
          <p className="text-text-muted max-w-xl mx-auto">
            자재 흐름부터 설비 효율까지, PCB SMT 제조에 특화된
            통합 생산관리 시스템
          </p>
        </div>

        {/* Feature Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {features.map((feature) => (
            <FeatureCard key={feature.title} feature={feature} />
          ))}
        </div>
      </div>
    </section>
  );
}

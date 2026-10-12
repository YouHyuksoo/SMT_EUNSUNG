"use client";

/**
 * @file src/app/components/LandingFeatures.tsx
 * @description 랜딩페이지 MES 주요 기능 섹션 (#modules)
 *
 * 초보자 가이드:
 * 1. **기능 목록**: 6개 핵심 모듈을 2~3열 목록으로 소개
 * 2. **색상**: 아이콘은 테마 primary 한 가지 색만 사용 (카드별 색 구분 없음)
 * 3. **인터랙션**: gsap 마운트 시 1회 스태거 등장 (reduced-motion 존중)
 */

import { useEffect, useRef } from "react";
import type { LucideIcon } from "lucide-react";
import { Boxes, Database, Factory, Gauge, Monitor, ScanLine } from "lucide-react";
import gsap from "gsap";
import LandingSectionTitle from "./LandingSectionTitle";

interface Feature {
  icon: LucideIcon;
  title: string;
  description: string;
}

const features: Feature[] = [
  {
    icon: Database,
    title: "기준정보",
    description: "품목, 라우팅, 설비, 작업자, 공정 조건을 ESDB 기준으로 관리",
  },
  {
    icon: Boxes,
    title: "수불관리",
    description: "입고, 출고, 재고, LOT 흐름을 공정 투입과 실시간 연결",
  },
  {
    icon: Factory,
    title: "SMT 생산",
    description: "PCB 투입부터 조립 공정 실적과 재공 상태를 라인별로 추적",
  },
  {
    icon: Gauge,
    title: "OEE 관리",
    description: "설비 가동, 성능, 품질 지표를 집계해 병목과 손실을 분석",
  },
  {
    icon: ScanLine,
    title: "품질추적",
    description: "SPI, AOI, FCT, VISION 검사 결과와 LOT 추적성을 통합 조회",
  },
  {
    icon: Monitor,
    title: "현장 모니터링",
    description: "대형 현황판은 별도 모니터링 라우트에서 독립적으로 운영",
  },
];

export default function LandingFeatures() {
  const rootRef = useRef<HTMLElement>(null);

  useEffect(() => {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
    // 마운트 시 1회 스태거 등장. ScrollTrigger를 쓰지 않으므로 gsap가
    // 실행되지 않아도 항목은 CSS 기본(가시) 상태로 남아 영구 숨김이 없다.
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
    <section ref={rootRef} id="modules" className="scroll-mt-16 py-20 lg:py-28 border-t border-border">
      <div className="max-w-7xl mx-auto px-4 sm:px-6">
        <LandingSectionTitle ko="MES 주요 기능" en="MES MODULES" />

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-px bg-border border border-border rounded-lg overflow-hidden">
          {features.map((feature) => {
            const Icon = feature.icon;
            return (
              <div
                key={feature.title}
                data-feature-card
                className="bg-card p-6 flex gap-4 transition-colors hover:bg-surface"
              >
                <Icon className="w-6 h-6 shrink-0 text-primary" strokeWidth={1.5} />
                <div>
                  <h3 className="text-base font-semibold text-text mb-1.5">{feature.title}</h3>
                  <p className="text-sm text-text-muted leading-relaxed">{feature.description}</p>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}

"use client";

/**
 * @file src/app/components/LandingHero.tsx
 * @description 랜딩페이지 히어로 섹션 - 시스템 이름, 관리 범위 요약, 로그인/대시보드 진입
 *
 * 초보자 가이드:
 * 1. **좌측**: 회사명·시스템명·한 줄 설명·진입 버튼 (로그인은 항상, 대시보드는 로그인 시)
 * 2. **우측 카드 덱**: 생산기술·검사·제품 관리 범위 (LandingScopeDeck - 부채꼴 펼침·자동 순환)
 * 3. **배경**: 테마 border 색으로 그린 얇은 격자 (이미지 없음, 오프라인 환경 대응)
 * 4. **등장 애니메이션**: gsap 순차 stagger (reduced-motion 존중)
 */

import { useEffect, useRef } from "react";
import { ArrowRight, LayoutDashboard } from "lucide-react";
import gsap from "gsap";
import LandingScopeDeck from "./LandingScopeDeck";

interface LandingHeroProps {
  isAuthenticated: boolean;
  onLogin: () => void;
  onDashboard: () => void;
}

const GRID_MASK = "radial-gradient(ellipse 80% 70% at 70% 30%, #000 30%, transparent 75%)";

export default function LandingHero({ isAuthenticated, onLogin, onDashboard }: LandingHeroProps) {
  const rootRef = useRef<HTMLElement>(null);

  useEffect(() => {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
    const ctx = gsap.context(() => {
      gsap.from("[data-hero-reveal]", {
        opacity: 0,
        y: 24,
        duration: 0.8,
        ease: "power3.out",
        stagger: 0.1,
      });
    }, rootRef);
    return () => ctx.revert();
  }, []);

  return (
    <section ref={rootRef} className="relative overflow-hidden pt-28 pb-20 lg:pt-40 lg:pb-28">
      {/* 격자 배경 */}
      <div
        aria-hidden
        className="absolute inset-0 z-0 opacity-60"
        style={{
          backgroundImage:
            "linear-gradient(var(--border) 1px, transparent 1px), linear-gradient(90deg, var(--border) 1px, transparent 1px)",
          backgroundSize: "48px 48px",
          maskImage: GRID_MASK,
          WebkitMaskImage: GRID_MASK,
        }}
      />

      <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 grid lg:grid-cols-12 gap-12 lg:gap-10 items-center">
        {/* 좌측: 소개 */}
        <div className="lg:col-span-7">
          <p data-hero-reveal className="mb-6 text-xs font-semibold tracking-[0.2em] text-primary">
            EUNSUNG ELECTRONICS · MES
          </p>

          <h1
            data-hero-reveal
            className="text-4xl sm:text-5xl lg:text-6xl font-bold text-text leading-[1.15] tracking-tight mb-6"
          >
            은성전장
            <br />
            생산관리시스템
          </h1>

          <p
            data-hero-reveal
            className="text-base sm:text-lg text-text-muted max-w-xl mb-10 leading-relaxed"
          >
            자동차 전장용 PCB Ass&apos;y·Brushcard Ass&apos;y 생산 라인의 자재 수불, 공정 실적,
            검사 결과, 설비 가동 현황을 관리합니다.
          </p>

          <div data-hero-reveal className="flex flex-col sm:flex-row gap-3">
            <button
              onClick={onLogin}
              className="flex items-center justify-center gap-2 px-7 py-3.5 rounded-lg text-base font-semibold
                         bg-primary text-white
                         hover:bg-primary-hover active:scale-[0.98] transition-all duration-200"
            >
              로그인
              <ArrowRight className="w-5 h-5" />
            </button>
            {isAuthenticated && (
              <button
                onClick={onDashboard}
                className="flex items-center justify-center gap-2 px-7 py-3.5 rounded-lg text-base font-semibold
                           border border-border bg-card text-text
                           hover:border-primary/50 hover:text-primary transition-colors duration-200"
              >
                <LayoutDashboard className="w-5 h-5" />
                대시보드로 이동
              </button>
            )}
          </div>
        </div>

        {/* 우측: 관리 범위 카드 덱 */}
        <div data-hero-reveal className="lg:col-span-5">
          <LandingScopeDeck />
        </div>
      </div>
    </section>
  );
}

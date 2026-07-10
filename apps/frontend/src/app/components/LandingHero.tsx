"use client";

/**
 * @file src/app/components/LandingHero.tsx
 * @description 랜딩페이지 히어로 섹션 - 메인 타이틀, 설명, CTA 버튼
 *
 * 초보자 가이드:
 * 1. **몽환적 블룸 배경**: DreamyBackground (선 없이 빛번짐만)
 * 2. **CTA 버튼**: 인증 상태에 따라 대시보드/로그인으로 이동
 * 3. **등장 애니메이션**: gsap 순차 stagger (reduced-motion 존중)
 */

import { useEffect, useRef } from "react";
import { ArrowRight, BarChart3, Zap, ShieldCheck } from "lucide-react";
import gsap from "gsap";
import { DreamyBackground } from "./DreamyBackground";

interface LandingHeroProps {
  onNavigate: () => void;
  isAuthenticated: boolean;
}

export default function LandingHero({ onNavigate, isAuthenticated }: LandingHeroProps) {
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
    <section ref={rootRef} className="relative overflow-hidden pt-32 pb-24 lg:pt-44 lg:pb-36">
      {/* 몽환적 소프트 블룸 배경 */}
      <DreamyBackground className="z-0" />

      <div className="relative z-10 max-w-7xl mx-auto px-6">
        <div className="max-w-3xl mx-auto text-center">
          {/* Badge */}
          <div
            data-hero-reveal
            className="inline-flex items-center gap-2 px-4 py-1.5 mb-8 rounded-full
                       border border-border/60 bg-card/50 text-primary text-sm font-medium
                       backdrop-blur-md shadow-sm"
          >
            <Zap className="w-3.5 h-3.5" />
            Manufacturing Execution System
          </div>

          {/* Title */}
          <h1
            data-hero-reveal
            className="text-4xl sm:text-5xl lg:text-[4rem] font-bold text-text
                       leading-[1.15] tracking-tight mb-6"
          >
            스마트한{" "}
            <span className="text-primary drop-shadow-[0_2px_24px_rgba(236,11,122,0.35)]">
              생산관리
            </span>
            의
            <br />
            시작
          </h1>

          {/* Description */}
          <p
            data-hero-reveal
            className="text-lg text-text-muted max-w-xl mx-auto mb-10 leading-relaxed"
          >
            PCB SMT 생산 전 공정을 실시간으로 관리하고, 데이터 기반 의사결정으로
            생산성을 극대화하세요.
          </p>

          {/* CTA Buttons */}
          <div
            data-hero-reveal
            className="flex flex-col sm:flex-row items-center justify-center gap-4"
          >
            <button
              onClick={onNavigate}
              className="flex items-center gap-2 px-8 py-3.5 rounded-lg text-base font-semibold
                         bg-primary text-white shadow-lg shadow-primary/30
                         hover:bg-primary-hover active:scale-[0.98] transition-all duration-200"
            >
              {isAuthenticated ? "대시보드로 이동" : "시작하기"}
              <ArrowRight className="w-5 h-5" />
            </button>
          </div>

          {/* Stats */}
          <div data-hero-reveal className="mt-16 grid grid-cols-3 gap-8 max-w-lg mx-auto">
            <div className="text-center">
              <div className="flex items-center justify-center gap-1.5 mb-1">
                <BarChart3 className="w-4 h-4 text-primary" />
                <span className="text-2xl font-bold text-text">16+</span>
              </div>
              <span className="text-xs text-text-muted">관리 모듈</span>
            </div>
            <div className="text-center">
              <div className="flex items-center justify-center gap-1.5 mb-1">
                <Zap className="w-4 h-4 text-primary" />
                <span className="text-2xl font-bold text-text">실시간</span>
              </div>
              <span className="text-xs text-text-muted">생산 모니터링</span>
            </div>
            <div className="text-center">
              <div className="flex items-center justify-center gap-1.5 mb-1">
                <ShieldCheck className="w-4 h-4 text-primary" />
                <span className="text-2xl font-bold text-text">100%</span>
              </div>
              <span className="text-xs text-text-muted">추적성 보장</span>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

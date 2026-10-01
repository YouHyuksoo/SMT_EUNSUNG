"use client";

/**
 * @file src/app/components/LandingHeader.tsx
 * @description 랜딩페이지 상단 네비게이션 - 로고, 섹션 링크, 로그인/대시보드 버튼
 *
 * 초보자 가이드:
 * 1. **로그인 버튼은 항상 표시**한다. 로그인된 경우 대시보드 버튼이 옆에 추가된다.
 * 2. **섹션 링크**는 같은 페이지 앵커(#company 등)로 이동한다. 모바일에서는 숨김.
 * 3. **스크롤 시** 배경색 변경으로 가독성 확보
 */

import { useState, useEffect } from "react";
import { useTranslation } from "react-i18next";
import { Factory, LogIn, LayoutDashboard } from "lucide-react";
import Link from "next/link";
import LanguageSwitcher from "@/components/layout/LanguageSwitcher";
import ThemeSelector from "./ThemeSelector";

interface LandingHeaderProps {
  isAuthenticated: boolean;
  onLogin: () => void;
  onDashboard: () => void;
}

const NAV_LINKS = [
  { label: "회사소개", href: "#company" },
  { label: "제품·생산기술", href: "#products" },
  { label: "MES 기능", href: "#modules" },
];

export default function LandingHeader({ isAuthenticated, onLogin, onDashboard }: LandingHeaderProps) {
  const { t } = useTranslation();
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => setScrolled(window.scrollY > 20);
    handleScroll();
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  return (
    <header
      className={`
        fixed top-0 left-0 right-0 z-50
        transition-all duration-300
        ${scrolled
          ? "bg-background/95 backdrop-blur-md border-b border-border shadow-sm"
          : "bg-transparent border-b border-transparent"
        }
      `}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 h-16 flex items-center justify-between gap-4">
        {/* Logo */}
        <Link href="/" className="flex items-center gap-3 group shrink-0">
          <div className="w-8 h-8 bg-primary rounded-md flex items-center justify-center
                          group-hover:scale-105 transition-transform">
            <Factory className="w-5 h-5 text-white" />
          </div>
          <span className="flex flex-col leading-none">
            <span className="text-[10px] font-semibold tracking-[0.18em] text-text-muted">EUNSUNG</span>
            <span className="font-bold text-base text-text">은성전장 MES</span>
          </span>
        </Link>

        {/* 섹션 링크 */}
        <nav className="hidden md:flex items-center gap-8">
          {NAV_LINKS.map((link) => (
            <a
              key={link.href}
              href={link.href}
              className="text-sm font-medium text-text-muted hover:text-text transition-colors"
            >
              {link.label}
            </a>
          ))}
        </nav>

        {/* 우측 액션 */}
        <div className="flex items-center gap-2">
          <ThemeSelector />
          <LanguageSwitcher />
          {isAuthenticated && (
            <button
              onClick={onDashboard}
              suppressHydrationWarning
              className="
                hidden sm:flex items-center gap-2 px-4 py-2.5
                border border-border bg-card text-text rounded-lg
                text-sm font-medium
                hover:border-primary/50 hover:text-primary
                transition-colors duration-200
              "
            >
              <LayoutDashboard className="w-4 h-4" />
              {t("landing.dashboard")}
            </button>
          )}
          <button
            onClick={onLogin}
            className="
              flex items-center gap-2 px-4 sm:px-5 py-2.5
              bg-primary text-white rounded-lg
              text-sm font-medium
              hover:bg-primary-hover active:scale-95
              transition-all duration-200
            "
          >
            <LogIn className="w-4 h-4" />
            {t("landing.login")}
          </button>
        </div>
      </div>
    </header>
  );
}

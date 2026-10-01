"use client";

/**
 * @file src/app/page.tsx
 * @description 은성전장 MES 랜딩페이지 - 회사·제품·생산기술 소개와 로그인/대시보드 진입점
 *
 * 초보자 가이드:
 * 1. **로그인 버튼**: 인증 여부와 관계없이 항상 표시 (/login)
 * 2. **대시보드 버튼**: 로그인된 경우에만 추가 표시 (/dashboard)
 * 3. **본문 내용**: 회사 홈페이지(eunsungele.com)에 게시된 사실만 사용
 */

import { useRouter } from "next/navigation";
import { useAuthStore } from "@/stores/authStore";
import LandingHero from "./components/LandingHero";
import LandingCompany from "./components/LandingCompany";
import LandingFeatures from "./components/LandingFeatures";
import LandingFooter from "./components/LandingFooter";
import LandingHeader from "./components/LandingHeader";

export default function LandingPage() {
  const router = useRouter();
  const { isAuthenticated } = useAuthStore();

  const goLogin = () => router.push("/login");
  const goDashboard = () => router.push("/dashboard");

  return (
    <div className="min-h-screen bg-background">
      <LandingHeader
        isAuthenticated={isAuthenticated}
        onLogin={goLogin}
        onDashboard={goDashboard}
      />
      <LandingHero
        isAuthenticated={isAuthenticated}
        onLogin={goLogin}
        onDashboard={goDashboard}
      />
      <LandingCompany />
      <LandingFeatures />
      <LandingFooter />
    </div>
  );
}

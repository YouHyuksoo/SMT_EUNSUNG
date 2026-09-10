"use client";

/**
 * @file src/app/pda/material/menu/page.tsx
 * @description 자재관리 서브메뉴 — SMMEX 스타일 2열 그리드 레이아웃
 *
 * 초보자 가이드:
 * 1. PdaHeader: 뒤로가기 → /pda/menu (메인 메뉴)
 * 2. PdaMenuGrid layout="grid": 2열 그리드, h-20 버튼
 * 3. pdaMaterialSubMenuItems: pdaMenuConfig에서 가져온 4개 서브메뉴 항목
 * 4. pdaAllowedMenus로 menuCode 필터링 (없으면 항상 표시)
 */
import { useAuthStore } from "@/stores/authStore";
import { isMenuAllowed } from "@/utils/menuAccess";
import PdaHeader from "@/components/pda/PdaHeader";
import PdaMenuGrid from "@/components/pda/PdaMenuGrid";
import { pdaMaterialSubMenuItems } from "@/components/pda/pdaMenuConfig";

export default function MaterialMenuPage() {
  const { user, pdaAllowedMenus } = useAuthStore();

  const isAdmin = user?.role === "ADMIN";

  // 판정 기준은 isMenuAllowed 한 곳에 있다 (ADMIN·코드 없는 메뉴·권한 미연동 시 통과)
  const visibleItems = pdaMaterialSubMenuItems.filter((item) =>
    isMenuAllowed(item.menuCode, pdaAllowedMenus, isAdmin)
  );

  return (
    <>
      <PdaHeader titleKey="pda.menu.material" backPath="/pda/menu" />
      <PdaMenuGrid items={visibleItems} layout="grid" centered />
    </>
  );
}

/**
 * @file src/components/layout/page-registries/query__pda-scan.generated.ts
 * @description 자동 생성 파일 — 직접 수정 금지. `node scripts/gen-page-registry.mjs`로 재생성.
 */
import dynamic from "next/dynamic";
import type { ComponentType } from "react";

export function getPageComponent(): ComponentType {
  return dynamic(() => import("@/app/(authenticated)/query/pda-scan/page"), { ssr: false });
}

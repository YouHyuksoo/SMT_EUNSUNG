"use client";

/**
 * @file src/app/(authenticated)/production/master-plan/page.tsx
 * @description 제품생산계획 — PB w_pln_product_master_plan_master 이식
 *
 * 화면 구현은 PlanScreen 에 있다 (반제품생산계획과 규칙이 같다).
 * 이 파일은 MI 설정만 넘긴다.
 */
import PlanScreen from '../components/PlanScreen';

export default function MasterPlanPage() {
  return (
    <PlanScreen
      config={{
        title: '제품생산계획',
        subtitle: '라인별 제품 생산계획을 시간대 10칸으로 관리합니다',
        path: '/production/master-plan',
        variant: 'mi',
      }}
    />
  );
}

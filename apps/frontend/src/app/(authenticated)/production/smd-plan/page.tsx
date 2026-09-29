"use client";

/**
 * @file src/app/(authenticated)/production/smd-plan/page.tsx
 * @description 반제품생산계획 — PB w_pln_assembly_master_plan_master 이식
 *
 * 화면 구현은 PlanScreen 에 있다 (제품생산계획과 규칙이 같다).
 * 이 파일은 SMD 설정만 넘긴다.
 */
import PlanScreen from '../components/PlanScreen';

export default function SmdPlanPage() {
  return (
    <PlanScreen
      config={{
        title: '반제품생산계획',
        subtitle: 'SMT 반제품 생산계획을 시간대 10칸으로 관리합니다',
        path: '/production/smd-plan',
        variant: 'smd',
      }}
    />
  );
}

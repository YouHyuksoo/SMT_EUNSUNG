/**
 * @file src/app/(authenticated)/tracking/forward-trace/page.tsx
 * @description 정추적(PCB→자재) — PCB 시리얼 하나의 설비 검사·릴 자재·솔더·지그·수리 이력을 모아 본다.
 *
 * 초보자 가이드:
 * - 화면은 components/trace/TraceabilityScreen (webdisplay 멕시코 정추적 화면)을 그대로 쓴다.
 * - 데이터는 Next API /api/trace/forward (lib/trace, IQ_MACHINE_*·IB_SMT_CHECKHIST 등).
 * - 번역은 TraceIntlProvider(next-intl) 가 업무 화면 언어를 따라 붙인다.
 */
'use client';

import TraceIntlProvider from '@/components/trace/TraceIntlProvider';
import { TraceabilityScreen } from '@/components/trace/TraceabilityScreen';

export default function ForwardTracePage() {
  return (
    <TraceIntlProvider>
      <TraceabilityScreen />
    </TraceIntlProvider>
  );
}

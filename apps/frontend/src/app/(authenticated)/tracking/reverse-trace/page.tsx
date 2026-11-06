/**
 * @file src/app/(authenticated)/tracking/reverse-trace/page.tsx
 * @description 역추적(자재→PCB) — 자재 릴 바코드로 그 릴이 장착된 RUN 의 PCB 시리얼을 찾는다.
 *
 * 초보자 가이드:
 * - 화면은 components/trace/ReverseTraceScreen (webdisplay 멕시코 역추적 화면)을 그대로 쓴다.
 * - 데이터는 Next API /api/trace/reverse (IB_SMT_CHECKHIST → IP_PRODUCT_2D_BARCODE).
 * - 번역은 TraceIntlProvider(next-intl) 가 업무 화면 언어를 따라 붙인다.
 */
'use client';

import TraceIntlProvider from '@/components/trace/TraceIntlProvider';
import { ReverseTraceScreen } from '@/components/trace/ReverseTraceScreen';

export default function ReverseTracePage() {
  return (
    <TraceIntlProvider>
      <ReverseTraceScreen />
    </TraceIntlProvider>
  );
}

"use client";

/**
 * @file src/app/(authenticated)/warehouse/vacuum-stock/page.tsx
 * @description 진공포장재고조회 — PB w_mat_vacuum_scan_query 이식
 *
 * 초보자 가이드:
 * 1. 진공포장은 습기를 막아 보관하는 방법이다. **실측 재고 0건** — 이력은 9,343건
 * 있지만 지금 포장 상태로 남아 있는 것이 없다. 화면이 비어 보이는 것은 정상이다.
 * 2. **화면 본체는 `ChamberStockScreen` 이 공유한다.** 262·263·264 의 PB SQL 이
 *    글자까지 같고 `chamber_type` 인자만 다르기 때문이다 (실측). 여기서는 그 값과
 *    화면 이름만 정한다.
 */
import { ChamberStockScreen } from '../components/ChamberStockScreen';

export default function 진공포장재고Page() {
  return (
    <ChamberStockScreen
      chamberType="V"
      title="진공포장재고조회"
      description="진공포장해 둔 자재를 봅니다"
    />
  );
}

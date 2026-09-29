"use client";

/**
 * @file src/app/(authenticated)/warehouse/dehumi-stock/page.tsx
 * @description 제습함재고조회 — PB w_mat_dehumi_scan_query 이식
 *
 * 초보자 가이드:
 * 1. 제습함은 부품을 건조한 상태로 보관하는 곳이다. 셋 중 실제로 가장 많이 쓰인다 —
 * 실측 재고 55건(40묶음).
 * 2. **화면 본체는 `ChamberStockScreen` 이 공유한다.** 262·263·264 의 PB SQL 이
 *    글자까지 같고 `chamber_type` 인자만 다르기 때문이다 (실측). 여기서는 그 값과
 *    화면 이름만 정한다.
 */
import { ChamberStockScreen } from '../components/ChamberStockScreen';

export default function 제습함재고Page() {
  return (
    <ChamberStockScreen
      chamberType="D"
      title="제습함재고조회"
      description="제습함에 들어가 있는 자재를 봅니다"
    />
  );
}

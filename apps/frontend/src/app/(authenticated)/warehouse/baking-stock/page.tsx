"use client";

/**
 * @file src/app/(authenticated)/warehouse/baking-stock/page.tsx
 * @description 베이킹재고조회 — PB w_mat_baking_scan_query 이식
 *
 * 초보자 가이드:
 * 1. 베이킹실은 습기를 먹은 부품을 구워 말리는 곳이다. 정해진 시간을 넘기면 다시
 * 구워야 하므로 경과시간이 이 화면의 핵심이다. 실측 재고 4건.
 * 2. **화면 본체는 `ChamberStockScreen` 이 공유한다.** 262·263·264 의 PB SQL 이
 *    글자까지 같고 `chamber_type` 인자만 다르기 때문이다 (실측). 여기서는 그 값과
 *    화면 이름만 정한다.
 */
import { ChamberStockScreen } from '../components/ChamberStockScreen';

export default function 베이킹재고Page() {
  return (
    <ChamberStockScreen
      chamberType="B"
      title="베이킹재고조회"
      description="베이킹실에 들어가 있는 자재를 봅니다"
    />
  );
}

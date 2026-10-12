"use client";

/**
 * @file src/app/(authenticated)/confirm/buy-price/page.tsx
 * @description 구매단가승인 — PB w_mat_buy_price_confirm 이식
 *
 * 화면 구현은 PriceConfirmScreen 에 있다 (판매·S-PARTS 와 규칙이 같다).
 */
import PriceConfirmScreen from '../components/PriceConfirmScreen';

export default function BuyPriceConfirmPage() {
  return (
    <PriceConfirmScreen
      config={{
        title: '구매단가승인',
        subtitle: '자재 구매단가 변경을 승인합니다',
        path: '/confirm/buy-price',
        variant: 'buy',
        partnerLabel: '공급처',
      }}
    />
  );
}

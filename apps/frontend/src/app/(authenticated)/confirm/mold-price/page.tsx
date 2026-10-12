"use client";

/**
 * @file src/app/(authenticated)/confirm/mold-price/page.tsx
 * @description S-PARTS구매단가승인 — PB w_mcn_mold_buy_price_confirm 이식
 *
 * 화면 구현은 PriceConfirmScreen 에 있다.
 * S-PARTS 는 라인유형이 키가 아니라 그 컬럼을 표시하지 않는다.
 */
import PriceConfirmScreen from '../components/PriceConfirmScreen';

export default function MoldPriceConfirmPage() {
  return (
    <PriceConfirmScreen
      config={{
        title: 'S-PARTS구매단가승인',
        subtitle: 'S-PARTS 구매단가 변경을 승인합니다',
        path: '/confirm/mold-price',
        variant: 'mold',
        partnerLabel: '공급처',
        emptyNote: 'IMCN_MOLD_UNIT_PRICE 는 현재 0행입니다 — 아직 S-PARTS 단가를 쓰지 않습니다.',
      }}
    />
  );
}

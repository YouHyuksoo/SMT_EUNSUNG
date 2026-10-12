"use client";

/**
 * @file src/app/(authenticated)/confirm/sale-price/page.tsx
 * @description 판매단가승인 — PB w_sal_sale_price_confirm 이식
 *
 * 화면 구현은 PriceConfirmScreen 에 있다.
 * 판매단가에는 승인번호·납품조건 컬럼이 없어 그 둘은 표시하지 않는다.
 */
import PriceConfirmScreen from '../components/PriceConfirmScreen';

export default function SalePriceConfirmPage() {
  return (
    <PriceConfirmScreen
      config={{
        title: '판매단가승인',
        subtitle: '제품 판매단가 변경을 승인합니다',
        path: '/confirm/sale-price',
        variant: 'sale',
        partnerLabel: '고객',
      }}
    />
  );
}

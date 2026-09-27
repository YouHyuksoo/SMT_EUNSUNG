/**
 * @file src/modules/price-confirm/price-confirm.module.ts
 * @description 승인(M_CONFIRM) 대분류 — PB 이관 모듈
 *
 * 화면 ↔ 컨트롤러 대응:
 *   구매단가승인        w_mat_buy_price_confirm       → BuyPriceConfirmController
 *   판매단가승인        w_sal_sale_price_confirm      → SalePriceConfirmController
 *   S-PARTS구매단가승인  w_mcn_mold_buy_price_confirm  → MoldPriceConfirmController
 *   설계BOM승인         w_des_bom_confirm_master      → BomConfirmController
 *
 * 단가승인 3화면은 PriceConfirmService 하나를 공유한다 — 테이블과 키 컬럼만
 * 다르고 승인 방식이 같아서, 규칙을 세 곳에 복붙하면 한쪽만 고쳐지는 일이 생긴다.
 *
 * 반출반입승인 2화면(w_com_carrying_out_bring_in_confirm / _security)은
 * 사용자 지시로 이관 범위에서 제외했다.
 */
import { Module } from '@nestjs/common';
import { BomConfirmController } from './bom-confirm.controller';
import { BomConfirmService } from './bom-confirm.service';
import {
  BuyPriceConfirmController,
  MoldPriceConfirmController,
  SalePriceConfirmController,
} from './price-confirm.controllers';
import { PriceConfirmService } from './price-confirm.service';

@Module({
  controllers: [
    BuyPriceConfirmController,
    SalePriceConfirmController,
    MoldPriceConfirmController,
    BomConfirmController,
  ],
  providers: [PriceConfirmService, BomConfirmService],
})
export class PriceConfirmModule {}

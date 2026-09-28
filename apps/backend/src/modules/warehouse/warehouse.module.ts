/**
 * @file src/modules/warehouse/warehouse.module.ts
 * @description 자재창고(M_WAREHOUSE) 대분류 — PB 이관 모듈
 *
 * 화면 ↔ 서비스 대응 (PB 메뉴 순번 · MENU_ITEM_TEXT):
 *   262 베이킹재고조회     w_mat_baking_scan_query   → ChamberStockService
 *   263 진공포장재고조회   w_mat_vacuum_scan_query   → ChamberStockService
 *   264 제습함재고조회     w_mat_dehumi_scan_query   → ChamberStockService
 *   266 SMT 공릴체크       w_smt_recycle_check_rpt   → RecycleCheckService
 *   244 솔더입출고조회     w_mat_solder_receipt_issue_master → SolderService (쓰기)
 *   245 솔더라인투입이력   w_mat_solder_input_move_query     → SolderService
 *   235 자재입고전표관리   w_mat_receipt_slip_master         → ReceiptSlipService (쓰기)
 *   237 자재바코드입고관리 w_mat_other_receipt_barcode_master → BarcodeReceiptService (쓰기)
 *   243 솔더라벨 발행      w_mat_receipt_slip_master_onetek_solder → SolderLabelService (쓰기)
 *
 * **왜 화면당 모듈이 아닌가.** 기존 `material` 모듈은 화면당 모듈 하나
 * (`material-current-inventory.module.ts` 등) 패턴인데, 자재창고는 20화면이라
 * 그 패턴으로 가면 모듈이 20개가 된다. 리포트(23화면)에서 쓴 도메인 모듈 하나
 * 방식을 따른다.
 *
 * **이 대분류는 쓰기가 본체다.** 20화면 중 14개가 입고·출고·취소·분할로
 * 운영 원장을 바꾼다 (실측). 1단계는 그중 조회 전용 4화면만 담았다 —
 * 쓰기 화면은 검증 방법을 정한 뒤에 단계별로 올린다.
 *
 * **이관 판정에서 걸러낸 것** (실측 근거):
 *   235·243 의 `d_mat_tb_vis_inout_issueno_hub` — 읽는 표
 *   `TB_VIS_INOUT_ISSUENO_HUB` 가 은성 DB 에 **없다**. 게다가 PB 의
 *   `dw_3.retrieve` 4곳 중 3곳이 주석 처리돼 있어 우클릭 하나만 살아 있다 —
 *   PB 에서도 이미 죽은 기능이므로 그 조회만 빼고 화면은 옮긴다.
 */
import { Module } from '@nestjs/common';
import { BarcodeReceiptService } from './barcode-receipt.service';
import { ChamberStockService } from './chamber-stock.service';
import { RecycleCheckService } from './recycle-check.service';
import { ReceiptSlipService } from './receipt-slip.service';
import { SolderLabelService } from './solder-label.service';
import { SolderService } from './solder.service';
import {
  BarcodeReceiptController,
  ChamberStockController,
  RecycleCheckController,
  SolderController,
  ReceiptSlipController,
  SolderLabelController,
  SolderInputHistoryController,
} from './warehouse.controllers';

@Module({
  controllers: [
    ChamberStockController,
    RecycleCheckController,
    SolderController,
    SolderInputHistoryController,
    ReceiptSlipController,
    BarcodeReceiptController,
    SolderLabelController,
  ],
  providers: [
    ChamberStockService,
    RecycleCheckService,
    SolderService,
    ReceiptSlipService,
    BarcodeReceiptService,
    SolderLabelService,
  ],
})
/**
 * 클래스 이름이 `MaterialWarehouseModule` 인 이유: `modules/inventory` 에 이미
 * 창고 기준정보용 `WarehouseModule` 이 있다 (라우트 `inventory/warehouses`).
 * 같은 이름을 쓰면 app.module 에서 식별자가 충돌한다 (실측 TS2300).
 */
export class MaterialWarehouseModule {}

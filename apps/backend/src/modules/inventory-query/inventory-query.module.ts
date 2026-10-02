/**
 * @file src/modules/inventory-query/inventory-query.module.ts
 * @description 재고(M_INVENTORY) 대분류 — PB 이관 모듈
 *
 * 화면 ↔ 서비스 대응:
 *   269 총재고조회         w_mat_total_inventory_query    → TotalInventoryService
 *   271 자재재고마감       w_mat_inventory_close_report   → InventoryCloseService
 *   272 자재재고조사       w_mat_inventory_check_master   → InventoryCheckService (쓰기)
 *   274 자재바코드스캔실사 w_mat_barcode_check_master     → InventoryCheckService (조회)
 *
 * **왜 `modules/inventory` 가 아닌가.** 그 폴더에는 이미 창고·로케이션 기준정보용
 * `WarehouseModule` 이 있다 (라우트 `inventory/warehouses`). 여기에 끼워 넣으면
 * 성격이 다른 두 묶음이 한 모듈에 섞이고 `WarehouseModule` 이름도 자재창고 쪽
 * `MaterialWarehouseModule` 과 헷갈린다. 대분류 단위로 따로 둔다.
 *
 * **이 대분류는 대부분 조회다.** 쓰기는 272 재고조정 하나뿐이고, 그것도 이 현장에서
 * 한 번도 돌아간 적이 없다 (출고 원장에 계정 M009 가 0건 — 실측).
 */
import { Module } from '@nestjs/common';
import { InventoryCheckService } from './inventory-check.service';
import { StocktakeService } from './stocktake.service';
import { WipStocktakeService } from './wip-stocktake.service';
import { InventoryCloseService } from './inventory-close.service';
import { TotalInventoryService } from './total-inventory.service';
import {
  BarcodeCheckController,
  InventoryCheckController,
  InventoryCloseController,
  StocktakeController,
  WipStocktakeController,
  TotalInventoryController,
} from './inventory-query.controllers';

@Module({
  controllers: [
    TotalInventoryController,
    InventoryCloseController,
    InventoryCheckController,
    BarcodeCheckController,
    StocktakeController,
    WipStocktakeController,
  ],
  providers: [
    TotalInventoryService,
    InventoryCloseService,
    InventoryCheckService,
    StocktakeService,
    WipStocktakeService,
  ],
})
export class InventoryQueryModule {}

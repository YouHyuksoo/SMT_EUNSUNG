import { Module } from '@nestjs/common';
import { MoldInventoryController } from './mold-inventory.controller';
import { MoldInventoryService } from './mold-inventory.service';
import { MoldIssueController } from './mold-issue.controller';
import { MoldIssueService } from './mold-issue.service';
import { MoldMasterController } from './mold-master.controller';
import { MoldMasterService } from './mold-master.service';
import { MoldOrderController } from './mold-order.controller';
import { MoldOrderService } from './mold-order.service';
import { MoldPriceController } from './mold-price.controller';
import { MoldPriceService } from './mold-price.service';
import { MoldReceiptController } from './mold-receipt.controller';
import { MoldReceiptService } from './mold-receipt.service';
import { MoldRepairController } from './mold-repair.controller';
import { MoldRepairService } from './mold-repair.service';

/**
 * S-PARTS(금형) 관리 — PB M_MOLD 메뉴 8화면.
 * PB 소스의 테이블 이름은 전부 IMCN_MOLD_* 다. 화면 문구만 은성 메뉴를 따라 S-PARTS 로 쓴다.
 */
@Module({
  controllers: [
    MoldMasterController,
    MoldInventoryController,
    MoldOrderController,
    MoldReceiptController,
    MoldIssueController,
    MoldRepairController,
    MoldPriceController,
  ],
  providers: [
    MoldMasterService,
    MoldInventoryService,
    MoldOrderService,
    MoldReceiptService,
    MoldIssueService,
    MoldRepairService,
    MoldPriceService,
  ],
})
export class MoldModule {}

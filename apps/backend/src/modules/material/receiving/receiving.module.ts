import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { LabelPrintLog } from '../../../entities/label-print-log.entity';
import { MatArrival } from '../../../entities/mat-arrival.entity';
import { MatArrivalStock } from '../../../entities/mat-arrival-stock.entity';
import { MatArrivalTransaction } from '../../../entities/mat-arrival-transaction.entity';
import { MatIssue } from '../../../entities/mat-issue.entity';
import { MatLot } from '../../../entities/mat-lot.entity';
import { MatReceiving } from '../../../entities/mat-receiving.entity';
import { MatStock } from '../../../entities/mat-stock.entity';
import { ItemMaster } from '../../../entities/item-master.entity';
import { PartnerMaster } from '../../../entities/partner-master.entity';
import { PurchaseOrder } from '../../../entities/purchase-order.entity';
import { PurchaseOrderItem } from '../../../entities/purchase-order-item.entity';
import { StockTransaction } from '../../../entities/stock-transaction.entity';
import { VendorBarcodeMapping } from '../../../entities/vendor-barcode-mapping.entity';
import { Warehouse } from '../../../entities/warehouse.entity';
import { WorkerMaster } from '../../../entities/worker-master.entity';
import { SystemModule } from '../../system/system.module';
import { ArrivalController } from '../controllers/arrival.controller';
import { ReceiptCancelController } from '../controllers/receipt-cancel.controller';
import { ReceivingController } from '../controllers/receiving.controller';
import { ArrivalService } from '../services/arrival.service';
import { ReceiptCancelService } from '../services/receipt-cancel.service';
import { ReceivingService } from '../services/receiving.service';

@Module({
  imports: [
    SystemModule,
    TypeOrmModule.forFeature([
      LabelPrintLog,
      MatArrival,
      MatArrivalStock,
      MatArrivalTransaction,
      MatIssue,
      MatLot,
      MatReceiving,
      MatStock,
      ItemMaster,
      PartnerMaster,
      PurchaseOrder,
      PurchaseOrderItem,
      StockTransaction,
      VendorBarcodeMapping,
      Warehouse,
      WorkerMaster,
    ]),
  ],
  controllers: [
    ArrivalController,
    ReceivingController,
    ReceiptCancelController,
  ],
  providers: [
    ArrivalService,
    ReceivingService,
    ReceiptCancelService,
  ],
})
export class ReceivingModule {}

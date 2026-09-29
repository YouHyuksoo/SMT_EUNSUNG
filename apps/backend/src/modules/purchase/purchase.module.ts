import { Module } from '@nestjs/common';
import { ArrivalService } from './arrival.service';
import {
  ArrivalController,
  ForecastOrderController,
  PurchaseOrderController,
} from './purchase.controllers';
import { PurchaseOrderService } from './purchase-order.service';

@Module({
  controllers: [PurchaseOrderController, ForecastOrderController, ArrivalController],
  providers: [PurchaseOrderService, ArrivalService],
})
export class PurchaseModule {}

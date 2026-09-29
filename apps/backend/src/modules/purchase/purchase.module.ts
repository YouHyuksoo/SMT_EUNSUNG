import { Module } from '@nestjs/common';
import { ArrivalService } from './arrival.service';
import {
  ArrivalController,
  RequirementPlanController,
  ForecastOrderController,
  PurchaseOrderController,
} from './purchase.controllers';
import { PurchaseOrderService } from './purchase-order.service';
import { RequirementPlanService } from './requirement-plan.service';

@Module({
  controllers: [
    PurchaseOrderController,
    ForecastOrderController,
    ArrivalController,
    RequirementPlanController,
  ],
  providers: [PurchaseOrderService, ArrivalService, RequirementPlanService],
})
export class PurchaseModule {}

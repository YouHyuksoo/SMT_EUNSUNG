import { Module } from '@nestjs/common';
import { ArrivalService } from './arrival.service';
import {
  ArrivalController,
  OrderPlanController,
  RequirementPlanController,
  ForecastOrderController,
  PurchaseOrderController,
} from './purchase.controllers';
import { PurchaseOrderService } from './purchase-order.service';
import { OrderPlanService } from './order-plan.service';
import { RequirementPlanService } from './requirement-plan.service';

@Module({
  controllers: [
    PurchaseOrderController,
    ForecastOrderController,
    ArrivalController,
    OrderPlanController,
  RequirementPlanController,
  ],
  providers: [
    PurchaseOrderService,
    ArrivalService,
    RequirementPlanService,
    OrderPlanService,
  ],
})
export class PurchaseModule {}

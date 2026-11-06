import { Module } from '@nestjs/common';
import { ProductInventoryController } from './controllers/product-inventory.controller';
import {
  ProductFgController,
  ProductPackController,
} from './controllers/product-shipping.controllers';
import { ProductFgService } from './services/product-fg.service';
import { ProductInventoryService } from './services/product-inventory.service';
import { ProductPackService } from './services/product-pack.service';
import { ShippingOrderController } from './controllers/shipping-order.controller';
import { ShippingOrderService } from './services/shipping-order.service';

@Module({
  controllers: [
    ProductInventoryController,
    ProductPackController,
    ProductFgController,
    ShippingOrderController,
  ],
  providers: [ProductInventoryService, ProductPackService, ProductFgService, ShippingOrderService],
})
export class ProductInventoryModule {}

import { Module } from '@nestjs/common';
import { ProductInventoryController } from './controllers/product-inventory.controller';
import {
  ProductFgController,
  ProductPackController,
} from './controllers/product-shipping.controllers';
import { ProductFgService } from './services/product-fg.service';
import { ProductInventoryService } from './services/product-inventory.service';
import { ProductPackService } from './services/product-pack.service';

@Module({
  controllers: [
    ProductInventoryController,
    ProductPackController,
    ProductFgController,
  ],
  providers: [ProductInventoryService, ProductPackService, ProductFgService],
})
export class ProductInventoryModule {}

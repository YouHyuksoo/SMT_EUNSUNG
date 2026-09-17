import { Module } from '@nestjs/common';
import { ProductInventoryController } from './controllers/product-inventory.controller';
import { ProductInventoryService } from './services/product-inventory.service';

@Module({
  controllers: [ProductInventoryController],
  providers: [ProductInventoryService],
})
export class ProductInventoryModule {}

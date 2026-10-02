import { Module } from '@nestjs/common';
import { ProductDestroyController } from './controllers/product-destroy.controller';
import { ProductDestroyService } from './services/product-destroy.service';

@Module({
  controllers: [ProductDestroyController],
  providers: [ProductDestroyService],
})
export class QualityProductDestroyModule {}

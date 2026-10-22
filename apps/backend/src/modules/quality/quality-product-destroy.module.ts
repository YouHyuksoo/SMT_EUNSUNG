import { Module } from '@nestjs/common';
import { LcrDestroyController } from './controllers/lcr-destroy.controller';
import { ProductDestroyController } from './controllers/product-destroy.controller';
import { LcrDestroyService } from './services/lcr-destroy.service';
import { ProductDestroyService } from './services/product-destroy.service';

@Module({
  controllers: [ProductDestroyController, LcrDestroyController],
  providers: [ProductDestroyService, LcrDestroyService],
})
export class QualityProductDestroyModule {}

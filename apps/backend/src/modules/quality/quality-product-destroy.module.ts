import { Module } from '@nestjs/common';
import { TransactionService } from '../../shared/transaction.service';
import { ProductDestroyController } from './controllers/product-destroy.controller';
import { ProductDestroyService } from './services/product-destroy.service';

@Module({
  controllers: [ProductDestroyController],
  providers: [ProductDestroyService, TransactionService],
})
export class QualityProductDestroyModule {}

import { Module } from '@nestjs/common';
import { TransactionService } from '../../shared/transaction.service';
import { ReceiptCancelController } from './controllers/receipt-cancel.controller';
import { ReceiptCancelService } from './services/receipt-cancel.service';

@Module({
  controllers: [ReceiptCancelController],
  providers: [ReceiptCancelService, TransactionService],
})
export class MaterialReceiptCancelModule {}

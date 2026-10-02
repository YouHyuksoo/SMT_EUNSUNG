import { Module } from '@nestjs/common';
import { ReceiptCancelController } from './controllers/receipt-cancel.controller';
import { ReceiptCancelService } from './services/receipt-cancel.service';

@Module({
  controllers: [ReceiptCancelController],
  providers: [ReceiptCancelService],
})
export class MaterialReceiptCancelModule {}

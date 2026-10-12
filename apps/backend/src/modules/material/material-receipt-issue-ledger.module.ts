import { Module } from '@nestjs/common';
import { ReceiptIssueLedgerController } from './controllers/receipt-issue-ledger.controller';
import { ReceiptIssueLedgerService } from './services/receipt-issue-ledger.service';

@Module({
  controllers: [ReceiptIssueLedgerController],
  providers: [ReceiptIssueLedgerService],
})
export class MaterialReceiptIssueLedgerModule {}

import { Module } from '@nestjs/common';
import { TransactionService } from '../../shared/transaction.service';
import { ReplaceBomController } from './controllers/replace-bom.controller';
import { ReplaceBomService } from './services/replace-bom.service';

@Module({
  controllers: [ReplaceBomController],
  providers: [ReplaceBomService, TransactionService],
})
export class BomModule {}

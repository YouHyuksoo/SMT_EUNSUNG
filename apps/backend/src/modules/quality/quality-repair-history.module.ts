import { Module } from '@nestjs/common';
import { RepairHistoryController } from './controllers/repair-history.controller';
import { RepairHistoryService } from './services/repair-history.service';

@Module({
  controllers: [RepairHistoryController],
  providers: [RepairHistoryService],
})
export class QualityRepairHistoryModule {}

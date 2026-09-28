import { Module } from '@nestjs/common';
import { RepairHistoryController } from './controllers/repair-history.controller';
import { RepairQueryController } from './controllers/repair-query.controller';
import { RepairHistoryService } from './services/repair-history.service';
import { RepairQueryService } from './services/repair-query.service';

@Module({
  controllers: [RepairHistoryController, RepairQueryController],
  providers: [RepairHistoryService, RepairQueryService],
})
export class QualityRepairHistoryModule {}

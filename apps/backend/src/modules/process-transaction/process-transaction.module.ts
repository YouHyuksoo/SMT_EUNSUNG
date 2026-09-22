import { Module } from '@nestjs/common';
import { MagazineLabelHistoryController } from './magazine-label-history.controller';
import { MagazineLabelHistoryService } from './magazine-label-history.service';
import { WorkstagePassController } from './workstage-pass.controller';
import { WorkstagePassService } from './workstage-pass.service';

@Module({
  controllers: [MagazineLabelHistoryController, WorkstagePassController],
  providers: [MagazineLabelHistoryService, WorkstagePassService],
})
export class ProcessTransactionModule {}

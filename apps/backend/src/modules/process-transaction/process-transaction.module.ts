import { Module } from '@nestjs/common';
import { MagazineLabelHistoryController } from './magazine-label-history.controller';
import { MagazineLabelHistoryService } from './magazine-label-history.service';
import { MagazineLabelService } from './magazine-label.service';
import { MagazinePidService } from './magazine-pid.service';
import { MagazineSplitService } from './magazine-split.service';
import {
  MagazineLabelController,
  MagazinePidController,
  MagazineSplitController,
} from './magazine.controllers';
import { WorkstagePassController } from './workstage-pass.controller';
import { WorkstagePassService } from './workstage-pass.service';

@Module({
  controllers: [
    MagazineLabelHistoryController,
    WorkstagePassController,
    MagazineLabelController,
    MagazineSplitController,
    MagazinePidController,
  ],
  providers: [
    MagazineLabelHistoryService,
    WorkstagePassService,
    MagazineLabelService,
    MagazineSplitService,
    MagazinePidService,
  ],
})
export class ProcessTransactionModule {}

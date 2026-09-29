import { Module } from '@nestjs/common';
import { JigCheckController } from './jig-check.controller';
import { JigCheckService } from './jig-check.service';
import { JigCleanCheckService } from './jig-clean-check.service';
import { JigHistoryController } from './jig-history.controller';
import { JigHistoryService } from './jig-history.service';
import { JigMasterController } from './jig-master.controller';
import { JigMasterService } from './jig-master.service';
import {
  JigCleanCheckController,
  JigRepairRequestController,
} from './jig-repair-request.controller';
import { JigRepairRequestService } from './jig-repair-request.service';

@Module({
  controllers: [
    JigHistoryController,
    JigMasterController,
    JigCheckController,
    JigRepairRequestController,
    JigCleanCheckController,
  ],
  providers: [
    JigHistoryService,
    JigMasterService,
    JigCheckService,
    JigRepairRequestService,
    JigCleanCheckService,
  ],
})
export class JigModule {}

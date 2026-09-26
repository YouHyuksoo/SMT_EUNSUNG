import { Module } from '@nestjs/common';
import { JigCheckController } from './jig-check.controller';
import { JigCheckService } from './jig-check.service';
import { JigHistoryController } from './jig-history.controller';
import { JigHistoryService } from './jig-history.service';
import { JigMasterController } from './jig-master.controller';
import { JigMasterService } from './jig-master.service';

@Module({
  controllers: [JigHistoryController, JigMasterController, JigCheckController],
  providers: [JigHistoryService, JigMasterService, JigCheckService],
})
export class JigModule {}

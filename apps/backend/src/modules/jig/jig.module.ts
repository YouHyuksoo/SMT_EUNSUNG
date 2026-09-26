import { Module } from '@nestjs/common';
import { JigHistoryController } from './jig-history.controller';
import { JigHistoryService } from './jig-history.service';
import { JigMasterController } from './jig-master.controller';
import { JigMasterService } from './jig-master.service';

@Module({
  controllers: [JigHistoryController, JigMasterController],
  providers: [JigHistoryService, JigMasterService],
})
export class JigModule {}

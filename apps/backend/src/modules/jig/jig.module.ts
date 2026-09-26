import { Module } from '@nestjs/common';
import { JigHistoryController } from './jig-history.controller';
import { JigHistoryService } from './jig-history.service';

@Module({
  controllers: [JigHistoryController],
  providers: [JigHistoryService],
})
export class JigModule {}

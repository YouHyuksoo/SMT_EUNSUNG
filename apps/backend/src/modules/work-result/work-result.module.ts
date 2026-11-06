// 설비별 작업 실적관리 모듈
import { Module } from '@nestjs/common';
import { WorkResultController } from './work-result.controller';
import { WorkResultFreeController } from './work-result-free.controller';
import { WorkResultFreeService } from './work-result-free.service';
import { WorkResultService } from './work-result.service';

@Module({
  controllers: [WorkResultController, WorkResultFreeController],
  providers: [WorkResultService, WorkResultFreeService],
})
export class WorkResultModule {}

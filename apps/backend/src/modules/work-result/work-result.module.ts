// 설비별 작업 실적관리 모듈
import { Module } from '@nestjs/common';
import { WorkResultController } from './work-result.controller';
import { WorkResultService } from './work-result.service';

@Module({
  controllers: [WorkResultController],
  providers: [WorkResultService],
})
export class WorkResultModule {}

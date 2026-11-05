// 설비별 검사실적관리 모듈 — 원장 IQ_EQUIP_INSPECT_RESULT
import { Module } from '@nestjs/common';
import { InspectResultFreeController } from './inspect-result-free.controller';
import { InspectResultFreeService } from './inspect-result-free.service';
import { InspectResultController } from './inspect-result.controller';
import { InspectResultService } from './inspect-result.service';

@Module({
  controllers: [InspectResultController, InspectResultFreeController],
  providers: [InspectResultService, InspectResultFreeService],
})
export class InspectResultModule {}

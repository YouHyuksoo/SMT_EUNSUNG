// 설비별 검사실적관리 모듈 — 원장 IQ_EQUIP_INSPECT_RESULT
import { Module } from '@nestjs/common';
import { InspectResultController } from './inspect-result.controller';
import { InspectResultService } from './inspect-result.service';

@Module({
  controllers: [InspectResultController],
  providers: [InspectResultService],
})
export class InspectResultModule {}

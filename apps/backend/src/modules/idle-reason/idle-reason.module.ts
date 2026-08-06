// 설비 비가동 사유코드 관리 모듈
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EquipDowntimeReason } from '../../entities/equip-downtime-reason.entity';
import { IdleReasonController } from './idle-reason.controller';
import { IdleReasonService } from './idle-reason.service';

@Module({
  imports: [TypeOrmModule.forFeature([EquipDowntimeReason])],
  controllers: [IdleReasonController],
  providers: [IdleReasonService],
})
export class IdleReasonModule {}

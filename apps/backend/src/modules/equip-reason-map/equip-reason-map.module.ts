// 설비별 비가동 사유 연계 모듈
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EquipDowntimeMap } from '../../entities/equip-downtime-map.entity';
import { EquipReasonMapController } from './equip-reason-map.controller';
import { EquipReasonMapService } from './equip-reason-map.service';

@Module({
  imports: [TypeOrmModule.forFeature([EquipDowntimeMap])],
  controllers: [EquipReasonMapController],
  providers: [EquipReasonMapService],
})
export class EquipReasonMapModule {}

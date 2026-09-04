// 설비 운영 현황 모듈
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EquipDowntimeResult } from '../../entities/equip-downtime-result.entity';
import { EquipOpsController } from './equip-ops.controller';
import { EquipOpsService } from './equip-ops.service';

@Module({
  imports: [TypeOrmModule.forFeature([EquipDowntimeResult])],
  controllers: [EquipOpsController],
  providers: [EquipOpsService],
})
export class EquipOpsModule {}

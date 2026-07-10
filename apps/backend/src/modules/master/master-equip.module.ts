/**
 * @file src/modules/master/master-equip.module.ts
 * @description 은성전장 설비정보 API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EquipMaster } from '../../entities/equip-master.entity';
import { EquipMasterController } from '../equipment/controllers/equip-master.controller';
import { EquipMasterService } from '../equipment/services/equip-master.service';

@Module({
  imports: [TypeOrmModule.forFeature([EquipMaster])],
  controllers: [EquipMasterController],
  providers: [EquipMasterService],
  exports: [EquipMasterService],
})
export class MasterEquipModule {}

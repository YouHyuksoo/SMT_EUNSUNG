/**
 * @file src/modules/master/master-process.module.ts
 * @description 은성전장 공정마스터 API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProcessMaster } from '../../entities/process-master.entity';
import { EquipMaster } from '../../entities/equip-master.entity';
import { ProcessEquipment } from '../../entities/process-equipment.entity';
import { ProcessController } from './controllers/process.controller';
import { ProcessService } from './services/process.service';

@Module({
  imports: [TypeOrmModule.forFeature([ProcessMaster, EquipMaster, ProcessEquipment])],
  controllers: [ProcessController],
  providers: [ProcessService],
  exports: [ProcessService],
})
export class MasterProcessModule {}

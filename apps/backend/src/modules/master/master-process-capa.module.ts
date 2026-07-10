/**
 * @file src/modules/master/master-process-capa.module.ts
 * @description 은성전장 공정 CAPA API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProcessCapa } from '../../entities/process-capa.entity';
import { ProcessMaster } from '../../entities/process-master.entity';
import { ItemMaster } from '../../entities/item-master.entity';
import { ProcessCapaController } from './controllers/process-capa.controller';
import { ProcessCapaService } from './services/process-capa.service';

@Module({
  imports: [TypeOrmModule.forFeature([ProcessCapa, ProcessMaster, ItemMaster])],
  controllers: [ProcessCapaController],
  providers: [ProcessCapaService],
  exports: [ProcessCapaService],
})
export class MasterProcessCapaModule {}

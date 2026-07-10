/**
 * @file src/modules/master/master-bom.module.ts
 * @description 은성전장 BOM 정보 API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BomMaster } from '../../entities/bom-master.entity';
import { ItemMaster } from '../../entities/item-master.entity';
import { BomController } from './controllers/bom.controller';
import { BomService } from './services/bom.service';

@Module({
  imports: [TypeOrmModule.forFeature([BomMaster, ItemMaster])],
  controllers: [BomController],
  providers: [BomService],
  exports: [BomService],
})
export class MasterBomModule {}

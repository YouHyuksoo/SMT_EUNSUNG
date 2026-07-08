/**
 * @file src/modules/master/master-part.module.ts
 * @description 은성전장 품목정보 API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ItemMaster } from '../../entities/item-master.entity';
import { PartController } from './controllers/part.controller';
import { PartService } from './services/part.service';

@Module({
  imports: [TypeOrmModule.forFeature([ItemMaster])],
  controllers: [PartController],
  providers: [PartService],
  exports: [PartService],
})
export class MasterPartModule {}

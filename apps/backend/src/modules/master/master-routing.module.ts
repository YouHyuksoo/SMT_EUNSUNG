/**
 * @file src/modules/master/master-routing.module.ts
 * @description 은성전장 공정라우팅(ProcessMap) API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProcessMap } from '../../entities/process-map.entity';
import { ItemMaster } from '../../entities/item-master.entity';
import { RoutingController } from './controllers/routing.controller';
import { RoutingService } from './services/routing.service';

@Module({
  imports: [TypeOrmModule.forFeature([ProcessMap, ItemMaster])],
  controllers: [RoutingController],
  providers: [RoutingService],
  exports: [RoutingService],
})
export class MasterRoutingModule {}

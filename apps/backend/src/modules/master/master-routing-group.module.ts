/**
 * @file src/modules/master/master-routing-group.module.ts
 * @description 은성전장 라우팅 그룹(공정순서/투입자재) API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { RoutingGroup } from '../../entities/routing-group.entity';
import { RoutingProcess } from '../../entities/routing-process.entity';
import { ProcessMaster } from '../../entities/process-master.entity';
import { ItemMaster } from '../../entities/item-master.entity';
import { BomMaster } from '../../entities/bom-master.entity';
import { RoutingMaterial } from '../../entities/routing-material.entity';
import { SupplierMaster } from '../../entities/supplier-master.entity';
import { RoutingGroupController } from './controllers/routing-group.controller';
import { RoutingGroupService } from './services/routing-group.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      RoutingGroup,
      RoutingProcess,
      ProcessMaster,
      ItemMaster,
      BomMaster,
      RoutingMaterial,
      SupplierMaster,
    ]),
  ],
  controllers: [RoutingGroupController],
  providers: [RoutingGroupService],
  exports: [RoutingGroupService],
})
export class MasterRoutingGroupModule {}

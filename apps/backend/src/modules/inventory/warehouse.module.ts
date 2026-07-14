/**
 * @file src/modules/inventory/warehouse.module.ts
 * @description 은성전장 창고/로케이션 API만 활성화하는 좁은 모듈.
 *              재고·수불 API(InventoryController)는 은성화 전이라 등록하지 않는다.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Warehouse } from '../../entities/warehouse.entity';
import { WarehouseLocation } from '../../entities/warehouse-location.entity';
import { WarehouseController } from './controllers/warehouse.controller';
import { WarehouseLocationController } from './controllers/warehouse-location.controller';
import { WarehouseService } from './services/warehouse.service';
import { WarehouseLocationService } from './services/warehouse-location.service';

@Module({
  imports: [TypeOrmModule.forFeature([Warehouse, WarehouseLocation])],
  controllers: [WarehouseController, WarehouseLocationController],
  providers: [WarehouseService, WarehouseLocationService],
  exports: [WarehouseService, WarehouseLocationService],
})
export class WarehouseModule {}

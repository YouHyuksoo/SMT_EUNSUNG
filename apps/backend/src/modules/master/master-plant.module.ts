/**
 * @file src/modules/master/master-plant.module.ts
 * @description 실제 PLANTS 스키마 기반 공장/작업장/라인/CELL API 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Plant } from '../../entities/plant.entity';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { PlantController } from './controllers/plant.controller';
import { PlantService } from './services/plant.service';

@Module({
  imports: [TypeOrmModule.forFeature([Plant])],
  controllers: [PlantController],
  providers: [PlantService, JwtAuthGuard],
  exports: [PlantService],
})
export class MasterPlantModule {}

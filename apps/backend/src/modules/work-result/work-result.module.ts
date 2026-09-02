// 설비별 작업 실적관리 모듈
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductSensorActual } from '../../entities/product-sensor-actual.entity';
import { WorkResultController } from './work-result.controller';
import { WorkResultService } from './work-result.service';

@Module({
  imports: [TypeOrmModule.forFeature([ProductSensorActual])],
  controllers: [WorkResultController],
  providers: [WorkResultService],
})
export class WorkResultModule {}

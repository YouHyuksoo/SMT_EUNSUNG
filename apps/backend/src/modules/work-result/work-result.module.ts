// 설비별 작업 실적관리 모듈
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductWorkResult } from '../../entities/product-work-result.entity';
import { WorkResultController } from './work-result.controller';
import { WorkResultService } from './work-result.service';

@Module({
  imports: [TypeOrmModule.forFeature([ProductWorkResult])],
  controllers: [WorkResultController],
  providers: [WorkResultService],
})
export class WorkResultModule {}

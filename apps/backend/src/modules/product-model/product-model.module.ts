// 제품 모델 마스터 모듈
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductModelMaster } from '../../entities/product-model-master.entity';
import { ProductModelController } from './product-model.controller';
import { ProductModelService } from './product-model.service';

@Module({
  imports: [TypeOrmModule.forFeature([ProductModelMaster])],
  controllers: [ProductModelController],
  providers: [ProductModelService],
})
export class ProductModelModule {}

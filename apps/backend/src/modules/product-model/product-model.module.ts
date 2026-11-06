// 제품 모델 마스터 모듈
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductModelMaster } from '../../entities/product-model-master.entity';
import { BomExplodeController } from './bom-explode.controller';
import { BomExplodeService } from './bom-explode.service';
import { ProductModelController } from './product-model.controller';
import { ProductModelService } from './product-model.service';

@Module({
  imports: [TypeOrmModule.forFeature([ProductModelMaster])],
  controllers: [BomExplodeController, ProductModelController],
  providers: [ProductModelService, BomExplodeService],
})
export class ProductModelModule {}

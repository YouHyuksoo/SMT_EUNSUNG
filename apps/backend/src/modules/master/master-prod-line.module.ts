/**
 * @file src/modules/master/master-prod-line.module.ts
 * @description 은성전장 생산라인정보 API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProdLineMaster } from '../../entities/prod-line-master.entity';
import { ProdLineController } from './controllers/prod-line.controller';
import { ProdLineService } from './services/prod-line.service';

@Module({
  imports: [TypeOrmModule.forFeature([ProdLineMaster])],
  controllers: [ProdLineController],
  providers: [ProdLineService],
  exports: [ProdLineService],
})
export class MasterProdLineModule {}

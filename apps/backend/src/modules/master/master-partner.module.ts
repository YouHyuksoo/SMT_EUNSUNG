/**
 * @file src/modules/master/master-partner.module.ts
 * @description 은성전장 거래처정보 API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PartnerMaster } from '../../entities/partner-master.entity';
import { PartnerController } from './controllers/partner.controller';
import { PartnerService } from './services/partner.service';

@Module({
  imports: [TypeOrmModule.forFeature([PartnerMaster])],
  controllers: [PartnerController],
  providers: [PartnerService],
  exports: [PartnerService],
})
export class MasterPartnerModule {}

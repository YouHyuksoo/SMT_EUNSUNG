/**
 * @file src/modules/master/master-company.module.ts
 * @description 은성전장 회사정보 API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { IsysOrganization } from '../../entities/isys-organization.entity';
import { CompanyController } from './controllers/company.controller';
import { CompanyService } from './services/company.service';

@Module({
  imports: [TypeOrmModule.forFeature([IsysOrganization])],
  controllers: [CompanyController],
  providers: [CompanyService],
  exports: [CompanyService],
})
export class MasterCompanyModule {}

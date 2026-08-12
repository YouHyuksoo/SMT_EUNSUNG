/**
 * @file src/modules/master/master-process.module.ts
 * @description 은성전장 공정마스터 API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProcessMaster } from '../../entities/process-master.entity';
import { ProcessLine } from '../../entities/process-line.entity';
import { DepartmentMaster } from '../../entities/department-master.entity';
import { ProdLineMaster } from '../../entities/prod-line-master.entity';
import { IsysUser } from '../../entities/isys-user.entity';
import { IsysOrganization } from '../../entities/isys-organization.entity';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { EquipMaster } from '../../entities/equip-master.entity';
import { ProcessController } from './controllers/process.controller';
import { ProcessService } from './services/process.service';

@Module({
  imports: [TypeOrmModule.forFeature([ProcessMaster, ProcessLine, EquipMaster, DepartmentMaster, ProdLineMaster, IsysUser, IsysOrganization])],
  controllers: [ProcessController],
  providers: [ProcessService, JwtAuthGuard],
  exports: [ProcessService],
})
export class MasterProcessModule {}

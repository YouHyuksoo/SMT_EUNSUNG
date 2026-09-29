/**
 * @file src/modules/master/master-equip.module.ts
 * @description 은성전장 설비정보 API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EquipMaster } from '../../entities/equip-master.entity';
import { ProdLineMaster } from '../../entities/prod-line-master.entity';
import { ProcessMaster } from '../../entities/process-master.entity';
import { IsysUser } from '../../entities/isys-user.entity';
import { IsysOrganization } from '../../entities/isys-organization.entity';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { EquipMasterController } from '../equipment/controllers/equip-master.controller';
import { EquipMasterService } from '../equipment/services/equip-master.service';
import { EquipmentResultQueryController } from '../equipment/controllers/equipment-result-query.controller';
import { EquipmentResultQueryService } from '../equipment/services/equipment-result-query.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      EquipMaster,
      ProdLineMaster,
      ProcessMaster,
      IsysUser,
      IsysOrganization,
    ]),
  ],
  controllers: [EquipMasterController, EquipmentResultQueryController],
  providers: [EquipMasterService, EquipmentResultQueryService, JwtAuthGuard],
  exports: [EquipMasterService],
})
export class MasterEquipModule {}

/**
 * @file src/modules/oee/oee.module.ts
 * @description OEE 입력 모듈 — 리소스/사유 마스터 + 가동일지.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { OeeResource } from '../../entities/oee-resource.entity';
import { OeeDowntimeReason } from '../../entities/oee-downtime-reason.entity';
import { OeeOperationLog } from '../../entities/oee-operation-log.entity';
import { OeeDowntimeEvent } from '../../entities/oee-downtime-event.entity';
import { WorktimeRange } from '../../entities/worktime-range.entity';
import { IsysUser } from '../../entities/isys-user.entity';
import { ComCode } from '../../entities/com-code.entity';
import { OeeController } from './oee.controller';
import { OeeMasterService } from './oee-master.service';
import { OeeLogService } from './oee-log.service';
import { OeeDashboardService } from './oee-dashboard.service';
import { ProdLineMaster } from '../../entities/prod-line-master.entity';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { OeeMobileController } from './oee-mobile.controller';
import { OeeMobileService } from './oee-mobile.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      OeeResource,
      OeeDowntimeReason,
      OeeOperationLog,
      OeeDowntimeEvent,
      WorktimeRange,
      IsysUser,
      ComCode,
      ProdLineMaster,
    ]),
  ],
  controllers: [OeeController, OeeMobileController],
  providers: [OeeMasterService, OeeLogService, OeeDashboardService, OeeMobileService, JwtAuthGuard],
})
export class OeeModule {}

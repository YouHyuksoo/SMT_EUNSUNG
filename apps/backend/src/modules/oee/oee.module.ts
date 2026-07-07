/**
 * @file src/modules/oee/oee.module.ts
 * @description OEE 입력 모듈 — 리소스/사유 마스터 + 가동일지.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { OeeResource } from '../../entities/oee-resource.entity';
import { OeeDowntimeReason } from '../../entities/oee-downtime-reason.entity';
import { OeeOperationLog } from '../../entities/oee-operation-log.entity';
import { OeeController } from './oee.controller';
import { OeeMasterService } from './oee-master.service';
import { OeeLogService } from './oee-log.service';

@Module({
  imports: [TypeOrmModule.forFeature([OeeResource, OeeDowntimeReason, OeeOperationLog])],
  controllers: [OeeController],
  providers: [OeeMasterService, OeeLogService],
})
export class OeeModule {}

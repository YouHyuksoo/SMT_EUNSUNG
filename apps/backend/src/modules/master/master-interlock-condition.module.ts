import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { IsysUser } from '../../entities/isys-user.entity';
import { IsysOrganization } from '../../entities/isys-organization.entity';
import { InterlockConditionController } from './controllers/interlock-condition.controller';
import { InterlockConditionService } from './services/interlock-condition.service';

@Module({ imports: [TypeOrmModule.forFeature([IsysUser, IsysOrganization])], controllers: [InterlockConditionController], providers: [InterlockConditionService] })
export class MasterInterlockConditionModule {}

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { IsysUser } from '../../entities/isys-user.entity';
import { IsysOrganization } from '../../entities/isys-organization.entity';
import { LabelFormController } from './controllers/label-form.controller';
import { LabelFormService } from './services/label-form.service';

@Module({ imports: [TypeOrmModule.forFeature([IsysUser, IsysOrganization])], controllers: [LabelFormController], providers: [LabelFormService] })
export class MasterLabelFormModule {}

/**
 * @file src/modules/master/master-label.module.ts
 * @description 은성전장 라벨 템플릿 API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { LabelTemplate } from '../../entities/label-template.entity';
import { LabelTemplateController } from './controllers/label-template.controller';
import { LabelTemplateService } from './services/label-template.service';

@Module({
  imports: [TypeOrmModule.forFeature([LabelTemplate])],
  controllers: [LabelTemplateController],
  providers: [LabelTemplateService],
  exports: [LabelTemplateService],
})
export class MasterLabelModule {}

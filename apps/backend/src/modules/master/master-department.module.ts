/**
 * @file src/modules/master/master-department.module.ts
 * @description 은성전장 시스템 부서 API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DepartmentMaster } from '../../entities/department-master.entity';
import { DepartmentController } from './controllers/department.controller';
import { DepartmentService } from './services/department.service';

@Module({
  imports: [TypeOrmModule.forFeature([DepartmentMaster])],
  controllers: [DepartmentController],
  providers: [DepartmentService],
  exports: [DepartmentService],
})
export class MasterDepartmentModule {}

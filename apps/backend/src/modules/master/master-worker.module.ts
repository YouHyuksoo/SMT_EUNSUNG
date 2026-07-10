/**
 * @file src/modules/master/master-worker.module.ts
 * @description 은성전장 작업자정보 API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { WorkerMaster } from '../../entities/worker-master.entity';
import { WorkerController } from './controllers/worker.controller';
import { WorkerService } from './services/worker.service';

@Module({
  imports: [TypeOrmModule.forFeature([WorkerMaster])],
  controllers: [WorkerController],
  providers: [WorkerService],
  exports: [WorkerService],
})
export class MasterWorkerModule {}

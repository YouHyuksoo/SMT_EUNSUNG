/**
 * @file src/modules/master/master-work-instruction.module.ts
 * @description 은성전장 작업지도서 API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { WorkInstruction } from '../../entities/work-instruction.entity';
import { WorkInstructionController } from './controllers/work-instruction.controller';
import { WorkInstructionService } from './services/work-instruction.service';

@Module({
  imports: [TypeOrmModule.forFeature([WorkInstruction])],
  controllers: [WorkInstructionController],
  providers: [WorkInstructionService],
  exports: [WorkInstructionService],
})
export class MasterWorkInstructionModule {}

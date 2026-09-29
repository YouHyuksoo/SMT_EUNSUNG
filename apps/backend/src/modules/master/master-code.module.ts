/**
 * @file src/modules/master/master-code.module.ts
 * @description 은성전장 기준정보 코드 API 모듈.
 *
 * 코드 체계가 두 개다: 공통코드(ISYS_BASECODE)와 코드마스터(ISYS_CODE_MASTER).
 * 어느 컬럼이 어느 쪽인지는 docs/database/pb-dddw-inventory.md 를 따른다.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ComCode } from '../../entities/com-code.entity';
import { CodeMasterController } from './controllers/code-master.controller';
import { ComCodeController } from './controllers/com-code.controller';
import { CodeMasterService } from './services/code-master.service';
import { ComCodeService } from './services/com-code.service';

@Module({
  imports: [TypeOrmModule.forFeature([ComCode])],
  controllers: [ComCodeController, CodeMasterController],
  providers: [ComCodeService, CodeMasterService],
  exports: [ComCodeService, CodeMasterService],
})
export class MasterCodeModule {}

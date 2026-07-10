/**
 * @file src/modules/master/master-code.module.ts
 * @description 은성전장 기준정보 공통코드 API만 활성화하는 좁은 모듈.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ComCode } from '../../entities/com-code.entity';
import { ComCodeController } from './controllers/com-code.controller';
import { ComCodeService } from './services/com-code.service';

@Module({
  imports: [TypeOrmModule.forFeature([ComCode])],
  controllers: [ComCodeController],
  providers: [ComCodeService],
  exports: [ComCodeService],
})
export class MasterCodeModule {}

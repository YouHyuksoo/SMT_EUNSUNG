// 조립실적(생산실적) 모듈 — 수기 작업실적·SMD실적 수정·보정 화면이 함께 쓴다
import { Module } from '@nestjs/common';
import { AssemblyResultController } from './assembly-result.controller';
import { AssemblyResultService } from './assembly-result.service';

@Module({
  controllers: [AssemblyResultController],
  providers: [AssemblyResultService],
  exports: [AssemblyResultService],
})
export class AssemblyResultModule {}

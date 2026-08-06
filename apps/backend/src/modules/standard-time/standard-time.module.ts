// 표준시간 관리 모듈
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductStMaster } from '../../entities/product-st-master.entity';
import { StandardTimeController } from './standard-time.controller';
import { StandardTimeService } from './standard-time.service';

@Module({
  imports: [TypeOrmModule.forFeature([ProductStMaster])],
  controllers: [StandardTimeController],
  providers: [StandardTimeService],
})
export class StandardTimeModule {}

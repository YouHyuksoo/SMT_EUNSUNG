// 작업지시관리 모듈
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductRunCard } from '../../entities/product-run-card.entity';
import { RunCardController } from './run-card.controller';
import { RunCardService } from './run-card.service';

@Module({
  imports: [TypeOrmModule.forFeature([ProductRunCard])],
  controllers: [RunCardController],
  providers: [RunCardService],
})
export class RunCardModule {}

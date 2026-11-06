// 작업지시관리 모듈
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductRunCard } from '../../entities/product-run-card.entity';
import { LotCardController } from './lot-card.controller';
import { LotCardService } from './lot-card.service';
import { RunCardController } from './run-card.controller';
import { RunCardService } from './run-card.service';

@Module({
  imports: [TypeOrmModule.forFeature([ProductRunCard])],
  controllers: [RunCardController, LotCardController],
  providers: [RunCardService, LotCardService],
})
export class RunCardModule {}

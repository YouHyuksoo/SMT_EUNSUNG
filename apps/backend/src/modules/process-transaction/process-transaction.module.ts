import { Module } from '@nestjs/common';
import { MagazineLabelHistoryController } from './magazine-label-history.controller';
import { MagazineLabelHistoryService } from './magazine-label-history.service';

@Module({ controllers: [MagazineLabelHistoryController], providers: [MagazineLabelHistoryService] })
export class ProcessTransactionModule {}

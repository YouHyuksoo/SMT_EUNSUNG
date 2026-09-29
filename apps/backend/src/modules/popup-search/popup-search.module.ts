/**
 * @file src/modules/popup-search/popup-search.module.ts
 * @description 공용 팝업조회 모듈 (PB 팝업 카탈로그의 엔진 설정형 팝업이 쓴다)
 */
import { Module } from '@nestjs/common';
import { PopupSearchController } from './controllers/popup-search.controller';
import { PopupSearchService } from './services/popup-search.service';

@Module({
  controllers: [PopupSearchController],
  providers: [PopupSearchService],
})
export class PopupSearchModule {}

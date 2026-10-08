/**
 * @file src/modules/monitoring/monitoring.module.ts
 * @description 모니터링 모듈 — 현장 TV/사이니지 보드용 읽기전용 집계 API
 *
 * 초보자 가이드:
 * 1. 보드 4종(생산/품질/재고/설비) 집계 서비스로 구성 — 쓰기 API 없음
 * 2. 서비스는 dashboard.service.ts 와 같이 DataSource 로 은성 테이블을 직접 조회한다
 * 3. 작업지시(job-order) 칸반 보드는 생산 보드 API(production)의 orders 를 프론트에서 재사용한다
 */
import { Module } from '@nestjs/common';
import { MonitoringBoardController } from './controllers/monitoring-board.controller';
import { ProductionBoardService } from './services/production-board.service';
import { QualityBoardService } from './services/quality-board.service';
import { InventoryBoardService } from './services/inventory-board.service';
import { EquipmentBoardService } from './services/equipment-board.service';

@Module({
  controllers: [MonitoringBoardController],
  providers: [ProductionBoardService, QualityBoardService, InventoryBoardService, EquipmentBoardService],
})
export class MonitoringModule {}
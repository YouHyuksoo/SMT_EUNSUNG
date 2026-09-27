/**
 * @file src/modules/tracking/tracking.module.ts
 * @description 추적(M_TRACKING) 대분류 — PB 이관 모듈
 *
 * 화면 ↔ 서비스 대응 (PB 메뉴 순번 · MENU_ITEM_TEXT):
 *   313 자재 제조번호 기준 추적  w_product_pid_tracking_rpt          → MaterialTrackingService
 *   314 자재추적조회(동적)       w_product_material_tracking_rpt     → MaterialTrackingService
 *   315 자재사용이력조회         w_product_material_tracking_msl_rpt → MaterialTrackingService
 *   317 생산이력조회(PID)        w_product_pid_tracking_fpcb_rpt     → PidTrackingService
 *   318 생산이력조회(Run No)     w_pln_product_barcode_tracking      → PidTrackingService
 *   319 롯트추적조회(ALL)        w_pln_product_all_barcode_tracking  → PidTrackingService
 *   321 생산현황데쉬보드         w_com_production_status_dashboard   → LineDashboardService
 *
 * 316·320 은 PB 메뉴에 없다 (순번만 비어 있다).
 *
 * 321 은 트랙 A(업무화면)다 — Timer 자동갱신만 보면 display 같지만 NSNP 잠금이라는
 * 쓰기 동작과 사용자 레벨 가드가 있고, PB 메뉴(M_PRODUCTIONSTATUSDASHBOARD)에
 * 등록된 화면이다. display 셸에는 로그인 사용자 맥락이 없어 잠금을 걸 수 없다.
 */
import { Module } from '@nestjs/common';
import { LineDashboardService } from './line-dashboard.service';
import { MaterialTrackingService } from './material-tracking.service';
import { PidTrackingService } from './pid-tracking.service';
import {
  LineDashboardController,
  MaterialTrackingController,
  PidTrackingController,
} from './tracking.controllers';

@Module({
  controllers: [MaterialTrackingController, PidTrackingController, LineDashboardController],
  providers: [MaterialTrackingService, PidTrackingService, LineDashboardService],
})
export class TrackingModule {}

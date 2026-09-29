/**
 * @file src/modules/query/query.module.ts
 * @description 조회(M_QUERY) 대분류 — PB 이관 모듈
 *
 * 화면 ↔ 서비스 대응 (PB 메뉴 순번 · MENU_ITEM_TEXT):
 *   323 PID 정보조회              w_pln_product_barcode_query          → PidQueryService
 *   324 마킹이력조회              w_pln_product_pcb_marking_query      → PidQueryService
 *   325 PCB 투입 리스트조회       w_qc_pcb_input_scan_master           → PidQueryService
 *   327 SMT 오장착 스캔 현황 조회 w_pln_product_pda_scan_query         → SmtCheckQueryService
 *   328 PDA 검사오류내역조회      w_smt_plan_ng_check_master           → SmtCheckQueryService
 *   329 SMT 피더별 모니터링       w_smt_plan_feeder_monitoring_master   → FeederMonitorService
 *   330 SMT 제품실적센서이력조회  w_pln_product_sensor_actual_master    → SensorActualService
 *   333 자재 바코드 상태 조회     w_mat_barcode_status_report          → SensorActualService
 *   335 NSNP 처리이력조회         w_pln_product_nsnp_history_query      → NsnpHistoryService
 *
 * 326·334 는 PB 메뉴의 구분선('-')이고 화면이 아니다.
 * 331 마스크검사이력조회 · 332 스퀴지검사이력조회는 이미 이관된
 * /jig/mask-check · /jig/squeeze-check 가 같은 표를 같은 조건으로 본다 —
 * 새 라우트를 만들지 않고 menuConfig 의 pbAlsoCovers 로 연결했다.
 *
 * **이 대분류는 이름과 달리 절반이 쓰기 화면이다.** 무엇이 쓰기인지는
 * query.dto.ts 와 각 서비스 주석에 적었다.
 *
 * NSNP 제어(잠금·해제·사용·미사용·이력초기화)는 TrackingModule 의 NsnpControlService
 * 하나를 쓴다 — 321 생산현황데쉬보드·329·335 세 화면이 같은 동작이다.
 */
import { Module } from '@nestjs/common';
import { TrackingModule } from '../tracking/tracking.module';
import { FeederMonitorService } from './feeder-monitor.service';
import { NsnpHistoryService } from './nsnp-history.service';
import { PidQueryService } from './pid-query.service';
import {
  FeederMonitorController,
  MarkingQueryController,
  MaterialBarcodeController,
  NsnpHistoryController,
  PcbInputQueryController,
  PdaNgQueryController,
  PdaScanQueryController,
  PidInfoController,
  SensorActualController,
} from './query.controllers';
import { SensorActualService } from './sensor-actual.service';
import { SmtCheckQueryService } from './smt-check-query.service';

@Module({
  imports: [TrackingModule],
  controllers: [
    PidInfoController,
    MarkingQueryController,
    PcbInputQueryController,
    PdaScanQueryController,
    PdaNgQueryController,
    FeederMonitorController,
    SensorActualController,
    MaterialBarcodeController,
    NsnpHistoryController,
  ],
  providers: [
    PidQueryService,
    SmtCheckQueryService,
    FeederMonitorService,
    SensorActualService,
    NsnpHistoryService,
  ],
})
export class QueryModule {}

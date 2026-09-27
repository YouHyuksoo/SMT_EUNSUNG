/**
 * @file src/modules/report/report.module.ts
 * @description 리포트(M_REPORT) 대분류 — PB 이관 모듈 (A: 기준정보·바코드·설비·제품·공정)
 *
 * 화면 ↔ 서비스 대응 (PB 메뉴 순번 · MENU_ITEM_TEXT):
 *   338 품목마스터리포트      w_des_item_master_rpt                    → MasterReportService
 *   340 라인설비바코드        w_pln_line_barcode_rpt                   → MasterReportService
 *   341 캐리어바코드          w_product_carrier_barcode                → CarrierBarcodeService
 *   343 설비리포트            w_mcn_machine_rpt                        → MasterReportService
 *   344 SMT PICKUP 리포트     w_smt_pickup_rate_rpt                    → ProductionReportService
 *   346 생산계획리포트        w_pln_master_plan_rpt                    → ProductionReportService
 *   347 런카드리포트          w_product_run_card_rpt                   → ProductionReportService
 *   348 제품 판매실적         w_prd_product_fg_issue_rpt               → ProductionReportService
 *   350 공정재공조회          w_product_workstage_stock_rpt            → ProductionReportService
 *   352 공정매거진조회        w_product_workstage_magazine_stock_rpt   → ProductionReportService
 *
 * 339·342·345·349·353·359·361 은 PB 메뉴의 소그룹 머리이고 화면이 아니다.
 * 351·356 은 구분선('-')이다.
 *
 * **341 은 리포트가 아니라 바코드 발행 화면이다** — 라벨 레이아웃을 갖고 있어
 * 인쇄물처럼 보이지만 IP_PRODUCT_CARRIER_BARCODE 에 바코드를 새로 넣는다.
 *
 * **라벨·카드 레이아웃은 이관 대상이 아니다.** d_line_barcode_rpt ·
 * d_smt_feeder_location_barcode · d_carrier_label_qr_report_20x8 ·
 * d_mcn_machine_barcode_rpt · d_mcn_machine_card_rpt 는 인쇄 지오메트리다
 * (용지 여백·칸 간격·글꼴). 목록은 옮기고 라벨은 CSV 로 내보낸다.
 */
import { Module } from '@nestjs/common';
import { CarrierBarcodeService } from './carrier-barcode.service';
import { MasterReportService } from './master-report.service';
import { ProductionReportService } from './production-report.service';
import {
  CarrierBarcodeController,
  FgIssueReportController,
  ItemMasterReportController,
  LineBarcodeReportController,
  MachineReportController,
  MagazineStockReportController,
  MasterPlanReportController,
  PickupRateReportController,
  RunCardReportController,
  WorkstageStockReportController,
} from './report.controllers';

@Module({
  controllers: [
    ItemMasterReportController,
    LineBarcodeReportController,
    CarrierBarcodeController,
    MachineReportController,
    PickupRateReportController,
    MasterPlanReportController,
    RunCardReportController,
    FgIssueReportController,
    WorkstageStockReportController,
    MagazineStockReportController,
  ],
  providers: [MasterReportService, CarrierBarcodeService, ProductionReportService],
})
export class ReportModule {}

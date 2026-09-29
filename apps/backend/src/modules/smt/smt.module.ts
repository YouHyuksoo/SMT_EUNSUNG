/**
 * @file src/modules/smt/smt.module.ts
 * @description SMT(M_SMT) 대분류 9화면 — PB 이관 모듈
 *
 * 화면 ↔ 컨트롤러 대응:
 *   SMT 라인관리            w_smt_line_master                → SmtLineController
 *   라인별 테이블 관리       w_smt_location_master            → SmtLocationController
 *   SMT BOM 대체관리         w_smt_bom_replace_master         → SmtBomReplaceController
 *   SMT BOM 관리 / 리포트    w_smt_bom_create_master
 *                            w_smt_bom_master_rpt             → SmtBomController
 *   SMT 계획배포관리          w_smt_plan_master                → SmtPlanController
 *   피더레이아웃 비교         w_smt_bom_comparison_master_rpt  → SmtComparisonController
 *   SMT 피더레이아웃 등록     w_smt_upload_nc_master (부분)    → SmtNcController
 *   마운터 픽업정보관리       w_mcn_feeder_pickup_master       → SmtPickupController
 */
import { Module } from '@nestjs/common';
import { SmtBomReplaceController } from './smt-bom-replace.controller';
import { SmtBomReplaceService } from './smt-bom-replace.service';
import { SmtBomController } from './smt-bom.controller';
import { SmtBomService } from './smt-bom.service';
import { SmtComparisonController } from './smt-comparison.controller';
import { SmtComparisonService } from './smt-comparison.service';
import { SmtLineController } from './smt-line.controller';
import { SmtLineService } from './smt-line.service';
import { SmtLocationController } from './smt-location.controller';
import { SmtLocationService } from './smt-location.service';
import { SmtNcController } from './smt-nc.controller';
import { SmtNcService } from './smt-nc.service';
import { SmtPickupController } from './smt-pickup.controller';
import { SmtPickupService } from './smt-pickup.service';
import { SmtPlanController } from './smt-plan.controller';
import { SmtPlanService } from './smt-plan.service';

@Module({
  controllers: [
    SmtLineController,
    SmtLocationController,
    SmtBomReplaceController,
    SmtBomController,
    SmtPlanController,
    SmtComparisonController,
    SmtNcController,
    SmtPickupController,
  ],
  providers: [
    SmtLineService,
    SmtLocationService,
    SmtBomReplaceService,
    SmtBomService,
    SmtPlanService,
    SmtComparisonService,
    SmtNcService,
    SmtPickupService,
  ],
})
export class SmtModule {}

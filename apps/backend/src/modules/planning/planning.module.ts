/**
 * @file src/modules/planning/planning.module.ts
 * @description 생산(M_PLANNING) 대분류 — PB 이관 모듈
 *
 * 화면 ↔ 컨트롤러 대응:
 *   제품생산계획           w_pln_product_master_plan_master       → MasterPlanController
 *   반제품생산계획          w_pln_assembly_master_plan_master      → SmdPlanController
 *   반제품생산실적관리       w_pln_assembly_actual_master           → SmdActualController
 *   롯트카드-PID 매핑관리    w_pln_product_pcb_kitting_scan_master  → KittingController
 *   기간별 생산실적 조회     w_pln_product_pcb_result_query         → ResultController
 *   생산일보 리포트          w_pln_product_pcb_result_report        → ResultController
 *
 * 롯트카드관리(w_product_run_card_duckil)는 기존 run-card 모듈에 이미 있다.
 * 이 배치에서는 강제삭제(연쇄) 경로만 그쪽에 더했다.
 *
 * 두 계획 화면은 PlanBaseService 하나를 공유한다 — 테이블만 다르고 키·시간대·
 * 확정처리가 같아서, 규칙을 두 곳에 복붙하면 한쪽만 고쳐지는 일이 생긴다.
 */
import { Module } from '@nestjs/common';
import { KittingController } from './kitting.controller';
import { KittingService } from './kitting.service';
import { MasterPlanController } from './master-plan.controller';
import { PlanBaseService } from './plan-base.service';
import { ResultController } from './result.controller';
import { ResultService } from './result.service';
import { SmdActualController } from './smd-actual.controller';
import { SmdActualService } from './smd-actual.service';
import { SmdPlanController } from './smd-plan.controller';

@Module({
  controllers: [
    MasterPlanController,
    SmdPlanController,
    SmdActualController,
    KittingController,
    ResultController,
  ],
  providers: [PlanBaseService, SmdActualService, KittingService, ResultService],
})
export class PlanningModule {}

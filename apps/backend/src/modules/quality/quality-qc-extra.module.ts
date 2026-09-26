import { Module } from '@nestjs/common';
import { Qc4mController } from './controllers/qc-4m.controller';
import { TemperatureController } from './controllers/temperature.controller';
import { WqcController } from './controllers/wqc.controller';
import { Qc4mService } from './services/qc-4m.service';
import { TemperatureService } from './services/temperature.service';
import { WqcService } from './services/wqc.service';

/**
 * 품질관리 — 4M 이력 / 공정품질검사이력 / 온도상태.
 * PB w_qc_4m_master · w_qc_workstage_inspect_data_master_es ·
 * w_pln_product_tempreture_history_query
 */
@Module({
  controllers: [Qc4mController, WqcController, TemperatureController],
  providers: [Qc4mService, WqcService, TemperatureService],
})
export class QualityQcExtraModule {}

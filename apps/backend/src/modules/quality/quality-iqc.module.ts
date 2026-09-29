import { Module } from '@nestjs/common';
import { IqcController } from './controllers/iqc.controller';
import { IqcService } from './services/iqc.service';

/** IQC 관리 — PB w_qc_iqc_master */
@Module({
  controllers: [IqcController],
  providers: [IqcService],
})
export class QualityIqcModule {}

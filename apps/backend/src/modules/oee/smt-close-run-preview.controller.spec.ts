import 'reflect-metadata';
import { RequestMethod } from '@nestjs/common';
import {
  GUARDS_METADATA,
  METHOD_METADATA,
  PATH_METADATA,
} from '@nestjs/common/constants';
import { OeeController } from './oee.controller';
import { OeeDashboardService } from './oee-dashboard.service';
import { OeeLogService } from './oee-log.service';
import { OeeMasterService } from './oee-master.service';
import { SmtCloseRunPreviewService } from './smt-close-run-preview.service';
import { SmtCloseRunPreviewQueryDto } from './smt-close-run-preview.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';

describe('OeeController SMT close-run preview', () => {
  const master = {} as OeeMasterService;
  const log = {} as OeeLogService;
  const dashboard = {} as OeeDashboardService;
  const sourcePreview = {
    preview: jest.fn().mockResolvedValue({ status: 'SOURCE_VALID' }),
  };

  it('is an authenticated GET preview route and has no organization query contract', () => {
    expect(Reflect.getMetadata(GUARDS_METADATA, OeeController) ?? []).toContain(
      JwtAuthGuard,
    );
    expect(
      Reflect.getMetadata(
        PATH_METADATA,
        OeeController.prototype.previewSmtCloseRun,
      ),
    ).toBe('smt-close-run/preview');
    expect(
      Reflect.getMetadata(
        METHOD_METADATA,
        OeeController.prototype.previewSmtCloseRun,
      ),
    ).toBe(RequestMethod.GET);
  });

  it('forwards only the DTO and authenticated organization ID', async () => {
    const target = new OeeController(
      master,
      log,
      dashboard,
      sourcePreview as unknown as SmtCloseRunPreviewService,
    );
    const query = {
      runNo: 'RUN-1',
      ctDate: '2026-08-24',
      organizationId: 999,
    } as unknown as SmtCloseRunPreviewQueryDto;

    await target.previewSmtCloseRun(query, 7);

    expect(sourcePreview.preview).toHaveBeenCalledWith(query, 7);
  });
});

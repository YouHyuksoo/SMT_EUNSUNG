import { OracleService } from '../../../common/services/oracle.service';
import { SchedulerJob } from '../../../entities/scheduler-job.entity';
import { ProcedureExecutor } from './procedure.executor';

describe('ProcedureExecutor', () => {
  let oracleService: jest.Mocked<Pick<OracleService, 'callProc'>>;
  let executor: ProcedureExecutor;

  const baseJob = {
    organizationId: 1,
    jobCode: 'PROC_JOB',
    execType: 'PROCEDURE',
    execTarget: 'PKG_TEST.SP_RUN',
    execParams: null,
  } as SchedulerJob;

  beforeEach(() => {
    oracleService = {
      callProc: jest.fn().mockResolvedValue([{ ok: 1 }]),
    };
    executor = new ProcedureExecutor(oracleService as unknown as OracleService);
  });

  it('should not add tenant params when procedure job has no tenant params', async () => {
    await executor.execute(baseJob);

    expect(oracleService.callProc).toHaveBeenCalledWith('PKG_TEST', 'SP_RUN', undefined);
  });

  it('should override tenant params with scheduler job tenant', async () => {
    await executor.execute({
      ...baseJob,
      execParams: JSON.stringify({
        organizationId: 999,
        mode: 'DAILY',
      }),
    });

    expect(oracleService.callProc).toHaveBeenCalledWith('PKG_TEST', 'SP_RUN', {
      organizationId: 1,
      mode: 'DAILY',
    });
  });
});

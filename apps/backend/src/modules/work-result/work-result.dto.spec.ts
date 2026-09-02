import { validateSync } from 'class-validator';
import { WorkResultUpsertDto } from './work-result.dto';

describe('WorkResultUpsertDto', () => {
  it('allows machineCode to be omitted while workstageCode remains required', () => {
    const valid = Object.assign(new WorkResultUpsertDto(), {
      runNo: 'RUN-1',
      workstageCode: 'WS-1',
      resultQty: 10,
      resultStatus: 'WIP',
    });
    expect(validateSync(valid).some((error) => error.property === 'machineCode')).toBe(false);

    const missingWorkstage = Object.assign(new WorkResultUpsertDto(), {
      runNo: 'RUN-1',
      resultQty: 10,
      resultStatus: 'WIP',
    });
    expect(validateSync(missingWorkstage).some((error) => error.property === 'workstageCode')).toBe(true);
  });
});

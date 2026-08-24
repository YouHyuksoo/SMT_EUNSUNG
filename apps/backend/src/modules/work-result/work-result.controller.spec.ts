import 'reflect-metadata';
import { GUARDS_METADATA } from '@nestjs/common/constants';
import { IS_PUBLIC_KEY } from '../../common/decorators/public.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { WorkResultController } from './work-result.controller';
import { WorkResultService } from './work-result.service';

describe('WorkResultController', () => {
  const service = {
    list: jest.fn().mockResolvedValue([]),
    results: jest.fn().mockResolvedValue([]),
    resultDetail: jest.fn().mockResolvedValue({ header: null }),
    upsertResult: jest.fn().mockResolvedValue({ seqNo: '01' }),
    getDefect: jest.fn().mockResolvedValue(null),
    saveDefect: jest.fn().mockResolvedValue(undefined),
    badReasons: jest.fn().mockResolvedValue([]),
    machines: jest.fn().mockResolvedValue([]),
    downtimeReasons: jest.fn().mockResolvedValue([]),
    downtimes: jest.fn().mockResolvedValue([]),
    upsertDowntime: jest.fn().mockResolvedValue({ dtSeq: 1 }),
  } as unknown as WorkResultService;

  beforeEach(() => jest.clearAllMocks());

  it('requires JwtAuthGuard and is not public', () => {
    expect(
      Reflect.getMetadata(IS_PUBLIC_KEY, WorkResultController),
    ).toBeFalsy();
    expect(
      Reflect.getMetadata(GUARDS_METADATA, WorkResultController) ?? [],
    ).toContain(JwtAuthGuard);
  });

  it('forwards authenticated organization and user instead of request body tenancy', async () => {
    const controller = new WorkResultController(service);
    const resultDto = {
      runNo: 'RUN-1',
      machineCode: 'MC-1',
      workstageCode: 'WS-1',
      resultQty: 10,
      resultStatus: 'WIP',
    };
    const downtimeDto = {
      runNo: 'RUN-1',
      machineCode: 'MC-1',
    };

    await controller.list('2026-08-01', '2026-08-25', '01', 'ITEM', 7);
    await controller.createResult(resultDto, 7, 'user-7');
    await controller.saveDefect(
      { runNo: 'RUN-1', badCode: 'NG', badQty: 1 },
      7,
      'user-7',
    );
    await controller.createDowntime(downtimeDto, 7, 'user-7');

    expect(service.list).toHaveBeenCalledWith(
      '2026-08-01',
      '2026-08-25',
      '01',
      'ITEM',
      7,
    );
    expect(service.upsertResult).toHaveBeenCalledWith(
      { ...resultDto, seqNo: undefined },
      7,
      'user-7',
    );
    expect(service.saveDefect).toHaveBeenCalledWith(
      'RUN-1',
      'NG',
      1,
      undefined,
      7,
      'user-7',
    );
    expect(service.upsertDowntime).toHaveBeenCalledWith(
      { ...downtimeDto, dtSeq: undefined },
      7,
      'user-7',
    );
  });
});

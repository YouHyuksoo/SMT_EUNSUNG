import 'reflect-metadata';
import { GUARDS_METADATA } from '@nestjs/common/constants';
import { BadRequestException } from '@nestjs/common';
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
    bulkDowntime: jest.fn().mockResolvedValue({ affected: 1, skipped: 0, targets: 1, skippedMachines: [] }),
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
      action: 'START',
      runNo: 'RUN-1',
      machineCodes: ['MC-1'],
    };

    await controller.list('2026-08-01', '2026-08-25', '01', 'ITEM', undefined, 7, 'Y');
    await controller.createResult(resultDto, 7, 'user-7');
    await controller.saveDefect(
      { runNo: 'RUN-1', badCode: 'NG', badQty: 1 },
      7,
      'user-7',
    );
    await controller.bulkDowntime(downtimeDto, 7, 'user-7');

    expect(service.list).toHaveBeenCalledWith(
      '2026-08-01',
      '2026-08-25',
      '01',
      'ITEM',
      7,
      undefined,
      true,
      undefined,
      undefined,
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
    expect(service.bulkDowntime).toHaveBeenCalledWith(downtimeDto, 7, 'user-7');
  });

  it('parses unique trimmed lineCodes and forwards them as the final list argument', async () => {
    const controller = new WorkResultController(service);

    await controller.list(
      '2026-08-01',
      '2026-08-25',
      '01',
      'ITEM',
      'MC-1',
      7,
      undefined,
      ' L1, L2, L1 ',
    );

    expect(service.list).toHaveBeenCalledWith(
      '2026-08-01',
      '2026-08-25',
      '01',
      'ITEM',
      7,
      'MC-1',
      false,
      ['L1', 'L2'],
      undefined,
    );
  });

  it('forwards the process filter for process-bound run cards', async () => {
    const controller = new WorkResultController(service);

    await controller.list('2026-10-14', '2026-10-14', '34', undefined, undefined, 7, 'Y', undefined, 'W091');

    expect(service.list).toHaveBeenCalledWith(
      '2026-10-14', '2026-10-14', '34', undefined, 7, undefined, true, undefined, 'W091',
    );
  });

  it('returns exactly 100 rows without truncation', async () => {
    const controller = new WorkResultController(service);
    const rows = Array.from({ length: 100 }, (_, index) => ({
      runNo: `RUN-${index}`,
    }));
    (service.list as jest.Mock).mockResolvedValueOnce(rows);

    await expect(
      controller.list(
        '2026-08-01',
        '2026-08-25',
        undefined,
        undefined,
        undefined,
        7,
        undefined,
      ),
    ).resolves.toEqual({ list: rows });
  });

  it('returns the first 100 rows and marks an additional row as truncated', async () => {
    const controller = new WorkResultController(service);
    const rows = Array.from({ length: 101 }, (_, index) => ({
      runNo: `RUN-${index}`,
    }));
    (service.list as jest.Mock).mockResolvedValueOnce(rows);

    await expect(
      controller.list(
        '2026-08-01',
        '2026-08-25',
        undefined,
        undefined,
        undefined,
        7,
        undefined,
        'L1',
      ),
    ).resolves.toEqual({ list: rows.slice(0, 100), truncated: true });
  });

  it('rejects malformed lineCodes before calling the service', async () => {
    const controller = new WorkResultController(service);
    const malformed = [
      'L1,,L2',
      'X'.repeat(21),
      Array.from({ length: 101 }, (_, index) => `L${index}`).join(','),
    ];

    for (const lineCodes of malformed) {
      await expect(
        controller.list(
          '2026-08-01',
          '2026-08-25',
          undefined,
          undefined,
          undefined,
          7,
          undefined,
          lineCodes,
        ),
      ).rejects.toBeInstanceOf(BadRequestException);
    }

    expect(service.list).not.toHaveBeenCalled();
  });
});

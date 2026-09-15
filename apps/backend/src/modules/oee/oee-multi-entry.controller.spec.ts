import 'reflect-metadata';
import {
  GUARDS_METADATA,
  METHOD_METADATA,
  PATH_METADATA,
} from '@nestjs/common/constants';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { OeeMultiEntryController } from './oee-multi-entry.controller';
import {
  OeeMultiEntryEndDto,
  OeeMultiEntryStartDto,
  OeeMultiEntryStatusQueryDto,
} from './oee-multi-entry.dto';
import { OeeMultiEntryService } from './oee-multi-entry.service';

describe('OeeMultiEntryController', () => {
  const service = {
    getStatus: jest.fn(),
    start: jest.fn(),
    end: jest.fn(),
  };
  let target: OeeMultiEntryController;

  beforeEach(() => {
    jest.clearAllMocks();
    target = new OeeMultiEntryController(
      service as unknown as OeeMultiEntryService,
    );
  });

  it('requires JwtAuthGuard and exposes only the approved batch routes', () => {
    expect(
      Reflect.getMetadata(GUARDS_METADATA, OeeMultiEntryController) ?? [],
    ).toContain(JwtAuthGuard);
    expect(Reflect.getMetadata(PATH_METADATA, OeeMultiEntryController)).toBe(
      'oee/multi-entry',
    );
    expect(
      Reflect.getMetadata(
        PATH_METADATA,
        OeeMultiEntryController.prototype.getStatus,
      ),
    ).toBe('status');
    expect(
      Reflect.getMetadata(
        PATH_METADATA,
        OeeMultiEntryController.prototype.start,
      ),
    ).toBe('start');
    expect(
      Reflect.getMetadata(PATH_METADATA, OeeMultiEntryController.prototype.end),
    ).toBe('end');
    expect(
      Reflect.getMetadata(
        METHOD_METADATA,
        OeeMultiEntryController.prototype.getStatus,
      ),
    ).toBe(0);
    expect(
      Reflect.getMetadata(
        METHOD_METADATA,
        OeeMultiEntryController.prototype.start,
      ),
    ).toBe(1);
    expect(
      Reflect.getMetadata(
        METHOD_METADATA,
        OeeMultiEntryController.prototype.end,
      ),
    ).toBe(1);
  });

  it('passes authenticated tenant context instead of client-owned tenant fields', async () => {
    const statusQuery = {
      processCode: 'SMT',
      lineCode: '01',
    } as OeeMultiEntryStatusQueryDto;
    const start = {
      processCode: 'SMT',
      lineCodes: ['01'],
      workerId: 'WORKER01',
    } as OeeMultiEntryStartDto;
    const end = {
      processCode: 'SMT',
      items: [{ lineCode: '01', dtSeq: 10 }],
      reasonCode: 'END_REASON',
    } as OeeMultiEntryEndDto;
    service.getStatus.mockResolvedValue({
      state: 'DOWNTIME',
      openEvents: [{ dtSeq: 10, lineCode: '01' }],
    });
    service.start.mockResolvedValue({ events: [] });
    service.end.mockResolvedValue({ events: [] });

    await expect(
      target.getStatus(statusQuery, 7, 'EUNSUNG', '1'),
    ).resolves.toMatchObject({
      state: 'DOWNTIME',
      openEvents: [{ dtSeq: 10, lineCode: '01' }],
    });
    await target.start(start, 7, 'EUNSUNG', '1', 'LOGIN01');
    await target.end(end, 7, 'EUNSUNG', '1', 'LOGIN01');

    expect(service.getStatus).toHaveBeenCalledWith(
      'SMT',
      '01',
      7,
      'EUNSUNG',
      '1',
    );
    expect(service.start).toHaveBeenCalledWith(
      start,
      7,
      'EUNSUNG',
      '1',
      'LOGIN01',
    );
    expect(service.end).toHaveBeenCalledWith(end, 7, 'EUNSUNG', '1', 'LOGIN01');
  });
});

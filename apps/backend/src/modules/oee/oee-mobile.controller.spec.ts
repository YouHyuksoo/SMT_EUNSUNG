import 'reflect-metadata';
import { GUARDS_METADATA, METHOD_METADATA, PATH_METADATA } from '@nestjs/common/constants';
import { OeeMobileController } from './oee-mobile.controller';
import { OeeMobileService } from './oee-mobile.service';
import {
  OeeMobileEndDowntimeDto,
  OeeMobileReasonsQueryDto,
  OeeMobileResourcesQueryDto,
  OeeMobileStartDowntimeDto,
  OeeMobileStatusQueryDto,
} from './oee-mobile.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { IS_PUBLIC_KEY } from '../../common/decorators/public.decorator';

describe('OeeMobileController', () => {
  const service = {
    listResources: jest.fn(),
    getWorker: jest.fn(),
    listReasons: jest.fn(),
    getStatus: jest.fn(),
    startDowntime: jest.fn(),
    endDowntime: jest.fn(),
  };
  let target: OeeMobileController;

  beforeEach(() => {
    jest.clearAllMocks();
    target = new OeeMobileController(service as unknown as OeeMobileService);
  });

  it('requires JwtAuthGuard and is not public', () => {
    expect(Reflect.getMetadata(IS_PUBLIC_KEY, OeeMobileController)).toBeFalsy();
    expect(Reflect.getMetadata(GUARDS_METADATA, OeeMobileController) ?? []).toContain(JwtAuthGuard);
  });

  it('exposes the authenticated resources route', () => {
    expect(Reflect.getMetadata(PATH_METADATA, OeeMobileController)).toBe('oee/mobile');
    expect(Reflect.getMetadata(PATH_METADATA, OeeMobileController.prototype.listResources)).toBe('resources');
    expect(Reflect.getMetadata(METHOD_METADATA, OeeMobileController.prototype.listResources)).toBe(0);
    expect(Reflect.getMetadata(PATH_METADATA, OeeMobileController.prototype.getWorker)).toBe(
      'workers/:workerId',
    );
    expect(Reflect.getMetadata(PATH_METADATA, OeeMobileController.prototype.listReasons)).toBe('reasons');
    expect(Reflect.getMetadata(PATH_METADATA, OeeMobileController.prototype.getStatus)).toBe('status');
    expect(Reflect.getMetadata(PATH_METADATA, OeeMobileController.prototype.startDowntime)).toBe(
      'downtime/start',
    );
    expect(Reflect.getMetadata(PATH_METADATA, OeeMobileController.prototype.endDowntime)).toBe(
      'downtime/end',
    );
    expect(Reflect.getMetadata(METHOD_METADATA, OeeMobileController.prototype.startDowntime)).toBe(1);
    expect(Reflect.getMetadata(METHOD_METADATA, OeeMobileController.prototype.endDowntime)).toBe(1);
  });

  it('passes all authenticated tenant values and wraps resources', async () => {
    const resources = [
      {
        processCode: 'SMT',
        resourceType: 'LINE',
        resourceCode: '01',
        resourceName: 'A',
        parentLineCode: null,
      },
    ];
    service.listResources.mockResolvedValue(resources);

    const query = { processCode: 'SMT' } as OeeMobileResourcesQueryDto;
    const result = await target.listResources(query, 7, 'EUNSUNG', '1');

    expect(service.listResources).toHaveBeenCalledWith('SMT', 7, 'EUNSUNG', '1');
    expect(result).toEqual({ resources });
  });

  it('passes the authenticated organization to the worker lookup', async () => {
    const worker = { workerId: 'WORKER01', workerName: '작업자' };
    service.getWorker.mockResolvedValue(worker);

    await expect(target.getWorker('WORKER01', 7)).resolves.toEqual(worker);
    expect(service.getWorker).toHaveBeenCalledWith('WORKER01', 7);
  });

  it('passes only authenticated organization to reasons and wraps rows', async () => {
    const reasons = [{ reasonCode: 'MACHINE_STOP', reasonName: '설비정지' }];
    service.listReasons.mockResolvedValue(reasons);

    const query = {} as OeeMobileReasonsQueryDto;
    await expect(target.listReasons(query, 7)).resolves.toEqual({ reasons });
    expect(service.listReasons).toHaveBeenCalledWith(7);
  });

  it('passes resource query and authenticated tenant to status', async () => {
    const query = {
      processCode: 'ASSY',
      resourceType: 'CELL',
      resourceCode: '50',
      parentLineCode: 'PROD2',
    } as OeeMobileStatusQueryDto;
    const status = { workDate: '2026-08-07', workSegment: 'A', state: 'RUNNING', events: [], openEvent: null };
    service.getStatus.mockResolvedValue(status);

    await expect(target.getStatus(query, 7, 'EUNSUNG', '1')).resolves.toEqual(status);
    expect(service.getStatus).toHaveBeenCalledWith(
      'ASSY',
      'CELL',
      '50',
      'PROD2',
      7,
      'EUNSUNG',
      '1',
    );
  });

  it('passes authenticated executor and tenant to start/end transitions', async () => {
    const start = {
      processCode: 'SMT',
      resourceType: 'LINE',
      resourceCode: '01',
      parentLineCode: '01',
      workerId: 'WORKER01',
      reasonCode: 'MACHINE_STOP',
      requestId: 'start-1',
    } as OeeMobileStartDowntimeDto;
    const end = { eventId: 1, requestId: 'end-1' } as OeeMobileEndDowntimeDto;
    service.startDowntime.mockResolvedValue({ event: {}, replayed: false });
    service.endDowntime.mockResolvedValue({ event: {}, replayed: false });

    await target.startDowntime(start, 7, 'EUNSUNG', '1', 'LOGIN01');
    await target.endDowntime(end, 7, 'LOGIN01');

    expect(service.startDowntime).toHaveBeenCalledWith(start, 7, 'EUNSUNG', '1', 'LOGIN01');
    expect(service.endDowntime).toHaveBeenCalledWith(end, 7, 'LOGIN01');
  });
});

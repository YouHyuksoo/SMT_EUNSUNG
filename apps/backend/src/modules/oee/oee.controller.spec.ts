import 'reflect-metadata';
import { GUARDS_METADATA } from '@nestjs/common/constants';
import { IS_PUBLIC_KEY } from '../../common/decorators/public.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { OeeController } from './oee.controller';
import { OeeDashboardService } from './oee-dashboard.service';
import { OeeLogService } from './oee-log.service';
import { OeeMasterService } from './oee-master.service';
import { LogSaveDto, ReasonUpsertDto, ResourceUpsertDto } from './oee.dto';

type AuthenticatedOeeController = {
  listResources(organizationId: number): Promise<unknown>;
  createResource(dto: ResourceUpsertDto, organizationId: number): Promise<unknown>;
  updateResource(dto: ResourceUpsertDto, organizationId: number): Promise<unknown>;
  listReasons(organizationId: number): Promise<unknown>;
  createReason(dto: ReasonUpsertDto, organizationId: number): Promise<unknown>;
  updateReason(dto: ReasonUpsertDto, organizationId: number): Promise<unknown>;
  loadLog(resourceId: string, workDate: string, shift: string, organizationId: number): Promise<unknown>;
  saveLog(dto: LogSaveDto, organizationId: number, userId: string): Promise<unknown>;
  dashboardOverview(date: string | undefined, organizationId: number): Promise<unknown>;
  dashboardDrilldown(
    processCode: string,
    date: string | undefined,
    organizationId: number,
  ): Promise<unknown>;
  dashboardLoss(date: string | undefined, organizationId: number): Promise<unknown>;
};

describe('OeeController', () => {
  const master = {
    listResources: jest.fn().mockResolvedValue([]),
    upsertResource: jest.fn().mockResolvedValue(undefined),
    listReasons: jest.fn().mockResolvedValue([]),
    upsertReason: jest.fn().mockResolvedValue(undefined),
  } as unknown as OeeMasterService;
  const log = {
    loadShift: jest.fn().mockResolvedValue([]),
    saveShift: jest.fn().mockResolvedValue(undefined),
  } as unknown as OeeLogService;
  const dashboard = {
    overview: jest.fn().mockResolvedValue({}),
    drilldown: jest.fn().mockResolvedValue({}),
    lossPareto: jest.fn().mockResolvedValue({}),
  } as unknown as OeeDashboardService;

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('requires JwtAuthGuard and is not public', () => {
    expect(Reflect.getMetadata(IS_PUBLIC_KEY, OeeController)).toBeFalsy();
    expect(Reflect.getMetadata(GUARDS_METADATA, OeeController) ?? []).toContain(JwtAuthGuard);
  });

  it('forwards authenticated organization and user values to every endpoint', async () => {
    const target = new OeeController(master, log, dashboard) as unknown as AuthenticatedOeeController;
    const resourceDto = {
      resourceId: 10,
      processCode: 'SMT',
      resourceType: 'LINE',
      resourceName: 'Line 1',
    } as ResourceUpsertDto;
    const reasonDto = {
      reasonCode: 'STOP',
      reasonName: '정지',
      lossBucket: 'AVAIL_DOWN',
      oeeFactor: 'AVAILABILITY',
    } as ReasonUpsertDto;
    const logDto = {
      resourceId: 10,
      workDate: '2026-08-20',
      shift: 'DAY',
      netLoadMinutes: 60,
      intervals: [],
    } as LogSaveDto;

    await target.listResources(7);
    await target.createResource(resourceDto, 7);
    await target.updateResource(resourceDto, 7);
    await target.listReasons(7);
    await target.createReason(reasonDto, 7);
    await target.updateReason(reasonDto, 7);
    await target.loadLog('10', '2026-08-20', 'DAY', 7);
    await target.saveLog(logDto, 7, 'authenticated-user');
    await target.dashboardOverview('2026-08-20', 7);
    await target.dashboardDrilldown('SMT', '2026-08-20', 7);
    await target.dashboardLoss('2026-08-20', 7);

    expect(master.listResources).toHaveBeenCalledWith(7);
    expect(master.upsertResource).toHaveBeenNthCalledWith(1, expect.objectContaining({ resourceId: undefined }), 7);
    expect(master.upsertResource).toHaveBeenNthCalledWith(2, resourceDto, 7);
    expect(master.listReasons).toHaveBeenCalledWith(7);
    expect(master.upsertReason).toHaveBeenNthCalledWith(1, reasonDto, false, 7);
    expect(master.upsertReason).toHaveBeenNthCalledWith(2, reasonDto, true, 7);
    expect(log.loadShift).toHaveBeenCalledWith(10, '2026-08-20', 'DAY', 7);
    expect(log.saveShift).toHaveBeenCalledWith(logDto, 7, 'authenticated-user');
    expect(dashboard.overview).toHaveBeenCalledWith('2026-08-20', 7);
    expect(dashboard.drilldown).toHaveBeenCalledWith('SMT', '2026-08-20', 7);
    expect(dashboard.lossPareto).toHaveBeenCalledWith('2026-08-20', 7);
  });
});

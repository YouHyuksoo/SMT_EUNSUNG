import 'reflect-metadata';
import { RequestMethod } from '@nestjs/common';
import { GUARDS_METADATA, METHOD_METADATA, PATH_METADATA } from '@nestjs/common/constants';
import { IS_PUBLIC_KEY } from '../../common/decorators/public.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { OeeController } from './oee.controller';
import { OeeDashboardService } from './oee-dashboard.service';
import { OeeLogService } from './oee-log.service';
import { OeeMasterService } from './oee-master.service';
import {
  LogSaveDto,
  ReasonUpsertDto,
  ResourceCreateDto,
  ResourceUpdateDto,
} from './oee.dto';
import { SmtCloseRunPreviewService } from './smt-close-run-preview.service';

type AuthenticatedOeeController = {
  listResources(organizationId: number): Promise<unknown>;
  listResourceCandidates(organizationId: number): Promise<unknown>;
  createResource(dto: ResourceCreateDto, organizationId: number): Promise<unknown>;
  updateResource(resourceId: number, dto: ResourceUpdateDto, organizationId: number): Promise<unknown>;
  deleteResource(resourceId: number, organizationId: number): Promise<unknown>;
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
  previewSmtCloseRun(query: unknown, organizationId: number): Promise<unknown>;
};

describe('OeeController', () => {
  const master = {
    listResources: jest.fn().mockResolvedValue([]),
    listResourceCandidates: jest.fn().mockResolvedValue([]),
    createResource: jest.fn().mockResolvedValue(undefined),
    updateResource: jest.fn().mockResolvedValue(undefined),
    deleteResource: jest.fn().mockResolvedValue(undefined),
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
  const smtCloseRunPreview = {
    preview: jest.fn().mockResolvedValue({}),
  } as unknown as SmtCloseRunPreviewService;

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('requires JwtAuthGuard and is not public', () => {
    expect(Reflect.getMetadata(IS_PUBLIC_KEY, OeeController)).toBeFalsy();
    expect(Reflect.getMetadata(GUARDS_METADATA, OeeController) ?? []).toContain(JwtAuthGuard);
  });

  it('exposes the approved candidate, update, and delete resource routes', () => {
    expect(Reflect.getMetadata(PATH_METADATA, OeeController.prototype.listResourceCandidates)).toBe('resource/candidates');
    expect(Reflect.getMetadata(METHOD_METADATA, OeeController.prototype.listResourceCandidates)).toBe(RequestMethod.GET);
    expect(Reflect.getMetadata(PATH_METADATA, OeeController.prototype.updateResource)).toBe('resource/:resourceId');
    expect(Reflect.getMetadata(METHOD_METADATA, OeeController.prototype.updateResource)).toBe(RequestMethod.PUT);
    expect(Reflect.getMetadata(PATH_METADATA, OeeController.prototype.deleteResource)).toBe('resource/:resourceId');
    expect(Reflect.getMetadata(METHOD_METADATA, OeeController.prototype.deleteResource)).toBe(RequestMethod.DELETE);
  });

  it('forwards authenticated organization and user values to every endpoint', async () => {
    const target = new OeeController(master, log, dashboard, smtCloseRunPreview) as unknown as AuthenticatedOeeController;
    const resourceDto = {
      lineCode: '01',
      processCode: 'SMT',
      resourceType: 'LINE',
    } as ResourceCreateDto;
    const resourceUpdateDto = {
      lineCode: '01',
      processCode: 'ASSY',
      resourceType: 'CELL',
    } as ResourceUpdateDto;
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
    await target.listResourceCandidates(7);
    await target.createResource(resourceDto, 7);
    await target.updateResource(10, resourceUpdateDto, 7);
    await target.deleteResource(10, 7);
    await target.listReasons(7);
    await target.createReason(reasonDto, 7);
    await target.updateReason(reasonDto, 7);
    await target.loadLog('10', '2026-08-20', 'DAY', 7);
    await target.saveLog(logDto, 7, 'authenticated-user');
    await target.dashboardOverview('2026-08-20', 7);
    await target.dashboardDrilldown('SMT', '2026-08-20', 7);
    await target.dashboardLoss('2026-08-20', 7);

    expect(master.listResources).toHaveBeenCalledWith(7);
    expect(master.listResourceCandidates).toHaveBeenCalledWith(7);
    expect(master.createResource).toHaveBeenCalledWith(resourceDto, 7);
    expect(master.updateResource).toHaveBeenCalledWith(10, resourceUpdateDto, 7);
    expect(master.deleteResource).toHaveBeenCalledWith(10, 7);
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

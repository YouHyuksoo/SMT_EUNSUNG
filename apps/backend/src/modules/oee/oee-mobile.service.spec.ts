import { Test, TestingModule } from '@nestjs/testing';
import { BadRequestException, ConflictException, NotFoundException } from '@nestjs/common';
import { getRepositoryToken } from '@nestjs/typeorm';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { FindOperator, IsNull, Not, Repository } from 'typeorm';
import { ComCode } from '../../entities/com-code.entity';
import { IsysUser } from '../../entities/isys-user.entity';
import { OeeDowntimeEvent } from '../../entities/oee-downtime-event.entity';
import { OeeResource } from '../../entities/oee-resource.entity';
import { ProdLineMaster } from '../../entities/prod-line-master.entity';
import { WorktimeRange } from '../../entities/worktime-range.entity';
import { MockLoggerService } from '@test/mock-logger.service';
import { OeeMobileService } from './oee-mobile.service';

describe('OeeMobileService', () => {
  let target: OeeMobileService;
  let lineRepository: DeepMocked<Repository<ProdLineMaster>>;
  let resourceRepository: DeepMocked<Repository<OeeResource>>;
  let userRepository: DeepMocked<Repository<IsysUser>>;
  let codeRepository: DeepMocked<Repository<ComCode>>;
  let eventRepository: DeepMocked<Repository<OeeDowntimeEvent>>;
  let worktimeRepository: DeepMocked<Repository<WorktimeRange>>;

  beforeEach(async () => {
    lineRepository = createMock<Repository<ProdLineMaster>>();
    resourceRepository = createMock<Repository<OeeResource>>();
    userRepository = createMock<Repository<IsysUser>>();
    codeRepository = createMock<Repository<ComCode>>();
    eventRepository = createMock<Repository<OeeDowntimeEvent>>();
    worktimeRepository = createMock<Repository<WorktimeRange>>();
    eventRepository.findOne.mockResolvedValue(null);
    eventRepository.find.mockResolvedValue([]);
    resourceRepository.find.mockResolvedValue([
      {
        resourceId: 1,
        organizationId: 7,
        processCode: 'SMT',
        resourceType: 'LINE',
        refCode: '01',
        resourceName: 'Configured resource',
        useYn: 'Y',
        sortOrder: 1,
      } as OeeResource,
    ]);

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        OeeMobileService,
        { provide: getRepositoryToken(ProdLineMaster), useValue: lineRepository },
        { provide: getRepositoryToken(OeeResource), useValue: resourceRepository },
        { provide: getRepositoryToken(IsysUser), useValue: userRepository },
        { provide: getRepositoryToken(ComCode), useValue: codeRepository },
        { provide: getRepositoryToken(OeeDowntimeEvent), useValue: eventRepository },
        { provide: getRepositoryToken(WorktimeRange), useValue: worktimeRepository },
      ],
    })
      .setLogger(new MockLoggerService())
      .compile();

    target = module.get<OeeMobileService>(OeeMobileService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('lists active configured resources joined to canonical same-organization lines', async () => {
    resourceRepository.find.mockResolvedValue([
      {
        resourceId: 2,
        organizationId: 7,
        processCode: 'SMT',
        resourceType: 'CELL',
        refCode: '02',
        resourceName: 'Spoofed cell name',
        useYn: 'Y',
        sortOrder: 10,
      } as OeeResource,
      {
        resourceId: 1,
        organizationId: 7,
        processCode: 'SMT',
        resourceType: 'LINE',
        refCode: '01',
        resourceName: 'Spoofed line name',
        useYn: 'Y',
        sortOrder: 10,
      } as OeeResource,
      {
        resourceId: 3,
        organizationId: 7,
        processCode: 'SMT',
        resourceType: 'LINE',
        refCode: '03',
        resourceName: 'Inactive resource',
        useYn: 'N',
        sortOrder: 1,
      } as OeeResource,
      {
        resourceId: 4,
        organizationId: 8,
        processCode: 'SMT',
        resourceType: 'LINE',
        refCode: '04',
        resourceName: 'Other organization',
        useYn: 'Y',
        sortOrder: 1,
      } as OeeResource,
      {
        resourceId: 5,
        organizationId: 7,
        processCode: 'SMT',
        resourceType: 'MACHINE',
        refCode: '05',
        resourceName: 'Unsupported type',
        useYn: 'Y',
        sortOrder: 1,
      } as OeeResource,
      {
        resourceId: 6,
        organizationId: 7,
        processCode: 'SMT',
        resourceType: 'CELL',
        refCode: null,
        resourceName: 'Missing reference',
        useYn: 'Y',
        sortOrder: 1,
      } as OeeResource,
    ]);
    lineRepository.find.mockResolvedValue([
      {
        lineCode: '02',
        lineName: 'Canonical cell line',
        organizationId: 7,
      } as ProdLineMaster,
      {
        lineCode: '01',
        lineName: 'Canonical line',
        organizationId: 7,
      } as ProdLineMaster,
    ]);

    const result = await target.listResources('SMT', 7, 'EUNSUNG', '1');
    const resourceOptions = resourceRepository.find.mock.calls[0][0] as {
      where: Record<string, unknown>;
      order: Record<string, string>;
    };
    expect(resourceOptions.where).toEqual({
      organizationId: 7,
      processCode: 'SMT',
      resourceType: expect.any(Object),
      useYn: 'Y',
      refCode: expect.any(Object),
    });
    const resourceTypeFilter = resourceOptions.where.resourceType as FindOperator<string>;
    expect(resourceTypeFilter.type).toBe('in');
    expect(resourceTypeFilter.value).toEqual(['LINE', 'CELL']);
    const refCodeFilter = resourceOptions.where.refCode as FindOperator<string>;
    expect(refCodeFilter.type).toBe('not');
    expect(refCodeFilter.value).toBeUndefined();
    expect(resourceOptions.order).toEqual({ sortOrder: 'ASC', refCode: 'ASC' });
    const lineOptions = lineRepository.find.mock.calls[0][0] as {
      where: Record<string, unknown>;
    };
    expect(lineOptions.where.organizationId).toBe(7);
    expect((lineOptions.where.lineCode as FindOperator<string>).type).toBe('in');
    expect((lineOptions.where.lineCode as FindOperator<string>).value).toEqual(['02', '01']);
    expect(result).toEqual([
      {
        processCode: 'SMT',
        resourceType: 'LINE',
        resourceCode: '01',
        resourceName: 'Canonical line',
        parentLineCode: '01',
      },
      {
        processCode: 'SMT',
        resourceType: 'CELL',
        resourceCode: '02',
        resourceName: 'Canonical cell line',
        parentLineCode: '02',
      },
    ]);
  });

  it('lists only configured assembly resources instead of a fixed line range', async () => {
    resourceRepository.find.mockResolvedValue([
      {
        resourceId: 20,
        organizationId: 7,
        processCode: 'ASSY',
        resourceType: 'CELL',
        refCode: '88',
        resourceName: 'Configured assembly cell',
        useYn: 'Y',
        sortOrder: 2,
      } as OeeResource,
    ]);
    lineRepository.find.mockResolvedValue([
      { lineCode: '88', lineName: 'Configured assembly line', organizationId: 7 } as ProdLineMaster,
    ]);

    const result = await target.listResources('ASSY', 7, 'EUNSUNG', '1');
    expect(result).toEqual([
      {
        processCode: 'ASSY',
        resourceType: 'CELL',
        resourceCode: '88',
        resourceName: 'Configured assembly line',
        parentLineCode: '88',
      },
    ]);
  });

  it('rejects incomplete tenant context before querying', async () => {
    await expect(target.listResources('SMT', undefined, 'EUNSUNG', '1')).rejects.toThrow(
      BadRequestException,
    );
    await expect(target.listResources('ASSY', 7, '', '1')).rejects.toThrow(BadRequestException);
    await expect(target.listResources('ASSY', 7, 'EUNSUNG', undefined)).rejects.toThrow(
      BadRequestException,
    );

    expect(lineRepository.find).not.toHaveBeenCalled();
  });

  it('rejects an unsupported process code without falling back to a resource source', async () => {
    await expect(
      target.listResources('PROCESS_X' as 'SMT', 7, 'EUNSUNG', '1'),
    ).rejects.toThrow(BadRequestException);

    expect(lineRepository.find).not.toHaveBeenCalled();
  });

  it('returns an empty list when no ASSY cells match the scoped contract', async () => {
    lineRepository.find.mockResolvedValue([]);

    await expect(target.listResources('ASSY', 7, 'EUNSUNG', '1')).resolves.toEqual([]);
  });

  it('looks up workers only inside the authenticated organization', async () => {
    userRepository.findOne.mockResolvedValue({
      userId: 'WORKER01',
      organizationId: 7,
      userName: '홍길동',
    } as IsysUser);

    await expect(target.getWorker('WORKER01', 7)).resolves.toEqual({
      workerId: 'WORKER01',
      workerName: '홍길동',
    });
    expect(userRepository.findOne).toHaveBeenCalledWith({
      where: { userId: 'WORKER01', organizationId: 7 },
    });

    userRepository.findOne.mockResolvedValueOnce(null);
    await expect(target.getWorker('WORKER01', 8)).rejects.toThrow(NotFoundException);
  });

  it('lists only approved MACHINE STATUS CODE reasons for the organization in code order', async () => {
    codeRepository.find.mockResolvedValue([
      {
        groupCode: 'MACHINE STATUS CODE',
        organizationId: 7,
        detailCode: 'B',
        codeName: 'B reason',
      },
      {
        groupCode: 'MACHINE STATUS CODE',
        organizationId: 7,
        detailCode: 'A',
        codeName: 'A reason',
      },
    ] as ComCode[]);

    await expect(target.listReasons(7)).resolves.toEqual([
      { reasonCode: 'A', reasonName: 'A reason' },
      { reasonCode: 'B', reasonName: 'B reason' },
    ]);

    const options = codeRepository.find.mock.calls[0][0] as {
      where: Record<string, unknown>;
      order: Record<string, string>;
    };
    expect(options.where).toMatchObject({ groupCode: 'MACHINE STATUS CODE', organizationId: 7 });
    expect((options.where.detailCode as ReturnType<typeof Not>).type).toBe('not');
    const excluded = (options.where.detailCode as ReturnType<typeof Not>).value;
    expect(excluded).toEqual(['N', '*']);
    expect(options.order).toEqual({ detailCode: 'ASC' });
  });

  it('allows both LINE and CELL resource types for either mobile process', async () => {
    resourceRepository.find.mockResolvedValue([
      {
        resourceId: 2,
        organizationId: 7,
        processCode: 'SMT',
        resourceType: 'CELL',
        refCode: '02',
        resourceName: 'SMT cell',
        useYn: 'Y',
        sortOrder: 1,
      } as OeeResource,
      {
        resourceId: 3,
        organizationId: 7,
        processCode: 'ASSY',
        resourceType: 'LINE',
        refCode: '19',
        resourceName: 'ASSY line',
        useYn: 'Y',
        sortOrder: 1,
      } as OeeResource,
      {
        resourceId: 4,
        organizationId: 7,
        processCode: 'ASSY',
        resourceType: 'CELL',
        refCode: '20',
        resourceName: 'ASSY cell',
        useYn: 'Y',
        sortOrder: 2,
      } as OeeResource,
    ]);
    lineRepository.find.mockResolvedValue([
      { lineCode: '02', lineName: 'SMT cell', organizationId: 7 } as ProdLineMaster,
      { lineCode: '19', lineName: 'ASSY line', organizationId: 7 } as ProdLineMaster,
      { lineCode: '20', lineName: 'ASSY cell', organizationId: 7 } as ProdLineMaster,
    ]);

    await expect(target.listResources('SMT', 7, 'EUNSUNG', '1')).resolves.toEqual([
      {
        processCode: 'SMT',
        resourceType: 'CELL',
        resourceCode: '02',
        resourceName: 'SMT cell',
        parentLineCode: '02',
      },
    ]);
    await expect(target.listResources('ASSY', 7, 'EUNSUNG', '1')).resolves.toEqual([
      {
        processCode: 'ASSY',
        resourceType: 'LINE',
        resourceCode: '19',
        resourceName: 'ASSY line',
        parentLineCode: '19',
      },
      {
        processCode: 'ASSY',
        resourceType: 'CELL',
        resourceCode: '20',
        resourceName: 'ASSY cell',
        parentLineCode: '20',
      },
    ]);
  });

  it('requires the configured reference for the exact process, type, and parent tuple', async () => {
    resourceRepository.find.mockResolvedValue([
      {
        resourceId: 2,
        organizationId: 7,
        processCode: 'SMT',
        resourceType: 'CELL',
        refCode: '02',
        resourceName: 'SMT cell',
        useYn: 'Y',
        sortOrder: 1,
      } as OeeResource,
    ]);
    lineRepository.find.mockResolvedValue([
      { lineCode: '02', lineName: 'SMT cell', organizationId: 7 } as ProdLineMaster,
    ]);

    const now = new Date('2026-08-07T08:30:00+09:00');
    jest.useFakeTimers().setSystemTime(now);
    try {
      worktimeRepository.find.mockResolvedValue([
        {
          organizationId: 7,
          rangeType: 'SMTWORKTIME',
          workType: 'A',
          startTime: '083000',
          endTime: '103000',
          attribute01: null,
          attribute02: null,
        },
      ] as WorktimeRange[]);

      await expect(
        target.getStatus('SMT', 'CELL', '02', '02', 7, 'EUNSUNG', '1'),
      ).resolves.toMatchObject({ state: 'RUNNING', events: [], openEvent: null });
      await expect(
        target.getStatus('SMT', 'LINE', '02', '02', 7, 'EUNSUNG', '1'),
      ).rejects.toThrow(BadRequestException);
      await expect(
        target.getStatus('SMT', 'CELL', '02', '03', 7, 'EUNSUNG', '1'),
      ).rejects.toThrow(BadRequestException);
    } finally {
      jest.useRealTimers();
    }

    await expect(
      target.startDowntime(
        {
          processCode: 'SMT',
          resourceType: 'LINE',
          resourceCode: '02',
          parentLineCode: '02',
          workerId: 'WORKER01',
          reasonCode: 'A',
          requestId: 'start-1',
        },
        7,
        'EUNSUNG',
        '1',
        'LOGIN01',
      ),
    ).rejects.toThrow(BadRequestException);
  });

  it.each([
    ['SMT', 'CELL', '02', 'SMTWORKTIME'],
    ['ASSY', 'CELL', '20', 'WORKTIME'],
  ] as const)('selects %s worktime by process for %s resources', async (processCode, resourceType, refCode, rangeType) => {
    resourceRepository.find.mockResolvedValue([
      {
        resourceId: 2,
        organizationId: 7,
        processCode,
        resourceType,
        refCode,
        resourceName: 'Configured resource',
        useYn: 'Y',
        sortOrder: 1,
      } as OeeResource,
    ]);
    lineRepository.find.mockResolvedValue([
      { lineCode: refCode, lineName: 'Canonical line', organizationId: 7 } as ProdLineMaster,
    ]);
    worktimeRepository.find.mockResolvedValue([
      {
        organizationId: 7,
        rangeType,
        workType: 'A',
        startTime: '083000',
        endTime: '103000',
        attribute01: null,
        attribute02: null,
      },
    ] as WorktimeRange[]);
    jest.useFakeTimers().setSystemTime(new Date('2026-08-07T08:30:00+09:00'));
    try {
      await expect(
        target.getStatus(processCode, resourceType, refCode, refCode, 7, 'EUNSUNG', '1'),
      ).resolves.toMatchObject({ state: 'RUNNING', workSegment: 'A' });
      expect(worktimeRepository.find).toHaveBeenCalledWith({
        where: { organizationId: 7, rangeType },
        order: { workType: 'ASC' },
      });
    } finally {
      jest.useRealTimers();
    }
  });

  it('rejects missing worker, reason, and worktime prerequisites', async () => {
    const command = {
      processCode: 'SMT',
      resourceType: 'LINE',
      resourceCode: '01',
      parentLineCode: '01',
      workerId: 'WORKER01',
      reasonCode: 'A',
      requestId: 'start-1',
    } as const;
    lineRepository.find.mockResolvedValue([
      { lineCode: '01', lineName: 'A', organizationId: 7, lineDivision: 'D' },
    ] as ProdLineMaster[]);
    eventRepository.findOne.mockResolvedValue(null);
    userRepository.findOne.mockResolvedValue(null);

    await expect(target.startDowntime(command, 7, 'EUNSUNG', '1', 'LOGIN01')).rejects.toThrow(
      NotFoundException,
    );

    userRepository.findOne.mockResolvedValue({
      userId: 'WORKER01',
      organizationId: 7,
      userName: '작업자',
    } as IsysUser);
    codeRepository.findOne.mockResolvedValue(null);
    await expect(target.startDowntime(command, 7, 'EUNSUNG', '1', 'LOGIN01')).rejects.toThrow(
      NotFoundException,
    );

    codeRepository.findOne.mockResolvedValue({
      groupCode: 'MACHINE STATUS CODE',
      detailCode: 'A',
      organizationId: 7,
      codeName: '정지',
    } as ComCode);
    worktimeRepository.find.mockResolvedValue([]);
    await expect(target.startDowntime(command, 7, 'EUNSUNG', '1', 'LOGIN01')).rejects.toThrow(
      BadRequestException,
    );
  });

  it('starts an event with server time and computed work context', async () => {
    const command = {
      processCode: 'SMT',
      resourceType: 'LINE',
      resourceCode: '01',
      parentLineCode: '01',
      workerId: 'WORKER01',
      reasonCode: 'A',
      memo: 'jam',
      requestId: 'start-1',
    } as const;
    const now = new Date('2026-08-07T08:30:00+09:00');
    const created = { eventId: 10 } as OeeDowntimeEvent;
    jest.useFakeTimers().setSystemTime(now);
    try {
      lineRepository.find.mockResolvedValue([
        { lineCode: '01', lineName: 'A', organizationId: 7, lineDivision: 'D' },
      ] as ProdLineMaster[]);
      eventRepository.findOne.mockResolvedValue(null);
      userRepository.findOne.mockResolvedValue({
        userId: 'WORKER01',
        organizationId: 7,
        userName: '작업자',
      } as IsysUser);
      codeRepository.findOne.mockResolvedValue({
        groupCode: 'MACHINE STATUS CODE',
        detailCode: 'A',
        organizationId: 7,
        codeName: '정지',
      } as ComCode);
      worktimeRepository.find.mockResolvedValue([
        {
          organizationId: 7,
          rangeType: 'SMTWORKTIME',
          workType: 'A',
          startTime: '083000',
          endTime: '103000',
          attribute01: null,
          attribute02: null,
        },
      ] as WorktimeRange[]);
      eventRepository.create.mockImplementation(
        (value) => value as unknown as OeeDowntimeEvent,
      );
      eventRepository.save.mockResolvedValue(created);

      await expect(target.startDowntime(command, 7, 'EUNSUNG', '1', 'LOGIN01')).resolves.toEqual({
        event: created,
        replayed: false,
      });

      const inserted = eventRepository.save.mock.calls[0][0] as OeeDowntimeEvent;
      expect(inserted).toMatchObject({
        organizationId: 7,
        resourceType: 'LINE',
        resourceCode: '01',
        parentLineCode: '01',
        processCode: 'SMT',
        workSegment: 'A',
        reasonCode: 'A',
        memo: 'jam',
        workerId: 'WORKER01',
        startRequestId: 'start-1',
        startedBy: 'LOGIN01',
        endTime: null,
        endRequestId: null,
        endedBy: null,
      });
      expect(inserted.startTime).toEqual(now);
      expect(inserted.createdDate).toEqual(now);
      expect(inserted.updatedDate).toEqual(now);
    } finally {
      jest.useRealTimers();
    }
  });

  it('replays the same start request and rejects another open event', async () => {
    const command = {
      processCode: 'SMT',
      resourceType: 'LINE',
      resourceCode: '01',
      parentLineCode: '01',
      workerId: 'WORKER01',
      reasonCode: 'A',
      requestId: 'start-1',
    } as const;
    const replay = {
      eventId: 10,
      startRequestId: 'start-1',
      processCode: 'SMT',
      resourceType: 'LINE',
      resourceCode: '01',
      parentLineCode: '01',
      workerId: 'WORKER01',
      reasonCode: 'A',
      memo: null,
    } as OeeDowntimeEvent;
    eventRepository.findOne.mockResolvedValueOnce(replay);

    await expect(target.startDowntime(command, 7, 'EUNSUNG', '1', 'LOGIN01')).resolves.toEqual({
      event: replay,
      replayed: true,
    });
    expect(userRepository.findOne).not.toHaveBeenCalled();

    jest.clearAllMocks();
    jest.useFakeTimers().setSystemTime(new Date('2026-08-07T08:30:00+09:00'));
    try {
      eventRepository.findOne.mockResolvedValueOnce(null).mockResolvedValueOnce({
        eventId: 11,
        endTime: null,
      } as OeeDowntimeEvent);
      lineRepository.find.mockResolvedValue([
        { lineCode: '01', lineName: 'A', organizationId: 7, lineDivision: 'D' },
      ] as ProdLineMaster[]);
      userRepository.findOne.mockResolvedValue({ userId: 'WORKER01', organizationId: 7 } as IsysUser);
      codeRepository.findOne.mockResolvedValue({
        groupCode: 'MACHINE STATUS CODE',
        detailCode: 'A',
        organizationId: 7,
        codeName: '정지',
      } as ComCode);
      worktimeRepository.find.mockResolvedValue([
        {
          rangeType: 'SMTWORKTIME',
          workType: 'A',
          startTime: '083000',
          endTime: '103000',
          attribute01: null,
          attribute02: null,
        },
      ] as WorktimeRange[]);

      await expect(target.startDowntime(command, 7, 'EUNSUNG', '1', 'LOGIN01')).rejects.toThrow(
        ConflictException,
      );
    } finally {
      jest.useRealTimers();
    }
  });

  it.each([
    ['process', { processCode: 'ASSY' }],
    ['resource code', { resourceCode: '02' }],
    ['parent line', { parentLineCode: '02' }],
    ['worker', { workerId: 'WORKER02' }],
    ['reason', { reasonCode: 'B' }],
    ['memo', { memo: 'different memo' }],
  ])('rejects a start replay when the %s command field differs', async (_field, change) => {
    const command = {
      processCode: 'SMT',
      resourceType: 'LINE',
      resourceCode: '01',
      parentLineCode: '01',
      workerId: 'WORKER01',
      reasonCode: 'A',
      memo: 'original memo',
      requestId: 'start-1',
    } as const;
    const replay = {
      eventId: 10,
      startRequestId: 'start-1',
      processCode: 'SMT',
      resourceType: 'LINE',
      resourceCode: '01',
      parentLineCode: '01',
      workerId: 'WORKER01',
      reasonCode: 'A',
      memo: 'original memo',
    } as OeeDowntimeEvent;
    eventRepository.findOne.mockResolvedValueOnce(replay);

    await expect(
      target.startDowntime({ ...command, ...change }, 7, 'EUNSUNG', '1', 'LOGIN01'),
    ).rejects.toThrow(ConflictException);
  });

  it.each([
    ['replays', { eventId: 10, endRequestId: 'end-1' } as OeeDowntimeEvent, true],
    ['cross-org missing', null, false],
  ])('handles end preconditions: %s', async (_label, firstLookup, replayed) => {
    const command = { eventId: 10, requestId: 'end-1' };
    eventRepository.findOne.mockResolvedValueOnce(firstLookup);
    if (!replayed) {
      await expect(target.endDowntime(command, 7, 'LOGIN01')).rejects.toThrow(NotFoundException);
      return;
    }

    await expect(target.endDowntime(command, 7, 'LOGIN01')).resolves.toEqual({
      event: firstLookup,
      replayed: true,
    });
    expect(eventRepository.update).not.toHaveBeenCalled();
  });

  it('ends an open event with an atomic organization-scoped conditional update', async () => {
    const command = { eventId: 10, requestId: 'end-1' };
    const openEvent = { eventId: 10, organizationId: 7, endTime: null } as OeeDowntimeEvent;
    const updated = { ...openEvent, endTime: new Date(), endRequestId: 'end-1', endedBy: 'LOGIN01' } as OeeDowntimeEvent;
    const now = new Date('2026-08-07T09:00:00+09:00');
    jest.useFakeTimers().setSystemTime(now);
    try {
      eventRepository.findOne.mockResolvedValueOnce(undefined).mockResolvedValueOnce(openEvent).mockResolvedValueOnce(updated);
      eventRepository.update.mockResolvedValue({ affected: 1, generatedMaps: [], raw: [] });

      await expect(target.endDowntime(command, 7, 'LOGIN01')).resolves.toEqual({
        event: updated,
        replayed: false,
      });
      expect(eventRepository.update).toHaveBeenCalledWith(
        { eventId: 10, organizationId: 7, endTime: IsNull() },
        { endTime: now, endRequestId: 'end-1', endedBy: 'LOGIN01', updatedDate: now },
      );
    } finally {
      jest.useRealTimers();
    }
  });

  it('rejects an already ended event with a different end request', async () => {
    eventRepository.findOne.mockResolvedValueOnce(undefined).mockResolvedValueOnce({
      eventId: 10,
      organizationId: 7,
      endTime: new Date('2026-08-07T08:45:00+09:00'),
      endRequestId: 'other-end',
    } as OeeDowntimeEvent);

    await expect(target.endDowntime({ eventId: 10, requestId: 'end-1' }, 7, 'LOGIN01')).rejects.toThrow(
      ConflictException,
    );
    expect(eventRepository.update).not.toHaveBeenCalled();
  });

  it('rejects an end replay when the request ID is reused for another event', async () => {
    const replay = { eventId: 11, organizationId: 7, endRequestId: 'end-1' } as OeeDowntimeEvent;
    eventRepository.findOne.mockResolvedValueOnce(replay);

    await expect(target.endDowntime({ eventId: 10, requestId: 'end-1' }, 7, 'LOGIN01')).rejects.toThrow(
      ConflictException,
    );
    expect(eventRepository.update).not.toHaveBeenCalled();
  });

  it('resolves current status from current work date, events, and open event', async () => {
    const now = new Date('2026-08-07T22:30:00+09:00');
    jest.useFakeTimers().setSystemTime(now);
    try {
      lineRepository.find.mockResolvedValue([
        { lineCode: '01', lineName: 'A', organizationId: 7, lineDivision: 'D' },
      ] as ProdLineMaster[]);
      worktimeRepository.find.mockResolvedValue([
        {
          rangeType: 'SMTWORKTIME',
          workType: 'G',
          startTime: '223000',
          endTime: '003000',
          attribute01: '0',
          attribute02: '1',
        },
      ] as WorktimeRange[]);
      const openEvent = { eventId: 10, endTime: null } as OeeDowntimeEvent;
      eventRepository.find.mockResolvedValue([openEvent]);
      eventRepository.findOne.mockResolvedValue(openEvent);

      await expect(target.getStatus('SMT', 'LINE', '01', '01', 7, 'EUNSUNG', '1')).resolves.toEqual({
        workDate: '2026-08-07',
        workSegment: 'G',
        state: 'DOWNTIME',
        events: [openEvent],
        openEvent,
      });
    } finally {
      jest.useRealTimers();
    }
  });

  it.each([
    ['same request', true],
    ['different request', false],
  ])('maps concurrent start ORA-00001 to %s replay/conflict', async (_label, sameRequest) => {
    const command = {
      processCode: 'SMT',
      resourceType: 'LINE',
      resourceCode: '01',
      parentLineCode: '01',
      workerId: 'WORKER01',
      reasonCode: 'A',
      requestId: 'start-1',
    } as const;
    const replay = {
      eventId: 20,
      startRequestId: 'start-1',
      processCode: 'SMT',
      resourceType: 'LINE',
      resourceCode: '01',
      parentLineCode: '01',
      workerId: 'WORKER01',
      reasonCode: 'A',
      memo: null,
    } as OeeDowntimeEvent;
    jest.useFakeTimers().setSystemTime(new Date('2026-08-07T08:30:00+09:00'));
    try {
      lineRepository.find.mockResolvedValue([
        { lineCode: '01', lineName: 'A', organizationId: 7, lineDivision: 'D' },
      ] as ProdLineMaster[]);
      userRepository.findOne.mockResolvedValue({ userId: 'WORKER01', organizationId: 7 } as IsysUser);
      codeRepository.findOne.mockResolvedValue({
        groupCode: 'MACHINE STATUS CODE',
        detailCode: 'A',
        organizationId: 7,
        codeName: '정지',
      } as ComCode);
      worktimeRepository.find.mockResolvedValue([
        {
          rangeType: 'SMTWORKTIME',
          workType: 'A',
          startTime: '083000',
          endTime: '103000',
          attribute01: null,
          attribute02: null,
        },
      ] as WorktimeRange[]);
      eventRepository.findOne
        .mockResolvedValueOnce(null)
        .mockResolvedValueOnce(null)
        .mockResolvedValueOnce(sameRequest ? replay : null);
      eventRepository.create.mockImplementation(
        (value) => value as unknown as OeeDowntimeEvent,
      );
      eventRepository.save.mockRejectedValue(
        Object.assign(new Error('ORA-00001: unique constraint violated'), { code: 'ORA-00001' }),
      );

      if (sameRequest) {
        await expect(target.startDowntime(command, 7, 'EUNSUNG', '1', 'LOGIN01')).resolves.toEqual({
          event: replay,
          replayed: true,
        });
      } else {
        await expect(target.startDowntime(command, 7, 'EUNSUNG', '1', 'LOGIN01')).rejects.toThrow(
          ConflictException,
        );
      }
    } finally {
      jest.useRealTimers();
    }
  });

  it('rejects a concurrent start replay when the unique-request row has different command fields', async () => {
    const command = {
      processCode: 'SMT',
      resourceType: 'LINE',
      resourceCode: '01',
      parentLineCode: '01',
      workerId: 'WORKER01',
      reasonCode: 'A',
      requestId: 'start-1',
    } as const;
    const replay = {
      eventId: 20,
      startRequestId: 'start-1',
      processCode: 'SMT',
      resourceType: 'LINE',
      resourceCode: '02',
      parentLineCode: '02',
      workerId: 'WORKER01',
      reasonCode: 'A',
      memo: null,
    } as OeeDowntimeEvent;
    jest.useFakeTimers().setSystemTime(new Date('2026-08-07T08:30:00+09:00'));
    try {
      lineRepository.find.mockResolvedValue([
        { lineCode: '01', lineName: 'A', organizationId: 7, lineDivision: 'D' },
      ] as ProdLineMaster[]);
      userRepository.findOne.mockResolvedValue({ userId: 'WORKER01', organizationId: 7 } as IsysUser);
      codeRepository.findOne.mockResolvedValue({
        groupCode: 'MACHINE STATUS CODE',
        detailCode: 'A',
        organizationId: 7,
      } as ComCode);
      worktimeRepository.find.mockResolvedValue([
        {
          rangeType: 'SMTWORKTIME',
          workType: 'A',
          startTime: '083000',
          endTime: '103000',
          attribute01: null,
          attribute02: null,
        },
      ] as WorktimeRange[]);
      eventRepository.findOne
        .mockResolvedValueOnce(null)
        .mockResolvedValueOnce(null)
        .mockResolvedValueOnce(replay);
      eventRepository.create.mockImplementation(
        (value) => value as unknown as OeeDowntimeEvent,
      );
      eventRepository.save.mockRejectedValue(
        Object.assign(new Error('unique constraint violated'), { code: 'ORA-00001' }),
      );

      await expect(target.startDowntime(command, 7, 'EUNSUNG', '1', 'LOGIN01')).rejects.toThrow(
        ConflictException,
      );
    } finally {
      jest.useRealTimers();
    }
  });

  it.each([
    ['same request', true],
    ['different request', false],
  ])('rechecks end request after an affected=0 atomic update: %s', async (_label, sameRequest) => {
    const openEvent = { eventId: 10, organizationId: 7, endTime: null } as OeeDowntimeEvent;
    const replay = { eventId: 10, organizationId: 7, endRequestId: 'end-1' } as OeeDowntimeEvent;
    eventRepository.findOne
      .mockResolvedValueOnce(null)
      .mockResolvedValueOnce(openEvent)
      .mockResolvedValueOnce(sameRequest ? replay : null);
    eventRepository.update.mockResolvedValue({ affected: 0, generatedMaps: [], raw: [] });

    if (sameRequest) {
      await expect(target.endDowntime({ eventId: 10, requestId: 'end-1' }, 7, 'LOGIN01')).resolves.toEqual({
        event: replay,
        replayed: true,
      });
    } else {
      await expect(target.endDowntime({ eventId: 10, requestId: 'end-1' }, 7, 'LOGIN01')).rejects.toThrow(
        ConflictException,
      );
    }
    expect(eventRepository.update).toHaveBeenCalledWith(
      { eventId: 10, organizationId: 7, endTime: IsNull() },
      expect.objectContaining({ endRequestId: 'end-1', endedBy: 'LOGIN01' }),
    );
  });

  it('rejects a concurrent end replay when the unique-request row belongs to another event', async () => {
    const openEvent = { eventId: 10, organizationId: 7, endTime: null } as OeeDowntimeEvent;
    const replay = { eventId: 11, organizationId: 7, endRequestId: 'end-1' } as OeeDowntimeEvent;
    eventRepository.findOne
      .mockResolvedValueOnce(null)
      .mockResolvedValueOnce(openEvent)
      .mockResolvedValueOnce(replay);
    eventRepository.update.mockRejectedValue(
      Object.assign(new Error('ORA-00001: unique constraint violated'), { code: 'ORA-00001' }),
    );

    await expect(target.endDowntime({ eventId: 10, requestId: 'end-1' }, 7, 'LOGIN01')).rejects.toThrow(
      ConflictException,
    );
  });

  it('does not replace unexpected Oracle errors with a generic conflict', async () => {
    const openEvent = { eventId: 10, organizationId: 7, endTime: null } as OeeDowntimeEvent;
    const databaseError = new Error('ORA-00942: table or view does not exist');
    eventRepository.findOne.mockResolvedValueOnce(null).mockResolvedValueOnce(openEvent);
    eventRepository.update.mockRejectedValue(databaseError);

    await expect(target.endDowntime({ eventId: 10, requestId: 'end-1' }, 7, 'LOGIN01')).rejects.toBe(
      databaseError,
    );
  });
});

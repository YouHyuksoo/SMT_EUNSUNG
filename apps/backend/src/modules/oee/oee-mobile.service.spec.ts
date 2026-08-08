import { Test, TestingModule } from '@nestjs/testing';
import { BadRequestException, ConflictException, NotFoundException } from '@nestjs/common';
import { getRepositoryToken } from '@nestjs/typeorm';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { FindOperator, In, IsNull, Not, Repository } from 'typeorm';
import { ComCode } from '../../entities/com-code.entity';
import { IsysUser } from '../../entities/isys-user.entity';
import { OeeDowntimeEvent } from '../../entities/oee-downtime-event.entity';
import { Plant } from '../../entities/plant.entity';
import { ProdLineMaster } from '../../entities/prod-line-master.entity';
import { WorktimeRange } from '../../entities/worktime-range.entity';
import { MockLoggerService } from '@test/mock-logger.service';
import { OeeMobileService } from './oee-mobile.service';

describe('OeeMobileService', () => {
  let target: OeeMobileService;
  let lineRepository: DeepMocked<Repository<ProdLineMaster>>;
  let plantRepository: DeepMocked<Repository<Plant>>;
  let userRepository: DeepMocked<Repository<IsysUser>>;
  let codeRepository: DeepMocked<Repository<ComCode>>;
  let eventRepository: DeepMocked<Repository<OeeDowntimeEvent>>;
  let worktimeRepository: DeepMocked<Repository<WorktimeRange>>;

  beforeEach(async () => {
    lineRepository = createMock<Repository<ProdLineMaster>>();
    plantRepository = createMock<Repository<Plant>>();
    userRepository = createMock<Repository<IsysUser>>();
    codeRepository = createMock<Repository<ComCode>>();
    eventRepository = createMock<Repository<OeeDowntimeEvent>>();
    worktimeRepository = createMock<Repository<WorktimeRange>>();
    eventRepository.findOne.mockResolvedValue(null);
    eventRepository.find.mockResolvedValue([]);

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        OeeMobileService,
        { provide: getRepositoryToken(ProdLineMaster), useValue: lineRepository },
        { provide: getRepositoryToken(Plant), useValue: plantRepository },
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

  it('queries the SMT line contract and maps lines in LINE_CODE order without status filters', async () => {
    lineRepository.find.mockResolvedValue([
      {
        lineCode: '12',
        lineName: 'L',
        organizationId: 7,
        lineDivision: 'D',
        lineStatus: 'D',
        activeYn: 'N',
      } as ProdLineMaster,
      {
        lineCode: '01',
        lineName: 'A',
        organizationId: 7,
        lineDivision: 'D',
        lineStatus: 'N',
        activeYn: 'Y',
      } as ProdLineMaster,
    ]);

    const result = await target.listResources('SMT', 7, 'EUNSUNG', '1');
    const options = lineRepository.find.mock.calls[0][0] as {
      where: Record<string, unknown>;
      order: Record<string, string>;
    };
    const lineCodeFilter = options.where.lineCode as FindOperator<string>;

    expect(options.where).toEqual({
      organizationId: 7,
      lineDivision: 'D',
      lineCode: expect.any(FindOperator),
    });
    expect(lineCodeFilter.type).toBe('in');
    expect(lineCodeFilter.value).toEqual([
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
    ]);
    expect(options.where).not.toHaveProperty('lineStatus');
    expect(options.where).not.toHaveProperty('activeYn');
    expect(options.order).toEqual({ lineCode: 'ASC' });
    expect(result).toEqual([
      {
        processCode: 'SMT',
        resourceType: 'LINE',
        resourceCode: '01',
        resourceName: 'A',
        parentLineCode: null,
      },
      {
        processCode: 'SMT',
        resourceType: 'LINE',
        resourceCode: '12',
        resourceName: 'L',
        parentLineCode: null,
      },
    ]);
    expect(plantRepository.find).not.toHaveBeenCalled();
  });

  it('queries only enabled PROD2 CELL rows in the authenticated company and plant and maps them', async () => {
    plantRepository.find.mockResolvedValue([
      {
        plantCode: 'EUNSUNG',
        shopCode: '2F',
        lineCode: 'PROD2',
        cellCode: '51',
        company: 'EUNSUNG',
        plantCd: '1',
        plantType: 'CELL',
        plantName: 'CELL 51',
        sortOrder: 2,
        useYn: 'Y',
      } as Plant,
      {
        plantCode: 'EUNSUNG',
        shopCode: '2F',
        lineCode: 'PROD2',
        cellCode: '50',
        company: 'EUNSUNG',
        plantCd: '1',
        plantType: 'CELL',
        plantName: 'CELL 50',
        sortOrder: 1,
        useYn: 'Y',
      } as Plant,
    ]);

    const result = await target.listResources('ASSY', 7, 'EUNSUNG', '1');
    const options = plantRepository.find.mock.calls[0][0] as {
      where: Record<string, unknown>;
      order: Record<string, string>;
    };

    expect(options.where).toEqual({
      company: 'EUNSUNG',
      plantCd: '1',
      plantCode: 'EUNSUNG',
      shopCode: '2F',
      lineCode: 'PROD2',
      plantType: 'CELL',
      useYn: 'Y',
    });
    expect(options.order).toEqual({ sortOrder: 'ASC', cellCode: 'ASC' });
    expect(result).toEqual([
      {
        processCode: 'ASSY',
        resourceType: 'CELL',
        resourceCode: '50',
        resourceName: 'CELL 50',
        parentLineCode: 'PROD2',
      },
      {
        processCode: 'ASSY',
        resourceType: 'CELL',
        resourceCode: '51',
        resourceName: 'CELL 51',
        parentLineCode: 'PROD2',
      },
    ]);
    expect(lineRepository.find).not.toHaveBeenCalled();
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
    expect(plantRepository.find).not.toHaveBeenCalled();
  });

  it('rejects an unsupported process code without falling back to a resource source', async () => {
    await expect(
      target.listResources('PROCESS_X' as 'SMT', 7, 'EUNSUNG', '1'),
    ).rejects.toThrow(BadRequestException);

    expect(lineRepository.find).not.toHaveBeenCalled();
    expect(plantRepository.find).not.toHaveBeenCalled();
  });

  it('returns an empty list when no ASSY cells match the scoped contract', async () => {
    plantRepository.find.mockResolvedValue([]);

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

  it('rejects process/resource mismatch before resource lookup', async () => {
    await expect(
      target.startDowntime(
        {
          processCode: 'SMT',
          resourceType: 'CELL',
          resourceCode: '50',
          parentLineCode: 'PROD2',
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
    expect(lineRepository.find).not.toHaveBeenCalled();
    expect(plantRepository.find).not.toHaveBeenCalled();
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
      parentLineCode: 'ignored-by-normalization',
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
    const replay = { eventId: 10, startRequestId: 'start-1' } as OeeDowntimeEvent;
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
    const replay = { eventId: 20, startRequestId: 'start-1' } as OeeDowntimeEvent;
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

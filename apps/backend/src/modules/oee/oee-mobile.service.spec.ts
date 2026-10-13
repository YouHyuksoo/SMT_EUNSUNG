import { Test, TestingModule } from '@nestjs/testing';
import { BadRequestException, ConflictException, NotFoundException } from '@nestjs/common';
import { getDataSourceToken, getRepositoryToken } from '@nestjs/typeorm';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { DataSource, IsNull, Repository } from 'typeorm';
import { EquipDowntimeReason } from '../../entities/equip-downtime-reason.entity';
import { IsysUser } from '../../entities/isys-user.entity';
import { OeeDowntimeEvent } from '../../entities/oee-downtime-event.entity';
import { MockLoggerService } from '@test/mock-logger.service';
import { OeeMobileService } from './oee-mobile.service';

import {
  findDbNow, findOeeWorkContext, worktimeRangeType, type OeeMobileWorkContext,
} from './oee-mobile-worktime';

// 업무일·근무구간·지금 시각은 DB 가 정한다(oee-mobile-worktime.ts). 여기서는 가짜 시계를 DB 시각으로 본다.
jest.mock('./oee-mobile-worktime', () => ({
  ...jest.requireActual('./oee-mobile-worktime'),
  findOeeWorkContext: jest.fn(),
  findDbNow: jest.fn(),
}));

const DAY_MS = 24 * 60 * 60 * 1000;
const KST_MS = 9 * 60 * 60 * 1000;
/** 테스트용 DB 시각 — 가짜 시계를 초 단위로 자른다 (SYSDATE 와 같은 정밀도) */
function dbClock(): Date {
  const now = new Date();
  now.setMilliseconds(0);
  return now;
}
/** 실제 SQL 과 같은 규칙: 08:30 전이면 전날 업무일, 08:30~20:30 주간 */
function workContextAt(now: Date): OeeMobileWorkContext {
  const kst = new Date(now.getTime() + KST_MS);
  const minutes = kst.getUTCHours() * 60 + kst.getUTCMinutes();
  const day = new Date(Date.UTC(kst.getUTCFullYear(), kst.getUTCMonth(), kst.getUTCDate()) - (minutes < 510 ? DAY_MS : 0));
  const workDate = day.toISOString().slice(0, 10);
  const workDay = new Date(day.getTime() - KST_MS);
  return {
    workDate,
    workDay,
    workSegment: minutes >= 510 && minutes < 1230 ? 'DAY' : 'NIGHT',
    now,
    workStart: new Date(workDay.getTime() + 510 * 60 * 1000),
  };
}

describe('OeeMobileService', () => {
  let target: OeeMobileService;
  let dataSource: DeepMocked<DataSource>;
  let userRepository: DeepMocked<Repository<IsysUser>>;
  let reasonRepository: DeepMocked<Repository<EquipDowntimeReason>>;
  let eventRepository: DeepMocked<Repository<OeeDowntimeEvent>>;

  beforeEach(async () => {
    jest.mocked(findDbNow).mockImplementation(async () => dbClock());
    jest.mocked(findOeeWorkContext).mockImplementation(async () => workContextAt(dbClock()));
    dataSource = createMock<DataSource>();
    userRepository = createMock<Repository<IsysUser>>();
    reasonRepository = createMock<Repository<EquipDowntimeReason>>();
    eventRepository = createMock<Repository<OeeDowntimeEvent>>();
    eventRepository.findOne.mockResolvedValue(null);
    eventRepository.find.mockResolvedValue([]);
    dataSource.query.mockResolvedValue([
      {
        processCode: 'SMT',
        resourceType: 'LINE',
        lineCode: '01',
        lineName: 'Configured resource',
        parentLineCode: '01',
        activeYn: 'Y',
        mesDisplayYn: 'Y',
        sortOrder: 1,
      },
    ]);

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        OeeMobileService,
        { provide: getDataSourceToken(), useValue: dataSource },
        { provide: getRepositoryToken(IsysUser), useValue: userRepository },
        { provide: getRepositoryToken(EquipDowntimeReason), useValue: reasonRepository },
        { provide: getRepositoryToken(OeeDowntimeEvent), useValue: eventRepository },
      ],
    })
      .setLogger(new MockLoggerService())
      .compile();

    target = module.get<OeeMobileService>(OeeMobileService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('lists view rows with named binds and retains inactive/non-display resources', async () => {
    dataSource.query.mockResolvedValue([
      {
        processCode: 'SMT',
        resourceType: 'LINE',
        lineCode: '01',
        lineName: 'Canonical line',
        parentLineCode: '01',
        activeYn: 'Y',
        mesDisplayYn: 'Y',
        sortOrder: 1,
      },
      {
        processCode: 'SMT',
        resourceType: 'CELL',
        lineCode: '02',
        lineName: 'Inactive hidden cell',
        parentLineCode: ' 01 ',
        activeYn: 'N',
        mesDisplayYn: 'N',
        sortOrder: 2,
      },
    ]);

    const result = await target.listResources('SMT', 7, 'EUNSUNG', '1');
    const [sql, parameters] = dataSource.query.mock.calls[0] as [string, unknown];
    expect(sql).toContain('FROM V_OEE_PRODUCT_LINE v');
    expect(sql).toContain('v.ACTIVE_YN AS "activeYn"');
    expect(sql).toContain('v.MES_DISPLAY_YN AS "mesDisplayYn"');
    expect(sql).toContain('v.SORT_ORDER AS "sortOrder"');
    expect(sql).toContain('ORDER BY v.SORT_ORDER ASC NULLS LAST, v.LINE_CODE ASC');
    expect(sql).not.toMatch(/OEE_RESOURCE/i);
    expect(parameters).toEqual({ organizationId: 7, processCode: 'SMT' });
    expect(result).toEqual([
      {
        processCode: 'SMT',
        resourceType: 'LINE',
        lineCode: '01',
        lineName: 'Canonical line',
        parentLineCode: '01',
        activeYn: 'Y',
        mesDisplayYn: 'Y',
        sortOrder: 1,
      },
      {
        processCode: 'SMT',
        resourceType: 'CELL',
        lineCode: '02',
        lineName: 'Inactive hidden cell',
        parentLineCode: '01',
        activeYn: 'N',
        mesDisplayYn: 'N',
        sortOrder: 2,
      },
    ]);
  });

  it('queries assembly rows from the common view without legacy resource fields', async () => {
    dataSource.query.mockResolvedValue([
      {
        processCode: 'ASSY',
        resourceType: 'CELL',
        lineCode: '20',
        lineName: 'Wave 2라인',
        parentLineCode: null,
        activeYn: 'Y',
        mesDisplayYn: 'Y',
        sortOrder: 2,
      },
    ]);

    const result = await target.listResources('ASSY', 7, 'EUNSUNG', '1');
    expect(result).toEqual([
      {
        processCode: 'ASSY',
        resourceType: 'CELL',
        lineCode: '20',
        lineName: 'Wave 2라인',
        parentLineCode: '20',
        activeYn: 'Y',
        mesDisplayYn: 'Y',
        sortOrder: 2,
      },
    ]);
    expect(dataSource.query.mock.calls[0][1]).toEqual({
      organizationId: 7,
      processCode: 'ASSY',
    });
  });

  it('rejects incomplete tenant context before querying', async () => {
    await expect(target.listResources('SMT', undefined, 'EUNSUNG', '1')).rejects.toThrow(
      BadRequestException,
    );
    await expect(target.listResources('ASSY', 7, '', '1')).rejects.toThrow(BadRequestException);
    await expect(target.listResources('ASSY', 7, 'EUNSUNG', undefined)).rejects.toThrow(
      BadRequestException,
    );

    expect(dataSource.query).not.toHaveBeenCalled();
  });

  it('rejects an unsupported process code without falling back to a resource source', async () => {
    await expect(
      target.listResources('PROCESS_X' as 'SMT', 7, 'EUNSUNG', '1'),
    ).rejects.toThrow(BadRequestException);

    expect(dataSource.query).not.toHaveBeenCalled();
  });

  it('returns an empty list when no ASSY cells match the scoped contract', async () => {
    dataSource.query.mockResolvedValue([]);

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

  it('lists active PLAN and UNPLAN idle reasons from the authenticated organization in contract order', async () => {
    reasonRepository.find.mockResolvedValue([
      {
        reasonCode: 'U-NULL',
        reasonName: 'Unplanned without order',
        reasonType: 'UNPLAN',
        displayOrder: null,
        organizationId: 7,
        useYn: 'Y',
      },
      {
        reasonCode: 'P-02',
        reasonName: 'Planned second',
        reasonType: 'PLAN',
        displayOrder: 1,
        organizationId: 7,
        useYn: 'Y',
      },
      {
        reasonCode: 'P-01',
        reasonName: 'Planned first',
        reasonType: 'PLAN',
        displayOrder: 1,
        organizationId: 7,
        useYn: 'Y',
      },
      {
        reasonCode: 'P-NULL',
        reasonName: 'Planned without order',
        reasonType: 'PLAN',
        displayOrder: null,
        organizationId: 7,
        useYn: 'Y',
      },
      {
        reasonCode: 'U-01',
        reasonName: 'Unplanned first',
        reasonType: 'UNPLAN',
        displayOrder: 1,
        organizationId: 7,
        useYn: 'Y',
      },
      {
        reasonCode: 'NO-TYPE',
        reasonName: 'Missing type',
        reasonType: null,
        displayOrder: 1,
        organizationId: 7,
        useYn: 'Y',
      },
      {
        reasonCode: 'OTHER-TYPE',
        reasonName: 'Unsupported type',
        reasonType: 'OTHER',
        displayOrder: 1,
        organizationId: 7,
        useYn: 'Y',
      },
      {
        reasonCode: 'INACTIVE',
        reasonName: 'Inactive reason',
        reasonType: 'PLAN',
        displayOrder: 1,
        organizationId: 7,
        useYn: 'N',
      },
      {
        reasonCode: 'OTHER-ORG',
        reasonName: 'Other organization',
        reasonType: 'PLAN',
        displayOrder: 1,
        organizationId: 8,
        useYn: 'Y',
      },
    ] as EquipDowntimeReason[]);

    await expect(target.listReasons(7)).resolves.toEqual([
      { reasonCode: 'P-01', reasonName: 'Planned first', reasonType: 'PLAN', displayOrder: 1 },
      { reasonCode: 'P-02', reasonName: 'Planned second', reasonType: 'PLAN', displayOrder: 1 },
      {
        reasonCode: 'P-NULL',
        reasonName: 'Planned without order',
        reasonType: 'PLAN',
        displayOrder: Number.MAX_SAFE_INTEGER,
      },
      { reasonCode: 'U-01', reasonName: 'Unplanned first', reasonType: 'UNPLAN', displayOrder: 1 },
      {
        reasonCode: 'U-NULL',
        reasonName: 'Unplanned without order',
        reasonType: 'UNPLAN',
        displayOrder: Number.MAX_SAFE_INTEGER,
      },
    ]);

    const options = reasonRepository.find.mock.calls[0][0] as {
      where: Record<string, unknown>;
      order: Record<string, string>;
    };
    expect(options.where).toMatchObject({ organizationId: 7, useYn: 'Y' });
    expect(options.order).toEqual({ reasonType: 'ASC', displayOrder: 'ASC', reasonCode: 'ASC' });
  });

  it('allows both LINE and CELL resource types for either mobile process', async () => {
    dataSource.query
      .mockResolvedValueOnce([
        {
          processCode: 'SMT',
          resourceType: 'CELL',
          lineCode: '02',
          lineName: 'SMT cell',
          parentLineCode: '01',
          activeYn: 'Y',
          mesDisplayYn: 'Y',
          sortOrder: 1,
        },
      ])
      .mockResolvedValueOnce([
        {
          processCode: 'ASSY',
          resourceType: 'LINE',
          lineCode: '19',
          lineName: 'ASSY line',
          parentLineCode: null,
          activeYn: 'Y',
          mesDisplayYn: 'Y',
          sortOrder: 1,
        },
        {
          processCode: 'ASSY',
          resourceType: 'CELL',
          lineCode: '20',
          lineName: 'ASSY cell',
          parentLineCode: null,
          activeYn: 'Y',
          mesDisplayYn: 'Y',
          sortOrder: 2,
        },
      ]);

    await expect(target.listResources('SMT', 7, 'EUNSUNG', '1')).resolves.toEqual([
      {
        processCode: 'SMT',
        resourceType: 'CELL',
        lineCode: '02',
        lineName: 'SMT cell',
        parentLineCode: '01',
        activeYn: 'Y',
        mesDisplayYn: 'Y',
        sortOrder: 1,
      },
    ]);
    await expect(target.listResources('ASSY', 7, 'EUNSUNG', '1')).resolves.toEqual([
      {
        processCode: 'ASSY',
        resourceType: 'LINE',
        lineCode: '19',
        lineName: 'ASSY line',
        parentLineCode: '19',
        activeYn: 'Y',
        mesDisplayYn: 'Y',
        sortOrder: 1,
      },
      {
        processCode: 'ASSY',
        resourceType: 'CELL',
        lineCode: '20',
        lineName: 'ASSY cell',
        parentLineCode: '20',
        activeYn: 'Y',
        mesDisplayYn: 'Y',
        sortOrder: 2,
      },
    ]);
  });

  it('requires the configured reference for the exact process, type, and parent tuple', async () => {
    dataSource.query.mockResolvedValue([
      {
        processCode: 'SMT',
        resourceType: 'CELL',
        lineCode: '02',
        lineName: 'SMT cell',
        parentLineCode: '01',
        activeYn: 'Y',
        mesDisplayYn: 'Y',
        sortOrder: 1,
      },
    ]);

    const now = new Date('2026-08-07T08:30:00+09:00');
    jest.useFakeTimers().setSystemTime(now);
    try {

      await expect(
        target.getStatus('SMT', 'CELL', '02', '01', 7, 'EUNSUNG', '1'),
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
    dataSource.query.mockResolvedValue([
      {
        processCode,
        resourceType,
        lineCode: refCode,
        lineName: 'Configured resource',
        parentLineCode: refCode,
        activeYn: 'Y',
        mesDisplayYn: 'Y',
        sortOrder: 1,
      },
    ]);
    jest.useFakeTimers().setSystemTime(new Date('2026-08-07T08:30:00+09:00'));
    try {
      await expect(
        target.getStatus(processCode, resourceType, refCode, refCode, 7, 'EUNSUNG', '1'),
      ).resolves.toMatchObject({ state: 'RUNNING', workSegment: 'DAY' });
      expect(findOeeWorkContext).toHaveBeenCalledWith(dataSource, processCode, 7);
      expect(worktimeRangeType(processCode)).toBe(rangeType);
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
    dataSource.query.mockResolvedValue([
      {
        processCode: 'SMT',
        resourceType: 'LINE',
        lineCode: '01',
        lineName: 'A',
        parentLineCode: '01',
        activeYn: 'Y',
        mesDisplayYn: 'Y',
        sortOrder: 1,
      },
    ]);
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
    reasonRepository.findOne.mockResolvedValue(null);
    await expect(target.startDowntime(command, 7, 'EUNSUNG', '1', 'LOGIN01')).rejects.toThrow(
      NotFoundException,
    );

    reasonRepository.findOne.mockResolvedValue({
      reasonCode: 'A',
      reasonName: '정지',
      reasonType: 'PLAN',
      displayOrder: 1,
      organizationId: 7,
      useYn: 'Y',
    } as EquipDowntimeReason);
    jest.mocked(findOeeWorkContext).mockRejectedValueOnce(
      new BadRequestException('현재 업무시간 구간이 없습니다.'),
    );
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
      dataSource.query.mockResolvedValue([
        {
          processCode: 'SMT',
          resourceType: 'LINE',
          lineCode: '01',
          lineName: 'A',
          parentLineCode: '01',
          activeYn: 'Y',
          mesDisplayYn: 'Y',
          sortOrder: 1,
        },
      ]);
      eventRepository.findOne.mockResolvedValue(null);
      userRepository.findOne.mockResolvedValue({
        userId: 'WORKER01',
        organizationId: 7,
        userName: '작업자',
      } as IsysUser);
      reasonRepository.findOne.mockResolvedValue({
        reasonCode: 'A',
        reasonName: '정지',
        reasonType: 'PLAN',
        displayOrder: 1,
        organizationId: 7,
        useYn: 'Y',
      } as EquipDowntimeReason);
      eventRepository.create.mockImplementation(
        (value) => value as unknown as OeeDowntimeEvent,
      );
      eventRepository.save.mockResolvedValue(created);

      await expect(target.startDowntime(command, 7, 'EUNSUNG', '1', 'LOGIN01')).resolves.toEqual({
        event: created,
        replayed: false,
      });

      expect(reasonRepository.findOne).toHaveBeenCalledWith({
        where: { reasonCode: 'A', organizationId: 7, useYn: 'Y' },
      });

      const inserted = eventRepository.save.mock.calls[0][0] as OeeDowntimeEvent;
      expect(inserted).toMatchObject({
        organizationId: 7,
        resourceType: 'LINE',
        parentLineCode: '01',
        processCode: 'SMT',
        workSegment: 'DAY',
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

  it.each([
    ['inactive', { organizationId: 7, useYn: 'N', reasonType: 'PLAN' }],
    ['other organization', { organizationId: 8, useYn: 'Y', reasonType: 'PLAN' }],
    ['missing type', { organizationId: 7, useYn: 'Y', reasonType: null }],
    ['unsupported type', { organizationId: 7, useYn: 'Y', reasonType: 'OTHER' }],
  ] as const)('rejects a %s reason from the mobile start contract', async (_label, reasonFields) => {
    const command = {
      processCode: 'SMT',
      resourceType: 'LINE',
      resourceCode: '01',
      parentLineCode: '01',
      workerId: 'WORKER01',
      reasonCode: 'A',
      requestId: 'start-1',
    } as const;
    dataSource.query.mockResolvedValue([
      {
        processCode: 'SMT',
        resourceType: 'LINE',
        lineCode: '01',
        lineName: 'A',
        parentLineCode: '01',
        activeYn: 'Y',
        mesDisplayYn: 'Y',
        sortOrder: 1,
      },
    ]);
    userRepository.findOne.mockResolvedValue({ userId: 'WORKER01', organizationId: 7 } as IsysUser);
    reasonRepository.findOne.mockResolvedValue({
      reasonCode: 'A',
      reasonName: '정지',
      displayOrder: 1,
      ...reasonFields,
    } as EquipDowntimeReason);

    await expect(target.startDowntime(command, 7, 'EUNSUNG', '1', 'LOGIN01')).rejects.toThrow(
      NotFoundException,
    );
    expect(reasonRepository.findOne).toHaveBeenCalledWith({
      where: { reasonCode: 'A', organizationId: 7, useYn: 'Y' },
    });
    expect(eventRepository.create).not.toHaveBeenCalled();
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
      dataSource.query.mockResolvedValue([
        {
          processCode: 'SMT',
          resourceType: 'LINE',
          lineCode: '01',
          lineName: 'A',
          parentLineCode: '01',
          activeYn: 'Y',
          mesDisplayYn: 'Y',
          sortOrder: 1,
        },
      ]);
      userRepository.findOne.mockResolvedValue({ userId: 'WORKER01', organizationId: 7 } as IsysUser);
      reasonRepository.findOne.mockResolvedValue({
        reasonCode: 'A',
        reasonName: '정지',
        reasonType: 'PLAN',
        displayOrder: 1,
        organizationId: 7,
        useYn: 'Y',
      } as EquipDowntimeReason);

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
      dataSource.query.mockResolvedValue([
        {
          processCode: 'SMT',
          resourceType: 'LINE',
          lineCode: '01',
          lineName: 'A',
          parentLineCode: '01',
          activeYn: 'Y',
          mesDisplayYn: 'Y',
          sortOrder: 1,
        },
      ]);
      const openEvent = { eventId: 10, endTime: null } as OeeDowntimeEvent;
      eventRepository.find.mockResolvedValue([openEvent]);
      eventRepository.findOne.mockResolvedValue(openEvent);

      await expect(target.getStatus('SMT', 'LINE', '01', '01', 7, 'EUNSUNG', '1')).resolves.toEqual({
        workDate: '2026-08-07',
        workSegment: 'NIGHT',
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
      dataSource.query.mockResolvedValue([
        {
          processCode: 'SMT',
          resourceType: 'LINE',
          lineCode: '01',
          lineName: 'A',
          parentLineCode: '01',
          activeYn: 'Y',
          mesDisplayYn: 'Y',
          sortOrder: 1,
        },
      ]);
      userRepository.findOne.mockResolvedValue({ userId: 'WORKER01', organizationId: 7 } as IsysUser);
      reasonRepository.findOne.mockResolvedValue({
        reasonCode: 'A',
        reasonName: '정지',
        reasonType: 'PLAN',
        displayOrder: 1,
        organizationId: 7,
        useYn: 'Y',
      } as EquipDowntimeReason);
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
      dataSource.query.mockResolvedValue([
        {
          processCode: 'SMT',
          resourceType: 'LINE',
          lineCode: '01',
          lineName: 'A',
          parentLineCode: '01',
          activeYn: 'Y',
          mesDisplayYn: 'Y',
          sortOrder: 1,
        },
      ]);
      userRepository.findOne.mockResolvedValue({ userId: 'WORKER01', organizationId: 7 } as IsysUser);
      reasonRepository.findOne.mockResolvedValue({
        reasonCode: 'A',
        reasonName: '정지',
        reasonType: 'PLAN',
        displayOrder: 1,
        organizationId: 7,
        useYn: 'Y',
      } as EquipDowntimeReason);
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

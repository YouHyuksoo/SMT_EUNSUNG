import { Test } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { ConflictException } from '@nestjs/common';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { Repository } from 'typeorm';
import { ProductCompanyCalendar } from '../../../entities/product-company-calendar.entity';
import { ProductLineCalendar } from '../../../entities/product-line-calendar.entity';
import { ShiftTimeMaster } from '../../../entities/shift-time-master.entity';
import { ShiftTimeService } from './shift-time.service';
import { WorkCalendarService } from './work-calendar.service';

const SHIFT = {
  organizationId: 1,
  dateset: new Date('2026-01-01T00:00:00'),
  dateend: null,
  dayTimeStart: '08:00',
  dayTimeEnd: '20:00',
  dayBreakMinutes: 60,
  nightTimeStart: '20:00',
  nightTimeEnd: '08:00',
  nightBreakMinutes: 60,
} as ShiftTimeMaster;

describe('WorkCalendarService', () => {
  let target: WorkCalendarService;
  let companyRepo: DeepMocked<Repository<ProductCompanyCalendar>>;
  let lineRepo: DeepMocked<Repository<ProductLineCalendar>>;
  let shiftTime: DeepMocked<ShiftTimeService>;

  beforeEach(async () => {
    companyRepo = createMock<Repository<ProductCompanyCalendar>>();
    lineRepo = createMock<Repository<ProductLineCalendar>>();
    shiftTime = createMock<ShiftTimeService>();
    shiftTime.findAll.mockResolvedValue([SHIFT]);
    shiftTime.resolveFromRows.mockReturnValue(SHIFT);

    const moduleRef = await Test.createTestingModule({
      providers: [
        WorkCalendarService,
        { provide: getRepositoryToken(ProductCompanyCalendar), useValue: companyRepo },
        { provide: getRepositoryToken(ProductLineCalendar), useValue: lineRepo },
        { provide: ShiftTimeService, useValue: shiftTime },
      ],
    }).compile();
    target = moduleRef.get(WorkCalendarService);
  });

  const companyRow = (date: string, dayType: string, confirmYn = 'N') =>
    ({
      planDate: new Date(`${date}T00:00:00`),
      organizationId: 1,
      dayType,
      holidayYn: dayType === 'OFF' ? 'Y' : 'N',
      offReason: dayType === 'OFF' ? 'WEEKEND' : null,
      workMinutes: dayType === 'OFF' ? 0 : 1320,
      otMinutes: 0,
      confirmYn,
      calendarComment: null,
    }) as ProductCompanyCalendar;

  describe('findDays — 전사 + 라인 예외 병합', () => {
    it('라인 예외 행이 전사 행을 덮어쓴다', async () => {
      companyRepo.find.mockResolvedValue([companyRow('2026-07-14', 'WORK')]);
      lineRepo.find.mockResolvedValue([
        {
          planDate: new Date('2026-07-14T00:00:00'),
          organizationId: 1,
          lineCode: 'L1',
          dayType: 'OFF',
          holidayYn: 'Y',
          offReason: 'LINE_STOP',
          workMinutes: 0,
          otMinutes: 0,
          confirmYn: 'N',
          calendarComment: null,
        } as ProductLineCalendar,
      ]);

      const days = await target.findDays({ month: '2026-07', lineCode: 'L1' }, 1);
      const day = days.find((d) => d.workDate === '2026-07-14');
      expect(day?.dayType).toBe('OFF');
      expect(day?.source).toBe('LINE');
    });

    it('라인 예외가 없으면 전사 행이 그대로 보이고 source=COMPANY', async () => {
      companyRepo.find.mockResolvedValue([companyRow('2026-07-14', 'WORK')]);
      lineRepo.find.mockResolvedValue([]);

      const days = await target.findDays({ month: '2026-07', lineCode: 'L1' }, 1);
      const day = days.find((d) => d.workDate === '2026-07-14');
      expect(day?.dayType).toBe('WORK');
      expect(day?.source).toBe('COMPANY');
    });

    it('lineCode가 없으면 라인 테이블을 조회하지 않는다', async () => {
      companyRepo.find.mockResolvedValue([companyRow('2026-07-14', 'WORK')]);
      await target.findDays({ month: '2026-07' }, 1);
      expect(lineRepo.find).not.toHaveBeenCalled();
    });
  });

  describe('generateYear', () => {
    it('토/일 미근무면 OFF/WEEKEND로 생성한다', async () => {
      companyRepo.find.mockResolvedValue([]);

      await target.generateYear({ year: '2026', saturdayWork: false, sundayWork: false }, 1);

      const saved = companyRepo.insert.mock.calls[0][0] as ProductCompanyCalendar[];
      // 2026-01-03은 토요일
      const sat = saved.find((d) => d.planDate.getTime() === new Date('2026-01-03T00:00:00').getTime());
      expect(sat?.dayType).toBe('OFF');
      expect(sat?.offReason).toBe('WEEKEND');
      expect(sat?.workMinutes).toBe(0);
      expect(sat?.holidayYn).toBe('Y');
    });

    it('양력 고정공휴일은 OFF/HOLIDAY로 생성한다', async () => {
      companyRepo.find.mockResolvedValue([]);

      await target.generateYear({ year: '2026', saturdayWork: true, sundayWork: true }, 1);

      const saved = companyRepo.insert.mock.calls[0][0] as ProductCompanyCalendar[];
      const day = saved.find((d) => d.planDate.getTime() === new Date('2026-03-01T00:00:00').getTime());
      expect(day?.dayType).toBe('OFF');
      expect(day?.offReason).toBe('HOLIDAY');
    });

    it('평일은 WORK이고 근무분은 교대시간에서 파생된다 (주간660+야간660=1320)', async () => {
      companyRepo.find.mockResolvedValue([]);

      await target.generateYear({ year: '2026', applyHolidays: false }, 1);

      const saved = companyRepo.insert.mock.calls[0][0] as ProductCompanyCalendar[];
      // 2026-07-14는 화요일
      const day = saved.find((d) => d.planDate.getTime() === new Date('2026-07-14T00:00:00').getTime());
      expect(day?.dayType).toBe('WORK');
      expect(day?.workMinutes).toBe(1320);
      expect(day?.holidayYn).toBe('N');
    });

    it('확정된 일자가 하나라도 있으면 409로 거부한다', async () => {
      companyRepo.find.mockResolvedValue([companyRow('2026-07-14', 'WORK', 'Y')]);
      await expect(target.generateYear({ year: '2026' }, 1)).rejects.toBeInstanceOf(ConflictException);
      expect(companyRepo.delete).not.toHaveBeenCalled();
      expect(companyRepo.insert).not.toHaveBeenCalled();
    });

    it('이미 해당 연도 행이 존재해도(재생성) save() upsert가 아니라 delete 후 insert로 덮어쓴다 (PK 충돌 회귀 방지)', async () => {
      // find()는 ensureNotConfirmed에서만 쓰인다 — 이미 365행이 있다고 가정해도 확정된 행이
      // 없으면 재생성은 항상 허용되어야 한다. repo.save()를 다시 쓰면 이 시나리오에서
      // ORA-00001(XPKIP_PRODUCT_COMPANY_CALENDAR)이 재현된다.
      companyRepo.find.mockResolvedValue([companyRow('2026-07-14', 'WORK', 'N')]);

      await target.generateYear({ year: '2026' }, 1);

      expect(companyRepo.delete).toHaveBeenCalledTimes(1);
      expect(companyRepo.save).not.toHaveBeenCalled();
      expect(companyRepo.insert).toHaveBeenCalledTimes(1);
      // delete가 insert보다 먼저 호출되어야 한다 (덮어쓰기 순서)
      const deleteOrder = companyRepo.delete.mock.invocationCallOrder[0];
      const insertOrder = companyRepo.insert.mock.invocationCallOrder[0];
      expect(deleteOrder).toBeLessThan(insertOrder);
      const insertedRows = companyRepo.insert.mock.calls[0][0] as ProductCompanyCalendar[];
      expect(insertedRows.length).toBe(365);
    });

    it('365일 생성 중 교대시간 rows는 요청당 1회만 불러온다 (일자마다 재조회 금지)', async () => {
      companyRepo.find.mockResolvedValue([]);

      await target.generateYear({ year: '2026' }, 1);

      expect(shiftTime.findAll).toHaveBeenCalledTimes(1);
      expect(shiftTime.resolveForDate).not.toHaveBeenCalled();
    });

    it('ENTER_BY/LAST_MODIFY_BY에 호출자 userId를 채운다 (NOT NULL 컬럼이라 비면 ORA-01400)', async () => {
      companyRepo.find.mockResolvedValue([]);

      await target.generateYear({ year: '2026' }, 1, 'HONG');

      const saved = companyRepo.insert.mock.calls[0][0] as ProductCompanyCalendar[];
      expect(saved.length).toBeGreaterThan(0);
      expect(saved.every((d) => d.enterBy === 'HONG')).toBe(true);
      expect(saved.every((d) => d.lastModifyBy === 'HONG')).toBe(true);
    });

    it('userId가 없으면 ENTER_BY/LAST_MODIFY_BY를 SYSTEM으로 채운다', async () => {
      companyRepo.find.mockResolvedValue([]);

      await target.generateYear({ year: '2026' }, 1);

      const saved = companyRepo.insert.mock.calls[0][0] as ProductCompanyCalendar[];
      expect(saved.every((d) => d.enterBy === 'SYSTEM')).toBe(true);
      expect(saved.every((d) => d.lastModifyBy === 'SYSTEM')).toBe(true);
    });

    it('ENTER_DATE/LAST_MODIFY_DATE를 채운다 (NOT NULL 컬럼이라 비면 ORA-01400)', async () => {
      companyRepo.find.mockResolvedValue([]);

      await target.generateYear({ year: '2026' }, 1);

      const saved = companyRepo.insert.mock.calls[0][0] as ProductCompanyCalendar[];
      expect(saved.length).toBeGreaterThan(0);
      expect(saved.every((d) => d.enterDate instanceof Date)).toBe(true);
      expect(saved.every((d) => d.lastModifyDate instanceof Date)).toBe(true);
    });
  });

  describe('bulkUpdateDays', () => {
    it('확정된 일자를 수정하려 하면 409', async () => {
      companyRepo.find.mockResolvedValue([companyRow('2026-07-14', 'WORK', 'Y')]);
      await expect(
        target.bulkUpdateDays({ days: [{ workDate: '2026-07-14', dayType: 'OFF' }] }, 1),
      ).rejects.toBeInstanceOf(ConflictException);
    });

    it('workMinutes 미지정이면 dayType에서 파생시킨다', async () => {
      companyRepo.find.mockResolvedValue([]);

      await target.bulkUpdateDays({ days: [{ workDate: '2026-07-14', dayType: 'HALF' }] }, 1);

      const saved = companyRepo.insert.mock.calls[0][0] as ProductCompanyCalendar[];
      expect(saved[0].workMinutes).toBe(330); // 주간 660 ÷ 2
    });

    it('workMinutes를 명시하면 그 값을 그대로 저장한다 (override)', async () => {
      companyRepo.find.mockResolvedValue([]);

      await target.bulkUpdateDays(
        { days: [{ workDate: '2026-07-14', dayType: 'WORK', workMinutes: 480 }] },
        1,
      );

      const saved = companyRepo.insert.mock.calls[0][0] as ProductCompanyCalendar[];
      expect(saved[0].workMinutes).toBe(480);
    });

    it('OFF가 아니면 offReason을 null로 강제한다', async () => {
      companyRepo.find.mockResolvedValue([]);

      await target.bulkUpdateDays(
        { days: [{ workDate: '2026-07-14', dayType: 'WORK', offReason: 'WEEKEND' }] },
        1,
      );

      const saved = companyRepo.insert.mock.calls[0][0] as ProductCompanyCalendar[];
      expect(saved[0].offReason).toBeNull();
      expect(saved[0].holidayYn).toBe('N');
    });

    it('ENTER_BY/LAST_MODIFY_BY에 호출자 userId를 채운다', async () => {
      companyRepo.find.mockResolvedValue([]);

      await target.bulkUpdateDays(
        { days: [{ workDate: '2026-07-14', dayType: 'WORK' }] },
        1,
        'HONG',
      );

      const saved = companyRepo.insert.mock.calls[0][0] as ProductCompanyCalendar[];
      expect(saved[0].enterBy).toBe('HONG');
      expect(saved[0].lastModifyBy).toBe('HONG');
    });

    it('ENTER_DATE/LAST_MODIFY_DATE를 채운다 (NOT NULL 컬럼이라 비면 ORA-01400)', async () => {
      companyRepo.find.mockResolvedValue([]);

      await target.bulkUpdateDays(
        { days: [{ workDate: '2026-07-14', dayType: 'WORK' }] },
        1,
      );

      const saved = companyRepo.insert.mock.calls[0][0] as ProductCompanyCalendar[];
      expect(saved[0].enterDate).toBeInstanceOf(Date);
      expect(saved[0].lastModifyDate).toBeInstanceOf(Date);
    });

    it('이미 존재하는 날짜를 수정해도 save() upsert가 아니라 delete 후 insert로 덮어쓴다 (PK 충돌 회귀 방지)', async () => {
      // find()는 ensureNotConfirmed에서만 쓰인다 — 이미 해당 날짜에 행이 있어도(확정 전) 수정은
      // 항상 허용되어야 한다. repo.save()를 다시 쓰면 이 시나리오에서 ORA-00001이 재현된다.
      companyRepo.find.mockResolvedValue([companyRow('2026-07-14', 'WORK', 'N')]);

      await target.bulkUpdateDays({ days: [{ workDate: '2026-07-14', dayType: 'HALF' }] }, 1);

      expect(companyRepo.delete).toHaveBeenCalledWith(
        expect.objectContaining({ organizationId: 1 }),
      );
      expect(companyRepo.save).not.toHaveBeenCalled();
      expect(companyRepo.insert).toHaveBeenCalledTimes(1);
      const deleteOrder = companyRepo.delete.mock.invocationCallOrder[0];
      const insertOrder = companyRepo.insert.mock.invocationCallOrder[0];
      expect(deleteOrder).toBeLessThan(insertOrder);
    });
  });

  describe('confirm/unconfirm', () => {
    // setConfirm()은 find()로 불러온 뒤 save(rows)로 되돌려 쓰지 않는다. find()가 반환하는
    // PLAN_DATE는 Oracle 드라이버가 이미 문자열('YYYY-MM-DD')로 hydrate해 두는데, save()가
    // 저장 전 재확인차 날리는 내부 SELECT가 그 문자열을 TO_DATE 없이 그대로 재바인딩하면서
    // 세션 NLS_DATE_FORMAT과 맞지 않아 ORA-01861(literal does not match format string)을 낸다.
    // repo.update(criteria, partial)로 CONFIRM_YN/감사 컬럼만 직접 UPDATE해 이 경로를 피한다.

    it('확정 시 update()로 CONFIRM_YN=Y와 LAST_MODIFY_BY/LAST_MODIFY_DATE만 UPDATE한다', async () => {
      companyRepo.update.mockResolvedValue({ affected: 1, raw: [], generatedMaps: [] });

      const count = await target.confirm({ year: '2026' }, 1, 'HONG');

      expect(companyRepo.save).not.toHaveBeenCalled();
      expect(companyRepo.find).not.toHaveBeenCalled();
      expect(companyRepo.update).toHaveBeenCalledTimes(1);
      const [criteria, partial] = companyRepo.update.mock.calls[0];
      expect(criteria).toEqual(expect.objectContaining({ organizationId: 1 }));
      expect(partial).toEqual({
        confirmYn: 'Y',
        lastModifyBy: 'HONG',
        lastModifyDate: expect.any(Date),
      });
      expect(count).toBe(1);
    });

    it('확정취소 시 update()로 CONFIRM_YN을 N으로 되돌린다', async () => {
      companyRepo.update.mockResolvedValue({ affected: 3, raw: [], generatedMaps: [] });

      const count = await target.unconfirm({ year: '2026', month: 3 }, 1, 'HONG');

      const [, partial] = companyRepo.update.mock.calls[0];
      expect(partial).toEqual(
        expect.objectContaining({ confirmYn: 'N', lastModifyBy: 'HONG' }),
      );
      expect(count).toBe(3);
    });

    it('확정/확정취소는 ENTER_DATE/ENTER_BY를 건드리지 않는다 (원본 생성시각 보존을 partial에서 구조적으로 보장)', async () => {
      companyRepo.update.mockResolvedValue({ affected: 1, raw: [], generatedMaps: [] });

      await target.confirm({ year: '2026' }, 1, 'HONG');

      const [, partial] = companyRepo.update.mock.calls[0];
      expect(partial).not.toHaveProperty('enterDate');
      expect(partial).not.toHaveProperty('enterBy');
    });

    it('라인 월력 확정은 lineRepo.update를 쓴다', async () => {
      lineRepo.update.mockResolvedValue({ affected: 1, raw: [], generatedMaps: [] });

      await target.confirm({ year: '2026', lineCode: 'L1' }, 1, 'HONG');

      expect(lineRepo.update).toHaveBeenCalledTimes(1);
      expect(companyRepo.update).not.toHaveBeenCalled();
      const [criteria] = lineRepo.update.mock.calls[0];
      expect(criteria).toEqual(expect.objectContaining({ organizationId: 1, lineCode: 'L1' }));
    });
  });

  describe('copyFromCompany', () => {
    it('라인 월력에 ENTER_BY/LAST_MODIFY_BY를 채운다', async () => {
      companyRepo.find.mockResolvedValue([companyRow('2026-07-14', 'WORK')]);
      lineRepo.find.mockResolvedValue([]); // ensureNotConfirmed가 lineCode 지정 시 라인 테이블을 조회한다
      lineRepo.create.mockImplementation((v) => v as ProductLineCalendar);

      await target.copyFromCompany({ year: '2026', lineCode: 'L1' }, 1, 'HONG');

      const saved = lineRepo.insert.mock.calls[0][0] as ProductLineCalendar[];
      expect(saved[0].enterBy).toBe('HONG');
      expect(saved[0].lastModifyBy).toBe('HONG');
    });

    it('라인 월력에 ENTER_DATE/LAST_MODIFY_DATE를 채운다 (NOT NULL 컬럼이라 비면 ORA-01400)', async () => {
      companyRepo.find.mockResolvedValue([companyRow('2026-07-14', 'WORK')]);
      lineRepo.find.mockResolvedValue([]);
      lineRepo.create.mockImplementation((v) => v as ProductLineCalendar);

      await target.copyFromCompany({ year: '2026', lineCode: 'L1' }, 1, 'HONG');

      const saved = lineRepo.insert.mock.calls[0][0] as ProductLineCalendar[];
      expect(saved[0].enterDate).toBeInstanceOf(Date);
      expect(saved[0].lastModifyDate).toBeInstanceOf(Date);
    });

    it('전사 월력이 비어있으면 409로 거부한다', async () => {
      companyRepo.find.mockResolvedValue([]);
      lineRepo.find.mockResolvedValue([]);

      await expect(
        target.copyFromCompany({ year: '2026', lineCode: 'L1' }, 1),
      ).rejects.toBeInstanceOf(ConflictException);
      expect(lineRepo.delete).not.toHaveBeenCalled();
      expect(lineRepo.insert).not.toHaveBeenCalled();
    });

    it('확정된 라인 일자가 있으면 409로 거부하고 복사를 시도하지 않는다', async () => {
      lineRepo.find.mockResolvedValue([
        { ...companyRow('2026-07-14', 'WORK', 'Y'), lineCode: 'L1' } as unknown as ProductLineCalendar,
      ]);

      await expect(
        target.copyFromCompany({ year: '2026', lineCode: 'L1' }, 1),
      ).rejects.toBeInstanceOf(ConflictException);
      expect(companyRepo.find).not.toHaveBeenCalled();
      expect(lineRepo.delete).not.toHaveBeenCalled();
      expect(lineRepo.insert).not.toHaveBeenCalled();
    });

    it('이미 해당 라인/연도 행이 존재해도(재복사) save() upsert가 아니라 delete 후 insert로 덮어쓴다 (PK 충돌 회귀 방지)', async () => {
      // find()는 ensureNotConfirmed에서만 쓰인다 — 이미 라인에 예외 행이 있어도(확정 전) 재복사는
      // 항상 허용되어야 한다. repo.save()를 다시 쓰면 이 시나리오에서
      // ORA-00001(XPKIP_PRODUCT_LINE_CALENDAR)이 재현된다.
      companyRepo.find.mockResolvedValue([companyRow('2026-07-14', 'WORK')]);
      lineRepo.find.mockResolvedValue([
        { ...companyRow('2026-07-14', 'WORK', 'N'), lineCode: 'L1' } as unknown as ProductLineCalendar,
      ]);
      lineRepo.create.mockImplementation((v) => v as ProductLineCalendar);

      await target.copyFromCompany({ year: '2026', lineCode: 'L1' }, 1);

      expect(lineRepo.delete).toHaveBeenCalledTimes(1);
      expect(lineRepo.save).not.toHaveBeenCalled();
      expect(lineRepo.insert).toHaveBeenCalledTimes(1);
      // delete가 insert보다 먼저 호출되어야 한다 (덮어쓰기 순서)
      const deleteOrder = lineRepo.delete.mock.invocationCallOrder[0];
      const insertOrder = lineRepo.insert.mock.invocationCallOrder[0];
      expect(deleteOrder).toBeLessThan(insertOrder);
      const insertedRows = lineRepo.insert.mock.calls[0][0] as ProductLineCalendar[];
      expect(insertedRows.length).toBe(1);
      expect(insertedRows[0].lineCode).toBe('L1');
    });
  });
});

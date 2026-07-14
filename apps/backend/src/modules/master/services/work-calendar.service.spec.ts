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
    shiftTime.resolveForDate.mockResolvedValue(SHIFT);

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
      companyRepo.save.mockImplementation(async (v) => v as ProductCompanyCalendar);

      await target.generateYear({ year: '2026', saturdayWork: false, sundayWork: false }, 1);

      const saved = companyRepo.save.mock.calls[0][0] as ProductCompanyCalendar[];
      // 2026-01-03은 토요일
      const sat = saved.find((d) => d.planDate.getTime() === new Date('2026-01-03T00:00:00').getTime());
      expect(sat?.dayType).toBe('OFF');
      expect(sat?.offReason).toBe('WEEKEND');
      expect(sat?.workMinutes).toBe(0);
      expect(sat?.holidayYn).toBe('Y');
    });

    it('양력 고정공휴일은 OFF/HOLIDAY로 생성한다', async () => {
      companyRepo.find.mockResolvedValue([]);
      companyRepo.save.mockImplementation(async (v) => v as ProductCompanyCalendar);

      await target.generateYear({ year: '2026', saturdayWork: true, sundayWork: true }, 1);

      const saved = companyRepo.save.mock.calls[0][0] as ProductCompanyCalendar[];
      const day = saved.find((d) => d.planDate.getTime() === new Date('2026-03-01T00:00:00').getTime());
      expect(day?.dayType).toBe('OFF');
      expect(day?.offReason).toBe('HOLIDAY');
    });

    it('평일은 WORK이고 근무분은 교대시간에서 파생된다 (주간660+야간660=1320)', async () => {
      companyRepo.find.mockResolvedValue([]);
      companyRepo.save.mockImplementation(async (v) => v as ProductCompanyCalendar);

      await target.generateYear({ year: '2026', applyHolidays: false }, 1);

      const saved = companyRepo.save.mock.calls[0][0] as ProductCompanyCalendar[];
      // 2026-07-14는 화요일
      const day = saved.find((d) => d.planDate.getTime() === new Date('2026-07-14T00:00:00').getTime());
      expect(day?.dayType).toBe('WORK');
      expect(day?.workMinutes).toBe(1320);
      expect(day?.holidayYn).toBe('N');
    });

    it('확정된 일자가 하나라도 있으면 409로 거부한다', async () => {
      companyRepo.find.mockResolvedValue([companyRow('2026-07-14', 'WORK', 'Y')]);
      await expect(target.generateYear({ year: '2026' }, 1)).rejects.toBeInstanceOf(ConflictException);
      expect(companyRepo.save).not.toHaveBeenCalled();
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
      companyRepo.save.mockImplementation(async (v) => v as ProductCompanyCalendar);

      await target.bulkUpdateDays({ days: [{ workDate: '2026-07-14', dayType: 'HALF' }] }, 1);

      const saved = companyRepo.save.mock.calls[0][0] as ProductCompanyCalendar[];
      expect(saved[0].workMinutes).toBe(330); // 주간 660 ÷ 2
    });

    it('workMinutes를 명시하면 그 값을 그대로 저장한다 (override)', async () => {
      companyRepo.find.mockResolvedValue([]);
      companyRepo.save.mockImplementation(async (v) => v as ProductCompanyCalendar);

      await target.bulkUpdateDays(
        { days: [{ workDate: '2026-07-14', dayType: 'WORK', workMinutes: 480 }] },
        1,
      );

      const saved = companyRepo.save.mock.calls[0][0] as ProductCompanyCalendar[];
      expect(saved[0].workMinutes).toBe(480);
    });

    it('OFF가 아니면 offReason을 null로 강제한다', async () => {
      companyRepo.find.mockResolvedValue([]);
      companyRepo.save.mockImplementation(async (v) => v as ProductCompanyCalendar);

      await target.bulkUpdateDays(
        { days: [{ workDate: '2026-07-14', dayType: 'WORK', offReason: 'WEEKEND' }] },
        1,
      );

      const saved = companyRepo.save.mock.calls[0][0] as ProductCompanyCalendar[];
      expect(saved[0].offReason).toBeNull();
      expect(saved[0].holidayYn).toBe('N');
    });
  });
});

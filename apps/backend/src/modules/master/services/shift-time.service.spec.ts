import { Test } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { Repository } from 'typeorm';
import { ShiftTimeMaster } from '../../../entities/shift-time-master.entity';
import { ShiftTimeService } from './shift-time.service';
import { UpdateShiftTimeDto } from '../dto/work-calendar.dto';

describe('ShiftTimeService', () => {
  let target: ShiftTimeService;
  let repo: DeepMocked<Repository<ShiftTimeMaster>>;

  const row = (dateset: string, dateend: string | null): ShiftTimeMaster =>
    ({
      organizationId: 1,
      dateset: new Date(`${dateset}T00:00:00`),
      dateend: dateend ? new Date(`${dateend}T00:00:00`) : null,
      dayTimeStart: '08:00',
      dayTimeEnd: '20:00',
      dayBreakMinutes: 60,
      nightTimeStart: '20:00',
      nightTimeEnd: '08:00',
      nightBreakMinutes: 60,
    }) as ShiftTimeMaster;

  beforeEach(async () => {
    repo = createMock<Repository<ShiftTimeMaster>>();
    const moduleRef = await Test.createTestingModule({
      providers: [
        ShiftTimeService,
        { provide: getRepositoryToken(ShiftTimeMaster), useValue: repo },
      ],
    }).compile();
    target = moduleRef.get(ShiftTimeService);
  });

  describe('resolveForDate', () => {
    it('유효기간에 들어가는 행을 고른다', async () => {
      repo.find.mockResolvedValue([row('2026-01-01', '2026-06-30'), row('2026-07-01', null)]);
      const found = await target.resolveForDate('2026-07-14', 1);
      expect(found?.dateset).toEqual(new Date('2026-07-01T00:00:00'));
    });

    it('DATEEND가 null이면 무기한으로 본다', async () => {
      repo.find.mockResolvedValue([row('2026-07-01', null)]);
      expect(await target.resolveForDate('2030-01-01', 1)).not.toBeNull();
    });

    it('어떤 구간에도 안 들어가면 null', async () => {
      repo.find.mockResolvedValue([row('2026-01-01', '2026-06-30')]);
      expect(await target.resolveForDate('2026-07-14', 1)).toBeNull();
    });
  });

  describe('create', () => {
    it('유효기간이 겹치면 409', async () => {
      repo.find.mockResolvedValue([row('2026-01-01', null)]);
      await expect(
        target.create({ dateset: '2026-07-01', dayTimeStart: '08:00', dayTimeEnd: '20:00' }, 1),
      ).rejects.toBeInstanceOf(ConflictException);
    });

    it('겹치지 않으면 저장한다', async () => {
      repo.find.mockResolvedValue([row('2026-01-01', '2026-06-30')]);
      repo.create.mockImplementation((v) => v as ShiftTimeMaster);
      repo.save.mockImplementation(async (v) => v as ShiftTimeMaster);
      const saved = await target.create(
        { dateset: '2026-07-01', dayTimeStart: '08:00', dayTimeEnd: '20:00' },
        1,
      );
      expect(saved.organizationId).toBe(1);
      expect(repo.save).toHaveBeenCalledTimes(1);
    });

    it('ENTER_BY/LAST_MODIFY_BY에 호출자 userId를 채운다', async () => {
      repo.find.mockResolvedValue([]);
      repo.create.mockImplementation((v) => v as ShiftTimeMaster);
      repo.save.mockImplementation(async (v) => v as ShiftTimeMaster);

      const saved = await target.create(
        { dateset: '2026-07-01', dayTimeStart: '08:00', dayTimeEnd: '20:00' },
        1,
        'HONG',
      );

      expect(saved.enterBy).toBe('HONG');
      expect(saved.lastModifyBy).toBe('HONG');
    });

    it('userId가 없으면 ENTER_BY/LAST_MODIFY_BY를 SYSTEM으로 채운다', async () => {
      repo.find.mockResolvedValue([]);
      repo.create.mockImplementation((v) => v as ShiftTimeMaster);
      repo.save.mockImplementation(async (v) => v as ShiftTimeMaster);

      const saved = await target.create(
        { dateset: '2026-07-01', dayTimeStart: '08:00', dayTimeEnd: '20:00' },
        1,
      );

      expect(saved.enterBy).toBe('SYSTEM');
      expect(saved.lastModifyBy).toBe('SYSTEM');
    });
  });

  describe('update', () => {
    it('없는 행이면 404', async () => {
      repo.findOne.mockResolvedValue(null);
      await expect(target.update('2026-07-01', {}, 1)).rejects.toBeInstanceOf(NotFoundException);
    });

    it('dateend가 dto에 없으면(undefined) 기존 값을 유지한다', async () => {
      const existing = row('2026-07-01', '2026-12-31');
      repo.findOne.mockResolvedValue(existing);
      repo.find.mockResolvedValue([existing]);
      repo.save.mockImplementation(async (v) => v as ShiftTimeMaster);

      const saved = await target.update('2026-07-01', { dayTimeStart: '09:00' }, 1);

      expect(saved.dateend).toEqual(new Date('2026-12-31T00:00:00'));
    });

    it('dateend: null이면 무기한으로 변경한다', async () => {
      const existing = row('2026-07-01', '2026-12-31');
      repo.findOne.mockResolvedValue(existing);
      repo.find.mockResolvedValue([existing]);
      repo.save.mockImplementation(async (v) => v as ShiftTimeMaster);

      // UpdateShiftTimeDto.dateend는 타입상 string|undefined지만, 컨트롤러는 바디를 그대로 넘기므로
      // 실제 런타임에는 무기한 해제를 위한 null이 들어온다. DTO/서비스는 변경 대상이 아니므로 브리지 캐스팅.
      const saved = await target.update(
        '2026-07-01',
        { dateend: null } as unknown as UpdateShiftTimeDto,
        1,
      );

      expect(saved.dateend).toBeNull();
    });

    it("dateend: '2026-12-31'이면 해당 값으로 설정한다", async () => {
      const existing = row('2026-07-01', null);
      repo.findOne.mockResolvedValue(existing);
      repo.find.mockResolvedValue([existing]);
      repo.save.mockImplementation(async (v) => v as ShiftTimeMaster);

      const saved = await target.update('2026-07-01', { dateend: '2026-12-31' }, 1);

      expect(saved.dateend).toEqual(new Date('2026-12-31T00:00:00'));
    });

    it('확장한 구간이 인접 구간과 겹치면 409이고 저장하지 않는다', async () => {
      const existing = row('2026-07-01', '2026-07-31');
      const neighbour = row('2026-08-01', null);
      repo.findOne.mockResolvedValue(existing);
      repo.find.mockResolvedValue([existing, neighbour]);

      await expect(
        target.update('2026-07-01', { dateend: '2026-08-15' }, 1),
      ).rejects.toBeInstanceOf(ConflictException);
      expect(repo.save).not.toHaveBeenCalled();
    });

    it('겹치지 않는 확장은 저장되며, 자기 자신의 dateset과는 겹침으로 판정하지 않는다', async () => {
      const existing = row('2026-07-01', '2026-07-31');
      repo.findOne.mockResolvedValue(existing);
      repo.find.mockResolvedValue([existing]);
      repo.save.mockImplementation(async (v) => v as ShiftTimeMaster);

      const saved = await target.update('2026-07-01', { dateend: '2026-09-30' }, 1);

      expect(saved.dateend).toEqual(new Date('2026-09-30T00:00:00'));
      expect(repo.save).toHaveBeenCalledTimes(1);
    });

    it('dto에 있는 교대시간 필드만 적용되고 나머지는 유지된다', async () => {
      const existing = row('2026-07-01', null);
      repo.findOne.mockResolvedValue(existing);
      repo.find.mockResolvedValue([existing]);
      repo.save.mockImplementation(async (v) => v as ShiftTimeMaster);

      const saved = await target.update('2026-07-01', { dayTimeStart: '09:00' }, 1);

      expect(saved.dayTimeStart).toBe('09:00');
      expect(saved.dayTimeEnd).toBe('20:00');
      expect(saved.dayBreakMinutes).toBe(60);
      expect(saved.nightTimeStart).toBe('20:00');
      expect(saved.nightTimeEnd).toBe('08:00');
      expect(saved.nightBreakMinutes).toBe(60);
    });

    it('LAST_MODIFY_BY/LAST_MODIFY_DATE를 호출자 userId로 갱신한다', async () => {
      const existing = row('2026-07-01', null);
      repo.findOne.mockResolvedValue(existing);
      repo.find.mockResolvedValue([existing]);
      repo.save.mockImplementation(async (v) => v as ShiftTimeMaster);

      const saved = await target.update('2026-07-01', { dayTimeStart: '09:00' }, 1, 'HONG');

      expect(saved.lastModifyBy).toBe('HONG');
      expect(saved.lastModifyDate).toBeInstanceOf(Date);
    });
  });

  describe('remove', () => {
    it('없는 행이면 404', async () => {
      repo.findOne.mockResolvedValue(null);
      await expect(target.remove('2026-07-01', 1)).rejects.toBeInstanceOf(NotFoundException);
    });
  });
});

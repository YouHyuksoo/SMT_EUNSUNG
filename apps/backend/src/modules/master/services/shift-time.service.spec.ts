import { Test } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { Repository } from 'typeorm';
import { ShiftTimeMaster } from '../../../entities/shift-time-master.entity';
import { ShiftTimeService } from './shift-time.service';

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
  });

  describe('remove', () => {
    it('없는 행이면 404', async () => {
      repo.findOne.mockResolvedValue(null);
      await expect(target.remove('2026-07-01', 1)).rejects.toBeInstanceOf(NotFoundException);
    });
  });
});

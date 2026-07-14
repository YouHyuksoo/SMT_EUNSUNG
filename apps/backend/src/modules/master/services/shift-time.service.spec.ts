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

  // Oracle 드라이버(OracleDriver.prepareHydratedValue)는 `type:'date'` 컬럼을 조회 시
  // Date 객체가 아니라 문자열('YYYY-MM-DD')로 hydrate한다. find()/findOne()이 돌려주는 행은
  // 항상 이 모양이다 — 이 목이 Date 객체를 주면(예전 버전) C1/I1 버그가 초록으로 통과해버린다.
  const row = (dateset: string, dateend: string | null): ShiftTimeMaster =>
    ({
      organizationId: 1,
      dateset,
      dateend,
      dayTimeStart: '08:00',
      dayTimeEnd: '20:00',
      dayBreakMinutes: 60,
      nightTimeStart: '20:00',
      nightTimeEnd: '08:00',
      nightBreakMinutes: 60,
      // 실제 DB 조회 결과는 NOT NULL 컬럼이라 항상 채워져 있다 — 로드된 엔티티를 흉내낸다.
      enterBy: 'SYSTEM',
      enterDate: '2026-01-01',
      lastModifyBy: 'SYSTEM',
      lastModifyDate: '2026-01-01',
    }) as unknown as ShiftTimeMaster;

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

  describe('resolveForDate / resolveFromRows', () => {
    it('유효기간에 들어가는 행을 고른다', async () => {
      repo.find.mockResolvedValue([row('2026-01-01', '2026-06-30'), row('2026-07-01', null)]);
      const found = await target.resolveForDate('2026-07-14', 1);
      expect(found?.dateset).toBe('2026-07-01');
    });

    it('DATEEND가 null이면 무기한으로 본다', async () => {
      repo.find.mockResolvedValue([row('2026-07-01', null)]);
      expect(await target.resolveForDate('2030-01-01', 1)).not.toBeNull();
    });

    it('어떤 구간에도 안 들어가면 null', async () => {
      repo.find.mockResolvedValue([row('2026-01-01', '2026-06-30')]);
      expect(await target.resolveForDate('2026-07-14', 1)).toBeNull();
    });

    // I1 회귀 방지: DATESET 당일 자체와, 두 구간이 맞닿는 교체일(changeover day)이 모두
    // 정상적으로 매치돼야 한다. new Date('YYYY-MM-DD')(UTC 자정) vs parseYmd()(KST 로컬 자정)를
    // 그대로 비교하면 KST에서는 로컬 자정이 UTC 자정보다 9시간 빠르므로 DATESET 당일이
    // 항상 탈락한다(근무분 0으로 계산되는 버그).
    it('DATESET 당일 자체가 매치된다 (문자열 rows, KST 자정 경계)', () => {
      const rows = [row('2026-01-01', null)];
      const hit = target.resolveFromRows(rows, '2026-01-01');
      expect(hit).not.toBeNull();
      expect(hit?.dateset).toBe('2026-01-01');
    });

    it('교대기간 교체일(전임 구간 종료 다음날)도 매치된다', () => {
      const rows = [row('2026-01-01', '2026-06-30'), row('2026-07-01', null)];
      const hit = target.resolveFromRows(rows, '2026-07-01');
      expect(hit).not.toBeNull();
      expect(hit?.dateset).toBe('2026-07-01');
    });

    it('전임 구간의 마지막 날(DATEEND)도 정상 매치된다', () => {
      const rows = [row('2026-01-01', '2026-06-30'), row('2026-07-01', null)];
      const hit = target.resolveFromRows(rows, '2026-06-30');
      expect(hit).not.toBeNull();
      expect(hit?.dateset).toBe('2026-01-01');
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

    it('ENTER_DATE/LAST_MODIFY_DATE를 채운다 (NOT NULL 컬럼이라 비면 ORA-01400)', async () => {
      repo.find.mockResolvedValue([]);
      repo.create.mockImplementation((v) => v as ShiftTimeMaster);
      repo.save.mockImplementation(async (v) => v as ShiftTimeMaster);

      const saved = await target.create(
        { dateset: '2026-07-01', dayTimeStart: '08:00', dayTimeEnd: '20:00' },
        1,
      );

      expect(saved.enterDate).toBeInstanceOf(Date);
      expect(saved.lastModifyDate).toBeInstanceOf(Date);
    });
  });

  // C1 회귀 방지: found를 save(found)/repo.remove(found)로 되돌려 쓰면, find()/findOne()이
  // 돌려준 DATESET(문자열)을 save()/remove()가 내부적으로 재확인 SELECT에 그대로 재바인딩해
  // ORA-01861(literal does not match format string)을 낸다. update()/remove()는 criteria
  // 기반 repo.update()/repo.delete()만 써야 하고, 절대 repo.save()/repo.remove()를 호출하면
  // 안 된다 — 아래 테스트들이 이를 구조적으로 강제한다.
  describe('update', () => {
    it('없는 행이면 404', async () => {
      repo.findOne.mockResolvedValue(null);
      await expect(target.update('2026-07-01', {}, 1)).rejects.toBeInstanceOf(NotFoundException);
    });

    it('문자열 shape 행(Oracle 드라이버 실제 반환 모양)에 대해 save()/remove()를 호출하지 않고 성공한다', async () => {
      const existing = row('2026-07-01', '2026-12-31');
      repo.findOne.mockResolvedValueOnce(existing).mockResolvedValueOnce(existing);
      repo.find.mockResolvedValue([existing]);
      repo.update.mockResolvedValue({ affected: 1, raw: [], generatedMaps: [] });

      await target.update('2026-07-01', { dayTimeStart: '09:00' }, 1);

      expect(repo.save).not.toHaveBeenCalled();
      expect(repo.update).toHaveBeenCalledTimes(1);
    });

    it('dateend가 dto에 없으면(undefined) 기존 값을 유지한다', async () => {
      const existing = row('2026-07-01', '2026-12-31');
      const afterUpdate = row('2026-07-01', '2026-12-31');
      repo.findOne.mockResolvedValueOnce(existing).mockResolvedValueOnce(afterUpdate);
      repo.find.mockResolvedValue([existing]);
      repo.update.mockResolvedValue({ affected: 1, raw: [], generatedMaps: [] });

      const saved = await target.update('2026-07-01', { dayTimeStart: '09:00' }, 1);

      expect(saved.dateend).toBe('2026-12-31');
      // dateend가 dto에 없었으므로 partial에 dateend가 포함되지 않아야 한다 (기존 값 보존).
      const [, partial] = repo.update.mock.calls[0];
      expect(partial).not.toHaveProperty('dateend');
    });

    it('dateend: null이면 무기한으로 변경한다', async () => {
      const existing = row('2026-07-01', '2026-12-31');
      const afterUpdate = row('2026-07-01', null);
      repo.findOne.mockResolvedValueOnce(existing).mockResolvedValueOnce(afterUpdate);
      repo.find.mockResolvedValue([existing]);
      repo.update.mockResolvedValue({ affected: 1, raw: [], generatedMaps: [] });

      // UpdateShiftTimeDto.dateend는 타입상 string|undefined지만, 컨트롤러는 바디를 그대로 넘기므로
      // 실제 런타임에는 무기한 해제를 위한 null이 들어온다. DTO/서비스는 변경 대상이 아니므로 브리지 캐스팅.
      const saved = await target.update(
        '2026-07-01',
        { dateend: null } as unknown as UpdateShiftTimeDto,
        1,
      );

      expect(saved.dateend).toBeNull();
      const [, partial] = repo.update.mock.calls[0];
      expect(partial).toEqual(expect.objectContaining({ dateend: null }));
    });

    it("dateend: '2026-12-31'이면 해당 값으로 설정한다", async () => {
      const existing = row('2026-07-01', null);
      const afterUpdate = row('2026-07-01', '2026-12-31');
      repo.findOne.mockResolvedValueOnce(existing).mockResolvedValueOnce(afterUpdate);
      repo.find.mockResolvedValue([existing]);
      repo.update.mockResolvedValue({ affected: 1, raw: [], generatedMaps: [] });

      const saved = await target.update('2026-07-01', { dateend: '2026-12-31' }, 1);

      expect(saved.dateend).toBe('2026-12-31');
    });

    it('확장한 구간이 인접 구간과 겹치면 409이고 UPDATE하지 않는다', async () => {
      const existing = row('2026-07-01', '2026-07-31');
      const neighbour = row('2026-08-01', null);
      repo.findOne.mockResolvedValue(existing);
      repo.find.mockResolvedValue([existing, neighbour]);

      await expect(
        target.update('2026-07-01', { dateend: '2026-08-15' }, 1),
      ).rejects.toBeInstanceOf(ConflictException);
      expect(repo.update).not.toHaveBeenCalled();
      expect(repo.save).not.toHaveBeenCalled();
    });

    it('겹치지 않는 확장은 UPDATE되며, 자기 자신의 dateset과는 겹침으로 판정하지 않는다', async () => {
      const existing = row('2026-07-01', '2026-07-31');
      const afterUpdate = row('2026-07-01', '2026-09-30');
      repo.findOne.mockResolvedValueOnce(existing).mockResolvedValueOnce(afterUpdate);
      repo.find.mockResolvedValue([existing]);
      repo.update.mockResolvedValue({ affected: 1, raw: [], generatedMaps: [] });

      const saved = await target.update('2026-07-01', { dateend: '2026-09-30' }, 1);

      expect(saved.dateend).toBe('2026-09-30');
      expect(repo.update).toHaveBeenCalledTimes(1);
    });

    it('dto에 있는 교대시간 필드만 partial에 담긴다', async () => {
      const existing = row('2026-07-01', null);
      repo.findOne.mockResolvedValueOnce(existing).mockResolvedValueOnce(existing);
      repo.find.mockResolvedValue([existing]);
      repo.update.mockResolvedValue({ affected: 1, raw: [], generatedMaps: [] });

      await target.update('2026-07-01', { dayTimeStart: '09:00' }, 1);

      const [criteria, partial] = repo.update.mock.calls[0];
      expect(criteria).toEqual(expect.objectContaining({ organizationId: 1 }));
      expect(partial).toEqual(
        expect.objectContaining({ dayTimeStart: '09:00' }),
      );
      expect(partial).not.toHaveProperty('dayTimeEnd');
      expect(partial).not.toHaveProperty('nightTimeStart');
    });

    it('LAST_MODIFY_BY/LAST_MODIFY_DATE를 호출자 userId로 갱신한다', async () => {
      const existing = row('2026-07-01', null);
      repo.findOne.mockResolvedValueOnce(existing).mockResolvedValueOnce(existing);
      repo.find.mockResolvedValue([existing]);
      repo.update.mockResolvedValue({ affected: 1, raw: [], generatedMaps: [] });

      await target.update('2026-07-01', { dayTimeStart: '09:00' }, 1, 'HONG');

      const [, partial] = repo.update.mock.calls[0];
      expect(partial).toEqual(
        expect.objectContaining({ lastModifyBy: 'HONG', lastModifyDate: expect.any(Date) }),
      );
    });

    it('ENTER_DATE/ENTER_BY는 partial에 포함하지 않는다 (원본 생성시각 보존)', async () => {
      const existing = row('2026-07-01', null);
      repo.findOne.mockResolvedValueOnce(existing).mockResolvedValueOnce(existing);
      repo.find.mockResolvedValue([existing]);
      repo.update.mockResolvedValue({ affected: 1, raw: [], generatedMaps: [] });

      await target.update('2026-07-01', { dayTimeStart: '09:00' }, 1, 'HONG');

      const [, partial] = repo.update.mock.calls[0];
      expect(partial).not.toHaveProperty('enterDate');
      expect(partial).not.toHaveProperty('enterBy');
    });
  });

  describe('remove', () => {
    it('없는 행이면 404', async () => {
      repo.findOne.mockResolvedValue(null);
      await expect(target.remove('2026-07-01', 1)).rejects.toBeInstanceOf(NotFoundException);
      expect(repo.delete).not.toHaveBeenCalled();
    });

    it('문자열 shape 행에 대해 repo.remove()가 아니라 criteria 기반 repo.delete()를 호출한다', async () => {
      const existing = row('2026-07-01', null);
      repo.findOne.mockResolvedValue(existing);

      await target.remove('2026-07-01', 1);

      expect(repo.remove).not.toHaveBeenCalled();
      expect(repo.delete).toHaveBeenCalledTimes(1);
      const [criteria] = repo.delete.mock.calls[0];
      expect(criteria).toEqual(
        expect.objectContaining({ organizationId: 1, dateset: new Date(2026, 6, 1) }),
      );
    });
  });
});

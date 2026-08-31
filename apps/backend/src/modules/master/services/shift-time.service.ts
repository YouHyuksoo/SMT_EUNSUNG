/**
 * @file src/modules/master/services/shift-time.service.ts
 * @description 2교대 시간 마스터(IP_SHIFT_TIME_MASTER) 서비스
 *
 * 초보자 가이드:
 * 1. 유효기간형이다. DATESET ~ DATEEND(null=무기한) 구간이 겹치면 안 된다.
 *    Oracle 제약으로 표현할 수 없어 서비스에서 검증한다.
 * 2. resolveForDate()가 특정 일자에 적용될 교대시간을 돌려주며, 월력 서비스가 근무분 계산에 쓴다.
 *    여러 일자를 한 번에 처리할 때는 findAll()로 rows를 1회만 불러온 뒤 resolveFromRows()를
 *    반복 호출한다 — 일자 수만큼 DB를 다시 조회하지 않기 위함이다.
 */
import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { EntityManager, Repository } from 'typeorm';
import { ShiftTimeMaster } from '../../../entities/shift-time-master.entity';
import { TransactionService } from '../../../shared/transaction.service';
import { ShiftTimeBreak, type ShiftSlot } from '../../../entities/shift-time-break.entity';
import {
  CreateShiftTimeDto,
  ShiftTimeBreakDto,
  UpdateShiftTimeDto,
} from '../dto/work-calendar.dto';

/** 목록 화면이 쓰는 모양 — 마스터 행 + 슬롯별 비작업 시간 */
export interface ShiftTimeView extends ShiftTimeMaster {
  dayBreaks: { breakType: string; breakMinutes: number }[];
  nightBreaks: { breakType: string; breakMinutes: number }[];
}

/** 0분 항목은 저장하지 않는다 — 화면이 모든 분류를 항상 보내기 때문이다. */
function sumBreaks(breaks: ShiftTimeBreakDto[] | undefined): number {
  return (breaks ?? []).reduce((acc, b) => acc + (b.breakMinutes > 0 ? b.breakMinutes : 0), 0);
}

/** 'YYYY-MM-DD' → 로컬 자정 Date (Oracle DATE 비교용) */
function parseYmd(isoDate: string): Date {
  const [y, m, d] = isoDate.split('-').map(Number);
  return new Date(y, m - 1, d);
}

/**
 * DB에서 읽은 date 컬럼 값을 로컬 자정 Date로 정규화한다.
 *
 * I1 회귀 방지: Oracle 드라이버(OracleDriver.prepareHydratedValue)는 `type:'date'` 컬럼을
 * 조회 시 문자열('YYYY-MM-DD')로 hydrate한다. 이 문자열을 그냥 `new Date(str)`에 넘기면
 * UTC 자정으로 해석되는데, parseYmd()가 만드는 비교 대상(target)은 로컬(KST) 자정이다.
 * KST(UTC+9)에서는 로컬 자정이 UTC 자정보다 9시간 빠르므로, DATESET 당일 자체가
 * "target >= from" 비교에서 항상 탈락한다(교대기간 첫날이 0분으로 계산되는 버그).
 * repo.create()로 막 만든 엔티티(아직 저장 전)나 단위 테스트 목(mock)은 진짜 Date 객체를
 * 주므로, 문자열/Date 두 모양을 이 함수 하나로 흡수해 resolveFromRows()/ensureNoOverlap()
 * 양쪽에서 동일하게 쓴다.
 */
function toLocalMidnight(value: Date | string): Date {
  if (typeof value === 'string') return parseYmd(value.slice(0, 10));
  return new Date(value.getFullYear(), value.getMonth(), value.getDate());
}

@Injectable()
export class ShiftTimeService {
  constructor(
    @InjectRepository(ShiftTimeMaster)
    private readonly repo: Repository<ShiftTimeMaster>,
    @InjectRepository(ShiftTimeBreak)
    private readonly breakRepo: Repository<ShiftTimeBreak>,
    private readonly tx: TransactionService,
  ) {}

  /**
   * 마스터 + 슬롯별 비작업 시간. 화면(교대시간 탭)이 쓴다.
   * findAll()은 월력 저장 경로가 일자마다 재사용하는 hot path라 그대로 두고, 자식 조회가
   * 필요한 화면용 경로만 여기서 따로 합친다.
   */
  async findAllWithBreaks(organizationId: number): Promise<ShiftTimeView[]> {
    const [rows, breaks] = await Promise.all([
      this.findAll(organizationId),
      this.breakRepo.find({ where: { organizationId } }),
    ]);
    return rows.map((row) => {
      const key = this.toIso(toLocalMidnight(row.dateset));
      const mine = breaks.filter((b) => this.toIso(toLocalMidnight(b.dateset)) === key);
      const pick = (slot: ShiftSlot) =>
        mine
          .filter((b) => b.shiftSlot === slot)
          .map((b) => ({ breakType: b.breakType, breakMinutes: b.breakMinutes }))
          .sort((a, b) => a.breakType.localeCompare(b.breakType));
      return { ...row, dayBreaks: pick('DAY'), nightBreaks: pick('NIGHT') } as ShiftTimeView;
    });
  }

  /**
   * 한 마스터 행의 비작업 자식행을 통째로 교체한다.
   * 보낸 목록이 그 행의 전부다 — 0분 항목은 의미 없는 행이라 저장하지 않는다.
   */
  private async replaceBreaks(
    manager: EntityManager,
    dateset: string,
    organizationId: number,
    dayBreaks: ShiftTimeBreakDto[] | undefined,
    nightBreaks: ShiftTimeBreakDto[] | undefined,
    userId?: string,
  ): Promise<void> {
    if (dayBreaks === undefined && nightBreaks === undefined) return;
    const planDate = parseYmd(dateset);
    const enterBy = userId ?? 'SYSTEM';
    const now = new Date();
    const rows = (['DAY', 'NIGHT'] as const).flatMap((slot) =>
      (slot === 'DAY' ? (dayBreaks ?? []) : (nightBreaks ?? []))
        .filter((b) => b.breakMinutes > 0)
        .map((b) => ({
          dateset: planDate,
          organizationId,
          shiftSlot: slot,
          breakType: b.breakType,
          breakMinutes: b.breakMinutes,
          enterBy,
          enterDate: now,
          lastModifyBy: enterBy,
          lastModifyDate: now,
        })),
    );
    await manager.delete(ShiftTimeBreak, { organizationId, dateset: planDate });
    if (rows.length > 0) await manager.insert(ShiftTimeBreak, rows as ShiftTimeBreak[]);
  }

  async findAll(organizationId: number): Promise<ShiftTimeMaster[]> {
    return this.repo.find({
      where: { organizationId },
      order: { dateset: 'DESC' },
    });
  }

  /** 해당 일자에 유효한 교대시간 1건. 없으면 null. */
  async resolveForDate(isoDate: string, organizationId: number): Promise<ShiftTimeMaster | null> {
    const rows = await this.findAll(organizationId);
    return this.resolveFromRows(rows, isoDate);
  }

  /**
   * 이미 불러온 rows(예: findAll() 1회 호출 결과)에서 해당 일자에 유효한 교대시간 1건을 고른다.
   * 여러 일자를 순회하며 매번 DB를 다시 조회하지 않도록, 호출자가 rows를 미리 로드해 재사용한다.
   */
  resolveFromRows(rows: ShiftTimeMaster[], isoDate: string): ShiftTimeMaster | null {
    const target = parseYmd(isoDate).getTime();
    const hit = rows.find((r) => {
      const from = toLocalMidnight(r.dateset).getTime();
      const to = r.dateend ? toLocalMidnight(r.dateend).getTime() : Number.POSITIVE_INFINITY;
      return target >= from && target <= to;
    });
    return hit ?? null;
  }

  async create(
    dto: CreateShiftTimeDto,
    organizationId: number,
    userId?: string,
  ): Promise<ShiftTimeMaster> {
    await this.ensureNoOverlap(dto.dateset, dto.dateend ?? null, organizationId, null);
    const enterBy = userId ?? 'SYSTEM';
    const now = new Date();
    // repo.create()로 만든 엔티티도 ENTER_DATE/LAST_MODIFY_DATE를 자동으로 채운다고 가정하지
    // 않는다 (work-calendar.service.ts의 buildRow()에서 같은 가정이 실제 DB에서 깨진 전례가
    // 있다). NOT NULL 컬럼이므로 매번 명시적으로 찍는다.
    const entity = this.repo.create({
      organizationId,
      dateset: parseYmd(dto.dateset),
      dateend: dto.dateend ? parseYmd(dto.dateend) : null,
      dayTimeStart: dto.dayTimeStart ?? null,
      dayTimeEnd: dto.dayTimeEnd ?? null,
      // 자식 목록이 오면 그 합이 이긴다 — 클라이언트가 보낸 총합을 그대로 믿지 않는다.
      dayBreakMinutes: dto.dayBreaks ? sumBreaks(dto.dayBreaks) : (dto.dayBreakMinutes ?? 0),
      nightTimeStart: dto.nightTimeStart ?? null,
      nightTimeEnd: dto.nightTimeEnd ?? null,
      nightBreakMinutes: dto.nightBreaks
        ? sumBreaks(dto.nightBreaks)
        : (dto.nightBreakMinutes ?? 0),
      enterBy,
      enterDate: now,
      lastModifyBy: enterBy,
      lastModifyDate: now,
    });
    // 마스터 저장과 자식(비작업) 저장을 한 트랜잭션에 묶는다. 나눠 놓으면 자식 저장이
    // 실패했을 때 마스터만 커밋돼 "휴식분 롤업은 있는데 내역이 없는" 반쪽 행이 남고,
    // 다음 저장 시도는 유효기간 겹침(409)으로 막혀 복구가 불가능해진다(실제로 발생).
    return this.tx.run(async (qr) => {
      const saved = await qr.manager.save(ShiftTimeMaster, entity);
      await this.replaceBreaks(
        qr.manager,
        dto.dateset,
        organizationId,
        dto.dayBreaks,
        dto.nightBreaks,
        userId,
      );
      return saved;
    });
  }

  async update(
    dateset: string,
    dto: UpdateShiftTimeDto,
    organizationId: number,
    userId?: string,
  ): Promise<ShiftTimeMaster> {
    const found = await this.findOneOrThrow(dateset, organizationId);
    // I4 회귀 방지: dto.dateend가 없으면(PartialType이라 합법) found.dateend를 그대로 써야 하는데,
    // found.dateend는 findOne()이 돌려준 런타임 문자열이다. 예전 코드는 이걸 this.toIso(Date)에
    // 그대로 넘겨 d.getFullYear()에서 TypeError를 던졌다. toLocalMidnight()로 정규화한 뒤에만
    // toIso()를 호출한다.
    const nextEndIso =
      dto.dateend !== undefined
        ? (dto.dateend ?? null)
        : found.dateend
          ? this.toIso(toLocalMidnight(found.dateend))
          : null;
    await this.ensureNoOverlap(dateset, nextEndIso, organizationId, dateset);

    const partial: Partial<ShiftTimeMaster> = {
      lastModifyBy: userId ?? 'SYSTEM',
      lastModifyDate: new Date(),
    };
    if (dto.dateend !== undefined) partial.dateend = dto.dateend ? parseYmd(dto.dateend) : null;
    if (dto.dayTimeStart !== undefined) partial.dayTimeStart = dto.dayTimeStart ?? null;
    if (dto.dayTimeEnd !== undefined) partial.dayTimeEnd = dto.dayTimeEnd ?? null;
    if (dto.dayBreaks !== undefined) partial.dayBreakMinutes = sumBreaks(dto.dayBreaks);
    else if (dto.dayBreakMinutes !== undefined) partial.dayBreakMinutes = dto.dayBreakMinutes;
    if (dto.nightTimeStart !== undefined) partial.nightTimeStart = dto.nightTimeStart ?? null;
    if (dto.nightTimeEnd !== undefined) partial.nightTimeEnd = dto.nightTimeEnd ?? null;
    if (dto.nightBreaks !== undefined) partial.nightBreakMinutes = sumBreaks(dto.nightBreaks);
    else if (dto.nightBreakMinutes !== undefined) partial.nightBreakMinutes = dto.nightBreakMinutes;

    // repo.update(criteria, partial)로 직접 UPDATE한다. found를 save(found)로 되돌려 쓰지 않는
    // 이유(C1, Bug 회귀 방지): find()/findOne()이 반환하는 DATESET은 Oracle 드라이버가 이미
    // 문자열('YYYY-MM-DD')로 hydrate해 둔다. save()는 저장 전 "정말 존재하는가"를 다시 확인하려고
    // 그 문자열 PK를 TO_DATE 변환 없이 그대로 재바인딩하는 SELECT를 날리는데, 세션
    // NLS_DATE_FORMAT과 형식이 안 맞아 ORA-01861(literal does not match format string)이 난다.
    // work-calendar.service.ts의 setConfirm()과 동일한 회피다.
    await this.tx.run(async (qr) => {
      await qr.manager.update(
        ShiftTimeMaster,
        { organizationId, dateset: parseYmd(dateset) },
        partial,
      );
      await this.replaceBreaks(
        qr.manager,
        dateset,
        organizationId,
        dto.dayBreaks,
        dto.nightBreaks,
        userId,
      );
    });
    return this.findOneOrThrow(dateset, organizationId);
  }

  async remove(dateset: string, organizationId: number): Promise<void> {
    await this.findOneOrThrow(dateset, organizationId);
    // C1 회귀 방지: repo.remove(entity)도 save()와 같은 SubjectDatabaseEntityLoader 재확인
    // SELECT 경로를 타서 ORA-01861을 낸다. criteria 기반 delete()로 그 경로를 우회한다.
    await this.tx.run(async (qr) => {
      await qr.manager.delete(ShiftTimeBreak, { organizationId, dateset: parseYmd(dateset) });
      await qr.manager.delete(ShiftTimeMaster, { organizationId, dateset: parseYmd(dateset) });
    });
  }

  private async findOneOrThrow(dateset: string, organizationId: number): Promise<ShiftTimeMaster> {
    const found = await this.repo.findOne({
      where: { organizationId, dateset: parseYmd(dateset) },
    });
    if (!found) throw new NotFoundException(`교대시간을 찾을 수 없습니다: ${dateset}`);
    return found;
  }

  private toIso(d: Date): string {
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    return `${y}-${m}-${day}`;
  }

  /** 유효기간 겹침 검증. excludeDateset은 수정 시 자기 자신을 제외하기 위한 값. */
  private async ensureNoOverlap(
    dateset: string,
    dateend: string | null,
    organizationId: number,
    excludeDateset: string | null,
  ): Promise<void> {
    const from = parseYmd(dateset).getTime();
    const to = dateend ? parseYmd(dateend).getTime() : Number.POSITIVE_INFINITY;
    if (to < from) {
      throw new ConflictException('종료일이 시작일보다 이릅니다.');
    }
    const rows = await this.repo.find({ where: { organizationId } });
    const clash = rows.find((r) => {
      const rFromDate = toLocalMidnight(r.dateset);
      if (excludeDateset && this.toIso(rFromDate) === excludeDateset) return false;
      const rFrom = rFromDate.getTime();
      const rTo = r.dateend ? toLocalMidnight(r.dateend).getTime() : Number.POSITIVE_INFINITY;
      return from <= rTo && rFrom <= to;
    });
    if (clash) {
      throw new ConflictException(
        `적용기간이 겹치는 교대시간이 있습니다: ${this.toIso(toLocalMidnight(clash.dateset))}`,
      );
    }
  }
}

/**
 * @file src/modules/master/services/shift-time.service.ts
 * @description 2교대 시간 마스터(IP_SHIFT_TIME_MASTER) 서비스
 *
 * 초보자 가이드:
 * 1. 유효기간형이다. DATESET ~ DATEEND(null=무기한) 구간이 겹치면 안 된다.
 *    Oracle 제약으로 표현할 수 없어 서비스에서 검증한다.
 * 2. resolveForDate()가 특정 일자에 적용될 교대시간을 돌려주며, 월력 서비스가 근무분 계산에 쓴다.
 */
import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ShiftTimeMaster } from '../../../entities/shift-time-master.entity';
import { CreateShiftTimeDto, UpdateShiftTimeDto } from '../dto/work-calendar.dto';

/** 'YYYY-MM-DD' → 로컬 자정 Date (Oracle DATE 비교용) */
function parseYmd(isoDate: string): Date {
  const [y, m, d] = isoDate.split('-').map(Number);
  return new Date(y, m - 1, d);
}

@Injectable()
export class ShiftTimeService {
  constructor(
    @InjectRepository(ShiftTimeMaster)
    private readonly repo: Repository<ShiftTimeMaster>,
  ) {}

  async findAll(organizationId: number): Promise<ShiftTimeMaster[]> {
    return this.repo.find({
      where: { organizationId },
      order: { dateset: 'DESC' },
    });
  }

  /** 해당 일자에 유효한 교대시간 1건. 없으면 null. */
  async resolveForDate(isoDate: string, organizationId: number): Promise<ShiftTimeMaster | null> {
    const target = parseYmd(isoDate).getTime();
    const rows = await this.repo.find({ where: { organizationId } });
    const hit = rows.find((r) => {
      const from = new Date(r.dateset).getTime();
      const to = r.dateend ? new Date(r.dateend).getTime() : Number.POSITIVE_INFINITY;
      return target >= from && target <= to;
    });
    return hit ?? null;
  }

  async create(dto: CreateShiftTimeDto, organizationId: number): Promise<ShiftTimeMaster> {
    await this.ensureNoOverlap(dto.dateset, dto.dateend ?? null, organizationId, null);
    const entity = this.repo.create({
      organizationId,
      dateset: parseYmd(dto.dateset),
      dateend: dto.dateend ? parseYmd(dto.dateend) : null,
      dayTimeStart: dto.dayTimeStart ?? null,
      dayTimeEnd: dto.dayTimeEnd ?? null,
      dayBreakMinutes: dto.dayBreakMinutes ?? 0,
      nightTimeStart: dto.nightTimeStart ?? null,
      nightTimeEnd: dto.nightTimeEnd ?? null,
      nightBreakMinutes: dto.nightBreakMinutes ?? 0,
    });
    return this.repo.save(entity);
  }

  async update(
    dateset: string,
    dto: UpdateShiftTimeDto,
    organizationId: number,
  ): Promise<ShiftTimeMaster> {
    const found = await this.findOneOrThrow(dateset, organizationId);
    const nextEnd = dto.dateend !== undefined ? (dto.dateend ? parseYmd(dto.dateend) : null) : found.dateend;
    await this.ensureNoOverlap(
      dateset,
      nextEnd ? this.toIso(nextEnd) : null,
      organizationId,
      dateset,
    );
    found.dateend = nextEnd;
    if (dto.dayTimeStart !== undefined) found.dayTimeStart = dto.dayTimeStart ?? null;
    if (dto.dayTimeEnd !== undefined) found.dayTimeEnd = dto.dayTimeEnd ?? null;
    if (dto.dayBreakMinutes !== undefined) found.dayBreakMinutes = dto.dayBreakMinutes;
    if (dto.nightTimeStart !== undefined) found.nightTimeStart = dto.nightTimeStart ?? null;
    if (dto.nightTimeEnd !== undefined) found.nightTimeEnd = dto.nightTimeEnd ?? null;
    if (dto.nightBreakMinutes !== undefined) found.nightBreakMinutes = dto.nightBreakMinutes;
    return this.repo.save(found);
  }

  async remove(dateset: string, organizationId: number): Promise<void> {
    const found = await this.findOneOrThrow(dateset, organizationId);
    await this.repo.remove(found);
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
      const rFromDate = new Date(r.dateset);
      if (excludeDateset && this.toIso(rFromDate) === excludeDateset) return false;
      const rFrom = rFromDate.getTime();
      const rTo = r.dateend ? new Date(r.dateend).getTime() : Number.POSITIVE_INFINITY;
      return from <= rTo && rFrom <= to;
    });
    if (clash) {
      throw new ConflictException(
        `적용기간이 겹치는 교대시간이 있습니다: ${this.toIso(new Date(clash.dateset))}`,
      );
    }
  }
}

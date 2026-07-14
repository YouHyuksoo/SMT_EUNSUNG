/**
 * @file src/modules/master/services/work-calendar.service.ts
 * @description 생산월력(IP_ 모델) 서비스 — 전사 월력 + 라인 예외
 *
 * 초보자 가이드:
 * 1. lineCode가 없으면 IP_PRODUCT_COMPANY_CALENDAR, 있으면 IP_PRODUCT_LINE_CALENDAR를 쓴다.
 * 2. 조회는 병합이다: 라인 예외 행이 있으면 그것이 이기고(source=LINE), 없으면 전사 행(source=COMPANY).
 * 3. HOLIDAY_YN은 절대 클라이언트 값을 믿지 않는다 — holidayYnOf(dayType)로 파생시킨다.
 *    DB CHECK 제약(CK_*_HOLIDAY_SYNC)이 이 불변식을 다시 한 번 강제한다.
 * 4. CONFIRM_YN='Y'인 일자가 범위에 하나라도 있으면 쓰기(저장/생성/복사)를 거부한다.
 */
import { ConflictException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Between, Repository } from 'typeorm';
import {
  defaultWorkMinutes,
  holidayYnOf,
  isFixedHoliday,
  type ShiftTimeMasterLike,
  type WorkDayType,
} from '@smt/shared';
import { ProductCompanyCalendar } from '../../../entities/product-company-calendar.entity';
import { ProductLineCalendar } from '../../../entities/product-line-calendar.entity';
import { ShiftTimeMaster } from '../../../entities/shift-time-master.entity';
import { ShiftTimeService } from './shift-time.service';
import {
  BulkUpdateDaysDto,
  ConfirmDaysDto,
  CopyFromCompanyDto,
  GenerateCalendarDto,
  SummaryQueryDto,
  WorkCalendarDaysQueryDto,
} from '../dto/work-calendar.dto';

export interface WorkCalendarDayView {
  workDate: string;
  dayType: WorkDayType;
  offReason: string | null;
  workMinutes: number;
  otMinutes: number;
  comment: string | null;
  confirmYn: 'Y' | 'N';
  source: 'COMPANY' | 'LINE';
}

export interface WorkCalendarSummary {
  workDays: number;
  offDays: number;
  halfDays: number;
  specialDays: number;
  totalMinutes: number;
}

function parseYmd(isoDate: string): Date {
  const [y, m, d] = isoDate.split('-').map(Number);
  return new Date(y, m - 1, d);
}

function toIso(d: Date): string {
  const date = new Date(d);
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${y}-${m}-${day}`;
}

/** 'YYYY-MM' → [해당 월 1일, 말일] */
function monthRange(month: string): [Date, Date] {
  const [y, m] = month.split('-').map(Number);
  return [new Date(y, m - 1, 1), new Date(y, m, 0)];
}

function yearRange(year: string): [Date, Date] {
  const y = Number(year);
  return [new Date(y, 0, 1), new Date(y, 11, 31)];
}

@Injectable()
export class WorkCalendarService {
  constructor(
    @InjectRepository(ProductCompanyCalendar)
    private readonly companyRepo: Repository<ProductCompanyCalendar>,
    @InjectRepository(ProductLineCalendar)
    private readonly lineRepo: Repository<ProductLineCalendar>,
    private readonly shiftTime: ShiftTimeService,
  ) {}

  /* ── 조회 ── */

  async findDays(
    query: WorkCalendarDaysQueryDto,
    organizationId: number,
  ): Promise<WorkCalendarDayView[]> {
    const [from, to] = monthRange(query.month);

    const companyRows = await this.companyRepo.find({
      where: { organizationId, planDate: Between(from, to) },
    });

    const lineRows = query.lineCode
      ? await this.lineRepo.find({
          where: { organizationId, lineCode: query.lineCode, planDate: Between(from, to) },
        })
      : [];

    const merged = new Map<string, WorkCalendarDayView>();
    for (const row of companyRows) {
      merged.set(toIso(row.planDate), this.toView(row, 'COMPANY'));
    }
    for (const row of lineRows) {
      merged.set(toIso(row.planDate), this.toView(row, 'LINE'));
    }
    return [...merged.values()].sort((a, b) => a.workDate.localeCompare(b.workDate));
  }

  async getSummary(
    query: SummaryQueryDto,
    organizationId: number,
  ): Promise<WorkCalendarSummary> {
    const [from, to] = yearRange(query.year);
    const companyRows = await this.companyRepo.find({
      where: { organizationId, planDate: Between(from, to) },
    });
    const lineRows = query.lineCode
      ? await this.lineRepo.find({
          where: { organizationId, lineCode: query.lineCode, planDate: Between(from, to) },
        })
      : [];

    const merged = new Map<string, WorkCalendarDayView>();
    for (const row of companyRows) merged.set(toIso(row.planDate), this.toView(row, 'COMPANY'));
    for (const row of lineRows) merged.set(toIso(row.planDate), this.toView(row, 'LINE'));

    const summary: WorkCalendarSummary = {
      workDays: 0,
      offDays: 0,
      halfDays: 0,
      specialDays: 0,
      totalMinutes: 0,
    };
    for (const day of merged.values()) {
      if (day.dayType === 'WORK') summary.workDays += 1;
      else if (day.dayType === 'OFF') summary.offDays += 1;
      else if (day.dayType === 'HALF') summary.halfDays += 1;
      else summary.specialDays += 1;
      summary.totalMinutes += day.workMinutes + day.otMinutes;
    }
    return summary;
  }

  /* ── 쓰기 ── */

  async bulkUpdateDays(dto: BulkUpdateDaysDto, organizationId: number): Promise<number> {
    if (dto.days.length === 0) return 0;

    const dates = dto.days.map((d) => d.workDate).sort();
    await this.ensureNotConfirmed(
      parseYmd(dates[0]),
      parseYmd(dates[dates.length - 1]),
      dto.lineCode,
      organizationId,
    );

    // 일자마다 다시 조회하지 않도록, 교대시간 rows는 요청당 1회만 불러와 재사용한다.
    const shiftRows = await this.shiftTime.findAll(organizationId);
    const rows = dto.days.map((day) => this.buildRow(day, dto.lineCode, organizationId, shiftRows));
    await this.saveRows(dto.lineCode, rows);
    return rows.length;
  }

  async generateYear(dto: GenerateCalendarDto, organizationId: number): Promise<number> {
    const [from, to] = yearRange(dto.year);
    await this.ensureNotConfirmed(from, to, dto.lineCode, organizationId);

    const applyHolidays = dto.applyHolidays ?? true;
    // 일자마다 다시 조회하지 않도록, 교대시간 rows는 요청당 1회만 불러와 재사용한다.
    const shiftRows = await this.shiftTime.findAll(organizationId);
    const rows = [];

    for (const cursor = new Date(from); cursor <= to; cursor.setDate(cursor.getDate() + 1)) {
      const isoDate = toIso(cursor);
      const dow = cursor.getDay(); // 0=일, 6=토

      let dayType: WorkDayType = 'WORK';
      let offReason: string | null = null;

      const weekendOff =
        (dow === 6 && !(dto.saturdayWork ?? false)) || (dow === 0 && !(dto.sundayWork ?? false));

      if (weekendOff) {
        dayType = 'OFF';
        offReason = 'WEEKEND';
      } else if (applyHolidays && isFixedHoliday(isoDate)) {
        dayType = 'OFF';
        offReason = 'HOLIDAY';
      }

      rows.push(
        this.buildRow(
          { workDate: isoDate, dayType, offReason, otMinutes: 0, comment: null },
          dto.lineCode,
          organizationId,
          shiftRows,
        ),
      );
    }

    await this.saveRows(dto.lineCode, rows);
    return rows.length;
  }

  /** 라인 월력을 전사 월력에서 복제한다 (해당 연도 전체 덮어쓰기). */
  async copyFromCompany(dto: CopyFromCompanyDto, organizationId: number): Promise<number> {
    const [from, to] = yearRange(dto.year);
    await this.ensureNotConfirmed(from, to, dto.lineCode, organizationId);

    const companyRows = await this.companyRepo.find({
      where: { organizationId, planDate: Between(from, to) },
    });
    if (companyRows.length === 0) {
      throw new ConflictException(`복사할 전사 월력이 없습니다: ${dto.year}년`);
    }

    const rows = companyRows.map((src) =>
      this.lineRepo.create({
        planDate: new Date(src.planDate),
        organizationId,
        lineCode: dto.lineCode,
        dayType: src.dayType,
        holidayYn: src.holidayYn,
        offReason: src.offReason,
        workMinutes: src.workMinutes,
        otMinutes: src.otMinutes,
        confirmYn: 'N',
        calendarComment: src.calendarComment,
      }),
    );
    await this.lineRepo.save(rows);
    return rows.length;
  }

  async confirm(dto: ConfirmDaysDto, organizationId: number): Promise<number> {
    return this.setConfirm(dto, 'Y', organizationId);
  }

  async unconfirm(dto: ConfirmDaysDto, organizationId: number): Promise<number> {
    return this.setConfirm(dto, 'N', organizationId);
  }

  /* ── 내부 ── */

  private repoFor(lineCode?: string) {
    return lineCode ? this.lineRepo : this.companyRepo;
  }

  /**
   * repoFor()의 반환 타입은 두 Repository의 유니온이라 TypeORM의 오버로드된
   * save()를 그 유니온 위에서 직접 호출할 수 없다(TS2349). 분기해서 각자의
   * 구체 타입으로 저장한다.
   */
  private async saveRows(lineCode: string | undefined, rows: unknown[]): Promise<void> {
    if (lineCode) {
      await this.lineRepo.save(rows as ProductLineCalendar[]);
    } else {
      await this.companyRepo.save(rows as ProductCompanyCalendar[]);
    }
  }

  private toView(
    row: ProductCompanyCalendar | ProductLineCalendar,
    source: 'COMPANY' | 'LINE',
  ): WorkCalendarDayView {
    return {
      workDate: toIso(row.planDate),
      dayType: row.dayType as WorkDayType,
      offReason: row.offReason,
      workMinutes: row.workMinutes,
      otMinutes: row.otMinutes,
      comment: row.calendarComment,
      confirmYn: row.confirmYn === 'Y' ? 'Y' : 'N',
      source,
    };
  }

  /**
   * 일자 1건을 엔티티로 만든다. HOLIDAY_YN과 근무분은 여기서만 파생된다.
   * shiftRows는 호출자가 findAll()로 미리 불러온 rows다 — 이 함수는 일자 수만큼
   * 반복 호출되므로, 여기서 직접 DB를 조회하지 않고 resolveFromRows()로만 판정한다.
   */
  private buildRow(
    day: {
      workDate: string;
      dayType: string;
      offReason?: string | null;
      workMinutes?: number;
      otMinutes?: number;
      comment?: string | null;
    },
    lineCode: string | undefined,
    organizationId: number,
    shiftRows: ShiftTimeMaster[],
  ) {
    const dayType = day.dayType as WorkDayType;
    const shift = this.shiftTime.resolveFromRows(
      shiftRows,
      day.workDate,
    ) as ShiftTimeMasterLike | null;

    const base = {
      planDate: parseYmd(day.workDate),
      organizationId,
      dayType,
      holidayYn: holidayYnOf(dayType),
      offReason: dayType === 'OFF' ? (day.offReason ?? null) : null,
      workMinutes: day.workMinutes ?? defaultWorkMinutes(dayType, shift),
      otMinutes: day.otMinutes ?? 0,
      confirmYn: 'N',
      calendarComment: day.comment ?? null,
    };

    // repo.create()는 새 엔티티 인스턴스에 필드를 병합해줄 뿐이므로,
    // save()에 넘길 값 자체는 이 평범한 객체로 충분하다.
    return lineCode ? { ...base, lineCode } : base;
  }

  /** 범위 안에 확정(CONFIRM_YN='Y') 일자가 하나라도 있으면 거부한다. */
  private async ensureNotConfirmed(
    from: Date,
    to: Date,
    lineCode: string | undefined,
    organizationId: number,
  ): Promise<void> {
    const rows = lineCode
      ? await this.lineRepo.find({
          where: { organizationId, lineCode, planDate: Between(from, to) },
        })
      : await this.companyRepo.find({
          where: { organizationId, planDate: Between(from, to) },
        });

    const locked = rows.find((r) => r.confirmYn === 'Y');
    if (locked) {
      throw new ConflictException(
        `확정된 월력은 수정할 수 없습니다. 확정 취소 후 진행하세요: ${toIso(locked.planDate)}`,
      );
    }
  }

  private async setConfirm(
    dto: ConfirmDaysDto,
    confirmYn: 'Y' | 'N',
    organizationId: number,
  ): Promise<number> {
    const [from, to] = dto.month
      ? monthRange(`${dto.year}-${String(dto.month).padStart(2, '0')}`)
      : yearRange(dto.year);

    const rows = dto.lineCode
      ? await this.lineRepo.find({
          where: { organizationId, lineCode: dto.lineCode, planDate: Between(from, to) },
        })
      : await this.companyRepo.find({
          where: { organizationId, planDate: Between(from, to) },
        });

    for (const row of rows) row.confirmYn = confirmYn;
    await this.saveRows(dto.lineCode, rows);
    return rows.length;
  }
}

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
 * 5. 교대조 작업시간/비작업 시간은 자식 테이블(IP_PRODUCT_CALENDAR_SHIFT/_BREAK)에 있다.
 *    자식은 "그 날만의 예외"라 행이 없을 수도 있고, 그때 근무분은 교대시간 마스터에서
 *    파생된다(defaultWorkMinutes). 행이 있으면 calendarWorkMinutes가 이긴다.
 *    LINE_CODE는 PK라 NULL을 못 써서 전사는 sentinel COMPANY_LINE_CODE('*')를 쓴다.
 */
import { ConflictException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Between, EntityManager, In, Repository } from 'typeorm';
import {
  calendarWorkMinutes,
  defaultWorkMinutes,
  holidayYnOf,
  isFixedHoliday,
  type CalendarBreak,
  type CalendarShift,
  type ShiftTimeMasterLike,
  type WorkDayType,
} from '@smt/shared';
import { ProductCompanyCalendar } from '../../../entities/product-company-calendar.entity';
import { ProductLineCalendar } from '../../../entities/product-line-calendar.entity';
import {
  COMPANY_LINE_CODE,
  ProductCalendarShift,
} from '../../../entities/product-calendar-shift.entity';
import { ProductCalendarBreak } from '../../../entities/product-calendar-break.entity';
import { ShiftTimeMaster } from '../../../entities/shift-time-master.entity';
import { ShiftTimeService } from './shift-time.service';
import { TransactionService } from '../../../shared/transaction.service';
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
  /** 그 일자에 저장된 교대조 작업시간. 없으면 빈 배열 = 교대시간 마스터를 따른다. */
  shifts: CalendarShift[];
  /** 그 일자에 저장된 비작업 시간. 없으면 빈 배열. */
  breaks: CalendarBreak[];
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
    @InjectRepository(ProductCalendarShift)
    private readonly shiftRepo: Repository<ProductCalendarShift>,
    @InjectRepository(ProductCalendarBreak)
    private readonly breakRepo: Repository<ProductCalendarBreak>,
    private readonly shiftTime: ShiftTimeService,
    private readonly tx: TransactionService,
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

    // 자식(교대조/비작업)은 부모와 같은 소유자를 따른다. 라인 모드면 라인 자식만 읽어
    // 병합 결과의 source와 어긋나지 않게 한다.
    const owner = query.lineCode ?? COMPANY_LINE_CODE;
    const [shiftRows, breakRows] = await Promise.all([
      this.shiftRepo.find({
        where: { organizationId, lineCode: owner, planDate: Between(from, to) },
      }),
      this.breakRepo.find({
        where: { organizationId, lineCode: owner, planDate: Between(from, to) },
      }),
    ]);
    for (const row of shiftRows) {
      merged.get(toIso(row.planDate))?.shifts.push({
        shiftCode: row.shiftCode,
        startTime: row.startTime,
        endTime: row.endTime,
      });
    }
    for (const row of breakRows) {
      merged.get(toIso(row.planDate))?.breaks.push({
        breakType: row.breakType,
        breakMinutes: row.breakMinutes,
      });
    }
    for (const day of merged.values()) {
      day.shifts.sort((a, b) => a.shiftCode.localeCompare(b.shiftCode));
      day.breaks.sort((a, b) => a.breakType.localeCompare(b.breakType));
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

  async bulkUpdateDays(
    dto: BulkUpdateDaysDto,
    organizationId: number,
    userId?: string,
  ): Promise<number> {
    if (dto.days.length === 0) return 0;

    const dates = dto.days.map((d) => d.workDate).sort();
    const from = parseYmd(dates[0]);
    const to = parseYmd(dates[dates.length - 1]);
    await this.ensureNotConfirmed(from, to, dto.lineCode, organizationId);

    // 일자마다 다시 조회하지 않도록, 교대시간 rows는 요청당 1회만 불러와 재사용한다.
    const shiftRows = await this.shiftTime.findAll(organizationId);
    const rows = dto.days.map((day) =>
      this.buildRow(day, dto.lineCode, organizationId, shiftRows, userId),
    );
    const planDates = dto.days.map((day) => parseYmd(day.workDate));
    const { shifts, breaks } = this.buildChildRows(dto.days, dto.lineCode, organizationId, userId);
    await this.replaceRowsByDates(
      dto.lineCode,
      organizationId,
      from,
      to,
      planDates,
      rows,
      shifts,
      breaks,
    );
    return rows.length;
  }

  async generateYear(
    dto: GenerateCalendarDto,
    organizationId: number,
    userId?: string,
  ): Promise<number> {
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
          userId,
        ),
      );
    }

    await this.replaceRowsInRange(dto.lineCode, organizationId, from, to, rows);
    return rows.length;
  }

  /** 라인 월력을 전사 월력에서 복제한다 (해당 연도 전체 덮어쓰기). */
  async copyFromCompany(
    dto: CopyFromCompanyDto,
    organizationId: number,
    userId?: string,
  ): Promise<number> {
    const [from, to] = yearRange(dto.year);
    await this.ensureNotConfirmed(from, to, dto.lineCode, organizationId);

    const companyRows = await this.companyRepo.find({
      where: { organizationId, planDate: Between(from, to) },
    });
    if (companyRows.length === 0) {
      throw new ConflictException(`복사할 전사 월력이 없습니다: ${dto.year}년`);
    }

    const enterBy = userId ?? 'SYSTEM';
    const now = new Date();
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
        enterBy,
        enterDate: now,
        lastModifyBy: enterBy,
        lastModifyDate: now,
      }),
    );
    // 전사 자식행(교대조/비작업)도 같이 복제한다. 부모만 옮기면 라인 월력의 근무분 근거가
    // 사라져 전사와 다른 값으로 보인다.
    const companyShifts = await this.shiftRepo.find({
      where: { organizationId, lineCode: COMPANY_LINE_CODE, planDate: Between(from, to) },
    });
    const companyBreaks = await this.breakRepo.find({
      where: { organizationId, lineCode: COMPANY_LINE_CODE, planDate: Between(from, to) },
    });
    const shifts = companyShifts.map((src) => ({
      planDate: new Date(src.planDate),
      organizationId,
      lineCode: dto.lineCode,
      shiftCode: src.shiftCode,
      startTime: src.startTime,
      endTime: src.endTime,
      enterBy,
      enterDate: now,
      lastModifyBy: enterBy,
      lastModifyDate: now,
    }));
    const breaks = companyBreaks.map((src) => ({
      planDate: new Date(src.planDate),
      organizationId,
      lineCode: dto.lineCode,
      breakType: src.breakType,
      breakMinutes: src.breakMinutes,
      enterBy,
      enterDate: now,
      lastModifyBy: enterBy,
      lastModifyDate: now,
    }));

    // save()가 아니라 delete()+insert()를 쓰는 이유는 replaceRowsInRange() 주석 참고
    // (PLAN_DATE Date vs 문자열 hydrate 불일치로 save()가 매번 INSERT를 시도해 ORA-00001 발생).
    await this.replaceRowsInRange(dto.lineCode, organizationId, from, to, rows, shifts, breaks);
    return rows.length;
  }

  async confirm(dto: ConfirmDaysDto, organizationId: number, userId?: string): Promise<number> {
    return this.setConfirm(dto, 'Y', organizationId, userId);
  }

  async unconfirm(dto: ConfirmDaysDto, organizationId: number, userId?: string): Promise<number> {
    return this.setConfirm(dto, 'N', organizationId, userId);
  }

  /* ── 내부 ── */

  /**
   * 지정한 [from,to] 범위의 기존 행을 전부 삭제한 뒤 새 rows를 삽입한다 — "연간/기간 재생성은
   * 해당 구간을 덮어쓴다"는 문서화된 동작을 그대로 구현한다.
   *
   * repo.save()를 여기 쓰지 않는 이유(중요, Bug 회귀 방지):
   * PLAN_DATE는 `type:'date'` 복합 PK다. Oracle 드라이버는 이 타입의 컬럼을 조회 시
   * 문자열('YYYY-MM-DD')로 hydrate하는데, save()는 내부적으로 "이 PK가 이미 있는가"를
   * 판정하려고 SubjectDatabaseEntityLoader로 재조회한 뒤 OrmUtils.compareIds로 우리가 만든
   * 식별자(Date 객체)와 비교한다. Date 객체 vs 문자열은 항상 불일치로 판정되므로 save()는
   * 기존 PK가 있어도 매번 INSERT를 시도해 XPKIP_PRODUCT_*_CALENDAR 유니크 제약을 위반한다
   * (ORA-00001) — 두 번째 generate, 또는 이미 존재하는 날짜에 대한 bulkUpdateDays에서 재현됨.
   * delete()+insert()는 둘 다 QueryBuilder로 Date를 직접 바인딩해 저장하므로 이 판정 경로를
   * 완전히 우회한다(Between()/insert()는 findDays 등 읽기 경로에서 이미 정상 동작이 검증됨).
   *
   * C2 회귀 방지 — 트랜잭션으로 감싸는 이유:
   * delete()와 insert()가 각각 별도 autocommit이면, insert가 실패했을 때(동시 generate로 인한
   * ORA-00001, 타임아웃, 커넥션 끊김 등) delete만 반영되어 그 연도 월력이 통째로 0건으로
   * 남는다(영구 데이터 손실). 게다가 delete 커밋과 insert 커밋 사이에는 그 구간이 0건인
   * 읽기 창이 실제로 존재해서, 그 사이 F_GET_DELIVERY_DATE(납기일 계산 PL/SQL)가
   * HOLIDAY_YN을 하나도 없는 캘린더로 읽는다. tx.run()으로 delete+insert를 한 트랜잭션에 묶어
   * 둘 다 성공하거나 둘 다 롤백되게 한다. 또한 ensureNotConfirmed()를 트랜잭션 안에서
   * 같은 매니저로 다시 확인해, "확인 후 쓰기 전" 사이에 다른 트랜잭션이 확정 처리를 끼워넣는
   * 창을 좁힌다.
   */
  private async replaceRowsInRange(
    lineCode: string | undefined,
    organizationId: number,
    from: Date,
    to: Date,
    rows: unknown[],
    shifts: unknown[] = [],
    breaks: unknown[] = [],
  ): Promise<void> {
    await this.tx.run(async (qr) => {
      await this.ensureNotConfirmed(from, to, lineCode, organizationId, qr.manager);
      if (lineCode) {
        await qr.manager.delete(ProductLineCalendar, { organizationId, lineCode, planDate: Between(from, to) });
        if (rows.length > 0) await qr.manager.insert(ProductLineCalendar, rows as ProductLineCalendar[]);
      } else {
        await qr.manager.delete(ProductCompanyCalendar, { organizationId, planDate: Between(from, to) });
        if (rows.length > 0) await qr.manager.insert(ProductCompanyCalendar, rows as ProductCompanyCalendar[]);
      }
      // 부모를 지웠으면 자식도 같은 범위에서 지운다. 남겨두면 새로 만든 일자에 옛 교대조
      // 시간이 그대로 달라붙어 근무분이 사라진 근거로 계산된다.
      await this.replaceChildrenInRange(qr.manager, lineCode, organizationId, from, to, shifts, breaks);
    });
  }

  /** 자식(교대조/비작업)만 범위 교체한다. 부모 교체 트랜잭션 안에서만 호출한다. */
  private async replaceChildrenInRange(
    manager: EntityManager,
    lineCode: string | undefined,
    organizationId: number,
    from: Date,
    to: Date,
    shifts: unknown[],
    breaks: unknown[],
  ): Promise<void> {
    const owner = lineCode ?? COMPANY_LINE_CODE;
    await manager.delete(ProductCalendarShift, {
      organizationId,
      lineCode: owner,
      planDate: Between(from, to),
    });
    await manager.delete(ProductCalendarBreak, {
      organizationId,
      lineCode: owner,
      planDate: Between(from, to),
    });
    if (shifts.length > 0) await manager.insert(ProductCalendarShift, shifts as ProductCalendarShift[]);
    if (breaks.length > 0) await manager.insert(ProductCalendarBreak, breaks as ProductCalendarBreak[]);
  }

  /**
   * 특정 일자 목록(불연속 가능)에 대해서만 기존 행을 삭제하고 새 rows를 삽입한다.
   * bulkUpdateDays가 이미 존재하는 날짜를 수정할 때 쓴다 — replaceRowsInRange와 같은 이유로
   * save() 대신 delete()+insert()를 쓰고, 같은 이유로 트랜잭션(C2)으로 감싼다. 날짜 수는
   * 화면에서 오는 값(최대 1년 366개)이라 Oracle의 IN 리스트 1000개 제한(ORA-01795)에
   * 안전하게 들어온다.
   */
  private async replaceRowsByDates(
    lineCode: string | undefined,
    organizationId: number,
    from: Date,
    to: Date,
    planDates: Date[],
    rows: unknown[],
    shifts: unknown[] = [],
    breaks: unknown[] = [],
  ): Promise<void> {
    if (planDates.length === 0) return;
    const owner = lineCode ?? COMPANY_LINE_CODE;
    await this.tx.run(async (qr) => {
      await this.ensureNotConfirmed(from, to, lineCode, organizationId, qr.manager);
      if (lineCode) {
        await qr.manager.delete(ProductLineCalendar, { organizationId, lineCode, planDate: In(planDates) });
        await qr.manager.insert(ProductLineCalendar, rows as ProductLineCalendar[]);
      } else {
        await qr.manager.delete(ProductCompanyCalendar, { organizationId, planDate: In(planDates) });
        await qr.manager.insert(ProductCompanyCalendar, rows as ProductCompanyCalendar[]);
      }
      // 부모와 같은 의미로 "보낸 내용이 그 일자의 전부"다 — 요청에 shifts/breaks가 없으면
      // 그 일자의 자식행은 비워진다(교대시간 마스터 기본값으로 되돌아간다).
      await qr.manager.delete(ProductCalendarShift, {
        organizationId,
        lineCode: owner,
        planDate: In(planDates),
      });
      await qr.manager.delete(ProductCalendarBreak, {
        organizationId,
        lineCode: owner,
        planDate: In(planDates),
      });
      if (shifts.length > 0) await qr.manager.insert(ProductCalendarShift, shifts as ProductCalendarShift[]);
      if (breaks.length > 0) await qr.manager.insert(ProductCalendarBreak, breaks as ProductCalendarBreak[]);
    });
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
      // 자식은 findDays가 별도 조회해서 채운다. getSummary는 쓰지 않으므로 빈 배열로 둔다.
      shifts: [],
      breaks: [],
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
      shifts?: CalendarShift[];
      breaks?: CalendarBreak[];
    },
    lineCode: string | undefined,
    organizationId: number,
    shiftRows: ShiftTimeMaster[],
    userId?: string,
  ) {
    const dayType = day.dayType as WorkDayType;
    const shift = this.shiftTime.resolveFromRows(
      shiftRows,
      day.workDate,
    ) as ShiftTimeMasterLike | null;

    // buildRow()는 repo.create()를 거치지 않는 평범한 객체 리터럴을 반환하므로,
    // @CreateDateColumn(ENTER_DATE)/@UpdateDateColumn(LAST_MODIFY_DATE) 기본값이 적용되지 않는다
    // (엔티티 메타데이터 기반 초기화는 repo.create()/실제 엔티티 인스턴스에서만 동작한다).
    // 그래서 ENTER_BY/CONFIRM_YN과 마찬가지로 ENTER_DATE/LAST_MODIFY_DATE도 신규·기존 여부를
    // 구분하지 않고 매번 명시적으로 찍는다. 이 함수는 신규 삽입과 기존 일자 덮어쓰기(같은 PK로
    // save()) 양쪽에 다 쓰이므로, 기존 일자를 수정하면 ENTER_DATE가 "최초 생성 시각"이 아니라
    // "마지막 저장 시각"으로 갱신된다 — ENTER_BY/CONFIRM_YN을 무조건 리셋하는 기존 동작과 같은
    // 절충이다. 원본 생성 시각을 보존하려면 저장 전 기존 행을 조회해야 하므로(추가 쿼리 1회),
    // 여기서는 단순함을 택한다.
    const enterBy = userId ?? 'SYSTEM';
    const now = new Date();
    const base = {
      planDate: parseYmd(day.workDate),
      organizationId,
      dayType,
      holidayYn: holidayYnOf(dayType),
      offReason: dayType === 'OFF' ? (day.offReason ?? null) : null,
      workMinutes: day.workMinutes ?? this.deriveWorkMinutes(day, dayType, shift),
      otMinutes: day.otMinutes ?? 0,
      confirmYn: 'N',
      calendarComment: day.comment ?? null,
      enterBy,
      enterDate: now,
      lastModifyBy: enterBy,
      lastModifyDate: now,
    };

    // repo.create()는 새 엔티티 인스턴스에 필드를 병합해줄 뿐이므로,
    // insert()/save()에 넘길 값 자체는 이 평범한 객체로 충분하다.
    return lineCode ? { ...base, lineCode } : base;
  }

  /**
   * 근무분 파생. 그 일자에 교대조 행이 오면 그것이 근거이고(calendarWorkMinutes),
   * 없으면 교대시간 마스터에서 파생시킨다(defaultWorkMinutes) — 연간 생성은 자식행을
   * 만들지 않으므로 후자가 여전히 필요하다.
   */
  private deriveWorkMinutes(
    day: { shifts?: CalendarShift[]; breaks?: CalendarBreak[] },
    dayType: WorkDayType,
    shift: ShiftTimeMasterLike | null,
  ): number {
    const shifts = day.shifts ?? [];
    if (shifts.length === 0) return defaultWorkMinutes(dayType, shift);
    return calendarWorkMinutes(dayType, shifts, day.breaks ?? []);
  }

  /**
   * 요청의 days[]에서 자식(교대조/비작업) insert 행을 만든다.
   * 분이 0인 비작업 항목은 저장하지 않는다 — 화면이 모든 분류를 항상 보내기 때문에
   * 0을 그대로 넣으면 의미 없는 행이 일자마다 쌓인다.
   */
  private buildChildRows(
    days: {
      workDate: string;
      shifts?: CalendarShift[];
      breaks?: CalendarBreak[];
    }[],
    lineCode: string | undefined,
    organizationId: number,
    userId?: string,
  ): { shifts: unknown[]; breaks: unknown[] } {
    const owner = lineCode ?? COMPANY_LINE_CODE;
    const enterBy = userId ?? 'SYSTEM';
    const now = new Date();
    const shifts: unknown[] = [];
    const breaks: unknown[] = [];

    for (const day of days) {
      const planDate = parseYmd(day.workDate);
      for (const s of day.shifts ?? []) {
        shifts.push({
          planDate,
          organizationId,
          lineCode: owner,
          shiftCode: s.shiftCode,
          startTime: s.startTime,
          endTime: s.endTime,
          enterBy,
          enterDate: now,
          lastModifyBy: enterBy,
          lastModifyDate: now,
        });
      }
      for (const b of day.breaks ?? []) {
        if (!(b.breakMinutes > 0)) continue;
        breaks.push({
          planDate,
          organizationId,
          lineCode: owner,
          breakType: b.breakType,
          breakMinutes: b.breakMinutes,
          enterBy,
          enterDate: now,
          lastModifyBy: enterBy,
          lastModifyDate: now,
        });
      }
    }
    return { shifts, breaks };
  }

  /**
   * 범위 안에 확정(CONFIRM_YN='Y') 일자가 하나라도 있으면 거부한다.
   * manager가 주어지면(트랜잭션 내부 재확인, C2) 그 매니저의 리포지토리로 조회해 같은
   * 트랜잭션 안에서 최신 상태를 다시 본다. 없으면(쓰기 전 최초 확인) 평소 리포지토리를 쓴다.
   */
  private async ensureNotConfirmed(
    from: Date,
    to: Date,
    lineCode: string | undefined,
    organizationId: number,
    manager?: EntityManager,
  ): Promise<void> {
    const companyRepo = manager ? manager.getRepository(ProductCompanyCalendar) : this.companyRepo;
    const lineRepo = manager ? manager.getRepository(ProductLineCalendar) : this.lineRepo;
    const rows = lineCode
      ? await lineRepo.find({
          where: { organizationId, lineCode, planDate: Between(from, to) },
        })
      : await companyRepo.find({
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
    userId?: string,
  ): Promise<number> {
    const [from, to] = dto.month
      ? monthRange(`${dto.year}-${String(dto.month).padStart(2, '0')}`)
      : yearRange(dto.year);

    const lastModifyBy = userId ?? 'SYSTEM';
    const lastModifyDate = new Date();

    // repo.update(criteria, partial)로 CONFIRM_YN/감사 컬럼만 직접 UPDATE한다. find() 후
    // save(rows)로 되돌려 쓰지 않는 이유(Bug 회귀 방지):
    // find()가 반환하는 행은 PLAN_DATE(type:'date')가 Oracle 드라이버에 의해 이미 문자열
    // ('YYYY-MM-DD')로 hydrate돼 있다. save()는 저장 전 "정말 존재하는가"를 다시 확인하려고
    // 내부적으로 그 문자열 PLAN_DATE를 TO_DATE 변환 없이 그대로 재바인딩하는 SELECT를 날리는데,
    // 세션 NLS_DATE_FORMAT과 형식이 안 맞아 ORA-01861(literal does not match format string)이
    // 난다. update()는 QueryBuilder로 WHERE 절을 직접 구성해 이 재확인 경로 자체를 타지 않는다
    // (Between()은 findDays 등 읽기 경로에서 이미 정상 동작이 검증됨).
    const result = dto.lineCode
      ? await this.lineRepo.update(
          { organizationId, lineCode: dto.lineCode, planDate: Between(from, to) },
          { confirmYn, lastModifyBy, lastModifyDate },
        )
      : await this.companyRepo.update(
          { organizationId, planDate: Between(from, to) },
          { confirmYn, lastModifyBy, lastModifyDate },
        );

    return typeof result.affected === 'number' ? result.affected : 0;
  }
}

/**
 * @file entities/product-company-calendar.entity.ts
 * @description 전사 생산월력 — 은성 레거시 테이블 IP_PRODUCT_COMPANY_CALENDAR에 매핑한다.
 *
 * 초보자 가이드:
 * 1. PK는 PLAN_DATE + ORGANIZATION_ID 복합키다.
 * 2. HOLIDAY_YN은 DAY_TYPE의 미러다. PL/SQL F_GET_DELIVERY_DATE가 읽으므로 삭제하지 않는다.
 *    저장 시 @smt/shared의 holidayYnOf(dayType)로 파생시킨다 (DB CHECK 제약이 정합을 강제).
 * 3. CONFIRM_YN='Y'인 일자는 모든 쓰기 경로에서 차단된다.
 */
import { Entity, PrimaryColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity({ name: 'IP_PRODUCT_COMPANY_CALENDAR' })
export class ProductCompanyCalendar {
  @PrimaryColumn({ name: 'PLAN_DATE', type: 'date' })
  planDate: Date;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  /** 휴일유무: DAY_TYPE의 미러 (OFF='Y', 그 외='N') */
  @Column({ type: 'varchar2', name: 'HOLIDAY_YN', length: 1 })
  holidayYn: string;

  /** 근무유형: WORK/OFF/HALF/SPECIAL — 공통코드 WORK_DAY_TYPE */
  @Column({ type: 'varchar2', name: 'DAY_TYPE', length: 20, default: 'WORK' })
  dayType: string;

  /** 휴무사유 — 공통코드 DAY_OFF_TYPE (DAY_TYPE='OFF'일 때만) */
  @Column({ type: 'varchar2', name: 'OFF_REASON', length: 20, nullable: true })
  offReason: string | null;

  @Column({ type: 'number', name: 'WORK_MINUTES', default: 0 })
  workMinutes: number;

  @Column({ type: 'number', name: 'OT_MINUTES', default: 0 })
  otMinutes: number;

  @Column({ type: 'varchar2', name: 'CONFIRM_YN', length: 1, default: 'N' })
  confirmYn: string;

  @Column({ type: 'varchar2', name: 'CALENDAR_COMMENT', length: 500, nullable: true })
  calendarComment: string | null;

  @Column({ type: 'varchar2', name: 'ENTER_BY', length: 20, nullable: true })
  enterBy: string | null;

  @Column({ type: 'varchar2', name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  lastModifyBy: string | null;

  @CreateDateColumn({ name: 'ENTER_DATE', type: 'date' })
  enterDate: Date;

  @UpdateDateColumn({ name: 'LAST_MODIFY_DATE', type: 'date' })
  lastModifyDate: Date;
}

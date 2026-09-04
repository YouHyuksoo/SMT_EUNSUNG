/**
 * @file entities/product-calendar-break.entity.ts
 * @description 생산월력 일자별 비작업(휴게/식사) 시간 — IP_PRODUCT_CALENDAR_BREAK에 매핑한다.
 *
 * 초보자 가이드:
 * 1. PK는 PLAN_DATE + ORGANIZATION_ID + LINE_CODE + BREAK_TYPE 복합키다.
 * 2. LINE_CODE sentinel 규칙은 ProductCalendarShift와 같다('*' = 전사).
 * 3. 여기 담긴 분의 합이 근무분에서 차감된다 (@smt/shared calendarWorkMinutes).
 */
import { Entity, PrimaryColumn, Column } from 'typeorm';
import { COMPANY_LINE_CODE } from './product-calendar-shift.entity';

@Entity({ name: 'IP_PRODUCT_CALENDAR_BREAK' })
export class ProductCalendarBreak {
  @PrimaryColumn({ name: 'PLAN_DATE', type: 'date' })
  planDate: Date;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @PrimaryColumn({ type: 'varchar2', name: 'LINE_CODE', length: 20, default: COMPANY_LINE_CODE })
  lineCode: string;

  /** 비작업 분류 — 공통코드 'BREAK TYPE' (REST=휴게시간, MEAL=식사시간) */
  @PrimaryColumn({ type: 'varchar2', name: 'BREAK_TYPE', length: 20 })
  breakType: string;

  @Column({ type: 'number', name: 'BREAK_MINUTES', default: 0 })
  breakMinutes: number;

  @Column({ type: 'varchar2', name: 'ENTER_BY', length: 20 })
  enterBy: string;

  @Column({ type: 'date', name: 'ENTER_DATE' })
  enterDate: Date;

  @Column({ type: 'varchar2', name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  lastModifyBy: string | null;

  @Column({ type: 'date', name: 'LAST_MODIFY_DATE', nullable: true })
  lastModifyDate: Date | null;
}

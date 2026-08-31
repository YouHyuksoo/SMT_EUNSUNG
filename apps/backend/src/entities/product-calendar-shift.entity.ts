/**
 * @file entities/product-calendar-shift.entity.ts
 * @description 생산월력 일자별 교대조 작업시간 — IP_PRODUCT_CALENDAR_SHIFT에 매핑한다.
 *
 * 초보자 가이드:
 * 1. PK는 PLAN_DATE + ORGANIZATION_ID + LINE_CODE + SHIFT_CODE 복합키다.
 * 2. LINE_CODE는 PK라 NULL을 못 쓴다. 전사 월력은 sentinel '*'를 넣는다(COMPANY_LINE_CODE).
 * 3. 행이 없는 일자는 교대시간 마스터(IP_SHIFT_TIME_MASTER) 기본값을 따른다 — 즉 이 테이블은
 *    "그 날만의 예외"만 담는다.
 */
import { Entity, PrimaryColumn, Column } from 'typeorm';

/** 전사 월력을 뜻하는 LINE_CODE sentinel. 라인 예외는 실제 라인코드를 쓴다. */
export const COMPANY_LINE_CODE = '*';

@Entity({ name: 'IP_PRODUCT_CALENDAR_SHIFT' })
export class ProductCalendarShift {
  @PrimaryColumn({ name: 'PLAN_DATE', type: 'date' })
  planDate: Date;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @PrimaryColumn({ type: 'varchar2', name: 'LINE_CODE', length: 20, default: COMPANY_LINE_CODE })
  lineCode: string;

  /** 교대조 — 공통코드 'SHIFT CODE' (A=1교대, B=2교대) */
  @PrimaryColumn({ type: 'varchar2', name: 'SHIFT_CODE', length: 10 })
  shiftCode: string;

  /** 'HH:MM'. END_TIME이 START_TIME보다 이르면 자정을 넘긴 야간 교대다. */
  @Column({ type: 'varchar2', name: 'START_TIME', length: 8 })
  startTime: string;

  @Column({ type: 'varchar2', name: 'END_TIME', length: 8 })
  endTime: string;

  @Column({ type: 'varchar2', name: 'ENTER_BY', length: 20 })
  enterBy: string;

  @Column({ type: 'date', name: 'ENTER_DATE' })
  enterDate: Date;

  @Column({ type: 'varchar2', name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  lastModifyBy: string | null;

  @Column({ type: 'date', name: 'LAST_MODIFY_DATE', nullable: true })
  lastModifyDate: Date | null;
}

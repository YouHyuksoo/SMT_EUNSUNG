/**
 * @file entities/product-calendar-line-run.entity.ts
 * @description 생산월력 일자별 라인 추가 운영 — IP_PRODUCT_CALENDAR_LINE_RUN에 매핑한다.
 *
 * 초보자 가이드:
 * 1. PK는 PLAN_DATE + ORGANIZATION_ID + LINE_CODE + RUN_SEQ 복합키다.
 * 2. LINE_CODE는 **월력 소유자**다('*' = 전사). 형제 테이블과 같은 의미다.
 *    실제로 추가 운영하는 라인은 RUN_LINE_CODE에 들어간다 — 둘은 다른 값이다.
 * 3. RUN_SEQ가 PK에 있어 같은 라인을 오전/야간처럼 여러 구간으로 등록할 수 있다.
 * 4. 여기 담긴 가동분의 합이 근무분에 더해진다 (@smt/shared calendarWorkMinutes).
 */
import { Entity, PrimaryColumn, Column } from 'typeorm';
import { COMPANY_LINE_CODE } from './product-calendar-shift.entity';

@Entity({ name: 'IP_PRODUCT_CALENDAR_LINE_RUN' })
export class ProductCalendarLineRun {
  @PrimaryColumn({ name: 'PLAN_DATE', type: 'date' })
  planDate: Date;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  /** 월력 소유자. 추가 운영 라인이 아니다. */
  @PrimaryColumn({ type: 'varchar2', name: 'LINE_CODE', length: 20, default: COMPANY_LINE_CODE })
  lineCode: string;

  /** 행 순번 — 같은 라인 복수 구간을 구분한다. 1부터 매긴다. */
  @PrimaryColumn({ type: 'number', name: 'RUN_SEQ' })
  runSeq: number;

  /** 추가 운영 대상 라인 (IP_PRODUCT_LINE) */
  @Column({ type: 'varchar2', name: 'RUN_LINE_CODE', length: 20 })
  runLineCode: string;

  /** 'HH:MM'. END_TIME이 START_TIME보다 이르면 자정을 넘긴 것이다. */
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

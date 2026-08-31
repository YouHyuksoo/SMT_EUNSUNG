/**
 * @file entities/shift-time-break.entity.ts
 * @description 교대시간 마스터의 슬롯별 비작업 시간 — IP_SHIFT_TIME_BREAK에 매핑한다.
 *
 * 초보자 가이드:
 * 1. PK는 DATESET + ORGANIZATION_ID + SHIFT_SLOT + BREAK_TYPE 복합키다.
 * 2. SHIFT_SLOT은 마스터의 컬럼 구조를 그대로 따른다 — 'DAY'는 DAY_TIME_*, 'NIGHT'는
 *    NIGHT_TIME_*. 화면에 보이는 교대조명(1교대/2교대)은 공통코드 'SHIFT CODE'로 붙일 뿐
 *    저장 구조와는 별개다.
 * 3. IP_SHIFT_TIME_MASTER.DAY_BREAK_MINUTES / NIGHT_BREAK_MINUTES는 이 테이블의 슬롯별
 *    합으로 서버가 갱신하는 롤업이다. 클라이언트 값을 그대로 믿지 않는다.
 */
import { Entity, PrimaryColumn, Column } from 'typeorm';

/** 교대 슬롯 — 마스터의 DAY_TIME_* / NIGHT_TIME_* 컬럼과 1:1 */
export const SHIFT_SLOTS = ['DAY', 'NIGHT'] as const;
export type ShiftSlot = (typeof SHIFT_SLOTS)[number];

@Entity({ name: 'IP_SHIFT_TIME_BREAK' })
export class ShiftTimeBreak {
  @PrimaryColumn({ name: 'DATESET', type: 'date' })
  dateset: Date;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @PrimaryColumn({ type: 'varchar2', name: 'SHIFT_SLOT', length: 10 })
  shiftSlot: string;

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

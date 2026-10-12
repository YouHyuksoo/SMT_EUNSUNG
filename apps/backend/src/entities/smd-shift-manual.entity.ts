/**
 * @file entities/smd-shift-manual.entity.ts
 * @description 반제품생산계획 주간·야간 수기실적 — IP_PRODUCT_SMD_SHIFT_MANUAL 에 매핑한다.
 *
 * 초보자 가이드:
 * 1. PK 는 반제품생산계획 키(PLAN_DATE + PLAN_SEQUENCE + ORGANIZATION_ID) + SHIFT_SLOT 이다.
 * 2. SHIFT_SLOT 'DAY' = 주간(08:30~20:30, 센서 시간구분 A~E), 'NIGHT' = 야간(20:30~다음날 08:30, F~J).
 *    계획의 SHIFT_CODE(1교대/2교대)와는 다른 값이다.
 * 3. 행이 있으면 그 근무조 실적은 이 수량을 쓰고, 행을 지우면 센서 자동 집계로 돌아간다.
 * 4. 읽기·쓰기는 SmdActualService 가 원시 SQL 로 한다(계획일을 문자열 키로 다루기 위해서다).
 *    DDL: oracle_db_scripts/IP_PRODUCT_SMD_SHIFT_MANUAL.sql
 */
import { Column, Entity, PrimaryColumn } from 'typeorm';

/** 근무조 — 주간 / 야간 */
export const SMD_SHIFT_SLOTS = ['DAY', 'NIGHT'] as const;
export type SmdShiftSlot = (typeof SMD_SHIFT_SLOTS)[number];

@Entity({ name: 'IP_PRODUCT_SMD_SHIFT_MANUAL' })
export class SmdShiftManual {
  @PrimaryColumn({ name: 'PLAN_DATE', type: 'date' })
  planDate!: Date;

  @PrimaryColumn({ name: 'PLAN_SEQUENCE', type: 'number' })
  planSequence!: number;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @PrimaryColumn({ name: 'SHIFT_SLOT', type: 'varchar2', length: 10 })
  shiftSlot!: string;

  @Column({ name: 'MANUAL_QTY', type: 'number' })
  manualQty!: number;

  @Column({ name: 'ENTER_BY', type: 'varchar2', length: 30 })
  enterBy!: string;

  @Column({ name: 'ENTER_DATE', type: 'date' })
  enterDate!: Date;

  @Column({ name: 'LAST_MODIFY_BY', type: 'varchar2', length: 30, nullable: true })
  lastModifyBy!: string | null;

  @Column({ name: 'LAST_MODIFY_DATE', type: 'date', nullable: true })
  lastModifyDate!: Date | null;
}

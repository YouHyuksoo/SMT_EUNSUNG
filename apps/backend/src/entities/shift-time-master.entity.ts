/**
 * @file entities/shift-time-master.entity.ts
 * @description 2교대 시간 마스터 — 은성 레거시 테이블 IP_SHIFT_TIME_MASTER에 매핑한다.
 *
 * 초보자 가이드:
 * 1. 유효기간형이다. DATESET ~ DATEEND 구간이 적용되며 DATEEND=null이면 무기한이다.
 * 2. 원본 테이블에는 PK가 없었다. 2026-07-14 마이그레이션이 (ORGANIZATION_ID, DATESET) PK를 부여했다.
 * 3. 야간 교대는 자정을 넘긴다(예: 20:00~08:00). 근무분 계산은 @smt/shared가 담당한다.
 */
import { Entity, PrimaryColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity({ name: 'IP_SHIFT_TIME_MASTER' })
export class ShiftTimeMaster {
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  /** 적용 시작일 */
  @PrimaryColumn({ name: 'DATESET', type: 'date' })
  dateset: Date;

  /** 적용 종료일 (null = 무기한) */
  @Column({ type: 'date', name: 'DATEEND', nullable: true })
  dateend: Date | null;

  @Column({ type: 'varchar2', name: 'DAY_TIME_START', length: 8, nullable: true })
  dayTimeStart: string | null;

  @Column({ type: 'varchar2', name: 'DAY_TIME_END', length: 8, nullable: true })
  dayTimeEnd: string | null;

  @Column({ type: 'number', name: 'DAY_BREAK_MINUTES', default: 0 })
  dayBreakMinutes: number;

  @Column({ type: 'varchar2', name: 'NIGHT_TIME_START', length: 8, nullable: true })
  nightTimeStart: string | null;

  @Column({ type: 'varchar2', name: 'NIGHT_TIME_END', length: 8, nullable: true })
  nightTimeEnd: string | null;

  @Column({ type: 'number', name: 'NIGHT_BREAK_MINUTES', default: 0 })
  nightBreakMinutes: number;

  @Column({ type: 'varchar2', name: 'ENTER_BY', length: 20, nullable: true })
  enterBy: string | null;

  @Column({ type: 'varchar2', name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  lastModifyBy: string | null;

  @CreateDateColumn({ name: 'ENTER_DATE', type: 'date' })
  enterDate: Date;

  @UpdateDateColumn({ name: 'LAST_MODIFY_DATE', type: 'date' })
  lastModifyDate: Date;
}

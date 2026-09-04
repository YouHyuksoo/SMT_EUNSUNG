// 설비비가동 실적 (IP_EQUIP_DOWNTIME_RESULT) — 종료 NULL=진행중
import { Entity, PrimaryColumn, Column } from 'typeorm';

@Entity({ name: 'IP_EQUIP_DOWNTIME_RESULT' })
export class EquipDowntimeResult {
  @PrimaryColumn({ name: 'DT_SEQ', type: 'number' }) dtSeq: number;
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' }) organizationId: number;

  // 작업지시 없이 발생한 비가동은 NULL (ADR 0002)
  @Column({ name: 'RUN_NO', length: 30, nullable: true }) runNo: string | null;
  @Column({ name: 'MACHINE_CODE', length: 30, nullable: true }) machineCode: string | null;
  @Column({ name: 'WORKSTAGE_CODE', length: 10, nullable: true }) workstageCode: string | null;
  @Column({ name: 'REASON_CODE', length: 20, nullable: true }) reasonCode: string | null;
  @Column({ name: 'START_TIME', type: 'date', nullable: true }) startTime: Date | null;
  @Column({ name: 'END_TIME', type: 'date', nullable: true }) endTime: Date | null;
  @Column({ name: 'MEMO', length: 500, nullable: true }) memo: string | null;
  @Column({ name: 'WORKER', length: 100, nullable: true }) worker: string | null;
  @Column({ name: 'ENTER_BY', length: 20, nullable: true }) enterBy: string | null;
  @Column({ name: 'ENTER_DATE', type: 'date', nullable: true }) enterDate: Date | null;
  @Column({ name: 'LAST_MODIFY_BY', length: 20, nullable: true }) lastModifyBy: string | null;
  @Column({ name: 'LAST_MODIFY_DATE', type: 'date', nullable: true }) lastModifyDate: Date | null;
}

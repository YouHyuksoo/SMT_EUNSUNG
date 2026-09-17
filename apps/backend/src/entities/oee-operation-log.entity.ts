/**
 * @file entities/oee-operation-log.entity.ts
 * @description OEE 가동/비가동 일지 — OEE_OPERATION_LOG 매핑.
 * 한 행 = 한 리소스가 특정 상태(RUN/DOWN)로 머문 구간.
 * 근거: docs/specs/2026-07-06-oee-management-design.md §3-③
 */
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity({ name: 'OEE_OPERATION_LOG' })
export class OeeOperationLog {
  @PrimaryGeneratedColumn('identity', { name: 'LOG_ID' })
  logId: number;

  @Column({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId: number;

  @Column({ name: 'RESOURCE_ID', type: 'number' })
  resourceId: number;

  @Column({ name: 'PROCESS_CODE', length: 20 })
  processCode: string;

  @Column({ name: 'WORK_DATE', type: 'date' })
  workDate: Date;

  @Column({ name: 'SHIFT', length: 10 })
  shift: string; // DAY/NIGHT

  @Column({ name: 'START_TIME', type: 'date' })
  startTime: Date;

  @Column({ name: 'END_TIME', type: 'date' })
  endTime: Date;

  @Column({ name: 'DURATION_MIN', type: 'number' })
  durationMin: number;

  @Column({ name: 'STATUS', length: 10 })
  status: string; // RUN/DOWN

  @Column({ name: 'REASON_CODE', length: 20, nullable: true })
  reasonCode: string | null;

  @Column({ name: 'RUN_NO', length: 50, nullable: true })
  runNo: string | null;

  @Column({ name: 'REMARK', length: 500, nullable: true })
  remark: string | null;

  @Column({ name: 'CREATED_BY', length: 50 })
  createdBy: string;

  @Column({ name: 'CREATED_DATE', type: 'date', default: () => 'SYSDATE' })
  createdDate: Date;
}

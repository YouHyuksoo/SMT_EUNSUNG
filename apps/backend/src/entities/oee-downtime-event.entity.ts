import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity({ name: 'OEE_DOWNTIME_EVENT' })
export class OeeDowntimeEvent {
  @PrimaryGeneratedColumn('identity', { name: 'EVENT_ID', type: 'number' })
  eventId: number;

  @Column({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId: number;

  @Column({ name: 'RESOURCE_TYPE', type: 'varchar2', length: 10 })
  resourceType: 'LINE' | 'CELL';

  @Column({ name: 'RESOURCE_CODE', type: 'varchar2', length: 50 })
  resourceCode: string;

  @Column({ name: 'PARENT_LINE_CODE', type: 'varchar2', length: 50 })
  parentLineCode: string;

  @Column({ name: 'PROCESS_CODE', type: 'varchar2', length: 20 })
  processCode: 'SMT' | 'ASSY';

  @Column({ name: 'WORK_DATE', type: 'date' })
  workDate: Date;

  @Column({ name: 'WORK_SEGMENT', type: 'varchar2', length: 5 })
  workSegment: 'DAY' | 'NIGHT';

  @Column({ name: 'START_TIME', type: 'timestamp', precision: 6 })
  startTime: Date;

  @Column({ name: 'END_TIME', type: 'timestamp', precision: 6, nullable: true })
  endTime: Date | null;

  @Column({ name: 'REASON_CODE', type: 'varchar2', length: 100 })
  reasonCode: string;

  @Column({ name: 'MEMO', type: 'varchar2', length: 500, nullable: true })
  memo: string | null;

  @Column({ name: 'WORKER_ID', type: 'varchar2', length: 20 })
  workerId: string;

  @Column({ name: 'START_REQUEST_ID', type: 'varchar2', length: 64 })
  startRequestId: string;

  @Column({ name: 'END_REQUEST_ID', type: 'varchar2', length: 64, nullable: true })
  endRequestId: string | null;

  @Column({ name: 'STARTED_BY', type: 'varchar2', length: 20 })
  startedBy: string;

  @Column({ name: 'ENDED_BY', type: 'varchar2', length: 20, nullable: true })
  endedBy: string | null;

  @Column({ name: 'CREATED_DATE', type: 'timestamp', precision: 6 })
  createdDate: Date;

  @Column({ name: 'UPDATED_DATE', type: 'timestamp', precision: 6 })
  updatedDate: Date;
}

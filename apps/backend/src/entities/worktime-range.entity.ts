import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity({ name: 'ICOM_WORKTIME_RANGES' })
export class WorktimeRange {
  /** The source table has no PK; this is the logical key used by TypeORM. */
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId: number;

  @PrimaryColumn({ name: 'RANGE_TYPE', type: 'varchar2', length: 20 })
  rangeType: string;

  @PrimaryColumn({ name: 'WORK_TYPE', type: 'varchar2', length: 1 })
  workType: string;

  @Column({ name: 'START_TIME', type: 'varchar2', length: 6, nullable: true })
  startTime: string | null;

  @Column({ name: 'END_TIME', type: 'varchar2', length: 6, nullable: true })
  endTime: string | null;

  @Column({ name: 'ATTRIBUTE01', type: 'varchar2', length: 10, nullable: true })
  attribute01: string | null;

  @Column({ name: 'ATTRIBUTE02', type: 'varchar2', length: 10, nullable: true })
  attribute02: string | null;
}

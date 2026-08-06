// 설비 비가동 사유코드 마스터 (IP_EQUIP_DOWNTIME_REASON)
import { Entity, PrimaryColumn, Column } from 'typeorm';

@Entity({ name: 'IP_EQUIP_DOWNTIME_REASON' })
export class EquipDowntimeReason {
  @PrimaryColumn({ name: 'REASON_CODE', length: 20 })
  reasonCode: string;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId: number;

  @Column({ name: 'REASON_NAME', length: 100 })
  reasonName: string;

  @Column({ name: 'DESCRIPTION', length: 500, nullable: true })
  description: string | null;

  @Column({ name: 'REASON_TYPE', length: 10, nullable: true })
  reasonType: string | null; // PLAN | UNPLAN

  @Column({ name: 'OEE_REFLECT_YN', length: 1, nullable: true })
  oeeReflectYn: string | null; // Y | N

  @Column({ name: 'DISPLAY_ORDER', type: 'number', nullable: true })
  displayOrder: number | null;

  @Column({ name: 'STD_TIME_YN', length: 1, nullable: true })
  stdTimeYn: string | null; // Y | N

  @Column({ name: 'STD_TIME_VALUE', type: 'number', nullable: true })
  stdTimeValue: number | null;

  @Column({ name: 'STD_TIME_UNIT', length: 10, nullable: true })
  stdTimeUnit: string | null; // HOUR | MIN | SEC

  @Column({ name: 'USE_YN', length: 1, nullable: true })
  useYn: string | null; // Y | N

  @Column({ name: 'ENTER_BY', length: 20, nullable: true })
  enterBy: string | null;

  @Column({ name: 'ENTER_DATE', type: 'date', nullable: true })
  enterDate: Date | null;

  @Column({ name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  lastModifyBy: string | null;

  @Column({ name: 'LAST_MODIFY_DATE', type: 'date', nullable: true })
  lastModifyDate: Date | null;
}

// 설비별 비가동 사유 연계 헤더 (IP_EQUIP_DOWNTIME_MAP)
import { Entity, PrimaryColumn, Column } from 'typeorm';

@Entity({ name: 'IP_EQUIP_DOWNTIME_MAP' })
export class EquipDowntimeMap {
  @PrimaryColumn({ name: 'MACHINE_CODE', length: 30 })
  machineCode: string;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId: number;

  @Column({ name: 'ENTER_BY', length: 20, nullable: true })
  enterBy: string | null;

  @Column({ name: 'ENTER_DATE', type: 'date', nullable: true })
  enterDate: Date | null;

  @Column({ name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  lastModifyBy: string | null;

  @Column({ name: 'LAST_MODIFY_DATE', type: 'date', nullable: true })
  lastModifyDate: Date | null;
}

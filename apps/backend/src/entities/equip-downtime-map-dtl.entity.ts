// 설비×비가동사유 매핑 디테일 (IP_EQUIP_DOWNTIME_MAP_DTL)
import { Entity, PrimaryColumn, Column } from 'typeorm';

@Entity({ name: 'IP_EQUIP_DOWNTIME_MAP_DTL' })
export class EquipDowntimeMapDtl {
  @PrimaryColumn({ name: 'MACHINE_CODE', length: 30 })
  machineCode: string;

  @PrimaryColumn({ name: 'REASON_CODE', length: 20 })
  reasonCode: string;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId: number;

  @Column({ name: 'SORT_NO', type: 'number', nullable: true })
  sortNo: number | null;

  @Column({ name: 'ENTER_BY', length: 20, nullable: true })
  enterBy: string | null;

  @Column({ name: 'ENTER_DATE', type: 'date', nullable: true })
  enterDate: Date | null;
}

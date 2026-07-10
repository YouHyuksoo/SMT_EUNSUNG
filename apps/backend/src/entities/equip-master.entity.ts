/**
 * @file entities/equip-master.entity.ts
 * @description 설비 마스터 엔티티 - 은성전장 IMCN_MACHINE 설비 정보를 관리한다.
 *              MACHINE_CODE + ORGANIZATION_ID를 자연키 PK로 사용한다.
 *
 * 초보자 가이드:
 * 1. equipCode는 IMCN_MACHINE.MACHINE_CODE에 매핑된다.
 * 2. equipType은 IMCN_MACHINE.MACHINE_TYPE 현장 코드를 그대로 사용한다.
 * 3. 기존 화면 호환을 위해 프론트 필드명은 equipCode/equipName을 유지한다.
 */
import {
  Entity,
  PrimaryColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  OneToMany,
} from 'typeorm';
import { EquipBomRel } from './equip-bom-rel.entity';

@Entity({ name: 'IMCN_MACHINE' })
@Index(['equipType'])
@Index(['lineCode'])
@Index(['status'])
export class EquipMaster {
  @PrimaryColumn({ name: 'MACHINE_CODE', length: 30 })
  equipCode: string;

  @Column({ name: 'MACHINE_NAME', length: 100 })
  equipName: string;

  @Column({ type: 'varchar2', name: 'MACHINE_TYPE', length: 10 })
  equipType: string;

  @Column({ type: 'varchar2', name: 'MACHINE_MODEL_NAME', length: 86, nullable: true })
  modelName: string | null;

  @Column({ type: 'varchar2', name: 'MACHINE_IMAGE_FILE_NAME', length: 200, nullable: true })
  imageUrl: string | null;

  @Column({ type: 'varchar2', name: 'SUPPLIER_CODE', length: 20, nullable: true })
  maker: string | null;

  @Column({ type: 'varchar2', name: 'LINE_CODE', length: 20 })
  lineCode: string | null;

  @Column({ type: 'varchar2', name: 'WORKSTAGE_CODE', length: 10, nullable: true })
  processCode: string | null;

  @Column({ type: 'varchar2', name: 'IP_ADDRESS', length: 30, nullable: true })
  ipAddress: string | null;

  @Column({ name: 'PORT_NO', type: 'number', nullable: true })
  port: number | null;

  commType?: string | null;

  commConfig?: string | null;

  @Column({ name: 'ACQUISITION_DATE', type: 'date', nullable: true })
  installDate: Date | null;

  @Column({ name: 'MACHINE_STATUS_CODE', length: 10, default: 'N', nullable: true })
  status: string;

  currentJobOrderId?: string | null;

  currentWorkerCodes?: string | null;

  @Column({ name: 'MES_DISPLAY_YN', length: 1, default: 'Y', nullable: true })
  useYn: string;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @Column({ type: 'varchar2', name: 'ACQUISITION_TYPE', length: 10, default: '*' })
  acquisitionType: string;

  @Column({ type: 'varchar2', name: 'ENTER_BY', length: 20, nullable: true })
  createdBy: string | null;

  @Column({ type: 'varchar2', name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  updatedBy: string | null;

  @CreateDateColumn({ name: 'ENTER_DATE', type: 'date' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'LAST_MODIFY_DATE', type: 'date' })
  updatedAt: Date;

  // Relations
  @OneToMany(() => EquipBomRel, (rel) => rel.equipment)
  bomRels: EquipBomRel[];

  /** IMCN_MACHINE에는 통신 JSON 컬럼이 없으므로 기존 호출 호환용으로만 유지한다. */
  getCommConfigObject(): Record<string, unknown> | null {
    return null;
  }

  /** IMCN_MACHINE에는 통신 JSON 컬럼이 없으므로 기존 호출 호환용으로만 유지한다. */
  setCommConfigObject(obj: Record<string, unknown>): void {
    this.commConfig = JSON.stringify(obj);
  }
}

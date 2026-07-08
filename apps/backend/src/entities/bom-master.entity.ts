/**
 * @file bom-master.entity.ts
 * @description 은성전장 Legacy BOM 엔티티.
 *              원장은 ID_ENG_BOM이고, 적용일자는 DATESET/DATEEND 컬럼을 사용한다.
 */
import { Column, Entity, Index, PrimaryColumn } from 'typeorm';

@Entity({ name: 'ID_ENG_BOM' })
@Index(['parentItemCode'])
@Index(['childItemCode'])
export class BomMaster {
  @PrimaryColumn({ name: 'PARENT_ITEM_CODE', length: 30 })
  parentItemCode: string;

  @PrimaryColumn({ name: 'CHILD_ITEM_CODE', length: 30 })
  childItemCode: string;

  @PrimaryColumn({ name: 'DATESET', type: 'date' })
  validFrom: Date;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @Column({ name: 'DATEEND', type: 'date' })
  validTo: Date | null;

  @Column({ name: 'ITEM_UNIT_QTY', type: 'number' })
  qtyPer: number;

  @Column({ name: 'ITEM_UNIT_QTY_EXT', type: 'number', nullable: true })
  itemUnitQtyExt: number | null;

  @Column({ name: 'SORT_SEQUENCE', type: 'number' })
  seq: number;

  @Column({ type: 'varchar2', name: 'WORKSTAGE_CODE', length: 10 })
  processCode: string | null;

  @Column({ type: 'varchar2', name: 'ITEM_TYPE', length: 10 })
  itemType: string;

  @Column({ type: 'varchar2', name: 'LINE_TYPE', length: 10 })
  lineType: string;

  @Column({ name: 'BOM_WORK_NO', type: 'number', nullable: true })
  bomWorkNo: number | null;

  @Column({ name: 'REVISION', length: 10, nullable: true })
  revision: string | null;

  @Column({ type: 'varchar2', name: 'ASSY_EXPLOSION_YN', length: 1, default: 'N' })
  assyExplosionYn: string;

  @Column({ name: 'LOSS_RATE', type: 'number', nullable: true })
  lossRate: number | null;

  @Column({ name: 'SCRAP_RATE', type: 'number', nullable: true })
  scrapRate: number | null;

  @Column({ type: 'varchar2', name: 'LOCATION_INFO', length: 2500, nullable: true })
  remark: string | null;

  @Column({ type: 'varchar2', name: 'ITEM_CODE', length: 20, nullable: true })
  itemCode: string | null;

  @Column({ type: 'varchar2', name: 'LINE_CODE', length: 20, nullable: true })
  lineCode: string | null;

  @Column({ type: 'varchar2', name: 'PCB_ITEM', length: 20, nullable: true })
  pcbItem: string | null;

  @Column({ type: 'varchar2', name: 'ENTER_BY', length: 20, nullable: true })
  createdBy: string | null;

  @Column({ type: 'date', name: 'ENTER_DATE', nullable: true })
  createdAt: Date | null;

  @Column({ type: 'varchar2', name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  updatedBy: string | null;

  @Column({ type: 'date', name: 'LAST_MODIFY_DATE', nullable: true })
  updatedAt: Date | null;

  /** 화면 호환용 비저장 필드 */
  bomGrp?: string | null;
  side?: string | null;
  ecoNo?: string | null;
  useYn?: string;
}

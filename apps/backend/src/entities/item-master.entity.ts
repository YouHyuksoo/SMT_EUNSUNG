/**
 * @file item-master.entity.ts
 * @description 품목 마스터(ItemMaster) 엔티티 - 은성전장 ID_ITEM 테이블 매핑.
 */
import {
  Entity,
  PrimaryColumn,
  Column,
  Index,
} from 'typeorm';

@Entity({ name: 'ID_ITEM' })
@Index(['itemType'])
export class ItemMaster {
  @PrimaryColumn({ name: 'ITEM_CODE', length: 20 })
  itemCode: string;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @Column({ name: 'ITEM_NAME', length: 300 })
  itemName: string;

  @Column({ name: 'PART_NO', type: 'varchar2', length: 200, nullable: true })
  itemNo: string;

  @Column({ type: 'varchar2', name: 'CUSTOMER_PART_NO', length: 50, nullable: true })
  custPartNo: string | null;

  @Column({ name: 'ITEM_TYPE', length: 10 })
  itemType: string;

  @Column({ type: 'varchar2', name: 'ITEM_CLASS', length: 20 })
  productType: string;

  @Column({ type: 'varchar2', name: 'LINE_TYPE', length: 10 })
  lineType: string;

  @Column({ type: 'varchar2', name: 'ITEM_DIVISION', length: 30 })
  itemDivision: string;

  @Column({ type: 'varchar2', name: 'MODEL_NAME', length: 100, nullable: true })
  modelName: string | null;

  @Column({ type: 'varchar2', name: 'MODEL_SUFFIX', length: 50, nullable: true })
  defectModelGroup: string | null;

  @Column({ type: 'varchar2', name: 'ITEM_SPEC', length: 300 })
  spec: string | null;

  @Column({ type: 'varchar2', name: 'ABC_GRADE', length: 1 })
  rev: string | null;

  @Column({ type: 'varchar2', name: 'BARCODE', length: 100, nullable: true })
  markingText: string | null;

  @Column({ name: 'ITEM_UOM', length: 3, default: 'EA' })
  unit: string;

  @Column({ type: 'varchar2', name: 'MODEL_COLOR', length: 20, nullable: true })
  color: string | null;

  @Column({ type: 'varchar2', name: 'DRAWING_NO', length: 30, nullable: true })
  drawNo: string | null;

  @Column({ name: 'MANUFACTURE_LEADTIME', type: 'number', nullable: true })
  leadTime: number;

  @Column({ name: 'SAFETY_INVENTORY', type: 'number', nullable: true })
  safetyStock: number;

  @Column({ name: 'MATERIAL_QTY', type: 'number', nullable: true })
  lotUnitQty: number | null;

  @Column({ name: 'ISSUE_PACKING_QTY', type: 'number', nullable: true })
  boxQty: number;

  @Column({ name: 'MATERIAL_QTY2', type: 'number', nullable: true })
  minPackQty: number;

  @Column({ name: 'CAPACITY', type: 'number', nullable: true })
  tactTime: number;

  @Column({ name: 'LIFE_CYCLE', type: 'number', nullable: true })
  expiryDate: number;

  @Column({ name: 'MSL_MAX_TIME', type: 'number', nullable: true })
  expiryExtDays: number;

  @Column({ name: 'WORK_BAD_RATE', type: 'number', nullable: true })
  toleranceRate: number; // PO 수량 오차 허용률 (%)

  @Column({ name: 'SET_ITEM_YN', length: 1, nullable: true })
  isSplittable: string; // 자재 분할 가능 여부 (Y/N)

  @Column({ type: 'number', name: 'CARRIER_SIZE', nullable: true })
  packUnit: number | null; // 팔레트 구성 단위(팔레트당 박스 수)

  @Column({ type: 'varchar2', name: 'LOCATION_ADDRESS', length: 20, nullable: true })
  storageLocation: string | null;

  @Column({ type: 'varchar2', name: 'FEEDER_LAYOUT_COMMENTS', length: 2000, nullable: true })
  imageUrl: string | null;

  @Column({ type: 'varchar2', name: 'COMMENTS', length: 1000, nullable: true })
  remark: string | null;

  @Column({ name: 'MES_DISPLAY_YN', length: 1, nullable: true })
  useYn: string;

  @Column({ type: 'varchar2', name: 'ENTER_BY', length: 20, nullable: true })
  createdBy: string | null;

  @Column({ type: 'varchar2', name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  updatedBy: string | null;

  @Column({ name: 'ENTER_DATE', type: 'date', nullable: true })
  createdAt: Date;

  @Column({ name: 'LAST_MODIFY_DATE', type: 'date', nullable: true })
  updatedAt: Date;
}

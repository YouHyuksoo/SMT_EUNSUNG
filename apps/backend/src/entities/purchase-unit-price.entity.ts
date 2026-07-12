import { Column, CreateDateColumn, Entity, PrimaryColumn, UpdateDateColumn } from 'typeorm';

@Entity({ name: 'IM_ITEM_UNIT_PRICE' })
export class PurchaseUnitPrice {
  @PrimaryColumn({ name: 'DATESET', type: 'date' })
  dateset: Date;

  @PrimaryColumn({ name: 'ITEM_CODE', type: 'varchar2', length: 20 })
  itemCode: string;

  @PrimaryColumn({ name: 'SUPPLIER_CODE', type: 'varchar2', length: 20 })
  supplierCode: string;

  @PrimaryColumn({ name: 'LINE_TYPE', type: 'varchar2', length: 10 })
  lineType: string;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId: number;

  @Column({ name: 'DATEEND', type: 'date' })
  dateend: Date;

  @Column({ name: 'UNIT_PRICE', type: 'number' })
  unitPrice: number;

  @Column({ name: 'STANDARD_UNIT_PRICE', type: 'number', nullable: true })
  standardUnitPrice: number | null;

  @Column({ name: 'TAX_RATE', type: 'number', nullable: true })
  taxRate: number | null;

  @Column({ name: 'CURRENCY', type: 'varchar2', length: 3 })
  currency: string;

  @Column({ name: 'DELIVERY', type: 'varchar2', length: 10 })
  delivery: string;

  @Column({ name: 'PRICE_TYPE', type: 'varchar2', length: 1 })
  priceType: string;

  @Column({ name: 'PRICE_CHANGE_REASON', type: 'varchar2', length: 10 })
  priceChangeReason: string;

  @Column({ name: 'APPROVAL_NO', type: 'varchar2', length: 30, nullable: true })
  approvalNo: string | null;

  @Column({ name: 'PRICE_CHANGE_CONFIRM_YN', type: 'varchar2', length: 1, nullable: true })
  priceChangeConfirmYn: string | null;

  @Column({ name: 'CONFIRM_BY', type: 'varchar2', length: 20, nullable: true })
  confirmBy: string | null;

  @Column({ name: 'CONFIRM_DATE', type: 'date', nullable: true })
  confirmDate: Date | null;

  @Column({ name: 'ENTER_BY', type: 'varchar2', length: 20, nullable: true })
  enterBy: string | null;

  @CreateDateColumn({ name: 'ENTER_DATE', type: 'date' })
  enterDate: Date;

  @Column({ name: 'LAST_MODIFY_BY', type: 'varchar2', length: 20, nullable: true })
  lastModifyBy: string | null;

  @UpdateDateColumn({ name: 'LAST_MODIFY_DATE', type: 'date' })
  lastModifyDate: Date;
}

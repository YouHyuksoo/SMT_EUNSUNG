import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity({ name: 'IM_ITEM_MASTER' })
export class ItemSupplier {
  @PrimaryColumn({ name: 'SUPPLIER_CODE', type: 'varchar2', length: 20 }) supplierCode: string;
  @PrimaryColumn({ name: 'ITEM_CODE', type: 'varchar2', length: 20 }) itemCode: string;
  @PrimaryColumn({ name: 'DATESET', type: 'date' }) dateset: Date;
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' }) organizationId: number;
  @Column({ name: 'ORDER_TYPE', type: 'varchar2', length: 1, nullable: true }) orderType: string | null;
  @Column({ name: 'ORDER_RATE', type: 'number' }) orderRate: number;
  @Column({ name: 'ORDER_LEADTIME', type: 'number', nullable: true }) orderLeadtime: number | null;
  @Column({ name: 'ORDER_BAD_RATE', type: 'number', nullable: true }) orderBadRate: number | null;
  @Column({ name: 'MIM_ORDER_QTY', type: 'number', nullable: true }) mimOrderQty: number | null;
  @Column({ name: 'PACKING_QTY', type: 'number', nullable: true }) packingQty: number | null;
  @Column({ name: 'LONGTERM_DELIVERY_YN', type: 'varchar2', length: 1, nullable: true }) longtermDeliveryYn: string | null;
  @Column({ name: 'WAREHOUSE_CHARGE', type: 'varchar2', length: 30, nullable: true }) warehouseCharge: string | null;
  @Column({ name: 'ORDER_CHARGE', type: 'varchar2', length: 30, nullable: true }) orderCharge: string | null;
  @Column({ name: 'DATEEND', type: 'date' }) dateend: Date;
  @Column({ name: 'MAIN_VENDOR_YN', type: 'varchar2', length: 1, nullable: true }) mainVendorYn: string | null;
  @Column({ name: 'PAYMENT_TYPE', type: 'varchar2', length: 20 }) paymentType: string;
  @Column({ name: 'INSPECT_METHOD', type: 'varchar2', length: 1, nullable: true }) inspectMethod: string | null;
  @Column({ name: 'INSPECT_RULE', type: 'varchar2', length: 1, nullable: true }) inspectRule: string | null;
  @Column({ name: 'INCIDENTAL_EXPENSE_CODE', type: 'varchar2', length: 3, nullable: true }) incidentalExpenseCode: string | null;
  @Column({ name: 'ENTER_BY', type: 'varchar2', length: 20 }) enterBy: string;
  @Column({ name: 'ENTER_DATE', type: 'date' }) enterDate: Date;
  @Column({ name: 'LAST_MODIFY_BY', type: 'varchar2', length: 20, nullable: true }) lastModifyBy: string | null;
  @Column({ name: 'LAST_MODIFY_DATE', type: 'date', nullable: true }) lastModifyDate: Date | null;
  @Column({ name: 'INSPECT_PROCESS', type: 'varchar2', length: 20, nullable: true }) inspectProcess: string | null;
  @Column({ name: 'ESD_CHECK_CYCLE_VALUE', type: 'number', nullable: true }) esdCheckCycleValue: number | null;
}

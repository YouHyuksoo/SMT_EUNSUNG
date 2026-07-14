import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity({ name: 'ICOM_SUPPLIER' })
export class SupplierMaster {
  @PrimaryColumn({ name: 'SUPPLIER_CODE', type: 'varchar2', length: 20 })
  supplierCode: string;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId: number;

  @Column({ name: 'SUPPLIER_NAME', type: 'varchar2', length: 100 })
  supplierName: string;

  @Column({ name: 'DATEEND', type: 'date' })
  dateEnd: Date;

  @Column({ name: 'DATESET', type: 'date' })
  dateSet: Date;

  @Column({ name: 'SUPPLIER_NAME_ENG', type: 'varchar2', length: 100 })
  supplierNameEng: string;

  @Column({ name: 'BUSINESS_NO', type: 'varchar2', length: 100, nullable: true })
  businessNo: string | null;

  @Column({ name: 'BUSINESS_STATUS', type: 'varchar2', length: 1 })
  businessStatus: string;

  @Column({ name: 'BUSINESS_TYPE', type: 'varchar2', length: 1, nullable: true })
  businessType: string | null;

  @Column({ name: 'SUPPLIER_CHARGE_NAME', type: 'varchar2', length: 20, nullable: true })
  supplierChargeName: string | null;

  @Column({ name: 'PAYMENT_TYPE', type: 'varchar2', length: 20 })
  paymentType: string;

  @Column({ name: 'OWNER_NAME', type: 'varchar2', length: 20, nullable: true })
  ownerName: string | null;

  @Column({ name: 'ADDRESS', type: 'varchar2', length: 100, nullable: true })
  address: string | null;

  @Column({ name: 'TEL_NO', type: 'varchar2', length: 40 })
  telNo: string;

  @Column({ name: 'FAX_NO', type: 'varchar2', length: 20, nullable: true })
  faxNo: string | null;

  @Column({ name: 'ENTER_DATE', type: 'date', nullable: true })
  enterDate: Date | null;

  @Column({ name: 'ENTER_BY', type: 'varchar2', length: 20, nullable: true })
  enterBy: string | null;

  @Column({ name: 'LAST_MODIFY_DATE', type: 'date', nullable: true })
  lastModifyDate: Date | null;

  @Column({ name: 'LAST_MODIFY_BY', type: 'varchar2', length: 20, nullable: true })
  lastModifyBy: string | null;

  @Column({ name: 'EMAIL_ADDRESS', type: 'varchar2', length: 50, nullable: true })
  emailAddress: string | null;
}

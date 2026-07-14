import { Column, CreateDateColumn, Entity, PrimaryColumn, UpdateDateColumn } from 'typeorm';

@Entity({ name: 'IS_PRODUCT_SALE_PRICE' })
export class ProductSalePrice {
  @PrimaryColumn({ name: 'CUSTOMER_CODE', type: 'varchar2', length: 20 }) customerCode: string;
  @PrimaryColumn({ name: 'ITEM_CODE', type: 'varchar2', length: 20 }) itemCode: string;
  @PrimaryColumn({ name: 'PRODUCT_LINE_TYPE', type: 'varchar2', length: 1 }) productLineType: string;
  @PrimaryColumn({ name: 'DATESET', type: 'date' }) dateset: Date;
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' }) organizationId: number;
  @Column({ name: 'DATEEND', type: 'date', nullable: true }) dateend: Date | null;
  @Column({ name: 'PRODUCT_SALE_PRICE', type: 'number', nullable: true }) salePrice: number | null;
  @Column({ name: 'STANDARD_SALE_PRICE', type: 'number', nullable: true }) standardSalePrice: number | null;
  @Column({ name: 'FOREIGN_SALE_PRICE', type: 'number', nullable: true }) foreignSalePrice: number | null;
  @Column({ name: 'SALE_CURRENCY', type: 'varchar2', length: 3, nullable: true }) saleCurrency: string | null;
  @Column({ name: 'FOREIGN_SALE_CURRENCY', type: 'varchar2', length: 3, nullable: true }) foreignSaleCurrency: string | null;
  @Column({ name: 'TAX_RATE', type: 'number', nullable: true }) taxRate: number | null;
  @Column({ name: 'PRICE_TYPE', type: 'varchar2', length: 1, nullable: true }) priceType: string | null;
  @Column({ name: 'PRICE_CHANGE_REASON', type: 'varchar2', length: 10, nullable: true }) priceChangeReason: string | null;
  @Column({ name: 'PRICE_CHANGE_CONFIRM_YN', type: 'varchar2', length: 1, nullable: true }) priceChangeConfirmYn: string | null;
  @Column({ name: 'CONFIRM_BY', type: 'varchar2', length: 20, nullable: true }) confirmBy: string | null;
  @Column({ name: 'CONFIRM_DATE', type: 'date', nullable: true }) confirmDate: Date | null;
  @Column({ name: 'SALE_CHARGE', type: 'varchar2', length: 20, nullable: true }) saleCharge: string | null;
  @Column({ name: 'MODEL_NAME', type: 'varchar2', length: 100, nullable: true }) modelName: string | null;
  @Column({ name: 'ENTER_BY', type: 'varchar2', length: 20, nullable: true }) enterBy: string | null;
  @CreateDateColumn({ name: 'ENTER_DATE', type: 'date' }) enterDate: Date;
  @Column({ name: 'LAST_MODIFY_BY', type: 'varchar2', length: 20, nullable: true }) lastModifyBy: string | null;
  @UpdateDateColumn({ name: 'LAST_MODIFY_DATE', type: 'date' }) lastModifyDate: Date;
}

// 작업지시(런카드) 헤더 (IP_PRODUCT_RUN_CARD)
// 컬럼 구성은 PowerBuilder 원본 w_product_run_card 의 dw_1 이 다루는 컬럼을 기준으로 한다.
import { Entity, PrimaryColumn, Column } from 'typeorm';

@Entity({ name: 'IP_PRODUCT_RUN_CARD' })
export class ProductRunCard {
  @PrimaryColumn({ name: 'RUN_NO', length: 30 }) runNo: string;
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' }) organizationId: number;

  @Column({ name: 'RUN_DATE', type: 'date' }) runDate: Date;
  @Column({ name: 'LOT_NO', length: 30 }) lotNo: string;
  @Column({ name: 'ITEM_CODE', length: 30 }) itemCode: string;
  @Column({ name: 'MODEL_NAME', length: 100 }) modelName: string;
  @Column({ name: 'LINE_CODE', length: 10 }) lineCode: string;
  @Column({ name: 'LOT_SIZE', type: 'number' }) lotSize: number;
  @Column({ name: 'CHARGER', length: 30 }) charger: string;

  @Column({ name: 'MARKING_NO', length: 30, nullable: true }) markingNo: string | null;
  @Column({ name: 'PCB_SUPPLIER_CODE', length: 30, nullable: true }) pcbSupplierCode: string | null;
  @Column({ name: 'RUN_STATUS', length: 1, nullable: true }) runStatus: string | null;
  @Column({ name: 'CARRIER_SIZE', type: 'number', nullable: true }) carrierSize: number | null;
  @Column({ name: 'PRODUCT_RUN_TYPE', length: 1, nullable: true }) productRunType: string | null;
  @Column({ name: 'ARRAY_TYPE', length: 20, nullable: true }) arrayType: string | null;
  @Column({ name: 'ACTIVE_YN', length: 1, nullable: true }) activeYn: string | null;
  @Column({ name: 'COMMENTS', length: 2000, nullable: true }) comments: string | null;
  @Column({ name: 'PARENT_ITEM_CODE', length: 30, nullable: true }) parentItemCode: string | null;
  @Column({ name: 'PCB_ITEM', length: 10, nullable: true }) pcbItem: string | null;
  @Column({ name: 'MASTER_MODEL_NAME', length: 50, nullable: true }) masterModelName: string | null;
  @Column({ name: 'MFS_GROUP_NO', length: 20, nullable: true }) mfsGroupNo: string | null;
  @Column({ name: 'SHIFT_CODE', length: 20, nullable: true }) shiftCode: string | null;
  @Column({ name: 'REVISION', length: 10, nullable: true }) revision: string | null;
  @Column({ name: 'MODEL_CLASS', length: 20, nullable: true }) modelClass: string | null;
  @Column({ name: 'PCB_WEEK', length: 20, nullable: true }) pcbWeek: string | null;

  @Column({ name: 'ENTER_BY', length: 20, nullable: true }) enterBy: string | null;
  @Column({ name: 'ENTER_DATE', type: 'date', nullable: true }) enterDate: Date | null;
  @Column({ name: 'LAST_MODIFY_BY', length: 20, nullable: true }) lastModifyBy: string | null;
  @Column({ name: 'LAST_MODIFY_DATE', type: 'date', nullable: true }) lastModifyDate: Date | null;
}

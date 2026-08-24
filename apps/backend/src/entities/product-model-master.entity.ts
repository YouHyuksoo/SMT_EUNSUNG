// 제품 모델 마스터 (IP_PRODUCT_MODEL_MASTER) — 모델 선택 팝업 데이터 소스(부분 매핑)
import { Entity, PrimaryColumn, Column } from 'typeorm';

@Entity({ name: 'IP_PRODUCT_MODEL_MASTER' })
export class ProductModelMaster {
  @PrimaryColumn({ name: 'PART_NO', length: 100 })
  partNo: string; // 고객사품번 = 모델코드

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId: number;

  @Column({ name: 'MODEL_NAME', length: 100, nullable: true })
  modelName: string | null;

  @Column({ name: 'MODEL_SPEC', length: 100, nullable: true })
  modelSpec: string | null; // 모델규격 = 규격

  @Column({ name: 'CUSTOMER_NAME', length: 100, nullable: true })
  customerName: string | null; // 회사명 = 고객명
}

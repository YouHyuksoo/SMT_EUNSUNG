/**
 * @file entities/isys-organization.entity.ts
 * @description 은성전장 조직(사업장) 엔티티 - ISYS_ORGANIZATION 테이블 매핑.
 *
 * 은성전장은 단일 조직(ORGANIZATION_ID=1, 은성전장, COMPANY_CODE=JSTECH)이다.
 * 로그인 시 사용자의 ORGANIZATION_ID로 회사코드/사업장 정보를 얻는다.
 */
import { Entity, PrimaryColumn, Column } from 'typeorm';

@Entity({ name: 'ISYS_ORGANIZATION' })
export class IsysOrganization {
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId: number;

  @Column({ name: 'ORGANIZATION_NAME', length: 100, nullable: true })
  organizationName: string | null;

  @Column({ name: 'ORGANIZATION_CODE', length: 20, nullable: true })
  organizationCode: string | null;

  @Column({ name: 'COMPANY_CODE', length: 20, nullable: true })
  companyCode: string | null;
}

/**
 * @file entities/isys-organization.entity.ts
 * @description 은성전장 조직(사업장) 엔티티 - ISYS_ORGANIZATION 테이블 매핑.
 *
 * 은성전장은 단일 조직(ORGANIZATION_ID=1, 은성전장, COMPANY_CODE=EUNSUNG)이다.
 * 로그인 시 사용자의 ORGANIZATION_ID로 회사코드/사업장 정보를 얻는다.
 */
import { Entity, PrimaryColumn, Column } from 'typeorm';

@Entity({ name: 'ISYS_ORGANIZATION' })
export class IsysOrganization {
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId: number;

  @Column({ name: 'ORGANIZATION_NAME', length: 50, nullable: true })
  organizationName: string | null;

  @Column({ name: 'ORGANIZATION_CODE', length: 10, nullable: true })
  organizationCode: string | null;

  @Column({ name: 'COMPANY_CODE', length: 10, nullable: true })
  companyCode: string | null;

  @Column({ name: 'ORGANIZATION_FULL_NAME', length: 100, nullable: true })
  organizationFullName: string | null;

  @Column({ name: 'BUSINESS_NO', length: 20, nullable: true })
  businessNo: string | null;

  @Column({ name: 'OWNER_NAME', length: 20, nullable: true })
  ownerName: string | null;

  @Column({ name: 'ADDRESS', length: 100, nullable: true })
  address: string | null;

  @Column({ name: 'TEL_NO', length: 20, nullable: true })
  telNo: string | null;

  @Column({ name: 'FAX_NO', length: 20, nullable: true })
  faxNo: string | null;

  @Column({ name: 'EMAIL_ADDRESS', length: 50, nullable: true })
  emailAddress: string | null;

  @Column({ name: 'ENTER_DATE', type: 'date', nullable: true })
  enterDate: Date | null;

  @Column({ name: 'ENTER_BY', length: 20, nullable: true })
  enterBy: string | null;

  @Column({ name: 'LAST_MODIFY_DATE', type: 'date', nullable: true })
  lastModifyDate: Date | null;

  @Column({ name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  lastModifyBy: string | null;
}

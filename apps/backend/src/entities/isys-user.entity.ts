/**
 * @file entities/isys-user.entity.ts
 * @description 은성전장 사용자 엔티티 - ISYS_USERS 테이블 매핑.
 *
 * 초보자 가이드:
 * 1. PK는 USER_ID (로그인 아이디, email 아님)
 * 2. PASSWORD는 평문 저장(VARCHAR2(20))
 * 3. USER_LEVEL(1~9)이 권한 레벨 (9=ADMIN). role/status 컬럼은 없다.
 * 4. ORGANIZATION_ID로 ISYS_ORGANIZATION → ISYS_COMPANY 를 조인한다.
 */
import { Entity, PrimaryColumn, Column } from 'typeorm';

@Entity({ name: 'ISYS_USERS' })
export class IsysUser {
  @PrimaryColumn({ name: 'USER_ID', length: 20 })
  userId: string;

  @Column({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId: number;

  @Column({ name: 'USER_NAME', length: 20, nullable: true })
  userName: string | null;

  @Column({ name: 'DEPARTMENT_CODE', length: 20, nullable: true })
  departmentCode: string | null;

  @Column({ name: 'PASSWORD', length: 20, nullable: true })
  password: string | null;

  @Column({ name: 'USER_LEVEL', type: 'number', nullable: true })
  userLevel: number | null;

  @Column({ name: 'EMAIL_ADDRESS', length: 50, nullable: true })
  emailAddress: string | null;

  @Column({ name: 'POSITION', length: 20, nullable: true })
  position: string | null;
}

/**
 * @file entities/department-master.entity.ts
 * @description 부서 마스터 엔티티 - ISYS_DEPARTMENT 테이블 매핑.
 *
 * 초보자 가이드:
 * 1. deptCode + organizationId가 PK
 * 2. parentDeptCode: 상위 부서 코드 (트리 구조)
 * 3. ISYS_DEPARTMENT에는 사용여부/정렬순서/부서장 컬럼이 없다.
 */
import {
  Entity,
  PrimaryColumn,
  Column,
} from 'typeorm';

@Entity({ name: 'ISYS_DEPARTMENT' })
export class DepartmentMaster {
  @PrimaryColumn({ name: 'DEPARTMENT_CODE', length: 20 })
  deptCode: string;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @Column({ type: 'varchar2', name: 'PRE_DEPARTMENT_CODE', length: 30, nullable: true })
  parentDeptCode: string | null;

  @Column({ type: 'varchar2', name: 'DEPARTMENT_NAME_KOR', length: 30, nullable: true })
  deptName: string | null;

  @Column({ type: 'varchar2', name: 'DEPARTMENT_NAME_LOCAL', length: 30, nullable: true })
  deptNameLocal: string | null;

  @Column({ type: 'varchar2', name: 'DEPARTMENT_NAME_ENG', length: 30, nullable: true })
  deptNameEng: string | null;

  @Column({ type: 'varchar2', name: 'COMMENTS', length: 1000, nullable: true })
  remark: string | null;

  @Column({ name: 'ENTER_DATE', type: 'date', nullable: true })
  createdAt: Date | null;

  @Column({ type: 'varchar2', name: 'ENTER_BY', length: 20, nullable: true })
  createdBy: string | null;

  @Column({ name: 'LAST_MODIFY_DATE', type: 'date', nullable: true })
  updatedAt: Date | null;

  @Column({ type: 'varchar2', name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  updatedBy: string | null;
}

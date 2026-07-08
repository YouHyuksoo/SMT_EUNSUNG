/**
 * @file entities/com-code.entity.ts
 * @description 공통코드 엔티티 - ISYS_BASECODE 테이블 매핑.
 *
 * 초보자 가이드:
 * 1. 복합 PK: CODE_TYPE + CODE_NAME + ORGANIZATION_ID
 * 2. 화면 계약의 groupCode는 CODE_TYPE, detailCode는 CODE_NAME에 대응한다.
 * 3. ISYS_BASECODE에는 사용여부/정렬순서/부모코드 컬럼이 없다.
 */
import {
  Entity,
  PrimaryColumn,
  Column,
  Index,
} from 'typeorm';

@Entity({ name: 'ISYS_BASECODE' })
@Index(['groupCode'])
export class ComCode {
  @PrimaryColumn({ name: 'CODE_TYPE', length: 30 })
  groupCode: string;

  @PrimaryColumn({ name: 'CODE_NAME', length: 100 })
  detailCode: string;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @Column({ name: 'CODE_MEAN_KOR', length: 100, nullable: true })
  codeName: string | null;

  @Column({ type: 'varchar2', name: 'CODE_NAME_DESCRIPTION_KOR', length: 100, nullable: true })
  codeDesc: string | null;

  @Column({ type: 'varchar2', name: 'CODE_MEAN_ENG', length: 100, nullable: true })
  codeNameEng: string | null;

  @Column({ type: 'varchar2', name: 'CODE_MEAN_LOCAL', length: 100, nullable: true })
  codeNameLocal: string | null;

  @Column({ type: 'varchar2', name: 'CODE_VALUE', length: 30, nullable: true })
  attr1: string | null;

  @Column({ type: 'varchar2', name: 'CODE_TYPE_DESC_KOR', length: 100, nullable: true })
  codeTypeDescKor: string | null;

  @Column({ type: 'varchar2', name: 'CODE_TYPE_DESC_ENG', length: 100, nullable: true })
  codeTypeDescEng: string | null;

  @Column({ type: 'varchar2', name: 'CODE_TYPE_DESC_LOCAL', length: 100, nullable: true })
  codeTypeDescLocal: string | null;

  @Column({ type: 'varchar2', name: 'CODE_GROUP', length: 100, nullable: true })
  codeGroup: string | null;

  @Column({ type: 'varchar2', name: 'ENTER_BY', length: 20, nullable: true })
  createdBy: string | null;

  @Column({ type: 'varchar2', name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  updatedBy: string | null;

  @Column({ name: 'ENTER_DATE', type: 'date', nullable: true })
  createdAt: Date | null;

  @Column({ name: 'LAST_MODIFY_DATE', type: 'date', nullable: true })
  updatedAt: Date | null;

  parentCode: string | null;
  sortOrder: number;
  useYn: string;
  attr2: string | null;
  attr3: string | null;
  defectGrade: 'CRITICAL' | 'MAJOR' | 'MINOR' | null;
}

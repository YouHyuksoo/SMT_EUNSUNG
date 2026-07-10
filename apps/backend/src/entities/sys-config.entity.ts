/**
 * @file entities/sys-config.entity.ts
 * @description 시스템 환경설정 엔티티 - ISYS_CONFIG 테이블 매핑.
 *
 * 초보자 가이드:
 * 1. configKey는 CONFIG_NAME이다.
 * 2. ISYS_CONFIG에는 그룹/타입/옵션/정렬 컬럼이 없으므로 서비스 view에서 보강한다.
 * 3. CONFIG_NAME + ORGANIZATION_ID가 자연키로 쓰인다.
 */
import {
  Entity,
  PrimaryColumn,
  Column,
} from 'typeorm';

@Entity({ name: 'ISYS_CONFIG' })
export class SysConfig {
  @PrimaryColumn({ name: 'CONFIG_NAME', length: 30 })
  configKey: string;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @Column({ type: 'varchar2', name: 'CONFIG_DESCRIPTION', length: 100, nullable: true })
  configDescription: string | null;

  @Column({ type: 'varchar2', name: 'CONFIG_VALUE', length: 20, nullable: true })
  configValue: string | null;

  @Column({ type: 'varchar2', name: 'CONFIG_VALUE_DESCRIPTION', length: 100, nullable: true })
  configValueDescription: string | null;

  @Column({ name: 'ENTER_DATE', type: 'date', nullable: true })
  createdAt: Date | null;

  @Column({ type: 'varchar2', name: 'ENTER_BY', length: 20, nullable: true })
  createdBy: string | null;

  @Column({ name: 'LAST_MODIFY_DATE', type: 'date', nullable: true })
  updatedAt: Date | null;

  @Column({ type: 'varchar2', name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  updatedBy: string | null;

  @Column({ type: 'varchar2', name: 'USE_YN', length: 1, nullable: true })
  isActive: string | null;
}

/**
 * @file entities/prod-line-master.entity.ts
 * @description 생산라인 마스터 엔티티 - 은성 레거시 테이블 IP_PRODUCT_LINE에 매핑한다.
 *              LINE_CODE + ORGANIZATION_ID 복합 자연키를 PK로 사용한다.
 *
 * 초보자 가이드:
 * 1. ACTIVE_YN은 마스터 사용여부가 아니라 라인 가동 활성 상태(Y=활성, N=대기)다.
 * 2. LINE_DIVISION / LINE_PRODUCT_DIVISION / LINE_STATUS는 ISYS_BASECODE 코드값이다.
 * 3. IP_PRODUCT_LINE에는 SMT 설비 운영용 컬럼(마스크/스퀴즈/솔더 LOT 등)이 다수 있으나,
 *    기준정보 화면이 다루는 컬럼만 여기에 선언한다.
 */
import {
  Entity,
  PrimaryColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'IP_PRODUCT_LINE' })
export class ProdLineMaster {
  @PrimaryColumn({ name: 'LINE_CODE', length: 20 })
  lineCode: string;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @Column({ type: 'varchar2', name: 'LINE_NAME', length: 100 })
  lineName: string;

  /** 라인구분: D=SMT, L=조립라인, T=검사라인, W=가공공정 등 */
  @Column({ type: 'varchar2', name: 'LINE_DIVISION', length: 20 })
  lineDivision: string;

  /** 라인제품구분: FIXED=고정, ONESELF=자작, SALE=유상, SUBLET=무상 */
  @Column({ type: 'varchar2', name: 'LINE_PRODUCT_DIVISION', length: 10 })
  lineProductDivision: string;

  /** 라인그룹: SMD/ASM/SUB/INSP/COMMON — ISYS_BASECODE에 코드 정의가 없어 자유 입력이다. */
  @Column({ type: 'varchar2', name: 'LINE_CODE_GROUP', length: 20, nullable: true })
  lineCodeGroup: string | null;

  /** 라인상태: N=정상, D=고장, S=정지 등 */
  @Column({ type: 'varchar2', name: 'LINE_STATUS', length: 10, nullable: true })
  lineStatus: string | null;

  @Column({ type: 'number', name: 'CAPACITY', nullable: true })
  capacity: number | null;

  /** 용량단위: KG, ST */
  @Column({ type: 'varchar2', name: 'CAPACITY_UOM', length: 3, nullable: true })
  capacityUom: string | null;

  /** 시간당 생산량 */
  @Column({ type: 'number', name: 'UPH_VALUE', nullable: true })
  uphValue: number | null;

  @Column({ type: 'varchar2', name: 'MES_DISPLAY_YN', length: 1, nullable: true })
  mesDisplayYn: string | null;

  @Column({ type: 'number', name: 'MES_DISPLAY_SEQUENCE', nullable: true })
  mesDisplaySequence: number | null;

  /** 활성유무: Y=활성, N=대기 (마스터 사용여부가 아님) */
  @Column({ type: 'varchar2', name: 'ACTIVE_YN', length: 1, nullable: true })
  activeYn: string | null;

  /** 설명 */
  @Column({ type: 'varchar2', name: 'COMMENTS', length: 1000, nullable: true })
  comments: string | null;

  @Column({ type: 'varchar2', name: 'ENTER_BY', length: 20, nullable: true })
  enterBy: string | null;

  @Column({ type: 'varchar2', name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  lastModifyBy: string | null;

  @CreateDateColumn({ name: 'ENTER_DATE', type: 'date' })
  enterDate: Date;

  @UpdateDateColumn({ name: 'LAST_MODIFY_DATE', type: 'date' })
  lastModifyDate: Date;
}

/**
 * @file entities/process-master.entity.ts
 * @description 공정(Workstage) 마스터 엔티티 - 은성전장 IP_PRODUCT_WORKSTAGE 공정 정보를 관리한다.
 *              WORKSTAGE_CODE + ORGANIZATION_ID를 자연키 PK로 사용한다.
 *
 * 초보자 가이드:
 * 1. processCode/processName/processType은 각각 WORKSTAGE_CODE/NAME/TYPE에 매핑된다.
 *    다른 모듈(라우팅, SPC, 작업지시 등)이 이 프로퍼티명을 참조하므로 그대로 유지한다.
 * 2. 배치 설비는 별도 중간 테이블 없이 IMCN_MACHINE.WORKSTAGE_CODE로 연결된다 (1:N).
 * 3. 나머지 컬럼은 레거시 PB 화면(d_pln_workstage_mst)이 다루던 필드를 그대로 노출한다.
 */
import {
  Entity,
  PrimaryColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity({ name: 'IP_PRODUCT_WORKSTAGE' })
@Index(['processType'])
export class ProcessMaster {
  @PrimaryColumn({ name: 'WORKSTAGE_CODE', length: 10 })
  processCode: string;

  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' })
  organizationId!: number;

  @Column({ name: 'WORKSTAGE_NAME', length: 100 })
  processName: string;

  /** 공정유형: I=일반공정 L=최종공정 Q=검사공정 (ISYS_BASECODE 'WORKSTAGE TYPE') */
  @Column({ name: 'WORKSTAGE_TYPE', length: 1, default: 'I' })
  processType: string;

  @Column({ name: 'WORKSTAGE_SORT_ORDER', type: 'number' })
  sortOrder: number;

  /* ── 구분/그룹 ── */

  /** 시작공정 여부 (ISYS_BASECODE 'WORKSTAGE START YN') */
  @Column({ type: 'varchar2', name: 'WORKSTAGE_START_YN', length: 1, nullable: true, default: 'N' })
  startYn: string | null;

  /** 공정 그룹: SMT/PBA/PACKING/REPAIR/WAREHOUSE (ISYS_BASECODE 'WORKSTAGE CODE GROUP') */
  @Column({ type: 'varchar2', name: 'WORKSTAGE_CODE_GROUP', length: 20, nullable: true })
  codeGroup: string | null;

  /** 공정 상태 (ISYS_BASECODE 'WORKSTAGE STATUS') */
  @Column({ type: 'varchar2', name: 'WORKSTAGE_STATUS', length: 1, nullable: true })
  workstageStatus: string | null;

  @Column({ type: 'varchar2', name: 'LINE_CODE', length: 20, default: '*' })
  lineCode: string;

  @Column({ type: 'varchar2', name: 'DEPARTMENT_CODE', length: 20, nullable: true, default: '1100' })
  departmentCode: string | null;

  @Column({ type: 'varchar2', name: 'SHIFT_CODE', length: 10, nullable: true })
  shiftCode: string | null;

  /** 대표 설비 코드 (IMCN_MACHINE.MACHINE_CODE) */
  @Column({ type: 'varchar2', name: 'MACHINE_CODE', length: 30, nullable: true })
  machineCode: string | null;

  @Column({ type: 'varchar2', name: 'COST_CENTER_CODE', length: 20, nullable: true })
  costCenterCode: string | null;

  @Column({ type: 'varchar2', name: 'MES_DISPLAY_GROUP', length: 20, nullable: true, default: '*' })
  mesDisplayGroup: string | null;

  @Column({ type: 'varchar2', name: 'ACTUAL_PLC_ADDRESS', length: 10, nullable: true })
  actualPlcAddress: string | null;

  /* ── 표준시간 / 생산성 ── */

  @Column({ name: 'ST_VALUE', type: 'number', nullable: true })
  stValue: number | null;

  @Column({ name: 'OT_VALUE', type: 'number', nullable: true })
  otValue: number | null;

  @Column({ name: 'STANDARD_QTY', type: 'number', nullable: true })
  standardQty: number | null;

  @Column({ name: 'UPH_VALUE', type: 'number', nullable: true })
  uphValue: number | null;

  @Column({ name: 'CAPACITY', type: 'number', nullable: true })
  capacity: number | null;

  @Column({ type: 'varchar2', name: 'CAPACITY_UOM', length: 3, nullable: true })
  capacityUom: string | null;

  @Column({ name: 'USE_RATE', type: 'number', nullable: true })
  useRate: number | null;

  @Column({ name: 'WORKSTAGE_WAIT_TIME', type: 'number', nullable: true })
  waitTime: number | null;

  @Column({ name: 'WORKSTAGE_MOVE_TIME', type: 'number', nullable: true })
  moveTime: number | null;

  @Column({ name: 'WORKSTAGE_PREPARE_TIME', type: 'number', nullable: true })
  prepareTime: number | null;

  @Column({ name: 'TOTAL_WORK_TIME', type: 'number', nullable: true })
  totalWorkTime: number | null;

  @Column({ name: 'WORKSTAGE_WORKER_WORK_TIME', type: 'number', nullable: true })
  workerWorkTime: number | null;

  @Column({ name: 'WORKSTAGE_MACHINE_WORK_TIME', type: 'number', nullable: true })
  machineWorkTime: number | null;

  @Column({ name: 'WORKSTAGE_WORKER_QTY', type: 'number', nullable: true })
  workerQty: number | null;

  @Column({ name: 'WORKSTAGE_MACHINE_QTY', type: 'number', nullable: true })
  machineQty: number | null;

  @Column({ name: 'WORKING_EFFICIENCY', type: 'number', nullable: true })
  workingEfficiency: number | null;

  @Column({ name: 'MACHINE_EFFICIENCY', type: 'number', nullable: true })
  machineEfficiency: number | null;

  /* ── 원가율 ── */

  @Column({ name: 'WAGE_RATE', type: 'number', nullable: true })
  wageRate: number | null;

  @Column({ name: 'EXPENSE_RATE', type: 'number', nullable: true })
  expenseRate: number | null;

  @Column({ name: 'MACHINERY_RATE', type: 'number', nullable: true })
  machineryRate: number | null;

  /* ── 불량관리 ── */

  /** 불량률 통제 여부 (ISYS_BASECODE 'BAD RATE CONTROL') */
  @Column({ type: 'varchar2', name: 'BAD_RATE_CONTROL', length: 1, nullable: true })
  badRateControl: string | null;

  @Column({ name: 'BAD_MAX_RATE', type: 'number', nullable: true })
  badMaxRate: number | null;

  @Column({ type: 'varchar2', name: 'BAD_QTY_EXTRACT_YN', length: 1, nullable: true })
  badQtyExtractYn: string | null;

  /* ── 기타 ── */

  /** 하위 반제품 생성 여부 (ISYS_BASECODE 'GEN SUB MFS YN') */
  @Column({ type: 'varchar2', name: 'GEN_SUB_MFS_YN', length: 1, nullable: true })
  genSubMfsYn: string | null;

  /** 조립비 반영 여부 (ISYS_BASECODE 'ASSY EXP YN') */
  @Column({ type: 'varchar2', name: 'ASSY_EXP_YN', length: 1, nullable: true })
  assyExpYn: string | null;

  /* ── 감사 컬럼 ── */

  @Column({ type: 'varchar2', name: 'ENTER_BY', length: 20, nullable: true })
  createdBy: string | null;

  @Column({ type: 'varchar2', name: 'LAST_MODIFY_BY', length: 20, nullable: true })
  updatedBy: string | null;

  @CreateDateColumn({ name: 'ENTER_DATE', type: 'date' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'LAST_MODIFY_DATE', type: 'date' })
  updatedAt: Date;
}

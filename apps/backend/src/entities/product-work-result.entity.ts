// 설비별 작업 실적 헤더 (IP_PRODUCT_WORK_RESULT) — 건별 실적 이력 원장
import { Entity, PrimaryColumn, Column } from 'typeorm';

@Entity({ name: 'IP_PRODUCT_WORK_RESULT' })
export class ProductWorkResult {
  @PrimaryColumn({ name: 'RUN_NO', length: 30 }) runNo: string;
  @PrimaryColumn({ name: 'SEQ_NO', length: 2 }) seqNo: string;
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' }) organizationId: number;

  @Column({ name: 'MACHINE_CODE', length: 30, nullable: true }) machineCode: string | null;
  @Column({ name: 'WORKSTAGE_CODE', length: 10, nullable: true }) workstageCode: string | null;
  @Column({ name: 'RESULT_QTY', type: 'number', nullable: true }) resultQty: number | null;
  @Column({ name: 'WORK_TIME', type: 'number', nullable: true }) workTime: number | null;
  @Column({ name: 'WORKER_COUNT', type: 'number', nullable: true }) workerCount: number | null;
  @Column({ name: 'WORKER_NAME', length: 100, nullable: true }) workerName: string | null;
  @Column({ name: 'RESULT_STATUS', length: 10, nullable: true }) resultStatus: string | null; // WIP | DONE
  // 센서실적 반영 상태 — P_INTERLOCK_SENSOR_ACTUAL_NEO 호출 결과를 보관한다.
  // 진행(WIP)은 호출 자체를 하지 않으므로 'N'이지만 실패가 아니다.
  @Column({ name: 'SENSOR_APPLY_YN', length: 1, nullable: true }) sensorApplyYn: string | null;
  @Column({ name: 'SENSOR_APPLY_MSG', length: 1000, nullable: true }) sensorApplyMsg: string | null;
  @Column({ name: 'ENTER_BY', length: 20, nullable: true }) enterBy: string | null;
  @Column({ name: 'ENTER_DATE', type: 'date', nullable: true }) enterDate: Date | null;
  @Column({ name: 'LAST_MODIFY_BY', length: 20, nullable: true }) lastModifyBy: string | null;
  @Column({ name: 'LAST_MODIFY_DATE', type: 'date', nullable: true }) lastModifyDate: Date | null;
}

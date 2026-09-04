/**
 * @file entities/product-sensor-actual.entity.ts
 * @description 생산 실적 — 은성 레거시 테이블 IP_PRODUCT_SENSOR_ACTUAL에 매핑한다.
 *
 * 초보자 가이드:
 * 1. PK는 RECEIPT_DATE + RECEIPT_SEQUENCE + ORGANIZATION_ID다. 작업지시(RUN_NO)는 일반 컬럼이라
 *    한 작업지시에 실적이 여러 건 쌓인다(1:N).
 * 2. RECEIPT_SEQUENCE는 레거시 전역 시퀀스 SEQ_PRODUCT_SENSOR로 채번한다. 센서 수집 배치
 *    (P_INTERLOCK_SENSOR_ACTUAL_NEO)도 같은 시퀀스를 쓰므로 수기 실적과 항번이 섞이지 않는다.
 * 3. IS_LAST_YN이 화면의 처리구분이다 — Y=완료(수정불가), N=진행.
 * 4. MACHINE_CODE/WORK_TIME/WORKER_NAME/WORKER_COUNT는 2026-09-02에 추가한 수기 실적 전용
 *    컬럼이다. 센서 배치는 채우지 않으므로 NULL일 수 있다.
 * 5. 실제 읽기/쓰기는 work-result.service.ts의 raw SQL이 담당한다. 이 엔티티는 TypeORM
 *    EntityManager(트랜잭션)를 얻기 위한 연결 지점이다.
 */
import { Entity, PrimaryColumn, Column } from 'typeorm';

@Entity({ name: 'IP_PRODUCT_SENSOR_ACTUAL' })
export class ProductSensorActual {
  /** 입고일자 = 실적 등록일자 */
  @PrimaryColumn({ name: 'RECEIPT_DATE', type: 'date' }) receiptDate: Date;
  /** 입고항번 = 실적 차수 항번 (SEQ_PRODUCT_SENSOR) */
  @PrimaryColumn({ name: 'RECEIPT_SEQUENCE', type: 'number' }) receiptSequence: number;
  @PrimaryColumn({ name: 'ORGANIZATION_ID', type: 'number' }) organizationId: number;

  @Column({ name: 'RUN_NO', length: 20, nullable: true }) runNo: string | null;
  @Column({ name: 'LINE_CODE', length: 10, nullable: true }) lineCode: string | null;
  @Column({ name: 'WORKSTAGE_CODE', length: 30, nullable: true }) workstageCode: string | null;
  @Column({ name: 'PRODUCT_ACTUAL_QTY', type: 'number', nullable: true }) productActualQty: number | null;
  /** 처리구분: Y=완료(수정불가), N=진행 */
  @Column({ name: 'IS_LAST_YN', length: 1, nullable: true }) isLastYn: string | null;

  // 2026-09-02 추가 — 수기 실적 전용
  @Column({ name: 'MACHINE_CODE', length: 30, nullable: true }) machineCode: string | null;
  @Column({ name: 'WORK_TIME', type: 'number', nullable: true }) workTime: number | null;
  @Column({ name: 'WORKER_NAME', length: 100, nullable: true }) workerName: string | null;
  @Column({ name: 'WORKER_COUNT', type: 'number', nullable: true }) workerCount: number | null;

  @Column({ name: 'ENTER_BY', length: 30, nullable: true }) enterBy: string | null;
  @Column({ name: 'ENTER_DATE', type: 'date', nullable: true }) enterDate: Date | null;
  @Column({ name: 'LAST_MODIFY_BY', length: 30, nullable: true }) lastModifyBy: string | null;
  @Column({ name: 'LAST_MODIFY_DATE', type: 'date', nullable: true }) lastModifyDate: Date | null;
}

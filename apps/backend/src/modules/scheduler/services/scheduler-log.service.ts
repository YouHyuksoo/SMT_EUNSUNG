/**
 * @file src/modules/scheduler/services/scheduler-log.service.ts
 * @description 스케줄러 실행 로그 서비스 - 작업 실행 이력 CRUD 및 통계를 관리한다.
 *
 * 초보자 가이드:
 * 1. **generateLogId()**: Oracle sequence 기반 LOG_ID 채번
 * 2. **createLog()**: RUNNING 상태로 로그 생성 (실행 시작 시 호출)
 * 3. **updateLog()**: 실행 완료 후 상태/종료시각/소요시간 등 갱신
 * 4. **findAll()**: 페이지네이션 + 필터(작업코드, 상태, 날짜범위) 목록 조회
 * 5. **getSummary()**: 대시보드용 통계 (오늘 실행건수, 성공률, 일별 추이, 작업별 비율, 최근 실패)
 * 6. **recoverStaleRunning()**: 서버 재시작 시 RUNNING/RETRYING → FAIL 처리
 */

import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { SchedulerLog } from '../../../entities/scheduler-log.entity';
import { SchedulerLogFilterDto } from '../dto/scheduler-log.dto';

/** 일별 추이 항목 타입 */
export interface DailyTrendItem {
  date: string;
  total: number;
  success: number;
  fail: number;
}

/** 작업별 비율 항목 타입 */
export interface JobRatioItem {
  jobCode: string;
  total: number;
  success: number;
  fail: number;
}

/** 대시보드 요약 타입 */
export interface LogSummary {
  todayTotal: number;
  todaySuccess: number;
  todayFail: number;
  successRate: number;
  dailyTrend: DailyTrendItem[];
  jobRatio: JobRatioItem[];
  recentFails: SchedulerLog[];
}

@Injectable()
export class SchedulerLogService {
  private readonly logger = new Logger(SchedulerLogService.name);

  constructor(
    @InjectRepository(SchedulerLog)
    private readonly logRepo: Repository<SchedulerLog>,
    private readonly dataSource: DataSource,
  ) {}

  // =============================================
  // 채번
  // =============================================

  /**
   * LOG_ID 채번: Oracle sequence
   * @param organizationId 조직 ID
   * @returns 다음 LOG_ID
   */
  async generateLogId(organizationId: number): Promise<number> {
    const result = await this.dataSource.query(
      `SELECT SEQ_ISYS_SCHEDULER_LOGS.NEXTVAL AS "nextId" FROM DUAL`,
    );
    return result[0].nextId;
  }

  // =============================================
  // CRUD
  // =============================================

  /**
   * 실행 로그 생성 (RUNNING 상태)
   * @param data 로그 데이터 (logId 자동 채번)
   * @returns 생성된 로그
   */
  async createLog(data: Partial<SchedulerLog>): Promise<SchedulerLog> {
    const organizationId = data.organizationId!;
    const logId = await this.generateLogId(organizationId);

    const log = this.logRepo.create({
      ...data,
      logId,
      status: 'RUNNING',
      startTime: new Date(),
      retryCount: data.retryCount ?? 0,
    });

    const saved = await this.logRepo.save(log);
    this.logger.log(`실행 로그 생성: organizationId=${organizationId}, logId=${logId}, jobCode=${data.jobCode}`);
    return saved;
  }

  /**
   * 실행 로그 갱신 (상태, 종료시각, 소요시간 등)
   * @param organizationId 조직 ID
   * @param logId 로그ID
   * @param updates 갱신 데이터
   */
  async updateLog(
    organizationId: number,
    logId: number,
    updates: Partial<SchedulerLog>,
  ): Promise<void> {
    await this.logRepo.update(
      { organizationId, logId },
      updates,
    );
  }

  /**
   * 실행 로그 목록 조회 (페이지네이션 + 필터)
   * @param filter 필터 조건
   * @param organizationId 조직 ID
   */
  async findAll(
    filter: SchedulerLogFilterDto,
    organizationId: number,
  ) {
    const { page = 1, limit = 50, jobCode, status, fromDate, toDate } = filter;

    const qb = this.logRepo.createQueryBuilder('l');
    qb.where('l.organizationId = :organizationId', { organizationId });

    if (jobCode) qb.andWhere('l.jobCode = :jobCode', { jobCode });
    if (status) qb.andWhere('l.status = :status', { status });
    if (fromDate) {
      qb.andWhere('l.startTime >= TO_DATE(:fromDate, \'YYYY-MM-DD\')', { fromDate });
    }
    if (toDate) {
      qb.andWhere('l.startTime < TO_DATE(:toDate, \'YYYY-MM-DD\') + 1', { toDate });
    }

    qb.orderBy('l.startTime', 'DESC');

    const total = await qb.getCount();
    const data = await qb
      .skip((page - 1) * limit)
      .take(limit)
      .getMany();

    return { data, total, page, limit };
  }

  // =============================================
  // 대시보드 통계
  // =============================================

  /**
   * 대시보드 요약 통계
   * @param organizationId 조직 ID
   */
  async getSummary(organizationId: number): Promise<LogSummary> {
    // 오늘 실행 건수 (SUCCESS / FAIL / 전체)
    const todayRows: { status: string; cnt: string }[] = await this.dataSource.query(
      `SELECT "STATUS" AS "status", COUNT(*) AS "cnt"
         FROM "ISYS_SCHEDULER_LOGS"
        WHERE "ORGANIZATION_ID" = :1
          AND "START_TIME" >= TRUNC(SYSDATE)
        GROUP BY "STATUS"`,
      [organizationId],
    );

    let todayTotal = 0;
    let todaySuccess = 0;
    let todayFail = 0;
    for (const row of todayRows) {
      const cnt = Number(row.cnt);
      todayTotal += cnt;
      if (row.status === 'SUCCESS') todaySuccess = cnt;
      if (row.status === 'FAIL' || row.status === 'TIMEOUT') todayFail += cnt;
    }
    const successRate = todayTotal > 0
      ? parseFloat(((todaySuccess / todayTotal) * 100).toFixed(1))
      : 0;

    // 최근 7일 일별 추이
    const trendRows: { dt: string; status: string; cnt: string }[] = await this.dataSource.query(
      `SELECT TO_CHAR(TRUNC("START_TIME"), 'YYYY-MM-DD') AS "dt",
              "STATUS" AS "status",
              COUNT(*) AS "cnt"
         FROM "ISYS_SCHEDULER_LOGS"
        WHERE "ORGANIZATION_ID" = :1
          AND "START_TIME" >= TRUNC(SYSDATE) - 7
        GROUP BY TRUNC("START_TIME"), "STATUS"
        ORDER BY TRUNC("START_TIME")`,
      [organizationId],
    );

    const trendMap = new Map<string, DailyTrendItem>();
    for (const row of trendRows) {
      const existing = trendMap.get(row.dt) ?? { date: row.dt, total: 0, success: 0, fail: 0 };
      const cnt = Number(row.cnt);
      existing.total += cnt;
      if (row.status === 'SUCCESS') existing.success += cnt;
      if (row.status === 'FAIL' || row.status === 'TIMEOUT') existing.fail += cnt;
      trendMap.set(row.dt, existing);
    }
    const dailyTrend = Array.from(trendMap.values());

    // 작업별 비율
    const ratioRows: { jobCode: string; status: string; cnt: string }[] = await this.dataSource.query(
      `SELECT "JOB_CODE" AS "jobCode",
              "STATUS" AS "status",
              COUNT(*) AS "cnt"
         FROM "ISYS_SCHEDULER_LOGS"
        WHERE "ORGANIZATION_ID" = :1
          AND "START_TIME" >= TRUNC(SYSDATE) - 30
        GROUP BY "JOB_CODE", "STATUS"`,
      [organizationId],
    );

    const ratioMap = new Map<string, JobRatioItem>();
    for (const row of ratioRows) {
      const existing = ratioMap.get(row.jobCode) ?? { jobCode: row.jobCode, total: 0, success: 0, fail: 0 };
      const cnt = Number(row.cnt);
      existing.total += cnt;
      if (row.status === 'SUCCESS') existing.success += cnt;
      if (row.status === 'FAIL' || row.status === 'TIMEOUT') existing.fail += cnt;
      ratioMap.set(row.jobCode, existing);
    }
    const jobRatio = Array.from(ratioMap.values());

    // 최근 실패 5건
    const recentFails = await this.logRepo.find({
      where: { organizationId },
      order: { startTime: 'DESC' },
      take: 5,
    });
    // TypeORM의 find에서 status IN 조건을 위해 queryBuilder 사용
    const recentFailsFiltered = await this.logRepo
      .createQueryBuilder('l')
      .where('l.organizationId = :organizationId', { organizationId })
      .andWhere('l.status IN (:...statuses)', { statuses: ['FAIL', 'TIMEOUT'] })
      .orderBy('l.startTime', 'DESC')
      .take(5)
      .getMany();

    return {
      todayTotal,
      todaySuccess,
      todayFail,
      successRate,
      dailyTrend,
      jobRatio,
      recentFails: recentFailsFiltered,
    };
  }

  // =============================================
  // 복구
  // =============================================

  /**
   * 서버 재시작 시 RUNNING/RETRYING 상태 로그를 FAIL로 복구
   * @param organizationId 조직 ID
   * @returns 복구된 건수
   */
  async recoverStaleRunning(organizationId: number): Promise<number> {
    const result = await this.dataSource.query(
      `UPDATE "ISYS_SCHEDULER_LOGS"
          SET "STATUS" = 'FAIL',
              "ERROR_MSG" = '서버 재시작으로 인한 자동 FAIL 처리',
              "END_TIME" = SYSTIMESTAMP
        WHERE "ORGANIZATION_ID" = :1
          AND "STATUS" IN ('RUNNING', 'RETRYING')`,
      [organizationId],
    );
    const affected = result?.rowsAffected ?? 0;
    if (affected > 0) {
      this.logger.warn(`Stale 로그 ${affected}건 FAIL 처리 완료 (organizationId=${organizationId})`);
    }
    return affected;
  }
}

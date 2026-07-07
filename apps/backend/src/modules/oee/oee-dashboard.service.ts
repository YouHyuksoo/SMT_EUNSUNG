/**
 * @file src/modules/oee/oee-dashboard.service.ts
 * @description OEE 대시보드 조회 — 공정별 종합/리소스 드릴다운/로스 파레토.
 *
 * 데이터 소스 2계층(스펙 §4.2):
 *  - 당일(workDate >= 오늘) → 실시간 뷰 V_OEE_LIVE
 *  - 과거(workDate < 오늘)  → 마감 스냅샷 OEE_DAILY_SUMMARY
 * 과거인데 스냅샷이 없으면 **폴백 없이** 409(OEE_SUMMARY_NOT_BUILT)로 마감 필요를 알린다.
 * 두 소스는 컬럼셋이 동일하므로 FROM만 교체한다(정합성은 P_OEE_BUILD_SUMMARY가 보장).
 *
 * 원자재준비율/고객불량은 OEE 곱셈식 밖의 선행/사후 KPI라 별도 테이블에서 조회해 종합화면 위젯으로 반환한다.
 */
import { ConflictException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

/** 공정별 종합 행 */
export interface OverviewRow {
  PROCESS_CODE: string;
  AVAILABILITY: number;
  PERFORMANCE: number;
  QUALITY: number;
  OEE: number;
  PLAN_ACHIEVE: number;
  OUTPUT_QTY: number;
  UPH: number;
  PICKUP_RATE: number | null;
}

/** 리소스 드릴다운 행 */
export interface DrilldownRow {
  RESOURCE_ID: number;
  RESOURCE_NAME: string;
  AVAILABILITY: number;
  PERFORMANCE: number;
  QUALITY: number;
  OEE: number;
  UPH: number;
  PLAN_ACHIEVE: number;
  RUN_MIN: number;
  DOWNTIME_MIN: number;
  OUTPUT_QTY: number;
}

/** 로스 파레토 행 */
export interface LossRow {
  REASON_CODE: string;
  REASON_NAME: string;
  LOSS_BUCKET: string | null;
  DOWN_MIN: number;
}

@Injectable()
export class OeeDashboardService {
  constructor(private readonly dataSource: DataSource) {}

  /** KST(백엔드 고정 TZ) 기준 오늘 날짜 문자열 YYYY-MM-DD */
  private todayKst(): string {
    const d = new Date();
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    return `${y}-${m}-${day}`;
  }

  /** 당일 이상이면 실시간, 과거면 스냅샷 */
  private isLive(workDate: string): boolean {
    return workDate >= this.todayKst();
  }

  private source(live: boolean): string {
    return live ? 'V_OEE_LIVE' : 'OEE_DAILY_SUMMARY';
  }

  private notBuilt(): never {
    throw new ConflictException({
      errorCode: 'OEE_SUMMARY_NOT_BUILT',
      message: '해당 일자의 OEE 집계가 생성되지 않았습니다 (마감 필요)',
    });
  }

  /** 공정별 종합 + 원자재준비/고객불량 위젯 */
  async overview(dateParam?: string) {
    const workDate = dateParam || this.todayKst();
    const live = this.isLive(workDate);

    const rows: OverviewRow[] = await this.dataSource.query(
      `SELECT PROCESS_CODE,
              ROUND(AVG(AVAILABILITY), 4) AS AVAILABILITY,
              ROUND(AVG(PERFORMANCE), 4)  AS PERFORMANCE,
              ROUND(AVG(QUALITY), 4)      AS QUALITY,
              ROUND(AVG(OEE), 4)          AS OEE,
              ROUND(AVG(PLAN_ACHIEVE), 4) AS PLAN_ACHIEVE,
              ROUND(SUM(OUTPUT_QTY), 0)   AS OUTPUT_QTY,
              ROUND(AVG(UPH), 1)          AS UPH,
              ROUND(AVG(PICKUP_RATE), 2)  AS PICKUP_RATE
         FROM ${this.source(live)}
        WHERE WORK_DATE = TO_DATE(:1, 'YYYY-MM-DD')
        GROUP BY PROCESS_CODE
        ORDER BY PROCESS_CODE`,
      [workDate],
    );

    if (!live && rows.length === 0) this.notBuilt();

    const material = await this.dataSource.query(
      `SELECT PROCESS_CODE, PLAN_QTY, READY_QTY, READINESS_RATE
         FROM OEE_MATERIAL_READINESS
        WHERE WORK_DATE = TO_DATE(:1, 'YYYY-MM-DD')
        ORDER BY PROCESS_CODE`,
      [workDate],
    );
    const customer: Array<{ RETURN_QTY: number }> = await this.dataSource.query(
      `SELECT NVL(SUM(RETURN_QTY), 0) AS RETURN_QTY
         FROM OEE_CUSTOMER_DEFECT
        WHERE WORK_DATE = TO_DATE(:1, 'YYYY-MM-DD')`,
      [workDate],
    );

    return {
      workDate,
      live,
      rows,
      material,
      customerReturnQty: customer[0]?.RETURN_QTY ?? 0,
    };
  }

  /** 특정 공정 리소스별 드릴다운 */
  async drilldown(processCode: string, dateParam?: string) {
    const workDate = dateParam || this.todayKst();
    const live = this.isLive(workDate);

    const rows: DrilldownRow[] = await this.dataSource.query(
      `SELECT v.RESOURCE_ID, r.RESOURCE_NAME,
              v.AVAILABILITY, v.PERFORMANCE, v.QUALITY, v.OEE,
              v.UPH, v.PLAN_ACHIEVE, v.RUN_MIN, v.DOWNTIME_MIN, v.OUTPUT_QTY
         FROM ${this.source(live)} v
         JOIN OEE_RESOURCE r ON r.RESOURCE_ID = v.RESOURCE_ID
        WHERE v.WORK_DATE = TO_DATE(:1, 'YYYY-MM-DD')
          AND v.PROCESS_CODE = :2
        ORDER BY v.OEE`,
      [workDate, processCode],
    );

    if (!live && rows.length === 0) this.notBuilt();

    return { workDate, live, processCode, rows };
  }

  /**
   * 로스 파레토 — 사유별 비가동시간(내림차순). 당일/과거 공통으로 OEE_OPERATION_LOG를 집계한다
   * (일지 원장은 마감 후에도 남으므로 스냅샷 분기·409가 필요 없다).
   * 사유 마스터는 (코드,공정) 다중행일 수 있어 코드 단위로 먼저 축약해 조인 fan-out을 막는다.
   */
  async lossPareto(dateParam?: string) {
    const workDate = dateParam || this.todayKst();

    const rows: LossRow[] = await this.dataSource.query(
      `SELECT ol.REASON_CODE,
              NVL(dr.REASON_NAME, ol.REASON_CODE) AS REASON_NAME,
              dr.LOSS_BUCKET,
              SUM(ol.DURATION_MIN) AS DOWN_MIN
         FROM OEE_OPERATION_LOG ol
         LEFT JOIN (
           SELECT REASON_CODE, MAX(REASON_NAME) AS REASON_NAME, MAX(LOSS_BUCKET) AS LOSS_BUCKET
             FROM OEE_DOWNTIME_REASON
            WHERE ORGANIZATION_ID = 1
            GROUP BY REASON_CODE
         ) dr ON dr.REASON_CODE = ol.REASON_CODE
        WHERE ol.WORK_DATE = TO_DATE(:1, 'YYYY-MM-DD')
          AND ol.STATUS = 'DOWN'
        GROUP BY ol.REASON_CODE, dr.REASON_NAME, dr.LOSS_BUCKET
        ORDER BY DOWN_MIN DESC`,
      [workDate],
    );

    return { workDate, rows };
  }
}

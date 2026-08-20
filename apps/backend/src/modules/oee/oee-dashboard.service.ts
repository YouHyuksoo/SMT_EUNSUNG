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
import { BadRequestException, ConflictException, Injectable } from '@nestjs/common';
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
  RESOURCE_CODE: string;
  RESOURCE_TYPE: string;
  RESOURCE_NAME: string;
  SHIFT: string;
  NET_LOAD_MIN: number | null;
  IDEAL_CT: number | null;
  PLAN_QTY: number | null;
  GOOD_QTY: number | null;
  TOTAL_QTY: number | null;
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
    const d = new Date(Date.now() - 8.5 * 60 * 60 * 1000);
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
  async overview(dateParam?: string, organizationId?: number) {
    const organization = this.requireOrganization(organizationId);
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
          AND ORGANIZATION_ID = :2
        GROUP BY PROCESS_CODE
        ORDER BY PROCESS_CODE`,
      [workDate, organization],
    );

    if (!live && rows.length === 0) this.notBuilt();

    const material = await this.dataSource.query(
      `SELECT PROCESS_CODE, PLAN_QTY, READY_QTY, READINESS_RATE
         FROM OEE_MATERIAL_READINESS
        WHERE WORK_DATE = TO_DATE(:1, 'YYYY-MM-DD')
          AND ORGANIZATION_ID = :2
        ORDER BY PROCESS_CODE`,
      [workDate, organization],
    );
    const customer: Array<{ RETURN_QTY: number }> = await this.dataSource.query(
      `SELECT NVL(SUM(RETURN_QTY), 0) AS RETURN_QTY
         FROM OEE_CUSTOMER_DEFECT
         WHERE WORK_DATE = TO_DATE(:1, 'YYYY-MM-DD')
           AND ORGANIZATION_ID = :2`,
      [workDate, organization],
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
  async drilldown(processCode: string, dateParam?: string, organizationId?: number) {
    const organization = this.requireOrganization(organizationId);
    const workDate = dateParam || this.todayKst();
    const live = this.isLive(workDate);

    const rows: DrilldownRow[] = await this.dataSource.query(
       `SELECT v.RESOURCE_ID, l.LINE_CODE AS RESOURCE_CODE, r.RESOURCE_TYPE,
               l.LINE_NAME AS RESOURCE_NAME, v.SHIFT,
               v.NET_LOAD_MIN, v.IDEAL_CT, v.PLAN_QTY, v.GOOD_QTY, v.TOTAL_QTY,
               v.AVAILABILITY, v.PERFORMANCE, v.QUALITY, v.OEE,
              v.UPH, v.PLAN_ACHIEVE, v.RUN_MIN, v.DOWNTIME_MIN, v.OUTPUT_QTY
         FROM ${this.source(live)} v
         JOIN OEE_RESOURCE r ON r.RESOURCE_ID = v.RESOURCE_ID
                              AND r.ORGANIZATION_ID = :3
         JOIN IP_PRODUCT_LINE l
           ON l.ORGANIZATION_ID = r.ORGANIZATION_ID
          AND l.LINE_CODE = r.REF_CODE
         WHERE v.WORK_DATE = TO_DATE(:1, 'YYYY-MM-DD')
           AND v.PROCESS_CODE = :2
           AND v.ORGANIZATION_ID = :3
          ORDER BY v.OEE, v.RESOURCE_ID, v.SHIFT`,
       [workDate, processCode, organization],
    );

    if (!live && rows.length === 0) this.notBuilt();

    return { workDate, live, processCode, rows };
  }

  /** 모바일 비가동 이벤트를 사유별로 집계한다. */
  async lossPareto(dateParam?: string, organizationId?: number) {
    const organization = this.requireOrganization(organizationId);
    const workDate = dateParam || this.todayKst();

    const rows: LossRow[] = await this.dataSource.query(
      `SELECT e.REASON_CODE,
              NVL(MAX(c.CODE_MEAN_KOR), e.REASON_CODE) AS REASON_NAME,
              CAST(NULL AS VARCHAR2(30)) AS LOSS_BUCKET,
              SUM((CAST(NVL(e.END_TIME, SYSTIMESTAMP) AS DATE) - CAST(e.START_TIME AS DATE)) * 1440) AS DOWN_MIN
         FROM OEE_DOWNTIME_EVENT e
         LEFT JOIN ISYS_BASECODE c
           ON c.ORGANIZATION_ID = e.ORGANIZATION_ID
         AND c.CODE_TYPE = 'MACHINE STATUS CODE'
           AND c.CODE_NAME = e.REASON_CODE
         WHERE e.WORK_DATE = TO_DATE(:1, 'YYYY-MM-DD')
           AND e.ORGANIZATION_ID = :2
         GROUP BY e.REASON_CODE
         ORDER BY DOWN_MIN DESC`,
       [workDate, organization],
    );

    return { workDate, rows };
  }

  private requireOrganization(organizationId?: number): number {
    if (organizationId == null || !Number.isInteger(organizationId) || organizationId <= 0) {
      throw new BadRequestException('인증 조직 정보가 필요합니다.');
    }
    return organizationId;
  }
}

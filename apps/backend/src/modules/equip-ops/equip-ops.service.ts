// 설비 운영 현황 — 설비마스터 전체 상태 + 라인/설비 기준 당일지표·당월이력 조회
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { EquipDowntimeResult } from '../../entities/equip-downtime-result.entity';

const ORG = 1;

/** 라인/설비 중 무엇을 기준으로 볼지 — 설비↔라인 매핑이 비어 있어도 SQL 형태는 동일하게 유지한다 */
interface ScopeParams {
  machineCode?: string;
  lineCode?: string;
}

@Injectable()
export class EquipOpsService {
  constructor(
    @InjectRepository(EquipDowntimeResult)
    private readonly repo: Repository<EquipDowntimeResult>,
  ) {}

  private q<T = Record<string, unknown>>(sql: string, params: unknown[] = []): Promise<T[]> {
    return this.repo.manager.query(sql, params);
  }

  /** 조회 대상 설비를 좁히는 조건. 설비코드 우선, 없으면 라인코드, 둘 다 없으면 전체 */
  private scopeClause(scope: ScopeParams, alias: string, params: unknown[]) {
    if (scope.machineCode) {
      params.push(scope.machineCode);
      return ` AND ${alias}.MACHINE_CODE = :${params.length}`;
    }
    if (scope.lineCode) {
      params.push(scope.lineCode);
      return ` AND ${alias}.MACHINE_CODE IN (SELECT MACHINE_CODE FROM IMCN_MACHINE WHERE ORGANIZATION_ID=${ORG} AND LINE_CODE = :${params.length})`;
    }
    return '';
  }

  /** 설비 목록 + 유형명·공정명·모델 + 진행중 비가동 여부 */
  machines(filter: { machineType?: string; workstageCode?: string; keyword?: string; lineCode?: string }) {
    const params: unknown[] = [];
    let where = `m.ORGANIZATION_ID = ${ORG}`;
    if (filter.machineType) { params.push(filter.machineType); where += ` AND m.MACHINE_TYPE = :${params.length}`; }
    if (filter.workstageCode) { params.push(filter.workstageCode); where += ` AND m.WORKSTAGE_CODE = :${params.length}`; }
    if (filter.lineCode) { params.push(filter.lineCode); where += ` AND m.LINE_CODE = :${params.length}`; }
    if (filter.keyword) {
      params.push(`%${filter.keyword.toUpperCase()}%`);
      const i = params.length;
      where += ` AND (UPPER(m.MACHINE_CODE) LIKE :${i} OR UPPER(m.MACHINE_NAME) LIKE :${i})`;
    }
    return this.q(
      `SELECT m.MACHINE_CODE AS "machineCode", m.MACHINE_NAME AS "machineName",
              m.MACHINE_TYPE AS "machineType",
              (SELECT MAX(b.CODE_MEAN_KOR) FROM ISYS_BASECODE b
                WHERE b.CODE_TYPE='MACHINE TYPE' AND b.CODE_NAME=m.MACHINE_TYPE AND b.ORGANIZATION_ID=m.ORGANIZATION_ID) AS "machineTypeName",
              m.WORKSTAGE_CODE AS "workstageCode",
              (SELECT MAX(w.WORKSTAGE_NAME) FROM IP_PRODUCT_WORKSTAGE w
                WHERE w.WORKSTAGE_CODE=m.WORKSTAGE_CODE AND w.ORGANIZATION_ID=m.ORGANIZATION_ID) AS "workstageName",
              m.MACHINE_MODEL_NAME AS "modelName",
              m.LINE_CODE AS "lineCode",
              (SELECT MAX(d.DT_SEQ) FROM IP_EQUIP_DOWNTIME_RESULT d
                WHERE d.MACHINE_CODE=m.MACHINE_CODE AND d.ORGANIZATION_ID=m.ORGANIZATION_ID AND d.END_TIME IS NULL) AS "openDtSeq"
         FROM IMCN_MACHINE m
        WHERE ${where}
        ORDER BY m.MACHINE_CODE`,
      params,
    );
  }

  /** 라인 목록 (라인코드·라인명·라인구분) + 배정 설비 수 */
  lines() {
    return this.q(
      `SELECT l.LINE_CODE AS "lineCode", l.LINE_NAME AS "lineName", l.LINE_DIVISION AS "lineDivision",
              (SELECT COUNT(*) FROM IMCN_MACHINE m WHERE m.LINE_CODE=l.LINE_CODE AND m.ORGANIZATION_ID=l.ORGANIZATION_ID) AS "machineCount"
         FROM IP_PRODUCT_LINE l
        WHERE l.ORGANIZATION_ID = ${ORG}
        ORDER BY l.LINE_CODE`,
    );
  }

  /** 당일 지표 — 달력 자정 기준. 비가동 분·정지 회수만 실측이고 나머지 산식은 미확정 */
  async summary(scope: ScopeParams) {
    const params: unknown[] = [];
    const scopeSql = this.scopeClause(scope, 'd', params);
    // 진행중 비가동은 지금(SYSDATE)까지, 당일 이전에 시작한 건은 자정부터 센다
    const rows = await this.q<{ downMinutes: number; stopCount: number }>(
      `SELECT NVL(ROUND(SUM(
                (LEAST(NVL(d.END_TIME, SYSDATE), TRUNC(SYSDATE) + 1)
                 - GREATEST(d.START_TIME, TRUNC(SYSDATE))) * 24 * 60
              )), 0) AS "downMinutes",
              COUNT(*) AS "stopCount"
         FROM IP_EQUIP_DOWNTIME_RESULT d
        WHERE d.ORGANIZATION_ID = ${ORG}
          AND d.START_TIME < TRUNC(SYSDATE) + 1
          AND NVL(d.END_TIME, SYSDATE) >= TRUNC(SYSDATE)${scopeSql}`,
      params,
    );
    return {
      downMinutes: Number(rows[0]?.downMinutes ?? 0),
      stopCount: Number(rows[0]?.stopCount ?? 0),
    };
  }

  /** 당월 비가동 이력 + 합계 요약 — 달력 기준(1일 00:00 ~ 익월 1일 00:00) */
  async monthly(scope: ScopeParams) {
    const params: unknown[] = [];
    const scopeSql = this.scopeClause(scope, 'd', params);
    const list = await this.q(
      `SELECT d.DT_SEQ AS "dtSeq", d.MACHINE_CODE AS "machineCode",
              (SELECT MAX(m.MACHINE_NAME) FROM IMCN_MACHINE m
                WHERE m.MACHINE_CODE=d.MACHINE_CODE AND m.ORGANIZATION_ID=d.ORGANIZATION_ID) AS "machineName",
              d.REASON_CODE AS "reasonCode",
              (SELECT MAX(r.REASON_NAME) FROM IP_EQUIP_DOWNTIME_REASON r
                WHERE r.REASON_CODE=d.REASON_CODE AND r.ORGANIZATION_ID=d.ORGANIZATION_ID) AS "reasonName",
              TO_CHAR(d.START_TIME,'MM-DD HH24:MI') AS "startTime",
              TO_CHAR(d.END_TIME,'MM-DD HH24:MI') AS "endTime",
              ROUND((NVL(d.END_TIME, SYSDATE) - d.START_TIME) * 24 * 60) AS "durationMin"
         FROM IP_EQUIP_DOWNTIME_RESULT d
        WHERE d.ORGANIZATION_ID = ${ORG}
          AND d.START_TIME >= TRUNC(SYSDATE,'MM')
          AND d.START_TIME < ADD_MONTHS(TRUNC(SYSDATE,'MM'), 1)${scopeSql}
        ORDER BY d.DT_SEQ DESC`,
      params,
    );
    const totalMin = list.reduce((s, r) => s + Number((r as { durationMin: number }).durationMin ?? 0), 0);
    return { list, totalCount: list.length, totalMinutes: totalMin };
  }
}

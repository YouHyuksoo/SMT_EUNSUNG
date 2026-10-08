/**
 * @file src/modules/monitoring/services/quality-board.service.ts
 * @description 품질 보드 집계 서비스 — 금일 판정/진성불량, 라인별, 불량유형 TOP10, 수리 현황, 7일 추이
 *
 * 초보자 가이드:
 * 1. 데이터원은 IP_PRODUCT_WORK_QC 한 테이블이다 (AOI 가 불량 의심으로 올린 건만 쌓인다).
 *    대시보드 getSummary 의 "불량" 카드와 같은 기준(QC_RESULT W=대기 N=진성 O=가성)이다.
 * 2. 이 테이블에는 "양품 검사 건수"가 없다. 그래서 HANES 의 생산량 대비 불량률 대신 아래처럼 정의한다.
 *    - totalQty   = 판정 건수  = QC_RESULT IN (W, N, O) 건수
 *    - defectQty  = 진성불량   = QC_RESULT = 'N' 건수
 *    - defectRate = 진성불량 / 판정 건수 (%) — 의심 건 중 진짜 불량 비율이다 (생산량 대비 불량률이 아님)
 * 3. byProcess 는 공정(WORKSTAGE_CODE)이 전부 W040(MOUNT) 한 가지라 라인(LINE_CODE)별로 묶는다.
 *    응답 필드명은 계약 그대로 processCode 이며 값은 라인명(예: E라인)이다.
 * 4. topDefects: 진성(N)만, BAD_REASON_CODE 별 건수. 이름은 DB 함수 F_GET_CODE_MASTER 로 얻는다.
 * 5. repair: 수리 큐는 최근 30일 안의 진성 건만 본다 (오래된 미처리 잔재가 계속 떠 있지 않게).
 *    - received       = 진성 + REPAIR_RESULT_CODE 없음 + 폐기(D) 아님  (수리 결과가 아직 없는 건)
 *    - inRepair       = 진성 + REPAIR_RESULT_CODE = 'N'(불합격)         (수리했지만 불합격 → 재수리 대기)
 *    - completedToday = 진성 + REPAIR_RESULT_CODE = 'G'(수리완료) + REPAIR_DATE 가 오늘
 *    "수리중"을 직접 나타내는 컬럼은 없다. 코드표(REPAIR RESULT CODE: G 수리완료 / N 불합격)로 근사했다.
 * 6. 조회 전용이다. 쿼리 4개를 순차로 실행해 커넥션을 한 번에 1개만 쓴다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

const ORG = 1;
/** 수리 큐를 보는 기간(일) */
const REPAIR_WINDOW_DAYS = 30;
/** 불량유형 TOP N */
const TOP_LIMIT = 10;

type Row = Record<string, string | number | null>;

export interface QualityBoardResponse {
  kpi: { totalQty: number; defectQty: number; defectRate: number };
  byProcess: { processCode: string; totalQty: number; defectQty: number; defectRate: number }[];
  topDefects: { defectCode: string; defectName: string; qty: number }[];
  repair: { received: number; inRepair: number; completedToday: number };
  dailyTrend: { date: string; totalQty: number; defectQty: number; defectRate: number }[];
}

/** 소수 1자리 % — 분모 0 이면 0 */
function rate(defect: number, total: number): number {
  return total > 0 ? Math.round((defect / total) * 1000) / 10 : 0;
}

@Injectable()
export class QualityBoardService {
  constructor(private readonly dataSource: DataSource) {}

  async getBoard(): Promise<QualityBoardResponse> {
    const byProcess = await this.getByLine();
    const topDefects = await this.getTopDefects();
    const repair = await this.getRepair();
    const dailyTrend = await this.getDailyTrend();

    const totalQty = byProcess.reduce((s, p) => s + p.totalQty, 0);
    const defectQty = byProcess.reduce((s, p) => s + p.defectQty, 0);
    return {
      kpi: { totalQty, defectQty, defectRate: rate(defectQty, totalQty) },
      byProcess,
      topDefects,
      repair,
      dailyTrend,
    };
  }

  /** 금일 라인별 판정 건수 / 진성불량 건수 (진성불량 많은 순) */
  private async getByLine() {
    const rows = (await this.dataSource.query(
      `SELECT NVL(l.LINE_NAME, NVL(q.LINE_CODE, '-')) AS "processCode",
              COUNT(*) AS "totalQty",
              NVL(SUM(CASE WHEN q.QC_RESULT = 'N' THEN 1 ELSE 0 END), 0) AS "defectQty"
         FROM IP_PRODUCT_WORK_QC q
         LEFT JOIN IP_PRODUCT_LINE l
                ON l.LINE_CODE = q.LINE_CODE AND l.ORGANIZATION_ID = q.ORGANIZATION_ID
        WHERE q.ORGANIZATION_ID = ${ORG}
          AND q.QC_RESULT IN ('W', 'N', 'O')
          AND q.QC_DATE >= TRUNC(SYSDATE)
          AND q.QC_DATE < TRUNC(SYSDATE) + 1
        GROUP BY NVL(l.LINE_NAME, NVL(q.LINE_CODE, '-'))
        ORDER BY 3 DESC, 1`,
    )) as Row[];
    return rows.map((r) => {
      const totalQty = Number(r.totalQty ?? 0);
      const defectQty = Number(r.defectQty ?? 0);
      return { processCode: String(r.processCode ?? '-'), totalQty, defectQty, defectRate: rate(defectQty, totalQty) };
    });
  }

  /** 금일 진성불량 사유 TOP N — 사유명은 코드표 'WQC BAD REASON CODE' */
  private async getTopDefects() {
    const rows = (await this.dataSource.query(
      `SELECT NVL(q.BAD_REASON_CODE, '-') AS "defectCode",
              MAX(F_GET_CODE_MASTER('WQC BAD REASON CODE', q.BAD_REASON_CODE, 'KOR', q.ORGANIZATION_ID)) AS "defectName",
              COUNT(*) AS "qty"
         FROM IP_PRODUCT_WORK_QC q
        WHERE q.ORGANIZATION_ID = ${ORG}
          AND q.QC_RESULT = 'N'
          AND q.QC_DATE >= TRUNC(SYSDATE)
          AND q.QC_DATE < TRUNC(SYSDATE) + 1
        GROUP BY NVL(q.BAD_REASON_CODE, '-')
        ORDER BY 3 DESC, 1
        FETCH FIRST ${TOP_LIMIT} ROWS ONLY`,
    )) as Row[];
    return rows.map((r) => {
      const code = String(r.defectCode ?? '-');
      const name = typeof r.defectName === 'string' ? r.defectName.trim() : '';
      return { defectCode: code, defectName: name || code, qty: Number(r.qty ?? 0) };
    });
  }

  /** 수리 대기 / 재수리(불합격) / 금일 수리완료 — 정의는 파일 머리 주석 5번 */
  private async getRepair() {
    const rows = (await this.dataSource.query(
      `SELECT NVL(SUM(CASE WHEN q.REPAIR_RESULT_CODE IS NULL
                            AND NVL(q.QC_INSPECT_HANDLING, '*') <> 'D' THEN 1 ELSE 0 END), 0) AS "received",
              NVL(SUM(CASE WHEN q.REPAIR_RESULT_CODE = 'N' THEN 1 ELSE 0 END), 0) AS "inRepair",
              NVL(SUM(CASE WHEN q.REPAIR_RESULT_CODE = 'G'
                            AND q.REPAIR_DATE >= TRUNC(SYSDATE)
                            AND q.REPAIR_DATE < TRUNC(SYSDATE) + 1 THEN 1 ELSE 0 END), 0) AS "completedToday"
         FROM IP_PRODUCT_WORK_QC q
        WHERE q.ORGANIZATION_ID = ${ORG}
          AND q.QC_RESULT = 'N'
          AND q.QC_DATE >= TRUNC(SYSDATE) - ${REPAIR_WINDOW_DAYS}`,
    )) as Row[];
    const r = rows[0] ?? {};
    return {
      received: Number(r.received ?? 0),
      inRepair: Number(r.inRepair ?? 0),
      completedToday: Number(r.completedToday ?? 0),
    };
  }

  /** 최근 7일(오늘 포함) 일별 판정/진성불량 — 쉬는 날도 0 으로 채운다 */
  private async getDailyTrend() {
    const rows = (await this.dataSource.query(
      `SELECT TO_CHAR(c.d, 'YYYY-MM-DD') AS "ymd",
              COUNT(q.qc_result) AS "totalQty",
              NVL(SUM(CASE WHEN q.qc_result = 'N' THEN 1 ELSE 0 END), 0) AS "defectQty"
         FROM (SELECT TRUNC(SYSDATE) - 7 + LEVEL AS d FROM DUAL CONNECT BY LEVEL <= 7) c
         LEFT JOIN (SELECT TRUNC(QC_DATE) AS qc_day, QC_RESULT AS qc_result
                      FROM IP_PRODUCT_WORK_QC
                     WHERE ORGANIZATION_ID = ${ORG}
                       AND QC_RESULT IN ('W', 'N', 'O')
                       AND QC_DATE >= TRUNC(SYSDATE) - 6
                       AND QC_DATE < TRUNC(SYSDATE) + 1) q
                ON q.qc_day = c.d
        GROUP BY c.d
        ORDER BY c.d`,
    )) as Row[];
    return rows.map((r) => {
      const totalQty = Number(r.totalQty ?? 0);
      const defectQty = Number(r.defectQty ?? 0);
      return { date: String(r.ymd), totalQty, defectQty, defectRate: rate(defectQty, totalQty) };
    });
  }
}

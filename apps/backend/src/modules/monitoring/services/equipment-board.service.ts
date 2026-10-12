/**
 * @file src/modules/monitoring/services/equipment-board.service.ts
 * @description 설비 보드 집계 서비스 — 설비 카드(93대 규모) + 라인별 현재 가동 작업을 한 번에 돌려준다
 *
 * 초보자 가이드:
 * 1. HANES 는 설비 목록과 RUNNING 작업지시를 프론트에서 조인하지만, 은성에는 그 API 가 없다.
 *    그래서 GET /monitoring/boards/equipment 한 번으로 { equips, runningJobs } 를 준다.
 * 2. 설비(equips): IMCN_MACHINE (MACHINE_TYPE='TEMP' 온도계 제외, ORGANIZATION_ID=1).
 *    status 는 아래 3가지다 (은성에는 점검/인터록 상태 데이터가 없다).
 *    - STOP   : IP_EQUIP_DOWNTIME_RESULT 에 종료시각(END_TIME)이 없는 진행중 비가동이 있다
 *    - UNUSED : IMCN_MACHINE.USE_STATUS 가 S/T/D (대시보드 getSummary 의 "미사용"과 같은 기준)
 *    - NORMAL : 그 외
 * 3. 가동 작업(runningJobs): 설비별 작업지시 데이터가 없어 "라인 단위"로만 연결한다.
 *    IP_PRODUCT_SENSOR_ACTUAL_TIME(SMD 센서 실적, 시간대 A~J 가 약 2시간 단위로 기록됨)에
 *    최근 LIVE_WINDOW_MIN 분 안에 기록(LAST_MODIFY_DATE)이 있는 라인을 "가동 중"으로 본다.
 *    라인마다 가장 최근에 기록된 모델 1건만 낸다.
 *    - planQty   : 같은 날짜·라인·모델의 IP_PRODUCT_SMD_PLAN.PLAN_QTY 합 (계획 없으면 0)
 *    - goodQty   : 같은 날짜·라인·모델의 센서 실적(PRODUCT_ACTUAL_QTY) 합
 *    - defectQty : 같은 라인·모델의 진성불량(IP_PRODUCT_WORK_QC.QC_RESULT='N') 건수 (실적일 이후)
 *    프론트는 설비의 lineCode 와 runningJobs[].lineCode 를 맞춰 그 라인의 정상 설비를 "작업중"으로 칠한다.
 * 4. 조회 전용. 쿼리 2개를 순차 실행(커넥션 1개씩).
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

const ORG = 1;
/** 센서 실적이 이 시간(분) 안에 기록된 라인을 가동 중으로 본다 (시간대 간격 약 2시간 + 여유) */
const LIVE_WINDOW_MIN = 180;

type Row = Record<string, string | number | null>;

export type EquipStatus = 'NORMAL' | 'STOP' | 'UNUSED';

export interface EquipCardDto {
  id: string;
  equipCode: string;
  equipName: string;
  equipType: string | null;
  lineCode: string | null;
  lineName: string | null;
  processCode: string | null;
  processName: string | null;
  status: EquipStatus;
  ipAddress: string | null;
  modelName: string | null;
}

export interface RunningJobDto {
  lineCode: string;
  orderNo: string;
  itemName: string | null;
  planQty: number;
  goodQty: number;
  defectQty: number;
  lastActualAt: string | null;
}

export interface EquipmentBoardResponse {
  equips: EquipCardDto[];
  runningJobs: RunningJobDto[];
}

function str(v: string | number | null | undefined): string | null {
  if (v === null || v === undefined) return null;
  const s = String(v).trim();
  return s === '' ? null : s;
}

@Injectable()
export class EquipmentBoardService {
  constructor(private readonly dataSource: DataSource) {}

  async getBoard(): Promise<EquipmentBoardResponse> {
    const equips = await this.getEquips();
    const runningJobs = await this.getRunningJobs();
    return { equips, runningJobs };
  }

  /** 설비 마스터 + 진행중 비가동 여부 (TEMP 제외) */
  private async getEquips(): Promise<EquipCardDto[]> {
    const rows = (await this.dataSource.query(
      `SELECT m.MACHINE_CODE AS "equipCode",
              m.MACHINE_NAME AS "equipName",
              (SELECT MAX(b.CODE_MEAN_KOR) FROM ISYS_BASECODE b
                WHERE b.CODE_TYPE = 'MACHINE TYPE' AND b.CODE_NAME = m.MACHINE_TYPE
                  AND b.ORGANIZATION_ID = m.ORGANIZATION_ID) AS "equipTypeName",
              m.MACHINE_TYPE AS "equipType",
              m.LINE_CODE AS "lineCode",
              l.LINE_NAME AS "lineName",
              m.WORKSTAGE_CODE AS "processCode",
              w.WORKSTAGE_NAME AS "processName",
              m.USE_STATUS AS "useStatus",
              m.IP_ADDRESS AS "ipAddress",
              m.MACHINE_MODEL_NAME AS "modelName",
              CASE WHEN EXISTS (SELECT 1 FROM IP_EQUIP_DOWNTIME_RESULT d
                                 WHERE d.MACHINE_CODE = m.MACHINE_CODE
                                   AND d.ORGANIZATION_ID = m.ORGANIZATION_ID
                                   AND d.END_TIME IS NULL) THEN 1 ELSE 0 END AS "down"
         FROM IMCN_MACHINE m
         LEFT JOIN IP_PRODUCT_LINE l
                ON l.LINE_CODE = m.LINE_CODE AND l.ORGANIZATION_ID = m.ORGANIZATION_ID
         LEFT JOIN IP_PRODUCT_WORKSTAGE w
                ON w.WORKSTAGE_CODE = m.WORKSTAGE_CODE AND w.ORGANIZATION_ID = m.ORGANIZATION_ID
        WHERE m.ORGANIZATION_ID = ${ORG}
          AND NVL(m.MACHINE_TYPE, '*') <> 'TEMP'
        ORDER BY m.LINE_CODE, m.MACHINE_CODE`,
    )) as Row[];

    return rows.map((r) => {
      const useStatus = str(r.useStatus);
      let status: EquipStatus = 'NORMAL';
      if (Number(r.down ?? 0) > 0) status = 'STOP';
      else if (useStatus === 'S' || useStatus === 'T' || useStatus === 'D') status = 'UNUSED';
      const lineCode = str(r.lineCode);
      const code = String(r.equipCode);
      return {
        id: code,
        equipCode: code,
        equipName: str(r.equipName) ?? code,
        equipType: str(r.equipTypeName) ?? str(r.equipType),
        // '*' 는 라인 미배정 표시다
        lineCode: lineCode === '*' ? null : lineCode,
        lineName: lineCode === '*' ? null : str(r.lineName),
        processCode: str(r.processCode),
        processName: str(r.processName),
        status,
        ipAddress: str(r.ipAddress),
        modelName: str(r.modelName),
      };
    });
  }

  /** 라인별 현재 가동 모델 1건 — 최근 LIVE_WINDOW_MIN 분 안에 센서 실적이 기록된 라인만 */
  private async getRunningJobs(): Promise<RunningJobDto[]> {
    const rows = (await this.dataSource.query(
      `WITH recent AS (
         SELECT s.RECEIPT_DATE, s.LINE_CODE, s.MODEL_NAME,
                SUM(NVL(s.PRODUCT_ACTUAL_QTY, 0)) AS good_qty,
                MAX(s.LAST_MODIFY_DATE) AS last_at
           FROM IP_PRODUCT_SENSOR_ACTUAL_TIME s
          WHERE s.ORGANIZATION_ID = ${ORG}
            AND s.RECEIPT_DATE >= TRUNC(SYSDATE) - 1
          GROUP BY s.RECEIPT_DATE, s.LINE_CODE, s.MODEL_NAME
         HAVING MAX(s.LAST_MODIFY_DATE) >= SYSDATE - ${LIVE_WINDOW_MIN} / 1440
       ), ranked AS (
         SELECT r.*, ROW_NUMBER() OVER (PARTITION BY r.LINE_CODE ORDER BY r.last_at DESC) AS rn
           FROM recent r
       )
       SELECT r.LINE_CODE AS "lineCode",
              r.MODEL_NAME AS "itemName",
              r.good_qty AS "goodQty",
              TO_CHAR(r.last_at, 'YYYY-MM-DD HH24:MI') AS "lastActualAt",
              (SELECT NVL(SUM(p.PLAN_QTY), 0) FROM IP_PRODUCT_SMD_PLAN p
                WHERE p.ORGANIZATION_ID = ${ORG} AND p.PLAN_DATE = r.RECEIPT_DATE
                  AND p.LINE_CODE = r.LINE_CODE AND p.MODEL_NAME = r.MODEL_NAME) AS "planQty",
              (SELECT MAX(p.WORK_ORDER_NO) FROM IP_PRODUCT_SMD_PLAN p
                WHERE p.ORGANIZATION_ID = ${ORG} AND p.PLAN_DATE = r.RECEIPT_DATE
                  AND p.LINE_CODE = r.LINE_CODE AND p.MODEL_NAME = r.MODEL_NAME) AS "orderNo",
              (SELECT COUNT(*) FROM IP_PRODUCT_WORK_QC q
                WHERE q.ORGANIZATION_ID = ${ORG} AND q.QC_RESULT = 'N'
                  AND q.QC_DATE >= r.RECEIPT_DATE
                  AND q.LINE_CODE = r.LINE_CODE AND q.MODEL_NAME = r.MODEL_NAME) AS "defectQty"
         FROM ranked r
        WHERE r.rn = 1
        ORDER BY r.LINE_CODE`,
    )) as Row[];

    return rows.map((r) => ({
      lineCode: String(r.lineCode ?? ''),
      orderNo: str(r.orderNo) ?? '',
      itemName: str(r.itemName),
      planQty: Number(r.planQty ?? 0),
      goodQty: Number(r.goodQty ?? 0),
      defectQty: Number(r.defectQty ?? 0),
      lastActualAt: str(r.lastActualAt),
    }));
  }
}

/**
 * @file src/modules/monitoring/services/inventory-board.service.ts
 * @description 재고 모니터링 보드 집계 서비스 — "조치가 필요한 재고"만 보여준다 (읽기 전용).
 *              품목 단위가 제각각인 총수량 합계는 무의미하므로 집계하지 않는다.
 *
 * 초보자 가이드:
 * 1. 응답 형태는 프론트 inventory-board/components/types.ts 의 InventoryBoardData 와 같다.
 *    { kpi, shortages, expiry, holds } — 목록은 상위 LIST_LIMIT 건, kpi 건수는 전체 건수.
 * 2. 은성 데이터 대응 (HANES 의 MAT_LOTS/PRODUCT_STOCKS 는 은성에 없다)
 *    - 안전재고 미달 : ID_ITEM.SAFETY_INVENTORY(> 0 인 품목) 대비 IM_ITEM_INVENTORY(자재창고) 합계 부족분
 *    - 유효기한      : ① 솔더 IM_ITEM_SOLDER_MASTER.VALID_DATE (불출됐고 폐기 전인 솔더, 30일 이내·초과)
 *                      ② MSL IM_ITEM_MSL_CHECK_VIEW (shared sqlMslNgCount 와 같은 판정 — 노출시간이
 *                         MSL 허용시간의 70% 이상인 LOT 이 후보, 경과율 99% 초과면 기한초과)
 *    - 보류/불량     : IM_ITEM_INVENTORY_HOLD (재고통제관리 화면이 만드는 행) + 잔량이 있는 LOT 만.
 *                      INVENTORY_STATUS 'B'(불량) → DEFECT, 그 외 → HOLD. 제품 보류는 대응 데이터가 없어 비워 둔다.
 *    - 금일 입출고   : 입고 IM_ITEM_RECEIPT.RECEIPT_DATE / 출고 IM_ITEM_ISSUE.ISSUE_DATE 오늘 건수
 * 3. IM_ITEM_INVENTORY 는 180만 행 — ITEM_CODE·MATERIAL_MFS 인덱스로만 접근하도록 쿼리를 짰다.
 * 4. 쿼리는 순차 실행한다 (오라클 커넥션 풀 고갈 방지 — 병렬로 5개를 쏘지 않는다).
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { namedBinds } from '../../../common/utils/named-binds.util';

/** 조직 ID (은성 단일 조직) */
const ORGANIZATION_ID = 1;
/** 목록(안전재고 미달 / 유효기한 / 보류) 최대 건수 */
const LIST_LIMIT = 50;
/** 솔더 유효기간 임박 기준일 */
const NEAR_EXPIRY_DAYS = 30;
/** MSL 후보 기준 — 노출시간이 허용시간의 이 비율 이상이면 임박 대상 (shared sqlMslNgCount 와 동일 0.7) */
const MSL_NEAR_RATIO = 0.7;
/** MSL 기한초과 기준 — 경과율이 이 값을 넘으면 초과 (shared sqlMslNgCount 의 0.99) */
const MSL_EXPIRED_RATIO = 0.99;

type Row = Record<string, unknown>;

export interface ShortageItem {
  itemCode: string;
  itemName: string | null;
  qty: number;
  safetyStock: number;
  shortage: number;
}

export interface ExpiryLot {
  matUid: string;
  itemCode: string;
  itemName: string | null;
  qty: number;
  expireDate: string;
  /** 음수면 기한초과 */
  daysLeft: number;
}

export interface HoldStock {
  kind: 'MATERIAL' | 'PRODUCT';
  ref: string;
  itemCode: string;
  itemName: string | null;
  qty: number;
  /** HOLD | IQC_FAIL | IQC_HOLD | DEFECT */
  reason: string;
}

export interface InventoryBoardData {
  kpi: {
    shortageCount: number;
    expiredCount: number;
    nearExpiryCount: number;
    holdCount: number;
    inCount: number;
    outCount: number;
  };
  shortages: ShortageItem[];
  expiry: ExpiryLot[];
  holds: HoldStock[];
}

/** 정렬용으로 남은 시간(시간 단위)을 같이 들고 다니는 기한 LOT */
interface ExpiryCandidate extends ExpiryLot {
  remainHours: number;
}

@Injectable()
export class InventoryBoardService {
  constructor(private readonly dataSource: DataSource) {}

  async getBoard(): Promise<InventoryBoardData> {
    const shortage = await this.getShortages();
    const expiryAll = await this.getExpiryLots();
    const hold = await this.getHoldStocks();
    const todayInOut = await this.getTodayInOut();

    return {
      kpi: {
        shortageCount: shortage.total,
        expiredCount: expiryAll.filter((e) => e.daysLeft < 0).length,
        nearExpiryCount: expiryAll.filter((e) => e.daysLeft >= 0).length,
        holdCount: hold.total,
        inCount: todayInOut.inCount,
        outCount: todayInOut.outCount,
      },
      shortages: shortage.items,
      expiry: expiryAll.slice(0, LIST_LIMIT).map((lot) => ({
        matUid: lot.matUid,
        itemCode: lot.itemCode,
        itemName: lot.itemName,
        qty: lot.qty,
        expireDate: lot.expireDate,
        daysLeft: lot.daysLeft,
      })),
      holds: hold.items,
    };
  }

  /**
   * 안전재고 미달 품목 — SAFETY_INVENTORY > 0 인 품목만, 부족량 큰 순.
   * 현재고는 자재창고 재고(IM_ITEM_INVENTORY) 합계. 품목별 상관 서브쿼리는 ITEM_CODE 인덱스를 탄다.
   */
  private async getShortages(): Promise<{ total: number; items: ShortageItem[] }> {
    const rows = (await this.dataSource.query(
      `SELECT s."itemCode", s."itemName", s."qty", s."safetyStock",
              COUNT(*) OVER () AS "totalCount"
         FROM (
               SELECT i.ITEM_CODE AS "itemCode",
                      i.ITEM_NAME AS "itemName",
                      (SELECT NVL(SUM(v.INVENTORY_QTY), 0)
                         FROM IM_ITEM_INVENTORY v
                        WHERE v.ITEM_CODE = i.ITEM_CODE
                          AND v.ORGANIZATION_ID = i.ORGANIZATION_ID) AS "qty",
                      i.SAFETY_INVENTORY AS "safetyStock"
                 FROM ID_ITEM i
                WHERE i.ORGANIZATION_ID = :organizationId
                  AND NVL(i.SAFETY_INVENTORY, 0) > 0
              ) s
        WHERE s."qty" < s."safetyStock"
        ORDER BY s."safetyStock" - s."qty" DESC, s."itemCode"
        FETCH FIRST ${LIST_LIMIT} ROWS ONLY`,
      namedBinds({ organizationId: ORGANIZATION_ID }),
    )) as Row[];

    const items = rows.map((r) => {
      const qty = Number(r.qty ?? 0);
      const safetyStock = Number(r.safetyStock ?? 0);
      return {
        itemCode: String(r.itemCode),
        itemName: (r.itemName as string | null) ?? null,
        qty,
        safetyStock,
        shortage: safetyStock - qty,
      };
    });
    return { total: Number(rows[0]?.totalCount ?? 0), items };
  }

  /** 유효기한 초과·임박 LOT — 솔더(유효기간) + MSL(노출시간), 남은 시간이 짧은 순 */
  private async getExpiryLots(): Promise<ExpiryCandidate[]> {
    const solder = await this.getSolderExpiry();
    const msl = await this.getMslExpiry();

    const seen = new Set<string>();
    return [...solder, ...msl]
      .sort((a, b) => a.remainHours - b.remainHours)
      .filter((lot) => {
        // 프론트가 matUid 를 React key 로 쓰므로 중복은 하나만 남긴다
        if (seen.has(lot.matUid)) return false;
        seen.add(lot.matUid);
        return true;
      });
  }

  /**
   * 솔더 페이스트 — shared sqlSolderNgCount 와 같은 대상(불출됨 ISSUE_DATE, 폐기 전 DESTROY_DATE IS NULL)에서
   * 유효기간(VALID_DATE)이 NEAR_EXPIRY_DAYS 이내이거나 지난 것. 수량 컬럼이 없어 1통 = 1 로 센다.
   */
  private async getSolderExpiry(): Promise<ExpiryCandidate[]> {
    const rows = (await this.dataSource.query(
      `SELECT NVL(s.SOLDER_LOT_NO, s.ITEM_BARCODE) AS "matUid",
              s.ITEM_CODE AS "itemCode",
              i.ITEM_NAME AS "itemName",
              TO_CHAR(s.VALID_DATE, 'YYYY-MM-DD') AS "expireDate",
              TRUNC(s.VALID_DATE) - TRUNC(SYSDATE) AS "daysLeft"
         FROM IM_ITEM_SOLDER_MASTER s
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = s.ITEM_CODE AND i.ORGANIZATION_ID = s.ORGANIZATION_ID
        WHERE s.ORGANIZATION_ID = :organizationId
          AND s.ISSUE_DATE IS NOT NULL
          AND s.DESTROY_DATE IS NULL
          AND s.VALID_DATE IS NOT NULL
          AND TRUNC(s.VALID_DATE) <= TRUNC(SYSDATE) + ${NEAR_EXPIRY_DAYS}
        ORDER BY s.VALID_DATE
        FETCH FIRST 500 ROWS ONLY`,
      namedBinds({ organizationId: ORGANIZATION_ID }),
    )) as Row[];

    return rows
      .filter((r) => r.matUid != null)
      .map((r) => {
        const daysLeft = Number(r.daysLeft ?? 0);
        return {
          matUid: String(r.matUid),
          itemCode: String(r.itemCode ?? ''),
          itemName: (r.itemName as string | null) ?? null,
          qty: 1,
          expireDate: String(r.expireDate ?? ''),
          daysLeft,
          remainHours: daysLeft * 24,
        };
      });
  }

  /**
   * MSL — shared sqlMslNgCount(d_display_msl_waring_ng_count) 판정을 그대로 따른다.
   * MSL_LEVEL >= '2A' 이고, 보정 노출시간(체크이력 경과시간 포함)이 허용시간 70% 이상인 LOT 이 후보.
   * 경과율(PASSED_TIME / MSL_MAX_TIME) 99% 초과면 기한초과(daysLeft 음수), 아니면 남은 일수.
   * (사운드 경고 상태 isys_sound_ment 는 알람 이력이라 기한 판정에서는 쓰지 않는다.)
   */
  private async getMslExpiry(): Promise<ExpiryCandidate[]> {
    const rows = (await this.dataSource.query(
      `SELECT x."matUid", x."itemCode", x."itemName", x."qty", x."remainHours", x."passedRatio",
              TO_CHAR(SYSDATE + x."remainHours" / 24, 'YYYY-MM-DD') AS "expireDate"
         FROM (
               SELECT a.LOT_NO AS "matUid",
                      a.ITEM_CODE AS "itemCode",
                      a.ITEM_NAME AS "itemName",
                      NVL(a.SCAN_QTY, 0) AS "qty",
                      a.MSL_MAX_TIME - a.PASSED_TIME AS "remainHours",
                      a.PASSED_TIME / a.MSL_MAX_TIME AS "passedRatio",
                      a.MSL_MAX_TIME AS "maxTime",
                      DECODE(a.MSL_PRE_PASSED_TIME, 0,
                        DECODE((SELECT NVL(SUM(1), 0) FROM IM_ITEM_BAKING_MASTER b
                                 WHERE b.LOT_NO = a.LOT_NO AND ROWNUM = 1), 0,
                               (SELECT ROUND((MAX(h.CHECK_DATE) - MIN(h.CHECK_DATE)) * 24)
                                  FROM IB_SMT_CHECKHIST h WHERE h.LOT_NO = a.LOT_NO) + a.PASSED_TIME,
                               a.PASSED_TIME),
                        a.PASSED_TIME) AS "effectiveTime"
                 FROM IM_ITEM_MSL_CHECK_VIEW a
                WHERE a.MSL_LEVEL >= '2A'
                  AND a.MSL_MAX_TIME > 0
              ) x
        WHERE x."effectiveTime" >= x."maxTime" * ${MSL_NEAR_RATIO}
        ORDER BY x."remainHours"
        FETCH FIRST 500 ROWS ONLY`,
      [],
    )) as Row[];

    return rows
      .filter((r) => r.matUid != null)
      .map((r) => {
        const remainHours = Number(r.remainHours ?? 0);
        const expired = Number(r.passedRatio ?? 0) > MSL_EXPIRED_RATIO;
        const days = Math.floor(remainHours / 24);
        return {
          matUid: String(r.matUid),
          itemCode: String(r.itemCode ?? ''),
          itemName: (r.itemName as string | null) ?? null,
          qty: Number(r.qty ?? 0),
          expireDate: String(r.expireDate ?? ''),
          daysLeft: expired ? Math.min(days, -1) : Math.max(days, 0),
          remainHours,
        };
      });
  }

  /**
   * 보류/불량 재고 — 재고통제관리(IM_ITEM_INVENTORY_HOLD)로 통제된 자재 LOT 중 잔량이 있는 것.
   * 통제 테이블이 작아 이쪽을 기준으로 IM_ITEM_INVENTORY 를 MATERIAL_MFS 인덱스로 붙인다.
   * 제품(PRODUCT) 보류·IQC 보류/불합격은 재고 LOT 과 연결되는 은성 데이터가 없어 만들지 않는다.
   */
  private async getHoldStocks(): Promise<{ total: number; items: HoldStock[] }> {
    const rows = (await this.dataSource.query(
      `SELECT h."ref", h."itemCode", h."itemName", h."qty", h."holdStatus",
              COUNT(*) OVER () AS "totalCount"
         FROM (
               SELECT c.MATERIAL_MFS AS "ref",
                      c.ITEM_CODE AS "itemCode",
                      MAX(i.ITEM_NAME) AS "itemName",
                      SUM(v.INVENTORY_QTY) AS "qty",
                      MAX(c.INVENTORY_STATUS) AS "holdStatus"
                 FROM IM_ITEM_INVENTORY_HOLD c
                 JOIN IM_ITEM_INVENTORY v
                   ON v.MATERIAL_MFS = c.MATERIAL_MFS
                  AND v.ITEM_CODE = c.ITEM_CODE
                  AND v.ORGANIZATION_ID = c.ORGANIZATION_ID
                 LEFT JOIN ID_ITEM i
                   ON i.ITEM_CODE = c.ITEM_CODE AND i.ORGANIZATION_ID = c.ORGANIZATION_ID
                WHERE c.ORGANIZATION_ID = :organizationId
                GROUP BY c.MATERIAL_MFS, c.ITEM_CODE
               HAVING SUM(v.INVENTORY_QTY) > 0
              ) h
        ORDER BY h."qty" DESC, h."ref"
        FETCH FIRST ${LIST_LIMIT} ROWS ONLY`,
      namedBinds({ organizationId: ORGANIZATION_ID }),
    )) as Row[];

    const items = rows.map((r) => ({
      kind: 'MATERIAL' as const,
      ref: String(r.ref),
      itemCode: String(r.itemCode),
      itemName: (r.itemName as string | null) ?? null,
      qty: Number(r.qty ?? 0),
      reason: r.holdStatus === 'B' ? 'DEFECT' : 'HOLD',
    }));
    return { total: Number(rows[0]?.totalCount ?? 0), items };
  }

  /** 금일 입출고 건수 — 입고 IM_ITEM_RECEIPT / 출고(불출) IM_ITEM_ISSUE, 수량 합계가 아닌 건수만 */
  private async getTodayInOut(): Promise<{ inCount: number; outCount: number }> {
    const rows = (await this.dataSource.query(
      `SELECT (SELECT COUNT(*) FROM IM_ITEM_RECEIPT
                WHERE ORGANIZATION_ID = :organizationId
                  AND RECEIPT_DATE >= TRUNC(SYSDATE)
                  AND RECEIPT_DATE < TRUNC(SYSDATE) + 1) AS "inCount",
              (SELECT COUNT(*) FROM IM_ITEM_ISSUE
                WHERE ORGANIZATION_ID = :organizationId
                  AND ISSUE_DATE >= TRUNC(SYSDATE)
                  AND ISSUE_DATE < TRUNC(SYSDATE) + 1) AS "outCount"
         FROM DUAL`,
      namedBinds({ organizationId: ORGANIZATION_ID }),
    )) as Row[];
    return {
      inCount: Number(rows[0]?.inCount ?? 0),
      outCount: Number(rows[0]?.outCount ?? 0),
    };
  }
}

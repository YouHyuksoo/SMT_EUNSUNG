/**
 * @file src/modules/inventory-query/fg-close.service.ts
 * @description 제품(완제품) 재고마감 — 모델 단위 월마감 (수량)
 *
 * 초보자 가이드:
 * 0. **월은 마감 기간이다.** 마감일자설정에 등록한 시작일~종료일(없으면 달력 월)의 입출고만 그 달로 센다 (close-period.ts).
 * 1. 기말 = 기초 + 입고 − 출고 + 조정. 제품에는 원가가 없어 금액은 만들지 않는다.
 *    - 입고 = 제품입고(IP_PRODUCT_FG_RECEIPT)의 정상(1) − 입고취소(2)
 *    - 출고 = 제품출고(IP_PRODUCT_FG_ISSUE)의 정상(3) − 출고취소(4)
 *    - 조정 = 제품 실사 조정(IP_PRODUCT_FG_ADJUST, 남음 +, 모자람 −)
 *    날짜는 입고일(RECEIPT_DATE)·출고일(ISSUE_DATE)·조정일(ADJUST_DATE)이다.
 * 2. 기초는 첫 마감이면 그 달 이전 수불 합계(ledger), 아니면 직전 마감월의 기말(previousClose).
 * 3. 마감은 계산 결과를 IP_PRODUCT_FG_INV_CLOSE 에 그 달 것만 갈아끼우고 IP_PRODUCT_FG_INV_CLOSE_MONTH 에
 *    마감 표시를 남긴다. 자재 마감(ISYS_INVENTORY_CLOSE_DATE)과 따로 닫는다. 한 트랜잭션.
 * 4. 순서 규칙은 자재 마감과 같다: 마감은 첫 마감이거나 마지막 마감월의 다음 달만, 그 달이 끝난 뒤에.
 *    마감 취소는 마지막 마감월만. 현재고(IP_PRODUCT_FG_INVENTORY)는 고치지 않는다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { InjectDataSource } from '@nestjs/typeorm';
import { clobBind } from '../../common/services/oracle.service';
import { namedBinds } from '../../common/utils/named-binds.util';
import { getClosePeriod, periodEnded, shiftMonth } from './close-period';

/** 마감 한 줄 (모델의 한 달) */
export interface FgCloseLine {
  modelName: string;
  modelSuffix: string;
  itemCode: string | null;
  openingQty: number;
  receiptQty: number;
  issueQty: number;
  adjustQty: number;
  endingQty: number;
}

export interface FgCloseStatus {
  yyyymm: string;
  closed: boolean;
  closedAt: string | null;
  lastClosed: string | null;
  openingSource: 'ledger' | 'previousClose' | null;
  canClose: boolean;
  canCancel: boolean;
  reason: string | null;
  /** 이 달 실사 조정이 아직 안 들어간 박스 수 (0 이 아니면 조정을 끝내고 마감하는 게 맞다) */
  pendingAdjustBoxes: number;
}

const num = (v: unknown) => Number(v ?? 0) || 0;

/** 기말 = 기초 + 입고 − 출고 + 조정 */
export const fgEnding = (l: { openingQty: number; receiptQty: number; issueQty: number; adjustQty: number }) =>
  l.openingQty + l.receiptQty - l.issueQty + l.adjustQty;

/**
 * 집계 SQL. 첫 마감(`ledger`)이면 그 달 이전 수불 전부를 기초로, 아니면 직전 마감월 기말을 기초로 쓴다.
 * 입고·출고·조정 중 하나라도 있었거나 기초가 있는 모델만 나온다.
 */
export const fgCloseAggregateSql = (ledger: boolean) => `
  SELECT m.MODEL_NAME AS "modelName", m.MODEL_SUFFIX AS "modelSuffix", MAX(m.ITEM_CODE) AS "itemCode",
         SUM(m.OPEN_Q) AS "openingQty", SUM(m.RC_Q) AS "receiptQty",
         SUM(m.IS_Q) AS "issueQty", SUM(m.AD_Q) AS "adjustQty"
    FROM (
      SELECT NVL(MODEL_NAME, '*') AS MODEL_NAME, NVL(MODEL_SUFFIX, '*') AS MODEL_SUFFIX, ITEM_CODE,
             CASE WHEN RECEIPT_DATE < TO_DATE(:startDate, 'YYYY-MM-DD')
                  THEN DECODE(TXN_DEFICIT, '1', QTY, '2', -QTY, 0) ELSE 0 END AS OPEN_Q,
             CASE WHEN RECEIPT_DATE >= TO_DATE(:startDate, 'YYYY-MM-DD')
                  THEN DECODE(TXN_DEFICIT, '1', QTY, '2', -QTY, 0) ELSE 0 END AS RC_Q,
             0 AS IS_Q, 0 AS AD_Q
        FROM IP_PRODUCT_FG_RECEIPT
       WHERE ORGANIZATION_ID = :organizationId
         AND RECEIPT_DATE < TO_DATE(:endDate, 'YYYY-MM-DD')
         ${ledger ? '' : `AND RECEIPT_DATE >= TO_DATE(:startDate, 'YYYY-MM-DD')`}
      UNION ALL
      SELECT NVL(MODEL_NAME, '*'), NVL(MODEL_SUFFIX, '*'), ITEM_CODE,
             CASE WHEN ISSUE_DATE < TO_DATE(:startDate, 'YYYY-MM-DD')
                  THEN -DECODE(TXN_DEFICIT, '3', QTY, '4', -QTY, 0) ELSE 0 END,
             0,
             CASE WHEN ISSUE_DATE >= TO_DATE(:startDate, 'YYYY-MM-DD')
                  THEN DECODE(TXN_DEFICIT, '3', QTY, '4', -QTY, 0) ELSE 0 END,
             0
        FROM IP_PRODUCT_FG_ISSUE
       WHERE ORGANIZATION_ID = :organizationId
         AND ISSUE_DATE < TO_DATE(:endDate, 'YYYY-MM-DD')
         ${ledger ? '' : `AND ISSUE_DATE >= TO_DATE(:startDate, 'YYYY-MM-DD')`}
      UNION ALL
      SELECT NVL(MODEL_NAME, '*'), NVL(MODEL_SUFFIX, '*'), ITEM_CODE,
             CASE WHEN ADJUST_DATE < TO_DATE(:startDate, 'YYYY-MM-DD') THEN ADJUST_QTY ELSE 0 END,
             0, 0,
             CASE WHEN ADJUST_DATE >= TO_DATE(:startDate, 'YYYY-MM-DD') THEN ADJUST_QTY ELSE 0 END
        FROM IP_PRODUCT_FG_ADJUST
       WHERE ORGANIZATION_ID = :organizationId
         AND ADJUST_DATE < TO_DATE(:endDate, 'YYYY-MM-DD')
         ${ledger ? '' : `AND ADJUST_DATE >= TO_DATE(:startDate, 'YYYY-MM-DD')`}
      ${ledger ? '' : `UNION ALL
      SELECT MODEL_NAME, MODEL_SUFFIX, ITEM_CODE, MM_INVENTORY_QTY, 0, 0, 0
        FROM IP_PRODUCT_FG_INV_CLOSE
       WHERE CLOSE_YYYYMM = :prevYyyymm AND ORGANIZATION_ID = :organizationId`}
    ) m
   GROUP BY m.MODEL_NAME, m.MODEL_SUFFIX
  HAVING SUM(m.OPEN_Q) <> 0 OR SUM(m.RC_Q) <> 0 OR SUM(m.IS_Q) <> 0 OR SUM(m.AD_Q) <> 0
   ORDER BY m.MODEL_NAME, m.MODEL_SUFFIX`;

@Injectable()
export class FgCloseService {
  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

  async status(yyyymm: string, organizationId: number): Promise<FgCloseStatus> {
    const [row] = await this.dataSource.query<{
      LAST_CLOSED: string | null; CLOSED_AT: string | null; PENDING: number;
    }[]>(
      `SELECT (SELECT MAX(CLOSE_YYYYMM) FROM IP_PRODUCT_FG_INV_CLOSE_MONTH
                WHERE ORGANIZATION_ID = :organizationId AND CLOSE_YN = 'Y') AS LAST_CLOSED,
              (SELECT TO_CHAR(MAX(LAST_CLOSE_DATE), 'YYYY-MM-DD HH24:MI') FROM IP_PRODUCT_FG_INV_CLOSE_MONTH
                WHERE ORGANIZATION_ID = :organizationId AND CLOSE_YN = 'Y'
                  AND CLOSE_YYYYMM = :yyyymm) AS CLOSED_AT,
              (SELECT COUNT(*) FROM IP_PRODUCT_FG_INV_CHECK c
                 LEFT JOIN (SELECT BARCODE, LOCATION_CODE, SUM(ADJUST_QTY) AS POSTED FROM IP_PRODUCT_FG_ADJUST
                             WHERE CHECK_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId
                             GROUP BY BARCODE, LOCATION_CODE) a
                   ON a.BARCODE = c.BARCODE AND a.LOCATION_CODE = c.LOCATION_CODE
                WHERE c.CHECK_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId
                  AND c.CHECK_QTY - c.INVENTORY_QTY - NVL(a.POSTED, 0) <> 0) AS PENDING
         FROM DUAL`,
      namedBinds({ organizationId, yyyymm }),
    );
    const lastClosed = row?.LAST_CLOSED ?? null;
    const closed = row?.CLOSED_AT != null;
    const period = await getClosePeriod(this.dataSource, yyyymm, organizationId);
    const monthEnded = periodEnded(period);

    let openingSource: FgCloseStatus['openingSource'] = null;
    let reason: string | null = null;
    if (closed) {
      reason = '이미 마감한 달입니다.';
    } else if (!lastClosed) {
      openingSource = 'ledger';
    } else if (yyyymm === shiftMonth(lastClosed, 1)) {
      openingSource = 'previousClose';
    } else if (yyyymm < lastClosed) {
      reason = `${lastClosed} 까지 마감돼 있습니다. 앞선 달은 다시 계산할 수 없습니다.`;
    } else {
      reason = `${shiftMonth(lastClosed, 1)} 을 먼저 마감하세요.`;
    }
    if (!reason && !monthEnded) reason = `마감 기간(${period.start} ~ ${period.end})이 끝난 뒤에 마감할 수 있습니다. (미리보기는 됩니다)`;

    return {
      yyyymm,
      closed,
      closedAt: row?.CLOSED_AT ?? null,
      lastClosed,
      openingSource,
      canClose: !reason,
      canCancel: closed && yyyymm === lastClosed,
      reason,
      pendingAdjustBoxes: num(row?.PENDING),
    };
  }

  /** 미리보기 — 계산만 하고 쓰지 않는다. 마감한 달이면 저장된 결과를 준다. */
  async preview(yyyymm: string, organizationId: number) {
    const status = await this.status(yyyymm, organizationId);
    if (status.closed) return { status, lines: await this.closedLines(yyyymm, organizationId) };
    if (!status.openingSource) throw new BadRequestException(status.reason ?? '계산할 수 없는 달입니다.');
    return { status, lines: await this.compute(yyyymm, status.openingSource, organizationId) };
  }

  async close(yyyymm: string, organizationId: number, userId: string) {
    const status = await this.status(yyyymm, organizationId);
    if (!status.canClose || !status.openingSource) {
      throw new BadRequestException(status.reason ?? '마감할 수 없는 달입니다.');
    }
    const openingSource = status.openingSource;

    return this.dataSource.transaction(async (manager) => {
      const lines = await this.compute(yyyymm, openingSource, organizationId);
      await manager.query(
        `DELETE FROM IP_PRODUCT_FG_INV_CLOSE WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId }),
      );
      if (lines.length > 0) {
        await manager.query(
          `INSERT INTO IP_PRODUCT_FG_INV_CLOSE
             (CLOSE_YYYYMM, MODEL_NAME, MODEL_SUFFIX, ORGANIZATION_ID, ITEM_CODE,
              LAST_INVENTORY_QTY, MM_RECEIPT_QTY, MM_ISSUE_QTY, MM_ADJUST_QTY, MM_INVENTORY_QTY, ENTER_DATE, ENTER_BY)
           SELECT :yyyymm, J.MN, J.MS, :organizationId, J.IC, J.OQ, J.RQ, J.IQ, J.AQ, J.EQ, SYSDATE, :userId
             FROM JSON_TABLE(:closeJson, '$[*]' COLUMNS (
                    MN VARCHAR2(100) PATH '$.modelName', MS VARCHAR2(50) PATH '$.modelSuffix',
                    IC VARCHAR2(20) PATH '$.itemCode',
                    OQ NUMBER PATH '$.openingQty', RQ NUMBER PATH '$.receiptQty', IQ NUMBER PATH '$.issueQty',
                    AQ NUMBER PATH '$.adjustQty', EQ NUMBER PATH '$.endingQty')) J`,
          namedBinds({ yyyymm, organizationId, userId, closeJson: clobBind(JSON.stringify(lines)) }),
        );
      }
      await manager.query(
        `MERGE INTO IP_PRODUCT_FG_INV_CLOSE_MONTH t
         USING (SELECT :yyyymm AS YM, :organizationId AS ORG FROM DUAL) s
            ON (t.CLOSE_YYYYMM = s.YM AND t.ORGANIZATION_ID = s.ORG)
          WHEN MATCHED THEN UPDATE
               SET t.CLOSE_YN = 'Y', t.LAST_CLOSE_DATE = SYSDATE, t.LAST_MODIFY_BY = :userId, t.LAST_MODIFY_DATE = SYSDATE
          WHEN NOT MATCHED THEN INSERT
               (CLOSE_YYYYMM, ORGANIZATION_ID, CLOSE_YN, LAST_CLOSE_DATE, ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
               VALUES (s.YM, s.ORG, 'Y', SYSDATE, SYSDATE, :userId, SYSDATE, :userId)`,
        namedBinds({ yyyymm, organizationId, userId }),
      );
      return { yyyymm, lines: lines.length, endingQty: lines.reduce((s, l) => s + l.endingQty, 0) };
    });
  }

  async cancel(yyyymm: string, organizationId: number, userId: string) {
    const status = await this.status(yyyymm, organizationId);
    if (!status.canCancel) {
      throw new BadRequestException(status.closed
        ? `마지막 마감월(${status.lastClosed})만 취소할 수 있습니다.`
        : '마감하지 않은 달입니다.');
    }
    return this.dataSource.transaction(async (manager) => {
      await manager.query(
        `DELETE FROM IP_PRODUCT_FG_INV_CLOSE WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId }),
      );
      await manager.query(
        `UPDATE IP_PRODUCT_FG_INV_CLOSE_MONTH
            SET CLOSE_YN = 'N', LAST_MODIFY_BY = :userId, LAST_MODIFY_DATE = SYSDATE
          WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId, userId }),
      );
      return { yyyymm };
    });
  }

  private async compute(
    yyyymm: string,
    openingSource: 'ledger' | 'previousClose',
    organizationId: number,
  ): Promise<FgCloseLine[]> {
    const period = await getClosePeriod(this.dataSource, yyyymm, organizationId);
    const binds: Record<string, unknown> = {
      organizationId,
      startDate: period.start,
      endDate: period.endExclusive,
    };
    if (openingSource === 'previousClose') binds.prevYyyymm = shiftMonth(yyyymm, -1);
    const rows = await this.dataSource.query<Record<string, unknown>[]>(
      fgCloseAggregateSql(openingSource === 'ledger'),
      namedBinds(binds),
    );
    return rows.map((r) => {
      const base = {
        openingQty: num(r.openingQty), receiptQty: num(r.receiptQty),
        issueQty: num(r.issueQty), adjustQty: num(r.adjustQty),
      };
      return {
        modelName: String(r.modelName),
        modelSuffix: String(r.modelSuffix),
        itemCode: (r.itemCode as string | null) ?? null,
        ...base,
        endingQty: fgEnding(base),
      };
    });
  }

  /** 마감한 달의 저장된 결과 */
  private async closedLines(yyyymm: string, organizationId: number): Promise<FgCloseLine[]> {
    const rows = await this.dataSource.query<Record<string, unknown>[]>(
      `SELECT MODEL_NAME AS "modelName", MODEL_SUFFIX AS "modelSuffix", ITEM_CODE AS "itemCode",
              LAST_INVENTORY_QTY AS "openingQty", MM_RECEIPT_QTY AS "receiptQty", MM_ISSUE_QTY AS "issueQty",
              MM_ADJUST_QTY AS "adjustQty", MM_INVENTORY_QTY AS "endingQty"
         FROM IP_PRODUCT_FG_INV_CLOSE
        WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId
        ORDER BY MODEL_NAME, MODEL_SUFFIX`,
      namedBinds({ yyyymm, organizationId }),
    );
    return rows.map((r) => ({
      modelName: String(r.modelName),
      modelSuffix: String(r.modelSuffix),
      itemCode: (r.itemCode as string | null) ?? null,
      openingQty: num(r.openingQty), receiptQty: num(r.receiptQty), issueQty: num(r.issueQty),
      adjustQty: num(r.adjustQty), endingQty: num(r.endingQty),
    }));
  }
}

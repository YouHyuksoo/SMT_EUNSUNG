/**
 * @file src/modules/inventory-query/inventory-close.service.ts
 * @description 271 자재재고마감 — 원자재 월마감 (월총평균법)
 *
 * 초보자 가이드:
 * 1. 계산(미리보기): 집계 SQL(inventory-close.sql.ts) + 단가·금액 계산(inventory-close.calc.ts).
 *    아무것도 쓰지 않는다.
 * 2. 마감: 계산 결과를 IM_ITEM_INVENTORY_CLOSE 에 그 달 것만 갈아끼우고,
 *    ISYS_INVENTORY_CLOSE_DATE 에 그 달을 마감(CLOSE_YN = 'Y')으로 남긴다. 한 트랜잭션.
 * 3. 순서 규칙 — 표준 월마감과 같다:
 *    - 마감은 첫 마감이거나 마지막 마감월의 다음 달만, 그 달이 끝난 뒤에 할 수 있다.
 *    - 마감 취소는 마지막 마감월만 할 수 있다 (다음 달 기초가 이 달 기말이기 때문).
 * 4. 현재고(IM_ITEM_INVENTORY)는 고치지 않는다. 마감은 장부를 닫는 일이다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { InjectDataSource } from '@nestjs/typeorm';
import { clobBind } from '../../common/services/oracle.service';
import { affectedRows } from '../../common/utils/affected-rows.util';
import { namedBinds } from '../../common/utils/named-binds.util';
import { closeMonth } from './inventory-close.calc';
import { closeAggregateSql } from './inventory-close.sql';

/** 마감 한 줄 (품목·창고의 한 달) */
export interface CloseLine {
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  lineType: string;
  locationCode: string;
  openingQty: number;
  openingPrice: number;
  openingAmt: number;
  receiptQty: number;
  receiptAmt: number;
  massQty: number;
  massAmt: number;
  badQty: number;
  badAmt: number;
  freeQty: number;
  freeAmt: number;
  saleQty: number;
  saleAmt: number;
  extraQty: number;
  extraAmt: number;
  /** 재고조정 (실사 차이, M009) */
  adjustQty: number;
  adjustAmt: number;
  issueQty: number;
  issueAmt: number;
  avgPrice: number;
  endingQty: number;
  endingAmt: number;
  /** 입고 중 단가표로 금액을 채운 건수 / 단가 등록이 없어 0원으로 둔 건수 (미리보기만) */
  tablePriced?: number;
  unpriced?: number;
}

export interface CloseStatus {
  yyyymm: string;
  closed: boolean;
  closedAt: string | null;
  lastClosed: string | null;
  /** 이 달 기초를 어디서 잡는가 */
  openingSource: 'ledger' | 'previousClose' | null;
  canClose: boolean;
  canCancel: boolean;
  /** 마감할 수 없는 이유 */
  reason: string | null;
}

const num = (v: unknown) => Number(v ?? 0) || 0;

/** YYYYMM ± n 개월 */
export const shiftMonth = (yyyymm: string, n: number) => {
  const d = new Date(Number(yyyymm.slice(0, 4)), Number(yyyymm.slice(4, 6)) - 1 + n, 1);
  return `${d.getFullYear()}${String(d.getMonth() + 1).padStart(2, '0')}`;
};
const firstDay = (yyyymm: string) => `${yyyymm.slice(0, 4)}-${yyyymm.slice(4, 6)}-01`;

@Injectable()
export class InventoryCloseService {
  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

  // ─────────────────────────────── 상태

  async status(yyyymm: string, organizationId: number): Promise<CloseStatus> {
    const [row] = await this.dataSource.query<{ LAST_CLOSED: string | null; CLOSED_AT: string | null }[]>(
      `SELECT (SELECT MAX(CLOSE_YYYYMM) FROM ISYS_INVENTORY_CLOSE_DATE
                WHERE ORGANIZATION_ID = :organizationId AND CLOSE_YN = 'Y') AS LAST_CLOSED,
              (SELECT TO_CHAR(MAX(LAST_CLOSE_DATE), 'YYYY-MM-DD HH24:MI') FROM ISYS_INVENTORY_CLOSE_DATE
                WHERE ORGANIZATION_ID = :organizationId AND CLOSE_YN = 'Y'
                  AND CLOSE_YYYYMM = :yyyymm) AS CLOSED_AT
         FROM DUAL`,
      namedBinds({ organizationId, yyyymm }),
    );
    const lastClosed = row?.LAST_CLOSED ?? null;
    const closed = row?.CLOSED_AT != null;
    const monthEnded = new Date() >= new Date(`${firstDay(shiftMonth(yyyymm, 1))}T00:00:00+09:00`);

    let openingSource: CloseStatus['openingSource'] = null;
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
    if (!reason && !monthEnded) reason = '그 달이 끝난 뒤에 마감할 수 있습니다. (미리보기는 됩니다)';

    return {
      yyyymm,
      closed,
      closedAt: row?.CLOSED_AT ?? null,
      lastClosed,
      openingSource,
      canClose: !reason,
      canCancel: closed && yyyymm === lastClosed,
      reason,
    };
  }

  // ─────────────────────────────── 계산 · 마감 · 취소

  /** 미리보기 — 계산만 하고 쓰지 않는다. 마감한 달이면 저장된 결과를 준다. */
  async preview(yyyymm: string, organizationId: number) {
    const status = await this.status(yyyymm, organizationId);
    if (status.closed) {
      return { status, lines: await this.closedLines(yyyymm, organizationId) };
    }
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
        `DELETE FROM IM_ITEM_INVENTORY_CLOSE WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId }),
      );
      if (lines.length > 0) {
        const json = JSON.stringify(lines.map((l) => ({
          i: l.itemCode, lt: l.lineType, loc: l.locationCode,
          lp: l.openingPrice, lq: l.openingQty, la: l.openingAmt,
          rq: l.receiptQty, ra: l.receiptAmt,
          mq: l.massQty, ma: l.massAmt, bq: l.badQty, ba: l.badAmt,
          fq: l.freeQty, fa: l.freeAmt, sq: l.saleQty, sa: l.saleAmt,
          xq: l.extraQty, xa: l.extraAmt, jq: l.adjustQty, ja: l.adjustAmt, iq: l.issueQty, ia: l.issueAmt,
          ap: l.avgPrice, eq: l.endingQty, ea: l.endingAmt,
        })));
        await manager.query(
          `INSERT INTO IM_ITEM_INVENTORY_CLOSE
             (CLOSE_YYYYMM, ITEM_CODE, LINE_TYPE, LOCATION_CODE, ORGANIZATION_ID,
              LAST_AVG_PRICE, LAST_INVENTORY_QTY, LAST_INVENTORY_AMT,
              MM_RECEIPT_QTY, MM_RECEIPT_AMT, MM_MATERIAL_COST_AMT,
              MM_MASS_QTY, MM_MASS_AMT, MM_BAD_QTY, MM_BAD_AMT,
              MM_FREE_QTY, MM_FREE_AMT, MM_SALE_QTY, MM_SALE_AMT,
              MM_EXTRA_QTY, MM_EXTRA_AMT, MM_ADJUST_QTY, MM_ADJUST_AMT, MM_SHIPPING_QTY, MM_SHIPPING_AMT,
              MM_ISSUE_QTY, MM_ISSUE_AMT, MM_LOGICAL_ISSUE_QTY,
              MM_AVG_PRICE, MM_INVENTORY_QTY, MM_INVENTORY_AMT,
              ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
           SELECT :yyyymm, J.I, J.LT, J.LOC, :organizationId,
                  J.LP, J.LQ, J.LA,
                  J.RQ, J.RA, 0,
                  J.MQ, J.MA, J.BQ, J.BA,
                  J.FQ, J.FA, J.SQ, J.SA,
                  J.XQ, J.XA, J.JQ, J.JA, 0, 0,
                  J.IQ, J.IA, 0,
                  J.AP, J.EQ, J.EA,
                  :userId, SYSDATE, :userId, SYSDATE
             FROM JSON_TABLE(:closeJson, '$[*]' COLUMNS (
                    I   VARCHAR2(20) PATH '$.i',
                    LT  VARCHAR2(10) PATH '$.lt',
                    LOC VARCHAR2(20) PATH '$.loc',
                    LP NUMBER PATH '$.lp', LQ NUMBER PATH '$.lq', LA NUMBER PATH '$.la',
                    RQ NUMBER PATH '$.rq', RA NUMBER PATH '$.ra',
                    MQ NUMBER PATH '$.mq', MA NUMBER PATH '$.ma',
                    BQ NUMBER PATH '$.bq', BA NUMBER PATH '$.ba',
                    FQ NUMBER PATH '$.fq', FA NUMBER PATH '$.fa',
                    SQ NUMBER PATH '$.sq', SA NUMBER PATH '$.sa',
                    XQ NUMBER PATH '$.xq', XA NUMBER PATH '$.xa',
                    JQ NUMBER PATH '$.jq', JA NUMBER PATH '$.ja',
                    IQ NUMBER PATH '$.iq', IA NUMBER PATH '$.ia',
                    AP NUMBER PATH '$.ap', EQ NUMBER PATH '$.eq', EA NUMBER PATH '$.ea')) J`,
          namedBinds({ yyyymm, organizationId, userId, closeJson: clobBind(json) }),
        );
      }

      // 마감월 표시. 그 달 행이 없으면 달력월 기간으로 만든다 (F_GET_INVENTORY_CLOSE_DATE 와 같은 경계).
      const updated = await manager.query(
        `UPDATE ISYS_INVENTORY_CLOSE_DATE
            SET CLOSE_YN = 'Y', LAST_CLOSE_DATE = SYSDATE, LAST_MODIFY_BY = :userId, LAST_MODIFY_DATE = SYSDATE
          WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId, userId }),
      );
      if (!affectedRows(updated)) {
        await manager.query(
          `INSERT INTO ISYS_INVENTORY_CLOSE_DATE
             (CLOSE_YYYYMM, ORGANIZATION_ID, START_DATE, END_DATE, CLOSE_YN, LAST_CLOSE_DATE,
              ENTER_DATE, ENTER_BY, LAST_MODIFY_DATE, LAST_MODIFY_BY)
           VALUES (:yyyymm, :organizationId, TO_DATE(:yyyymm || '01', 'YYYYMMDD'),
                   ADD_MONTHS(TO_DATE(:yyyymm || '01', 'YYYYMMDD'), 1) - 1 / 86400, 'Y', SYSDATE,
                   SYSDATE, :userId, SYSDATE, :userId)`,
          namedBinds({ yyyymm, organizationId, userId }),
        );
      }
      return { yyyymm, lines: lines.length, endingAmt: lines.reduce((s, l) => s + l.endingAmt, 0) };
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
        `DELETE FROM IM_ITEM_INVENTORY_CLOSE WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId }),
      );
      await manager.query(
        `UPDATE ISYS_INVENTORY_CLOSE_DATE
            SET CLOSE_YN = 'N', LAST_MODIFY_BY = :userId, LAST_MODIFY_DATE = SYSDATE
          WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId, userId }),
      );
      return { yyyymm };
    });
  }

  // ─────────────────────────────── 보조

  private async compute(
    yyyymm: string,
    openingSource: 'ledger' | 'previousClose',
    organizationId: number,
  ): Promise<CloseLine[]> {
    const binds: Record<string, unknown> = {
      organizationId,
      startDate: firstDay(yyyymm),
      endDate: firstDay(shiftMonth(yyyymm, 1)),
    };
    if (openingSource === 'previousClose') binds.prevYyyymm = shiftMonth(yyyymm, -1);
    const rows = await this.dataSource.query<Record<string, unknown>[]>(
      closeAggregateSql(openingSource === 'ledger'),
      namedBinds(binds),
    );
    return rows.map((r) => {
      const c = closeMonth({
        openingQty: num(r.openingQty),
        openingAmt: num(r.openingAmt),
        openingPrice: num(r.openingPrice),
        receiptQty: num(r.receiptQty),
        receiptAmt: num(r.receiptAmt),
        massQty: num(r.massQty),
        badQty: num(r.badQty),
        freeQty: num(r.freeQty),
        saleQty: num(r.saleQty),
        extraQty: num(r.extraQty),
        adjustQty: num(r.adjustQty),
      });
      return {
        itemCode: String(r.itemCode),
        itemName: (r.itemName as string | null) ?? null,
        itemSpec: (r.itemSpec as string | null) ?? null,
        itemUom: (r.itemUom as string | null) ?? null,
        lineType: String(r.lineType),
        locationCode: String(r.locationCode),
        openingQty: num(r.openingQty),
        openingPrice: num(r.openingPrice),
        openingAmt: num(r.openingAmt),
        receiptQty: num(r.receiptQty),
        receiptAmt: num(r.receiptAmt),
        massQty: num(r.massQty),
        badQty: num(r.badQty),
        freeQty: num(r.freeQty),
        saleQty: num(r.saleQty),
        extraQty: num(r.extraQty),
        adjustQty: num(r.adjustQty),
        ...c,
        tablePriced: num(r.tablePriced),
        unpriced: num(r.unpriced),
      };
    });
  }

  /** 마감한 달의 저장된 결과 */
  private async closedLines(yyyymm: string, organizationId: number): Promise<CloseLine[]> {
    const rows = await this.dataSource.query<Record<string, unknown>[]>(
      `SELECT C.ITEM_CODE AS "itemCode", I.ITEM_NAME AS "itemName", I.ITEM_SPEC AS "itemSpec",
              I.ITEM_UOM AS "itemUom", C.LINE_TYPE AS "lineType", C.LOCATION_CODE AS "locationCode",
              C.LAST_INVENTORY_QTY AS "openingQty", C.LAST_AVG_PRICE AS "openingPrice",
              C.LAST_INVENTORY_AMT AS "openingAmt",
              C.MM_RECEIPT_QTY AS "receiptQty", C.MM_RECEIPT_AMT AS "receiptAmt",
              C.MM_MASS_QTY AS "massQty", C.MM_MASS_AMT AS "massAmt",
              C.MM_BAD_QTY AS "badQty", C.MM_BAD_AMT AS "badAmt",
              C.MM_FREE_QTY AS "freeQty", C.MM_FREE_AMT AS "freeAmt",
              C.MM_SALE_QTY AS "saleQty", C.MM_SALE_AMT AS "saleAmt",
              C.MM_EXTRA_QTY AS "extraQty", C.MM_EXTRA_AMT AS "extraAmt",
              NVL(C.MM_ADJUST_QTY, 0) AS "adjustQty", NVL(C.MM_ADJUST_AMT, 0) AS "adjustAmt",
              C.MM_ISSUE_QTY AS "issueQty", C.MM_ISSUE_AMT AS "issueAmt",
              C.MM_AVG_PRICE AS "avgPrice",
              C.MM_INVENTORY_QTY AS "endingQty", C.MM_INVENTORY_AMT AS "endingAmt"
         FROM IM_ITEM_INVENTORY_CLOSE C
         LEFT JOIN (SELECT ITEM_CODE, MAX(ITEM_NAME) AS ITEM_NAME, MAX(ITEM_SPEC) AS ITEM_SPEC,
                           MAX(ITEM_UOM) AS ITEM_UOM
                      FROM ID_ITEM WHERE ORGANIZATION_ID = :organizationId GROUP BY ITEM_CODE) I
           ON I.ITEM_CODE = C.ITEM_CODE
        WHERE C.CLOSE_YYYYMM = :yyyymm AND C.ORGANIZATION_ID = :organizationId
        ORDER BY C.ITEM_CODE, C.LOCATION_CODE`,
      namedBinds({ yyyymm, organizationId }),
    );
    return rows.map((r) => ({
        itemCode: String(r.itemCode),
        itemName: (r.itemName as string | null) ?? null,
        itemSpec: (r.itemSpec as string | null) ?? null,
        itemUom: (r.itemUom as string | null) ?? null,
        lineType: String(r.lineType),
        locationCode: String(r.locationCode),
        openingQty: num(r.openingQty), openingPrice: num(r.openingPrice), openingAmt: num(r.openingAmt),
        receiptQty: num(r.receiptQty), receiptAmt: num(r.receiptAmt),
        massQty: num(r.massQty), massAmt: num(r.massAmt), badQty: num(r.badQty), badAmt: num(r.badAmt),
        freeQty: num(r.freeQty), freeAmt: num(r.freeAmt), saleQty: num(r.saleQty), saleAmt: num(r.saleAmt),
        extraQty: num(r.extraQty), extraAmt: num(r.extraAmt),
        adjustQty: num(r.adjustQty), adjustAmt: num(r.adjustAmt),
        issueQty: num(r.issueQty), issueAmt: num(r.issueAmt), avgPrice: num(r.avgPrice),
        endingQty: num(r.endingQty), endingAmt: num(r.endingAmt),
      }));
  }
}

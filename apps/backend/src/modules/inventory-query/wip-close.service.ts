/**
 * @file src/modules/inventory-query/wip-close.service.ts
 * @description 공정(라인)재고 마감 — 품목 단위 월마감
 * PB 원본: PBL Library 10.5/f_mat_workstage_inventory_close_new.srf
 *
 * 초보자 가이드:
 * 0. **월은 마감 기간이다.** 마감일자설정에 등록한 시작일~종료일(없으면 달력 월)의 입출고만 그 달로 센다 (close-period.ts).
 * 1. 기말 = 기초 + 입고 − 출고. 공정입고(IM_ITEM_WORKSTAGE_RECEIPT)·공정출고(IM_ITEM_WORKSTAGE_ISSUE)는
 *    품목 단위이고 수량이 부호를 가진다 (입고취소는 음수). 그래서 수량을 그냥 더한다.
 *    공정간 이동(ENTER_BY = 'WS_MOVE', 출고·입고 한 쌍)은 품목 합계로 0 이라 입고·출고 칸에서 뺀다.
 *    출고에 공정실사 조정(LAST_MODIFY_BY = 'INV ADJUST')이 들어 있으면 출고 합계에는 포함하고
 *    조정 칸에도 따로 보인다 (자재 마감의 조정 칸과 같다). 모자람 +, 남음 −.
 * 2. **기초**: 직전 달을 마감했으면 그 달 기말. 첫 마감이면 **전월 말 공정재고를 0 으로 본다.**
 *    다만 그 달 입고보다 소비가 많은 품목은 모자란 만큼을 기초로 둔다 (전월에 라인에 나간 자재를 쓴 몫).
 *    현재 공정재고 장부는 쓰지 않는다 — 2026-10-11 까지 소비를 인팩 사급 자재만 빼서 장부에
 *    11.8억 개가 쌓였다 (2026-10-16 실측, 사용자 결정 "8월말 공정기초 0 으로 9월부터 쌓기").
 * 3. **단가**: 그 달 원자재 마감(IM_ITEM_INVENTORY_CLOSE)의 월평균단가를 쓴다 (PB 와 같은 출처).
 *    그 달 단가가 없으면 직전 달 공정 마감 단가, 그것도 없으면 0 원이다. 금액 = 수량 × 단가.
 *    그래서 **원자재 마감을 먼저 해야** 마감할 수 있다 (PB 도 먼저 확인한다).
 * 4. 마감은 그 달 결과를 IM_ITEM_WORKSTAGE_INV_CLOSE 에 갈아끼운다. 마감 여부는 그 달 행이 있는지로 본다.
 *    순서 규칙은 자재 마감과 같다: 첫 마감이거나 마지막 마감월의 다음 달만, 그 달이 끝난 뒤에.
 *    취소는 마지막 마감월만. 현재 공정재고(IM_ITEM_WORKSTAGE_INVENTORY)는 고치지 않는다.
 * 5. 마감한 달은 공정실사가 시작·입력·조정을 거절한다 (`assertWipMonthOpen`).
 * 6. **생산투입을 다 넣고 마감한다.** 생산투입(공정출고)은 DB 잡(P_WIP_ISSUE_CREATE, 06:10·17:10)이
 *    제품 입고·입고취소로 만든다 (wip-bom.ts). 마감은 먼저 그 프로시저를 돌려 남은 박스를 반영한 뒤 계산한다.
 *    마감 뒤에는 마감 잠금 트리거가 그 기간 원장을 막고, 늦게 처리된 박스는 잡이 다음 기간 첫날로 넣는다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource, QueryRunner } from 'typeorm';
import { InjectDataSource } from '@nestjs/typeorm';
import { clobBind } from '../../common/services/oracle.service';
import { namedBinds } from '../../common/utils/named-binds.util';
import { firstCloseGate, getCloseStartMonth, getClosePeriod, periodBoundsSql, periodEnded, shiftMonth } from './close-period';
import { catchUpWipIssue, notWipMoveSql, wipMovedSql, wipPendingPackWhere } from './wip-bom';

/** 공정실사 조정 출고를 찾는 표시 (wip-stocktake.service.ts 의 WIP_ADJUST_MARK 와 같다) */
const ADJUST_MARK = 'INV ADJUST';

/** 마감 한 줄 (품목의 한 달) */
export interface WipCloseLine {
  itemCode: string;
  itemName: string | null;
  itemSpec: string | null;
  itemUom: string | null;
  lineType: string;
  openingQty: number;
  openingAmt: number;
  receiptQty: number;
  receiptAmt: number;
  issueQty: number;
  issueAmt: number;
  /** 재고조정 (공정실사 차이) — 출고에 포함돼 있다 */
  adjustQty: number;
  adjustAmt: number;
  endingQty: number;
  endingAmt: number;
  avgPrice: number;
}

export interface WipCloseStatus {
  yyyymm: string;
  closed: boolean;
  lastClosed: string | null;
  openingSource: 'inventory' | 'previousClose' | null;
  /** 이 달 원자재 마감이 돼 있는가 (단가 출처) */
  materialClosed: boolean;
  canClose: boolean;
  canCancel: boolean;
  reason: string | null;
  /** 이 달 공정실사 조정이 아직 안 들어간 품목 수 (0 이 아니면 조정을 끝내고 마감하는 게 맞다) */
  pendingAdjustItems: number;
  /** 생산투입 잡이 아직 처리하지 않은 박스 수 (마감할 때 먼저 반영한다) */
  pendingPacks: number;
}

const num = (v: unknown) => Number(v ?? 0) || 0;

/** 그 달 공정 마감이 돼 있으면 공정실사를 건드릴 수 없다. */
export async function assertWipMonthOpen(qr: QueryRunner, yyyymm: string, organizationId: number) {
  const rows = (await qr.query(
    `SELECT COUNT(*) AS "n" FROM IM_ITEM_WORKSTAGE_INV_CLOSE
      WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
    namedBinds({ yyyymm, organizationId }),
  )) as { n: number }[];
  if (num(rows[0]?.n)) throw new BadRequestException(`${yyyymm} 은 이미 공정 재고마감을 한 달입니다.`);
}

/**
 * 입고·출고·조정 집계. 한 줄 = 품목.
 * `previousClose` 면 직전 달 마감 기말도 함께 읽는다. 첫 마감의 기초는 wipCloseLine 이 정한다.
 */
export const wipCloseAggregateSql = (previousClose: boolean) => `
  SELECT m.ITEM_CODE AS "itemCode",
         SUM(m.RC_Q) AS "receiptQty", SUM(m.IS_Q) AS "issueQty", SUM(m.AD_Q) AS "adjustQty",
         SUM(m.PREV_Q) AS "prevQty", SUM(m.PREV_A) AS "prevAmt"
    FROM (
      SELECT ITEM_CODE, SUM(RECEIPT_QTY) AS RC_Q, 0 AS IS_Q, 0 AS AD_Q, 0 AS PREV_Q, 0 AS PREV_A
        FROM IM_ITEM_WORKSTAGE_RECEIPT
       WHERE ORGANIZATION_ID = :organizationId AND RECEIPT_DATE >= TO_DATE(:startDate, 'YYYY-MM-DD')
         AND RECEIPT_DATE < TO_DATE(:endDate, 'YYYY-MM-DD') AND ${notWipMoveSql('ENTER_BY')}
       GROUP BY ITEM_CODE
      UNION ALL
      SELECT ITEM_CODE, 0, SUM(ISSUE_QTY),
             SUM(CASE WHEN LAST_MODIFY_BY = '${ADJUST_MARK}' THEN ISSUE_QTY ELSE 0 END), 0, 0
        FROM IM_ITEM_WORKSTAGE_ISSUE
       WHERE ORGANIZATION_ID = :organizationId AND ISSUE_DATE >= TO_DATE(:startDate, 'YYYY-MM-DD')
         AND ISSUE_DATE < TO_DATE(:endDate, 'YYYY-MM-DD') AND ${notWipMoveSql('ENTER_BY')}
       GROUP BY ITEM_CODE
      ${previousClose ? `UNION ALL
      SELECT ITEM_CODE, 0, 0, 0, SUM(MM_INVENTORY_QTY), SUM(MM_INVENTORY_AMT)
        FROM IM_ITEM_WORKSTAGE_INV_CLOSE
       WHERE CLOSE_YYYYMM = :prevYyyymm AND ORGANIZATION_ID = :organizationId
       GROUP BY ITEM_CODE` : ''}
    ) m
   GROUP BY m.ITEM_CODE`;

/** 집계 한 줄 + 단가로 마감 한 줄을 만든다. 단가가 없으면 0 원. */
export function wipCloseLine(
  r: Record<string, unknown>,
  previousClose: boolean,
  price: number,
  info: { itemName: string | null; itemSpec: string | null; itemUom: string | null; lineType: string | null },
): WipCloseLine {
  const receiptQty = num(r.receiptQty);
  const issueQty = num(r.issueQty);
  const adjustQty = num(r.adjustQty);
  // 첫 마감: 전월 말 0. 그 달 입고보다 소비가 많으면 모자란 만큼만 기초로 둔다.
  const openingQty = previousClose
    ? num(r.prevQty)
    : Math.max(0, issueQty - receiptQty);
  const endingQty = openingQty + receiptQty - issueQty;
  const openingAmt = previousClose ? num(r.prevAmt) : openingQty * price;
  return {
    itemCode: String(r.itemCode),
    ...info,
    lineType: info.lineType ?? '*',
    openingQty,
    openingAmt,
    receiptQty,
    receiptAmt: receiptQty * price,
    issueQty,
    issueAmt: issueQty * price,
    adjustQty,
    adjustAmt: adjustQty * price,
    endingQty,
    endingAmt: endingQty * price,
    avgPrice: price,
  };
}

@Injectable()
export class WipCloseService {
  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

  async status(yyyymm: string, organizationId: number): Promise<WipCloseStatus> {
    const [row] = await this.dataSource.query<{
      LAST_CLOSED: string | null; THIS_N: number; MAT_N: number; PENDING: number; PACKS: number;
    }[]>(
      `SELECT (SELECT MAX(CLOSE_YYYYMM) FROM IM_ITEM_WORKSTAGE_INV_CLOSE WHERE ORGANIZATION_ID = :organizationId) AS LAST_CLOSED,
              (SELECT COUNT(*) FROM IM_ITEM_WORKSTAGE_INV_CLOSE
                WHERE ORGANIZATION_ID = :organizationId AND CLOSE_YYYYMM = :yyyymm) AS THIS_N,
              (SELECT COUNT(*) FROM IM_ITEM_INVENTORY_CLOSE
                WHERE ORGANIZATION_ID = :organizationId AND CLOSE_YYYYMM = :yyyymm) AS MAT_N,
              (SELECT COUNT(*) FROM IM_ITEM_WORKSTAGE_INV_CHECK c
                 LEFT JOIN (SELECT ITEM_CODE, SUM(ISSUE_QTY) AS POSTED FROM IM_ITEM_WORKSTAGE_ISSUE
                             WHERE ORGANIZATION_ID = :organizationId AND LAST_MODIFY_BY = '${ADJUST_MARK}'
                               AND ${periodBoundsSql('ISSUE_DATE', ':yyyymm', ':organizationId')}
                             GROUP BY ITEM_CODE) a ON a.ITEM_CODE = c.ITEM_CODE
                 LEFT JOIN ${wipMovedSql} mv ON mv.ITEM_CODE = c.ITEM_CODE
                WHERE c.CLOSE_YYYYMM = :yyyymm AND c.ORGANIZATION_ID = :organizationId
                  AND c.MFS = '*' AND c.LINE_CODE = '*'
                  AND NVL(c.INVENTORY_QTY, 0) - NVL(mv.QTY, 0) - NVL(c.CHECK_INVENTORY_QTY, 0) - NVL(a.POSTED, 0) <> 0) AS PENDING,
              (SELECT COUNT(*) FROM IP_PRODUCT_PACK_MASTER p
                WHERE p.ORGANIZATION_ID = :organizationId AND ${wipPendingPackWhere('p')}) AS PACKS
         FROM DUAL`,
      namedBinds({ organizationId, yyyymm }),
    );
    const lastClosed = row?.LAST_CLOSED ?? null;
    const closed = num(row?.THIS_N) > 0;
    const materialClosed = num(row?.MAT_N) > 0;
    const period = await getClosePeriod(this.dataSource, yyyymm, organizationId);
    const monthEnded = periodEnded(period);

    const gate = firstCloseGate(yyyymm, await getCloseStartMonth(this.dataSource, organizationId), lastClosed);

    let openingSource: WipCloseStatus['openingSource'] = null;
    let reason: string | null = null;
    if (closed) {
      reason = '이미 마감한 달입니다.';
    } else if (gate.reason) {
      reason = gate.reason;
    } else if (gate.first) {
      openingSource = 'inventory';
    } else if (yyyymm === shiftMonth(lastClosed as string, 1)) {
      openingSource = 'previousClose';
    } else if (yyyymm < lastClosed) {
      reason = `${lastClosed} 까지 마감돼 있습니다. 앞선 달은 다시 계산할 수 없습니다.`;
    } else {
      reason = `${shiftMonth(lastClosed, 1)} 을 먼저 마감하세요.`;
    }
    if (!reason && !materialClosed) reason = '원자재 재고마감을 먼저 하세요. (단가를 원자재 마감에서 가져옵니다)';
    if (!reason && !monthEnded) reason = `마감 기간(${period.start} ~ ${period.end})이 끝난 뒤에 마감할 수 있습니다. (미리보기는 됩니다)`;

    return {
      yyyymm, closed, lastClosed, openingSource, materialClosed,
      canClose: !reason,
      canCancel: closed && yyyymm === lastClosed,
      reason,
      pendingAdjustItems: num(row?.PENDING),
      pendingPacks: num(row?.PACKS),
    };
  }

  /** 미리보기 — 계산만 하고 쓰지 않는다. 마감한 달이면 저장된 결과를 준다. */
  async preview(yyyymm: string, organizationId: number) {
    const status = await this.status(yyyymm, organizationId);
    if (status.closed) return { status, lines: await this.closedLines(yyyymm, organizationId) };
    if (!status.openingSource) throw new BadRequestException(status.reason ?? '계산할 수 없는 달입니다.');
    const lines = await this.compute(yyyymm, status.openingSource, organizationId);
    return { status, lines, unpriced: lines.filter((l) => l.avgPrice === 0 && l.endingQty !== 0).length };
  }

  async close(yyyymm: string, organizationId: number, userId: string) {
    // 입고·입고취소 중 아직 생산투입에 안 들어간 박스를 먼저 반영한다 (따로 커밋 — 마감이 실패해도 맞는 일이다).
    await this.dataSource.transaction((manager) => catchUpWipIssue(manager, organizationId));
    const status = await this.status(yyyymm, organizationId);
    if (!status.canClose || !status.openingSource) {
      throw new BadRequestException(status.reason ?? '마감할 수 없는 달입니다.');
    }
    const openingSource = status.openingSource;
    return this.dataSource.transaction(async (manager) => {
      const lines = await this.compute(yyyymm, openingSource, organizationId);
      await manager.query(
        `DELETE FROM IM_ITEM_WORKSTAGE_INV_CLOSE WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
        namedBinds({ yyyymm, organizationId }),
      );
      if (lines.length > 0) {
        await manager.query(
          `INSERT INTO IM_ITEM_WORKSTAGE_INV_CLOSE
             (CLOSE_YYYYMM, LINE_CODE, WORKSTAGE_CODE, MFS, MATERIAL_MFS, ITEM_CODE, LINE_TYPE, ORGANIZATION_ID,
              LAST_AVG_PRICE, LAST_INVENTORY_QTY, LAST_INVENTORY_AMT,
              MM_RECEIPT_QTY, MM_RECEIPT_AMT, MM_ISSUE_QTY, MM_ISSUE_AMT,
              MM_MASS_ISSUE_QTY, MM_MASS_ISSUE_AMT, MM_BAD_ISSUE_QTY, MM_BAD_ISSUE_AMT,
              MM_EXTRA_ISSUE_QTY, MM_EXTRA_ISSUE_AMT, MM_ADJUST_QTY, MM_ADJUST_AMT,
              MM_INVENTORY_QTY, MM_INVENTORY_AMT, MM_AVG_PRICE,
              ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE)
           SELECT :yyyymm, '*', '*', '*', '*', J.I, J.LT, :organizationId,
                  J.AP, J.OQ, J.OA,
                  J.RQ, J.RA, J.IQ, J.IA,
                  0, 0, 0, 0, 0, 0, J.JQ, J.JA,
                  J.EQ, J.EA, J.AP,
                  :userId, SYSDATE, :userId, SYSDATE
             FROM JSON_TABLE(:closeJson, '$[*]' COLUMNS (
                    I VARCHAR2(20) PATH '$.itemCode', LT VARCHAR2(10) PATH '$.lineType',
                    AP NUMBER PATH '$.avgPrice', OQ NUMBER PATH '$.openingQty', OA NUMBER PATH '$.openingAmt',
                    RQ NUMBER PATH '$.receiptQty', RA NUMBER PATH '$.receiptAmt',
                    IQ NUMBER PATH '$.issueQty', IA NUMBER PATH '$.issueAmt',
                    JQ NUMBER PATH '$.adjustQty', JA NUMBER PATH '$.adjustAmt',
                    EQ NUMBER PATH '$.endingQty', EA NUMBER PATH '$.endingAmt')) J`,
          namedBinds({ yyyymm, organizationId, userId, closeJson: clobBind(JSON.stringify(lines)) }),
        );
      }
      return {
        yyyymm, lines: lines.length,
        endingQty: lines.reduce((s, l) => s + l.endingQty, 0),
        endingAmt: lines.reduce((s, l) => s + l.endingAmt, 0),
      };
    });
  }

  async cancel(yyyymm: string, organizationId: number) {
    const status = await this.status(yyyymm, organizationId);
    if (!status.canCancel) {
      throw new BadRequestException(status.closed
        ? `마지막 마감월(${status.lastClosed})만 취소할 수 있습니다.`
        : '마감하지 않은 달입니다.');
    }
    await this.dataSource.query(
      `DELETE FROM IM_ITEM_WORKSTAGE_INV_CLOSE WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId`,
      namedBinds({ yyyymm, organizationId }),
    );
    return { yyyymm };
  }

  private async compute(
    yyyymm: string,
    openingSource: 'inventory' | 'previousClose',
    organizationId: number,
  ): Promise<WipCloseLine[]> {
    const previousClose = openingSource === 'previousClose';
    const period = await getClosePeriod(this.dataSource, yyyymm, organizationId);
    const binds: Record<string, unknown> = {
      organizationId,
      startDate: period.start,
      endDate: period.endExclusive,
    };
    if (previousClose) binds.prevYyyymm = shiftMonth(yyyymm, -1);
    const [rows, matPrices, prevPrices, items] = await Promise.all([
      this.dataSource.query<Record<string, unknown>[]>(wipCloseAggregateSql(previousClose), namedBinds(binds)),
      this.dataSource.query<{ ITEM_CODE: string; P: number }[]>(
        `SELECT ITEM_CODE, MAX(MM_AVG_PRICE) AS P FROM IM_ITEM_INVENTORY_CLOSE
          WHERE CLOSE_YYYYMM = :yyyymm AND ORGANIZATION_ID = :organizationId GROUP BY ITEM_CODE`,
        namedBinds({ yyyymm, organizationId }),
      ),
      this.dataSource.query<{ ITEM_CODE: string; P: number }[]>(
        `SELECT ITEM_CODE, MAX(MM_AVG_PRICE) AS P FROM IM_ITEM_WORKSTAGE_INV_CLOSE
          WHERE CLOSE_YYYYMM = :prevYyyymm AND ORGANIZATION_ID = :organizationId GROUP BY ITEM_CODE`,
        namedBinds({ prevYyyymm: shiftMonth(yyyymm, -1), organizationId }),
      ),
      this.dataSource.query<Record<string, unknown>[]>(
        `SELECT ITEM_CODE AS "itemCode", ITEM_NAME AS "itemName", ITEM_SPEC AS "itemSpec", ITEM_UOM AS "itemUom",
                LINE_TYPE AS "lineType"
           FROM ID_ITEM WHERE ORGANIZATION_ID = :organizationId`,
        namedBinds({ organizationId }),
      ),
    ]);
    const mat = new Map(matPrices.map((p) => [p.ITEM_CODE, num(p.P)]));
    const prev = new Map(prevPrices.map((p) => [p.ITEM_CODE, num(p.P)]));
    const info = new Map(items.map((i) => [String(i.itemCode), i]));
    return rows
      .map((r) => {
        const code = String(r.itemCode);
        const it = info.get(code);
        const price = mat.get(code) || prev.get(code) || 0;
        return wipCloseLine(r, previousClose, price, {
          itemName: (it?.itemName as string | null) ?? null,
          itemSpec: (it?.itemSpec as string | null) ?? null,
          itemUom: (it?.itemUom as string | null) ?? null,
          lineType: (it?.lineType as string | null) ?? null,
        });
      })
      .filter((l) => l.openingQty !== 0 || l.receiptQty !== 0 || l.issueQty !== 0 || l.endingQty !== 0)
      .sort((a, b) => a.itemCode.localeCompare(b.itemCode));
  }

  /** 마감한 달의 저장된 결과 */
  private async closedLines(yyyymm: string, organizationId: number): Promise<WipCloseLine[]> {
    const rows = await this.dataSource.query<Record<string, unknown>[]>(
      `SELECT C.ITEM_CODE AS "itemCode", I.ITEM_NAME AS "itemName", I.ITEM_SPEC AS "itemSpec", I.ITEM_UOM AS "itemUom",
              C.LINE_TYPE AS "lineType",
              C.LAST_INVENTORY_QTY AS "openingQty", C.LAST_INVENTORY_AMT AS "openingAmt",
              C.MM_RECEIPT_QTY AS "receiptQty", C.MM_RECEIPT_AMT AS "receiptAmt",
              C.MM_ISSUE_QTY AS "issueQty", C.MM_ISSUE_AMT AS "issueAmt",
              NVL(C.MM_ADJUST_QTY, 0) AS "adjustQty", NVL(C.MM_ADJUST_AMT, 0) AS "adjustAmt",
              C.MM_INVENTORY_QTY AS "endingQty", C.MM_INVENTORY_AMT AS "endingAmt", C.MM_AVG_PRICE AS "avgPrice"
         FROM IM_ITEM_WORKSTAGE_INV_CLOSE C
         LEFT JOIN ID_ITEM I ON I.ITEM_CODE = C.ITEM_CODE AND I.ORGANIZATION_ID = C.ORGANIZATION_ID
        WHERE C.CLOSE_YYYYMM = :yyyymm AND C.ORGANIZATION_ID = :organizationId
        ORDER BY C.ITEM_CODE`,
      namedBinds({ yyyymm, organizationId }),
    );
    return rows.map((r) => ({
      itemCode: String(r.itemCode),
      itemName: (r.itemName as string | null) ?? null,
      itemSpec: (r.itemSpec as string | null) ?? null,
      itemUom: (r.itemUom as string | null) ?? null,
      lineType: String(r.lineType),
      openingQty: num(r.openingQty), openingAmt: num(r.openingAmt),
      receiptQty: num(r.receiptQty), receiptAmt: num(r.receiptAmt),
      issueQty: num(r.issueQty), issueAmt: num(r.issueAmt),
      adjustQty: num(r.adjustQty), adjustAmt: num(r.adjustAmt),
      endingQty: num(r.endingQty), endingAmt: num(r.endingAmt), avgPrice: num(r.avgPrice),
    }));
  }
}

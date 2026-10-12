/**
 * @file src/modules/process-transaction/wip-ledger.service.ts
 * @description 공정 입출고 내역 — 공정(라인)재고가 언제 무엇으로 늘고 줄었는지 보여준다 (읽기 전용)
 *
 * 초보자 가이드:
 * 1. **공정재고는 품목 단위다.** 자재를 라인으로 출고하면 공정입고(IM_ITEM_WORKSTAGE_RECEIPT)가,
 *    생산 실적으로 자재가 소모되면 공정출고(IM_ITEM_WORKSTAGE_ISSUE)가 쌓인다. 수량은 부호를 가진다
 *    (입고취소·출고반품은 음수).
 * 2. **구분**: R 입고 · I 생산투입 · A 실사조정. 실사조정은 공정재고실사 일괄 조정이 넣은 출고로,
 *    LAST_MODIFY_BY = 'INV ADJUST' 로 구별한다 (wip-stocktake.service.ts 의 WIP_ADJUST_MARK).
 * 3. **생산투입의 LAST_MODIFY_BY 는 생산한 제품의 품목코드다.** 그래서 어느 제품을 만들며 썼는지 보여 준다.
 * 4. **공정재고 증감** = 입고 수량 − 출고 수량. 품목별 합계의 순증감도 같은 식이다.
 * 5. 출고 원장은 한 달에 30만 건이 넘는다. 날짜(PK 첫 컬럼)로 반드시 좁히고, 건별 내역은
 *    품목을 안 주면 7일까지만 받는다. 품목별 합계는 1년까지.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { namedBinds } from '../../common/utils/named-binds.util';
import { WIP_ADJUST_MARK } from '../inventory-query/wip-stocktake.service';
import { WipLedgerQueryDto } from './wip-ledger.dto';

type Row = Record<string, unknown>;

/** 건별 내역 최대 행 수 */
export const WIP_LEDGER_ROW_LIMIT = 5000;
const DETAIL_MAX_DAYS_WITHOUT_ITEM = 7;
const SUMMARY_MAX_DAYS = 366;

const daysBetween = (from: string, to: string) =>
  Math.round((Date.parse(to) - Date.parse(from)) / 86_400_000) + 1;

@Injectable()
export class WipLedgerService {
  constructor(private readonly dataSource: DataSource) {}

  /** 입고 ∪ 출고 한 줄씩. KIND 는 R / I / A. */
  private sourceSql(itemFilter: boolean) {
    const item = (col: string) => (itemFilter ? `AND ${col} = :itemCode` : '');
    return `
      SELECT 'R' AS KIND, r.RECEIPT_DATE AS TXN_DATE, r.RECEIPT_SEQUENCE AS SEQ, r.ORGANIZATION_ID,
             r.ITEM_CODE, r.RECEIPT_DEFICIT AS DEFICIT, r.RECEIPT_QTY AS QTY,
             r.ENTER_DATE, r.ENTER_BY, CAST(NULL AS VARCHAR2(30)) AS PRODUCT_CODE
        FROM IM_ITEM_WORKSTAGE_RECEIPT r
       WHERE r.RECEIPT_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
         AND r.RECEIPT_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
         AND r.ORGANIZATION_ID = :organizationId ${item('r.ITEM_CODE')}
      UNION ALL
      SELECT CASE WHEN s.LAST_MODIFY_BY = '${WIP_ADJUST_MARK}' THEN 'A' ELSE 'I' END,
             s.ISSUE_DATE, s.ISSUE_SEQUENCE, s.ORGANIZATION_ID,
             s.ITEM_CODE, s.ISSUE_DEFICIT, s.ISSUE_QTY,
             s.ENTER_DATE, s.ENTER_BY,
             CASE WHEN s.LAST_MODIFY_BY = '${WIP_ADJUST_MARK}' THEN NULL ELSE s.LAST_MODIFY_BY END
        FROM IM_ITEM_WORKSTAGE_ISSUE s
       WHERE s.ISSUE_DATE >= TO_DATE(:dateFrom, 'YYYY-MM-DD')
         AND s.ISSUE_DATE < TO_DATE(:dateTo, 'YYYY-MM-DD') + 1
         AND s.ORGANIZATION_ID = :organizationId ${item('s.ITEM_CODE')}`;
  }

  private validate(query: WipLedgerQueryDto, maxDays: number | null) {
    const days = daysBetween(query.dateFrom, query.dateTo);
    if (!(days >= 1)) throw new BadRequestException('종료일이 시작일보다 빠릅니다.');
    if (maxDays !== null && days > maxDays) {
      throw new BadRequestException(
        maxDays === DETAIL_MAX_DAYS_WITHOUT_ITEM
          ? `품목을 지정하지 않으면 건별 내역은 ${maxDays}일까지 조회할 수 있습니다.`
          : `${maxDays}일까지 조회할 수 있습니다.`,
      );
    }
  }

  private binds(query: WipLedgerQueryDto, organizationId: number) {
    const itemCode = query.itemCode?.trim().toUpperCase() || '';
    return {
      itemCode,
      binds: {
        dateFrom: query.dateFrom,
        dateTo: query.dateTo,
        organizationId,
        ...(itemCode ? { itemCode } : {}),
        ...(query.kind ? { kind: query.kind } : {}),
      },
    };
  }

  /** 건별 내역. 최근 것부터. */
  async findDetail(query: WipLedgerQueryDto, organizationId: number) {
    const { itemCode, binds } = this.binds(query, organizationId);
    this.validate(query, itemCode ? SUMMARY_MAX_DAYS : DETAIL_MAX_DAYS_WITHOUT_ITEM);
    const rows = (await this.dataSource.query(
      `SELECT a.KIND AS "kind", a.TXN_DATE AS "txnDate", a.SEQ AS "seq", a.ITEM_CODE AS "itemCode",
              i.ITEM_NAME AS "itemName", i.ITEM_SPEC AS "itemSpec", i.ITEM_UOM AS "itemUom",
              a.DEFICIT AS "deficit", a.QTY AS "qty",
              CASE WHEN a.KIND = 'R' THEN a.QTY ELSE -a.QTY END AS "stockEffect",
              a.PRODUCT_CODE AS "productCode", p.ITEM_NAME AS "productName",
              a.ENTER_BY AS "enterBy", a.ENTER_DATE AS "enterDate"
         FROM (${this.sourceSql(Boolean(itemCode))}) a
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = a.ITEM_CODE AND i.ORGANIZATION_ID = a.ORGANIZATION_ID
         LEFT JOIN ID_ITEM p ON p.ITEM_CODE = a.PRODUCT_CODE AND p.ORGANIZATION_ID = a.ORGANIZATION_ID
        WHERE 1 = 1 ${query.kind ? 'AND a.KIND = :kind' : ''}
        ORDER BY a.TXN_DATE DESC, a.ENTER_DATE DESC, a.SEQ DESC
        FETCH FIRST ${WIP_LEDGER_ROW_LIMIT + 1} ROWS ONLY`,
      namedBinds(binds),
    )) as Row[];
    const truncated = rows.length > WIP_LEDGER_ROW_LIMIT;
    const data = truncated ? rows.slice(0, WIP_LEDGER_ROW_LIMIT) : rows;
    return { data, total: data.length, truncated };
  }

  /** 품목별 기간 합계 + 지금 공정재고. 순증감이 큰 품목부터. */
  async findSummary(query: WipLedgerQueryDto, organizationId: number) {
    const { itemCode, binds } = this.binds(query, organizationId);
    this.validate(query, SUMMARY_MAX_DAYS);
    const data = (await this.dataSource.query(
      `SELECT t.ITEM_CODE AS "itemCode", i.ITEM_NAME AS "itemName", i.ITEM_SPEC AS "itemSpec",
              i.ITEM_UOM AS "itemUom",
              t.RECEIPT_QTY AS "receiptQty", t.ISSUE_QTY AS "issueQty", t.ADJUST_QTY AS "adjustQty",
              t.RECEIPT_QTY - t.ISSUE_QTY - t.ADJUST_QTY AS "netQty",
              t.CNT AS "count", NVL(w.INVENTORY_QTY, 0) AS "currentQty"
         FROM (SELECT a.ORGANIZATION_ID, a.ITEM_CODE,
                      SUM(CASE WHEN a.KIND = 'R' THEN a.QTY ELSE 0 END) AS RECEIPT_QTY,
                      SUM(CASE WHEN a.KIND = 'I' THEN a.QTY ELSE 0 END) AS ISSUE_QTY,
                      SUM(CASE WHEN a.KIND = 'A' THEN a.QTY ELSE 0 END) AS ADJUST_QTY,
                      COUNT(*) AS CNT
                 FROM (${this.sourceSql(Boolean(itemCode))}) a
                WHERE 1 = 1 ${query.kind ? 'AND a.KIND = :kind' : ''}
                GROUP BY a.ORGANIZATION_ID, a.ITEM_CODE) t
         LEFT JOIN ID_ITEM i ON i.ITEM_CODE = t.ITEM_CODE AND i.ORGANIZATION_ID = t.ORGANIZATION_ID
         LEFT JOIN IM_ITEM_WORKSTAGE_INVENTORY w
                ON w.ITEM_CODE = t.ITEM_CODE AND w.ORGANIZATION_ID = t.ORGANIZATION_ID
        ORDER BY ABS(t.RECEIPT_QTY - t.ISSUE_QTY - t.ADJUST_QTY) DESC, t.ITEM_CODE`,
      namedBinds(binds),
    )) as Row[];
    return { data, total: data.length, truncated: false };
  }
}

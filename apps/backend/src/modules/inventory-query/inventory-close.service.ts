/**
 * @file src/modules/inventory-query/inventory-close.service.ts
 * @description 271 자재재고마감 — PB `w_mat_inventory_close_report` 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. **월별 수불명세를 보는 화면이다.** 한 달 동안 자재가 어떻게 드나들었는지를
 *    네 덩어리로 이어 붙여 보여준다:
 *        (1) 전월말 재고 → (2) 이번 달 입고 → (3) 이번 달 출고 → (4) 당월말 재고
 *    그래서 `(1) + (2) − (3) = (4)` 가 맞는지 눈으로 확인할 수 있다.
 * 2. **(1)과 (4)는 월마감을 돌려야 생긴다.** 그 값은 `IM_ITEM_INVENTORY_CLOSE_MFS`
 *    에서 오는데 **이 현장에서는 0행이다** (실측). `IM_ITEM_INVENTORY_CLOSE`(품목
 *    단위 마감)도 **0행**이다. 즉 **월마감을 한 번도 돌린 적이 없다** —
 *    (2)입고·(3)출고 줄만 나오고 앞뒤 잔액 줄은 비어 있다. 화면에 그렇게 적었다.
 * 3. **마감을 만드는 경로는 이 화면에 없다.** PB 도 리포트만 있고 마감 생성은
 *    다른 배치다 (이 창에 INSERT·UPDATE 가 한 줄도 없다 — 실측).
 * 4. **조회 조건에 월(`YYYYMM`)이 필수다.** 입고·출고 원장이 각각 22만/260만 행이라
 *    월이 없으면 전 기간을 훑는다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { InventoryCloseQueryDto, ReceiptIssueLedgerQueryDto } from './inventory-query.dto';

type Row = Record<string, unknown>;

@Injectable()
export class InventoryCloseService {
  constructor(private readonly dataSource: DataSource) {}

  /**
   * 월 수불명세 (PB `d_mat_receipt_issue_rpt`).
   *
   * 네 덩어리를 `DIV` 로 구분해 한 목록으로 낸다 — PB 와 같은 순서로 정렬하면
   * 전월말 → 입고 → 출고 → 당월말이 차례로 보인다.
   */
  async findLedger(query: ReceiptIssueLedgerQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT a.DIV                        AS "div",
              a.RECEIPT_ISSUE_SEQUENCE     AS "sequence",
              TO_CHAR(a.RECEIPT_ISSUE_DATE, 'YYYY-MM-DD')  AS "ledgerDate",
              a.RECEIPT_ISSUE_DEFICIT      AS "deficit",
              a.LINE_TYPE                  AS "lineType",
              a.QTY                        AS "qty",
              a.PRICE                      AS "price",
              a.AMT                        AS "amt",
              a.MATERIAL_COST              AS "materialCost",
              a.MATERIAL_COST_AMT          AS "materialCostAmt",
              a.EXCHANGE_RATE              AS "exchangeRate",
              a.FOREIGN_RECEIPT_AMT        AS "foreignAmt",
              a.INVOICE_NO                 AS "invoiceNo",
              a.SUPPLIER_CODE              AS "supplierCode",
              a.RECEIPT_ISSUE_TYPE         AS "ledgerType",
              a.CURRENCY                   AS "currency",
              a.RECEIPT_ISSUE_STATUS       AS "status",
              a.ITEM_CODE                  AS "itemCode",
              b.ITEM_NAME                  AS "itemName",
              b.ITEM_SPEC                  AS "itemSpec",
              b.ITEM_UOM                   AS "itemUom",
              a.MATERIAL_MFS               AS "lotNo",
              a.LOCATION_CODE              AS "locationCode",
              a.LINE_CODE                  AS "lineCode"
         FROM (
                -- (1) 전월말 재고. 월마감을 돌려야 생긴다 (파일 머리 2번).
                SELECT '(1) 전월말재고' DIV, 0 RECEIPT_ISSUE_SEQUENCE,
                       LAST_DAY(ADD_MONTHS(TO_DATE(:yyyymm || '01', 'YYYYMMDD'), -1))
                         RECEIPT_ISSUE_DATE,
                       NULL RECEIPT_ISSUE_DEFICIT, LINE_TYPE,
                       LAST_INVENTORY_QTY QTY, 0 MATERIAL_COST,
                       LAST_AVG_PRICE PRICE, 0 MATERIAL_COST_AMT,
                       NULL INVOICE_NO, LAST_INVENTORY_AMT AMT,
                       0 EXCHANGE_RATE, 0 FOREIGN_RECEIPT_AMT,
                       NULL SUPPLIER_CODE, NULL RECEIPT_ISSUE_TYPE, NULL CURRENCY,
                       'N' RECEIPT_ISSUE_STATUS, ITEM_CODE, MATERIAL_MFS,
                       LOCATION_CODE, NULL LINE_CODE, ORGANIZATION_ID
                  FROM IM_ITEM_INVENTORY_CLOSE_MFS
                 WHERE CLOSE_YYYYMM = :yyyymm
                UNION ALL
                -- (2) 이번 달 입고
                SELECT '(2) 입고', RECEIPT_SEQUENCE, RECEIPT_DATE,
                       RECEIPT_DEFICIT, LINE_TYPE, RECEIPT_QTY, MATERIAL_COST,
                       UNIT_PRICE, MATERIAL_COST_AMT, INVOICE_NO, RECEIPT_AMT,
                       EXCHANGE_RATE, FOREIGN_RECEIPT_AMT, SUPPLIER_CODE,
                       RECEIPT_TYPE, CURRENCY, RECEIPT_STATUS, ITEM_CODE,
                       MATERIAL_MFS, LOCATION_CODE, NULL, ORGANIZATION_ID
                  FROM IM_ITEM_RECEIPT
                 WHERE RECEIPT_DATE >= TO_DATE(:yyyymm || '01', 'YYYYMMDD')
                   AND RECEIPT_DATE <  ADD_MONTHS(TO_DATE(:yyyymm || '01', 'YYYYMMDD'), 1)
                UNION ALL
                -- (3) 이번 달 출고
                SELECT '(3) 출고', ISSUE_SEQUENCE, ISSUE_DATE,
                       ISSUE_DEFICIT, LINE_TYPE, ISSUE_QTY, 0,
                       ISSUE_PRICE, 0, NULL, ISSUE_AMT,
                       0, 0, SUPPLIER_CODE,
                       ISSUE_TYPE, NULL, ISSUE_STATUS, ITEM_CODE,
                       MATERIAL_MFS, LOCATION_CODE, LINE_CODE, ORGANIZATION_ID
                  FROM IM_ITEM_ISSUE
                 WHERE ISSUE_DATE >= TO_DATE(:yyyymm || '01', 'YYYYMMDD')
                   AND ISSUE_DATE <  ADD_MONTHS(TO_DATE(:yyyymm || '01', 'YYYYMMDD'), 1)
                UNION ALL
                -- (4) 당월말 재고. 역시 월마감을 돌려야 생긴다.
                SELECT '(4) 당월말재고', 9999999,
                       LAST_DAY(TO_DATE(:yyyymm || '01', 'YYYYMMDD')),
                       NULL, LINE_TYPE, MM_INVENTORY_QTY, 0,
                       MM_AVG_PRICE, 0, NULL, MM_INVENTORY_AMT,
                       0, 0, NULL, NULL, NULL,
                       'N', ITEM_CODE, MATERIAL_MFS, LOCATION_CODE, NULL,
                       ORGANIZATION_ID
                  FROM IM_ITEM_INVENTORY_CLOSE_MFS
                 WHERE CLOSE_YYYYMM = :yyyymm
              ) a
         LEFT JOIN ID_ITEM b
                ON b.ITEM_CODE = a.ITEM_CODE
               AND b.ORGANIZATION_ID = a.ORGANIZATION_ID
        WHERE a.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(a.LOCATION_CODE, '*') LIKE :locationCode ESCAPE '\\'
          AND a.ORGANIZATION_ID = :organizationId
        ORDER BY a.ITEM_CODE, a.MATERIAL_MFS, a.DIV,
                 a.RECEIPT_ISSUE_DATE, a.RECEIPT_ISSUE_SEQUENCE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        yyyymm: query.yyyymm,
        itemCode: likePrefix(query.itemCode),
        locationCode: likePrefix(query.locationCode),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 품목 단위 월마감 (PB `d_mat_inventory_close_rpt`).
   *
   * **이 표도 0행이다** (실측 `IM_ITEM_INVENTORY_CLOSE`). 월마감 배치가 돌면 채워진다.
   * 현재고는 `F_GET_MAT_INVENTORY_QTY` 로 함께 내어 마감값과 견줘 볼 수 있게 한다
   * (PB 가 같은 자리에 붙이던 계산식이다).
   */
  async findCloseSummary(query: InventoryCloseQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT c.CLOSE_YYYYMM              AS "closeYyyymm",
              c.ITEM_CODE                 AS "itemCode",
              i.ITEM_NAME                 AS "itemName",
              i.ITEM_SPEC                 AS "itemSpec",
              i.ITEM_UOM                  AS "itemUom",
              i.ITEM_CLASS                AS "itemClass",
              i.ITEM_DIVISION             AS "itemDivision",
              c.LINE_TYPE                 AS "lineType",
              c.LOCATION_CODE             AS "locationCode",
              c.LAST_INVENTORY_QTY        AS "lastQty",
              c.LAST_AVG_PRICE            AS "lastAvgPrice",
              c.LAST_INVENTORY_AMT        AS "lastAmt",
              c.MM_RECEIPT_QTY            AS "receiptQty",
              c.MM_RECEIPT_AMT            AS "receiptAmt",
              c.MM_ISSUE_QTY              AS "issueQty",
              c.MM_ISSUE_AMT              AS "issueAmt",
              c.MM_MASS_QTY               AS "massQty",
              c.MM_MASS_AMT               AS "massAmt",
              c.MM_BAD_QTY                AS "badQty",
              c.MM_BAD_AMT                AS "badAmt",
              c.MM_EXTRA_QTY              AS "extraQty",
              c.MM_EXTRA_AMT              AS "extraAmt",
              c.MM_FREE_QTY               AS "freeQty",
              c.MM_FREE_AMT               AS "freeAmt",
              c.MM_SALE_QTY               AS "saleQty",
              c.MM_SALE_AMT               AS "saleAmt",
              c.MM_SHIPPING_QTY           AS "shippingQty",
              c.MM_SHIPPING_AMT           AS "shippingAmt",
              c.MM_LOGICAL_ISSUE_QTY      AS "logicalIssueQty",
              c.MM_AVG_PRICE              AS "avgPrice",
              c.MM_INVENTORY_QTY          AS "closeQty",
              c.MM_INVENTORY_AMT          AS "closeAmt",
              c.MM_MATERIAL_COST_AMT      AS "materialCostAmt",
              -- 지금 이 순간의 재고. 마감값과 견줘 보라고 PB 가 붙이던 계산식이다.
              F_GET_MAT_INVENTORY_QTY(c.ITEM_CODE, c.LINE_TYPE, c.ORGANIZATION_ID)
                                          AS "currentQty",
              c.ENTER_BY                  AS "enterBy",
              TO_CHAR(c.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')        AS "enterDate"
         FROM IM_ITEM_INVENTORY_CLOSE c
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = c.ITEM_CODE
               AND i.ORGANIZATION_ID = c.ORGANIZATION_ID
        WHERE c.CLOSE_YYYYMM = :yyyymm
          AND c.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(i.ITEM_DIVISION, '*') LIKE :itemDivision ESCAPE '\\'
          AND c.ORGANIZATION_ID = :organizationId
        ORDER BY i.ITEM_CLASS, i.ITEM_DIVISION, c.ITEM_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        yyyymm: query.yyyymm,
        itemCode: likePrefix(query.itemCode),
        itemDivision: likePrefix(query.itemDivision),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }
}

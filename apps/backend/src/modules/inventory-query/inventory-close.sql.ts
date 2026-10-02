/**
 * @file src/modules/inventory-query/inventory-close.sql.ts
 * @description 271 자재재고마감 — 원자재 월마감 집계 SQL (한 문장)
 *
 * 초보자 가이드:
 * 1. 대상: 원자재(ID_ITEM.ITEM_DIVISION = 'R'). 단위: 품목·창고. 기간: 거래일 기준 한 달.
 *    원장의 거래유형(LINE_TYPE)은 시기마다 섞여 있어(같은 품목을 F 로 입고하고 Y 로 출고 — 실측)
 *    거래유형별로 나누면 잔량이 음수로 갈린다. 그래서 품목 단위로 평균하고, 마감표의 LINE_TYPE
 *    키에는 품목 기준정보의 현재 거래유형을 넣는다. 입고 단가는 입고행의 거래유형으로 찾는다.
 * 2. 기초: 전월 마감이 있으면 그 기말, 첫 마감이면 그 달 1일 전까지 입고 − 출고 원장 합계.
 *    첫 마감의 기초단가는 전월 말일에 유효한 단가(품목 기준정보 공급처 우선)다.
 * 3. 입고금액: 입고행에 금액(RECEIPT_AMT)이 있으면 그것, 없으면 입고행 단가 × 수량,
 *    그것도 없으면 입고일에 유효한 단가표(IM_ITEM_UNIT_PRICE, 공급처·품목·거래유형) × 수량.
 *    단가표가 0원이면 0원이다 (무상 F 자재 — 사용자 결정 2026-10-02). 입고행은 고치지 않는다.
 * 4. 출고: 출고계정별 수량. 반품·취소는 음수로 들어 있어 그대로 더하면 상쇄된다.
 * 5. 금액 계산(평균단가·출고금액·기말금액)은 inventory-close.calc.ts 가 한다.
 */

/** 출고계정 → 마감표 출고 구분 (ISYS_BASECODE 'ISSUE ACCOUNT') */
export const ISSUE_GROUPS = {
  mass: ['M001'],                                   // 양산
  bad: ['M002', 'M007', 'M008', 'M013', 'M014'],    // 양산불량·분실·검사폐기·LOSS·스크렙
  free: ['M003'],                                   // 무상
  sale: ['M004', 'M005'],                           // 유상·내부거래
} as const;

const inList = (codes: readonly string[]) => codes.map((c) => `'${c}'`).join(', ');

/**
 * 마감 집계. 바인드: :organizationId, :startDate·:endDate ('YYYY-MM-DD', end 는 다음달 1일),
 * :prevYyyymm (전월 마감이 기초일 때만).
 * @param openingFromLedger 첫 마감이면 true — 기초를 원장 합계로 잡는다.
 */
export function closeAggregateSql(openingFromLedger: boolean): string {
  const opening = openingFromLedger
    ? `OPEN_QTY AS (
         SELECT ITEM_CODE, LOCATION_CODE, SUM(Q) AS QTY
           FROM (SELECT ITEM_CODE, LOCATION_CODE, RECEIPT_QTY AS Q
                   FROM IM_ITEM_RECEIPT
                  WHERE ORGANIZATION_ID = :organizationId
                    AND RECEIPT_DATE < TO_DATE(:startDate, 'YYYY-MM-DD')
                    AND ITEM_CODE IN (SELECT ITEM_CODE FROM ITEMS)
                 UNION ALL
                 SELECT ITEM_CODE, LOCATION_CODE, -ISSUE_QTY
                   FROM IM_ITEM_ISSUE
                  WHERE ORGANIZATION_ID = :organizationId
                    AND ISSUE_DATE < TO_DATE(:startDate, 'YYYY-MM-DD')
                    AND ITEM_CODE IN (SELECT ITEM_CODE FROM ITEMS))
          GROUP BY ITEM_CODE, LOCATION_CODE
         HAVING SUM(Q) <> 0
       ),
       OPENING AS (
         SELECT O.ITEM_CODE, O.LOCATION_CODE, O.QTY,
                NVL((SELECT MAX(P.UNIT_PRICE) KEEP (DENSE_RANK FIRST ORDER BY
                               CASE WHEN P.LINE_TYPE = I.MASTER_LINE_TYPE THEN 0 ELSE 1 END,
                               CASE WHEN P.SUPPLIER_CODE = I.MAIN_SUPPLIER THEN 0 ELSE 1 END,
                               P.DATESET DESC)
                       FROM IM_ITEM_UNIT_PRICE P
                      WHERE P.ITEM_CODE = O.ITEM_CODE
                        AND P.ORGANIZATION_ID = :organizationId
                        AND TRUNC(P.DATESET) <= TO_DATE(:startDate, 'YYYY-MM-DD') - 1
                        AND P.DATEEND >= TO_DATE(:startDate, 'YYYY-MM-DD') - 1), 0) AS PRICE
           FROM OPEN_QTY O
           JOIN ITEMS I ON I.ITEM_CODE = O.ITEM_CODE
       ),
       OPEN_ROWS AS (
         SELECT ITEM_CODE, LOCATION_CODE, QTY, ROUND(QTY * PRICE) AS AMT, PRICE
           FROM OPENING
       )`
    : `OPEN_ROWS AS (
         SELECT ITEM_CODE, LOCATION_CODE,
                SUM(MM_INVENTORY_QTY) AS QTY, SUM(MM_INVENTORY_AMT) AS AMT, MAX(MM_AVG_PRICE) AS PRICE
           FROM IM_ITEM_INVENTORY_CLOSE
          WHERE CLOSE_YYYYMM = :prevYyyymm
            AND ORGANIZATION_ID = :organizationId
          GROUP BY ITEM_CODE, LOCATION_CODE
         HAVING SUM(NVL(MM_INVENTORY_QTY, 0)) <> 0 OR SUM(NVL(MM_INVENTORY_AMT, 0)) <> 0
       )`;

  return `WITH
ITEMS AS (
  SELECT ITEM_CODE, MAX(ITEM_NAME) AS ITEM_NAME, MAX(ITEM_SPEC) AS ITEM_SPEC,
         MAX(ITEM_UOM) AS ITEM_UOM, MAX(SUPPLIER_CODE) AS MAIN_SUPPLIER,
         MAX(LINE_TYPE) AS MASTER_LINE_TYPE
    FROM ID_ITEM
   WHERE ORGANIZATION_ID = :organizationId
     AND ITEM_DIVISION = 'R'
   GROUP BY ITEM_CODE
),
${opening},
RC AS (
  SELECT R.ITEM_CODE, R.LINE_TYPE, R.LOCATION_CODE, R.RECEIPT_QTY AS QTY,
         CASE WHEN NVL(R.RECEIPT_AMT, 0) <> 0 THEN 'ROW'
              WHEN NVL(R.UNIT_PRICE, 0) <> 0 THEN 'ROW'
              WHEN UP.PRICE IS NOT NULL THEN 'TABLE'
              ELSE 'NONE' END AS SRC,
         CASE WHEN NVL(R.RECEIPT_AMT, 0) <> 0 THEN R.RECEIPT_AMT
              WHEN NVL(R.UNIT_PRICE, 0) <> 0 THEN ROUND(R.RECEIPT_QTY * R.UNIT_PRICE)
              ELSE ROUND(R.RECEIPT_QTY * NVL(UP.PRICE, 0)) END AS AMT
    FROM IM_ITEM_RECEIPT R
    OUTER APPLY (
      SELECT MAX(P.UNIT_PRICE) KEEP (DENSE_RANK LAST ORDER BY P.DATESET) AS PRICE
        FROM IM_ITEM_UNIT_PRICE P
       WHERE P.SUPPLIER_CODE = R.SUPPLIER_CODE
         AND P.ITEM_CODE = R.ITEM_CODE
         AND P.LINE_TYPE = R.LINE_TYPE
         AND P.ORGANIZATION_ID = R.ORGANIZATION_ID
         AND TRUNC(P.DATESET) <= TRUNC(R.RECEIPT_DATE)
         AND P.DATEEND >= TRUNC(R.RECEIPT_DATE)
    ) UP
   WHERE R.ORGANIZATION_ID = :organizationId
     AND R.RECEIPT_DATE >= TO_DATE(:startDate, 'YYYY-MM-DD')
     AND R.RECEIPT_DATE < TO_DATE(:endDate, 'YYYY-MM-DD')
     AND R.ITEM_CODE IN (SELECT ITEM_CODE FROM ITEMS)
),
RC_SUM AS (
  SELECT ITEM_CODE, LOCATION_CODE, SUM(QTY) AS QTY, SUM(AMT) AS AMT,
         SUM(CASE WHEN SRC = 'ROW' THEN 1 ELSE 0 END) AS ROW_PRICED,
         SUM(CASE WHEN SRC = 'TABLE' THEN 1 ELSE 0 END) AS TABLE_PRICED,
         SUM(CASE WHEN SRC = 'NONE' THEN 1 ELSE 0 END) AS UNPRICED
    FROM RC
   GROUP BY ITEM_CODE, LOCATION_CODE
),
IS_SUM AS (
  SELECT ITEM_CODE, LOCATION_CODE,
         SUM(CASE WHEN ISSUE_ACCOUNT IN (${inList(ISSUE_GROUPS.mass)}) THEN ISSUE_QTY ELSE 0 END) AS MASS,
         SUM(CASE WHEN ISSUE_ACCOUNT IN (${inList(ISSUE_GROUPS.bad)}) THEN ISSUE_QTY ELSE 0 END) AS BAD,
         SUM(CASE WHEN ISSUE_ACCOUNT IN (${inList(ISSUE_GROUPS.free)}) THEN ISSUE_QTY ELSE 0 END) AS FREE,
         SUM(CASE WHEN ISSUE_ACCOUNT IN (${inList(ISSUE_GROUPS.sale)}) THEN ISSUE_QTY ELSE 0 END) AS SALE,
         SUM(CASE WHEN ISSUE_ACCOUNT IN (${inList([...ISSUE_GROUPS.mass, ...ISSUE_GROUPS.bad,
           ...ISSUE_GROUPS.free, ...ISSUE_GROUPS.sale])}) THEN 0 ELSE ISSUE_QTY END) AS EXTRA
    FROM IM_ITEM_ISSUE
   WHERE ORGANIZATION_ID = :organizationId
     AND ISSUE_DATE >= TO_DATE(:startDate, 'YYYY-MM-DD')
     AND ISSUE_DATE < TO_DATE(:endDate, 'YYYY-MM-DD')
     AND ITEM_CODE IN (SELECT ITEM_CODE FROM ITEMS)
   GROUP BY ITEM_CODE, LOCATION_CODE
),
KEYS AS (
  SELECT ITEM_CODE, LOCATION_CODE FROM OPEN_ROWS
  UNION SELECT ITEM_CODE, LOCATION_CODE FROM RC_SUM
  UNION SELECT ITEM_CODE, LOCATION_CODE FROM IS_SUM
)
SELECT K.ITEM_CODE       AS "itemCode",
       I.ITEM_NAME       AS "itemName",
       I.ITEM_SPEC       AS "itemSpec",
       I.ITEM_UOM        AS "itemUom",
       NVL(I.MASTER_LINE_TYPE, '*') AS "lineType",
       K.LOCATION_CODE   AS "locationCode",
       NVL(O.QTY, 0)     AS "openingQty",
       NVL(O.AMT, 0)     AS "openingAmt",
       NVL(O.PRICE, 0)   AS "openingPrice",
       NVL(R.QTY, 0)     AS "receiptQty",
       NVL(R.AMT, 0)     AS "receiptAmt",
       NVL(R.ROW_PRICED, 0)   AS "rowPriced",
       NVL(R.TABLE_PRICED, 0) AS "tablePriced",
       NVL(R.UNPRICED, 0)     AS "unpriced",
       NVL(S.MASS, 0)    AS "massQty",
       NVL(S.BAD, 0)     AS "badQty",
       NVL(S.FREE, 0)    AS "freeQty",
       NVL(S.SALE, 0)    AS "saleQty",
       NVL(S.EXTRA, 0)   AS "extraQty"
  FROM KEYS K
  JOIN ITEMS I ON I.ITEM_CODE = K.ITEM_CODE
  LEFT JOIN OPEN_ROWS O
    ON O.ITEM_CODE = K.ITEM_CODE AND O.LOCATION_CODE = K.LOCATION_CODE
  LEFT JOIN RC_SUM R
    ON R.ITEM_CODE = K.ITEM_CODE AND R.LOCATION_CODE = K.LOCATION_CODE
  LEFT JOIN IS_SUM S
    ON S.ITEM_CODE = K.ITEM_CODE AND S.LOCATION_CODE = K.LOCATION_CODE
 ORDER BY K.ITEM_CODE, K.LOCATION_CODE`;
}

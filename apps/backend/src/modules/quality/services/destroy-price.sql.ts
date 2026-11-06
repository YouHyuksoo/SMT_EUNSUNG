/**
 * @file src/modules/quality/services/destroy-price.sql.ts
 * @description 공정폐기·LCR 폐기 금액에 쓰는 단가 SQL 조각
 *
 * 초보자 가이드:
 * 1. 자재 단가는 구매단가표(IM_ITEM_UNIT_PRICE)에서 기준일에 유효한 단가를 쓴다.
 *    기준일에 유효한 단가가 없으면 최근 적용일 단가를 쓴다 (장기재고 현황과 같은 고르기 순서).
 * 2. 제품·반제품은 구매단가가 없으므로 BOM(ID_ENG_BOM)을 끝까지 펼쳐 말단 자재의
 *    (누적 소요량 × 단가) 합을 단가로 쓴다.
 * 3. LCR 측정 자재는 BOM 위치(LOCATION_INFO)가 L/C/R + 숫자로 시작하는 자재다.
 *    CN(커넥터)·LED 는 정규식에서 빠지고, 위치가 L 이어도 전원 트랜스(TRN-)는 LCR 측정 대상이 아니다.
 */

/** ID_ENG_BOM 별칭 `b` 가 기준일(:bindName, 'YYYY-MM-DD' 문자열)에 유효한지 */
export const bomValidOn = (alias: string, bindName: string) =>
  `TRUNC(${alias}.DATESET) <= TO_DATE(:${bindName}, 'YYYY-MM-DD')
   AND NVL(TRUNC(${alias}.DATEEND), DATE '9999-12-31') >= TO_DATE(:${bindName}, 'YYYY-MM-DD')`;

/**
 * 품목 하나의 구매단가 — 스칼라 서브쿼리. itemExpr / orgExpr 는 바깥 쿼리의 컬럼식,
 * dateBind 는 'YYYY-MM-DD' 문자열 바인드 이름.
 * (재귀 WITH 안에서 OUTER APPLY 로 붙이면 12.2 서버 세션이 끊긴다 — 실측. 스칼라 서브쿼리로 쓴다)
 */
export const purchasePriceExpr = (itemExpr: string, orgExpr: string, dateBind: string) => `(
  SELECT MAX(p.UNIT_PRICE) KEEP (DENSE_RANK FIRST ORDER BY
             CASE WHEN TRUNC(p.DATESET) <= TO_DATE(:${dateBind}, 'YYYY-MM-DD')
                   AND p.DATEEND >= TO_DATE(:${dateBind}, 'YYYY-MM-DD')
                  THEN 0 ELSE 1 END,
             p.DATESET DESC)
    FROM IM_ITEM_UNIT_PRICE p
   WHERE p.ITEM_CODE = ${itemExpr}
     AND p.ORGANIZATION_ID = ${orgExpr}
     AND p.UNIT_PRICE IS NOT NULL)`;

/**
 * 폐기 단가 1건의 재료: 구매단가("ownPrice")와 BOM 말단 자재원가 합("bomPrice").
 * 바인드: :itemCode, :organizationId, :baseDate('YYYY-MM-DD').
 */
export const DESTROY_UNIT_PRICE_SQL = `
  WITH t (CHILD_ITEM_CODE, QTY, LVL) AS (
    SELECT b.CHILD_ITEM_CODE, b.ITEM_UNIT_QTY, 1
      FROM ID_ENG_BOM b
     WHERE b.PARENT_ITEM_CODE = :itemCode
       AND b.ORGANIZATION_ID = :organizationId
       AND ${bomValidOn('b', 'baseDate')}
    UNION ALL
    SELECT b.CHILD_ITEM_CODE, t.QTY * b.ITEM_UNIT_QTY, t.LVL + 1
      FROM t
      JOIN ID_ENG_BOM b
        ON b.PARENT_ITEM_CODE = t.CHILD_ITEM_CODE
       AND b.ORGANIZATION_ID = :organizationId
       AND ${bomValidOn('b', 'baseDate')}
     WHERE t.LVL < 10
  ), leaf AS (
    SELECT t.CHILD_ITEM_CODE, t.QTY
      FROM t
     WHERE NOT EXISTS (SELECT 1 FROM ID_ENG_BOM c
                        WHERE c.PARENT_ITEM_CODE = t.CHILD_ITEM_CODE
                          AND c.ORGANIZATION_ID = :organizationId
                          AND ${bomValidOn('c', 'baseDate')})
  )
  SELECT ${purchasePriceExpr(':itemCode', ':organizationId', 'baseDate')} AS "ownPrice",
         (SELECT ROUND(SUM(leaf.QTY * ${purchasePriceExpr('leaf.CHILD_ITEM_CODE', ':organizationId', 'baseDate')}), 2)
            FROM leaf) AS "bomPrice"
    FROM DUAL`;

/** LCR 측정 자재 판별 — ID_ENG_BOM 별칭 b, ID_ITEM 별칭 i */
export const LCR_PART_FILTER = `REGEXP_LIKE(b.LOCATION_INFO, '^[LCR][0-9]') AND NVL(i.ITEM_NAME, '*') NOT LIKE 'TRN%'`;

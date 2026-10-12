/**
 * @file src/modules/purchase/order-plan.sql.ts
 * @description 478 자재발주계획 — 발주량 계산을 한 문장(CTE)으로 만드는 SQL 조각
 *
 * 초보자 가이드:
 * 1. 발주량 = (계획잔량 × BOM 누적수량) − 가용재고 → 발주속성 올림 → 공급처 비율 → 납기 보정 → 단가.
 *    PB 는 작업 테이블(_TEMP·_GEN·REQUIR_ORDER)에 썼다 지우며 커서로 돌았다. 여기서는
 *    작업 테이블 없이 CTE 로 이어 붙인다 — 미리보기는 아무것도 쓰지 않는다.
 * 2. CTE 순서: PLN(계획) → ROOTS·BOMX(BOM 재귀 전개) → REQ(말단 자재 소요) → REQO(소요량표)
 *    → GRP(발주 대상 품목을 줄로 묶음) → LN(공급처·비율) → 최종 SELECT(재고·속성·납기·단가).
 * 3. BOM 전개는 `PKG_DESIGN.BOM_EXPLOSION(_ALL)` 과 같은 조건이다: 시작 행은 그 품목을
 *    CHILD 로 가진 행 중 PARENT 가 가장 큰 것, 하위는 날짜 유효 + (ALL 이 아니면)
 *    반제품 전개여부 Y. 누적수량은 경로의 단위수량 곱이다.
 * 4. 순서가 결과를 바꾸는 재고 차감·올림은 SQL 이 아니라 order-plan.netting.ts 가 한다.
 */

/** 계획 원천. 열: ITEM_CODE, PLAN_DATE, QTY, MFS, REQ_DATE. */
export const PLAN_SOURCES = {
  /** 수기로 넣은 발주 기준계획. 소요전개 기준일은 원천 값을 그대로 쓴다. */
  manual: {
    label: '수기계획',
    explodeAll: false,
    sql: `SELECT ITEM_CODE, PLAN_DATE, ORDER_QTY AS QTY, '*' AS MFS,
                 REQUIRMENT_PLAN_DATE AS REQ_DATE
            FROM IM_ITEM_MASTER_PLAN_4_PO
           WHERE TRUNC(PLAN_DATE) BETWEEN TO_DATE(:dateFrom, 'YYYY-MM-DD') AND TO_DATE(:dateTo, 'YYYY-MM-DD')
             AND ITEM_CODE LIKE :itemPattern
             AND ORGANIZATION_ID = :organizationId`,
  },
  /** 생산계획(MI). 남은 수량 = 계획 - 실적. MFS 에 작업지시번호를 남긴다. */
  productionPlan: {
    label: '생산계획',
    explodeAll: false,
    sql: `SELECT ITEM_CODE, PLAN_DATE, PLAN_QTY - NVL(ACTUAL_QTY, 0) AS QTY,
                 NVL(WORK_ORDER_NO, '*') AS MFS, TRUNC(SYSDATE) AS REQ_DATE
            FROM IP_PRODUCT_MI_PLAN
           WHERE TRUNC(PLAN_DATE) BETWEEN TO_DATE(:dateFrom, 'YYYY-MM-DD') AND TO_DATE(:dateTo, 'YYYY-MM-DD')
             AND NVL(PLAN_QTY, 0) - NVL(ACTUAL_QTY, 0) > 0
             AND ITEM_CODE LIKE :itemPattern
             AND ORGANIZATION_ID = :organizationId`,
  },
  /** 생산계획을 시간까지 나눠 본다 (PLAN_PRIORITY 3~7자리가 HHMI). */
  productionPlanByTime: {
    label: '생산계획(시간별)',
    explodeAll: false,
    sql: `SELECT ITEM_CODE,
                 TO_DATE(TO_CHAR(PLAN_DATE, 'YYYYMMDD') || ' '
                         || SUBSTR(PLAN_PRIORITY, 3, 5), 'YYYYMMDD HH24:MI') AS PLAN_DATE,
                 PLAN_QTY - NVL(ACTUAL_QTY, 0) AS QTY,
                 NVL(WORK_ORDER_NO, '*') AS MFS, TRUNC(SYSDATE) AS REQ_DATE
            FROM IP_PRODUCT_MI_PLAN
           WHERE TRUNC(PLAN_DATE) BETWEEN TO_DATE(:dateFrom, 'YYYY-MM-DD') AND TO_DATE(:dateTo, 'YYYY-MM-DD')
             AND NVL(PLAN_QTY, 0) - NVL(ACTUAL_QTY, 0) > 0
             AND ITEM_CODE LIKE :itemPattern
             AND ORGANIZATION_ID = :organizationId`,
  },
  /** 납품계획. 남은 수량에서 지시번호로 잡힌 실적까지 뺀다. */
  salePlan: {
    label: '납품계획',
    explodeAll: false,
    sql: `SELECT ITEM_CODE, PLAN_DATE,
                 PLAN_QTY - (NVL(ACTUAL_QTY, 0)
                   + F_GET_PLAN_ACTUAL_QTY_BY_ONO(WORK_ORDER_NO, ORGANIZATION_ID)) AS QTY,
                 NVL(WORK_ORDER_NO, '*') AS MFS, TRUNC(SYSDATE) AS REQ_DATE
            FROM IP_PRODUCT_DELIVERY_PLAN
           WHERE TRUNC(PLAN_DATE) BETWEEN TO_DATE(:dateFrom, 'YYYY-MM-DD') AND TO_DATE(:dateTo, 'YYYY-MM-DD')
             AND NVL(PLAN_QTY, 0) - NVL(ACTUAL_QTY, 0) > 0
             AND ITEM_CODE LIKE :itemPattern
             AND ORGANIZATION_ID = :organizationId`,
  },
  /**
   * 납품계획(시간별). 은성 설정(SALE_UPLOAD_DIVISION=SAMSUNG)에서 PB 가 실제로 쓰던 경로다.
   * 전개는 반제품 전개여부와 관계없이 전 단계를 편다 (`BOM_EXPLOSION_ALL`).
   * 발주규칙 E(PO제외) 제품은 뺀다.
   */
  salePlanByTime: {
    label: '납품계획(시간별)',
    explodeAll: true,
    sql: `SELECT ITEM_CODE,
                 TO_DATE(TO_CHAR(PLAN_DATE, 'YYYYMMDD') || ' '
                         || PLAN_PRIORITY, 'YYYYMMDD HH24:MI:SS') AS PLAN_DATE,
                 PLAN_QTY - NVL(ACTUAL_QTY, 0) AS QTY,
                 NVL(WORK_ORDER_NO, '*') AS MFS, TRUNC(SYSDATE) AS REQ_DATE
            FROM IP_PRODUCT_DELIVERY_PLAN
           WHERE TRUNC(PLAN_DATE) BETWEEN TO_DATE(:dateFrom, 'YYYY-MM-DD') AND TO_DATE(:dateTo, 'YYYY-MM-DD')
             AND NVL(PLAN_QTY, 0) - NVL(ACTUAL_QTY, 0) > 0
             AND ITEM_CODE LIKE :itemPattern
             AND ITEM_CODE NOT IN (SELECT ITEM_CODE FROM ID_ITEM
                                    WHERE ORDER_RULE = 'E'
                                      AND ORGANIZATION_ID = :organizationId)
             AND ORGANIZATION_ID = :organizationId`,
  },
} as const;

export type PlanSource = keyof typeof PLAN_SOURCES;

/**
 * 소요량에서 뺄 재고 원천 (품목·거래유형별 합). PB 는 체크박스 조합마다 INSERT 를 따로
 * 적어 두었고(실측 40개) 일부 조합은 가지가 빠져 있었다. 여기서는 켠 가지를 모두 더한다.
 */
export const INVENTORY_ARMS = {
  /** 자재창고 재고. PB 도 `LOCATION_CODE = 'M01'` 만 본다. */
  inventory: `SELECT ITEM_CODE, LINE_TYPE, SUM(INVENTORY_QTY) AS QTY
                FROM IM_ITEM_INVENTORY
               WHERE ORGANIZATION_ID = :organizationId
                 AND LOCATION_CODE = 'M01'
               GROUP BY ITEM_CODE, LINE_TYPE`,
  /** 아직 안 들어온 발주잔량. */
  order: `SELECT ITEM_CODE, LINE_TYPE, SUM(ORDER_QTY - NVL(ARRIVAL_QTY, 0)) AS QTY
            FROM IM_ITEM_PURCHASE_ORDER
           WHERE ORDER_QTY - NVL(ARRIVAL_QTY, 0) > 0
             AND ORGANIZATION_ID = :organizationId
           GROUP BY ITEM_CODE, LINE_TYPE`,
  /** 도착했지만 입고 전인 물량. */
  arrival: `SELECT ITEM_CODE, LINE_TYPE, SUM(ARRIVAL_QTY) AS QTY
              FROM IM_ITEM_ARRIVAL
             WHERE ARRIVAL_TYPE = 'A'
               AND ARRIVAL_STATUS = 'N'
               AND ORGANIZATION_ID = :organizationId
             GROUP BY ITEM_CODE, LINE_TYPE`,
  /**
   * 공정에 깔려 있는 재고. 이 스키마의 `IM_ITEM_WORKSTAGE_INVENTORY` 에는 `LINE_TYPE` 이
   * 없어(실측, PB 는 이 체크박스를 켜면 ORA-00904) 품목 기준정보에서 가져온다.
   */
  workstageInventory: `SELECT W.ITEM_CODE, I.LINE_TYPE, SUM(W.INVENTORY_QTY) AS QTY
                         FROM IM_ITEM_WORKSTAGE_INVENTORY W
                         JOIN ID_ITEM I
                           ON I.ITEM_CODE = W.ITEM_CODE
                          AND I.ORGANIZATION_ID = W.ORGANIZATION_ID
                          AND I.ITEM_DIVISION IN ('R', 'S')
                          AND I.DATESET <= TRUNC(SYSDATE)
                          AND I.DATEEND >= TRUNC(SYSDATE)
                        WHERE W.ORGANIZATION_ID = :organizationId
                        GROUP BY W.ITEM_CODE, I.LINE_TYPE`,
  /** 무상재고. PB 도 원자재·부자재(`ITEM_DIVISION` R·S)만 센다. */
  freeInventory: `SELECT ITEM_CODE, LINE_TYPE, SUM(INVENTORY_QTY) AS QTY
                    FROM IM_ITEM_FREE_INVENTORY
                   WHERE ORGANIZATION_ID = :organizationId
                     AND ITEM_CODE IN (SELECT ITEM_CODE FROM ID_ITEM
                                        WHERE ITEM_DIVISION IN ('R', 'S')
                                          AND ORGANIZATION_ID = :organizationId)
                   GROUP BY ITEM_CODE, LINE_TYPE`,
} as const;

export type InventoryArm = keyof typeof INVENTORY_ARMS;

/** 결과 열 이름 (재고 가지별 수량) */
export const ARM_COLUMNS: Record<InventoryArm, string> = {
  inventory: 'INV_STOCK',
  order: 'INV_ORDER',
  arrival: 'INV_ARRIVAL',
  workstageInventory: 'INV_WORKSTAGE',
  freeInventory: 'INV_FREE',
};

/**
 * 발주계획 대상 품목. 발주속성 적용(PB Auto Order Rule)을 켜면 `:orderRule` 이 'A%'
 * (발주규칙 A=자동), 끄면 '%' (전 품목)이다.
 */
const ORDER_RULE_ITEMS_SQL = `SELECT ITEM_CODE FROM ID_ITEM
                 WHERE DATESET <= TRUNC(SYSDATE)
                   AND DATEEND >= TRUNC(SYSDATE)
                   AND NVL(ORDER_RULE, '*') LIKE :orderRule
                   AND ORGANIZATION_ID = :organizationId`;

/**
 * 품목별 발주 공급처와 발주비율 (`IM_ITEM_MASTER`, 비율 0 초과 100 이하).
 * 비율이 나뉘어 있으면(예: 60/40) 공급처마다 그 비율로 나눠 발주한다.
 * 비율 100 이 둘 이상이면 같은 수량이 공급처마다 통째로 발주되므로, 주거래선
 * 한 곳만 남긴다 (사용자 결정 2026-10-02). 은성 데이터는 MAIN_VENDOR_YN 이 전부
 * Y 라 그 컬럼으로는 가릴 수 없어, 아래 순서로 고른다:
 *   1. 품목 기준정보 공급처(ID_ITEM.SUPPLIER_CODE)와 같은 공급처
 *   2. 단가 기준정보가 등록된 공급처
 *   3. 공급처코드 순
 */
const ORDER_SUPPLIER_SQL = `SELECT ITEM_CODE, SUPPLIER_CODE, ORDER_RATE, PAYMENT_TYPE
  FROM (
    SELECT M.ITEM_CODE, M.SUPPLIER_CODE, M.ORDER_RATE, M.PAYMENT_TYPE,
           ROW_NUMBER() OVER (
             PARTITION BY M.ITEM_CODE, DECODE(M.ORDER_RATE, 100, '*', M.SUPPLIER_CODE)
             ORDER BY CASE WHEN M.SUPPLIER_CODE = (SELECT MAX(I.SUPPLIER_CODE) FROM ID_ITEM I
                                                    WHERE I.ITEM_CODE = M.ITEM_CODE
                                                      AND I.ORGANIZATION_ID = M.ORGANIZATION_ID)
                           THEN 0 ELSE 1 END,
                      CASE WHEN EXISTS (SELECT 'X' FROM IM_ITEM_UNIT_PRICE P
                                         WHERE P.SUPPLIER_CODE = M.SUPPLIER_CODE
                                           AND P.ITEM_CODE = M.ITEM_CODE
                                           AND P.ORGANIZATION_ID = M.ORGANIZATION_ID
                                           AND P.DATESET <= TRUNC(SYSDATE)
                                           AND P.DATEEND >= TRUNC(SYSDATE))
                           THEN 0 ELSE 1 END,
                      M.SUPPLIER_CODE) AS RN
      FROM IM_ITEM_MASTER M
     WHERE M.ORDER_RATE > 0
       AND M.ORDER_RATE <= 100
       AND M.DATESET <= TRUNC(SYSDATE)
       AND M.DATEEND >= TRUNC(SYSDATE)
       AND M.ORGANIZATION_ID = :organizationId)
 WHERE RN = 1`;

export interface ComputeOptions {
  source: PlanSource;
  arms: InventoryArm[];
  distinctMfs: boolean;
  applyLeadTime: boolean;
  applyCalendar: boolean;
}

/**
 * 계획 → BOM 재귀 전개 → 소요량(REQO) 까지의 CTE.
 * 바인드: :dateFrom, :dateTo ('YYYY-MM-DD'), :itemPattern, :organizationId.
 */
export function requirementCtes(source: PlanSource): string {
  const src = PLAN_SOURCES[source];
  const assy = src.explodeAll ? '' : "AND NVL(B.ASSY_EXPLOSION_YN, 'N') = 'Y'";
  return `PLN AS (${src.sql}),
ROOTS AS (SELECT DISTINCT ITEM_CODE AS ROOT_ITEM, PLAN_DATE AS BOM_DATE FROM PLN),
BOMX (ROOT_ITEM, BOM_DATE, PARENT_ITEM_CODE, CHILD_ITEM_CODE, BOM_LINE_TYPE, QTY) AS (
  SELECT R.ROOT_ITEM, R.BOM_DATE, B.PARENT_ITEM_CODE, B.CHILD_ITEM_CODE, B.LINE_TYPE, 1
    FROM ROOTS R
    JOIN ID_ENG_BOM B
      ON B.CHILD_ITEM_CODE = R.ROOT_ITEM
     AND B.PARENT_ITEM_CODE = (SELECT MAX(X.PARENT_ITEM_CODE) FROM ID_ENG_BOM X
                                WHERE X.CHILD_ITEM_CODE = R.ROOT_ITEM
                                  AND TRUNC(X.DATESET) <= R.BOM_DATE
                                  AND NVL(X.DATEEND, DATE '9999-12-31') >= R.BOM_DATE
                                  AND X.ORGANIZATION_ID = :organizationId)
     AND TRUNC(B.DATESET) <= R.BOM_DATE
     AND NVL(B.DATEEND, DATE '9999-12-31') >= R.BOM_DATE
     AND B.ORGANIZATION_ID = :organizationId
  UNION ALL
  SELECT P.ROOT_ITEM, P.BOM_DATE, B.PARENT_ITEM_CODE, B.CHILD_ITEM_CODE, B.LINE_TYPE,
         P.QTY * NVL(DECODE(B.CHILD_ITEM_CODE, P.ROOT_ITEM, 1, B.ITEM_UNIT_QTY), 0)
    FROM BOMX P
    JOIN ID_ENG_BOM B
      ON B.PARENT_ITEM_CODE = P.CHILD_ITEM_CODE
     AND TRUNC(B.DATESET) <= P.BOM_DATE
     AND NVL(B.DATEEND, DATE '9999-12-31') >= P.BOM_DATE
     AND B.ORGANIZATION_ID = :organizationId
     ${assy}
) CYCLE CHILD_ITEM_CODE SET IS_CYCLE TO 'Y' DEFAULT 'N',
REQ AS (
  -- 같은 전개 안에서 하위를 가진 행(모델 자신·반제품)은 자재가 아니므로 뺀다.
  -- 거래유형은 재고·단가가 쓰는 품목 기준정보 값 (구매구분은 보지 않는다 — 2026-09-30).
  SELECT P.REQ_DATE, P.MFS, X.CHILD_ITEM_CODE AS ITEM_CODE,
         NVL((SELECT MAX(I.LINE_TYPE) FROM ID_ITEM I
               WHERE I.ITEM_CODE = X.CHILD_ITEM_CODE
                 AND I.ORGANIZATION_ID = :organizationId), X.BOM_LINE_TYPE) AS LINE_TYPE,
         P.PLAN_DATE, X.QTY * P.QTY AS REQ_QTY,
         P.ITEM_CODE AS SET_ITEM_CODE, X.PARENT_ITEM_CODE
    FROM PLN P
    JOIN BOMX X
      ON X.ROOT_ITEM = P.ITEM_CODE
     AND X.BOM_DATE = P.PLAN_DATE
     AND X.IS_CYCLE = 'N'
   WHERE NOT EXISTS (SELECT 'X' FROM BOMX Z
                      WHERE Z.ROOT_ITEM = X.ROOT_ITEM
                        AND Z.BOM_DATE = X.BOM_DATE
                        AND Z.PARENT_ITEM_CODE = X.CHILD_ITEM_CODE)
),
REQO AS (
  SELECT REQ_DATE, MFS, ITEM_CODE, LINE_TYPE, PLAN_DATE, SUM(REQ_QTY) AS REQ_QTY,
         MAX(SET_ITEM_CODE) AS SET_ITEM_CODE, MAX(PARENT_ITEM_CODE) AS PARENT_ITEM_CODE
    FROM REQ
   GROUP BY REQ_DATE, MFS, ITEM_CODE, LINE_TYPE, PLAN_DATE
)`;
}

/** BOM 이 없어 전개에서 빠지는 계획 제품 (BOM_EXPLOSION 이 -100 을 주는 경우와 같다). */
export function skippedItemsSql(source: PlanSource): string {
  return `WITH PLN AS (${PLAN_SOURCES[source].sql})
SELECT DISTINCT P.ITEM_CODE AS "itemCode"
  FROM PLN P
 WHERE NOT EXISTS (SELECT 'X' FROM ID_ENG_BOM B
                    WHERE B.CHILD_ITEM_CODE = P.ITEM_CODE
                      AND TRUNC(B.DATESET) <= P.PLAN_DATE
                      AND NVL(B.DATEEND, DATE '9999-12-31') >= P.PLAN_DATE
                      AND B.ORGANIZATION_ID = :organizationId)
 ORDER BY 1`;
}

/** 수량이 비어 있는 계획 (수기계획에서만 생길 수 있다). */
export function nullQtySql(source: PlanSource): string {
  return `WITH PLN AS (${PLAN_SOURCES[source].sql})
SELECT MIN(ITEM_CODE) AS "itemCode" FROM PLN WHERE QTY IS NULL`;
}

/**
 * 발주 줄 계산 SELECT. 재고 차감·올림 전 단계까지 — 줄마다 소요량, 재고 가지별 수량,
 * 발주속성, 보정된 납기, 단가를 붙인다. 정렬은 차감 순서(품목·거래유형·납기)다.
 * 추가 바인드: :orderRule, :orderDate ('YYYY-MM-DD').
 */
export function orderLinesSql(opt: ComputeOptions): string {
  const grp = opt.distinctMfs
    ? `SELECT ITEM_CODE, MIN(PLAN_DATE) AS DELIVERY_DATE, LINE_TYPE, SUM(REQ_QTY) AS ORDER_QTY,
              '*' AS MFS, MAX(SET_ITEM_CODE) AS SET_ITEM_CODE, MAX(PARENT_ITEM_CODE) AS PARENT_ITEM_CODE
         FROM REQO
        WHERE ITEM_CODE IN (${ORDER_RULE_ITEMS_SQL})
        GROUP BY ITEM_CODE, LINE_TYPE`
    : `SELECT ITEM_CODE, PLAN_DATE AS DELIVERY_DATE, LINE_TYPE, SUM(REQ_QTY) AS ORDER_QTY,
              MFS, MAX(SET_ITEM_CODE) AS SET_ITEM_CODE, MAX(PARENT_ITEM_CODE) AS PARENT_ITEM_CODE
         FROM REQO
        WHERE ITEM_CODE IN (${ORDER_RULE_ITEMS_SQL})
        GROUP BY MFS, PLAN_DATE, ITEM_CODE, LINE_TYPE`;

  const armJoins = opt.arms
    .map((arm) => `LEFT JOIN (${INVENTORY_ARMS[arm]}) ${ARM_COLUMNS[arm]}
           ON ${ARM_COLUMNS[arm]}.ITEM_CODE = L.ITEM_CODE AND ${ARM_COLUMNS[arm]}.LINE_TYPE = L.LINE_TYPE`)
    .join('\n    ');
  const armCols = (Object.keys(ARM_COLUMNS) as InventoryArm[])
    .map((arm) => (opt.arms.includes(arm)
      ? `NVL(${ARM_COLUMNS[arm]}.QTY, 0) AS "${ARM_COLUMNS[arm]}"`
      : `0 AS "${ARM_COLUMNS[arm]}"`))
    .join(',\n           ');

  // 리드타임은 납기를 앞으로 당긴다(자재가 생산 시작 전에 들어와야 한다). 작업일 보정은
  // 당긴 납기가 휴무일이면 일하는 날로 옮기고, 못 찾으면 발주일 전날이다 (PB 와 같다).
  const leadDate = opt.applyLeadTime
    ? `L.DELIVERY_DATE - NVL((SELECT MAX(NVL(B.MANUFACTURE_LEADTIME, 0)) FROM ID_ITEM B
                               WHERE B.ITEM_CODE = L.ITEM_CODE
                                 AND B.DATESET <= TRUNC(SYSDATE)
                                 AND B.DATEEND >= TRUNC(SYSDATE)
                                 AND B.ORGANIZATION_ID = :organizationId), 0)`
    : 'L.DELIVERY_DATE';
  const finalDate = opt.applyCalendar
    ? `NVL(F_GET_DELIVERY_DATE(${leadDate}, :organizationId), TO_DATE(:orderDate, 'YYYY-MM-DD') - 1)`
    : leadDate;

  return `WITH ${requirementCtes(opt.source)},
GRP AS (${grp}),
LN AS (
  SELECT G.ITEM_CODE, G.LINE_TYPE, G.DELIVERY_DATE, G.MFS, G.SET_ITEM_CODE, G.PARENT_ITEM_CODE,
         G.ORDER_QTY AS REQ_QTY,
         NVL(S.SUPPLIER_CODE, '*') AS SUPPLIER_CODE,
         NVL(S.PAYMENT_TYPE, '*') AS PAYMENT_TYPE,
         S.ORDER_RATE,
         DECODE(S.ORDER_RATE, NULL, G.ORDER_QTY, G.ORDER_QTY * S.ORDER_RATE / 100) AS ORDER_QTY
    FROM GRP G
    LEFT JOIN (${ORDER_SUPPLIER_SQL}) S
      ON S.ITEM_CODE = G.ITEM_CODE
),
PR AS (
  -- 유효 단가. 같은 키가 여럿이면 가장 늦게 시작한 단가.
  SELECT SUPPLIER_CODE, ITEM_CODE, LINE_TYPE,
         MAX(DELIVERY) KEEP (DENSE_RANK LAST ORDER BY DATESET) AS DELIVERY,
         MAX(UNIT_PRICE) KEEP (DENSE_RANK LAST ORDER BY DATESET) AS UNIT_PRICE,
         MAX(CURRENCY) KEEP (DENSE_RANK LAST ORDER BY DATESET) AS CURRENCY
    FROM IM_ITEM_UNIT_PRICE
   WHERE DATESET <= TRUNC(SYSDATE)
     AND DATEEND >= TRUNC(SYSDATE)
     AND ORGANIZATION_ID = :organizationId
   GROUP BY SUPPLIER_CODE, ITEM_CODE, LINE_TYPE
),
PLT AS (
  -- 단가표 거래유형. 공급처·거래유형이 정확히 맞는 단가가 없으면 공급처·품목의 거래유형으로
  -- 맞춘다 (PB cb_price_reset). 공급처가 * 이면 거래처를 모르므로 단가를 붙이지 않는다.
  SELECT L.*,
         CASE WHEN L.SUPPLIER_CODE = '*' THEN NULL
              WHEN EXISTS (SELECT 'X' FROM PR WHERE PR.SUPPLIER_CODE = L.SUPPLIER_CODE
                                             AND PR.ITEM_CODE = L.ITEM_CODE
                                             AND PR.LINE_TYPE = L.LINE_TYPE) THEN L.LINE_TYPE
              ELSE (SELECT MIN(PR.LINE_TYPE) FROM PR WHERE PR.SUPPLIER_CODE = L.SUPPLIER_CODE
                                                      AND PR.ITEM_CODE = L.ITEM_CODE) END AS PRICE_LINE_TYPE
    FROM LN L
)
SELECT L.ITEM_CODE        AS "itemCode",
       I.ITEM_NAME        AS "itemName",
       I.ITEM_SPEC        AS "itemSpec",
       I.ITEM_UOM         AS "itemUom",
       L.LINE_TYPE        AS "lineType",
       L.PRICE_LINE_TYPE  AS "priceLineType",
       L.SUPPLIER_CODE    AS "supplierCode",
       SUP.SUPPLIER_NAME  AS "supplierName",
       L.PAYMENT_TYPE     AS "paymentType",
       L.ORDER_RATE       AS "orderRate",
       L.MFS              AS "mfs",
       L.SET_ITEM_CODE    AS "setItemCode",
       L.PARENT_ITEM_CODE AS "parentItemCode",
       TO_CHAR(L.DELIVERY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "planDate",
       TO_CHAR(${finalDate}, 'YYYY-MM-DD HH24:MI:SS') AS "deliveryDate",
       L.REQ_QTY          AS "requirementQty",
       L.ORDER_QTY        AS "orderQty",
       ${armCols},
       (SELECT CASE WHEN COUNT(*) = 1 THEN MAX(NVL(M.MIM_ORDER_QTY, 0)) ELSE 0 END
          FROM IM_ITEM_MASTER M
         WHERE M.SUPPLIER_CODE = L.SUPPLIER_CODE AND M.ITEM_CODE = L.ITEM_CODE
           AND M.DATESET <= TRUNC(SYSDATE) AND M.DATEEND >= TRUNC(SYSDATE)
           AND M.ORGANIZATION_ID = :organizationId) AS "minQty",
       (SELECT CASE WHEN COUNT(*) = 1 THEN MAX(NVL(M.PACKING_QTY, 0)) ELSE 0 END
          FROM IM_ITEM_MASTER M
         WHERE M.SUPPLIER_CODE = L.SUPPLIER_CODE AND M.ITEM_CODE = L.ITEM_CODE
           AND M.DATESET <= TRUNC(SYSDATE) AND M.DATEEND >= TRUNC(SYSDATE)
           AND M.ORGANIZATION_ID = :organizationId) AS "packQty",
       (SELECT CASE WHEN COUNT(*) = 1 THEN MAX(NVL(M.ORDER_BAD_RATE, 0)) ELSE 0 END
          FROM IM_ITEM_MASTER M
         WHERE M.SUPPLIER_CODE = L.SUPPLIER_CODE AND M.ITEM_CODE = L.ITEM_CODE
           AND M.DATESET <= TRUNC(SYSDATE) AND M.DATEEND >= TRUNC(SYSDATE)
           AND M.ORGANIZATION_ID = :organizationId) AS "badRate",
       (SELECT CASE WHEN COUNT(*) = 1 THEN MAX(U.ITEM_UOM) END FROM ID_ITEM U
         WHERE U.ITEM_CODE = L.ITEM_CODE
           AND U.DATESET <= TRUNC(SYSDATE) AND U.DATEEND >= TRUNC(SYSDATE)
           AND U.ORGANIZATION_ID = :organizationId) AS "orderUom",
       PR.DELIVERY        AS "delivery",
       PR.UNIT_PRICE      AS "unitPrice",
       PR.CURRENCY        AS "currency"
  FROM PLT L
  ${armJoins}
  LEFT JOIN PR
    ON PR.SUPPLIER_CODE = L.SUPPLIER_CODE
   AND PR.ITEM_CODE = L.ITEM_CODE
   AND PR.LINE_TYPE = L.PRICE_LINE_TYPE
  LEFT JOIN (SELECT ITEM_CODE, MAX(ITEM_NAME) AS ITEM_NAME, MAX(ITEM_SPEC) AS ITEM_SPEC,
                    MAX(ITEM_UOM) AS ITEM_UOM
               FROM ID_ITEM WHERE ORGANIZATION_ID = :organizationId GROUP BY ITEM_CODE) I
    ON I.ITEM_CODE = L.ITEM_CODE
  LEFT JOIN ICOM_SUPPLIER SUP
    ON SUP.SUPPLIER_CODE = L.SUPPLIER_CODE
   AND SUP.ORGANIZATION_ID = :organizationId
 ORDER BY L.ITEM_CODE, L.LINE_TYPE, L.DELIVERY_DATE, L.SUPPLIER_CODE, L.MFS`;
}

/** 쓰인 바인드만 골라 준다 — oracledb 는 SQL 에 없는 이름을 넘기면 오류를 낸다. */
export function pickBinds(sql: string, all: Record<string, unknown>): Record<string, unknown> {
  const used: Record<string, unknown> = {};
  for (const [key, value] of Object.entries(all)) {
    if (new RegExp(`:${key}\\b`).test(sql)) used[key] = value;
  }
  return used;
}

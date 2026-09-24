/**
 * @file src/modules/popup-search/popup-search.queries.ts
 * @description 공용 팝업조회 SQL 화이트리스트 (백엔드 전용 — 브라우저로 나가지 않는다)
 *
 * 왜 화이트리스트인가:
 * - PB 팝업은 100개가 넘는다. 팝업마다 엔드포인트를 만들면 컨트롤러가 폭발한다.
 * - 그래서 엔드포인트는 1개로 두고, **클라이언트는 쿼리명과 필터값만** 보낸다.
 *   컬럼명·테이블명·정렬·연산자·SQL 조각은 절대 받지 않는다.
 *
 * 규칙:
 * 1. `sql` 은 **SELECT 로 시작하는 정적 문자열**이다. 값 결합(템플릿 보간) 금지 — 바인드만 쓴다.
 * 2. 컬럼 별칭은 카탈로그(`@smt/shared` POPUP_CATALOG)의 `columns[].key` 와 같아야 한다.
 * 3. `binds` 는 카탈로그 엔트리의 `filters[].key` 와 1:1 이다 (테스트가 검사한다).
 * 4. 모든 쿼리는 `:organizationId` 로 테넌트를 제한한다. 이 값은 토큰에서 온다.
 * 5. 쿼리명은 카탈로그의 `query` 와 같아야 한다.
 *
 * SQL 은 PB 원본(`.srd` 의 retrieve 인자)을 유지한다. PB 가 코드는 앞자리 LIKE,
 * 명칭은 부분 LIKE 로 찾았으므로 `match` 도 그대로 맞춘다.
 */

/** 바인드 값을 LIKE 패턴으로 만드는 방식 — PB retrieve 인자 형태를 그대로 옮긴다 */
export type BindMatch = 'prefix' | 'contains' | 'exact';

export interface PopupQueryDef {
  /** SELECT 본문 (ORDER BY 제외). 정적 문자열 */
  readonly sql: string;
  /** 정적 ORDER BY 절 (컬럼 목록만) */
  readonly orderBy: string;
  /** 필터 바인드 → 매칭 방식. 키는 카탈로그 filters[].key */
  readonly binds: Readonly<Record<string, BindMatch>>;
}

const SUPPLIER_SEARCH: PopupQueryDef = {
  sql: `
    SELECT s.SUPPLIER_CODE      AS "supplierCode",
           s.SUPPLIER_NAME      AS "supplierName",
           s.SUPPLIER_NAME_ENG  AS "supplierNameEng",
           s.BUSINESS_NO        AS "businessNo",
           s.OWNER_NAME         AS "ownerName",
           s.TEL_NO             AS "telNo"
      FROM ICOM_SUPPLIER s
     WHERE s.ORGANIZATION_ID = :organizationId
       AND s.SUPPLIER_CODE <> '*'
       AND UPPER(s.SUPPLIER_CODE) LIKE :supplierCode
       AND UPPER(s.SUPPLIER_NAME) LIKE :supplierName`,
  orderBy: 's.SUPPLIER_CODE',
  binds: { supplierCode: 'prefix', supplierName: 'contains' },
};

/** 금형 공급처 — 공급처 팝업과 같지만 PB 가 업종(BUSINESS_CATEGORY='M')으로 한 번 더 거른다 */
const MOLD_SUPPLIER_SEARCH: PopupQueryDef = {
  sql: `
    SELECT s.SUPPLIER_CODE      AS "supplierCode",
           s.SUPPLIER_NAME      AS "supplierName",
           s.SUPPLIER_NAME_ENG  AS "supplierNameEng",
           s.BUSINESS_NO        AS "businessNo",
           s.OWNER_NAME         AS "ownerName",
           s.TEL_NO             AS "telNo"
      FROM ICOM_SUPPLIER s
     WHERE s.ORGANIZATION_ID = :organizationId
       AND s.BUSINESS_CATEGORY = 'M'
       AND UPPER(s.SUPPLIER_CODE) LIKE :supplierCode
       AND UPPER(s.SUPPLIER_NAME) LIKE :supplierName`,
  orderBy: 's.SUPPLIER_CODE',
  binds: { supplierCode: 'prefix', supplierName: 'contains' },
};

const CUSTOMER_SEARCH: PopupQueryDef = {
  sql: `
    SELECT c.CUSTOMER_CODE      AS "customerCode",
           c.CUSTOMER_NAME      AS "customerName",
           c.CUSTOMER_NAME_ENG  AS "customerNameEng",
           c.BUSINESS_NO        AS "businessNo",
           c.OWNER_NAME         AS "ownerName",
           c.TEL_NO             AS "telNo"
      FROM ICOM_CUSTOMER c
     WHERE c.ORGANIZATION_ID = :organizationId
       AND c.CUSTOMER_CODE <> '*'
       AND UPPER(c.CUSTOMER_CODE) LIKE :customerCode
       AND UPPER(c.CUSTOMER_NAME) LIKE :customerName
       AND UPPER(NVL(c.SALE_CHARGE, '*')) LIKE :saleCharge`,
  // PB d_com_customer_popup 의 sort="business_type A customer_code A" 를 유지한다.
  orderBy: 'c.BUSINESS_TYPE, c.CUSTOMER_CODE',
  binds: { customerCode: 'prefix', customerName: 'contains', saleCharge: 'contains' },
};

/** 쿼리명 → SQL 정의. 카탈로그의 `query` 와 짝이 맞아야 한다 */
export const POPUP_QUERIES: Readonly<Record<string, PopupQueryDef>> = {
  'supplier-search': SUPPLIER_SEARCH,
  'mold-supplier-search': MOLD_SUPPLIER_SEARCH,
  'customer-search': CUSTOMER_SEARCH,
};

/** SELECT 전용인지 검사한다 — 등록 시점에 한 번, 그리고 테스트에서 다시 */
export function assertSelectOnly(name: string, def: PopupQueryDef): void {
  const sql = def.sql.trim();
  if (!/^SELECT\s/i.test(sql)) {
    throw new Error(`팝업 쿼리 ${name}: SELECT 로 시작해야 합니다.`);
  }
  if (sql.includes(';')) {
    throw new Error(`팝업 쿼리 ${name}: 세미콜론을 포함할 수 없습니다.`);
  }
  if (/\b(INSERT|UPDATE|DELETE|MERGE|TRUNCATE|DROP|ALTER|CREATE|GRANT|BEGIN|EXECUTE)\b/i.test(sql)) {
    throw new Error(`팝업 쿼리 ${name}: 조회 외 구문을 포함할 수 없습니다.`);
  }
  if (!sql.includes(':organizationId')) {
    throw new Error(`팝업 쿼리 ${name}: :organizationId 로 테넌트를 제한해야 합니다.`);
  }
  if (!/^[A-Za-z0-9_.,\s"]+$/.test(def.orderBy)) {
    throw new Error(`팝업 쿼리 ${name}: orderBy 에는 컬럼 목록만 올 수 있습니다.`);
  }
}

for (const [name, def] of Object.entries(POPUP_QUERIES)) {
  assertSelectOnly(name, def);
}

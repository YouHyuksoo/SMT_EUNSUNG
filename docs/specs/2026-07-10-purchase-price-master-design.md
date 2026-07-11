# 구매단가관리 (기준정보) — Design Spec

- **작성일**: 2026-07-10
- **작성자**: hsyou + Claude (브레인스토밍)
- **상태**: Draft (오빠 승인 완료, 구현계획 대기)
- **대상 테이블**: `IM_ITEM_UNIT_PRICE` (은성 ESDB, `INFINITY21_JSMES`)
- **MENU_CODE**: `MST_PURCHASE_PRICE` / **경로**: `/master/purchase-price`

---

## 1. 목적과 범위

기준정보에 **구매단가관리** 화면을 추가한다. 품목별·공급사별 구매단가를 조회하고 신규 단가를 등록·수정한다.

### 범위에 포함
- 목록 조회 (기준일자 기준 유효단가 필터)
- 신규 단가 등록
- 기존 단가 수정
- 저장 전 영향도 미리보기

### 범위에서 제외 (근거와 함께)
- **삭제(DELETE)** — DELETE 트리거가 없어 직전 행의 `DATEEND` 복원과 입고 금액 되돌리기가 불가능하다. 물리 삭제를 열면 데이터가 훼손된다.
- **단가변경 승인 워크플로우** — `PRICE_CHANGE_CONFIRM_YN` 등 승인 컬럼은 존재하나 5,303행 전부 `N`이고 `CONFIRM_BY`/`APPROVAL_NO`가 비어 있다. 현장 미사용 기능이므로 목록·폼에 표시만 하고 승인 액션은 만들지 않는다.
- **엑셀 일괄등록** — 아래 §2의 `ORA-04091` 제약 때문에 별도 설계가 필요하다.

---

## 2. 핵심 전제 — DB 트리거가 업무 규칙의 주인이다

`IM_ITEM_UNIT_PRICE`는 순수 기준정보 테이블이 **아니다**. `ENABLED` 상태의 BEFORE ROW 트리거 2개가 붙어 있다.

### `TRG_IM_ITEM_UNIT_PRICE_INS` (BEFORE INSERT FOR EACH ROW)

1. **입고 금액 소급 갱신** — `IM_ITEM_RECEIPT`에서 같은 (품목·공급사·구입유형·조직)이면서 `RECEIPT_DATE`가 `:NEW.DATESET` ~ `TRUNC(SYSDATE)` 범위인 행의 `UNIT_PRICE`, `RECEIPT_AMT`, `FOREIGN_RECEIPT_AMT`, `CURRENCY`를 새 단가로 덮어쓴다.
2. **직전 단가 자동 마감** — 같은 키의 기간이 겹치는 기존 행(`DATESET <= :NEW.DATESET AND DATEEND >= :NEW.DATESET`)의 `DATEEND`를 `:NEW.DATESET - 1`로 UPDATE한다.

### `TRG_IM_ITEM_UNIT_PRICE_UPD` (BEFORE UPDATE OF DATESET, UNIT_PRICE, CURRENCY)

`IM_ITEM_RECEIPT` 소급 갱신만 수행한다 (자기 테이블 마감 없음).

### 여기서 따라오는 설계 제약

| 제약 | 근거 |
|---|---|
| 서비스에 마감·겹침검증·금액재계산 로직을 **넣지 않는다** | 트리거가 이미 수행. 중복 구현 시 이중 마감 |
| INSERT는 **단일행 `INSERT ... VALUES`만** (TypeORM `save()` 1건씩) | BEFORE ROW 트리거가 자기 테이블을 UPDATE → 다중행 INSERT는 `ORA-04091` (mutating table) |
| DELETE 미제공 | 복원 트리거 부재 (§1) |
| `ORA-20003` / `ORA-04091` 원문 보존 | 트리거가 모든 예외를 `raise_application_error(-20003, SQLERRM)`으로 감싼다. `Database query failed`로 뭉개면 원인 추적 불가 |
| 미리보기는 읽기전용, 저장과 트랜잭션으로 묶지 않는다 | 미리보기는 조회 API, 저장은 별도 요청 |

**검증 근거**: 5,303행 중 기간이 겹치는 쌍은 단 1건. 현장 규율이 아니라 트리거가 강제한 결과다.

---

## 3. 데이터 모델 (실측)

### `IM_ITEM_UNIT_PRICE` (5,303행 / 품목 4,124종 / 공급사 74곳)

**PK (5컬럼 복합)**: `DATESET` + `ITEM_CODE` + `SUPPLIER_CODE` + `LINE_TYPE` + `ORGANIZATION_ID`

| 컬럼 | 타입 | Null | 설명 |
|---|---|---|---|
| DATESET | DATE | N | 시작일자 (PK) |
| ITEM_CODE | VARCHAR2(20) | N | 품목코드 (PK) → `ID_ITEM` |
| SUPPLIER_CODE | VARCHAR2(20) | N | 공급상/제작처 (PK) → `ICOM_SUPPLIER` |
| LINE_TYPE | VARCHAR2(10) | N | 구입유형 (PK) |
| ORGANIZATION_ID | NUMBER | N | 조직ID (PK) |
| DATEEND | DATE | N | 종료일자 (미마감 = `9999-12-31`) |
| UNIT_PRICE | NUMBER | N | 단가 |
| STANDARD_UNIT_PRICE | NUMBER | Y | 기준단가 |
| TAX_RATE | NUMBER | Y | 세율 |
| CURRENCY | VARCHAR2(3) | N | 통화 |
| DELIVERY | VARCHAR2(10) | N | 납선 |
| PRICE_TYPE | VARCHAR2(1) | N | 단가형태 |
| PRICE_CHANGE_REASON | VARCHAR2(10) | N | 단가변경사유 |
| APPROVAL_NO | VARCHAR2(30) | Y | 승인번호 (미사용) |
| PRICE_CHANGE_CONFIRM_YN | VARCHAR2(1) | Y | 단가변경승인구분 (미사용) |
| CONFIRM_BY / CONFIRM_DATE | VARCHAR2(20) / DATE | Y | 승인자/승인일자 (미사용) |
| ENTER_BY / ENTER_DATE | VARCHAR2(20) / DATE | Y | 등록자/등록일자 |
| LAST_MODIFY_BY / LAST_MODIFY_DATE | VARCHAR2(20) / DATE | Y | 최종수정자/최종수정일자 |

**FK**: `R_ITEM_IM_UNIT_PRICE` → `ID_ITEM`, `FK_IM_ITEM_MASTER` → `IM_ITEM_MASTER`

### 코드성 컬럼 — 전부 `ISYS_BASECODE`에 존재

`CODE_TYPE`에 **공백이 포함**된다. 하드코딩 주의.

| 컬럼 | CODE_TYPE | 코드값 |
|---|---|---|
| LINE_TYPE | `LINE TYPE` (11건) | A=외부부품, D=도입(면세), F=무상구매, G=국내구매, L=도입로칼, M=무상사급, N=내부거래, O=OEM, P=도입(과세), T=자작, Y=유상사급 |
| PRICE_TYPE | `PRICE TYPE` (2건) | F=고정단가, T=임시단가 |
| DELIVERY | `DELIVERY` (2건) | 1=수출, 2=내수 |
| CURRENCY | `CURRENCY` (7건) | KRW, USD, JPY, CNY, HKD, VND, WON |
| PRICE_CHANGE_REASON | `PRICE CHANGE REASON` (3건) | N=신규, I=인상, D=인하 |
| PRICE_CHANGE_CONFIRM_YN | `PRICE CHANGE CONFIRM YN` (2건) | Y=승인, N=아니오 |

### 공급사 마스터 — `ICOM_SUPPLIER`

**`PARTNER_MASTERS` 테이블은 은성 DB에 존재하지 않는다** (`ORA-00942`). 기존 `PartnerSelect`/`usePartnerOptions`(`/master/partners`)는 이 화면에 사용할 수 없다. `IM_ITEM_MASTER.SUPPLIER_CODE → ICOM_SUPPLIER` FK가 실제 참조 대상이다.

`ICOM_SUPPLIER`: PK(`SUPPLIER_CODE` VARCHAR2(20), `ORGANIZATION_ID` NUMBER), `SUPPLIER_NAME` VARCHAR2(100)

### `IM_ITEM_RECEIPT` (입고, 1,458,954행)

트리거의 소급 갱신 대상. 인덱스 `INDXIM_ITEM_RECEIPT(ITEM_CODE, LINE_TYPE, RECEIPT_DATE)`가 있어 영향도 조회는 인덱스를 탄다.

---

## 4. 백엔드 설계

기존 좁은 모듈(narrow module) 패턴 + 레거시 테이블 직접 매핑 패턴(`prod-line-master.entity.ts` → `IP_PRODUCT_LINE`)을 따른다.

### 엔티티 (`apps/backend/src/entities/`)

- `purchase-unit-price.entity.ts` → `@Entity({ name: 'IM_ITEM_UNIT_PRICE' })`, `@PrimaryColumn` 5개
- `supplier-master.entity.ts` → `@Entity({ name: 'ICOM_SUPPLIER' })`, `@PrimaryColumn` 2개

감사 컬럼은 `prod-line-master.entity.ts`와 동일하게 `ENTER_BY`/`LAST_MODIFY_BY` + `@CreateDateColumn ENTER_DATE` / `@UpdateDateColumn LAST_MODIFY_DATE`.

### 엔드포인트

`@Controller('master/purchase-prices')`, 테넌트는 `@OrganizationId()` 데코레이터로 주입.

| 메서드 | 경로 | 용도 |
|---|---|---|
| GET | `/master/purchase-prices` | 목록. 필터: `itemCode`, `supplierCode`, `lineType`, `priceType`, `baseDate`, `validOnly` |
| GET | `/master/purchase-prices/impact` | 저장 전 영향도 미리보기 (읽기전용) |
| POST | `/master/purchase-prices` | 등록 (단일행) |
| PUT | `/master/purchase-prices` | 수정 (복합키를 body로 전달) |
| GET | `/master/suppliers` | 공급사 목록 (`ICOM_SUPPLIER`) |

`PUT`에 `:id`를 쓰지 않는다. 키가 4개(+조직)라 경로 인코딩이 지저분해진다. `prod-line`은 키가 `lineCode` 하나여서 `:id`가 성립했지만 여기선 성립하지 않는다. `UpdatePurchasePriceDto`가 복합키를 필수 필드로 포함한다.

### 목록 쿼리

`baseDate`가 주어지면 `DATESET <= :baseDate AND DATEEND >= :baseDate`로 유효 단가만 반환. 공급사명은 `ICOM_SUPPLIER` LEFT JOIN, 품목명은 `ID_ITEM` LEFT JOIN으로 함께 내려준다.

### 영향도 미리보기 쿼리

트리거가 무엇을 할지 그대로 재현하되 **읽기만** 한다.

```sql
-- (1) 자동 마감될 기존 단가 행
SELECT DATESET, DATEEND, UNIT_PRICE
  FROM IM_ITEM_UNIT_PRICE
 WHERE ITEM_CODE = :itemCode
   AND SUPPLIER_CODE = :supplierCode
   AND LINE_TYPE = :lineType
   AND ORGANIZATION_ID = :organizationId
   AND DATESET <= :dateset
   AND DATEEND >= :dateset;

-- (2) 금액이 재계산될 입고 건수/합계
SELECT COUNT(*) AS AFFECTED_ROWS, SUM(RECEIPT_AMT) AS AFFECTED_AMT
  FROM IM_ITEM_RECEIPT
 WHERE ITEM_CODE = :itemCode
   AND LINE_TYPE = :lineType
   AND SUPPLIER_CODE = :supplierCode
   AND ORGANIZATION_ID = :organizationId
   AND RECEIPT_DATE >= :dateset
   AND RECEIPT_DATE <= TRUNC(SYSDATE);
```

### 에러 처리

`catch (error: unknown)`으로 받아 `ORA-20003`/`ORA-04091` 원문을 응답에 실어 보낸다. `as any` 금지.

### 등록 위치

- `apps/backend/src/modules/master/master-purchase-price.module.ts` (신규 좁은 모듈)
- `apps/backend/src/app.module.ts` — imports에 추가
- `apps/backend/src/database/database.module.ts` — **`entities` 명시 배열에 두 엔티티 추가 (누락 시 런타임 실패)**

DB는 `synchronize: false`. 테이블은 이미 존재하므로 DDL 불필요.

---

## 5. 프론트엔드 설계

`apps/frontend/src/app/(authenticated)/master/purchase-price/`

| 파일 | 역할 |
|---|---|
| `page.tsx` | 화면 컨테이너. 단일 그리드 + 기준일 필터, 우측 슬라이드 폼 패널 |
| `purchasePriceColumns.tsx` | `createPurchasePriceGridColumns({t, onEdit})` → `ColumnDef[]` |
| `components/PurchasePriceFormPanel.tsx` | 등록/수정 슬라이드 패널 + 영향도 확인 모달 |

### 필터바

기준일자(`DateFilter`), 품목(`PartSearchModal` — 4,124종이라 `usePartOptions`의 `limit=100` 드롭다운은 부적합), 공급사(`SupplierSelect` 신규), 구입유형(`ComCodeSelect groupCode="LINE TYPE"`), 단가형태(`ComCodeSelect groupCode="PRICE TYPE"`), "유효단가만" 체크박스.

### 그리드 컬럼

품목코드/품목명, 공급사코드/공급사명, 구입유형, 시작일자, 종료일자, 단가, 기준단가, 통화, 세율, 단가형태, 납선, 단가변경사유, 승인여부, 등록자/등록일자.

### 저장 플로우

1. 폼에서 저장 클릭
2. `GET /master/purchase-prices/impact` 호출
3. `ConfirmModal`로 표시: *"기존 단가 N건이 YYYY-MM-DD로 마감되고, 입고 M건(합계 ₩X)의 금액이 재계산됩니다."*
4. 확인 시 `POST` / `PUT`

`alert()`/`confirm()` 대신 프로젝트 `ConfirmModal`을 쓴다.

### 공용 컴포넌트 신규

`apps/frontend/src/components/shared/SupplierSelect.tsx` + `useSupplierOptions` 훅 (`apps/frontend/src/hooks/useMasterOptions.ts`에 추가). `/master/suppliers` 조회.

---

## 6. 등록 동기화 체크리스트

`MST_PURCHASE_PRICE` / `/master/purchase-price` 철자를 아래 전부에서 일치시킨다.

- [ ] `apps/frontend/src/config/menuConfig.ts` — MASTER children에 `{ code: "MST_PURCHASE_PRICE", labelKey: "menu.master.purchasePrice", path: "/master/purchase-price" }`
- [ ] `apps/backend/src/seeds/menu-config.json` — `childMenuCodes.MASTER`에 `"MST_PURCHASE_PRICE"`
- [ ] `apps/frontend/public/help/manifest.json` — master 카테고리 items
- [ ] `apps/frontend/public/help/user/ko/MST_PURCHASE_PRICE.md`
- [ ] `apps/frontend/public/help/operator/ko/MST_PURCHASE_PRICE.md`
- [ ] `apps/frontend/src/locales/{ko,en,zh,vi}.json` — `menu."master.purchasePrice"` + `master.purchasePrice.*`
- [ ] `apps/backend/src/app.module.ts`
- [ ] `apps/backend/src/database/database.module.ts` (entities 배열)

---

## 7. 검증 기준

- [ ] `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`
- [ ] `pnpm --filter @eunsung/frontend exec tsc --noEmit --pretty false`
- [ ] 목록 조회: 기준일자 필터로 유효단가만 반환되는지 실제 데이터로 확인
- [ ] 영향도 미리보기: 알려진 품목(`M2014700034`/`IP`/`Y` — 이력 3건)으로 마감 대상 행이 정확히 나오는지 확인
- [ ] 등록: 단일행 INSERT가 `ORA-04091` 없이 성공하고, 트리거가 직전 행 `DATEEND`를 실제로 마감했는지 DB에서 pre/post 확인
- [ ] 에러: 의도적 위반(예: 존재하지 않는 `ITEM_CODE`)으로 `ORA-20003` 원문이 UI까지 전달되는지 확인
- [ ] 렌더된 화면 확인 (`claude-in-chrome`)

**주의**: 등록 검증은 운영 데이터(`IM_ITEM_RECEIPT` 146만 행)를 실제로 갱신한다. 테스트용 품목·공급사 조합을 정하고 사전에 오빠 승인을 받은 뒤 수행한다.

---

## 8. 별개 이슈 (이번 범위 밖, 기록만)

기존 `PartnerSelect` / `usePartnerOptions`가 호출하는 `/master/partners`는 `PARTNER_MASTERS` 테이블을 조회하는데, 이 테이블이 은성 DB에 없다(`ORA-00942`). 해당 컴포넌트를 쓰는 화면들이 은성 사이트에서 정상 동작하는지 별도 확인이 필요하다.

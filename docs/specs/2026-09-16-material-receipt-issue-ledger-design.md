# 자재입출고수불원장 (MAT_RECEIPT_ISSUE_LEDGER) 설계

## 사용자 승인과 범위

PowerBuilder 동적 메뉴의 `자재입출고수불원장`(`ISYS_DYNAMIC_MENU.MENU_ITEM_TEXT`, `MENU_TAG = w_mat_ledger_report`) 화면을 Next.js + NestJS로 이식한다. 사용자는 아래를 승인했다.

1. 레거시 창의 **라디오 5모드 전부**를 구현한다. 한 화면에서 모드를 전환하는 레거시 구조를 유지한다.
2. 실제 필터링에 쓰이지 않는 파라미터는 제거한다. `arg_etc_line`은 모든 모드에서, `arg_keyitem_yn`은 SQL이 쓰지 않는 모드 1·2에서 제거한다 (모드 3·4·5는 실사용이므로 유지).
3. 검증 DB는 `JSIDCESDB`(ESDBPDB)를 그대로 쓴다. 데이터가 없는 모드는 검증 한계를 명시한다.

범위 밖: 자재 입고/출고 등록·수정 기능, 월마감 적재 로직, `IM_ITEM_LEDGER` 기반 원장(본 화면과 무관한 별개 DataWindow다).

## 근거 자료

레거시 원본은 PBL 스냅샷에 export되어 있지 않아 `infinity21_uw_mat.pbl`, `infinity21_urd_com.pbl`에서 PBORCA로 읽기 전용 export하여 확인했다. 원본 PBL은 변경하지 않았다.

- 창: `w_mat_ledger_report` (title `Material Receipt Issue Ledger Report`), `infinity21_uw_mat.pbl`
- DataWindow 5종: `d_mat_daily_receipt_issue_rpt`, `d_mat_ws_receipt_issue_rpt`, `d_mat_receipt_barcode_rpt`, `d_mat_item_feeder_layout_detail_rpt`, `d_mat_item_issue_loss_lst`
- 레거시 SQL 원본 스냅샷은 `docs/sql/`에 보관한다.

## 모드 구성

레거시 `w_mat_ledger_report`의 라디오 버튼이 `dw_1` ~ `dw_5`를 `bringtotop`으로 전환한다. 웹에서는 탭으로 구현한다.

| 모드 | 레거시 컨트롤 | DataWindow | 원천 테이블 | 표시 컬럼 |
|---|---|---|---|---|
| 수불원장 (기본) | `rb_master` / `dw_1` | `d_mat_daily_receipt_issue_rpt` | `IM_ITEM_RECEIPT` ∪ `IM_ITEM_ISSUE` | 33 |
| 공정 수불원장 | (else) / `dw_5` | `d_mat_ws_receipt_issue_rpt` | `IM_ITEM_WORKSTAGE_RECEIPT` ∪ `IM_ITEM_WORKSTAGE_ISSUE` | 9 |
| 입고 바코드 | `rb_barcode` / `dw_2` | `d_mat_receipt_barcode_rpt` | `IM_ITEM_RECEIPT_BARCODE` | 27 |
| 라인 피더 레이아웃 | `rb_line_inventory` / `dw_3` | `d_mat_item_feeder_layout_detail_rpt` | `ID_ENG_BOM_SMT` | 8 |
| 출고 로스 | `rb_issue_loss` / `dw_4` | `d_mat_item_issue_loss_lst` | `IM_ITEM_ISSUE_LOSS` | 13 |

## 모드 1 — 수불원장 (본체)

### 쿼리 계약

`IM_ITEM_RECEIPT`를 `'R'`, `IM_ITEM_ISSUE`를 `'I'`로 `RCV_ISS_CODE` 부여하여 `UNION ALL`한 인라인 뷰 `A`에, `ID_ITEM B`(inner join, `ITEM_CODE` + `ORGANIZATION_ID`)와 `IM_ITEM_RECEIPT_BARCODE C`(outer join, `ITEM_CODE` + `MATERIAL_MFS = C.LOT_NO`)를 붙인다. 레거시 조인 형태를 그대로 유지한다.

기간은 **일자 범위**다. 월 단위가 아니다.

```
RECEIPT_DATE >= :dateFrom AND RECEIPT_DATE < :dateTo + 1
ISSUE_DATE   >= :dateFrom AND ISSUE_DATE   < :dateTo + 1
```

정렬은 레거시 그대로 `ORGANIZATION_ID ASC, ENTER_DATE ASC, RECEIPT_ISSUE_DATE DESC, RECEIPT_ISSUE_SEQUENCE DESC`.

### 바인드 파라미터

레거시 17개 중 실사용 15개를 채택한다.

| 파라미터 | 적용 위치 | 의미 |
|---|---|---|
| `dateFrom` / `dateTo` | 두 분기 각각 | 조회 기간 (일자) |
| `itemCode` | 두 분기 | 품목코드 `LIKE`. 레거시는 빈 값이면 `'%'` |
| `lotNo` | 두 분기 | `MATERIAL_MFS LIKE` |
| `locationCode` | 두 분기 | 창고 `LIKE` |
| `inventoryType` | 두 분기 | `NVL(INVENTORY_TYPE,'*') LIKE` |
| `organizationId` | 두 분기 | 조직 (= 컨텍스트) |
| `supplierCode` | 입고 분기 | `NVL(SUPPLIER_CODE,'*') LIKE` |
| `fromSupplierCode` | 입고 분기 | `NVL(FROM_SUPPLIER_CODE,'*') LIKE` |
| `lineCode` | 출고 분기 | `LINE_CODE LIKE` |
| `workstageCode` | 출고 분기 | `WORKSTAGE_CODE LIKE` |
| `supplierIssue` | 출고 분기 | 출고측 `NVL(SUPPLIER_CODE,'*') LIKE` |
| `issueDeficit` | 출고 분기 | `ISSUE_DEFICIT LIKE` (3=출고+, 4=출고-) |
| `includeW00` | 출고 분기 | `'N'`이면 `WORKSTAGE_CODE <> 'W00'` |
| `rcvIssCode` | UNION **밖** | `A.RCV_ISS_CODE LIKE` (R=입고, I=출고) |

`rcvIssCode`(레거시 `arg_deficit`)와 `issueDeficit`(레거시 `arg_issue_deficit`)는 이름이 비슷하나 적용 위치와 의미가 다르다. 혼동 금지.

### 제거하는 파라미터와 근거

- `arg_etc_line` (`stringlist`): 창의 인스턴스 변수 `ivs_line_code`로 전달되는데, `open` 이벤트에서 `ivs_line_code[1] = '%'`로 설정된 뒤 창 어디에서도 재할당되지 않는다. 따라서 `LINE_CODE NOT IN ('%')`는 어떤 행도 제외하지 않는 사(死)조건이다. PB `stringlist`는 `dataSource.query` 바인드로 옮길 수단도 없다. 제거한다.
- `arg_keyitem_yn`: 이 DataWindow의 `retrieve` SQL 본문에 0회 등장한다(선언·전달만 됨). 모드 2도 같은 이유로 쓰지 않으므로 **모드 1·2에서 제거**한다. 모드 3·4·5에서는 `NVL(ID_ITEM.KEYITEM_YN,'N') LIKE`로 실제 사용되므로 유지한다.

### 표시 컬럼 (33)

`No`(행번호) · `Inventory Type` · `Location Code` · `Label Type` · `Receipt Type` · `Lot Divide Yn` · `Line Code` · `Feeder Location Code` · `Feeder Shaft` · `From Supplier Code` · `Model Name` · `Rcv Iss Code` · `Enter Date` · `Location Address` · `Item Code` · `Material mfs` · `Manufacture Week` · `Item Name` · `Item Spec` · `Qty` · `Receipt Issue Deficit` · `Invoice No` · `Workstage Code` · `Supplier Code` · `Receipt Issue Type` · `Receipt Issue Status` · `Barcode` · `Origin Mfs` · `Vendor Lotno` · `Vendor Code` · `LED Rank Info` · `Feeding Date` · `Destroy Date`

`Qty` 포맷은 `###,###,##0`, 일시 컬럼(`Enter Date`, `Feeding Date`, `Destroy Date`)은 날짜+시각이다.

이 중 `Label Type`, `Receipt Type`, `Lot Divide Yn`, `Manufacture Week`, `Vendor Lotno`, `Vendor Code`, `LED Rank Info`, `Feeding Date`, `Destroy Date` 9개는 `IM_ITEM_RECEIPT_BARCODE`에서만 나온다.

### 바코드 조인 판단

`IM_ITEM_RECEIPT_BARCODE`에는 PK·UK가 하나도 없다(`user_constraints` 조회 결과 0건). `(ITEM_CODE, LOT_NO)`가 중복되면 outer join이 행을 배수로 늘린다. 그럼에도 **레거시 조인을 그대로 유지한다**: 표시 컬럼 9개가 이 테이블에서만 나와 제거가 불가능하고, 이 화면은 합계가 아니라 트랜잭션 나열이라 중복 행이 눈에 보이는 형태로 드러난다. 의도적 결정으로 기록한다.

`ID_ITEM`은 레거시대로 inner join을 유지한다. 품목마스터에 없는 품목의 입출고는 조회되지 않는다.

## 모드 2 — 공정 수불원장

`IM_ITEM_WORKSTAGE_RECEIPT` ∪ `IM_ITEM_WORKSTAGE_ISSUE`, `ID_ITEM` inner join. 정렬은 모드 1과 동일.

레거시는 인자 16개를 전달하지만 SQL이 실제 사용하는 것은 `dateFrom`, `dateTo`, `itemCode`, `organizationId`, `rcvIssCode` 5개뿐이다. 나머지 11개(`lotNo`, `lineCode`, `workstageCode`, `supplierCode`, `fromSupplierCode`, `locationCode`, `supplierIssue`, `issueDeficit`, `etcLine`, `keyitemYn`, `inventoryType`)는 WHERE 절에 없다. 이 모드의 DTO는 실사용 5개만 받는다.

표시 컬럼 9개: `No` · `Rcv Iss Code` · `Enter Date` · `Location Address` · `Item Code` · `Item Name` · `Item Spec` · `Qty` · `Receipt Issue Deficit`

## 모드 3 — 입고 바코드

`IM_ITEM_RECEIPT_BARCODE` + `ID_ITEM`(outer join, `ITEM_CODE`만). 정렬 `SCAN_DATE ASC, LOT_NO ASC`.

파라미터 9개 전부 실사용이다: `dateFrom`, `dateTo`(`SCAN_DATE` 기준, `< :dateTo + 1`), `itemCode`, `lotNo`, `slipNo`(`RECEIPT_SLIP_NO LIKE`), `lotDivide`(`NVL(LOT_DIVIDE_YN,'*') LIKE`), `supplierCode`, `organizationId`, `keyitemYn`(`NVL(ID_ITEM.KEYITEM_YN,'N') LIKE`).

표시 컬럼 27개. 레거시 헤더의 오타(`Iissue Type`, `Iissue Compare Date`)는 번역 라벨에서 바로잡는다.

## 모드 4 — 라인 피더 레이아웃

`ID_ENG_BOM_SMT` + `ID_ITEM`(outer join). 재고 2개 컬럼은 상관 스칼라 서브쿼리다.

- `inventory_qty` = `(SELECT SUM(inventory_qty) FROM IM_ITEM_INVENTORY b WHERE b.item_code = id_eng_bom_smt.child_item_code)`
- `workstage_inventory_qty` = 위와 동일하되 `IM_ITEM_WORKSTAGE_INVENTORY`에 `line_code` 조건 추가

파라미터 3개: `itemCode`(`CHILD_ITEM_CODE LIKE`), `modelName`(`PARENT_ITEM_CODE LIKE`), `keyitemYn`. **조직 필터가 없다** — 레거시 SQL에 `organization_id` 조건은 `ID_ITEM` outer join 조건으로만 들어간다. 레거시 동작을 유지한다.

표시 컬럼 8개: `Item Code` · `Item Name` · `Item Spec` · `Location Address` · `MSL Level` · `Inventory Qty` · `Unit Qty` · `Workstage Inventory Qty`

## 모드 5 — 출고 로스

`IM_ITEM_ISSUE_LOSS` + `ID_ITEM`(outer join). 정렬 `LINE_CODE ASC, ISSUE_DATE ASC, ISSUE_SEQUENCE ASC`.

파라미터 8개 전부 실사용: `dateFrom`, `dateTo`, `lineCode`, `modelName`(`NVL(MODEL_NAME,'*') LIKE`), `itemCode`, `materialMfs`, `organizationId`, `keyitemYn`.

**종료일 경계 결정**: 이 모드만 `ISSUE_DATE < :dateTo`로 다른 모드의 `< :dateTo + 1`과 다르다. 즉 종료일 당일이 결과에서 빠진다. 레거시 동작을 그대로 유지하되, 화면 필터에 종료일이 포함되지 않음을 라벨로 명시한다. 실데이터가 있는 유일한 모드이므로 이 차이가 사용자에게 보인다. 운영 확인 후 `+1`로 통일하려면 별도 변경으로 처리한다.

표시 컬럼 13개: `No` · `Issue Date` · `Issue Sequence` · `Item Code` · `Material Mfs` · `Line Code` · `Model Name` · `Issue Qty` · `Enter Date` · `Enter By` · `Last Modify Date` · `Last Modify By` · `Organization Id`

## 구현 구조

### 백엔드

`apps/backend/src/modules/material/` 신규 모듈. 읽기 전용 조회 엔드포인트 5개(모드당 1개).

`apps/backend/src/modules/master/services/purchase-price.service.ts`의 레거시 `IM_*` 테이블 접근 선례를 따른다.

- `dataSource.query(sql, binds)` named bind
- 조직은 컨트롤러에서 `@OrganizationId()` 데코레이터로 주입 (모드 4 제외)
- `catch (error: unknown)`으로 받아 Oracle `driverError.message` 원문을 보존해 `BadRequestException`으로 변환. `Database query failed` 같은 뭉개진 메시지를 만들지 않는다
- `as any` 금지

모드별 DTO는 각 모드의 실사용 파라미터만 선언한다. 5개 모드가 필터 집합이 서로 다르므로 공통 DTO로 묶지 않는다.

### 프론트엔드

`apps/frontend/src/app/(authenticated)/material/receipt-issue-ledger/`

- `page.tsx`는 레이아웃·모드 전환·상태 배선만 담당한다
- 컬럼 정의는 모드별 파일로 분리한다 (`ledgerColumns.ts`, `wsLedgerColumns.ts`, `barcodeColumns.ts`, `feederLayoutColumns.ts`, `issueLossColumns.ts`)
- 데이터 조회는 모드별 훅으로 분리한다
- 모드 전환은 탭. 필터 패널은 선택된 모드가 실제 사용하는 필터만 노출한다

코드성 값은 자유 입력을 만들지 않고 기존 공통코드·기준정보 선택 컴포넌트를 재사용한다. 레거시 컨트롤과의 대응은 다음과 같다.

| 레거시 컨트롤 | 성격 | 대응 |
|---|---|---|
| `ddlb_deficit`, `ddlb_issue_deficit`, `ddlb_lot_divide`, `ddlb_inventory_type` (`uo_basecode`) | `ISYS_BASECODE` 공통코드 | 공통코드 선택 컴포넌트 |
| `ddlb_line_code` (`uo_line_code`) | 라인 기준정보 | 라인 선택 컴포넌트 |
| `ddlb_workstage_code` (`uo_workstage_code_all`) | 공정 기준정보 | 공정 선택 컴포넌트 |
| `ddlb_supplier_code`, `ddlb_from_supplier_code` (`uo_supplier_code`) | 거래처 기준정보 | 거래처 선택 컴포넌트 |
| `ddlb_item_code` (`uo_item_code`) | 품목 기준정보 | 품목 선택 컴포넌트 |
| `uo_dateset` / `uo_dateend` (`uo_ymd_calendar`) | 일자 | 기존 날짜 입력 |
| `cbx_w00` | 체크박스 | 체크박스 (`includeW00`) |

`ISYS_BASECODE`의 `RECEIPT ISSUE DEFICIT` 코드값은 1=입고, 2=입고반품, 3=출고+, 4=출고-다.

### 메뉴 배선

메뉴코드 `MAT_RECEIPT_ISSUE_LEDGER`, 경로 `/material/receipt-issue-ledger`, `MATERIAL` 카테고리. 이 카테고리는 현재 `menuCodes: []`로 비어 있어 이 화면이 첫 leaf가 된다.

순서를 지킨다.

1. `apps/frontend/src/config/menuConfig.ts`에 leaf 추가
2. `pnpm --filter @eunsung/frontend gen:menu` — `default-menu-category-layout.ts`, `menu-code-validator.ts`, `menu-config.json`이 생성된다. **이 세 파일을 직접 편집하지 않는다**
3. `ko/en/vi/zh.json` 라벨 추가
4. page registry 생성물 갱신
5. `pnpm --filter @eunsung/frontend test`로 구조 테스트 통과 확인

`MATERIAL` 카테고리가 지금까지 leaf 없이 존재했으므로, DB 메뉴 테이블(`MENU_CATEGORY_ITEMS`, `ROLE_MENU_PERMISSIONS`)에 신규 메뉴코드 반영이 필요한지 확인한다.

## 성능

`IM_ITEM_RECEIPT`, `IM_ITEM_ISSUE`는 대형 테이블이다. 구현 전 `RECEIPT_DATE` / `ISSUE_DATE` / `ORGANIZATION_ID` 관련 사용 가능한 인덱스를 확인하고, 기간 필터가 인덱스를 타도록 형태를 맞춘다. 비즈니스 날짜 정의(일자 범위, `< dateTo + 1`)는 유지한 채 쿼리 형태만 조정한다.

조회 기간 무제한을 허용하지 않는다. 기본 기간을 두고, 과도한 범위는 프론트에서 제한한다.

## 검증과 한계

`JSIDCESDB` 기준 원천 테이블 건수(2026-09-16 확인):

| 테이블 | 건수 | 영향 |
|---|---|---|
| `IM_ITEM_RECEIPT` | 0 | 모드 1 입고 분기 검증 불가 |
| `IM_ITEM_ISSUE` | 0 | 모드 1 출고 분기 검증 불가 |
| `IM_ITEM_RECEIPT_BARCODE` | 0 | 모드 1 조인·모드 3 검증 불가 |
| `IM_ITEM_WORKSTAGE_RECEIPT` | 0 | 모드 2 검증 불가 |
| `IM_ITEM_WORKSTAGE_ISSUE` | 0 | 모드 2 검증 불가 |
| `IM_ITEM_INVENTORY` | 0 | 모드 4 재고 서브쿼리 항상 NULL |
| `IM_ITEM_WORKSTAGE_INVENTORY` | 0 | 모드 4 공정재고 서브쿼리 항상 NULL |
| `IM_ITEM_ISSUE_LOSS` | 32,501 | **모드 5 실데이터 검증 가능** |
| `ID_ENG_BOM_SMT` | 28,246 | **모드 4 BOM 골격 검증 가능** |
| `ID_ITEM` | 2,519 | 조인 대상 존재 |

따라서 검증 수준은 모드별로 다르다.

- 모드 4·5: 실데이터로 행 반환·필터 동작·정렬까지 검증한다.
- 모드 1·2·3: SQL이 ORA 오류 없이 실행되고 바인드가 정상 동작하며 0행을 반환하는 것까지만 검증한다. **수치 정합성은 검증할 수 없다.**

Oracle/드라이버 오류(`ORA-*`, `NJS-*`)는 원문 그대로 보존해 보고한다.

코드 검증은 다음을 수행한다.

- `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`
- `pnpm --filter @eunsung/frontend exec tsc --noEmit --pretty false`
- `pnpm --filter @eunsung/backend test` (신규 서비스 spec 포함)
- `pnpm --filter @eunsung/frontend test` (메뉴·페이지 등록 구조 테스트)
- 렌더된 화면 확인 (dev 서버는 사용자가 기동)

## 미해결 사항

- 모드 4의 조직 필터 부재는 레거시 동작을 그대로 옮긴 것이다. 운영에서 다조직 사용 시 의도치 않은 결과가 나올 수 있으나, 이번 범위에서는 변경하지 않는다.
- 모드 5의 종료일 경계(`< :dateTo`)는 위 모드 5 절에서 레거시 유지로 결정했다. 통일 여부는 운영 확인 후 별도 변경 대상이다.

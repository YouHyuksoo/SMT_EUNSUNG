# 제품모델 관리 추가 설계

- **작성일**: 2026-09-05
- **상태**: Draft (범위 승인 완료, 문서 검토 중)
- **PB 기준**: `w_pln_product_model_master`
- **대상 테이블**: `IP_PRODUCT_MODEL_MASTER` 외 연관 이력
- **메뉴 코드/경로**: `MST_PRODUCT_MODEL` / `/master/product-model`
- **메뉴 소유 그룹**: `MASTER` (PB 기준정보 순서상 품목관리 다음)

---

## 1. 목적

PB 기준정보의 `제품모델관리`를 현행 MES 기준정보에 추가한다. 현재 `IP_PRODUCT_MODEL_MASTER`에는 조직 1 기준 312건이 있으나, 현행 코드는 선택 팝업용 4컬럼 공개 조회만 제공한다. 새 화면은 PB의 전체 기능을 최종 범위로 삼되 세 단계로 나눠 안전하게 완성한다.

## 2. 확인된 현재 상태

- PB 메뉴: `M_PRODUCTMODELMASTER` → `w_pln_product_model_master`
- PB 주 테이블: `IP_PRODUCT_MODEL_MASTER` (2026-09-05 라이브 `USER_TAB_COLUMNS` 실측 93개 컬럼; PB master DW 68개, 목록 DW 71개)
- PB 부가 데이터: `IB_SMT_SW`, `IP_PRODUCT_SPEC_CONFIRM_DOC`
- 현행 엔티티: `PART_NO`, `ORGANIZATION_ID`, `MODEL_NAME`, `MODEL_SPEC`, `CUSTOMER_NAME`만 부분 매핑
- 현행 API: `GET /master/product-models`만 제공
- 현행 서비스: 조직을 `1`로 하드코딩
- 현행 컨트롤러: `@Public()` 적용
- 기존 소비자: `ModelSearchModal`을 사용하는 생산 런카드와 OEE 표준시간 화면

## 3. 핵심 결정

### 3.1 기존 API를 호환 확장한다

별도 중복 API를 만들지 않고 `/master/product-models`를 정식 기준정보 CRUD 계약으로 확장한다. 목록 응답에는 기존 `list` 소비자가 사용하는 `partNo`, `modelName`, `modelSpec`, `customerName`을 계속 포함한다. 프론트 선택 모달은 표준 응답 래퍼와 기존 응답을 모두 허용하는 임시 호환 코드를 거친 뒤 정식 응답으로 통일한다.

### 3.2 인증과 조직 경계를 먼저 바로잡는다

`@Public()`과 조직 `1` 하드코딩을 제거하고 `@OrganizationId()`로만 조직을 받는다. body/query의 `organizationId`는 DTO에 노출하지 않는다. 컨트롤러에는 `JwtAuthGuard`가 실제 적용되는 구조와 메타데이터 회귀 테스트를 둔다.

목록·상세·주 테이블 저장·SW·문서의 모든 SELECT/UPDATE/DELETE는 토큰에서 얻은 조직 ID를 WHERE 조건에 포함한다. 같은 `modelName`이 다른 조직에 있어도 타 조직 행은 404/영향 0건이어야 한다. PB master 상세이 `modelName`만으로 조회하는 동작은 보안 결함으로 보고 parity 대상에서 제외한다.

### 3.3 DB 컬럼명을 계약 이름으로 사용한다

새 DTO·응답·폼은 실제 컬럼의 lowerCamelCase를 사용한다. 예: `MODEL_NAME → modelName`, `PART_NO → partNo`, `MARKING_CHECK_YN → markingCheckYn`. 기존 의미 별칭을 추가하지 않는다.

### 3.4 하나의 화면을 책임별 탭으로 나눈다

- 기본정보: 모델명/품번/품목/고객/규격/유형/구분/제품류/리비전/적용기간
- 생산·포장: Array, PCB 수량, 포장 수량, Serial/Magazine, 캘린더 사용
- 검사·인터락: SPI/Marking/AOI/Reflow/Function/ICT/Power/Solder 검사 여부와 검사 채널
- 자재·마킹: TOP/BOTTOM/INSERT/PCB/Solder/Underfill 품목, 마킹 유형·위치·길이, 출력 좌표
- 소프트웨어: `IB_SMT_SW` 버전/체크섬/복사조건
- 문서: `IP_PRODUCT_SPEC_CONFIRM_DOC` 승인 문서 이력

### 3.5 PB 기능 대응표

| PB 구성 | 현행 설계 | 단계 |
|---|---|---|
| `d_pln_product_model_master_lst` | 좌측/상단 모델 DataGrid | 1 |
| `d_pln_product_model_master_mst` | 기본, 생산·포장, 자재·마킹 탭 | 1~2 |
| `d_pln_product_model_master_4_interlock_mst` ShareData | 검사·인터락 탭 | 1 |
| `d_smt_sw_lst` | 소프트웨어 탭 | 3 |
| `d_pln_product_model_master_doc_lst`와 문서 버튼 | 문서 이력 탭 | 3 |
| `master_sample_pid1/2/3` | 검사·인터락 탭의 마스터 샘플 PID | 1 |
| 모델명/품목 변경 자동복사 이벤트 | 폼 규칙 및 회귀 테스트 | 2 |
| `d_pln_product_model_master_simple_mst` | 소스 미확보 blocker; 은성 `Gvs_simple_model_master_yn` 운영값을 먼저 확인 | 사전 |

은성 운영 설정이 `N`이면 일반 master DW만 범위로 명시하고 진행한다. `Y`이면 누락 SRD를 확보하기 전에는 1단계 구현에 착수하지 않는다.

페이지 파일은 상태·레이아웃 조립만 담당하고 컬럼, 폼, 탭, API 타입을 분리한다.

## 4. 단계별 범위

### 1단계 — 관리 화면 기반과 주 테이블 핵심 CRUD

- 인증·조직 경계 수정
- 목록, 상세, 등록, 수정, 삭제 영향 확인
- 기본정보 및 생산·포장 필드
- 검사공정 Y/N 필드
- `MODEL_TYPE`, `MODEL_DIVISION`, `BARCODE_TYPE`, `ARRAY_TYPE`, `PRODUCT_CLASS`, `MARKING_CONDITION`, `SOLDER_TYPE`는 `ISYS_BASECODE`와 실측 매칭 후 `ComCodeSelect` 사용
- 고객/품목은 기존 선택 컴포넌트 재사용
- 기존 `ModelSearchModal` 호환 유지

`ORGANIZATION_ID`, `ENTER_BY/DATE`, `LAST_MODIFY_BY/DATE`는 서버 소유 필드로 강제한다. create/update DTO에서 받지 않으며 인증 사용자와 서버 시간으로 설정한다.

물리 삭제는 참조 관계와 PB 동작을 확인하기 전까지 API를 열지 않는다. 1단계에서는 삭제 영향 조회와 사용 가능 여부만 제공한다.

### 2단계 — 상세 제조조건

- 구성 자재 필드와 마킹 규칙
- 출력 좌표, Serial/Magazine 세부 규칙
- PB의 기본값·필수값·상호 활성화 규칙 이식
- BOM 조회 연결은 기존 `/master/bom` 기능 재사용 가능성을 확인한 후 링크한다

### 3단계 — 소프트웨어와 문서 이력

- `IB_SMT_SW` 목록/등록/수정/삭제
- PB처럼 주 모델과 같은 저장 액션에서 SW 변경을 함께 저장할 때는 단일 트랜잭션으로 처리하며 어느 한쪽 실패 시 모두 롤백
- `IP_PRODUCT_SPEC_CONFIRM_DOC` 메타데이터·BLOB 업로드/다운로드/삭제
- 문서 삭제 키는 `(modelName, version, token organizationId)`로 강제하고 정확히 1건 영향인지 확인한다. PB의 초기화되지 않은 version 삭제 코드는 결함으로 보고 복제하지 않는다.

문서 파일은 PDF/XLS/XLSX/DOC/DOCX만 허용하고 확장자, MIME, magic byte를 모두 검사한다. 최대 크기는 기존 업로드 정책을 확인해 한 곳의 상수로 정하며 요청 제한과 DB 스트리밍을 함께 적용한다. 원본 경로를 저장하지 않고 basename을 정규화하며 CR/LF와 경로 문자를 제거한다. 다운로드는 인증·토큰 조직·3-key 일치 후에만 허용하고 안전하게 인코딩한 `Content-Disposition`을 사용한다. metadata와 BLOB 저장은 단일 트랜잭션으로 처리해 어느 단계든 실패하면 INSERT까지 롤백한다.

## 5. 백엔드 구조

- `apps/backend/src/entities/product-model-master.entity.ts`: 라이브 스키마와 실제 화면 범위에 필요한 컬럼 매핑
- `apps/backend/src/modules/product-model/dto/product-model.dto.ts`: 목록/등록/수정 DTO
- `apps/backend/src/modules/product-model/product-model.controller.ts`: 조직 분리 CRUD
- `apps/backend/src/modules/product-model/product-model.service.ts`: 목록·상세·저장 및 참조 영향 확인
- `apps/backend/src/modules/product-model/product-model.service.spec.ts`: 조직 경계, 키, 허용 필드 테스트
- `apps/backend/src/modules/product-model/product-model.controller.spec.ts`: Guard와 DTO 변환 테스트
- `apps/backend/src/modules/product-model/product-model.module.ts`: Guard 의존성, 엔티티, 하위 서비스 등록
- 3단계에서 `product-model-software.*`, `product-model-document.*`를 별도 책임으로 추가

주 키는 라이브 PK/UK를 재조회해 확정한다. 현재 엔티티의 `(PART_NO, ORGANIZATION_ID)` 가정은 PB DataWindow의 `(MODEL_NAME, ORGANIZATION_ID)` 키 표시와 충돌하므로 추측해서 유지하지 않는다. 모든 raw query는 호출마다 새 named bind 객체를 사용하고 드라이버가 첫 bind 객체를 변경하는 회귀 테스트를 둔다.

## 6. 프론트엔드 구조

`apps/frontend/src/app/(authenticated)/master/product-model/`

- `page.tsx`: 조회 조건, 선택 상태, 탭 조립
- `types.ts`: API 계약 타입
- `productModelColumns.tsx`: 목록 컬럼
- `components/ProductModelFormPanel.tsx`: 등록/수정 셸
- `components/BasicInfoTab.tsx`
- `components/ProductionPackingTab.tsx`
- `components/InspectionInterlockTab.tsx`
- `components/MaterialMarkingTab.tsx`
- 3단계에서 `SoftwareTab.tsx`, `DocumentHistoryTab.tsx`

목록은 `DataGrid`, 알림은 toast, 삭제 확인은 `ConfirmModal`을 사용한다. 페이지는 대량 필드를 직접 소유하지 않는다.

## 7. 등록과 문서

- `apps/frontend/src/config/menuConfig.ts`
- 자동 생성되는 `apps/backend/src/seeds/menu-config.json`
- `apps/frontend/src/i18n/messages/{ko,en,es,vi}.json`
- `apps/frontend/public/help/manifest.json`
- `apps/frontend/public/help/user/ko/MST_PRODUCT_MODEL.md`
- `apps/frontend/public/help/operator/ko/MST_PRODUCT_MODEL.md`

## 8. 검증 기준

1. Oracle 기대 건수 312건과 조직별 건수를 먼저 기록한다.
2. 인증된 백엔드 API의 목록/상세가 동일 건수를 반환하는지 확인한다.
3. 프론트 프록시를 거친 응답을 확인한다.
4. API `total`과 전체 페이지 합계가 Oracle 기대 건수와 일치하고, 렌더된 대표 행과 정렬이 DB 원본과 일치하는지 확인한다.
5. 등록/수정은 승인된 테스트 모델로 pre/post SQL을 남긴다.
6. 기존 런카드와 OEE의 `ModelSearchModal`이 계속 모델을 선택하는지 회귀 확인한다.
7. DML 전 사용자 승인을 다시 받고 pre/post SQL을 남긴다. 원복 실패 시 즉시 중단하고 `docs/reports/`에 기록한다.
8. 문서 업로드는 허용/차단 파일, 크기 제한, 파일명 헤더 주입, 타 조직 접근, BLOB 저장 실패 롤백을 테스트한다.

## 9. 제외 및 후속 결정

- DB DDL은 하지 않는다.
- PB에 없는 신규 업무 규칙은 만들지 않는다.
- `QC 품질판정조건표`와 다른 누락 기준정보 화면은 별도 계획으로 다룬다.
- 삭제는 참조 테이블과 PB의 삭제 처리 확인 후 별도 승인한다.

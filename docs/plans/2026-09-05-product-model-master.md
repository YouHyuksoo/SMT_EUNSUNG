# Product Model Master Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** PB 제품모델관리의 전체 기능을 `/master/product-model`에 단계적으로 추가하고 기존 모델 선택 기능을 보존한다.

**Architecture:** 기존 `product-model` 모듈을 조직 분리된 기준정보 CRUD로 확장한다. 프론트는 얇은 페이지와 책임별 탭으로 구성하며, 주 테이블 기능을 먼저 완성한 뒤 소프트웨어와 문서 이력을 독립 API·컴포넌트로 붙인다.

**Tech Stack:** NestJS 11, TypeORM/Oracle, Next.js 16, React 19, TanStack DataGrid, Jest, Node structure tests, pnpm

---

## 사전 조건

- 설계: `docs/specs/2026-09-05-product-model-master-design.md`
- PB 원본: `PBL Library 10.5/w_pln_product_model_master.srw` 및 연결 DataWindow
- 라이브 DB: `JSIDCESDB`, 조직 1의 `IP_PRODUCT_MODEL_MASTER` 312건
- 사용자 변경이 있는 `AGENTS.md`, `apps/frontend/package.json`, `packages/shared/dist/**`는 작업 범위 밖으로 보존한다.

### Task 1: 실제 키·코드·참조 계약 고정

**Files:**
- Create: `apps/backend/src/modules/product-model/product-model.contract.spec.ts`
- Create: `apps/backend/src/modules/product-model/fixtures/product-model-schema.fixture.json`
- Create: `docs/reports/2026-09-05-product-model-pb-parity-inventory.md`
- Reference: `PBL Library 10.5/w_pln_product_model_master.srw`
- Reference: `PBL Library 10.5/d_pln_product_model_master_*.srd`
- Reference: `PBL Library 10.5/d_smt_sw_lst.srd`

- [ ] `USER_CONSTRAINTS`/`USER_CONS_COLUMNS`로 `IP_PRODUCT_MODEL_MASTER`의 실제 PK/UK를 조회한다.
- [ ] 라이브 `USER_TAB_COLUMNS` 결과를 fixture로 저장하고 PB Window의 버튼·이벤트·연결 DataWindow를 추적표로 작성한다.
- [ ] master/list/interlock/SW/document DataWindow의 컬럼·CRUD·활성화 규칙을 신규 화면 탭에 전부 매핑한다.
- [ ] 은성의 `Gvs_simple_model_master_yn` 운영값을 확인한다. `N`이면 일반 모드 제외 근거를 기록하고, `Y`이면 `d_pln_product_model_master_simple_mst` 확보 전 1단계를 중단한다.
- [ ] 코드 후보 컬럼을 정규화해 `ISYS_BASECODE.CODE_TYPE`과 조회하고 실제 코드값을 기록한다.
- [ ] 주 키가 현재 엔티티 가정과 다른 경우 실패하는 계약 테스트를 작성한다.
- [ ] `pnpm --filter @eunsung/backend test -- --runInBand product-model.contract.spec.ts`를 실행해 fixture 누락 FAIL을 확인한다.
- [ ] 수집한 라이브 결과로 fixture를 고정하고 같은 명령이 PASS인지 확인한다.
- [ ] `git status --short`와 대상 경로의 `git diff`를 확인한다.
- [ ] `git add -- apps/backend/src/modules/product-model/product-model.contract.spec.ts apps/backend/src/modules/product-model/fixtures/product-model-schema.fixture.json docs/reports/2026-09-05-product-model-pb-parity-inventory.md` 후 `git diff --cached --check`를 실행한다.
- [ ] `test: lock product model database contract`로 커밋한다.

### Task 2: 인증·조직 경계 회귀 테스트

**Files:**
- Create: `apps/backend/src/modules/product-model/product-model.controller.spec.ts`
- Modify: `apps/backend/src/modules/product-model/product-model.controller.ts`
- Modify: `apps/backend/src/modules/product-model/product-model.service.ts`
- Modify: `apps/backend/src/modules/product-model/product-model.module.ts`

- [ ] `@Public()`이 없어야 하고 `JwtAuthGuard`가 적용되어야 한다는 실패 테스트를 작성한다.
- [ ] 요청 body/query의 조직 ID가 서비스로 전달되지 않고 `@OrganizationId()`만 전달되는 테스트를 작성한다.
- [ ] 현재 코드에서 테스트가 FAIL인지 확인한다.
- [ ] 컨트롤러의 `@Public()`을 제거하고 프로젝트 Guard 패턴을 적용한다.
- [ ] 서비스의 `const ORG = 1`과 SQL 문자열 보간을 제거하고 bind 변수로 조직을 전달한다.
- [ ] 주/하위 리소스 모든 쿼리에 토큰 조직을 강제하고 타 조직 동일 모델 접근이 404/0건인 테스트를 추가한다.
- [ ] 호출마다 새 bind 객체를 만들며 첫 호출에서 bind가 변경돼도 다음 호출이 안전한 회귀 테스트를 추가한다.
- [ ] `TypeOrmModule.forFeature([ProductModelMaster, IsysUser, IsysOrganization])`와 `JwtAuthGuard` provider를 `product-model.module.ts`에 등록하고 module compile 테스트를 추가한다.
- [ ] `pnpm --filter @eunsung/backend test -- --runInBand product-model.controller.spec.ts`가 PASS인지 확인한다.
- [ ] `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`가 exit 0인지 확인한다.
- [ ] `fix: secure product model organization boundary`로 커밋한다.

### Task 3: 엔티티와 DTO 전체 경로 추가

**Files:**
- Modify: `apps/backend/src/entities/product-model-master.entity.ts`
- Create: `apps/backend/src/modules/product-model/dto/product-model.dto.ts`
- Create: `apps/backend/src/modules/product-model/dto/product-model.dto.spec.ts`

- [ ] 필수값, 숫자 최소값, 날짜, Y/N, 코드 길이 검증의 실패 테스트를 작성한다.
- [ ] 실제 DB 이름의 lowerCamelCase로 화면 범위에 필요한 엔티티 컬럼을 매핑한다.
- [ ] `CreateProductModelDto`, `UpdateProductModelDto`, `ProductModelQueryDto`를 작성한다.
- [ ] `organizationId`, 감사 컬럼, 임의 속성이 DTO를 통과하지 않는지 테스트한다.
- [ ] `pnpm --filter @eunsung/backend test -- --runInBand product-model.dto.spec.ts`가 PASS인지 확인한다.
- [ ] `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`가 exit 0인지 확인한다.
- [ ] `feat: map product model master contract`로 커밋한다.

### Task 4: 목록·상세·등록·수정 API

**Files:**
- Modify: `apps/backend/src/modules/product-model/product-model.controller.ts`
- Modify: `apps/backend/src/modules/product-model/product-model.service.ts`
- Create: `apps/backend/src/modules/product-model/product-model.service.spec.ts`

- [ ] 목록 검색/페이징/조직 분리 실패 테스트를 작성한다.
- [ ] 상세가 복합키와 조직을 모두 요구하는 실패 테스트를 작성한다.
- [ ] create/update가 DTO 허용 필드만 저장하고 감사 컬럼을 서버에서 채우는 실패 테스트를 작성한다.
- [ ] Task 1에서 확인한 실제 키를 URL-safe path parameter로 정하고 `GET /master/product-models`, `GET /master/product-models/:modelKey`, `POST`, `PUT /:modelKey`를 구현한다. 조직 ID는 URL/body에 넣지 않는다.
- [ ] 목록 응답에 기존 모달의 4개 필드를 유지한다.
- [ ] 삭제는 구현하지 않고 참조 영향 조회 API만 추가한다.
- [ ] `pnpm --filter @eunsung/backend test -- --runInBand product-model.service.spec.ts product-model.controller.spec.ts`가 PASS인지 확인한다.
- [ ] `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`가 exit 0인지 확인한다.
- [ ] `feat: add product model master CRUD API`로 커밋한다.

### Task 5: 기존 모델 선택 모달 호환성

**Files:**
- Modify: `apps/frontend/src/components/shared/ModelSearchModal.tsx`
- Create: `apps/frontend/src/components/shared/model-search-modal.eunsung.structure.test.mjs`

- [ ] 표준 응답 래퍼에서도 4개 기존 필드를 읽는 실패 구조 테스트를 작성한다.
- [ ] 모달을 새 응답 계약에 맞추되 선택 결과 타입은 유지한다.
- [ ] 런카드와 OEE 표준시간의 호출부를 변경할 필요가 없는지 확인한다.
- [ ] `node --test apps/frontend/src/components/shared/model-search-modal.eunsung.structure.test.mjs`가 PASS인지 확인한다.
- [ ] `pnpm --filter @eunsung/frontend typecheck`가 exit 0인지 확인한다.
- [ ] `fix: preserve product model selector compatibility`로 커밋한다.

### Task 6: 1단계 제품모델 목록과 기본정보 폼

**Files:**
- Create: `apps/frontend/src/app/(authenticated)/master/product-model/page.tsx`
- Create: `apps/frontend/src/app/(authenticated)/master/product-model/types.ts`
- Create: `apps/frontend/src/app/(authenticated)/master/product-model/productModelColumns.tsx`
- Create: `apps/frontend/src/app/(authenticated)/master/product-model/components/ProductModelFormPanel.tsx`
- Create: `apps/frontend/src/app/(authenticated)/master/product-model/components/BasicInfoTab.tsx`
- Create: `apps/frontend/src/app/(authenticated)/master/product-model/components/ProductionPackingTab.tsx`
- Create: `apps/frontend/src/app/(authenticated)/master/product-model/components/InspectionInterlockTab.tsx`
- Create: `apps/frontend/src/app/(authenticated)/master/product-model/product-model.eunsung.structure.test.mjs`

- [ ] 얇은 page, 전용 columns, 분리된 tabs, DataGrid 사용을 강제하는 실패 구조 테스트를 작성한다.
- [ ] 목록·검색·선택·등록·수정 상태를 `page.tsx`에 연결한다.
- [ ] 코드 필드는 `ComCodeSelect`, 품목/고객은 기존 검색 컴포넌트를 사용한다.
- [ ] 숫자·날짜·필수값과 PB 기본값을 폼에 반영한다.
- [ ] toast와 `ConfirmModal`만 사용하고 브라우저 기본 대화상자를 사용하지 않는다.
- [ ] `node --test "apps/frontend/src/app/(authenticated)/master/product-model/product-model.eunsung.structure.test.mjs"`가 PASS인지 확인한다.
- [ ] `pnpm --filter @eunsung/frontend typecheck`가 exit 0인지 확인한다.
- [ ] `feat: add product model master screen`으로 커밋한다.

### Task 7: 메뉴·번역·도움말 등록

**Files:**
- Modify: `apps/frontend/src/config/menuConfig.ts`
- Generated: `apps/backend/src/seeds/menu-config.json`
- Generated: `apps/backend/src/modules/menu-categories/utils/menu-code-validator.ts`
- Generated: `apps/backend/src/modules/menu-categories/utils/default-menu-category-layout.ts`
- Modify: `apps/frontend/src/i18n/messages/ko.json`
- Modify: `apps/frontend/src/i18n/messages/en.json`
- Modify: `apps/frontend/src/i18n/messages/es.json`
- Modify: `apps/frontend/src/i18n/messages/vi.json`
- Modify: `apps/frontend/public/help/manifest.json`
- Create: `apps/frontend/public/help/user/ko/MST_PRODUCT_MODEL.md`
- Create: `apps/frontend/public/help/operator/ko/MST_PRODUCT_MODEL.md`

- [ ] `menuConfig.ts`에 `MST_PRODUCT_MODEL`을 먼저 추가한 뒤 `pnpm --filter @eunsung/frontend typecheck`를 실행해 생성 메뉴 파일 불일치로 FAIL하는지 확인한다.
- [ ] `MASTER` 메뉴의 PB 순서상 품목 다음에 제품모델을 등록한다. 비어 있는 `PRODUCT_MGMT` 그룹으로 옮기지 않는다.
- [ ] 4개 언어 메뉴/필드 번역을 추가한다.
- [ ] 사용자/운영자 도움말과 manifest를 추가한다.
- [ ] `pnpm --filter @eunsung/frontend gen:menu`로 메뉴 생성 파일 3종을 갱신한다.
- [ ] `pnpm --filter @eunsung/frontend typecheck`를 다시 실행해 메뉴·페이지 레지스트리 전수 검증이 PASS인지 확인한다.
- [ ] 생성기가 기존 dirty 파일을 바꾸지 않았는지 `git status --short`로 확인하고 위 등록 파일만 path별 stage한다.
- [ ] `feat: register product model master menu`로 커밋한다.

### Task 8: 2단계 상세 제조조건

**Files:**
- Create: `apps/frontend/src/app/(authenticated)/master/product-model/components/MaterialMarkingTab.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/product-model/components/ProductModelFormPanel.tsx`
- Modify: `apps/backend/src/modules/product-model/dto/product-model.dto.ts`
- Modify: `apps/backend/src/modules/product-model/product-model.service.ts`
- Modify: `apps/backend/src/modules/product-model/product-model.service.spec.ts`
- Modify: `apps/frontend/src/app/(authenticated)/master/product-model/types.ts`
- Modify: `apps/frontend/src/app/(authenticated)/master/product-model/components/BasicInfoTab.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/product-model/components/ProductionPackingTab.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/product-model/product-model.eunsung.structure.test.mjs`

- [ ] 구성품·마킹·출력 좌표 필드의 저장 회귀 테스트를 작성한다.
- [ ] TOP/BOTTOM/INSERT/PCB/Solder/Underfill은 품목 선택기로 제한한다.
- [ ] 마킹 유형 1~5와 시작/길이 규칙을 반복 UI로 구현하되 데이터 계약은 개별 실제 컬럼을 유지한다.
- [ ] PB의 필드 활성화 조건을 테스트로 고정한다.
- [ ] `pnpm --filter @eunsung/backend test -- --runInBand product-model.service.spec.ts`가 PASS인지 확인한다.
- [ ] `node --test "apps/frontend/src/app/(authenticated)/master/product-model/product-model.eunsung.structure.test.mjs"`가 PASS인지 확인한다.
- [ ] `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`가 exit 0인지 확인한다.
- [ ] `pnpm --filter @eunsung/frontend typecheck`가 exit 0인지 확인한다.
- [ ] `feat: add product model manufacturing details`로 커밋한다.

### Task 9: 3단계 소프트웨어 버전 탭

**Files:**
- Create: `apps/backend/src/entities/smt-software.entity.ts`
- Create: `apps/backend/src/modules/product-model/product-model-software.service.ts`
- Create: `apps/backend/src/modules/product-model/product-model-software.service.spec.ts`
- Modify: `apps/backend/src/modules/product-model/product-model.controller.ts`
- Modify: `apps/backend/src/modules/product-model/product-model.module.ts`
- Create: `apps/frontend/src/app/(authenticated)/master/product-model/components/SoftwareTab.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/product-model/components/ProductModelFormPanel.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/product-model/types.ts`
- Modify: `apps/frontend/src/app/(authenticated)/master/product-model/product-model.eunsung.structure.test.mjs`

- [ ] `IB_SMT_SW` 실제 키·컬럼 계약 테스트를 작성한다.
- [ ] 모델과 조직으로 제한된 CRUD API를 구현한다.
- [ ] 주 모델과 같은 저장 요청의 SW 변경을 QueryRunner 단일 트랜잭션으로 처리하고 한쪽 실패 시 전체 롤백을 테스트한다.
- [ ] 버전, 체크섬, 복사 ST, 마킹점, 품번을 DataGrid와 폼으로 구현한다.
- [ ] `pnpm --filter @eunsung/backend test -- --runInBand product-model-software.service.spec.ts product-model.service.spec.ts`가 PASS인지 확인한다.
- [ ] `node --test "apps/frontend/src/app/(authenticated)/master/product-model/product-model.eunsung.structure.test.mjs"`가 PASS인지 확인한다.
- [ ] `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`가 exit 0인지 확인한다.
- [ ] `pnpm --filter @eunsung/frontend typecheck`가 exit 0인지 확인한다.
- [ ] `feat: add product model software versions`로 커밋한다.

### Task 10: 3단계 승인문서 이력 탭

**Files:**
- Create: `apps/backend/src/entities/product-spec-confirm-document.entity.ts`
- Create: `apps/backend/src/modules/product-model/product-model-document.service.ts`
- Create: `apps/backend/src/modules/product-model/product-model-document.service.spec.ts`
- Modify: `apps/backend/src/modules/product-model/product-model.controller.ts`
- Modify: `apps/backend/src/modules/product-model/product-model.controller.spec.ts`
- Modify: `apps/backend/src/modules/product-model/product-model.module.ts`
- Create: `apps/frontend/src/app/(authenticated)/master/product-model/components/DocumentHistoryTab.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/product-model/components/ProductModelFormPanel.tsx`
- Modify: `apps/frontend/src/app/(authenticated)/master/product-model/types.ts`
- Modify: `apps/frontend/src/app/(authenticated)/master/product-model/product-model.eunsung.structure.test.mjs`

- [ ] `IP_PRODUCT_SPEC_CONFIRM_DOC`의 실제 키와 PB 허용 동작을 테스트로 고정한다.
- [ ] 모델과 조직별 메타데이터·BLOB 업로드/다운로드 API를 구현한다.
- [ ] PDF/XLS/XLSX/DOC/DOCX의 확장자·MIME·magic byte, 공용 최대 크기, 스트리밍, basename 정규화와 CR/LF 제거, 안전한 `Content-Disposition`을 구현한다.
- [ ] metadata INSERT와 BLOB 저장을 단일 트랜잭션으로 묶고 BLOB 실패 시 전체 롤백을 테스트한다.
- [ ] 컨트롤러 테스트에서 multipart 크기 제한, 허용/차단 파일, CR/LF 파일명, 타 조직 다운로드 차단, 스트리밍 응답 헤더를 검증한다.
- [ ] 삭제는 `(modelName, version, token organizationId)`로 정확히 1건만 처리하고 PB의 초기화되지 않은 version 버그를 재현하지 않는 테스트를 작성한다.
- [ ] 승인일, 버전, 접수일, 문서명을 표시하고 업로드·다운로드·삭제를 연결한다.
- [ ] `pnpm --filter @eunsung/backend test -- --runInBand product-model-document.service.spec.ts product-model.controller.spec.ts`가 PASS인지 확인한다.
- [ ] `node --test "apps/frontend/src/app/(authenticated)/master/product-model/product-model.eunsung.structure.test.mjs"`가 PASS인지 확인한다.
- [ ] `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`가 exit 0인지 확인한다.
- [ ] `pnpm --filter @eunsung/frontend typecheck`가 exit 0인지 확인한다.
- [ ] `feat: add product model document history`로 커밋한다.

### Task 11: Oracle → API → UI 종단 검증

**Files:**
- Create: `docs/test-checklists/2026-09-05-product-model-master.md`

- [ ] Oracle에서 조직 1 기대 건수와 대표 모델의 화면 대상 컬럼 값을 기록한다.
- [ ] 사용자가 기동한 3003 backend의 인증 API `total`과 전체 페이지 합계가 Oracle 건수와 일치하는지 확인한다.
- [ ] 사용자가 기동한 3010 frontend proxy 응답이 동일한지 확인한다.
- [ ] 브라우저에서 대표 행, 정렬, 필터, 상세 탭, 코드명 렌더링을 확인한다.
- [ ] DML 직전 사용자 승인을 받고 승인된 테스트 모델로 pre/post를 확인한 뒤 원복한다.
- [ ] 원복 실패 시 즉시 중단하고 `docs/reports/`에 미완료 기록을 남긴다.
- [ ] 런카드와 OEE 표준시간의 모델 선택 회귀를 확인한다.
- [ ] `pnpm --filter @eunsung/backend test -- --runInBand product-model`과 backend typecheck를 실행한다.
- [ ] `pnpm --filter @eunsung/frontend test`와 frontend typecheck를 실행한다.
- [ ] `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`가 exit 0인지 확인한다.
- [ ] `pnpm --filter @eunsung/frontend typecheck`가 exit 0인지 확인한다.
- [ ] 실패나 미검증 항목이 있으면 `docs/reports/`에 남긴다.
- [ ] 검증 파일만 `test: verify product model master end to end`로 커밋한다.

## 모든 커밋 단계의 공통 안전 절차

- 각 Task 시작과 커밋 직전에 `git status --short`를 확인한다.
- `git add .`를 사용하지 않고 Task의 `Files`에 적힌 경로만 `git add -- <paths>`로 stage한다.
- `git diff --cached --check`와 `git diff --cached --name-only`로 범위를 확인한다.
- 기존 사용자 변경인 `AGENTS.md`, `apps/frontend/package.json`, `packages/shared/dist/**`는 stage하거나 수정하지 않는다.

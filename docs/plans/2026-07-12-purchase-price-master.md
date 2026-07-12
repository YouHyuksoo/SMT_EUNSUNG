# 구매단가관리 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use test-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `IM_ITEM_UNIT_PRICE` 기반 구매단가 조회, 영향도 확인, 단건 등록·수정 화면을 기준정보 메뉴에 추가한다.

**Architecture:** NestJS의 좁은 master 모듈이 Oracle 레거시 테이블을 직접 매핑하고, DB 트리거가 기간 마감과 입고금액 소급 갱신을 계속 소유한다. Next.js 화면은 단일 그리드와 우측 폼 패널로 구성하며 저장 전에 읽기 전용 영향도 API를 호출한다.

**Tech Stack:** NestJS 11, TypeORM, Oracle, Next.js 16, React 19, TanStack Table, Tailwind CSS 4, Jest, Node structure tests

---

### Task 1: 백엔드 계약과 서비스

**Files:**
- Create: `apps/backend/src/entities/purchase-unit-price.entity.ts`
- Create: `apps/backend/src/entities/supplier-master.entity.ts`
- Create: `apps/backend/src/modules/master/dto/purchase-price.dto.ts`
- Create: `apps/backend/src/modules/master/services/purchase-price.service.ts`
- Create: `apps/backend/src/modules/master/services/purchase-price.service.spec.ts`

- [ ] 서비스 테스트에서 목록·영향도·공급사·단건 생성·복합키 수정이 모두 서버 주입 `organizationId`만 사용하고 body/query의 조직값을 신뢰하지 않는지 먼저 정의한다.
- [ ] 신규 영향도는 기존 단가 마감과 입고 재계산을 모두 반환하고, 수정 영향도는 UPDATE 트리거 동작대로 입고 재계산만 반환하는 계약을 테스트한다.
- [ ] `ORA-20003`/`ORA-04091`의 driver 원문을 추출해 HTTP 예외 메시지로 보존하는 테스트를 정의한다.
- [ ] `pnpm --filter @eunsung/backend test -- --runInBand purchase-price.service.spec.ts`로 기능 부재에 따른 실패를 확인한다.
- [ ] 두 레거시 엔티티와 검증 DTO를 추가한다.
- [ ] 목록은 QueryBuilder 조인과 페이지네이션, 영향도는 인덱스 조건을 유지한 raw query, 저장은 단일 `save()`/`update()`로 구현한다.
- [ ] 같은 테스트를 다시 실행해 통과를 확인한다.

### Task 2: 백엔드 라우트와 모듈 등록

**Files:**
- Create: `apps/backend/src/modules/master/controllers/purchase-price.controller.ts`
- Create: `apps/backend/src/modules/master/controllers/purchase-price.controller.spec.ts`
- Create: `apps/backend/src/modules/master/master-purchase-price.module.ts`
- Modify: `apps/backend/src/app.module.ts`
- Modify: `apps/backend/src/database/database.module.ts`

- [ ] 컨트롤러 테스트에 `/master/purchase-prices`, `/impact`, `/master/suppliers` 계약과 모든 메서드의 `@OrganizationId()` 전달을 먼저 추가하고 실패를 확인한다.
- [ ] HTTP 계층 테스트에서 Oracle 원문이 전역 예외 처리에 의해 `Database query failed`로 치환되지 않는지 확인한다.
- [ ] `pnpm --filter @eunsung/backend test -- --runInBand purchase-price.controller.spec.ts`로 실패를 확인한 뒤 구현 후 재실행한다.
- [ ] 컨트롤러와 좁은 모듈을 추가한다.
- [ ] 기존 dirty-tree 변경을 보존하며 AppModule과 명시 entities 배열에 필요한 항목만 추가한다.
- [ ] 백엔드 focused test와 TypeScript 검사를 실행한다.

### Task 3: 프론트 메뉴와 공용 공급사 선택기

**Files:**
- Modify: `apps/frontend/src/config/menuConfig.ts`
- Modify: `apps/backend/src/seeds/menu-config.json`
- Modify: `apps/frontend/src/hooks/useMasterOptions.ts`
- Create: `apps/frontend/src/components/shared/SupplierSelect.tsx`
- Modify: `apps/frontend/src/locales/ko.json`
- Modify: `apps/frontend/src/locales/en.json`
- Modify: `apps/frontend/src/locales/zh.json`
- Modify: `apps/frontend/src/locales/vi.json`
- Create: `apps/frontend/src/app/(authenticated)/master/purchase-price/purchase-price.structure.test.mjs`

- [ ] 구조 테스트에 메뉴 코드·경로·시드 동기화, 공급사 API 훅, 4개 로케일 키를 먼저 정의한다.
- [ ] 프론트 테스트를 실행해 실패를 확인한다.
- [ ] `MST_PURCHASE_PRICE` 메뉴와 공급사 옵션 컴포넌트, 번역을 추가한다.
- [ ] 구조 테스트를 다시 실행해 통과를 확인한다.

### Task 4: 구매단가 그리드와 우측 폼

**Files:**
- Create: `apps/frontend/src/app/(authenticated)/master/purchase-price/types.ts`
- Create: `apps/frontend/src/app/(authenticated)/master/purchase-price/purchasePriceColumns.tsx`
- Create: `apps/frontend/src/app/(authenticated)/master/purchase-price/components/PurchasePriceFormPanel.tsx`
- Create: `apps/frontend/src/app/(authenticated)/master/purchase-price/page.tsx`

- [ ] 구조 테스트에 목록 API, 기준일·유효단가 필터, `PartSearchModal`, 코드 선택기, 영향도 `ConfirmModal`, POST/PUT 저장 계약을 먼저 추가하고 실패를 확인한다.
- [ ] 신규 확인 문구만 기존 단가 마감을 안내하고 수정 확인 문구는 입고금액 재계산만 안내하는지 테스트한다.
- [ ] Oracle 원문 오류가 API 인터셉터/토스트에 전달되며 화면 코드가 일반 문구로 덮어쓰지 않는지 확인한다.
- [ ] 승인번호·승인여부·승인자·승인일은 읽기 전용 표시만 하고 승인 버튼/API가 없음을 구조 테스트로 고정한다.
- [ ] 프론트 테스트를 실행해 실패를 확인한다.
- [ ] 고정 높이 단일 그리드, 필터 툴바, 행 편집, 우측 폼을 구현한다.
- [ ] 신규 저장은 영향도 확인 후 POST, 수정은 원본 복합키를 포함해 PUT하며 DELETE UI는 만들지 않는다.
- [ ] 구조 테스트와 프론트 TypeScript 검사를 실행한다.

### Task 5: 도움말과 최종 검증

**Files:**
- Modify: `apps/frontend/public/help/manifest.json`
- Create: `apps/frontend/public/help/user/ko/MST_PURCHASE_PRICE.md`
- Create: `apps/frontend/public/help/operator/ko/MST_PURCHASE_PRICE.md`

- [ ] 도움말 manifest 및 사용자·운영자 문서를 실제 화면 동작과 위험한 트리거 영향에 맞춰 추가한다.
- [ ] `pnpm --filter @eunsung/backend test -- --runInBand purchase-price.service.spec.ts`를 실행한다.
- [ ] `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`를 실행한다.
- [ ] `pnpm --filter @eunsung/frontend test`를 실행한다.
- [ ] `pnpm --filter @eunsung/frontend exec tsc --noEmit --pretty false`를 실행한다.
- [ ] 서버가 이미 실행 중일 때만 3003 API와 3100 렌더링을 확인한다. 서버가 없으면 임의로 기동하지 않고 미검증 사항으로 기록한다.
- [ ] 실행 중인 백엔드가 있으면 알려진 조합 `M2014700034`/`IP`/`Y`의 이력 3건을 read-only로 조회하고 기준일 목록 및 신규/수정 영향도 결과가 트리거 정의와 일치하는지 확인한다.
- [ ] 운영 데이터 DML 검증은 별도 승인 없이는 수행하지 않고 목록·영향도 read-only API까지만 확인한다.

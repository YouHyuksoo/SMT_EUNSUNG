# 제품모델 조회 메뉴 추가 및 잔여 검증

- 범위: 기준정보 → 제품모델 관리 (`MST_PRODUCT_MODEL`, `/master/product-model`). 조회 전용이며 등록·수정·삭제는 포함하지 않는다.
- 기존 `GET /api/v1/master/product-models` API로 모델명, 고객사품번, 모델규격, 고객사명을 조회한다. 검색, 컬럼 필터, 내보내기, 새로고침을 제공한다.
- 이전 PB 전체 관리 화면 계획의 구현 완료를 의미하지 않는다.

## 변경 경로

- 화면·조회 훅·컬럼: `apps/frontend/src/app/(authenticated)/master/product-model/`
- 메뉴 원본: `apps/frontend/src/config/menuConfig.ts`
- 번역: `apps/frontend/src/locales/{ko,en,zh,vi}.json`
- 메뉴 및 페이지 레지스트리는 기존 생성 스크립트로 갱신했다.
- 기존 API: `apps/backend/src/modules/product-model/` (변경 없음). 기존 API의 조직 1 고정 및 Public 설정도 변경하지 않았다.

## 확인 결과

- `pnpm --filter @eunsung/frontend typecheck`: 통과 (39 pages, 36 menu leaves).
- `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`: 통과.
- `node --test apps/backend/src/modules/menu-categories/utils/default-menu-category-layout.structure.test.mjs`: 1건 통과.
- Oracle JSIDCESDB 조회: `SELECT COUNT(*) AS MODEL_COUNT FROM IP_PRODUCT_MODEL_MASTER WHERE ORGANIZATION_ID = 1` → 312건.

## 미완료 및 재개 절차

- 확인 시점에 로컬 3010·3003 LISTEN 소켓이 없어 API·브라우저 렌더 검증은 수행하지 못했다. 서버를 임의 기동하지 않았다.
- 사용자가 서버를 기동한 뒤 로그인된 세션에서 기준정보 → 제품모델 관리 메뉴 노출 및 진입을 확인한다.
- Oracle 기대 건수를 다시 조회하고 백엔드 API → 프론트 프록시 API → 화면 전체 건수가 일치하는지 확인한다 (페이지당 50행).
- 검색·초기화·새로고침 및 오류 표시를 확인한다. 사용자별 메뉴 권한도 확인한다.

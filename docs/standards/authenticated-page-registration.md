---
sources:
  - AGENTS.md
  - apps/frontend/scripts/gen-page-registry.mjs
  - apps/frontend/scripts/check-page-registration.mjs
  - apps/frontend/package.json
  - apps/frontend/src/components/layout/TabKeepAlive.tsx
  - apps/frontend/src/components/layout/pageRegistry.generated.ts
  - apps/frontend/src/components/layout/page-registries/
  - apps/frontend/src/app/(authenticated)/
verifiedCommit: 1bd1735
---

# 인증 페이지 등록 표준

이 프론트엔드는 Next.js App Router와 탭 keep-alive registry를 함께 사용한다. 인증 페이지의 `page.tsx` 파일만 추가하면 직접 URL과 새로고침은 동작할 수 있지만, 사이드바 클릭에서는 탭만 생기고 화면 컴포넌트가 전환되지 않을 수 있다.

신규 페이지 작업은 공용 `new-frontend-page` 스킬과 이 저장소의 `.agents/new-frontend-page.yaml` 프로필을 함께 사용한다. 공용 스킬은 절차를 정의하고, 프로필은 은성 MES의 등록 파일·생성기·검증 명령·런타임 조건을 정의한다.

## 필수 절차

인증 페이지를 추가·이동·삭제한 뒤 다음 명령 중 하나를 실행한다.

```powershell
pnpm --filter @eunsung/frontend typecheck
pnpm --filter @eunsung/frontend test
```

두 명령은 registry 생성기와 전수 검증기를 먼저 실행한다. 개발 서버와 빌드도 시작 전에 같은 생성·검증 단계를 수행한다.

생성 결과에서 다음 두 항목을 확인한다.

1. `apps/frontend/src/components/layout/pageRegistry.generated.ts`에 정확한 경로의 `case`가 존재한다.
2. `apps/frontend/src/components/layout/page-registries/<route>.generated.ts`가 실제 `page.tsx`를 dynamic import한다.

## 자동 전수 검증

`check-page-registration.mjs`가 다음 항목을 파일시스템 기준으로 전수 비교한다.

- 모든 인증 `page.tsx`의 중앙 registry case
- 페이지별 lazy registry 파일과 실제 import 경로
- 모든 `menuConfig` leaf 경로에 대응하는 `page.tsx`
- 메뉴 코드의 백엔드 시드, 화이트리스트, 기본 카테고리 배치

하나라도 누락되면 `test`, `typecheck`, `dev`, `build`가 실패한다.

## 기능별 구조 테스트

새 페이지의 구조 테스트는 registry 경로를 함께 검증한다.

```js
const registry = read('src/components/layout/pageRegistry.generated.ts');
assert.match(registry, /case "\/master\/example"/);
```

메뉴 등록 테스트는 다음 항목을 한 묶음으로 확인한다.

- `menuConfig.ts`
- 백엔드 메뉴 시드
- 메뉴 코드 화이트리스트
- 기본 카테고리 배치
- keep-alive page registry

## 완료 검증

1. 구조 테스트와 프론트 TypeScript 검사를 실행한다.
2. 사이드바에서 메뉴를 클릭한다.
3. URL, 상단 탭, 본문 화면이 한 번의 클릭으로 함께 변경되는지 확인한다.
4. 다른 탭으로 이동했다가 돌아왔을 때 화면이 유지되는지 확인한다.
5. 새로고침 없이 동작해야 한다.

직접 URL의 HTTP 200만으로 메뉴 이동을 완료 처리하지 않는다.

## 구매·판매단가 사례

`/master/purchase-price`와 `/master/sale-price`는 메뉴와 App Router 페이지는 등록됐지만 generated registry가 누락됐다. 그 결과 상단 탭만 생성되고 본문은 이전 화면에 남았으며, 새로고침 후에만 App Router fallback으로 표시됐다. 두 기능의 구조 테스트에 registry 검증을 추가하고 생성기를 실행해 재발을 차단했다.

# OEE 종합 현황 (관제센터형) — 목업

- 작성일: 2026-09-01
- 대상: OEE관리 하위 신규 화면 `OEE_OVERALL_STATUS` / `/oee/overall-status`
- 디자인 원안: `docs/presentations/2026-07-10-inventory-oee-visual-review.html` #gallery → DESIGN A 관제센터형

## 배경

현장 대형 모니터에 상시 표출할 OEE 종합 화면. 라인을 고르면 그 라인의 설비를
같은 타일로 펼쳐 가동율·성능율·양품율을 본다. **이번 단계는 목업이고 산식은 나중에 붙인다.**

## 사전 실측

| 항목 | 값 |
|---|---|
| 원안 팔레트 | 고정 다크 (`#060b16` 배경, 시안 `#3fd6e2`, 상태 녹/황/적) |
| 원안 구조 | `.a-head` / `.a-kpis` 6칸 / `.a-wall` 타일 / `.a-alert` |
| 라인 마스터 | `IP_PRODUCT_LINE` 18건 (A~L라인, WAVE, ICT, 성능검사기 등) |
| 설비 | `IMCN_MACHINE` 120대 — **LINE_CODE가 전부 `'*'`(미배정)** |
| OEE 산식 | `packages/shared/src/oee/oee-calc.ts` 에 이미 존재 |
| 페이지 등록 | `docs/standards/authenticated-page-registration.md` 절차(생성기+검증기) |

**라인→설비 배정이 비어 있어 실데이터로는 드릴다운이 항상 0대다.** 그래서 이번엔 전체 목업으로 간다.

## 확정 결정 (grill 7문)

| # | 항목 | 결정 | 감수한 위험 |
|---|---|---|---|
| 1 | 데이터 | 전체 하드코딩 목업 | 실데이터 검증 불가 |
| 2 | 테마 | 원안 고정 다크가 아니라 프로젝트 테마 토큰으로 번안 | 네온 관제실 느낌은 약해짐 |
| 3 | 구성 | KPI 띠(공장 종합) + 라인 타일(OEE 대표값 + 3율) + 설비 타일(3율) | |
| 4 | 선택 | 단일 선택, 진입 시 첫 라인 자동 선택 | |
| 5 | KPI 범위 | 공장 종합 고정 — 라인을 바꿔도 불변 | |
| 6 | 관제 장치 | 상태색 + 정지 점멸 + ALERT 바 | 상태값도 상수 |
| 7 | 실시간 | 헤더 시계만 1초 갱신(탭 이탈 시 정지). 폴링은 산식 단계 | |
| 8 | 이름 | 실제 라인명·실제 설비코드 사용 | 진짜 실적으로 오해 가능 → **목업 표식 필수** |

## 설계

- 목업 상수는 `_lib/mock.ts`로 분리하고 화면은 「데이터 → 뷰」로만 짠다.
  산식 단계에서 상수 자리에 API 응답을 끼우면 화면 코드는 그대로 둔다.
- 헤더에 «목업 — 산식 미적용» 배지를 상시 노출한다. 실제 설비코드에 가짜 수치가
  붙으므로 표식이 없으면 실적으로 오해된다.
- 점멸은 `prefers-reduced-motion`을 존중한다.

## 체크리스트

- [x] 1. 목업 데이터 `_lib/mock.ts` (라인 6~8, 라인당 설비 4~8) → 검증: tsc
- [x] 2. 화면 `page.tsx` — 헤더/시계/목업배지, KPI 띠, 라인 타일, 설비 타일, ALERT → 검증: tsc
- [x] 3. 메뉴 등록 4곳 (menuConfig / seeds / validator / layout) → 검증: 등록 검증기
- [x] 4. i18n (ko/en/vi/zh) → 검증: 구조 테스트
- [~] 5. 전체 검증 — tsc + 구조 테스트 + 화면 확인

## 진행 기록

### 구현 내용

- `_lib/mock.ts` — 라인 6개(A·B·C라인, WAVE, ICT, ROUTER) / 라인당 설비 2~4대.
  라인명·설비코드는 실제 마스터 값, 수치는 전부 상수. `MOCK_FACTORY_KPIS`,
  `MOCK_LINES`, `MOCK_MACHINES`, `MOCK_ALERT` 넷만 API로 갈아끼우면 된다.
- `page.tsx` — 헤더(시계+목업 배지) / KPI 6칸 / 라인 타일 / 설비 타일 / ALERT 바.
  `RateRows`를 라인·설비가 공유해 3율 표기가 어긋나지 않는다.
- 메뉴 등록 4곳 — `menuConfig.ts`, `menu-code-validator.ts`, `seeds/menu-config.json`,
  `default-menu-category-layout.ts`. OEE 카테고리 **맨 앞**에 배치했다(종합 성격).

### 구현 중 내린 결정

- **점멸은 `motion-safe:animate-pulse`** — 모션 최소화 설정을 존중한다. 상시 표출
  화면에서 점멸이 불편한 사용자를 배제하지 않기 위함이다.
- **시계는 `document.hidden`일 때 멈춘다** — 이 앱은 탭 keep-alive라 다른 탭으로 가도
  컴포넌트가 살아 있다. 타이머를 방치하면 열어둔 화면 수만큼 초당 렌더가 쌓인다.
- **상태색은 테마 토큰 위에 얹었다** — 배경/글자는 `bg-surface`/`text-text`를 쓰고
  녹·황·적만 상태 표시에 쓴다. 라이트/다크 양쪽에서 대비가 유지된다.

### 검증 결과

- 프론트 `tsc --noEmit` 통과 (registry 생성기 포함)
- `pnpm --filter @eunsung/frontend test` **75/75 통과** — 페이지 등록 전수 검증기 포함
- `pageRegistry.generated.ts`에 `/oee/overall-status` case 생성 확인
- 백엔드 `tsc --noEmit` 통과 (메뉴 코드 3곳 반영)
- lint 지적 없음
- dev 서버에서 `/oee/overall-status` 컴파일·200 확인
- **미검증**: 실제 렌더 모습(타일 배치·색·점멸), 사이드바 메뉴 노출

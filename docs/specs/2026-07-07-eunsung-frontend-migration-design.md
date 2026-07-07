# 은성전장 고도화 MES 프론트 마이그레이션 설계

- 작성일: 2026-07-07
- 대상 저장소: `C:\Project\MES\Infinity21 MES SMT_EUNSUNG`
- 기준 참조: `C:\Project\HANES`
- 상태: 구현 전 설계

---

## 1. 목적

은성전장 기존 모니터링 중심 Next.js 앱을 HANES MES와 같은 운영형 프론트 구조로 확장한다.

1차 목표는 백엔드/DB 세부 로직이 아니라 **프론트 골격 마이그레이션**이다. 랜딩페이지, 로그인, 메인 업무 shell, 시스템관리, 메뉴/권한 UI, 도움말, 공통 UI 컴포넌트를 먼저 이식하고, 기준정보·수불관리·OEE 화면은 은성 PCB 생산 구조에 맞는 메뉴와 placeholder/service boundary를 만든다.

기존 Oracle DB 재사용, 프로시저 호출, 수불 저장, OEE 집계 등 세부 백엔드 계획은 화면별로 별도 설계한다.

---

## 2. 확정 결정

### 2.1 Monorepo 전환

현재 루트 Next.js 앱을 HANES식 monorepo로 전환한다.

```text
apps/
  frontend/    # 신규 은성 고도화 MES 프론트
packages/
  shared/      # 공통 타입, 코드값, 프론트/백엔드 공유 규칙
docs/
config/
oracle_db_scripts/
```

기존 모니터링 소스는 별도 앱으로 단절하지 않고, `apps/frontend` 안의 display route group으로 흡수한다.

### 2.2 업무 shell과 모니터링 shell 분리

업무 MES 화면과 모니터링 화면은 목적이 다르므로 같은 상단 네비게이션을 쓰지 않는다.

```text
apps/frontend/src/app
  page.tsx                         # 랜딩
  login/                           # 로그인
  (authenticated)/                 # 업무 MES shell
    layout.tsx                     # AuthGuard + MainLayout
    dashboard/
    master/
    inventory/
    material/
    product/
    oee/
    system/
  (display)/                       # 모니터링 전용 shell
    display/[screenId]/page.tsx
  api/display/*                    # 기존 모니터링 데이터 API
```

- 업무 화면: HANES `MainLayout`, `Header`, `Sidebar`, `TabBar`, `TabKeepAlive` 패턴 사용.
- 모니터링 화면: 기존 `DisplayLayout`, `DisplayHeader`, `DisplayFooter`, 자동 갱신, 대형 화면 가독성 패턴 유지.
- 모니터링 메뉴는 업무 shell에서 진입할 수 있지만, 진입 후 화면 chrome은 모니터링 전용으로 전환한다.

### 2.3 프론트 우선

이번 단계에서 백엔드/DB 상세는 확정하지 않는다.

- API 호출부는 service layer로 분리한다.
- 백엔드 미연결 상태에서도 shell, 메뉴, 라우팅, placeholder 화면은 렌더되어야 한다.
- 실제 DB 재사용 방식은 기준정보, 수불관리, OEE 화면별 후속 설계에서 정한다.

---

## 3. HANES에서 가져올 프론트 범위

### 3.1 전체 shell

- 랜딩페이지: `app/page.tsx`, landing components
- 로그인/인증 화면: `app/login`, `AuthGuard`, auth store
- 메인 레이아웃: `components/layout/MainLayout.tsx`
- 상단 네비게이션: `Header`, 메뉴 검색, 테마, 언어, 도움말 버튼
- 사이드바: `Sidebar`, `SidebarMenu`, DB 메뉴 트리 fallback 구조
- 탭: `TabBar`, `TabKeepAlive`, 클라이언트 네비게이션 유틸
- providers: toast, theme, i18n, auth hydration, 공통코드 preload

### 3.2 공통 UI/입력

- `components/ui`: Button, Input, Modal, Select, Badge, Card, StatCard, ComCodeBadge
- `components/shared`: BarcodeScanInput, ComCodeSelect, DateRangeFilter, FilterBar, PartSelect, ProcessSelect, EquipSelect, WarehouseSelect, WorkerSelect, StatusHeaderHelp
- 에러 처리: error store, error detail modal, API interceptor
- 도움말: HelpButton, HelpPanel, MarkdownRenderer
- AI 패널은 shell 수준에서 가져오되, 은성 문서/화면 색인은 후속으로 재구성한다.

### 3.3 시스템 기능 페이지

아래 페이지는 전체 이식 대상이다.

- `/system/users`
- `/system/roles`
- `/system/menu-categories`
- `/system/config`
- `/system/comm-config`
- `/system/department`
- `/system/document`
- `/system/training`
- `/system/scheduler`
- `/system/er-view`
- `/system/pda-roles`
- `/system/improvement-requests`

이 단계에서는 API 연결이 완료되지 않아도 화면 구조, 라우팅, 메뉴 배치, 빈 상태가 깨지지 않아야 한다.

---

## 4. 은성용 1차 메뉴 구조

```text
대시보드

모니터링
  - 제품생산현황
  - SMD 생산현황
  - 종합 F/P 현황
  - 라인별 생산현황
  - SMD 듀얼생산현황
  - 솔더 페이스트 관리
  - SPI 차트분석
  - AOI 차트분석
  - FCT 차트분석
  - VISION 차트분석

기준정보
  - 품목
  - BOM
  - 공정
  - 라우팅
  - 설비
  - 생산라인
  - 작업자
  - 창고
  - 거래처
  - 근무캘린더

수불관리
  - 자재입고
  - 자재출고
  - 자재재고
  - LOT 추적
  - 재고조정
  - 재고실사
  - 제품입고
  - 제품출고
  - 제품재고

OEE 관리
  - OEE 대시보드
  - 가동/비가동 입력
  - 생산실적 입력
  - 비가동 사유
  - 근무시간/캘린더

시스템관리
  - 사용자
  - 역할/권한
  - 메뉴관리
  - 시스템설정
  - 통신설정
  - 부서
  - 문서/교육
  - 스케줄러
  - ER View
  - 개선요청

도움말
```

하네스 전용 도메인 표현은 제거한다. 은성 업무 용어는 PCB 생산 흐름을 기준으로 SMT, 성능검사, 코팅, 라우팅, 조립, 검사/포장 중심으로 정리한다.

---

## 5. 화면 구현 원칙

### 5.1 업무 화면

- HANES의 조용하고 밀도 있는 운영 UI를 유지한다.
- 조회/입력 페이지는 DataGrid + filter bar + 우측 form/detail panel 패턴을 기본으로 한다.
- 코드성 값은 plain text보다 `ComCodeBadge`, `ComCodeSelect` 같은 선택/표시 컴포넌트를 우선한다.
- 스캐너 입력이 필요한 화면은 일반 input 조합보다 `BarcodeScanInput` 패턴을 사용한다.
- 백엔드가 없거나 미정인 화면은 명확한 빈 상태와 placeholder service를 둔다.

### 5.2 모니터링 화면

- 업무 shell의 Header/Sidebar/TabBar를 쓰지 않는다.
- 전체화면, 원거리 가독성, 자동 갱신, 자동 롤링, 라인 선택, SQL viewer 등 기존 display 목적을 유지한다.
- 기존 `/api/display/<screenId>` 경로와 `DisplayLayout` 계열을 우선 보존한다.
- 업무 메뉴에서 모니터링으로 진입할 수는 있지만, 진입 후에는 display 전용 layout이 화면을 지배한다.

---

## 6. 단계 계획

### Phase 1: 작업 공간 골격

- `apps/frontend` 생성.
- 루트 package/workspace/turbo 구조를 HANES 기준으로 맞춘다.
- 기존 루트 앱의 설정과 의존성은 `apps/frontend`로 흡수할 항목과 유지할 항목을 분리한다.

### Phase 2: HANES 프론트 shell 이식

- 랜딩, 로그인, providers, stores, layout, UI 컴포넌트, services/api를 이식한다.
- 브랜드를 `은성전장 MES` 또는 `EUNSUNG MES`로 변경한다.
- 하네스 전용 문구와 라우트를 은성 메뉴 기준으로 정리한다.

### Phase 3: 모니터링 route group 흡수

- 기존 `(display)`, `components/display`, `hooks/useDisplay*`, `lib/queries`, `api/display`를 신규 `apps/frontend` 구조 안에 유지한다.
- display 화면은 업무 shell과 독립된 route group으로 동작하게 한다.

### Phase 4: 시스템 페이지 이식

- 시스템관리 페이지 전체를 가져온다.
- API 연결부는 service boundary를 유지하고, 미연결 상태에서도 화면이 깨지지 않게 처리한다.

### Phase 5: 은성 업무 메뉴와 placeholder

- 기준정보, 수불관리, OEE 관리 메뉴를 생성한다.
- 각 leaf route는 은성용 제목, 설명 없는 빈 상태, 향후 service 경계를 갖춘 placeholder로 둔다.
- 화면별 실제 DB/API 연결은 별도 설계에서 진행한다.

### Phase 6: 검증

- `apps/frontend` 개발 서버 실행.
- 랜딩, 로그인, 업무 shell, 시스템 페이지, 기준정보/수불/OEE placeholder route 진입 확인.
- 모니터링 `/display/[screenId]` 진입과 기존 display layout 유지 확인.
- 백엔드 미연결 상태에서 치명적 런타임 오류가 없는지 확인.

---

## 7. 비범위

- 은성 Oracle 테이블별 원장 확정.
- 기존 프로시저/트리거 호출 방식 확정.
- 수불 저장/취소 로직 구현.
- OEE 집계 테이블/프로시저 구현.
- 권한 seed와 운영 사용자 마이그레이션.
- 실제 배포/PM2/GitHub Actions 변경.

이 항목은 프론트 shell 이식 후 화면 단위로 다시 설계한다.

---

## 8. 성공 기준

- `apps/frontend`에서 은성 브랜드의 랜딩과 업무 shell이 실행된다.
- HANES 수준의 상단 네비게이션, 사이드바, 탭, 시스템 페이지 라우팅이 동작한다.
- 기존 모니터링 화면은 업무 shell과 다른 display 전용 layout으로 열린다.
- 기준정보, 수불관리, OEE 관리 메뉴가 은성 PCB 생산 기준으로 보인다.
- 백엔드/DB 미연결 상태에서도 주요 프론트 라우트가 빈 상태 또는 placeholder로 렌더된다.
- 후속 화면별 백엔드/DB 계획을 세울 수 있도록 API 호출부가 service boundary로 분리되어 있다.

# OEE MOBILE 구현 계획

**Goal:** 10인치 Android 가로형 MOBILE에서 1층 SMT와 2층 조립공정 작업자가 OEE 입력을 빠르고 안전하게 기록하도록 기존 `/oee/entry`를 현장용 단일 입력 경험으로 완성한다.
**Architecture:** `/oee/entry`를 canonical MOBILE route로 유지하고, 서버 계약이 없는 `/oee/equip-downtime-mobile` 목업의 스캔 및 비가동 시작·종료 경험을 이 경로에 통합한다. 인증된 NestJS OEE API와 `@smt/shared` 검증을 사용하며, 실제 Oracle 기준정보와 업무 규칙을 확인하지 않은 값은 코드에 만들지 않는다.
**Spec:** `docs/specs/2026-07-06-oee-management-design.md`

## Global Constraints

- 제품 용어는 PDA와 태블릿을 구분하지 않고 `MOBILE`로 통일한다.
- 대상은 1층 SMT와 2층 조립공정의 OEE 현장입력이며 재고, 수불, 마감, 대시보드, 기준정보 관리는 제외한다.
- 목표 기기는 10인치 Android, 가로 화면이다. 화면은 데스크톱에서도 깨지지 않아야 하지만 모바일 산업현장 사용성을 우선한다.
- canonical route는 `/oee/entry`다. `/oee/equip-downtime-mobile`은 별도 업무 계약으로 확장하지 않는다.
- 작업자 흐름은 사번 식별, 담당 공정·라인/셀 확인, 리소스 스캔 또는 선택, 비가동 시작, 사유 선택, 선택 메모, 비가동 종료를 최소 단계로 제공한다.
- 현재 범위를 `@Public()` 쓰기 API로 출시하지 않는다. 조직은 인증 컨텍스트에서 가져오고 요청 body의 `organizationId`를 신뢰하지 않는다.
- 시작·종료 시각은 서버가 결정한다. 사용자가 임의로 서버 기록시각을 조작하는 UI를 기본 흐름에 두지 않는다.
- 중복 탭과 재시도는 동일 이벤트가 중복 저장되지 않도록 API 계약에서 처리한다. 오프라인 큐는 이번 범위에서 제외하고 연결 실패 시 초안을 유지한 온라인 재시도만 제공한다.
- 비가동 사유, 공정별 근무시간, SMT 라인과 조립 셀/설비의 리소스 매핑은 실제 기준정보로 검증한다.
- 프론트와 백엔드가 공유하는 검증 규칙은 `packages/shared`에 한 번만 정의한다.
- DB 스키마 변경은 별도 승인 없이는 하지 않는다.

## Milestones And Master Checkpoints

| Milestone | 산출물 | Coach 완료 기준 | Master 확인 |
|---|---|---|---|
| M0 범위 고정 | 본 계획, 협업 체크포인트 | canonical route와 포함·제외 범위 명시 | 오전 보고 |
| M1 요구사항 | actor/state/error/acceptance matrix | 근거·가정·결정이 분리됨 | 수시 게이트 |
| M2 화면설계 | 10인치 가로 화면 흐름과 상태 설계 | SMT/조립 차이와 실패 상태 포함 | 오후 보고 |
| M3 계약설계 | API, 인증, 시간, 중복, Oracle 매핑 | 구현자가 추측할 계약이 없음 | 수시 게이트 |
| M4 TDD 구현 | focused red-green evidence | 승인된 범위만 최소 구현 | 저녁 보고 |
| M5 실제 검증 | typecheck/test/API/Oracle/render evidence | 실제 데이터 경로와 화면 확인 | 완료 게이트 |

Coach는 최소 오전·오후·저녁 세 번 진행상황을 체크포인트로 남기고, 범위·API·DB 계약 또는 실제 데이터가 설계와 충돌하면 즉시 Master 확인 항목으로 올린다.

### Task 1: 요구사항과 화면 대상 확정

**Files:** `docs/reports/oee-mobile-collaboration/`, `docs/specs/2026-07-06-oee-management-design.md`, 실제 OEE 프론트·백엔드 경로

1. `luna_planner`가 최신 Master 지시와 실제 구현을 대조한다.
2. `/oee/entry` 하나를 route 단위 설계 대상으로 두고, 그 안의 작업자 식별·리소스 확인·비가동 기록·현재조 이력을 screen state 또는 step으로 정의한다.
3. 생산수량 입력은 기존 OEE 설계 요구와 실제 데이터 원천을 대조해 같은 MOBILE 흐름에 포함할지 명시한다. 원천이 불명확하면 비가동 MVP 이후 항목으로 분리한다.
4. `/oee/equip-downtime-mobile`, 대시보드, 마스터, 재고·수불 화면은 제외 사유를 기록한다.
5. actor, 입력, 출력, 상태, 오류, 빈 상태, 권한, acceptance criteria를 작성한다.
6. Coach가 화면 대상을 승인한 뒤에만 상세 화면설계를 시작한다.

### Task 2: 10인치 Android 가로 화면설계

**Files:** 승인된 requirements artifact, 기존 공용 컴포넌트와 layout

1. 최초 설정과 일상 작업 흐름을 분리한다.
2. SMT는 라인 단위, 조립은 실제 검증된 셀/설비 단위를 반영한다.
3. 스캔 성공·실패·수동 대체, 가동·비가동·미저장·저장 중·재시도 상태를 설계한다.
4. 주요 터치 타깃 64dp 이상, 주요 동작 높이 72dp 이상, 색상 외 텍스트·아이콘 상태 표현을 적용한다.
5. 실수로 재스캔하거나 화면을 이탈할 때 미저장 작업 보호 방식을 정의한다.
6. 접근성, 로딩, 빈 상태, API 오류와 느린 네트워크 acceptance criteria를 작성한다.

### Task 3: 인증·API·데이터 계약 승인

**Files:** `apps/backend/src/modules/oee/`, OEE entities, `packages/shared/src/oee/`, 관련 frontend services/hooks

1. `@Public()` 제거 범위와 `JwtAuthGuard`, `@OrganizationId()` 적용을 설계하고 Guard 메타데이터 테스트를 먼저 준비한다.
2. 작업자 사번 스캔값과 로그인 사용자의 관계를 정의한다.
3. 리소스 조회 키를 실제 Oracle 마스터와 확인한다.
4. 비가동 시작·종료를 기존 구간 replace와 이벤트형 API 중 어떤 계약으로 처리할지 데이터 무결성 기준으로 결정한다.
5. 서버 KST 시각, 업무일·교대 경계, 동시성, idempotency 계약을 확정한다.
6. 실제 사유코드, 근무시간, 리소스 데이터의 Oracle 건수와 샘플을 기록한다.

### Task 4: TDD 구현

**Files:** 승인된 설계에서 지정한 최소 frontend/backend/shared 파일

1. `lunar_impl`에 승인된 설계, 계약, acceptance criteria를 전달한다.
2. Guard, 조직 격리, 상태 전이, 중복 요청, 검증 규칙의 focused test를 먼저 실패시킨다.
3. 최소 백엔드·shared 구현으로 테스트를 통과시킨다.
4. 화면 상태와 주요 작업 흐름의 focused test를 먼저 실패시킨 뒤 최소 UI를 구현한다.
5. 생성 registry는 직접 수정하지 않고 프로젝트 명령으로 갱신·검증한다.

### Task 5: 엔드투엔드 검증과 정리

**Verification:**

1. `pnpm --filter @eunsung/frontend typecheck`
2. `pnpm --filter @eunsung/frontend test`
3. `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false`
4. `pnpm --filter @eunsung/backend test -- --runInBand` 또는 변경 모듈의 focused Jest 명령
5. Oracle 기대 건수 → 인증된 백엔드 API → 프론트 요청 → 렌더된 상태 순으로 실제 데이터 확인
6. 사용자 dev 서버가 실행 중이면 10인치 가로 viewport에서 스캔 대체 흐름, 비가동 시작·사유·종료, 오류·재시도를 직접 확인
7. superseded 목업 route와 메뉴 항목을 제거하거나 canonical route로 명확히 정리하고 registry 검증 수행

## Open Decisions Owned By Coach

- 생산수량 입력을 비가동 MVP에 함께 포함할지는 실제 수집 원천과 현장 책임자를 확인한 뒤 M1에서 결정한다.
- 조립 리소스 단위는 실제 기준정보 확인 전 `셀/설비` 중 하나로 고정하지 않는다.
- 기존 근무조 전체 replace API를 현장 시작·종료에 그대로 사용하지 않는다. 동시 작업 손실 가능성을 평가한 뒤 계약을 결정한다.
- `/oee/equip-downtime-mobile` 삭제 또는 redirect 시점은 canonical 화면의 acceptance criteria 통과 후로 한다.

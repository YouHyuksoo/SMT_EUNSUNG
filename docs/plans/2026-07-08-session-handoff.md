# 세션 핸드오프 — 은성전장 MES (2026-07-08)

다음 세션 또는 다른 에이전트가 바로 이어서 작업하기 위한 현재 상태 요약이다.
이 문서는 2026-07-08 현재 `main` 기준으로 갱신했다.

## 0. 현재 기준 상태

- 기준 브랜치: `main`
- 기준 커밋: `385b4c2`
- 원격 추적 상태: `main...origin/main` 차이 없음
- 작업 전환 전 미커밋 변경은 폐기하지 않고 stash에 보존했다.
- 현재 세션의 문서 최신화 변경은 이 파일에 반영했다.

보존된 stash:

| Stash | 설명 |
|---|---|
| `stash@{0}` | `On main: codex-clean-main-after-switch-20260708` |
| `stash@{1}` | `On refactor/menu-org-tenant-and-inspection-cleanup: codex-before-switch-to-main-20260708` |
| `stash@{2}` | `On refactor/menu-org-tenant-and-inspection-cleanup: epitaxy: pre-switch from refactor/menu-org-tenant-and-inspection-cleanup` |

최근 `main` 커밋:

- `385b4c2 WIP: epitaxy pre-switch from refactor/menu-org-tenant-and-inspection-cleanup`
- `f9d5af0 fix eunsung master mappings and trim system menus`
- `e149aa1 fix users API module registration`
- `be595d9 fix department API module registration`
- `837a92b restore system menu category`
- `666ed01 rename comm config table to isys`
- `f202bd7 fix comm config table and sidebar icons`
- `8da646f remove material management pages`

## 1. 환경 핵심

- 모노레포: pnpm + turborepo
- 백엔드: `apps/backend` (`@eunsung/backend`, NestJS, 포트 3003)
- 프론트엔드: `apps/frontend` (`@eunsung/frontend`, Next.js, 포트 3100)
- 공유 패키지: `packages/shared` (`@smt/shared`)
- DB: Oracle, `oracle-db` 사이트명 `ESDBext`, 스키마 `INFINITY21_JSMES`
- 서버는 사용자가 직접 기동한다. 에이전트가 임의로 dev 서버나 대체 포트를 띄우지 않는다.
- DB/DDL/DML 작업은 실제 스키마를 먼저 확인하고 `oracle-db` connector로 적용/검증한다.

## 2. 현재 확립된 개발 규약

- package manager는 `pnpm`만 사용한다.
- `main`에서 작업한다는 지시가 있으면 먼저 브랜치와 dirty tree를 확인한다.
- dirty tree가 있으면 버리거나 덮어쓰지 말고 stash 또는 사용자 확인으로 보존한다.
- 프론트/백엔드/shared가 같이 바뀌면 각 워크스페이스 타입체크를 별도로 수행한다.
- 인증형 MES 업무 화면은 `apps/frontend/src/app/(authenticated)` 아래를 기준으로 한다.
- 백엔드 신규 모듈 활성화 시 `app.module.ts`, `database.module.ts`, 관련 entity/provider/test 경로를 함께 확인한다.
- 메뉴 코드는 메뉴 식별자와 DB 테이블명을 혼동하지 않는다. 예: `SYS_SCHEDULER`는 메뉴 코드이고, 스케줄러 테이블명 변경 대상이 아니다.

## 3. 최근 확인된 시스템 상태

- `main`과 `origin/main`은 현재 동일 커밋이다.
- 직전 전환 작업에서 `refactor/menu-org-tenant-and-inspection-cleanup` 브랜치의 변경은 stash에 보존했다.
- `docs/README.md` manifest는 `standardVersion: 1`이며, docs 정리 작업은 이 manifest를 기준으로 한다.
- 현재 docs 직하위 허용 구조:
  - `docs/README.md`
  - `docs/plans/`
  - `docs/specs/`
  - `docs/sql/`
  - `docs/reports/`는 core 폴더지만 별도 보고서가 필요할 때만 사용한다.

## 4. OEE 현황

근거 문서:

- `docs/specs/2026-07-06-oee-management-design.md`
- `docs/plans/2026-07-06-oee-foundation.md`
- `docs/plans/2026-07-06-oee-input.md`
- `docs/plans/2026-07-06-oee-dashboard.md`

현재 유지해야 할 전제:

- OEE는 WebDisplay 전용 구조가 아니라 NestJS 백엔드 + authenticated 프론트 구조로 재배치하는 방향이다.
- OEE 계산/검증 로직은 `packages/shared` 쪽 공용 규칙을 우선한다.
- DB 작업은 `ESDBext` 실제 객체와 동기화 여부를 확인한 뒤 진행한다.

남은 OEE 후보 작업:

- OEE 대시보드 앱층 완성
- 근무시간 마스터 화면
- 입력 화면 수량/plan-time 자동로드
- 원자재준비/고객불량 입력
- `P_OEE_BUILD_SUMMARY` 정기 실행 스케줄러 연결 여부 결정

## 5. 문서 정리 현황

`managing-docs` manifest 기준으로 확인한 내용:

| 항목 | 현재 판단 |
|---|---|
| 미등록 docs 폴더 | 없음 |
| docs 루트 md 오염 | 없음 (`README.md`만 허용) |
| 살아있는 문서 frontmatter 누락 | 현재 살아있는 문서가 없어 대상 없음 |
| 외부 문서 집합 | 등록 없음 |
| SQL 파일명 의심 | `docs/sql/oee_tables_ext_snapshot.sql`, `docs/sql/oee_tables_snapshot.sql`는 manifest의 `kebab-case.sql` 규칙과 다름 |
| 위치 의심 | `docs/plans/*-design.md` 일부는 specs 명명규칙과도 맞아 내용 확인 후 이동 후보 |

정리 후보:

1. `docs/sql/oee_tables_ext_snapshot.sql` → `docs/sql/oee-tables-ext-snapshot.sql`
2. `docs/sql/oee_tables_snapshot.sql` → `docs/sql/oee-tables-snapshot.sql`
3. `docs/plans/*-design.md` 중 구현 전 설계 문서인 것은 `docs/specs/`로 이동 검토

이동/삭제는 manifest 원칙상 사용자 승인 후 `git mv`로 처리한다.

## 6. 다음 작업 시 주의

- stash에 보존된 변경을 적용하기 전에는 반드시 `git stash show --stat stash@{n}`로 범위를 확인한다.
- 이전 브랜치 변경을 `main`에 합칠지 여부는 파일 단위로 판단한다.
- 문서 최신화 요청이 있으면 기존 상태 문서도 최신 내용으로 갱신한다. 새 보고서만 만들고 기존 handoff를 방치하지 않는다.
- 커밋 요청 시 전체 dirty tree를 확인하고, 의도한 문서/코드만 stage한다.

## 다음 세션 추천 스킬

- `oracle-db`: ESDBext 스키마/DDL/PLSQL 확인 및 적용
- `managing-docs`: docs 구조 정리, 기존 문서 최신화
- `frontend-design`: authenticated 업무 화면 UI 작업
- `verification-before-completion`: 완료 주장 전 검증

# OEE 사용자 관리형 리소스 구현·DB 검증

- 검증일: 2026-08-21
- 대상 DB: `EUNSUNG_DEV_ESDBPDB`
- 결정 근거: `docs/adr/0003-oee-user-managed-line-resources.md`
- 상태: 소스·Oracle 검증 완료, 현재 workspace 런타임 화면 검증 대기

## 구현 결과

- `/oee/master/resource` 관리 화면을 추가했다.
- 인증 조직의 `IP_PRODUCT_LINE`에서 라인을 선택하고 SMT/ASSY, LINE/CELL을 직접 등록한다.
- 같은 조직의 라인코드는 `OEE_RESOURCE`에 한 건만 등록할 수 있다.
- 모바일 리소스 목록과 입력 검증을 고정 코드 목록 대신 활성 `OEE_RESOURCE` 기준으로 전환했다.
- 모바일 LINE/CELL 유형과 서버가 반환한 부모 라인 코드를 보존한다.
- SMT는 `SMTWORKTIME`, ASSY는 `WORKTIME`을 사용한다.
- 이력이 있는 리소스의 공정·유형 변경과 물리 삭제는 `OEE_RESOURCE_IN_USE`로 거부한다.
- 고정 18개 리소스 seed는 routine deployment에서 제거하고 manual bootstrap으로 이동했다.

## Oracle 적용

적용 파일:

1. `oracle_db_scripts/oee/12_resource_management_contract.sql`
2. `oracle_db_scripts/oee/04_view_plan_time.sql`
3. `oracle_db_scripts/oee/05_view_live.sql`
4. `oracle_db_scripts/oee/06_proc_build_summary.sql`

모든 파일은 `oracle-db --execute-file`에서 블록 1개씩 성공했다. `V_OEE_PLAN_TIME` 재생성 직후 의존 객체가 INVALID가 되어 manifest 순서대로 `V_OEE_LIVE`, `P_OEE_BUILD_SUMMARY`를 재배포했다.

최종 객체 상태:

| 객체 | 유형 | 상태 |
|---|---|---|
| `V_OEE_PLAN_TIME` | VIEW | VALID |
| `V_OEE_LIVE` | VIEW | VALID |
| `P_OEE_BUILD_SUMMARY` | PROCEDURE | VALID |

`USER_ERRORS` 조회 결과는 0건이다.

## 리소스 무결성

적용 전 개발 DB의 `OEE_RESOURCE`는 18건이고 NULL `REF_CODE`와 `(ORGANIZATION_ID, REF_CODE)` 중복은 0건이었다.

적용 후:

| 항목 | 결과 |
|---|---|
| 리소스 건수 | 18 |
| `RESOURCE_ID` 합계 | 657 |
| 데이터 SHA-256 | `4079C7A0678EA53C9885F23782B2E225989FFC401B5755EECB8669E5D7F62B36` |
| unique index | `UX_OEE_RESOURCE_REF (ORGANIZATION_ID, REF_CODE)` |
| 공정 제약 | `PROCESS_CODE IN ('SMT', 'ASSY')`, ENABLED/VALIDATED |
| 유형 제약 | `RESOURCE_TYPE IN ('LINE', 'CELL')`, ENABLED/VALIDATED |
| 사용 제약 | `USE_YN IN ('Y', 'N')`, ENABLED/VALIDATED |

기존 SMT 12건과 ASSY 6건의 `RESOURCE_ID`는 유지됐다.

## 계획시간 검증

`V_OEE_PLAN_TIME`을 `OEE_RESOURCE`와 결합한 현재 결과:

| 공정 | 유형 | 행 수 |
|---|---|---:|
| SMT | LINE | 240 |
| ASSY | LINE | 120 |

현재 DB에는 CELL 등록이 없어 CELL 계획행은 0건이다. View 계약과 정적 테스트는 LINE/CELL을 모두 포함한다.

## 자동 검증

| 명령 | 결과 |
|---|---|
| `pnpm --filter @eunsung/backend test -- --runInBand src/modules/oee` | 9 suites, 97 tests 통과 |
| `pnpm --filter @eunsung/backend exec tsc --noEmit --pretty false` | 통과 |
| `pnpm --filter @eunsung/frontend test` | 41 tests 통과, page/menu registry 검증 통과 |
| `pnpm --filter @eunsung/frontend typecheck` | 통과 |
| `git diff --check` | 통과 |

## 런타임 검증 대기 사유

포트 3003과 3100은 열려 있지만 현재 프로세스는 이 workspace가 아닌 다음 경로에서 실행 중이다.

```text
D:\Orca\ESFA_P2026\SMT_EUNSUNG\apps\backend\dist\main
D:\Orca\ESFA_P2026\SMT_EUNSUNG\node_modules\...\next\dist\server\lib\start-server.js
```

따라서 현재 서버에서 신규 `/oee/master/resource`는 404이고 `/api/oee/resource` 응답도 변경 전 엔티티 계약이다. 저장소 규칙에 따라 서버를 임의로 재시작하거나 대체 포트로 띄우지 않았다.

현재 workspace 서버를 사용자가 다시 기동한 뒤 다음 순서의 최종 확인이 필요하다.

1. 인증된 `GET /api/v1/oee/resource`와 `/api/v1/oee/resource/candidates`
2. 프론트 proxy `/api/oee/resource`
3. `/oee/master/resource`의 18개 렌더 순서
4. 미등록 라인의 CELL 등록과 모바일 선택
5. 이력 없는 리소스 삭제 성공 및 이력 있는 리소스 409

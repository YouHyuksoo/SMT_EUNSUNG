# OEE A~J 대시보드 개발 DB 배포 결과

- 작성일: 2026-08-13
- 작성 계기: OEE MOBILE의 A~J 업무구간과 대시보드 계산 원천을 통합하고 개발 DB에서 실제 검증
- 대상 DB: `EUNSUNG_DEV_ESDBPDB`, schema `INFINITY21_JSMES`

## 요약 (결론 먼저)

- 대시보드의 `SHIFT` 컬럼명은 API 호환을 위해 유지하고 값은 `A~J` 업무구간으로 통일했다.
- `V_OEE_PLAN_TIME`은 실제 `ICOM_WORKTIME_RANGES`의 `SMTWORKTIME`/`WORKTIME`을 사용한다.
- `V_OEE_LIVE`는 `OEE_DOWNTIME_EVENT`를 구간 시작·종료 시각으로 잘라 가동시간을 계산한다.
- SMT LINE 12건과 ASSY CELL 15건, 총 27건을 `OEE_RESOURCE`에 동기화했다.
- `V_OEE_PLAN_TIME`, `V_OEE_LIVE`, `P_OEE_BUILD_SUMMARY`는 모두 `VALID`이고 `USER_ERRORS`는 0건이다.
- 기존 ASSY CELL 50 이벤트 22번의 0.2667분이 2026-08-08 C구간에 정확히 반영됐다.

## 상세

### 배포 순서

1. `oracle_db_scripts/oee/01_tables.sql`
2. `oracle_db_scripts/oee/03_tables_ext.sql`
3. `oracle_db_scripts/oee/09_seed_dashboard_resources.sql`
4. `oracle_db_scripts/oee/04_view_plan_time.sql`
5. `oracle_db_scripts/oee/05_view_live.sql`
6. `oracle_db_scripts/oee/06_proc_build_summary.sql`

미승인 사유를 포함하는 `02_seed_reason.sql`은 실행하지 않았다. 각 테이블 DDL과 리소스 시드는 두 번째 실행도 성공했고 리소스 건수는 27건으로 유지됐다.

### Oracle 실측

- `SMTWORKTIME`: A~J 10건, 중복 0건
- `WORKTIME`: A~J 10건, 중복 0건
- `OEE_RESOURCE`: SMT LINE 12건, ASSY CELL 15건
- 현재 업무일 계획행: SMT 120건, ASSY 150건
- 현재 업무일 실시간행: 완료 구간과 진행 중 구간만 반환
- 2026-08-08 이벤트 22: ASSY/CMA/C구간, 이벤트 0.2667분 = 구간 반영 0.2667분

### API 및 화면

- `GET /api/v1/oee/dashboard/drilldown?processCode=SMT&date=2026-08-13`: HTTP 200, 24행, A/B 구간과 계산 피연산자 반환
- `GET /api/v1/oee/dashboard/drilldown?processCode=ASSY&date=2026-08-13`: HTTP 200, 30행, A/B 구간 반환
- `GET /oee/dashboard/drilldown?processCode=SMT&date=2026-08-13`: HTTP 200
- 브라우저 화면은 기존 드릴다운 안의 읽기 전용 계산 검증 패널을 사용하며 별도 route를 추가하지 않았다.

### 검증 명령

- OEE focused Jest: 3 suites, 14 tests passed
- backend TypeScript: passed
- `git diff --check`: passed
- Oracle DDL 재실행: passed

## 후속 조치

- `OEE_RESOURCE.IDEAL_CT`와 `OEE_PRODUCTION_RESULT` 실적이 현재 비어 있다. 따라서 가동율은 실제 계산되지만 성능율·양품율·OEE는 0이며 화면에서 누락 원인으로 확인된다.
- 승인된 CT 및 생산실적 원천을 연결한 뒤 성능율·양품율·OEE의 실제값을 추가 검증해야 한다.
- 과거 스냅샷은 업무일 J구간 종료 후 `P_OEE_BUILD_SUMMARY`를 실행해 생성한다. 이번 작업에서는 프로시저를 직접 실행하지 않았다.
- loss API 단건 호출 중 백엔드 DB 연결이 일시적으로 503을 반환했다. 동일 시점의 Oracle 직접 조회와 drilldown API는 정상이며, 서버 연결 안정화 후 loss API를 재확인한다.

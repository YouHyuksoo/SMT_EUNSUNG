# OEE 리소스 유형 변경 409 incident

- 발생일: 2026-08-21
- 요청: `PUT /oee/resource/95`, ASSY LINE → ASSY CELL
- 최초 결과: `409 OEE_RESOURCE_IN_USE`
- 최종 결과: 수정 성공 및 연결 이력 이관 확인

## 직접 원인

`OeeMasterService.updateResource()`가 수정과 삭제에 같은 이력 보호 기준을 적용해 `OEE_DOWNTIME_EVENT` 1건이 있는 리소스의 공정·유형 변경을 거부했다.

## 프로세스 원인

물리 삭제의 이력 보호 조건을 수정 정책에도 그대로 적용했고, 사용자가 선택한 LINE/CELL 분류를 사후 정정하는 실제 시나리오가 acceptance test에 없었다.

## 수정

공정·유형 변경 시 다음 데이터를 하나의 Oracle PL/SQL 문장으로 이관한다.

- `OEE_DOWNTIME_EVENT.PROCESS_CODE`, `RESOURCE_TYPE`
- `OEE_OPERATION_LOG.PROCESS_CODE`
- `OEE_PRODUCTION_RESULT.PROCESS_CODE`
- `OEE_DAILY_SUMMARY.PROCESS_CODE`
- `OEE_RESOURCE.PROCESS_CODE`, `RESOURCE_TYPE`

라인코드 변경은 계속 금지하고 이력 있는 리소스의 물리 삭제도 계속 거부한다.

## 실제 검증

| 항목 | 결과 |
|---|---|
| 화면 | 라인 19가 `ASSY / CELL`로 렌더됨 |
| `OEE_RESOURCE` | `RESOURCE_ID=95`, `ASSY`, `CELL`, `REF_CODE=19` |
| `OEE_DOWNTIME_EVENT` | `EVENT_ID=41`, `ASSY`, `CELL`, `RESOURCE_CODE=19` |
| `V_OEE_PLAN_TIME` | `RESOURCE_ID=95` 계획시간 20행 유지 |
| Backend OEE 테스트 | 9 suites, 97 tests 통과 |
| Backend typecheck | 통과 |
| `git diff --check` | 통과 |

## 재발 방지

`oee-master.service.spec.ts`가 이력이 존재하는 공정·유형 변경의 성공과 다섯 테이블의 원자적 이관 SQL을 검증한다.

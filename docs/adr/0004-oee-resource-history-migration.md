# 0004. OEE 리소스 공정·유형 변경 시 이력 이관

- 결정일: 2026-08-21
- 상태: 승인
- 대상: OEE 리소스 관리 수정 API와 연결 이력
- 보완 결정: `0003-oee-user-managed-line-resources.md`

## 배경

`0003` 구현은 비가동 이벤트나 생산·요약 이력이 있으면 OEE 리소스의 공정·유형 변경을 거부했다. 그러나 사용자가 LINE/CELL과 SMT/ASSY를 직접 관리하는 계약에서는 기존 분류를 정정할 수 있어야 한다. 이력 차단은 라인 19를 LINE에서 CELL로 변경하려는 정상 요청을 `OEE_RESOURCE_IN_USE`로 거부했다.

## 결정

1. `REF_CODE`인 라인코드는 등록 후에도 변경하지 않는다.
2. 공정·유형 변경은 이력 존재 여부와 관계없이 허용한다.
3. `OEE_DOWNTIME_EVENT`의 조직·기존 공정·기존 유형·리소스 코드가 일치하는 행은 새 공정·유형으로 함께 이관한다.
4. `OEE_OPERATION_LOG`, `OEE_PRODUCTION_RESULT`, `OEE_DAILY_SUMMARY`의 같은 `RESOURCE_ID` 공정 스냅샷도 함께 이관한다.
5. 이력 이관과 `OEE_RESOURCE` 수정은 하나의 Oracle PL/SQL 문장으로 원자적으로 실행한다.
6. 수정 중 리소스 자연키가 달라지면 전체 문장을 실패시킨다.
7. 물리 삭제는 기존과 같이 이력이 한 건이라도 있으면 거부한다.

## 결과

- 사용자는 기존 비가동 이벤트가 있는 리소스도 LINE/CELL 또는 SMT/ASSY로 재분류할 수 있다.
- `V_OEE_LIVE`의 자연키 조인과 공정별 계획시간 연결이 변경 후에도 유지된다.
- `oee-master.service.spec.ts`가 이력 이관 대상 테이블과 bind 계약을 검증한다.

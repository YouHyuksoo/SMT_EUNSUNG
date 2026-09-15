# 다중입력 원장 전환 및 일괄 처리 구현 계약

## 승인된 요구사항

사용자와 grill-me로 확정한 모바일 다중입력 단일 화면의 개발 계약이다. 상세 화면설계 HTML은 이번 산출물이 아니다.

- 보조 테이블 없이 IP_EQUIP_DOWNTIME_RESULT에만 저장. 식별자는 인증 조직 + DT_SEQ.
- LINE_CODE 추가 승인 및 개발 DB 적용 완료. 기존 행은 NULL로 남기고 신규 라인 기반 행만 새 처리에 포함한다. ENTER_DATE는 생성 로그로만 기록한다.
- RUN/설비 선택 없음, 작업장 ALL 제거. 기존 SMT/ASSY와 라인 선택 UI 및 7인치 별칭 유지.
- 시작 사유 선택 입력, 종료 사유 필수. 종료 시 선택 건 전체에 최종 사유 덮어쓰기.
- 시작 및 종료는 각각 한 번의 API와 한 트랜잭션으로 전체 성공 또는 전체 취소. 같은 묶음의 시각은 서버에서 한 번 정하고 공통 적용. 사용자 시각 편집 없음.
- 라인별 미종료 한 건만 허용. 동시성은 조직 + 라인 마스터 행을 정렬하여 잠근 후 원장 상태 재검증.
- 통신 오류는 자동 재전송 금지, 재조회로 상태 확인. 확정할 수 없는 요청은 결과 확인 필요로 남기고 성공으로 추정하지 않는다. 확인 전 중복 제출 방지.
- work-result와 기존 단건 모바일 API는 변경 범위 밖. 실적번호 생성 로직은 바꾸지 않고 기존 SEQ_IP_EQUIP_DOWNTIME를 신규 INSERT에 사용한다.

## Coordinator 구현 계약

- 전용 `oee/multi-entry` 컨트롤러/서비스로 새 원장 경로를 제공한다. 기존 resources/workers/reasons API 재사용.
- 인증 JwtAuthGuard 필수. 조직·사용자는 인증 컨텍스트만 신뢰한다.
- GET `oee/multi-entry/status?processCode=SMT|ASSY&lineCode=...` → `{workDate, workSegment, state, events, openEvent}`. 이벤트 필드는 실제 원장 lowerCamelCase: dtSeq, organizationId, lineCode, reasonCode, memo, worker, startTime, endTime. 일별 이력은 기존 업무시간 정의 사용, 미종료 조회는 날짜 제한 없음. LINE_CODE NULL인 기존 행 제외.
- POST `oee/multi-entry/start` → body `{processCode, lineCodes: string[], workerId, reasonCode?: string, memo?: string}`, response `{events: [...]}`.
- POST `oee/multi-entry/end` → body `{processCode, items: [{lineCode, dtSeq}], reasonCode: string}`, response `{events: [...]}`.
- 중복 대상, 비어 있는 묶음, 잘못된 공정/라인/작업자/사유, 다른 조직 접근, 이미 시작/종료한 대상은 전체 실패. 유효 길이는 실제 원장 및 마스터 규격을 따른다.
- 종료 UPDATE는 조직 + DT_SEQ + LINE_CODE 및 END_TIME IS NULL로 대상 고정. ENTER_DATE/ENTER_BY 유지, LAST_MODIFY 로그 기록. 시작 RUN_NO/MACHINE_CODE NULL.
- 서버 시간은 현재 KST 전제를 유지. Oracle raw bind는 호출마다 새 값/객체 사용.
- 추가 DDL/보조 테이블/기존 데이터 DML 금지. 인덱스나 추가 컬럼이 필요하면 escalation.
- 프론트는 새 API만으로 다중입력 상태/명령을 처리하며, 다른 화면용 기존 단건 계약을 바꾸지 않는다.
- 전송 결과를 모르면 같은 명령을 자동/실패건 재전송하지 않는다. 상태 재조회는 POST가 아닌 GET만 사용. 상태 변화만으로 요청 성공을 단정하지 않는다.

## 완료 기준

- 사유 선택/필수 및 일괄 overwrite, 공통 시각, 트랜잭션 rollback, 동시 시작 보호, 조직 경계, 기존 NULL 라인 데이터 제외, 오래된 종료 요청 보호에 대한 의미 있는 회귀 테스트.
- 인증 Guard 메타데이터 테스트 및 DTO 검증 테스트.
- 프론트 일괄 요청 한 번, ALL 제거, 통신 오류 시 재조회 및 제출 잠금 회귀 테스트.
- 백엔드 집중 Jest/tsc, 프론트 집중 테스트/typecheck.
- 가능한 실행 환경에서 Oracle → 인증 백엔드 → 프록시 → 렌더 검증. 불가능한 경로는 미완료 보고서에 정확히 남기며 전체 완료를 주장하지 않는다.

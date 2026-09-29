# 다중입력 기존 설비 실적 포함 및 화면 전환 정리

## 사용자 승인과 범위

사용자는 기존 실적을 포함하려고 설비 라인 대체를 요청했으며, 같은 라인의 복수 미종료 실적을 모두 종료하는 방식과 아래 UI/메뉴 변경을 승인했다. 이 계약은 기존 데이터 제외 및 라인별 미종료 한 건 응답 계약을 대체한다.

1. 유효 라인은 실적 LINE_CODE 우선, NULL이면 동일 조직 IMCN_MACHINE의 MACHINE_CODE에 해당하는 LINE_CODE를 사용한다. 원장이나 설비 라인을 임의 UPDATE하여 채우지 않는다.
2. 상태·이력·시작 중복 검사·종료 대상 검사·응답 모두 동일한 유효 라인 기준이다. 모두 NULL인 실적은 어느 라인에도 귀속시키지 않는다. 다른 조직의 설비로 대체하지 않는다.
3. 한 라인에 미종료가 여러 건이면 모두 표시·종료 대상으로 처리한다. 미종료가 하나라도 있으면 신규 시작 차단.
4. 선택된 모든 실적은 한 트랜잭션으로 최종 사유 및 서버 종료 시각을 공통 적용한다. 조회 이후 종료 대상이 추가·종료·변경되었으면 전체 취소 후 재조회한다.
5. 화면 모드 버튼은 하나만 표시한다. 메뉴가 보이면 `전체화면`, 전체화면이면 `메뉴`. 숫자/인치 표기 제거.
6. OEE_MULTI_ENTRY_7IN 메뉴를 프론트 등록·백엔드 seed/검증/기본 배치 및 확인된 DB 메뉴 배치에서 제거한다. 기본 다중입력 메뉴로 진입한다. 기존 별칭 URL 자체는 이번 메뉴 삭제 요청으로 삭제하지 않는다.

## Coordinator API 및 구현 계약

- GET `/oee/multi-entry/status`의 단일 openEvent를 `openEvents: MultiEntryEvent[]`로 대체한다. `state`는 목록이 비었으면 RUNNING, 아니면 DOWNTIME이다. events의 업무일 기준 및 날짜 제한 없는 openEvents는 유지한다.
- 응답 이벤트의 lineCode는 유효 라인이다. dtSeq/organizationId 등 기존 이벤트 필드는 유지한다. 원장에 저장된 NULL 라인을 변경하는 동작은 하지 않는다.
- POST end `{processCode, items:[{lineCode,dtSeq}], reasonCode}` 계약 유지. 한 lineCode에 여러 dtSeq 허용, 동일 실적 중복 금지. 프론트는 선택 라인별 모든 openEvents를 펼쳐 전송한다.
- 서버는 유일한 선택 라인 마스터를 정렬 잠금하고, 실제 미종료 전체 집합과 요청 items 집합을 정확히 비교한다. 원장 행도 잠금·재검증하며 UPDATE는 조직+DT_SEQ와 유효 라인 및 END_TIME IS NULL 조건으로 보호한다.
- 신규 START는 기존처럼 선택 라인당 한 행 생성, 직접 LINE_CODE 저장, RUN_NO/MACHINE_CODE NULL. 기존 설비 실적이 미종료면 전체 START 거부한다.
- Oracle SQL은 LEFT JOIN 결과를 바로 FOR UPDATE하여 잠금 제한을 유발하지 않는다. 기본 원장에 대한 상관 스칼라 설비 라인 조회 또는 별도 기본 행 잠금 패턴을 사용하고 실제 Oracle로 검증한다.
- pending 저장소의 END items는 lineCodes보다 많을 수 있다. 대상 lineCode 포함 여부와 dtSeq 중복을 검증한다. 수동 확인 및 통신 재전송 금지 동작 유지.
- 프론트 메뉴 삭제 후 page registry는 생성 명령으로만 갱신한다. 별칭 route는 등록된 화면으로 유지할 수 있으나 메뉴 leaf는 없어야 한다.

## 검증

- 명시 라인 우선, 동일 조직 설비 라인 대체, 미등록 설비/라인 NULL, 타 조직 차단.
- 복수 미종료 조회 및 일괄 종료, 오래된 대상/누락 대상/새로 추가된 대상 거부와 rollback, 공통 사유/시각.
- Oracle numeric affected count 및 SQL 출현 순서 bind 회귀 검증 필수.
- 기존 DB 기대값: 조직1, 이전 NULL 라인48건 모두 설비 라인으로 귀속, 미종료03라인8건/22라인2건(실행 시 재조회).
- 기존 업무 실적은 검증용으로 종료하지 않는다. 실제 쓰기 검증은 전용 신규 행과 rollback으로 제한한다.
- 화면 모드별 버튼 하나, 인치 문구 없음, 메뉴 부재, 복수 종료 요청 및 수동 확인 화면 렌더 검증.
- backend 집중 Jest/tsc, frontend 집중 테스트/typecheck, 실제 API/DB 확인 경계를 보고한다.

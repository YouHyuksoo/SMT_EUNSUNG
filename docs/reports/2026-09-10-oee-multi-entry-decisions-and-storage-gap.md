# 모바일 다중입력 확정 기준 및 저장 계약 미완료 기록

- 작성일: 2026-09-10
- 상태: 구현 전 저장 대상 식별 계약 확인 필요
- 선행 기록: `2026-09-09-oee-multi-entry-storage-blocker.md`

## 사용자 확정 기준

- 보조 테이블 없이 `IP_EQUIP_DOWNTIME_RESULT`를 원장으로 사용한다.
- 기존 데이터는 삭제·이관하지 않고 신규 다중입력 처리에서 제외한다. 전환 후 등록 건부터 처리한다.
- `ENTER_DATE`는 생성 로그로만 기록한다. 전환 판정의 구체적인 저장·조회 조건은 미확정이다.
- 실적 식별은 조직 + DT_SEQ이며 실적번호 생성 로직 변경은 범위에서 제외한다.
- RUN·설비 선택 없음, 작업장 ALL 제거.
- 시작 사유 생략 가능. 종료 사유 필수이며 선택한 모든 건의 기존/미입력 사유를 최종 사유로 덮어쓴다.
- 일괄 종료는 동일 종료 시각, 단일 트랜잭션으로 전체 성공 또는 전체 취소한다.
- 일괄 시작도 동일 시작 시각, 단일 트랜잭션으로 전체 성공 또는 전체 취소한다.
- 같은 대상의 진행 중 비가동은 한 건만 허용한다. 서버에서 동시 요청 상태를 재검증한다.

## 실제 확인 근거

- `apps/backend/src/modules/oee/oee-mobile.service.ts`: `listResources`는 SMT/ASSY 라인을 반환하고, 상태 및 시작 요청은 공정·리소스 종류·리소스 코드로 대상을 식별한다. 기존 저장소는 `OeeDowntimeEvent`이다.
- `apps/frontend/src/app/(authenticated)/oee/multi-entry/page.tsx`: 선택 리소스별 개별 API 호출 방식이므로 승인된 일괄 원자성을 위해 서버 batch 계약이 필요하다.
- Oracle connector로 `EUNSUNG_DEV_ESDBPDB`의 `IP_EQUIP_DOWNTIME_RESULT` describe 및 컬럼 주석을 읽기 전용으로 재확인했다.
- 실제 컬럼: RUN_NO, DT_SEQ, ORGANIZATION_ID, MACHINE_CODE, WORKSTAGE_CODE, REASON_CODE, START_TIME, END_TIME, MEMO, WORKER, ENTER_BY, ENTER_DATE, LAST_MODIFY_BY, LAST_MODIFY_DATE, CAUSE_YN.
- 라인/리소스 식별 전용 컬럼이 없다. 조직 + DT_SEQ는 개별 실적 식별자이며 해당 실적이 어느 선택 라인에 속하는지는 나타내지 않는다.
- 개발 프로필 확인이며 실행 중 앱의 DB·인증 조직 일치나 렌더 검증은 수행하지 않았다.

## 남은 계약과 후속 작업

1. 원장에 선택 라인을 저장하는 방법 확정. 보조 테이블 없이 원장에 LINE_CODE를 추가하는 안을 제안하되 DDL은 승인 전 실행하지 않는다. 기존 컬럼에 다른 의미를 임의로 저장하지 않는다.
2. 라인 저장 방식 확정 후 기존 데이터 제외 조건, 중복 요청 및 동시성 처리 방법을 정한다. ENTER_DATE나 메모를 임의의 요청 메타데이터로 재해석하지 않는다.
3. 확정된 계약으로 집중 회귀 테스트, 일괄 API 및 화면 구현을 진행한다.
4. Oracle 기대 데이터 → 인증 백엔드 → 프록시 → 렌더 검증을 수행한다.

이번 작업은 본 기록만 추가했다. 앱 코드 및 DB DDL/DML 변경은 없으며 기존 작업 트리 변경은 보존했다. 구현·테스트는 아직 완료하지 않았다.

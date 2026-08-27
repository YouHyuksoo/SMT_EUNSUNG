# 설비비가동 — 작업지시 비의존 등록

- 작성일: 2026-08-27
- 대상: `/oee/equip-work-result` (설비별 작업 실적관리) · `IP_EQUIP_DOWNTIME_RESULT`
- 관련 결정: `docs/adr/0002-equip-downtime-machine-scoped.md`

## 배경

현재 `설비비가동` 버튼은 작업지시를 선택해야만 동작한다. 작업지시를 선택하지 않으면
`작업지시를 먼저 선택하세요` 토스트만 뜨고 패널이 열리지 않는다.

현장에서는 작업지시와 무관하게 설비가 멈추는 경우가 있으므로, 작업지시 없이도
설비만 선택해 비가동을 시작/종료할 수 있어야 한다.

## 요구사항

| 상황 | 설비 | 동작 |
|---|---|---|
| 작업지시 선택 O, 작업지시에 설비 있음 | 해당 설비 고정 | 현행 유지 |
| 작업지시 선택 O, 작업지시에 설비 없음 | 설비 선택 | 현행 유지 |
| 작업지시 선택 X | 설비 선택 | **신규** |

## 제약과 결정

`IP_EQUIP_DOWNTIME_RESULT`의 PK가 `(RUN_NO, DT_SEQ, ORGANIZATION_ID)`이고 `RUN_NO`가
NOT NULL이라 작업지시 없는 행을 넣을 수 없다.

결정(사용자 승인, 2026-08-27):

1. **스키마 변경** — `RUN_NO`를 nullable로 바꾸고 PK를 `(DT_SEQ, ORGANIZATION_ID)`로 재설계.
   `DT_SEQ`는 시퀀스에서 채번한다. (센티널 RUN_NO 대신 선택)
2. **설비 기준 통일** — 비가동 이력 조회와 진행중 판정을 `MACHINE_CODE` 기준으로 통일.
   작업지시 선택 여부와 무관하게 그 설비의 비가동을 다룬다.

배경 데이터: 기존 행 3건, 진행중 0건. `DT_SEQ`가 `1,1,2`로 중복이라 재채번이 필요하다.

## 단계

1. **DDL** → verify: 제약/컬럼 nullable/시퀀스 조회로 반영 확인, 기존 3건 보존 확인
2. **백엔드** — `downtimes`/`upsertDowntime`을 machineCode 기준 + runNo optional로 → verify: `tsc --noEmit`
3. **프론트** — 작업지시 미선택 시에도 패널 오픈, 설비 선택 필수 → verify: `tsc --noEmit`, 실제 화면 확인
4. **검증** — 3가지 상황 각각 시작/종료 후 DB 행 확인

## 체크리스트

### 1. DDL

- [x] `SEQ_IP_EQUIP_DOWNTIME` 시퀀스 생성 (기존 MAX 초과 값에서 시작)
- [x] 기존 3건 `DT_SEQ` 유니크하게 재채번
- [x] PK drop → `RUN_NO` nullable → PK `(DT_SEQ, ORGANIZATION_ID)` 재생성
- [x] `MACHINE_CODE` 조회용 인덱스 추가 (기존 PK 선두컬럼 RUN_NO가 더 이상 조회 경로가 아님)
- [x] `docs/sql/IP_PRODUCT_WORK_RESULT.sql` DDL 스냅샷 갱신
- [x] pre/post 결과 기록

### 2. 백엔드

- [x] `DowntimeUpsertDto.runNo` → optional
- [x] `downtimes()` — runNo 대신 machineCode 기준 조회로 변경
- [x] `upsertDowntime()` — 시퀀스 채번, RUN_NO NULL 허용, 종료/수정은 dtSeq 단독 키로
- [x] 컨트롤러 `GET /downtimes` 파라미터 machineCode 수용
- [x] `equip-downtime-result.entity.ts` runNo nullable + PK 반영
- [x] `tsc --noEmit` 통과

### 3. 프론트

- [x] 우측 `설비 비가동` 버튼 — 작업지시 미선택이어도 패널 오픈
- [x] 패널 렌더 조건에서 `panelRun` 필수 제거 (설비만으로 동작)
- [x] 헤더 표기 — 작업지시 있으면 runNo, 없으면 `작업지시 없음`
- [x] 설비 미선택 시 시작/종료 버튼 비활성 + 안내
- [x] 설비 변경 시 이력/사유 재조회
- [x] `tsc --noEmit`, lint 통과

### 4. 검증

API 레벨 검증 완료 (2026-08-27, localhost:3003 실 DB). 검증용 행 2건은 확인 후 삭제해
기존 3건 상태로 복구했다.

- [x] 작업지시 없이 시작 → `RUN_NO=NULL`, `DT_SEQ=4` 저장 확인
- [x] 설비 기준 이력 조회 — 작업지시 유/무 행이 함께 조회됨
- [x] 같은 설비 중복 시작 차단 — `400 이미 진행중인 비가동이 있습니다`
- [x] 작업지시 없이 시작한 비가동 종료 (dtSeq 단독 키)
- [x] 작업지시 연계 시작 → `RUN_NO=03A267D76F` 저장
- [x] 작업지시로 시작한 비가동을 runNo 없이(설비 화면 경로) 종료
- [x] 화면 컴파일·응답 확인 (`/oee/equip-work-result` HTTP 200)
- [ ] **미완료** — 브라우저에서 실제 클릭 동작 확인 (이 세션에서 브라우저 도구 미사용)

## 남은 확인

브라우저에서 아래 3가지를 직접 눌러보는 확인이 남아 있다.

1. 작업지시 미선택 상태에서 `설비 비가동` → 패널 열림 + 설비 선택 콤보 노출
2. 작업지시 선택(설비 있음) → 설비 고정 표시
3. 설비 선택 후 이력/사유 자동 재조회

## 관련 없는 기존 이슈

`GET /api/v1/master/routing-groups`가 `ORA-00942`로 500을 반환한다. 이번 변경과 무관한
선행 문제이므로 건드리지 않았다.

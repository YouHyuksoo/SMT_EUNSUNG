# 설비 계획 비가동 관리 (월력관리 화면 개편)

- 작성일: 2026-08-31
- 대상 화면: `MST_WORK_CALENDAR` 생산월력관리 → 좌측 패널 교체
- 선행 계획: `2026-08-30-work-calendar-day-modal-redesign.md`

## 배경

월력관리 좌측의 연도·라인 입력과 하단 가동일수 집계를 걷어내고, 그 자리에 설비 계획
비가동 등록 패널을 넣는다. 캘린더에서 체크한 일자 × 선택한 설비에 사유·시간을 적용해
`IP_EQUIP_DOWNTIME_RESULT`에 일괄 등록한다. 비가동 이력 DB는 설비작업실적·설비 운영
현황이 쓰는 것을 그대로 공유한다.

## 사전 실측

| 항목 | 값 |
|---|---|
| 비가동 실적 테이블 | `IP_EQUIP_DOWNTIME_RESULT` (RUN_NO, DT_SEQ, MACHINE_CODE, WORKSTAGE_CODE, REASON_CODE, START_TIME, END_TIME, MEMO, WORKER) |
| DT_SEQ 채번 | `SEQ_IP_EQUIP_DOWNTIME.NEXTVAL` |
| 계획 사유 | `IP_EQUIP_DOWNTIME_REASON.REASON_TYPE='PLAN'` — 6건 (MC01 모델 교체 / SP01 샘플 생산 / PM01 프로그램 수정 / PM02 예방정비 / CN01 청소·5S / PD01 계획 비가동) |
| 설비 | `IMCN_MACHINE` 120대 — **LINE_CODE가 전부 `'*'`(미배정)** |
| 라인 마스터 | `IP_PRODUCT_LINE` 18건 (A~L라인, WAVE, ICT 등) |
| 기존 bulk API | `POST /oee/work-result/downtimes/bulk` 는 START/END를 SYSDATE로 찍는 실시간용 — **재사용 불가** |
| 삭제 API | 없음 — 신규 필요 |

## 확정 결정 (grill 10문)

| # | 항목 | 결정 | 감수한 위험 |
|---|---|---|---|
| 1 | 화면 정체성 | 월력관리를 그대로 개편 | 라인 예외 월력 편집 상실 (`IP_PRODUCT_LINE_CALENDAR` 0행이라 데이터 손실은 없음) |
| 2 | 캘린더 체크박스 | 하나로 공유 — 월력 일괄수정과 비가동 등록이 같은 선택을 소비 | 같은 체크로 두 종류 저장 |
| 3 | 레이아웃 | 좌측 3단 `col-4` + 캘린더 `col-8` | |
| 4 | 겹침 | 기존 PLAN만 삭제 후 재삽입, UNPLAN은 건너뛰고 보고 | 계획 이력 유실 |
| 5 | 자정 넘김 | 불허 — 종료 ≤ 시작이면 등록 비활성 | 야간 계획 등록 불가 |
| 6 | 라인 모드 | 구현하되 배정 0대면 안내 | 현재 데이터로는 항상 0대 |
| 7 | 조회·취소 | 셀 뱃지 + 뱃지 클릭 목록 모달 + 삭제 | |
| 8 | 클릭 충돌 | 뱃지 = 비가동 목록, 나머지 셀 = 월력 편집 | 셀 하나에 클릭 타겟 3개 |
| 9 | 확정일 | 체크박스 항상 표시. 일괄수정은 서버 409, 비가동은 통과 | |
| 10 | 과거 일자 | 허용 | |

## 설계

### API (`@Controller('oee/work-result')`)

```
POST   /downtimes/plan     { machineCodes[], reasonCode, dates[], startHm, endHm }
                           → { inserted, replaced, skipped, skippedDetail[] }
GET    /downtimes/plan     ?from=YYYY-MM-DD&to=YYYY-MM-DD
                           → 계획 비가동 행 목록 (뱃지 집계·목록 모달 공용)
DELETE /downtimes/:dtSeq   (신규)
GET    /downtime-reasons   ?reasonType=PLAN  (기존 엔드포인트에 파라미터 추가)
```

### 저장 값

| 컬럼 | 값 |
|---|---|
| RUN_NO | NULL — 계획 비가동은 작업지시와 무관 |
| DT_SEQ | `SEQ_IP_EQUIP_DOWNTIME.NEXTVAL` |
| WORKSTAGE_CODE | 해당 설비의 `IMCN_MACHINE.WORKSTAGE_CODE` |
| START_TIME | `TO_DATE(일자 || ' ' || startHm, 'YYYY-MM-DD HH24:MI')` |
| END_TIME | 같은 일자 + endHm (자정 넘김 없음) |
| MEMO / WORKER | NULL |
| ENTER_BY | 호출자 userId |

### 겹침 판정

```sql
같은 MACHINE_CODE 이면서
  신규.START < NVL(기존.END, 무한)  AND  기존.START < 신규.END
```
겹치는 기존 행이 PLAN 사유면 삭제 후 삽입(replaced), UNPLAN이면 삽입하지 않고
`skippedDetail`에 (일자, 설비, 사유) 를 담아 돌려준다. 전체를 한 트랜잭션으로 묶는다.

### 검증

설비 ≥ 1 · 사유 필수 · 날짜 ≥ 1 · 종료 > 시작. 프론트에서 등록 버튼을 막고 서버에서도 재확인.

## 체크리스트

- [x] 1. 백엔드 DTO + 서비스(등록/조회/삭제) + 컨트롤러 → 검증: tsc, jest
- [x] 2. `downtime-reasons`에 `reasonType` 파라미터 추가 → 검증: jest
- [x] 3. 프론트 좌측 패널 `PlanDowntimePanel` (설비/라인 · 사유 · 시간 · 등록) → 검증: tsc
- [x] 4. `CalendarGrid` — 확정일 체크 허용 + 계획 비가동 뱃지/클릭 → 검증: tsc
- [x] 5. 일자별 계획 비가동 목록 모달(삭제 포함) → 검증: tsc
- [x] 6. `page.tsx` 좌측 교체 · col-4/col-8 · 뱃지 데이터 로드 → 검증: tsc
- [x] 7. i18n (ko/en/vi/zh) → 검증: 구조 테스트
- [~] 8. 전체 검증 — tsc(front/back) + jest + 구조 테스트 + 화면 확인

## 진행 기록

### 백엔드 실서버 검증 (2026-08-31, 실 DB ES_JSIDC)

`work-result` 컨트롤러가 `@Public()`이라 인증 없이 왕복 검증이 가능했다. 6건 전부 통과.

| # | 검증 | 결과 |
|---|---|---|
| ① | 설비 2대 x 일자 2일 등록 | `inserted 4` |
| ② | 재등록 시 PLAN 덮어쓰기 | `replaced 4, inserted 4` (총 4건 유지, 사유·시간 교체) |
| ③ | 종료 <= 시작 | `400 종료시간은 시작시간보다 늦어야 합니다` |
| ④ | 기간 조회 | 4건, 일자·시각·설비명·사유명 정상 |
| ⑤ | UNPLAN 보호 | 설비 고장과 겹친 설비는 `skipped` + 사유명 반환, 고장 행 생존. 다른 설비는 `inserted` |
| ⑥ | 삭제 / 없는 건 | `deleted 1` / `404` |

테스트 데이터(ENTER_BY='TESTER')는 전부 삭제했다. 남은 4건은 8월 26~27일 기존 운영 데이터다.

### 구현 중 내린 결정

- **전사복사 기능 제거**: 라인 예외 월력 전용 기능이라 라인 선택이 사라지면서 함께 뗐다.
  구조 테스트도 «전사복사 경로가 되살아나면 안 된다»로 뒤집어 갱신했다.
- **`lineCode` 상태 전면 제거**: 좌측 라인 선택이 사라져 항상 전사 월력이다. 백엔드의
  전사/라인 병합 로직과 `IP_PRODUCT_LINE_CALENDAR`는 그대로 둔다(다른 경로가 쓸 수 있다).
- **연도 입력·요약 집계 제거**: 연도는 월 피커에서 파생되므로 `year`만 남기고 draft는 뗐다.
- **`findAll` vs 조회 경로**: 계획 비가동 조회는 월 단위 1회만 부른다(뱃지·목록 모달 공용).
- **effect 동기 setState 회피**: 설비 목록 비우기는 effect가 아니라 모드/라인 변경 핸들러에서
  한다 — 이 저장소 lint 룰(cascading renders)에 걸린다.

### 검증 결과

- 백엔드 `tsc` 통과, `jest work-result shift-time work-calendar` **72/72 통과**
- 백엔드 전체 13 suite 실패 — 변경 전과 동일한 목록
- 프론트 `tsc` 통과, 구조 테스트 48/50(실패 2건은 기존 `master/process` 건)
- lint — `PlanDowntimePanel`·`PlanDowntimeListModal` 지적 없음. `page.tsx`는 3건이나
  기존에도 같은 종류 3건 + `setYearDraft` 1건이었으므로 순증가 없음
- `/master/work-calendar` 컴파일·200 응답 확인
- **미검증**: 화면에서의 실제 조작(설비 체크 → 사유 → 시간 → 등록 → 뱃지 → 삭제)

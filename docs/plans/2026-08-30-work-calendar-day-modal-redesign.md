# 생산월력 일자편집 팝업 재구성 (교대조 시간 · 비작업 시간)

- 작성일: 2026-08-30
- 대상 화면: `MST_WORK_CALENDAR` 생산월력관리 → 일자 편집 모달
- 선행 계획: `2026-07-14-work-calendar-ip-model.md`

## 배경

일자편집 모달이 `근무유형 / 휴무사유 / 근무분 / 잔업분 / 비고`만 받는다. 현장 요구는
교대조(A·B)별 시작~종료 시각과 비작업 시간(휴게·식사)을 일자 단위로 관리하는 것이다.
두 항목 모두 **일자 1 : N** 이라 기존 "1일 = 1행" 구조로는 담을 수 없다.

## 확정된 설계 결정

| 항목 | 결정 | 근거 |
|---|---|---|
| 교대조 시간·비작업 시간 저장 | 자식 테이블 2개 신설 | 교대조·비작업분류가 공통코드라 가변. 컬럼 flatten은 코드 추가 때마다 DDL이 필요 |
| 기존 365행 처리 | 영문 CODE_NAME 유지, 한글명만 신규 부여 | `IP_PRODUCT_COMPANY_CALENDAR` 365행(WORK 257 / OFF+WEEKEND 104 / OFF+HOLIDAY 4)과 shared 규칙 무손상 |
| 교대조 시간 기본값 | `IP_SHIFT_TIME_MASTER` prefill + 일자별 override | 365일을 일일이 입력하지 않게. 수정한 날만 자식행 생성 |
| 잔업·비작업 집계 단위 | 일자 전체 | 입력 단순. 기존 `OT_MINUTES` 단일 컬럼과 정합 |
| 전사/라인 구분 | 자식 테이블 `LINE_CODE` sentinel `'*'` = 전사 | 부모처럼 테이블을 2벌로 나누면 4개가 된다. PK에 NULL 불가라 sentinel 사용 |
| 비고(CALENDAR_COMMENT) | **유지** | 요구 목록에 없으나 기존 기능이고 제거 요청도 아님 |
| 근무시간(분) 입력 | 수동 입력 → **자동계산 표시**로 전환 | Σ(교대조 구간) − Σ(비작업분). 요구 목록에 수동 입력이 없음 |

## 공통코드 (ISYS_BASECODE)

| CODE_TYPE | CODE_NAME | CODE_MEAN_KOR |
|---|---|---|
| WORK DAY TYPE | WORK / OFF / HALF / SPECIAL | 정상 / 휴무 / 임시조정 / 공휴일(특근) |
| DAY OFF TYPE | WEEKEND / HOLIDAY / ANNIV / EVENT / EDU | 주말 / 공휴일 / 사내기념일 / 행사 / 교육 |
| BREAK TYPE | REST / MEAL | 휴게시간 / 식사시간 |
| SHIFT CODE | A / B | 1교대 / 2교대 — **기존 2행 재사용** |

`WORK DAY TYPE`·`DAY OFF TYPE`은 `2026-07-14_work_calendar_com_codes.sql`이 심게 돼 있었으나
ES_JSIDC에 미적용 상태였다(사전 조회로 0건 확인). 이번에 한글명을 확정해 함께 적용한다.

## 근무분 계산식

```
dayType = OFF        → 0
그 외                → max(0, Σ shiftSpanMinutes(교대조) − Σ breakMinutes)
shiftSpanMinutes     → end > start ? end-start : end+1440-start   (야간 자정 넘김)
```

잔업(`OT_MINUTES`)은 근무분에 포함하지 않고 별도 유지한다(요약바 총가용시간은 근무분+잔업).
자식행이 하나도 없는 일자는 기존 `defaultWorkMinutes(dayType, 교대시간마스터)` 폴백을 쓴다
— 연간 생성이 365일치 자식행을 만들지 않기 때문이다.

## 체크리스트

- [x] 1. ISYS_BASECODE 공통코드 시드 (WORK DAY TYPE 4 / DAY OFF TYPE 5 / BREAK TYPE 2) → 검증: 건수 pre/post
- [x] 2. 자식 테이블 2개 DDL (`IP_PRODUCT_CALENDAR_SHIFT`, `IP_PRODUCT_CALENDAR_BREAK`) → 검증: describe
- [x] 3. shared `calendarWorkMinutes()` 추가 → 검증: 워크스페이스 빌드
- [x] 4. 백엔드 엔티티 2개 + DTO 확장(shifts/breaks) → 검증: tsc
- [x] 5. 백엔드 서비스 — findDays 자식 로드, bulkUpdateDays 자식 저장(트랜잭션 동참) → 검증: tsc + jest
- [x] 6. 프론트 types + DayEditModal 재구성 → 검증: tsc
- [x] 7. i18n 키 (ko/en/vi/zh) → 검증: 구조 테스트
- [~] 8. 전체 검증 — tsc(front/back) + 구조 테스트 + 화면 확인

## 진행 기록

### 2026-08-30 DB 적용 (ES_JSIDC, 139.150.82.207/ESDBPDB)

`apps/backend/src/migrations/2026-08-30_work_calendar_shift_break.sql` — blocks_executed 2, 둘 다 성공.

| 대상 | pre | post |
|---|---|---|
| ISYS_BASECODE (WORK DAY TYPE + DAY OFF TYPE + BREAK TYPE) | 0건 | 11건 |
| IP_PRODUCT_CALENDAR_SHIFT / _BREAK 테이블 | 0개 | 2개 |

`SHIFT CODE`(A=1교대, B=2교대) 2건은 기존 값을 그대로 재사용했다.
`IP_PRODUCT_COMPANY_CALENDAR` 365행은 건드리지 않았다.

### 구현 중 내린 결정

- **교대시간 마스터 → 교대조 매핑**: 공통코드 `SHIFT CODE`의 첫 코드(A)를 주간,
  두 번째(B)를 야간에 대응시켜 prefill한다. 세 번째 이후 코드는 빈 값으로 두고 담당자가 채운다.
- **`pickShiftMaster`를 shared로 올리지 않았다**: 백엔드 `ShiftTimeService.resolveFromRows`는
  Oracle date hydration(문자열/Date 혼재) 보정이 얽혀 있어 그대로 공유할 수 없다. 프론트가 받는
  값은 이미 ISO 문자열이라 3줄짜리 사전식 비교로 충분하다. 양쪽이 함께 강제해야 하는 규칙
  (근무분 파생)만 `calendarWorkMinutes`로 shared에 한 번 정의했다.
- **0분 비작업 행은 저장하지 않는다**: 화면이 모든 분류를 항상 보내므로, 0을 그대로 넣으면
  의미 없는 행이 일자마다 쌓인다.
- **연간 생성/전사 복사도 자식행을 함께 정리한다**: 부모만 교체하면 옛 교대조 행이 새 일자에
  달라붙어 사라진 근거로 근무분이 계산된다. `replaceRowsInRange`가 같은 트랜잭션에서 자식도 교체.
- **비고 유지**: 요구 목록에 없었지만 기존 기능이고 제거 요청이 아니었다.

### 버튼 배치 (후속)

취소·저장을 하단 footer가 아니라 헤더 타이틀 높이 우측(닫기 X 왼쪽)에 둔다.
공용 `Modal`에 선택적 `headerActions` 슬롯을 추가했다 — 기존 `footer` 사용처 9곳은
prop을 안 넘기므로 렌더 결과가 그대로다.

### 교대시간 마스터 비작업 시간 (2026-08-31 후속)

교대시간 등록 팝업에도 슬롯별 비작업 시간을 넣고, 그 값이 일자 편집에 자동 반영되게 한다.

- **자식 테이블 `IP_SHIFT_TIME_BREAK` 신설** — PK (DATESET, ORGANIZATION_ID, SHIFT_SLOT, BREAK_TYPE).
  `SHIFT_SLOT`은 교대조 코드(A/B)가 아니라 `'DAY'|'NIGHT'`다. 마스터 자체가 DAY_TIME_* /
  NIGHT_TIME_* 컬럼 구조라, 슬롯을 그대로 따라야 백엔드가 롤업 대상을 명확히 판정할 수 있다.
  화면의 «1교대/2교대»는 공통코드 'SHIFT CODE'로 붙이는 표시용 라벨일 뿐이다.
- **`DAY_BREAK_MINUTES`/`NIGHT_BREAK_MINUTES`는 롤업 컬럼으로 전환** — 삭제하지 않았다.
  `@smt/shared`의 `shiftNetMinutes`/`defaultWorkMinutes`와 교대시간 목록의 순근무 표시가
  이 컬럼을 읽으므로, 저장 시 서버가 자식 합으로 갱신한다. 클라이언트가 보낸 총합은 무시한다.
- **`findAll` vs `findAllWithBreaks`** — `findAll`은 월력 저장이 일자마다 재사용하는 hot path라
  건드리지 않고, 자식 조회가 필요한 화면용 경로만 분리했다.
- **일자 편집 prefill은 합산** — 일자 편집의 비작업 시간은 교대조별이 아니라 일자 단위이므로
  마스터의 주간·야간을 분류별로 더해서 채운다(주간 휴게 30 + 야간 휴게 30 → 휴게 60).
- **마이그레이션 작성 시 주의** — `oracle_connector.execute_file`은 파일 첫 토큰이 DECLARE/BEGIN일
  때만 PL/SQL로 보고 끝의 `;`를 남긴다. 헤더 주석이 앞에 있으면 DDL로 오인해 `;`를 잘라
  PLS-00103이 난다. 주석을 `DECLARE` 아래로 옮겨 해결했다.

### 검증 결과

- 백엔드 `tsc --noEmit` 통과, `jest work-calendar` **44/44 통과**(신규 7건 포함)
- 프론트 `tsc --noEmit` 통과, 구조 테스트 48/50(실패 2건은 `master/process` 기존 실패)
- 백엔드 전체 jest 13 suite 실패 — 변경 전과 동일한 목록(auth/inventory/bom/menu-categories/system/architecture)
- **미검증**: 실제 화면 렌더와 저장 왕복. 브라우저 도구 사용 불가, 로그인 계정 조회 차단됨.

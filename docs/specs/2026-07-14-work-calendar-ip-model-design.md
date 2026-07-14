# 생산월력관리 — IP_ 월력 모델 재구축 설계

- 작성일: 2026-07-14
- 메뉴: `MST_WORK_CALENDAR` / `/master/work-calendar`
- 상태: 설계 (구현 전)

## 1. 배경 — 왜 다시 만드는가

생산월력관리 화면은 **코드는 이미 다 있는데 DB가 없어 전 기능이 실패하는 상태**다.

- 프론트 7개 파일(월 그리드·일자편집·연간생성·복사·확정·교대패턴 탭), 백엔드 컨트롤러/서비스/DTO, 엔티티 3개, 메뉴·로케일 4개국어·도움말(ko)까지 등록 완료.
- 그러나 이 코드가 바라보는 `WORK_CALENDARS` / `WORK_CALENDAR_DAYS` / `SHIFT_PATTERNS`는 **은성 Oracle에 존재하지 않는다**(ESDBext에서 확인). 마이그레이션도 저장소에 없다. HANES에서 통째로 복사되면서 스키마만 빠진 것이다.
- 추가로 `ShiftPatternController`/`ShiftPatternService`가 어떤 NestJS 모듈에도 등록돼 있지 않아 교대패턴 탭은 404다.

동시에 은성 DB(Infinity21 스키마)에는 이미 월력 테이블군이 존재하고, OEE 설계가 별도로 `OEE_WORK_CALENDAR`를 신설해 둔 상태였다. 즉 **근무일 달력 모델이 3벌 경쟁**하고 있었다.

| 모델 | 테이블 | 실DB | 코드 사용 |
|---|---|---|---|
| HANES 복사본 | `WORK_CALENDARS` + `_DAYS` + `SHIFT_PATTERNS` | 없음 | 화면이 이걸 봄 (실패) |
| Infinity21 레거시 | `IP_PRODUCT_COMPANY_CALENDAR` / `_LINE_` / `_WS_`, `IP_SHIFT_TIME_MASTER` | 있음 (0건) | 없음 |
| OEE 스펙 | `OEE_WORK_CALENDAR` + `OEE_WORKTIME_RANGE` | 있음 (1건/0건) | 없음 |

## 2. 결정

**IP_ 계열을 정본으로 삼고, 부족한 컬럼을 보강한다.** 달력은 한 벌만 유지한다.

근거:

- IP_ 모델은 조직·라인·공정 계층이 이미 잡혀 있고 FK가 실제 마스터(`IP_PRODUCT_LINE`, `ISYS_ORGANIZATION`)에 걸려 있다.
- **`IP_PRODUCT_COMPANY_CALENDAR`는 이미 살아있는 소비처가 있다** — PL/SQL 함수 `F_GET_DELIVERY_DATE`(납기일 계산)가 이 테이블의 휴일을 읽는다. 이걸 채우면 납기 계산도 함께 정상화된다.
- 세 IP_ 테이블 모두 0건이므로 ALTER가 안전하다.

용도(사용자 확정): **OEE 계획가동시간의 원천 + 생산계획/시뮬레이션 작업일 + 설비점검 업무일 기준**. 여러 도메인이 함께 읽는 공용 마스터이므로 단일 모델이어야 한다. 현재 은성에 실재하는 소비처는 OEE뿐이고(생산계획·설비점검 모듈은 아직 없음), 나머지 둘은 이 마스터를 나중에 읽어간다.

### 폐기

- `WORK_CALENDARS` / `WORK_CALENDAR_DAYS` / `SHIFT_PATTERNS` 엔티티·서비스·컨트롤러·DTO 전부 삭제 (테이블이 없으므로 데이터 손실 없음).
- `OEE_WORK_CALENDAR` / `OEE_WORKTIME_RANGE`는 이번 범위에서 채우지 않는다. OEE 계획가동시간 파생은 후속 작업에서 IP_ 월력을 원천으로 삼도록 연결한다. 이 결정은 `docs/specs/2026-07-06-oee-management-design.md` §3-⑦의 "근무일=OEE_WORK_CALENDAR" 항목을 **대체**한다.

## 3. 스코프

- **전사 월력 + 라인별 예외** 2계층. 공정(WS)·설비(MCN)·금형(MOLD) 월력은 쓰지 않는다.
- 교대는 **2교대(주간/야간)** 고정.
- 이번 범위: 월력 화면 + 교대시간 마스터 화면. OEE_PLAN_TIME 파생은 후속.

## 4. DDL — IP_ 테이블 보강

세 테이블 모두 현재 0건. ALTER만 수행하며 기존 컬럼은 삭제·변경하지 않는다.

### 4.1 `IP_PRODUCT_COMPANY_CALENDAR`, `IP_PRODUCT_LINE_CALENDAR` (동일)

```sql
DAY_TYPE      VARCHAR2(20) DEFAULT 'WORK' NOT NULL   -- WORK/OFF/HALF/SPECIAL
OFF_REASON    VARCHAR2(20)                           -- 휴무사유 (DAY_TYPE='OFF'일 때만)
WORK_MINUTES  NUMBER(5)    DEFAULT 0 NOT NULL        -- 순근무분
OT_MINUTES    NUMBER(5)    DEFAULT 0 NOT NULL        -- 잔업분
CONFIRM_YN    VARCHAR2(1)  DEFAULT 'N' NOT NULL      -- 확정 잠금

CHECK (DAY_TYPE IN ('WORK','OFF','HALF','SPECIAL'))
CHECK ((DAY_TYPE = 'OFF' AND HOLIDAY_YN = 'Y')
    OR (DAY_TYPE <> 'OFF' AND HOLIDAY_YN = 'N'))
```

**`HOLIDAY_YN`은 유지한다.** `F_GET_DELIVERY_DATE`가 읽고 있어 제거하면 납기 계산이 깨진다. `DAY_TYPE`의 미러로 두고, 두 값이 어긋나지 않도록 CHECK 제약으로 DB가 강제한다. 애플리케이션은 `DAY_TYPE`만 쓰고 `HOLIDAY_YN`은 저장 시 파생한다.

### 4.2 `IP_SHIFT_TIME_MASTER`

현재 **PK가 없다.** 먼저 정상화한다.

```sql
-- NOT NULL 보강 후
PRIMARY KEY (ORGANIZATION_ID, DATESET)

DAY_BREAK_MINUTES   NUMBER(4) DEFAULT 0 NOT NULL
NIGHT_BREAK_MINUTES NUMBER(4) DEFAULT 0 NOT NULL
```

기존 `DATESET ~ DATEEND` 유효기간 구조를 그대로 쓴다(`DATEEND` NULL = 무기한). 기간 겹침은 DB 제약으로 표현할 수 없으므로 서비스에서 검증한다.

### 4.3 공통코드 시드

`WORK_DAY_TYPE`(WORK/OFF/HALF/SPECIAL), `DAY_OFF_TYPE`(WEEKEND/HOLIDAY/…) 두 그룹이 아직 없다. 기준정보 화면이 자유입력 대신 공통코드를 쓰도록 시드가 선행돼야 한다.

## 5. 도메인 규칙 — `packages/shared`에 1회 정의

프론트(미리보기)와 백엔드(저장값 계산)가 **같은 함수를 호출한다.** 같은 조건을 두 계층에 복붙하지 않는다.

```
shiftNetMinutes(start, end, breakMin)
  -- 자정 넘김 처리 (야간 20:00~08:00 → +24h)
  -- = span(start, end) - breakMin

defaultWorkMinutes(dayType, shiftTime)
  OFF     → 0
  WORK    → 주간순근무분 + 야간순근무분
  HALF    → 주간순근무분 ÷ 2
  SPECIAL → 주간순근무분          -- 휴일 특근은 주간 1교대

holidayYnOf(dayType)  → dayType === 'OFF' ? 'Y' : 'N'
```

자동 계산값은 일자편집에서 **수동 override 가능**하며, 저장되는 값은 최종값이다.

### 월력 병합 (라인 예외)

```
effective(date, lineCode) =
  IP_PRODUCT_LINE_CALENDAR(date, lineCode) 행이 있으면 그 행
  없으면 IP_PRODUCT_COMPANY_CALENDAR(date) 행
```

화면은 "전사" 또는 특정 라인을 선택한다. 라인 모드에서는 회사월력을 배경으로 표시하고 예외만 덮어쓴다.

### 연간 생성

- 토/일 근무 여부는 플래그로 받는다(기본 미근무 → `OFF` / `OFF_REASON='WEEKEND'`).
- 공휴일은 **양력 고정공휴일만** 자동 `OFF`/`OFF_REASON='HOLIDAY'` 처리한다: 1/1, 3/1, 5/5, 6/6, 8/15, 10/3, 10/9, 12/25. 설·추석·대체공휴일은 담당자가 수정한다.
- 생성은 해당 연도 일자를 **덮어쓴다**. 확정(`CONFIRM_YN='Y'`)된 일자가 하나라도 있으면 거부한다.

### 확정 잠금

`CONFIRM_YN='Y'`인 일자는 모든 쓰기 경로(일자 저장·연간 생성·복사·삭제)에서 차단한다.

## 6. API — `@Controller('master/work-calendar')`

tenant는 `@OrganizationId()`(은성 규약). 응답은 `ResponseUtil`.

| Method | Path | Body / Query |
|---|---|---|
| GET | `/days` | `year`, `month`, `lineCode?` — 병합 결과 |
| PUT | `/days/bulk` | `{ lineCode?, days: [{ workDate, dayType, offReason?, workMinutes?, otMinutes?, comment? }] }` |
| POST | `/generate` | `{ year, lineCode?, saturdayWork?, sundayWork?, applyHolidays? }` |
| POST | `/copy-from-company` | `{ year, lineCode }` — 라인월력을 회사월력에서 복제 |
| POST | `/confirm` · `/unconfirm` | `{ year, month?, lineCode? }` |
| GET | `/summary` | `year`, `lineCode?` → 가동일수·비가동일수·총가용시간 |

교대시간 마스터: `@Controller('master/shift-times')` — GET / POST / PUT `/:dateset` / DELETE `/:dateset`.

두 컨트롤러 모두 `MasterWorkCalendarModule`에 등록한다 (기존 shift-pattern 배선 누락 재발 방지).

## 7. 프론트

기존 UI 골격을 유지하되 IP_ 모델에 맞춰 조정한다.

- `page.tsx` — 탭 2개: **월력** / **교대시간**
- 좌측: 연도 + 라인 선택(`LineSelect`, "전사" 옵션). HANES의 캘린더 헤더(`CALENDAR_ID`) 개념은 IP_ 모델에 없으므로 `CalendarFormPanel`은 **제거**한다.
- 우측: 요약 바 + 월 그리드(`CalendarGrid` 재사용). 일자 셀에 `DAY_TYPE` 뱃지, 확정일은 잠금 표시.
- `DayEditModal` — 근무유형/휴무사유는 자유입력이 아니라 `ComCodeSelect`(`WORK_DAY_TYPE`, `DAY_OFF_TYPE`). 휴무사유는 `dayType==='OFF'`일 때만 노출. 근무분·잔업분은 자동계산 후 수정 가능.
- `ShiftPatternTab` → `ShiftTimeTab`으로 교체: 유효기간(`DATESET~DATEEND`) 행 CRUD, 주간/야간 시작·종료·휴식분.

## 8. 테스트

- `packages/shared` — 근무분 계산 유닛테스트(자정 넘김, HALF/SPECIAL, 휴식 차감).
- 백엔드 jest — 연간 생성(주말·공휴일 판정), 라인 예외 병합, 확정 잠금, 교대시간 유효기간 겹침 거부, tenant 격리.
- 프론트 구조테스트 `work-calendar.eunsung.structure.test.mjs` — 메뉴 4곳 등록, IP_ 테이블/API 경로 사용, `WORK_CALENDARS`·`SHIFT_PATTERNS`·`/master/work-calendars` 재등장 금지.

## 9. 미해결 / 후속

- **OEE 계획가동시간 파생**: `OEE_PLAN_TIME`을 IP_ 월력 × 교대시간에서 채우는 로직. `OEE_RESOURCE`(라인/설비 단위)와 라인월력의 매핑 규칙을 정해야 한다.
- **라인 마스터 실데이터 미확인**: `IP_PRODUCT_LINE`의 실제 라인 목록을 확인하지 못했다(설계 중 ESDBext 접속 타임아웃). 구현 착수 전 확인 필요.
- 도움말 문서(`MST_WORK_CALENDAR.md`)는 HANES 모델 기준으로 작성돼 있어 IP_ 모델에 맞춰 다시 써야 한다. en/vi/zh 도움말은 아직 없다.

---
menuCode: MST_WORK_CALENDAR
audience: operator
title: 생산월력관리 — 운영 가이드
summary: IP_PRODUCT_COMPANY_CALENDAR/IP_PRODUCT_LINE_CALENDAR/IP_SHIFT_TIME_MASTER 전체 컬럼 DB 매핑, 병합·연간생성·복사·확정 로직, HOLIDAY_YN 파생 규칙, API 목록, 트러블슈팅, 멀티테넌시 스코프
tags: [기준정보, 생산월력, 작업캘린더, 운영, 교대시간]
keywords: [IP_PRODUCT_COMPANY_CALENDAR, IP_PRODUCT_LINE_CALENDAR, IP_SHIFT_TIME_MASTER, PLAN_DATE, DAY_TYPE, OFF_REASON, HOLIDAY_YN, WORK_DAY_TYPE, DAY_OFF_TYPE, CONFIRM_YN, generateYear, copyFromCompany, F_GET_DELIVERY_DATE, CK_IPCC_HOLIDAY_SYNC, CK_IPLC_HOLIDAY_SYNC, ORGANIZATION_ID, 멀티테넌시]
related: [MST_PROD_LINE]
---

# 생산월력관리 — 운영 가이드

## 시스템 목적·역할
전사 근무 캘린더와 라인별 예외 캘린더, 2교대 근무시간 마스터를 보유하는 기준정보 화면입니다. 세 개의 은성 레거시 테이블 **`IP_PRODUCT_COMPANY_CALENDAR`**(전사), **`IP_PRODUCT_LINE_CALENDAR`**(라인 예외), **`IP_SHIFT_TIME_MASTER`**(교대시간)를 관리합니다. 여기서 확정한 가동일·근무시간(분)은 생산계획·CAPA 산정의 기준이 되고, `HOLIDAY_YN`은 PL/SQL 납기일 계산 함수가 읽습니다.

## 데이터 구조
```
IP_PRODUCT_COMPANY_CALENDAR (PK: PLAN_DATE, ORGANIZATION_ID)   ── 전사 월력
IP_PRODUCT_LINE_CALENDAR    (PK: PLAN_DATE, ORGANIZATION_ID, LINE_CODE) ── 라인 예외 월력

IP_SHIFT_TIME_MASTER (PK: ORGANIZATION_ID, DATESET) ── 유효기간형 2교대 시간 마스터
   (원본 테이블에는 PK가 없었다. 2026-07-14 마이그레이션으로 PK 부여)
```

**조회 병합 규칙**: 월 조회(`GET /days`)는 두 테이블을 항상 함께 읽습니다. 같은 날짜에 라인 예외 행(`IP_PRODUCT_LINE_CALENDAR`)이 있으면 그 값이 이기고(`source=LINE`), 없으면 전사 행(`IP_PRODUCT_COMPANY_CALENDAR`)이 표시됩니다(`source=COMPANY`). 이 병합은 매 조회마다 애플리케이션 레벨에서 수행되며, DB에 물리적으로 병합된 테이블은 없습니다.

## ① 전사 월력 — IP_PRODUCT_COMPANY_CALENDAR / 라인 예외 — IP_PRODUCT_LINE_CALENDAR (전체 컬럼)

두 테이블은 `LINE_CODE` 유무만 다르고 나머지 컬럼은 동일합니다.

| 화면 항목 | DB 컬럼 | 역할 / 의미 · 운영 포인트 |
|------|------|------|
| 일자 | `PLAN_DATE` | PK 구성(DATE). 월 조회는 `Between(월초, 월말)`로 필터. |
| (라인 예외만) 라인 | `LINE_CODE` | `IP_PRODUCT_LINE_CALENDAR`의 PK 구성. 전사 테이블에는 없음. |
| 근무유형 | `DAY_TYPE` | 기본 `WORK`. 공통코드 `WORK_DAY_TYPE`. DTO에서 `IsIn(['WORK','OFF','HALF','SPECIAL'])` 검증. |
| 휴무사유 | `OFF_REASON` | nullable, 공통코드 `DAY_OFF_TYPE`. `DAY_TYPE='OFF'`가 아니면 항상 null로 저장(서버가 강제). 연간 생성은 주말=`WEEKEND`, 고정공휴일=`HOLIDAY`. |
| **휴일유무** | **`HOLIDAY_YN`** | **`DAY_TYPE`의 미러**(`OFF`→`'Y'`, 그 외→`'N'`). 클라이언트가 값을 보내지 않으며, 서버가 `@smt/shared`의 `holidayYnOf(dayType)`로만 파생시킨다(`work-calendar.service.ts` `buildRow()`). PL/SQL `F_GET_DELIVERY_DATE`(납기일 계산)가 이 컬럼을 직접 읽으므로 **절대 직접 UPDATE하지 않는다**. DB CHECK 제약 `CK_IPCC_HOLIDAY_SYNC`(전사)/`CK_IPLC_HOLIDAY_SYNC`(라인)가 `DAY_TYPE`↔`HOLIDAY_YN` 불일치를 막는다. |
| 근무시간 | `WORK_MINUTES` | NUMBER. 미지정 시 `defaultWorkMinutes(dayType, shift)`로 자동 산출(아래 파생식 참고). 지정 시 override로 그대로 저장. |
| 잔업시간 | `OT_MINUTES` | NUMBER, 기본 0. |
| 확정 | `CONFIRM_YN` | `'Y'`/`'N'`, 기본 `'N'`. `'Y'`인 일자가 범위에 하나라도 있으면 저장/연간생성/복사가 `ConflictException`(409)으로 거부된다(`ensureNotConfirmed`). |
| 비고 | `CALENDAR_COMMENT` | VARCHAR2 500, nullable. |
| 감사 | `ENTER_BY`, `LAST_MODIFY_BY`, `ENTER_DATE`, `LAST_MODIFY_DATE` | 저장할 때마다 명시적으로 다시 찍는다(신규/기존 구분 없이 매번 갱신 — 아래 "구현 메모" 참고). |
| 멀티테넌시 | `ORGANIZATION_ID` | PK 구성. `@OrganizationId()` 데코레이터가 `req.user.organizationId`에서 추출. `COMPANY`/`PLANT_CD` 컬럼은 이 두 테이블에 없다. |

## ② 교대시간 — IP_SHIFT_TIME_MASTER (전체 컬럼)

| 화면 항목 | DB 컬럼 | 역할 / 의미 · 운영 포인트 |
|------|------|------|
| 적용시작일 | `DATESET` | PK 구성(DATE). |
| 적용종료일 | `DATEEND` | nullable=무기한. |
| 주간 시작/종료 | `DAY_TIME_START` / `DAY_TIME_END` | VARCHAR2(8), `HH:MM`. |
| 주간 휴식(분) | `DAY_BREAK_MINUTES` | NUMBER, 기본 0. |
| 야간 시작/종료 | `NIGHT_TIME_START` / `NIGHT_TIME_END` | VARCHAR2(8). **야간은 자정을 넘길 수 있다**(예: `20:00`~`08:00`). 순근무분 계산 시 `end < start`면 +24h로 처리(`shiftNetMinutes`, `@smt/shared`). |
| 야간 휴식(분) | `NIGHT_BREAK_MINUTES` | NUMBER, 기본 0. |
| 감사 | `ENTER_BY`, `LAST_MODIFY_BY`, `ENTER_DATE`, `LAST_MODIFY_DATE` | `@CreateDateColumn`/`@UpdateDateColumn`이지만, 서비스는 이 값들을 매번 명시적으로 채운다(자동 채움을 신뢰하지 않는다 — 엔티티 주석 참고). |
| 멀티테넌시 | `ORGANIZATION_ID` | PK 구성. |

> 화면에 표시되는 "주간/야간 순근무(분)"은 저장 컬럼이 아니라 `shiftNetMinutes()`로 매번 계산해 보여주는 값이다.
> 적용기간이 겹치는 행은 등록/수정할 수 없다(`ensureNoOverlap`, DB CHECK로 표현 불가하여 서비스 레벨에서 검증).

---

## API 목록

`master/work-calendar` (`work-calendar.controller.ts`)

| 메서드/경로 | 설명 |
|------|------|
| `GET /master/work-calendar/days?month=YYYY-MM&lineCode=` | 월별 일자 조회. 전사+라인 예외 병합 결과 반환. |
| `PUT /master/work-calendar/days/bulk` | 일자 일괄 저장(`lineCode` 미지정 시 전사). |
| `POST /master/work-calendar/generate` | 연간 생성. |
| `POST /master/work-calendar/copy-from-company` | 라인 월력을 전사 월력에서 복제(라인 필수). |
| `POST /master/work-calendar/confirm` | 확정(연 또는 월 단위, `lineCode` 옵션). |
| `POST /master/work-calendar/unconfirm` | 확정 취소. |
| `GET /master/work-calendar/summary?year=YYYY&lineCode=` | 연간 요약(가동일수·비가동일수·반일·특근·총가용시간). |

`master/shift-times` (`shift-time.controller.ts`)

| 메서드/경로 | 설명 |
|------|------|
| `GET /master/shift-times` | 목록(적용시작일 내림차순). |
| `POST /master/shift-times` | 등록. |
| `PUT /master/shift-times/:dateset` | 수정(적용시작일은 불변, 경로 파라미터). |
| `DELETE /master/shift-times/:dateset` | 삭제. |

모든 API는 `JwtAuthGuard`로 로그인이 필요하며, `ORGANIZATION_ID`로 스코프된다.

## 알고리즘

### 근무시간 자동 파생 (`defaultWorkMinutes`, `@smt/shared/work-calendar/work-calendar-rules.ts`)
근무시간을 지정하지 않고 저장하면(`WorkCalendarDayItemDto.workMinutes` 미지정) 서버가 해당 일자에 유효한 `IP_SHIFT_TIME_MASTER` 행을 찾아 아래처럼 계산합니다.

| DAY_TYPE | WORK_MINUTES |
|------|------|
| `OFF` | 0 |
| `WORK` | 주간 순근무분 + 야간 순근무분 |
| `HALF` | 주간 순근무분 ÷ 2 (내림) |
| `SPECIAL` | 주간 순근무분 |

순근무분 = `(종료 - 시작) - 휴식분`. 값을 지정해서 저장하면 그 값이 override로 그대로 저장됩니다.

### 연간 생성 (`generateYear`, `POST /generate`)
1. 확정된 일자가 대상 범위(연도, `lineCode`)에 있으면 409로 차단(`ensureNotConfirmed`).
2. `IP_SHIFT_TIME_MASTER` 전체를 1회 조회해 재사용(`findAll`, 일자마다 재조회하지 않음).
3. 1/1~12/31 순회: 주말이고 `saturdayWork`/`sundayWork`가 꺼져 있으면 `OFF`/`WEEKEND`. 그 외 `applyHolidays`(기본 true)이고 고정공휴일이면 `OFF`/`HOLIDAY`. 나머지는 `WORK`.
4. **양력 고정공휴일만** 자동 적용된다(`isFixedHoliday`): 1/1, 3/1, 5/5, 6/6, 8/15, 10/3, 10/9, 12/25. 음력 공휴일(설·추석)·대체공휴일·임시공휴일은 포함되지 않는다 — 운영자가 일자 편집으로 보정해야 한다.
5. 해당 범위의 기존 행을 **DELETE 후 전량 INSERT**(덮어쓰기). `lineCode` 유무에 따라 대상 테이블이 갈린다.

### 전사에서 복사 (`copyFromCompany`, `POST /copy-from-company`)
- 대상 연도·라인에 확정 일자가 있으면 409.
- 원본(전사) 일자가 0건이면 409(`복사할 전사 월력이 없습니다`).
- 전사 행을 그대로 복제해 `IP_PRODUCT_LINE_CALENDAR`에 저장(`CONFIRM_YN`은 항상 `'N'`으로 리셋). 대상 라인의 해당 연도 **기존 예외를 DELETE 후 전량 INSERT**(덮어쓰기).

### 확정 / 확정취소 (`confirm`/`unconfirm`, `setConfirm`)
- `ConfirmDaysDto`의 `month` 유무로 월 단위/연 단위 범위를 정한다.
- `repo.update()`로 `CONFIRM_YN`·감사 컬럼만 직접 UPDATE한다(재조회 후 `save()`를 쓰지 않는다 — 아래 구현 메모 참고).

### 일괄 저장 (`bulkUpdateDays`, `PUT /days/bulk`)
- 저장 대상 날짜들의 확정 여부를 먼저 확인(`ensureNotConfirmed`, min~max 범위).
- 날짜별로 `buildRow()`가 `HOLIDAY_YN` 파생 + 근무시간 자동/override 처리.
- 전달된 날짜만 골라 DELETE 후 INSERT(`replaceRowsByDates`, 불연속 날짜 가능).

### 구현 메모 (재발 방지용)
- `IP_PRODUCT_COMPANY_CALENDAR`/`IP_PRODUCT_LINE_CALENDAR`/`IP_SHIFT_TIME_MASTER` 저장 경로는 TypeORM `save()`를 쓰지 않고 **`delete()` + `insert()`/`update()`**를 쓴다. `PLAN_DATE`가 `type:'date'` 복합 PK인데 Oracle 드라이버가 조회 시 이를 문자열로 hydrate하고, `save()`는 내부적으로 Date 객체 식별자와 재비교하면서 항상 불일치로 판정해 `ORA-00001`(유니크 제약 위반)을 낸다. 이 저장 로직을 손대는 경우 이 제약을 유지해야 한다.
- `ENTER_BY`/`ENTER_DATE`/`LAST_MODIFY_BY`/`LAST_MODIFY_DATE`/`CONFIRM_YN`은 `buildRow()`에서 신규·기존 여부를 구분하지 않고 매번 명시적으로 다시 찍는다. 기존 일자를 수정하면 `ENTER_DATE`가 "최초 생성 시각"이 아니라 "마지막 저장 시각"으로 갱신된다.

## 사전 설정 (마스터·공통코드)
- 공통코드: `WORK_DAY_TYPE`(근무유형), `DAY_OFF_TYPE`(휴무사유). 미등록 시 일자 편집 드롭다운과 달력 배지가 비어 보인다.
- 라인 마스터(생산라인관리, `IP_PRODUCT_LINE` 계열): 라인 선택 목록의 원천. 미등록 시 라인 선택 목록이 빈다.
- **교대시간(`IP_SHIFT_TIME_MASTER`)을 캘린더보다 먼저 등록해야 한다.** 미등록 상태로 연간 생성을 실행하면 근무일의 `WORK_MINUTES`가 0으로 채워진다.

## 운영 절차
1. 교대시간 등록/점검: 적용기간·주간/야간 시작·종료·휴식.
2. 전사 월력 연간 생성(주말·고정공휴일 옵션 확인).
3. 음력 공휴일·대체공휴일·특근·반일·잔업 등 예외를 달력에서 일자 편집으로 보정.
4. 필요한 라인만 전사에서 복사 후 라인별 예외를 보정.
5. 검증 후 확정. 변경이 필요하면 확정취소 → 수정 → 재확정.

## 권한
- 기준정보 관리자: 월력/교대시간 등록·수정·연간생성·복사·확정·삭제.
- 일반 사용자: 조회. (별도 권한 게이트는 메뉴/라우트 권한 정책을 따름)

## 문제 해결 (트러블슈팅)
| 증상 | 원인 | 조치 |
|------|------|------|
| 저장·연간생성·복사가 409로 막힘 | 대상 범위(연도/라인)에 `CONFIRM_YN='Y'`인 일자 존재 | 확정취소(`/unconfirm`)로 되돌린 후 재시도 |
| 교대시간 등록/수정이 409로 막힘 | 새 적용기간이 기존 `IP_SHIFT_TIME_MASTER` 행과 겹침 | 기존 행의 적용종료일을 채우거나, 겹치지 않는 시작일로 재입력 |
| 연간 생성 후 근무시간이 0 | 교대시간 마스터 미등록, 또는 해당 일자에 적용되는 교대시간이 없음 | 교대시간 탭에서 해당 기간을 포함하는 행을 먼저 등록 |
| 전사에서 복사 시 409(복사할 전사 월력이 없음) | 대상 연도의 전사 월력이 아직 생성되지 않음 | 전사 월력을 먼저 연간 생성한 뒤 복사 |
| 음력 공휴일(설·추석 등)이 근무로 잡힘 | 고정 공휴일만 자동 적용(음력·대체공휴일 미포함) | 해당 일자를 달력에서 OFF/`HOLIDAY`로 수동 보정 |
| 손으로 고친 예외가 사라짐 | 연간 생성/전사에서 복사 재실행이 해당 범위를 전체 덮어씀 | 보정은 생성/복사 이후에 수행 |
| 라인 선택 목록이 빔 | 라인 마스터(`IP_PRODUCT_LINE` 계열) 미등록 | 생산라인관리에서 라인 등록 |
| 달력 셀 클릭이 안 됨 | 해당 일자가 확정 상태(자물쇠 아이콘) | 확정취소 후 편집 |
| `HOLIDAY_YN` 값이 `DAY_TYPE`과 안 맞는 데이터 발견 | 애플리케이션 경로를 거치지 않고 DB를 직접 수정 | `HOLIDAY_YN`을 직접 고치지 말고 `DAY_TYPE`을 정정 후 저장 API로 재저장(CHECK 제약이 재검증) |

## 데이터·연계
- 테이블: `IP_PRODUCT_COMPANY_CALENDAR`, `IP_PRODUCT_LINE_CALENDAR`, `IP_SHIFT_TIME_MASTER`
- 공통코드: `WORK_DAY_TYPE`, `DAY_OFF_TYPE`
- 공유 규칙 모듈: `@smt/shared/work-calendar`(`defaultWorkMinutes`, `holidayYnOf`, `isFixedHoliday`, `shiftNetMinutes`) — 프론트(미리보기)와 백엔드(저장값)가 동일 함수를 호출한다.
- 연계: PL/SQL `F_GET_DELIVERY_DATE`(납기일 계산, `HOLIDAY_YN` 참조), DB CHECK 제약 `CK_IPCC_HOLIDAY_SYNC`/`CK_IPLC_HOLIDAY_SYNC`
- 참조 마스터: 생산라인관리(라인 예외 지정 대상)
- 활용: 생산계획·CAPA 등 가동일/가용시간 기준
- 스코프: `ORGANIZATION_ID`(로그인 사용자 소속 조직). `COMPANY`/`PLANT_CD` 컬럼은 이 세 테이블에 없다.

---
sources:
  - apps/backend/src/entities/product-company-calendar.entity.ts
  - apps/backend/src/entities/product-line-calendar.entity.ts
  - apps/backend/src/entities/product-calendar-shift.entity.ts
  - apps/backend/src/entities/product-calendar-break.entity.ts
  - apps/backend/src/entities/shift-time-master.entity.ts
  - apps/backend/src/entities/shift-time-break.entity.ts
  - apps/backend/src/modules/master/services/work-calendar.service.ts
  - apps/backend/src/modules/master/services/shift-time.service.ts
  - packages/shared/src/work-calendar/work-calendar-rules.ts
verifiedCommit: dee4f7e
---

# 생산월력 — IP_PRODUCT_*_CALENDAR / IP_SHIFT_TIME_*

## 구성

```
IP_PRODUCT_COMPANY_CALENDAR   전사 월력 (1일 1행)
  PK PLAN_DATE + ORGANIZATION_ID
IP_PRODUCT_LINE_CALENDAR      라인 예외 월력 (있으면 전사를 덮어씀)
  PK PLAN_DATE + ORGANIZATION_ID + LINE_CODE
        │
        ├── IP_PRODUCT_CALENDAR_SHIFT   일자별 교대조 작업시간   (2026-08-30 신설)
        │     PK PLAN_DATE + ORGANIZATION_ID + LINE_CODE + SHIFT_CODE
        └── IP_PRODUCT_CALENDAR_BREAK   일자별 비작업(휴게/식사) (2026-08-30 신설)
              PK PLAN_DATE + ORGANIZATION_ID + LINE_CODE + BREAK_TYPE

IP_SHIFT_TIME_MASTER          교대시간 마스터 (유효기간 DATESET~DATEEND)
  PK ORGANIZATION_ID + DATESET
        └── IP_SHIFT_TIME_BREAK         슬롯별 비작업 시간       (2026-08-31 신설)
              PK DATESET + ORGANIZATION_ID + SHIFT_SLOT + BREAK_TYPE
```

## 핵심 규칙

**LINE_CODE sentinel** — 자식 테이블의 `LINE_CODE`는 PK라 NULL을 못 쓴다. 전사 월력은
`'*'`(`COMPANY_LINE_CODE`)를 넣는다. 부모처럼 테이블을 전사/라인 2벌로 나누지 않기 위한 선택이다.

**SHIFT_SLOT vs SHIFT_CODE** — `IP_SHIFT_TIME_BREAK`의 키는 교대조 코드(A/B)가 아니라
`SHIFT_SLOT`(`'DAY'`|`'NIGHT'`)이다. 마스터 자체가 `DAY_TIME_*`/`NIGHT_TIME_*` 컬럼 구조라
슬롯을 따라야 서버가 롤업 대상을 판정할 수 있다. 화면의 「1교대/2교대」는 공통코드
`SHIFT CODE`로 붙이는 표시용 라벨이다.

**롤업 컬럼** — `IP_SHIFT_TIME_MASTER.DAY_BREAK_MINUTES` / `NIGHT_BREAK_MINUTES`는 삭제하지
않고 자식 합으로 서버가 갱신하는 롤업이다. `@smt/shared`의 순근무 계산과 목록 표시가 이
컬럼을 그대로 읽는다. 클라이언트가 보낸 총합은 무시한다.

**HOLIDAY_YN** — `DAY_TYPE`의 미러다. PL/SQL `F_GET_DELIVERY_DATE`가 읽으므로 삭제하면 안 되고,
`@smt/shared`의 `holidayYnOf()`로만 파생시킨다. DB CHECK 제약이 정합을 다시 강제한다.

**근무분 파생** — 자식(교대조/비작업) 행이 있으면 `calendarWorkMinutes()`가,
없으면 `defaultWorkMinutes(교대시간 마스터)`가 계산한다. 연간 생성은 자식행을 만들지 않으므로
후자가 여전히 필요하다.

## 공통코드 (ISYS_BASECODE)

| CODE_TYPE | 값 |
|---|---|
| `WORK DAY TYPE` | WORK=정상 / OFF=휴무 / HALF=임시조정 / SPECIAL=공휴일(특근) |
| `DAY OFF TYPE` | WEEKEND / HOLIDAY / ANNIV / EVENT / EDU |
| `BREAK TYPE` | REST=휴게시간 / MEAL=식사시간 |
| `SHIFT CODE` | A=1교대 / B=2교대 (기존 값 재사용) |

## 주의

- **FK 제약이 없다.** 부모↔자식 연결은 애플리케이션이 트랜잭션으로 지킨다. 연간 생성·전사
  복사·일자 저장은 부모와 자식을 한 트랜잭션에서 함께 교체한다 — 부모만 갈아치우면 옛
  교대조 행이 새 일자에 달라붙어 사라진 근거로 근무분이 계산된다.
- `IP_PRODUCT_LINE_CALENDAR`는 2026-09-02 기준 0건이다. 화면에서 라인 예외 편집을 제거해
  당분간 전사 월력만 쓴다(백엔드 병합 로직은 유지).

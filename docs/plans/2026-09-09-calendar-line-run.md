# 생산월력 일자편집 — 라인 추가 운영

작성일: 2026-09-09

## 배경

일자편집 팝업은 지금 교대조 작업시간·잔업·비작업 시간만 다룬다. 정규 교대 외에
특정 라인만 추가로 돌리는 경우를 기록할 자리가 없다.

## 요구사항

잔업(연장) 근무시간 아래에 **라인 추가 운영** 영역을 둔다.

- 라인코드·라인명을 고르는 콤보 + 가동시간(시작~종료) 입력
- 그리드로 구성해 복수 행 관리 (행 추가 / 행 삭제)
- 근무시간 집계 시 가동시간을 분으로 환산해 더한다

## 결정사항

| 항목 | 결정 | 근거 |
|---|---|---|
| 근무분 반영 범위 | 저장값(WORK_MINUTES)까지 포함 | 사용자 확정. 프론트 미리보기·서버 저장값·캘린더 그리드가 한 식을 쓴다 |
| 같은 라인 중복 행 | 허용 (PK에 RUN_SEQ) | 사용자 확정. 오전·야간처럼 구간을 나눠 등록 |
| 계산식 | `Σ교대 − Σ비작업 + Σ라인추가` | 라인 추가 운영은 교대 외 가동이라 비작업분을 빼지 않는다 |
| 휴무일(OFF) | 0 유지 | 기존 `calendarWorkMinutes`가 OFF에서 즉시 0을 반환. 휴일 가동은 SPECIAL(공휴일 특근)로 표현한다 |
| 자정 넘김 | 기존 `shiftSpanMinutes` 재사용 | 20:00~02:00 같은 구간을 교대조와 동일하게 처리 |

## 데이터 모델

`IP_PRODUCT_CALENDAR_LINE_RUN` — 교대조/비작업과 같은 자식 테이블 패턴.

| 컬럼 | 설명 |
|---|---|
| PLAN_DATE, ORGANIZATION_ID | 부모 월력 키 |
| LINE_CODE | **월력 소유자**. `'*'`=전사. 형제 테이블과 같은 의미 |
| RUN_SEQ | 행 순번. 같은 라인 중복 등록을 허용하는 키 |
| RUN_LINE_CODE | **추가 운영 라인**. IP_PRODUCT_LINE 참조 |
| START_TIME, END_TIME | 'HH:MM' |

`LINE_CODE`(소유자)와 `RUN_LINE_CODE`(운영 라인)는 의미가 다르므로 컬럼을 분리한다.

## 작업 범위

1. 마이그레이션 + 운영 DB 반영
2. `packages/shared` — `CalendarLineRun` 타입, `calendarWorkMinutes` 4번째 인자
3. 백엔드 — 엔티티, `database.module.ts` 등록, DTO, 조회·저장 경로
4. 프론트 — 타입, 일자편집 팝업 그리드, i18n 4개 로케일
5. 검증 — typecheck / 기존 테스트 / 실제 화면

## 참고

- 체크리스트: `docs/reports/2026-09-09-calendar-line-run/checklist.md`
- 결정 로그: `docs/reports/2026-09-09-calendar-line-run/context-notes.md`

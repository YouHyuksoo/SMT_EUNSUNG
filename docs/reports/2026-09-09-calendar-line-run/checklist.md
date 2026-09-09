# 체크리스트 — 라인 추가 운영

## DB
- [x] 마이그레이션 SQL 작성 (`IP_PRODUCT_CALENDAR_LINE_RUN`, 멱등)
- [x] 운영 DB(ES_JSIDC) 반영 + pre/post 확인

## shared
- [x] `CalendarLineRun` 타입 추가
- [x] `calendarWorkMinutes`에 lineRuns 합산 (선택 인자, 기존 호출 무영향)

## 백엔드
- [x] 엔티티 `product-calendar-line-run.entity.ts`
- [x] `database.module.ts` 엔티티 배열 등록
- [x] `master-work-calendar.module.ts` forFeature 등록
- [x] DTO에 `lineRuns` 추가
- [x] 조회(list) — 자식행 merge
- [x] 저장(save) — buildChildRows / replaceRowsByDates

## 프론트
- [x] `types.ts` — `CalendarLineRun`, `WorkCalendarDay.lineRuns`
- [x] 일자편집 팝업 — 잔업 아래 그리드 (라인 콤보 + 시작~종료 + 행추가/삭제)
- [x] 근무시간 표시에 합산 반영
- [x] i18n ko/en/vi/zh

## 검증
- [x] 프론트 `tsc --noEmit`
- [x] 백엔드 `tsc --noEmit`
- [x] `pnpm --filter @eunsung/frontend test`
- [x] work-calendar 백엔드 스펙
- [x] 실제 화면 확인 (등록 → 저장 → 재조회 → 근무시간 증가)

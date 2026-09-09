# 컨텍스트 노트 — 라인 추가 운영

작업 중 내린 결정과 이유를 계속 덧붙인다.

## 2026-09-09 착수

### 왜 자식 테이블을 새로 만드나
교대조(`IP_PRODUCT_CALENDAR_SHIFT`)에 얹는 방안을 먼저 봤으나 PK가
`(PLAN_DATE, ORG, LINE_CODE, SHIFT_CODE)`라 같은 라인 복수 행을 못 담는다.
또 교대조 행은 "그 날만의 교대 예외"라는 의미가 있어 성격이 다르다. 별도 테이블로 뺀다.

### LINE_CODE 이름 충돌
형제 테이블에서 `LINE_CODE`는 **월력 소유자**(`'*'`=전사)다. 이번 기능의 라인은
**추가 운영 대상**이라 의미가 다르다. 소유자는 `LINE_CODE`로 두어 형제와 맞추고,
운영 라인은 `RUN_LINE_CODE`로 분리했다. 같은 컬럼명을 재사용하면 조회 조건에서
소유자 필터와 섞여 버그가 난다.

### 근무분 계산을 shared에 두는 이유
`calendarWorkMinutes`는 프론트 미리보기와 백엔드 저장값이 함께 호출한다.
프론트에만 더하면 화면과 DB가 갈라진다. CLAUDE.md의 "규칙은 shared에 한 번 정의"
원칙대로 한 곳만 고친다.

### 비작업분을 빼지 않는 이유
비작업(휴게·식사)은 교대 근무 안의 쉬는 시간이다. 라인 추가 운영은 교대 밖의
별도 가동이라 이미 순수 가동시간이다. 여기서 또 빼면 이중 차감이 된다.

### OFF일 처리
`calendarWorkMinutes`는 `dayType === 'OFF'`면 즉시 0을 반환한다. 이 동작을 유지한다.
휴무일에 라인을 돌리는 상황은 근무유형 `SPECIAL`(공휴일 특근)로 표현하는 게
기존 모델의 의도다.

## 2026-09-09 구현 중 발견

### 시간 입력이 삭제 버튼을 덮던 버그
행 레이아웃을 `w-[232px] flex-shrink-0` 안에 `Input fullWidth` 두 개로 짰더니, 각 입력이
`width:100%`(=232px)로 잡혀 컨테이너를 넘쳤다. 넘친 영역이 휴지통 버튼 위를 덮어
Playwright 클릭이 "intercepts pointer events"로 실패했다. 눈으로는 잘 안 보이는 종류다.
각 입력을 `min-w-0 flex-1` 래퍼로 감싸 폭을 반씩 나누고 컨테이너를 264px로 넓혀 해결했다.
실제 렌더 검증을 안 했으면 놓쳤을 버그다.

### 스펙이 깨진 이유
`WorkCalendarService` 생성자에 repo를 하나 추가하자 `work-calendar.service.spec.ts`의
테스트 모듈이 `ProductCalendarLineRunRepository`를 못 찾아 44건이 전부 실패했다.
DI 토큰 provider와 `mockQr`의 delete/insert 라우팅에 새 엔티티를 함께 등록해야 한다.

### shared는 dist를 참조한다
백엔드/프론트가 `@smt/shared`를 `dist/index.js`로 읽는다. `packages/shared/src`만 고치면
`has no exported member` 오류가 난다. `pnpm --filter @smt/shared build`가 필요하다.

### 운영 DB 왕복 검증
2026-12-31(미확정)에 같은 라인 2구간(18:00~21:00, 22:00~00:00)을 저장해
RUN_SEQ 1·2로 분리 저장되고 `LINE_CODE='*'`(소유자) / `RUN_LINE_CODE='01'`(운영 라인)이
제대로 갈리는 것을 확인했다. 자정 넘김 구간도 120분으로 계산됐다.
검증 후 원본(workMinutes 0, 자식행 없음)으로 되돌렸고 테이블은 0행이다.

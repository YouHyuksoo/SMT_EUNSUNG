# 477·478 구매구분 무시 · 날짜 표시 통일 · 선택 체크박스 — 결과와 미완료 기록 (2026-09-30)

로컬 백엔드는 ESDB(192.168.175.100/XE)로 붙였다. DB 검증은 빌드된 서비스(`dist`)를 ESDB 에 직접 물려 돌렸다
(크롬 확장 미연결로 화면 API 대신).

## 고친 것 (커밋 전)

### 1. 477 소요량 전개 · 478 발주계획 생성 — 구매구분(LINE_TYPE) 무시

- 원인: 은성 `ID_ENG_BOM` 10,443행 중 10,422행이 `LINE_TYPE='T'`(자작). PB 는 전개 결과를
  477 `IN ('G','D','N','S','M','F','B')`, 478 `NOT IN ('A','T')` 로 걸러 **소요량이 0건**이었다.
  같은 자재를 `ID_ITEM` 은 대부분 `F`(무상구매)로 갖고 있다.
- 사용자 결정: "구매 구분 무시하자".
- 변경: `apps/backend/src/modules/purchase/bom-requirement.sql.ts` 에 두 조각을 한 번 정의하고 두 서비스가 쓴다.
  - `LEAF_ONLY_SQL` — 같은 전개 안에서 하위 품목이 있는 행(모델 자신·반제품)을 뺀다. 필터만 지우면 모델 100개가 자재로 잡힌다.
  - `ITEM_LINE_TYPE_SQL` — 소요량 행의 거래유형은 `ID_ITEM.LINE_TYPE`(없으면 BOM 값). 478 의 재고·단가·확정이 `ITEM_CODE+LINE_TYPE` 으로 맞물려 BOM 값 `T` 로는 차감·단가가 0건이 된다.
  - 478 요구량 INSERT 의 `LINE_TYPE <> 'T'`, 발주 확정(`purchase()`)의 `LINE_TYPE <> 'T'` 2곳 제거. 화면 문구 2곳도 수정.

### 2. 날짜 표시 통일 (UTC 원문 제거)

- 원인: 백엔드가 Oracle DATE 를 JS Date 로 내려 JSON 에서 UTC ISO 가 되고(`2026-10-04T15:00:00.000Z`, KST 10-05 자정),
  화면은 `String(value)` 로 찍었다. 모양도 `ts` 원문 / `toLocaleDateString(undefined)` / `ko-KR` / `toLocaleString()` 이 섞여 있었다.
- 공용 포맷터 `formatDisplayDate` (`apps/frontend/src/utils/date.ts`): 날짜 `YYYY-MM-DD`, 일시 `YYYY-MM-DD HH:mm:ss`(KST).
  `YYYY-MM-DD` 로 시작하지 않는 값은 문자열 그대로. 샘플 15개 입력 검증 통과(TZ=Asia/Seoul).
- 적용: `DataGrid` 기본 셀(`defaultColumn.cell`), 컬럼 파일 21개의 `ts`, `DateCell`, BOM/입고취소 `date`·`dateTime`,
  사용자 최근로그인, 개선요청 2곳, 알림벨, 엑셀 내보내기(`useExport.toRows`).
- 477/478 조회 SQL 은 날짜를 `TO_CHAR` 문자열로 내린다. 477 날짜별 표의 열 제목이 하루 앞당겨지던 것(`dateKey` 의 `toISOString`)과,
  삭제 payload 로 되돌아가는 날짜 키 문제를 같이 막는다. 478 계획일·납기는 시간별 원천이면 `HH24:MI` 까지.
- 구매 화면 6개의 기본 날짜 `toISOString().slice(0,10)` → `getTodayLocal()` (오전 9시 전 어제 날짜 문제).

### 3. 선택 체크박스

- `purchase-columns.tsx` `selectColumn` (id `select` — 엑셀 내보내기에서 자동 제외). 여러 줄을 고르는 3개 화면:
  477 기준계획, 478 발주계획(발주수량 0 인 줄은 체크 불가), 자재주문예정(forecast). 전체선택 헤더 포함, 선택 배경 `bg-primary/15`.

## 검증

| 항목 | 결과 |
|---|---|
| backend / frontend `tsc --noEmit` | 통과 |
| frontend `test` (구조 테스트) | 1/1 통과 |
| 477 전개 (3모델, 기준일자 2026-09-30) | 기준계획 3 → 소요량 416행, 자재 244종, 거래유형 F 403 · Y 11 · M 2, 모델·반제품 혼입 0 |
| 477 거래유형 F 필터 | 403행 (수정 전 0) |
| 477 날짜별 표 열 | `2026-10-05/06/07` (수정 전 하루 앞당겨짐) |
| 477 날짜 키 삭제 | `{deleted: 1}` 후 같은 값으로 복구 |
| 478 생성 (생산계획 09-30~10-30, 15건) | 요구량 119행 (F 118 · M 1), 재고 매칭 품목 53종, **발주계획 0행** — 아래 결정 대기 |
| `ID_ENG_BOM_TEMP` 세션 | 전개 전후 동일 (70,319) — 전개가 남기는 찌꺼기 없음 |

## 미완료 · 결정 대기

| 항목 | 내용 |
|---|---|
| 478 발주계획 0행 | `netRequirements` 가 `ID_ITEM.ORDER_RULE='O'`(직주문) 품목만 대상. 이번 요구 품목은 `A`(자동) 117종 · 값 없음 2종, `O` 0종. R/S 품목 전체도 `A` 1,400 · 없음 99, `O` 0. **A 를 포함할지 사용자 결정 필요.** |
| 린트 | `next lint` 가 `Cannot find module '@eslint/eslintrc/universal'` 로 실행 불가 (환경 문제, 이번 변경과 무관) |
| 화면 렌더링 | 크롬 확장 미연결로 체크박스·날짜 표시를 화면에서 확인하지 못함 |
| 테스트 데이터 | ESDB 에 등록자 `CLAUDE_TEST` 로 남김 (원래 비어 있던 표): 477 기준계획 3 · 소요량 416, 478 `IM_ITEM_PURCHASE_REQUIR_ORDER` 119 · `IM_ITEM_INVENTORY_GEN` 1,514. 정리 여부 사용자 확인 필요 |

## 보고만 한 것 (같은 유형, 범위 밖)

| 항목 | 규모 |
|---|---|
| 프론트 `toISOString().slice(0,10)` 로 오늘/기간 기본값 만들기 | 96개 파일 121곳 (구매 6개만 수정). 오전 9시(KST) 전 어제 날짜 |
| 백엔드 같은 관용구 | 8개 모듈: equipment-result-query, jig-check, bom.controller, num-rule, oee-mobile-worktime, sensor-actual, smt-bom, er-view |

# display/21 제품생산현황 재구성 설계

**날짜:** 2026-05-22  
**대상 URL:** `/display/21`  
**데이터 소스:** `IRPT_PRODUCT_LINE_MONITORING`

---

## 1. 배경

기존 display/21은 다른 서버(SOLUEM India MES) 기준으로 구성되어 있어 BJVNSMT_E DB 컬럼 불일치. 완전 재구성.

---

## 2. 레이아웃

**B: 테이블 + 우측 달성률 바 차트** (KPI 상단 없음)

```
┌─────────────────────────────────────┬──────────────────────────────────┐
│  테이블 (60%)                         │  라인별 달성률 차트 (40%)           │
│  LINE_NAME  MODEL_NAME  계획  실적   │  S01 ████████░░  76%              │
│  달성률%   NG수   [상태뱃지]           │  S02 ████░░░░░░  42%              │
│                                     │  S03 ██░░░░░░░░  18%              │
└─────────────────────────────────────┴──────────────────────────────────┘
```

- KPI 상단 바 없음 (라인별 이기종 모델 혼재로 총계획 합산 의미 없음)
- 좌측 60% 테이블, 우측 40% 차트

---

## 3. 데이터

### 사용 컬럼

| 컬럼 | 용도 |
|------|------|
| LINE_NAME | 테이블/차트 라인명 |
| LINE_CODE | 키 식별자 |
| LINE_STATUS | 가동 상태 뱃지 |
| MODEL_NAME | 현재 생산 모델 |
| PRODUCT_RUN_TYPE | 구분 (항상 'P') |
| RUN_DATE | 작업일 |
| ACTUAL_DATE | 실적일 |
| RUNNING_LOT_PLAN_QTY | 계획수량 |
| RUNNING_LOT_ACTUAL_QTY | 실적수량 |
| RUNNING_LOT_NG_QTY | NG수량 |

**제외:** `RUNNING_LOT_INPUT_QTY` — BJVNSMT_E에서 항상 null

### 달성률 계산

```
달성률(%) = RUNNING_LOT_ACTUAL_QTY / RUNNING_LOT_PLAN_QTY * 100
```
- 클라이언트에서 계산
- PLAN_QTY = 0 이면 달성률 0으로 처리

---

## 4. 컴포넌트 구성

```
src/
  app/
    api/display/21/route.ts          # GET API
  lib/queries/
    product-line-monitoring.ts       # SQL 쿼리
  components/display/screens/
    product-line/
      ProductionLineStatus.tsx       # 메인 (SWR + DisplayLayout)
      ProductionLineTable.tsx        # 라인별 테이블
      ProductionLineChart.tsx        # 달성률 수평 바 차트 (CSS)
```

---

## 5. 컴포넌트 상세

### ProductionLineStatus.tsx
- `useSWR('/api/display/21', fetcher, { refreshInterval: timing.refreshSeconds * 1000 })`
- `useDisplayTiming()` 훅으로 갱신 주기 연동
- DisplayLayout 래핑

### ProductionLineTable.tsx
- 테이블 컬럼: LINE_NAME / MODEL_NAME / 계획 / 실적 / 달성률% / NG / 상태
- LINE_STATUS 뱃지: `N`=회색(미가동) / `R`=초록(가동중) / 기타=노랑(대기)
- 달성률 셀 색상: 0~29%=빨강 / 30~69%=노랑 / 70~100%=초록

### ProductionLineChart.tsx
- CSS 수평 바 차트 (외부 라이브러리 없음)
- X축: 0~100%
- 바 색상: 달성률 구간별 (테이블과 동일 기준)
- 라인명 좌측 표시, 달성률% 우측 표시

---

## 6. API

**Route:** `GET /api/display/21`  
**파라미터:** 없음 (전체 라인 조회)  
**응답:**
```json
{
  "lines": [...],
  "timestamp": "ISO string"
}
```

**SQL:** `SELECT LINE_NAME, LINE_CODE, LINE_STATUS, MODEL_NAME, PRODUCT_RUN_TYPE, RUN_DATE, ACTUAL_DATE, RUNNING_LOT_PLAN_QTY, RUNNING_LOT_ACTUAL_QTY, RUNNING_LOT_NG_QTY FROM IRPT_PRODUCT_LINE_MONITORING ORDER BY LINE_CODE`

---

## 7. 갱신 주기

`useDisplayTiming()` 훅 → localStorage `mes-display-timing.refreshSeconds` → 설정 모달 연동

---

## 8. 기존 파일 처리

- 기존 display/21 관련 컴포넌트 전부 삭제 후 신규 작성
- `src/lib/queries/smd-production.ts`의 display/21 관련 SQL 제거 (이미 분리되어 있다면 불필요)

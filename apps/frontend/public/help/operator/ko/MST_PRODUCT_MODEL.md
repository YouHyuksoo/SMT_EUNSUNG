# 제품모델관리 운영자 안내

`IP_PRODUCT_MODEL_MASTER`의 모델 목록과 BOM 전개 방식을 다룹니다. 설계: `docs/specs/2026-10-17-wip-semi-product-from-aoi-design.md`.

## 저장 칼럼 (IP_PRODUCT_MODEL_MASTER)

| 칼럼 | 뜻 |
|---|---|
| `BOM_EXPLODE_TYPE` | 공통코드 `BOM EXPLODE TYPE` — TB · SUB · NEST · SINGLE · RAW · NONE |
| `TOP_ITEM_CODE` | AOI T면 실적이 만드는 품목 |
| `BOTTOM_ITEM_CODE` | AOI B면 실적이 만드는 품목 |
| `INSERT_ITEM_CODE` | SUB 공정 품목 (SUB-Assy). SUB-Assy 아래 TOP·BOT 구조에서만 자동으로 채운다 |
| `BOM_EXPLODE_SOURCE` | A = 자동 분류, M = 사람이 정함 |
| `BOM_EXPLODE_NOTE` | 자동 분류 메모 |

- 모델 키는 `MODEL_NAME` 입니다(PK). 고객사품번(`PART_NO`)은 여러 모델이 같은 값을 씁니다(2026-10-17 기준 12개 품번).
- `TOP_ITEM_CODE`·`BOTTOM_ITEM_CODE`·`INSERT_ITEM_CODE` 는 원래 있던 칼럼입니다(`INSERT_ITEM_CODE` 는 SUB 공정 모델 항목). 2026-10-17 기준 전부 비어 있었고 다른 코드에서 쓰지 않았습니다.
- 마이그레이션: `apps/backend/src/migrations/2026-10-17_model_master_bom_explode.sql`

## API

| 경로 | 동작 |
|---|---|
| `GET /master/product-models/bom-explode` | 모델 목록 + 전개 방식 |
| `POST /master/product-models/bom-explode/classify` | 자동 분류. 사람이 정한 행(M)은 건너뜀. `modelNames` 로 범위 지정 가능 |
| `GET /master/product-models/bom-explode/candidates?modelName=` | 제품 자신 + 그 BOM 반제품 (면 추정 포함) |
| `PATCH /master/product-models/bom-explode` (본문 `modelName`) | 사람이 정함 (M) |

## 자동 분류 규칙 (`bom-explode.classify.ts`)

- **BOM:** `ID_ENG_BOM` 에서 `ITEM_CODE` 가 모델 품목코드인 오늘 유효 행만 씁니다.
- **반제품:** 이 BOM 안에서 자식이 있는 노드입니다. **SMT 반제품**은 자식이 전부 말단인 반제품입니다.
- **면 판정:** BOM 행 `PCB_ITEM`(T/B) → 품목명(BOT·BOTTOM / TOP) → 코드 끝(숫자 뒤 T/B) 순서로 봅니다.
- **판정 순서:**
  1. TOP 안에 BOT
  2. 제품 직하 TOP·BOT
  3. 면 없는 SUB-Assy 하나 아래 TOP·BOT
  4. SMT 반제품이 2개이고 한쪽만 면이 있으면 나머지를 반대 면으로 정함 (소거)
  5. SMT 반제품 하나 → 단면
  6. 반제품 없음 → 원자재만
  7. 나머지 → 미분류
- **단면·원자재만의 세는 면:** 최근 6개월 런카드(`IP_PRODUCT_RUN_CARD.PCB_ITEM` 이 T/B 인 런)의 면으로 정합니다. 런카드가 양면이면 각 면을 하나의 모델로 보고 두 면 모두 같은 품목을 넣습니다(실적은 면마다 세고, `P_ASSY_RESULT_ADD` 가 TOP = BOTTOM 이면 공정재고를 면마다 × 0.5 로 움직입니다). 런이 없으면 비우고 메모를 남깁니다.

# 공급사정보 삭제 요청 — 61개 삭제 + 발주계획·구매품목 마스터 정리 (2026-10-15)

대상 DB: ESDBext(`XE`), `ORGANIZATION_ID = 1`.
요청 원본: 바탕화면 `공급사 삭제 요청리스트.xls` — `공급상/제작처` 칸이 노란색인 61개.
61개 중 58개는 2026-09-30 보강분(`ENTER_BY = 'SUPPLIER_SYNC_0930'`)이고 `ESA`·`ESSMT`·`DC` 3개는 기존 `ADMIN` 등록분이다.

## 결과

| 순서 | 표 | 전 → 후 | 삭제 | 복구 SQL |
|---|---|---|---|---|
| 1 | `ICOM_SUPPLIER` | 76 → 36 | 40 | `docs/sql/icom-supplier-delete-rollback-2026-10-15.sql` (61행) |
| 2 | `IM_ITEM_PURCHASE_ORDER_PLAN` | 924 → 536 | 388 | `docs/sql/im-item-purchase-order-plan-delete-rollback-2026-10-15.sql` |
| 2 | `ICOM_SUPPLIER` | 36 → 15 | 21 | (1과 같은 파일) |
| 3 | `IM_ITEM_MASTER` | 4,478 → 1,344 | 3,134 | `docs/sql/im-item-master-delete-rollback-2026-10-15.sql` |
| 4 | `IM_ITEM_UNIT_PRICE` | 5,386 → 2,322 | 3,064 | `docs/sql/im-item-unit-price-delete-rollback-2026-10-15.sql` |

- 1단계는 코드별 SAVEPOINT 로 한 건씩 지웠다. 21개가
  `ORA-02292: integrity constraint (INFINITY21_JSMES.R_524) violated - child record found` 로 막혔다.
- 막은 행은 2026-10-02 `ADMIN` 발주계획 생성분 388행(상태 `N` 304 · `P` 84, 입고 0)이다.
  `IM_ITEM_PURCHASE_ORDER`·`IM_ITEM_PURCHASE_ORDER_WAIT` 연결은 0건이었다. 사용자 지시로 지우고 21개를 마저 삭제했다.
- 3단계: 사용자 지시 "구매품목 마스터도 제거해". 61개 코드의 행만 지웠다. 삭제 후 공급사 마스터에 없는 공급사를 쓰는 구매품목은 0행이다.
- 4단계: 사용자 지시 "구매단가도 제거해". 61개 코드의 행만 지웠다. 삭제 후 공급사 마스터에 없는 공급사의 단가는 0행이다.
  단가 표에는 INSERT·UPDATE 트리거만 있고 DELETE 트리거는 없다.
- 공급사·발주계획·구매품목 표에는 트리거가 없다. 남은 공급사 15개: AT, DY, IE, IP, IPCKD, KI, KY, MT, SC, SU, SW, TI, TS, YS, 한글 코드 1개.
- 복구 순서: 공급사 → 발주계획 → 구매품목 → 구매단가.

## 품목정보(ID_ITEM) — 노란 공급사 품목 중 4년간 입고 없는 것

사용자 지시: "노란색이면서 해당 공급상이면서 4년간 없었다면 품목을 지우라는 뜻".

- 노란 공급사 품목 642개. `IM_ITEM_RECEIPT`·`IM_ITEM_RECEIPT_BARCODE` 기준 4년간 입고 없음 637개.
- 그중 523개는 남겼다. 지난 4년 안에 런카드가 나온 모델이거나, 그런 모델의 유효 BOM 부품이다.
  대부분 사내에서 만드는 PCB ASSY라 구매입고가 원래 없다. `IP_PRODUCT_FG_ISSUE` 362,896행 중 최종이 2026-10-14다.
- 나머지 114개 중 9개는 `IP_PRODUCT_FG_ISSUE` 4년 이력이 있어 남겼다.
- 105개를 코드별 SAVEPOINT 로 지웠다. 2,591 → 2,488, 103개 삭제 후 커밋.
- 2개(`M1590-156600`, `E2010000130`)는 `ORA-02292 ... (INFINITY21_JSMES.R_557)` 로 막혔다. `IS_PRODUCT_SALE_PRICE` 가 참조한다.
  사용자 지시 "판가도 다지워"로 판가 2행(고객 IP·TS)과 품목 2개를 지웠다. 복구: `docs/sql/is-product-sale-price-delete-rollback-2026-10-15.sql`. 품목정보 최종 2,486행.
- 복구: `docs/sql/id-item-delete-rollback-2026-10-15.sql` (105행).
  `TRG_ID_ITEM_DEL` 이 지운 행을 `ID_ITEM_HISTORY` 에 남겼다.
- 지운 품목을 참조하는 `ID_ENG_BOM` 1,061행은 그대로다. 4년간 생산이 없는 모델의 BOM이다.

## 남은 참조 (손대지 않음)

- `ID_ITEM.SUPPLIER_CODE`: 남은 노란 공급사 품목 537개 = 생산 사용 532 + 4년 내 입고 있음 5.
- `IM_ITEM_PURCHASE_REQUIR_ORDER` 84행, `IM_ITEM_ISSUE` `*` 15,872행(최종 2026-10-14), `IM_ITEM_RECEIPT_BARCODE.VENDOR_CODE` `*` 187,501행.
- 입고·재고 등 이력 표의 공급사 코드는 그대로다.

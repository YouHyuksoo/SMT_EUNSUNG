# 478 발주계획 생성을 막던 기준정보 정리 — ORDER_RULE 전환 · 공급처 마스터 보강 (2026-09-30)

대상 DB: ESDB(192.168.175.100/XE), `ORGANIZATION_ID = 1`. 앞선 기록
`2026-09-30-purchase-linetype-date-format-unfinished.md` 의 "478 발주계획 0행 — 결정 대기" 는 이 작업으로 해소됐다.

## 1. `ID_ITEM.ORDER_RULE` 전량 `'O'`(직주문)

- 이유: 478 `netRequirements` 는 `ORDER_RULE = 'O'` 품목만 발주계획으로 넘긴다. 은성 품목은 `O` 가 0건이었다.
- 사용자 지시: "ORDER_RULE='O' 로 변경 전부해".
- 전: `A` 2,455 · NULL 105 → 후: `O` 2,560 (`UPDATE ... SET ORDER_RULE = 'O'` 한 문장, 2,560행).
- 트리거: `ID_ITEM_UPD_MANUAL`(UPDATE OF route_no) · `TRG_ID_ITEM_UPD`(UPDATE OF supplier_code, line_type, customer_code)
  모두 대상 컬럼이 아니라 발화하지 않았다. 전후 `IM_ITEM_INVENTORY` 1,840,397행 · `ID_ENG_BOM` 'T' 10,422행 동일.
  - 주의: `ID_ITEM_UPD_MANUAL` 은 `route_no` 변경 시 재고 행을 **DELETE** 하고 입출고 거래유형을 덮어쓴다. `line_type`·`route_no` 대량 변경 전에 반드시 검토.
- 복구: `docs/sql/id-item-order-rule-restore-2026-09-30.sql` (변경 전 값을 품목별로 되돌림).

## 2. `ICOM_SUPPLIER` 보강 (59개 추가)

- 증상: 478 생성이 `ORA-02291: integrity constraint (INFINITY21_JSMES.R_524) violated` —
  `IM_ITEM_PURCHASE_ORDER_PLAN(SUPPLIER_CODE, ORGANIZATION_ID)` → `ICOM_SUPPLIER` FK.
- 원인: 공급처 마스터는 16개인데 `IM_ITEM_MASTER`·`IM_ITEM_UNIT_PRICE`·`IM_ITEM_RECEIPT`·`ID_ITEM`·`IM_ITEM_INVENTORY` 가
  마스터에 없는 코드 59개를 쓴다. 단가(최종 2026-09-22)·입고(2026-09-14)에 지금도 입력되는 코드라 참조 쪽을 고치지 않고 부모를 보강했다
  (참조를 바꾸면 478 의 공급처+품목+거래유형 단가 매칭이 끊긴다).
- 사용자 지시: "구매품목 마스터를 정리든 공급처를 보강하던 동기화해".
- 추가 값: 이름·영문명 = 코드 그대로(`*` 는 `미지정`/`UNASSIGNED`), 기존 16행 관례대로 `DATESET 2020-07-31`, `DATEEND 9999-12-31`,
  `BUSINESS_STATUS 'A'`, `PAYMENT_TYPE 'D'`, `TEL_NO '1'`, `ENTER_BY 'SUPPLIER_SYNC_0930'`.
- 결과: 16 → 75, 빠진 코드 59 → 0. `ICOM_SUPPLIER` 에는 트리거가 없다.
- 롤백: `docs/sql/icom-supplier-sync-rollback-2026-09-30.sql` (`ENTER_BY` 로 삭제).

## 3. 478 재검증 (생산계획 2026-09-30 ~ 10-30, 15건)

| 항목 | 결과 |
|---|---|
| 소요량 | 119행 (거래유형 F 118 · M 1) |
| 발주계획 | 119행 — 발주 필요 85 · 재고로 충당 34 |
| 단가 연결 | 117행 매칭(납품구분 2 · KRW). 단가 값은 단가 마스터에 0 으로 들어 있다 (무상구매 F) |
| 공급처 `*`(미지정) | 5행 |

발주 확정(`purchase()`)은 실주문이 생기므로 실행하지 않았다.

## 남은 일 (사용자 확인)

| 항목 | 내용 |
|---|---|
| 업체명 | 추가한 59개는 이름이 코드 그대로다. 공급처 선택 목록에 코드명 항목이 늘었다. 실제 업체명 입력 필요 |
| 같은 업체 두 행 | `델콤`↔`DC`, `인팩`↔`IP`, `'01937`↔`01937`(앞 따옴표), `1783`↔`01783`. 병합은 참조 5개 표를 함께 바꿔야 하는 별도 작업 |
| 테스트 데이터 | 478 `IM_ITEM_PURCHASE_ORDER_PLAN` 119 · `IM_ITEM_PURCHASE_REQUIR_ORDER` 119 · `IM_ITEM_INVENTORY_GEN`, 477 기준계획 3 · 소요량 416 (등록자 `CLAUDE_TEST`) |

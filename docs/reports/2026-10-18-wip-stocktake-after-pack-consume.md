# 미완료: 완제품 실적 소비 이후 공정 실사 계산 (2026-10-18, 2026-10-19 갱신)

## 상태

- 2026-10-17 15:33 부터 반제품(AOI 실적)이, 완제품 실적 전환(`ISYS_CONFIG WIP_RESULT_CONSUME_FROM`) 뒤부터 조립라인 완제품 실적의 제품이
  공정재고 장부에 품목 그대로 들어간다. 설계: `docs/specs/2026-10-17-wip-semi-product-from-aoi-design.md` 5-2 ~ 5-7.
  (2026-10-18 의 포장 시점 소비 `WIP_PACK_CONSUME_FROM` 은 처리된 박스 0건인 채 삭제됐다.)
- 공정 실사 계산(`apps/backend/src/modules/inventory-query/wip-bom.ts` 의 `wipCountedSql`·`wipMovedSql`, `wip-stocktake.service.ts`)은
  "장부는 원자재뿐이고, 센 반제품·제품·박스는 BOM 말단 자재로 풀어 더한다" 전제 그대로다.

## 해야 할 일 (2026-11 말 최종 실사 전)

1. 실사에서 센 반제품·완제품(전환 뒤 실적분)은 풀지 않고 그 품목으로 센다. 전환 전 미입고 박스·라인의 반제품(전환 전 AOI)은 지금처럼 푼다.
2. `wipMovedSql`(장부 고정 뒤 입고된 안 센 박스 몫): 전환 뒤 포장 박스는 자재 말단이 아니라 제품 품목 몫을 뺀다.
3. 실사 조정은 공정(WORKSTAGE_CODE)을 어떻게 둘지 정한다 — 반제품은 공정별 현재고(`IM_ITEM_WORKSTAGE_INV_WS`)가 있다.

## 다음 세션 확인

- `ISYS_CONFIG` `WIP_DIRECT_CONSUME_FROM`·`WIP_RESULT_CONSUME_FROM` 값, 잡 161 상태(162 는 제거), `wip-bom.ts` 현재 코드로 다시 확인한 뒤 진행한다.

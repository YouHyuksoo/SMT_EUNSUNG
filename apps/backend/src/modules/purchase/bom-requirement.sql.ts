/**
 * @file src/modules/purchase/bom-requirement.sql.ts
 * @description 477 소요량 전개와 478 발주계획 생성이 함께 쓰는 BOM 전개 결과 조건.
 *
 * 두 SQL 조각 모두 `ID_ENG_BOM_TEMP` 를 별칭 `T` 로 읽는 문장 안에 넣는다.
 *
 * PB 는 전개 결과를 BOM 의 LINE_TYPE(구매구분)으로 걸렀다 (477: IN G·D·N·S·M·F·B,
 * 478: NOT IN A·T). 은성 BOM 은 LINE_TYPE 이 거의 전부 'T'(자작)로 일괄 입력돼 있어
 * 그대로 두면 소요량이 0 건이 된다. 사용자 결정(2026-09-30)으로 구매구분은 보지 않는다.
 */

/**
 * 말단 자재만 남긴다. 같은 전개 안에서 하위 품목을 가진 행(모델 자신·반제품)은
 * 자재가 아니므로 뺀다. 구매구분 필터가 하던 "반제품 제외"를 구조로 대신한다.
 */
export const LEAF_ONLY_SQL = `NOT EXISTS (SELECT 'X' FROM ID_ENG_BOM_TEMP P
                                 WHERE P.SESSION_ID = T.SESSION_ID
                                   AND P.PARENT_ITEM_CODE = T.CHILD_ITEM_CODE)`;

/**
 * 소요량 행에 붙일 거래유형. BOM 값('T') 대신 재고·단가·발주가 쓰는 품목 기준정보
 * 값을 붙여야 478 의 재고 차감·단가 연결이 맞는다. 품목이 없으면 BOM 값.
 */
export const ITEM_LINE_TYPE_SQL = `NVL((SELECT MAX(I.LINE_TYPE) FROM ID_ITEM I
                 WHERE I.ITEM_CODE = T.CHILD_ITEM_CODE
                   AND I.ORGANIZATION_ID = T.ORGANIZATION_ID), T.LINE_TYPE)`;

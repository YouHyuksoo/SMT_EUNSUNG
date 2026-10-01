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
import * as oracledb from 'oracledb';

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

/**
 * BOM 이 없어 펼 수 없는 계획은 그 줄만 건너뛰고 나머지를 전개한다 (사용자 결정 2026-10-01).
 * `PKG_DESIGN.BOM_EXPLOSION` 은 BOM 이 없으면 음수를 준다. 건너뛴 품목은 PL/SQL 변수
 * `v_skipped` 에 쉼표로 모아 `:skipped` OUT 바인드로 돌려준다.
 * 블록에 `v_bom_session NUMBER;` 와 {@link SKIPPED_DECLARE_SQL} 을 선언해야 한다.
 */
export const SKIPPED_DECLARE_SQL = `v_skipped VARCHAR2(4000);`;

export const skipNoBomSql = (itemExpr: string) => `IF v_bom_session IS NULL OR v_bom_session < 0 THEN
               IF NVL(LENGTH(v_skipped), 0) < 3800 THEN
                 v_skipped := v_skipped || ',' || ${itemExpr};
               END IF;
               CONTINUE;
             END IF;`;

export const SKIPPED_ASSIGN_SQL = `:skipped := v_skipped;`;

export const skippedOutBind = () => ({
  dir: oracledb.BIND_OUT,
  type: oracledb.STRING,
  maxSize: 4000,
});

/** OUT 바인드 결과 → 중복 없는 품목코드 목록 */
export const parseSkipped = (raw: unknown): string[] => {
  const value = (raw as { skipped?: string | null } | undefined)?.skipped ?? '';
  return [...new Set(value.split(',').filter(Boolean))];
};

/**
 * `PKG_DESIGN.BOM_EXPLOSION` 이 "BOM 없음"(-100)으로 판단하는 조건과 같다:
 * 그 계획일에 유효한 BOM 행 중 그 품목을 CHILD 로 가진 행이 하나도 없다.
 * 전개 실패내역 조회에 쓴다 — 전개가 건너뛴 행과 같은 행이 나와야 한다.
 */
export const noBomSql = (itemExpr: string, dateExpr: string, orgExpr: string) => `NOT EXISTS (
         SELECT 'X' FROM ID_ENG_BOM B
          WHERE B.CHILD_ITEM_CODE = ${itemExpr}
            AND B.ORGANIZATION_ID = ${orgExpr}
            AND TRUNC(B.DATESET) <= ${dateExpr}
            AND NVL(B.DATEEND, DATE '9999-12-31') >= ${dateExpr})`;

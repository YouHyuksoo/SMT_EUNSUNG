/**
 * @file src/modules/inventory-query/total-inventory.service.ts
 * @description 269 총재고조회 — PB `w_mat_total_inventory_query` 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. **한 품목이 지금 어디에 얼마나 있는지 한 줄로 보는 화면이다.** 재고는 네 군데에
 *    흩어져 있다 — 자재창고 · 공정(라인) · 조립품 · 완제품. 그 넷을 합쳐 보여준다.
 * 2. **합계는 DB 함수가 낸다.** 품목마다 함수 네 개를 부른다:
 *        `F_GET_MAT_INVENTORY_QTY_ALL`   자재창고 재고
 *        `F_GET_MAT_WS_INV_QTY`          공정(라인) 재고
 *        `F_GET_SAL_ASSY_INV_BY_ITEM`    조립품 재고
 *        `F_GET_SAL_PROD_INV_BY_ITEM`    완제품 재고
 *    넷 다 PB 동명 함수가 **없는** DB 함수라 그대로 부른다 (실측). 합계 규칙을
 *    TypeScript 로 다시 쓰면 다른 화면과 숫자가 갈린다.
 * 3. **함수를 품목당 네 번만 부른다.** 합계를 SQL 안에서 다시 더하려고 네 함수를
 *    한 번 더 부르게 했더니 2,560품목 조회가 **54.38초**가 됐다 (실측).
 *    값은 이미 손에 있으므로 합계는 TypeScript 에서 더한다 → **6.25초**.
 *    그래도 빠르지는 않다 — 품목 전체를 보면 함수가 10,240번 돌기 때문이고 PB 도
 *    같은 값을 치른다. 품목분류·구분으로 좁히면 1,628품목에 2.60초다. 화면이
 *    그렇게 안내한다.
 * 4. **상세는 두 가지로 나뉜다.**
 *        창고별 — 자재창고와 공정 재고를 합쳐 어느 자리에 얼마가 있는지
 *        롯트별 — 고른 품목 하나를 롯트 단위로
 *    둘 다 **수량이 0 인 것은 뺀다** (PB 고정조건) — 0 을 빼지 않으면 183만 행이
 *    그대로 나온다. 실측 0 이 아닌 것은 4,690행이다.
 * 5. **쓰기가 없다.** PB DataWindow 가 `update="ID_ITEM"` 을 달고 있지만 갱신 가능한
 *    편집 열이 하나도 없어 무동작이다 (실측).
 * 6. **BOM 기준 조회는 옮기지 않았다.** `ID_ENG_BOM_TEMP` 를 읽는데 그 표는 선두
 *    인덱스가 `SESSION_ID` 인 **세션 임시표**라 웹이 PB 세션의 행을 읽을 수 없다
 *    (238 의 출고계획 모드와 같은 이유).
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { TotalInventoryDetailQueryDto, TotalInventoryQueryDto } from './inventory-query.dto';

type Row = Record<string, unknown>;

@Injectable()
export class TotalInventoryService {
  constructor(private readonly dataSource: DataSource) {}

  /**
   * 품목별 총재고 (PB `d_mat_total_inventory_query`).
   *
   * 네 군데 재고를 함수로 붙인다. **합계는 SQL 이 아니라 여기서 더한다** —
   * 같은 SELECT 안에서 네 함수를 다시 부르면 호출이 두 배가 되어 조회가
   * 54.38초에서 안 끝난다 (실측).
   */
  async findTotals(query: TotalInventoryQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT i.ITEM_CODE                 AS "itemCode",
              i.ITEM_NAME                 AS "itemName",
              i.ITEM_SPEC                 AS "itemSpec",
              i.ITEM_UOM                  AS "itemUom",
              i.ITEM_TYPE                 AS "itemType",
              i.ITEM_CLASS                AS "itemClass",
              i.ITEM_DIVISION             AS "itemDivision",
              i.SET_ITEM_YN               AS "setItemYn",
              i.SAFETY_INVENTORY          AS "safetyInventory",
              i.BUY_PRICE                 AS "buyPrice",
              F_GET_MAT_INVENTORY_QTY_ALL(i.ITEM_CODE, i.ORGANIZATION_ID) AS "inventoryQty",
              F_GET_MAT_WS_INV_QTY(i.ITEM_CODE, i.ORGANIZATION_ID)        AS "workstageQty",
              F_GET_SAL_ASSY_INV_BY_ITEM(i.ITEM_CODE, i.ORGANIZATION_ID)  AS "assemblyQty",
              F_GET_SAL_PROD_INV_BY_ITEM(i.ITEM_CODE, i.ORGANIZATION_ID)  AS "productQty"
         FROM ID_ITEM i
        WHERE i.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(i.ITEM_DIVISION, '*') LIKE :itemDivision ESCAPE '\\'
          AND NVL(i.ITEM_CLASS, '*') LIKE :itemClass ESCAPE '\\'
          AND i.ORGANIZATION_ID = :organizationId
        ORDER BY i.ITEM_CLASS, i.ITEM_DIVISION, i.SET_ITEM_YN DESC, i.ITEM_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        itemCode: likePrefix(query.itemCode),
        itemDivision: likePrefix(query.itemDivision),
        itemClass: likePrefix(query.itemClass),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    // **합계는 여기서 더한다.** 같은 SELECT 안에서 네 함수를 다시 부르면 호출이
    // 두 배가 되어 2,560품목 조회가 **54.38초**가 됐다 (실측). 값은 이미 손에
    // 있으므로 SQL 에 다시 물을 이유가 없다.
    const withTotal = rows.map((r) => ({
      ...r,
      totalQty: Number(r.inventoryQty ?? 0) + Number(r.workstageQty ?? 0)
        + Number(r.assemblyQty ?? 0) + Number(r.productQty ?? 0),
    }));
    return limited(withTotal);
  }

  /**
   * 자리별 상세 (PB `d_mat_total_inventory_detail`).
   *
   * 자재창고와 공정 재고를 합쳐 어느 자리에 얼마가 있는지 본다.
   * **수량 0 은 뺀다** — 빼지 않으면 1,837,704행이 그대로 나온다 (실측 0 이 아닌 것
   * 4,690행).
   */
  async findByLocation(query: TotalInventoryDetailQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT a.DIV                        AS "div",
              a.LOCATION_CODE              AS "locationName",
              a.ITEM_CODE                  AS "itemCode",
              b.ITEM_NAME                  AS "itemName",
              b.ITEM_SPEC                  AS "itemSpec",
              b.ITEM_UOM                   AS "itemUom",
              a.INVENTORY_QTY              AS "inventoryQty"
         FROM ( SELECT 'WAREHOUSE' DIV,
                       F_GET_BASECODE('MATERIAL LOCATION CODE', v.LOCATION_CODE,
                                      :lang, v.ORGANIZATION_ID) LOCATION_CODE,
                       v.ITEM_CODE, v.INVENTORY_QTY, v.ORGANIZATION_ID
                  FROM IM_ITEM_INVENTORY v
                 WHERE v.INVENTORY_QTY <> 0
                UNION ALL
                SELECT 'WORKSTAGE',
                       F_GET_LINE_NAME(w.LINE_CODE, w.ORGANIZATION_ID),
                       w.ITEM_CODE, w.INVENTORY_QTY, w.ORGANIZATION_ID
                  FROM IM_ITEM_WORKSTAGE_INVENTORY w
                 WHERE w.INVENTORY_QTY <> 0 ) a
         JOIN ID_ITEM b
           ON b.ITEM_CODE = a.ITEM_CODE
          AND b.ORGANIZATION_ID = a.ORGANIZATION_ID
        WHERE a.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND a.ORGANIZATION_ID = :organizationId
        ORDER BY a.ITEM_CODE, a.DIV, a.LOCATION_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      {
        lang: query.lang ?? 'KOR',
        itemCode: likePrefix(query.itemCode),
        organizationId,
      } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /**
   * 롯트별 상세 (PB `d_mat_total_inventory_detail_lot_qty`).
   *
   * 품목 하나를 롯트 단위로 본다. 공정 재고 쪽은 라인별 수량을 DB 함수가 다시
   * 계산한다 (`F_GET_MAT_WS_INV_QTY_BY_LINE`) — 공정 재고표가 이동 이력이라
   * 행을 그대로 더하면 값이 맞지 않는다.
   */
  async findByLot(itemCode: string, lang: string, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT 'WAREHOUSE'                  AS "div",
              F_GET_BASECODE('LOCATION CODE', v.LOCATION_CODE, :lang, :organizationId)
                                           AS "locationName",
              v.LOCATION_CODE              AS "locationCode",
              v.MATERIAL_MFS               AS "lotNo",
              v.INVENTORY_QTY              AS "inventoryQty"
         FROM IM_ITEM_INVENTORY v
        WHERE v.ITEM_CODE = :itemCode
          AND v.INVENTORY_QTY <> 0
          AND v.ORGANIZATION_ID = :organizationId
        UNION ALL
       SELECT 'WORKSTAGE',
              F_GET_LINE_NAME(w.LINE_CODE, w.ORGANIZATION_ID),
              w.LINE_CODE,
              w.MATERIAL_MFS,
              F_GET_MAT_WS_INV_QTY_BY_LINE(w.ITEM_CODE, w.LINE_CODE,
                                           w.MATERIAL_MFS, w.ORGANIZATION_ID)
         FROM IM_ITEM_WORKSTAGE_INVENTORY w
        WHERE w.ITEM_CODE = :itemCode
          AND w.ORGANIZATION_ID = :organizationId
          AND F_GET_MAT_WS_INV_QTY_BY_LINE(w.ITEM_CODE, w.LINE_CODE,
                                           w.MATERIAL_MFS, w.ORGANIZATION_ID) <> 0
        GROUP BY w.LINE_CODE, w.ITEM_CODE, w.MATERIAL_MFS, w.ORGANIZATION_ID`,
      { itemCode, lang: lang || 'KOR', organizationId } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }
}

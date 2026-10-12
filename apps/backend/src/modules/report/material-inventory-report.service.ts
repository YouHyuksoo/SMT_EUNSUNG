/**
 * @file src/modules/report/material-inventory-report.service.ts
 * @description 자재 재고 리포트 2화면
 *              368 w_mat_long_term_inventory_report  자재장기재고리포트
 *              369 w_mat_current_inventory_report    재고리포트
 *
 * 초보자 가이드:
 * 1. **IM_ITEM_INVENTORY 에는 날짜 인덱스가 없다** (183만행 · 실측 인덱스는
 *    ITEM_CODE · MATERIAL_MFS · (MATERIAL_MFS, LOCATION_CODE) 뿐). 그래서 이
 *    화면들은 기간이 아니라 **품목·위치 조건**으로 막는다.
 * 2. **재고수량이 0 보다 큰 행은 3,540행뿐이다** (183만행 중 — 실측). 장기재고와
 *    불용재고는 그 조건이 있어 가볍고, 상세·합계 탭은 `SIGN(qty) >= 0` 이 기본이라
 *    0 짜리 행까지 다 걸린다. 그 두 탭에 품목 조건을 권하는 이유다.
 * 3. **369 일일 탭의 재공수량은 함수를 못 쓴다.** PB 는
 *    `F_GET_MAT_WS_ITEM_INV_QTY` 를 호출하는데 그 함수는 **INVALID 상태다**
 *    (실측). 본문이 `IM_ITEM_WORKSTAGE_INVENTORY.LINE_TYPE` 을 참조하는데 그
 *    컬럼이 없기 때문이다 — 그 표에 있는 것은 LINE_CODE 이고 1,256행 전부 NULL 이다.
 *    INVALID 함수를 호출하면 쿼리 자체가 실행되지 않으므로 직접 집계로 바꿨다.
 *    **집계 기준이 PB 와 다르다**: PB 는 (품목, 구매유형) 으로 부르지만 여기서는
 *    (품목, 조직) 으로 합산한다. 구매유형으로 가를 근거가 표에 없다.
 *    DB 오브젝트는 건드리지 않았다.
 * 4. **불용재고의 함수 호출을 한 번으로 줄였다.** PB 는 WHERE 안에서 같은 인자로
 *    `F_GET_MAT_ISSUE_QTY_4_DISUSED` 를 행마다 최대 3번 호출한다. 한 번 계산해
 *    바깥에서 거르면 결과는 같고 호출은 1/3 이다.
 * 5. **입고·출고 수량은 PB 와 같은 DB 함수가 센다** (`F_GET_MAT_RECEIPT_BY_DATE`,
 *    `F_GET_MAT_ISSUE_BY_DATE`). TypeScript 로 다시 쓰면 PB 와 숫자가 갈린다.
 */
import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { likePrefix } from '@smt/shared';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import {
  MaterialDisusedQueryDto,
  MaterialInventoryDailyQueryDto,
  MaterialInventoryQueryDto,
  MaterialLongTermQueryDto,
} from './material-report.dto';
import { namedBinds } from '../../common/utils/named-binds.util';

type Row = Record<string, unknown>;


@Injectable()
export class MaterialInventoryReportService {
  constructor(private readonly dataSource: DataSource) {}

  /** 369 의 네 탭이 함께 쓰는 조건 (PB `SIGN(qty) >= :arg_sign` 그대로). */
  private inventoryWhere(withItemClass: boolean) {
    return `v.ITEM_CODE LIKE :itemCode ESCAPE '\\'
        AND NVL(v.LOCATION_CODE, '*') LIKE :locationCode ESCAPE '\\'
        AND SIGN(NVL(v.INVENTORY_QTY, 0)) >= :sign
        AND v.ORGANIZATION_ID = :organizationId
        ${withItemClass ? `AND NVL(i.ITEM_CLASS, '*') LIKE :itemClass ESCAPE '\\'` : ''}`;
  }

  private inventoryBinds(
    query: MaterialInventoryQueryDto,
    organizationId: number,
    withItemClass: boolean,
  ) {
    const binds: Row = {
      itemCode: likePrefix(query.itemCode),
      locationCode: likePrefix(query.locationCode),
      sign: query.sign ?? 0,
      organizationId,
    };
    if (withItemClass) binds.itemClass = likePrefix(query.itemClass);
    return binds;
  }

  // ───────────────────────────────── 369 재고리포트 · 상세

  /** 롯트(자재 MFS)별 재고 상세. 안전재고와 비교해 부족을 찾는 탭이다. */
  async findInventoryDetail(query: MaterialInventoryQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT v.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.ITEM_UOM                                AS "itemUom",
              i.SAFETY_INVENTORY                        AS "safetyInventory",
              v.MATERIAL_MFS                            AS "materialMfs",
              v.LINE_TYPE                               AS "lineType",
              v.LOCATION_CODE                           AS "locationCode",
              v.INVENTORY_QTY                           AS "inventoryQty",
              v.INVENTORY_PRICE                         AS "inventoryPrice",
              v.INVENTORY_AMT                           AS "inventoryAmt",
              v.INVENTORY_HOLD                          AS "inventoryHold",
              v.INVENTORY_STATUS                        AS "inventoryStatus",
              v.COMMENTS                                AS "comments",
              v.ENTER_BY                                AS "enterBy",
              TO_CHAR(v.ENTER_DATE, 'YYYY-MM-DD HH24:MI:SS')     AS "enterDate",
              v.LAST_MODIFY_BY                          AS "lastModifyBy",
              TO_CHAR(v.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "lastModifyDate"
         FROM IM_ITEM_INVENTORY v
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = v.ITEM_CODE
               AND i.ORGANIZATION_ID = v.ORGANIZATION_ID
        WHERE ${this.inventoryWhere(false)}
        ORDER BY v.ITEM_CODE, v.MATERIAL_MFS
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds(this.inventoryBinds(query, organizationId, false)),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 품목별 재고합계.
   *
   * 재고단가는 PB 와 같이 `금액 합 ÷ 수량 합` 이다 (수량이 0 이면 0 — PB DECODE).
   */
  async findInventorySummary(query: MaterialInventoryQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT v.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.ITEM_UOM                                AS "itemUom",
              i.ITEM_CLASS                              AS "itemClass",
              v.LINE_TYPE                               AS "lineType",
              v.INVENTORY_STATUS                        AS "inventoryStatus",
              SUM(NVL(v.INVENTORY_QTY, 0))              AS "inventoryQty",
              SUM(NVL(v.INVENTORY_AMT, 0))              AS "inventoryAmt",
              -- 수량 합이 0 이면 0 (PB DECODE 그대로). 안 막으면 0 으로 나눈다.
              DECODE(SUM(NVL(v.INVENTORY_QTY, 0)), 0, 0,
                     SUM(NVL(v.INVENTORY_AMT, 0)) / SUM(NVL(v.INVENTORY_QTY, 0)))
                                                        AS "inventoryPrice"
         FROM IM_ITEM_INVENTORY v
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = v.ITEM_CODE
               AND i.ORGANIZATION_ID = v.ORGANIZATION_ID
        WHERE ${this.inventoryWhere(true)}
        GROUP BY v.ITEM_CODE, i.ITEM_NAME, i.ITEM_SPEC, i.ITEM_UOM, i.ITEM_CLASS,
                 v.LINE_TYPE, v.INVENTORY_STATUS
        ORDER BY v.ITEM_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds(this.inventoryBinds(query, organizationId, true)),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 일일 재고 (기준일의 입고·출고·재공을 함께 본다).
   *
   * 재공수량은 PB 의 INVALID 함수 대신 직접 집계한다 (파일 머리 4번 참고).
   * PB 는 (품목, 구매유형) 인자로 불렀지만 표에 구매유형이 없어 (품목, 조직) 으로
   * 합산한다 — **숫자의 정의가 PB 와 다르다.**
   */
  async findInventoryDaily(query: MaterialInventoryDailyQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT v.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.ITEM_UOM                                AS "itemUom",
              v.LINE_TYPE                               AS "lineType",
              v.LOCATION_CODE                           AS "locationCode",
              v.INVENTORY_STATUS                        AS "inventoryStatus",
              SUM(NVL(v.INVENTORY_QTY, 0))              AS "inventoryQty",
              -- 기준일 하루치 입고·출고. PB 와 같은 DB 함수다.
              F_GET_MAT_RECEIPT_BY_DATE(v.ITEM_CODE, v.LINE_TYPE,
                                        TRUNC(TO_DATE(:baseDate, 'YYYY-MM-DD')),
                                        v.ORGANIZATION_ID)      AS "receiptQty",
              F_GET_MAT_ISSUE_BY_DATE(v.ITEM_CODE, v.LINE_TYPE, v.LOCATION_CODE,
                                      TRUNC(TO_DATE(:baseDate, 'YYYY-MM-DD')),
                                      v.ORGANIZATION_ID)        AS "issueQty",
              -- 공정재공. PB 의 F_GET_MAT_WS_ITEM_INV_QTY 는 INVALID 라 못 쓴다.
              -- 행마다 부르는 상관 서브쿼리 대신 미리 집계해 붙인다 (값은 같고
              -- 1,256행짜리 표를 한 번만 읽는다).
              MAX(w.WORKSTAGE_QTY)                      AS "workstageInventoryQty"
         FROM IM_ITEM_INVENTORY v
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = v.ITEM_CODE
               AND i.ORGANIZATION_ID = v.ORGANIZATION_ID
         LEFT JOIN ( SELECT ITEM_CODE, ORGANIZATION_ID,
                            SUM(NVL(INVENTORY_QTY, 0)) AS WORKSTAGE_QTY
                       FROM IM_ITEM_WORKSTAGE_INVENTORY
                      GROUP BY ITEM_CODE, ORGANIZATION_ID ) w
                ON w.ITEM_CODE = v.ITEM_CODE
               AND w.ORGANIZATION_ID = v.ORGANIZATION_ID
        WHERE ${this.inventoryWhere(true)}
        GROUP BY v.ITEM_CODE, i.ITEM_NAME, i.ITEM_SPEC, i.ITEM_UOM,
                 v.LINE_TYPE, v.LOCATION_CODE, v.INVENTORY_STATUS, v.ORGANIZATION_ID
        ORDER BY v.ITEM_CODE, v.LOCATION_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        ...this.inventoryBinds(query, organizationId, true),
        baseDate: query.baseDate,
      }),
    )) as Row[];
    return limited(rows);
  }

  /**
   * 불용재고 (오래 안 나간 재고).
   *
   * 판정은 PB 와 같다 — 개월수 안의 출고량이 0 이거나, 재고 대비 출고율이
   * 기준 이하인 재고다. `termMonths = 0` 이면 출고량 조건을 걸지 않는다
   * (PB DECODE 그대로).
   *
   * **함수 호출을 PB 의 1/2 이하로 줄였다.** PB 는 WHERE 에서 세 번 + SELECT 에서
   * 두 번, 모두 같은 인자로 같은 함수를 불렀다. 여기서는 세 단계로 나눈다:
   *   1단 출고량을 한 번 계산한다 (`INVENTORY_QTY > 0` 으로 3,540행까지 줄어든 뒤다)
   *   2단 그 값으로 불용을 판정한다
   *   3단 **남은 행에만** 마지막 출고일을 계산한다 (판정에 쓰이지 않는 값이다)
   * 값은 PB 와 같다.
   */
  async findDisusedInventory(query: MaterialDisusedQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT j."itemCode", j."itemName", j."itemSpec", j."itemUom",
              j."safetyInventory", j."materialMfs", j."lineType", j."locationCode",
              j."inventoryQty", j."inventoryPrice", j."inventoryAmt",
              j."inventoryHold", j."inventoryStatus", j."comments", j."issueQty",
              TO_CHAR(F_GET_MAT_ISSUE_DATE_4_DISUSED(j."materialMfs", j."itemCode",
                                                     j."lineType", :termMonths,
                                                     j."organizationId"),
                      'YYYY-MM-DD')                     AS "lastIssueDate"
         FROM ( SELECT d.*
                  FROM ( SELECT v.ITEM_CODE             AS "itemCode",
                                i.ITEM_NAME             AS "itemName",
                                i.ITEM_SPEC             AS "itemSpec",
                                i.ITEM_UOM              AS "itemUom",
                                i.SAFETY_INVENTORY      AS "safetyInventory",
                                v.MATERIAL_MFS          AS "materialMfs",
                                v.LINE_TYPE             AS "lineType",
                                v.LOCATION_CODE         AS "locationCode",
                                v.INVENTORY_QTY         AS "inventoryQty",
                                v.INVENTORY_PRICE       AS "inventoryPrice",
                                v.INVENTORY_AMT         AS "inventoryAmt",
                                v.INVENTORY_HOLD        AS "inventoryHold",
                                v.INVENTORY_STATUS      AS "inventoryStatus",
                                v.COMMENTS              AS "comments",
                                v.ORGANIZATION_ID       AS "organizationId",
                                -- 불용 판정에 쓰는 값. 여기서 한 번만 계산한다.
                                F_GET_MAT_ISSUE_QTY_4_DISUSED(v.MATERIAL_MFS, v.ITEM_CODE,
                                                              v.LINE_TYPE, :termMonths,
                                                              v.ORGANIZATION_ID)
                                                        AS "issueQty"
                           FROM IM_ITEM_INVENTORY v
                           LEFT JOIN ID_ITEM i
                                  ON i.ITEM_CODE = v.ITEM_CODE
                                 AND i.ORGANIZATION_ID = v.ORGANIZATION_ID
                          WHERE v.ITEM_CODE LIKE :itemCode ESCAPE '\\'
                            AND v.ORGANIZATION_ID = :organizationId
                            AND v.INVENTORY_QTY > 0 ) d
                 -- 개월수가 0 이면 출고량 조건을 걸지 않는다 (PB DECODE 그대로).
                 WHERE ( :termMonths = 0
                      OR d."issueQty" = 0
                      -- 출고율(%) = 출고량 / 재고량 × 100. 재고 0 은 위에서 걸러졌다.
                      OR d."issueQty" / d."inventoryQty" * 100 <= :maxIssueRate )
                 ORDER BY d."itemCode", d."materialMfs"
                 FETCH FIRST ${ROW_LIMIT} ROWS ONLY ) j`,
      namedBinds({
        termMonths: query.termMonths,
        maxIssueRate: query.maxIssueRate ?? 0,
        itemCode: likePrefix(query.itemCode),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }

  // ───────────────────────────────── 368 자재장기재고리포트

  /**
   * 장기재고 — 마지막 입고가 기준일에서 N개월 이전인 재고.
   *
   * PB: `LAST_RECEIPT_DATE <= ADD_MONTHS(TO_DATE(:arg_date), :arg_term * -1)`.
   * 기간이 아니라 **기준일 + 개월수**다.
   *
   * 품목명을 함께 보여준다 — PB 는 품목코드만 보여줘서 무엇이 잠겨 있는지
   * 코드를 외우지 않으면 알 수 없었다.
   */
  async findLongTermInventory(query: MaterialLongTermQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT v.ITEM_CODE                               AS "itemCode",
              i.ITEM_NAME                               AS "itemName",
              i.ITEM_SPEC                               AS "itemSpec",
              i.ITEM_UOM                                AS "itemUom",
              v.MATERIAL_MFS                            AS "materialMfs",
              v.SUPPLIER_CODE                           AS "supplierCode",
              F_GET_SUPPLIER_NAME(v.SUPPLIER_CODE, v.ORGANIZATION_ID) AS "supplierName",
              v.INVENTORY_QTY                           AS "inventoryQty",
              v.LOCATION_ADDRESS_RACK                   AS "locationAddressRack",
              TO_CHAR(v.LAST_RECEIPT_DATE, 'YYYY-MM-DD')             AS "lastReceiptDate",
              -- 며칠째 입고가 없는지. PB 는 날짜만 보여줘 며칠인지 세어야 했다.
              TRUNC(TO_DATE(:baseDate, 'YYYY-MM-DD') - TRUNC(v.LAST_RECEIPT_DATE))
                                                        AS "idleDays"
         FROM IM_ITEM_INVENTORY v
         LEFT JOIN ID_ITEM i
                ON i.ITEM_CODE = v.ITEM_CODE
               AND i.ORGANIZATION_ID = v.ORGANIZATION_ID
        WHERE v.LAST_RECEIPT_DATE <= ADD_MONTHS(TO_DATE(:baseDate, 'YYYY-MM-DD'),
                                                :termMonths * -1)
          AND v.ITEM_CODE LIKE :itemCode ESCAPE '\\'
          AND NVL(v.MATERIAL_MFS, '*') LIKE :materialMfs ESCAPE '\\'
          AND NVL(v.SUPPLIER_CODE, '*') LIKE :supplierCode ESCAPE '\\'
          AND v.ORGANIZATION_ID = :organizationId
          AND v.INVENTORY_QTY > 0
        ORDER BY v.LAST_RECEIPT_DATE, v.ITEM_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      namedBinds({
        baseDate: query.baseDate,
        termMonths: query.termMonths,
        itemCode: likePrefix(query.itemCode),
        materialMfs: likePrefix(query.materialMfs),
        supplierCode: likePrefix(query.supplierCode),
        organizationId,
      }),
    )) as Row[];
    return limited(rows);
  }
}

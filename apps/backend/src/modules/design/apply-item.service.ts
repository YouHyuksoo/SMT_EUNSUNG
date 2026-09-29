/**
 * @file src/modules/design/apply-item.service.ts
 * @description 149 적용모델관리 — PB `w_des_apply_item_master` 이식 (조회 전용)
 *
 * 초보자 가이드:
 * 1. **"이 자재가 어느 제품에 들어가나"를 거슬러 올라가는 화면이다.** 자재코드를
 *    하나 주면 그 자재를 쓰는 상위 품목을 BOM 을 타고 **끝까지** 찾아 올라간다.
 *    설계 변경이나 단종을 검토할 때 영향 범위를 보는 데 쓴다.
 * 2. **BOM 을 거꾸로 탄다.** `CONNECT BY PRIOR PARENT_ITEM_CODE = CHILD_ITEM_CODE` 라
 *    자식에서 부모로 올라간다 (보통의 BOM 전개는 반대 방향이다).
 * 3. **오늘 유효한 BOM 만 본다** (PB 고정조건): `DATESET <= 오늘 <= NVL(DATEEND, 오늘)`.
 *    끝난 BOM 까지 끌고 올라가면 이미 단종된 제품이 영향 범위에 섞인다.
 * 4. **조회 전용이다.** PB 의 DataWindow 두 개에 갱신 설정이 남아 있지만
 *    `dw.update()` 를 **한 번도 부르지 않는다** — 화면에서 고쳐도 저장되지 않는 상태였다.
 *    그래서 웹도 읽기만 한다.
 * 5. 고른 품목이 제품모델이면 아래에 모델 기준정보를 함께 보여준다.
 */
import { BadRequestException, Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { limited, ROW_LIMIT } from '../../shared/row-limit';
import { ApplyItemQueryDto, ApplyModelQueryDto } from './apply-item.dto';

type Row = Record<string, unknown>;

@Injectable()
export class ApplyItemService {
  constructor(private readonly dataSource: DataSource) {}

  /**
   * 이 자재를 쓰는 상위 품목 전부 (PB `d_des_apply_item_lst`).
   *
   * **자재코드는 반드시 받는다.** 비우면 `START WITH` 가 전 품목이 되어 BOM
   * 1만 건을 모든 방향으로 전개한다.
   */
  async findApplyItems(query: ApplyItemQueryDto, organizationId: number) {
    const itemCode = (query.itemCode ?? '').trim();
    if (!itemCode) {
      throw new BadRequestException('자재(품목)코드를 넣으세요.');
    }

    const rows = (await this.dataSource.query(
      `SELECT i.ITEM_CODE        AS "itemCode",
              i.ITEM_NAME        AS "itemName",
              i.ITEM_SPEC        AS "itemSpec",
              i.ITEM_UOM         AS "itemUom",
              i.ITEM_TYPE        AS "itemType",
              i.ITEM_CLASS       AS "itemClass",
              i.LINE_TYPE        AS "lineType",
              i.BARCODE          AS "barcode",
              i.ABC_GRADE        AS "abcGrade",
              i.RAW_MATERIAL     AS "rawMaterial",
              i.SAFETY_INVENTORY AS "safetyInventory",
              i.WORK_BAD_RATE    AS "workBadRate",
              i.MANUFACTURE_LEADTIME AS "manufactureLeadtime",
              i.HS_CODE          AS "hsCode",
              i.SVC_CODE         AS "svcCode",
              i.ENTER_BY         AS "enterBy",
              TO_CHAR(i.ENTER_DATE, 'YYYY-MM-DD') AS "enterDate"
         FROM ID_ITEM i
        WHERE i.ORGANIZATION_ID = :organizationId
          AND i.ITEM_CODE IN (
                SELECT b.CHILD_ITEM_CODE
                  FROM ID_ENG_BOM b
                 WHERE b.DATESET <= TRUNC(SYSDATE)
                   AND NVL(b.DATEEND, TRUNC(SYSDATE)) >= TRUNC(SYSDATE)
                   AND b.ORGANIZATION_ID = :organizationId
                 START WITH b.CHILD_ITEM_CODE = :itemCode
                   AND b.DATESET <= TRUNC(SYSDATE)
                   AND NVL(b.DATEEND, TRUNC(SYSDATE)) >= TRUNC(SYSDATE)
                   AND b.ORGANIZATION_ID = :organizationId
                 -- 자식 → 부모 방향으로 거슬러 올라간다.
                 CONNECT BY PRIOR b.PARENT_ITEM_CODE = b.CHILD_ITEM_CODE
                   AND b.DATESET <= TRUNC(SYSDATE)
                   AND NVL(b.DATEEND, TRUNC(SYSDATE)) >= TRUNC(SYSDATE)
                   AND b.ORGANIZATION_ID = :organizationId)
        ORDER BY i.ITEM_CODE
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      { organizationId, itemCode } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }

  /** 고른 품목의 제품모델 기준정보 (PB `d_pln_product_model_master_simple_4_apply_mst`). */
  async findApplyModels(query: ApplyModelQueryDto, organizationId: number) {
    const rows = (await this.dataSource.query(
      `SELECT m.MODEL_NAME     AS "modelName",
              m.MODEL_SUFFIX   AS "modelSuffix",
              m.MODEL_TYPE     AS "modelType",
              m.MODEL_DIVISION AS "modelDivision",
              m.PART_NO        AS "partNo",
              m.ITEM_CODE      AS "itemCode",
              m.CUSTOMER_CODE  AS "customerCode",
              m.CUSTOMER_NAME  AS "customerName",
              m.CUSTOMER_MODEL_NAME AS "customerModelName",
              m.EC_NO          AS "ecNo",
              m.REVISION       AS "revision",
              m.PACKING_PCS_QTY AS "packingPcsQty",
              m.ARRAY_TYPE     AS "arrayType",
              m.BARCODE_TYPE   AS "barcodeType",
              TO_CHAR(m.DATESET, 'YYYY-MM-DD') AS "dateSet",
              TO_CHAR(m.DATEEND, 'YYYY-MM-DD') AS "dateEnd"
         FROM IP_PRODUCT_MODEL_MASTER m
        WHERE m.ORGANIZATION_ID = :organizationId
          AND m.ITEM_CODE = :itemCode
        ORDER BY m.MODEL_NAME
        FETCH FIRST ${ROW_LIMIT} ROWS ONLY`,
      { organizationId, itemCode: query.itemCode.trim() } as unknown as unknown[],
    )) as Row[];
    return limited(rows);
  }
}

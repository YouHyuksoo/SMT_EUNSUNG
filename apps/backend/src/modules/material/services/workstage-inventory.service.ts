import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { WorkstageInventoryQueryDto } from '../dto/workstage-inventory.dto';
import { namedBinds } from '../../../common/utils/named-binds.util';
import { wipUnreceivedPackWhere } from '../../inventory-query/wip-bom';

type OracleRow = Record<string, unknown>;

@Injectable()
export class WorkstageInventoryService {
  constructor(private readonly dataSource: DataSource) {}

  async find(query: WorkstageInventoryQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      itemCode: this.like(query.itemCode),
      includeZero: query.includeZero === 'N' ? 'N' : 'Y',
      itemDivision: query.itemDivision?.trim() || null,
      itemClass: query.itemClass?.trim() || null,
      supplierCode: query.supplierCode?.trim() || null,
    };
    const offset = (query.page - 1) * query.limit;
    const from = `
      FROM IM_ITEM_WORKSTAGE_INVENTORY inv
      INNER JOIN ID_ITEM item
        ON item.ITEM_CODE = inv.ITEM_CODE
       AND item.ORGANIZATION_ID = inv.ORGANIZATION_ID
      LEFT JOIN ICOM_SUPPLIER sup
        ON sup.SUPPLIER_CODE = item.SUPPLIER_CODE
       AND sup.ORGANIZATION_ID = item.ORGANIZATION_ID
      WHERE inv.ORGANIZATION_ID = :organizationId
        AND inv.ITEM_CODE LIKE :itemCode
        AND (:includeZero = 'Y' OR NVL(inv.INVENTORY_QTY, 0) > 0)
        AND (:itemDivision IS NULL OR item.ITEM_DIVISION = :itemDivision)
        AND (:itemClass IS NULL OR item.ITEM_CLASS = :itemClass)
        AND (:supplierCode IS NULL OR item.SUPPLIER_CODE = :supplierCode)
    `;
    const select = `
      SELECT inv.ITEM_CODE AS "itemCode",
             item.ITEM_NAME AS "itemName",
             item.ITEM_SPEC AS "itemSpec",
             item.ITEM_UOM AS "itemUom",
             item.ITEM_DIVISION AS "itemDivision",
             item.ITEM_CLASS AS "itemClass",
             item.SUPPLIER_CODE AS "supplierCode",
             sup.SUPPLIER_NAME AS "supplierName",
             item.MODEL_NAME AS "modelName",
             item.LOCATION_ADDRESS AS "locationAddress",
             inv.INVENTORY_QTY AS "inventoryQty",
             inv.ENTER_DATE AS "enterDate",
             inv.ENTER_BY AS "enterBy",
             inv.LAST_MODIFY_DATE AS "lastModifyDate",
             inv.LAST_MODIFY_BY AS "lastModifyBy",
             inv.ORGANIZATION_ID AS "organizationId"
      ${from}
      ORDER BY inv.ORGANIZATION_ID, inv.ITEM_CODE
      OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY
    `;
    const count = `SELECT COUNT(*) AS "total" ${from}`;
    const rows = await this.dataSource.query(
      select,
      namedBinds({ ...binds, offset, limit: query.limit }),
    ) as OracleRow[];
    const totals = await this.dataSource.query(count, namedBinds({ ...binds })) as OracleRow[];
    return {
      data: rows,
      total: Number(totals[0]?.total ?? 0),
      page: query.page,
      limit: query.limit,
    };
  }

  /**
   * 공정에 있는 제품 — 포장했지만 제품창고에 입고 안 한 박스를 모델·품목별로 묶는다.
   * 공정재고 장부는 원자재만 들고 있고, 이 박스의 자재도 아직 장부에 있다(입고 때 생산투입으로 빠진다).
   */
  async findProducts(organizationId: number) {
    return (await this.dataSource.query(
      `SELECT p.MODEL_NAME AS "modelName",
              p.PART_NO AS "itemCode",
              item.ITEM_NAME AS "itemName",
              item.ITEM_DIVISION AS "itemDivision",
              COUNT(*) AS "boxCount",
              SUM(p.PACK_QTY) AS "packQty",
              TO_CHAR(MIN(p.PACK_DATE), 'YYYY-MM-DD') AS "firstPackDate",
              TO_CHAR(MAX(p.PACK_DATE), 'YYYY-MM-DD') AS "lastPackDate"
         FROM IP_PRODUCT_PACK_MASTER p
         LEFT JOIN ID_ITEM item
           ON item.ITEM_CODE = p.PART_NO
          AND item.ORGANIZATION_ID = p.ORGANIZATION_ID
        WHERE p.ORGANIZATION_ID = :organizationId
          AND ${wipUnreceivedPackWhere('p')}
        GROUP BY p.MODEL_NAME, p.PART_NO, item.ITEM_NAME, item.ITEM_DIVISION
        ORDER BY p.MODEL_NAME, p.PART_NO`,
      namedBinds({ organizationId }),
    )) as OracleRow[];
  }

  /**
   * 공정별 공정재고 (IM_ITEM_WORKSTAGE_INV_WS). 공정이 정해진 행만 — 공정 미지정('*')은 자재 탭 장부에 있다.
   * W180(SMT) = AOI 실적으로 들어온 반제품과 그 소비, 후공정 = 매거진 스캔으로 옮겨 온 반제품.
   */
  async findByWorkstage(organizationId: number) {
    return (await this.dataSource.query(
      `SELECT w.WORKSTAGE_CODE AS "workstageCode", ws.WORKSTAGE_NAME AS "workstageName",
              w.ITEM_CODE AS "itemCode", item.ITEM_NAME AS "itemName", item.ITEM_DIVISION AS "itemDivision",
              w.INVENTORY_QTY AS "inventoryQty",
              TO_CHAR(w.LAST_MODIFY_DATE, 'YYYY-MM-DD HH24:MI') AS "lastModifyDate", w.LAST_MODIFY_BY AS "lastModifyBy"
         FROM IM_ITEM_WORKSTAGE_INV_WS w
         LEFT JOIN ID_ITEM item ON item.ITEM_CODE = w.ITEM_CODE AND item.ORGANIZATION_ID = w.ORGANIZATION_ID
         LEFT JOIN IP_PRODUCT_WORKSTAGE ws ON ws.WORKSTAGE_CODE = w.WORKSTAGE_CODE AND ws.ORGANIZATION_ID = w.ORGANIZATION_ID
        WHERE w.ORGANIZATION_ID = :organizationId AND w.WORKSTAGE_CODE <> '*' AND w.INVENTORY_QTY <> 0
        ORDER BY w.WORKSTAGE_CODE, w.ITEM_CODE`,
      namedBinds({ organizationId }),
    )) as OracleRow[];
  }

  /** 공정간 이동 — 최근 days 일 (기본 7일). 이동 원장(ENTER_BY = 'WS_MOVE') 한 쌍마다 한 줄 */
  async findMoves(organizationId: number, days = 7) {
    return (await this.dataSource.query(
      `SELECT TO_CHAR(m.MOVE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS "moveDate", m.MAGAZINE_LABEL_NO AS "magazineLabelNo",
              m.FROM_WORKSTAGE_CODE AS "fromWorkstageCode", fw.WORKSTAGE_NAME AS "fromWorkstageName",
              m.TO_WORKSTAGE_CODE AS "toWorkstageCode", tw.WORKSTAGE_NAME AS "toWorkstageName",
              m.ITEM_CODE AS "itemCode", item.ITEM_NAME AS "itemName", m.MOVE_QTY AS "moveQty",
              m.RUN_NO AS "runNo", m.LINE_CODE AS "lineCode", m.ENTER_BY AS "enterBy"
         FROM IM_ITEM_WS_MOVE m
         LEFT JOIN ID_ITEM item ON item.ITEM_CODE = m.ITEM_CODE AND item.ORGANIZATION_ID = m.ORGANIZATION_ID
         LEFT JOIN IP_PRODUCT_WORKSTAGE fw ON fw.WORKSTAGE_CODE = m.FROM_WORKSTAGE_CODE AND fw.ORGANIZATION_ID = m.ORGANIZATION_ID
         LEFT JOIN IP_PRODUCT_WORKSTAGE tw ON tw.WORKSTAGE_CODE = m.TO_WORKSTAGE_CODE AND tw.ORGANIZATION_ID = m.ORGANIZATION_ID
        WHERE m.ORGANIZATION_ID = :organizationId AND m.MOVE_DATE >= TRUNC(SYSDATE) - :days
        ORDER BY m.MOVE_DATE DESC
        FETCH FIRST 5000 ROWS ONLY`,
      namedBinds({ organizationId, days }),
    )) as OracleRow[];
  }

  private like(value?: string): string {
    const trimmed = value?.trim();
    return trimmed ? `${trimmed}%` : '%';
  }
}

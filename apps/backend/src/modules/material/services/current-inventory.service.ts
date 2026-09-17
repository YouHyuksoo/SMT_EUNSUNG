import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { CurrentInventoryQueryDto } from '../dto/current-inventory.dto';

type OracleRow = Record<string, unknown>;

@Injectable()
export class CurrentInventoryService {
  constructor(private readonly dataSource: DataSource) {}

  async find(query: CurrentInventoryQueryDto, organizationId: number) {
    const binds: Record<string, unknown> = {
      organizationId,
      itemCode: this.like(query.itemCode),
      locationCode: this.like(query.locationCode),
      lineType: this.like(query.lineType),
      inventoryStatus: this.like(query.inventoryStatus),
      inventoryHold: this.like(query.inventoryHold),
      includeZero: query.includeZero === 'Y' ? 'Y' : 'N',
    };
    const offset = (query.page - 1) * query.limit;
    const pageBinds = { ...binds, offset, limit: query.limit };

    const from = `
      FROM IM_ITEM_INVENTORY inv
      LEFT JOIN ID_ITEM item
        ON item.ITEM_CODE = inv.ITEM_CODE
       AND item.ORGANIZATION_ID = inv.ORGANIZATION_ID
      WHERE inv.ORGANIZATION_ID = :organizationId
        AND inv.ITEM_CODE LIKE :itemCode
        AND NVL(inv.LOCATION_CODE, '*') LIKE :locationCode
        AND NVL(inv.LINE_TYPE, '*') LIKE :lineType
        AND NVL(inv.INVENTORY_STATUS, '*') LIKE :inventoryStatus
        AND NVL(inv.INVENTORY_HOLD, '*') LIKE :inventoryHold
        AND (:includeZero = 'Y' OR SIGN(NVL(inv.INVENTORY_QTY, 0)) >= 1)
    `;

    const select = `
      SELECT inv.MATERIAL_MFS AS "materialMfs",
             inv.ITEM_CODE AS "itemCode",
             item.ITEM_NAME AS "itemName",
             item.ITEM_SPEC AS "itemSpec",
             item.ITEM_UOM AS "itemUom",
             item.ITEM_DIVISION AS "itemDivision",
             item.LOCATION_ADDRESS AS "locationAddress",
             inv.LINE_TYPE AS "lineType",
             inv.INVENTORY_STATUS AS "inventoryStatus",
             inv.INVENTORY_HOLD AS "inventoryHold",
             inv.INVENTORY_PRICE AS "inventoryPrice",
             inv.INVENTORY_QTY AS "inventoryQty",
             inv.INVENTORY_AMT AS "inventoryAmt",
             inv.LOCATION_CODE AS "locationCode",
             inv.COMMENTS AS "comments",
             inv.MANUFACTURE_WEEK AS "manufactureWeek",
             inv.LAST_RECEIPT_DATE AS "lastReceiptDate",
             inv.BAKING_DATE AS "bakingDate",
             inv.ENTER_DATE AS "enterDate",
             inv.ENTER_BY AS "enterBy",
             inv.LAST_MODIFY_DATE AS "lastModifyDate",
             inv.LAST_MODIFY_BY AS "lastModifyBy",
             inv.ORGANIZATION_ID AS "organizationId"
      ${from}
      ORDER BY inv.ORGANIZATION_ID, inv.LOCATION_CODE, inv.ITEM_CODE, inv.MATERIAL_MFS
      OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY
    `;
    const count = `SELECT COUNT(*) AS "total" ${from}`;
    const rows = await this.dataSource.query(select, pageBinds as unknown as unknown[]) as OracleRow[];
    const totals = await this.dataSource.query(count, binds as unknown as unknown[]) as OracleRow[];
    return {
      data: rows as OracleRow[],
      total: Number((totals as OracleRow[])[0]?.total ?? 0),
      page: query.page,
      limit: query.limit,
    };
  }

  private like(value?: string): string {
    const trimmed = value?.trim();
    return trimmed ? `${trimmed}%` : '%';
  }
}

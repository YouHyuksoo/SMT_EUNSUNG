import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { WorkstageInventoryQueryDto } from '../dto/workstage-inventory.dto';

type OracleRow = Record<string, unknown>;

@Injectable()
export class WorkstageInventoryService {
  constructor(private readonly dataSource: DataSource) {}

  async find(query: WorkstageInventoryQueryDto, organizationId: number) {
    const binds = {
      organizationId,
      itemCode: this.like(query.itemCode),
      includeZero: query.includeZero === 'N' ? 'N' : 'Y',
    };
    const offset = (query.page - 1) * query.limit;
    const from = `
      FROM IM_ITEM_WORKSTAGE_INVENTORY inv
      INNER JOIN ID_ITEM item
        ON item.ITEM_CODE = inv.ITEM_CODE
       AND item.ORGANIZATION_ID = inv.ORGANIZATION_ID
      WHERE inv.ORGANIZATION_ID = :organizationId
        AND inv.ITEM_CODE LIKE :itemCode
        AND (:includeZero = 'Y' OR NVL(inv.INVENTORY_QTY, 0) > 0)
    `;
    const select = `
      SELECT inv.ITEM_CODE AS "itemCode",
             item.ITEM_NAME AS "itemName",
             item.ITEM_SPEC AS "itemSpec",
             item.ITEM_UOM AS "itemUom",
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
      { ...binds, offset, limit: query.limit } as unknown as unknown[],
    ) as OracleRow[];
    const totals = await this.dataSource.query(count, { ...binds } as unknown as unknown[]) as OracleRow[];
    return {
      data: rows,
      total: Number(totals[0]?.total ?? 0),
      page: query.page,
      limit: query.limit,
    };
  }

  private like(value?: string): string {
    const trimmed = value?.trim();
    return trimmed ? `${trimmed}%` : '%';
  }
}

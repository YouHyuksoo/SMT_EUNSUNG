import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { ProductInventoryQueryDto } from '../dto/product-inventory.dto';

type OracleRow = Record<string, unknown>;

@Injectable()
export class ProductInventoryService {
  constructor(private readonly dataSource: DataSource) {}

  async find(query: ProductInventoryQueryDto, organizationId: number) {
    const binds: Record<string, unknown> = {
      organizationId,
      model: this.like(query.model),
      locationCode: this.like(query.locationCode),
      packType: this.like(query.packType),
    };
    const pageBinds = { ...binds, offset: (query.page - 1) * query.limit, limit: query.limit };
    const from = `
      FROM IP_PRODUCT_FG_INVENTORY inv
      WHERE inv.MODEL_NAME LIKE :model
        AND NVL(inv.LOCATION_CODE, '*') LIKE :locationCode
        AND NVL(inv.PACK_TYPE, '*') LIKE :packType
        AND inv.ORGANIZATION_ID = :organizationId
        AND inv.QTY > 0
    `;
    const select = `
      SELECT inv.INVENTORY_DATE AS "inventoryDate",
             ROUND(SYSDATE - inv.INVENTORY_DATE, 2) AS "invDay",
             inv.LOCATION_CODE AS "productLocationCode",
             inv.QTY AS "qty",
             inv.MODEL_NAME AS "modelName",
             inv.MODEL_SUFFIX AS "modelSuffix",
             inv.BARCODE AS "barcode",
             inv.PACK_TYPE AS "packType",
             inv.PALLET_NO AS "palletNo",
             inv.PALLET_DATE AS "palletDate",
             inv.ORGANIZATION_ID AS "organizationId"
      ${from}
      ORDER BY inv.INVENTORY_DATE, inv.MODEL_NAME
      OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY
    `;
    const count = `SELECT COUNT(*) AS "total", NVL(SUM(inv.QTY), 0) AS "qtyTotal" ${from}`;
    const rows = await this.dataSource.query(select, pageBinds as unknown as unknown[]) as OracleRow[];
    const totals = await this.dataSource.query(count, binds as unknown as unknown[]) as OracleRow[];
    return {
      data: rows,
      total: Number(totals[0]?.total ?? 0),
      qtyTotal: Number(totals[0]?.qtyTotal ?? 0),
      page: query.page,
      limit: query.limit,
    };
  }

  private like(value?: string): string {
    const trimmed = value?.trim();
    return trimmed ? `${trimmed}%` : '%';
  }
}

import { DataSource } from 'typeorm';
import { WorkstageInventoryService } from './workstage-inventory.service';

describe('WorkstageInventoryService', () => {
  const query = jest.fn();
  const service = new WorkstageInventoryService({ query } as unknown as DataSource);

  beforeEach(() => query.mockReset());

  it('queries the PB workstage inventory source by organization and item prefix', async () => {
    query.mockResolvedValueOnce([{ itemCode: 'A100', inventoryQty: 3 }]).mockResolvedValueOnce([{ total: 1 }]);

    const result = await service.find({ itemCode: 'A1', includeZero: 'Y', page: 1, limit: 500 }, 7);

    expect(query.mock.calls[0][0]).toContain('IM_ITEM_WORKSTAGE_INVENTORY');
    expect(query.mock.calls[0][0]).toContain('ID_ITEM');
    expect(query.mock.calls[0][1]).toMatchObject({ organizationId: 7, itemCode: 'A1%' });
    expect(result).toMatchObject({ data: [{ itemCode: 'A100', inventoryQty: 3 }], total: 1 });
  });

  it('excludes zero inventory when the PB positive-quantity filter is selected', async () => {
    query.mockResolvedValue([]);

    await service.find({ includeZero: 'N', page: 1, limit: 500 }, 7);

    expect(query.mock.calls[0][0]).toContain("(:includeZero = 'Y' OR NVL(inv.INVENTORY_QTY, 0) > 0)");
    expect(query.mock.calls[0][1]).toMatchObject({ includeZero: 'N' });
  });

  it('filters by item division, class and supplier and returns supplier name', async () => {
    query.mockResolvedValue([]);

    await service.find({ itemDivision: 'R', itemClass: 'IC', supplierCode: ' IP ', includeZero: 'Y', page: 1, limit: 500 }, 7);

    expect(query.mock.calls[0][0]).toContain('ICOM_SUPPLIER');
    expect(query.mock.calls[0][0]).toContain('(:itemDivision IS NULL OR item.ITEM_DIVISION = :itemDivision)');
    expect(query.mock.calls[0][0]).toContain('(:itemClass IS NULL OR item.ITEM_CLASS = :itemClass)');
    expect(query.mock.calls[0][0]).toContain('(:supplierCode IS NULL OR item.SUPPLIER_CODE = :supplierCode)');
    expect(query.mock.calls[0][1]).toMatchObject({ itemDivision: 'R', itemClass: 'IC', supplierCode: 'IP' });
  });

  it('passes null for unselected optional filters', async () => {
    query.mockResolvedValue([]);

    await service.find({ includeZero: 'Y', page: 1, limit: 500 }, 7);

    expect(query.mock.calls[0][1]).toMatchObject({ itemDivision: null, itemClass: null, supplierCode: null });
  });

  it('lists unreceived, unshipped boxes packed since the full-consume date as in-process products', async () => {
    query.mockResolvedValueOnce([{ modelName: 'M1', boxCount: 2, packQty: 64 }]);

    const rows = await service.findProducts(7);

    const sql = query.mock.calls[0][0] as string;
    expect(sql).toContain('IP_PRODUCT_PACK_MASTER');
    expect(sql).toContain("NVL(p.RECEIPT_FLAG, 'N') = 'N'");
    expect(sql).toContain("NVL(p.SHIP_FLAG, 'N') = 'N'");
    expect(sql).toContain("p.PACK_DATE >= DATE '2026-10-01'");
    expect(query.mock.calls[0][1]).toMatchObject({ organizationId: 7 });
    expect(rows).toEqual([{ modelName: 'M1', boxCount: 2, packQty: 64 }]);
  });
});

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
});

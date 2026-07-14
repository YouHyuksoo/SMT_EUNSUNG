import { BadRequestException } from '@nestjs/common';
import { GUARDS_METADATA } from '@nestjs/common/constants';
import { PurchasePriceController } from './purchase-price.controller';
import { PurchasePriceService } from '../services/purchase-price.service';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';

describe('PurchasePriceController', () => {
  const service = {
    findAll: jest.fn(),
    getImpact: jest.fn(),
    findSuppliers: jest.fn(),
    create: jest.fn(),
    update: jest.fn(),
  };
  let target: PurchasePriceController;

  beforeEach(() => {
    jest.clearAllMocks();
    target = new PurchasePriceController(service as unknown as PurchasePriceService);
  });

  it('requires JwtAuthGuard so OrganizationId is populated', () => {
    const guards = Reflect.getMetadata(GUARDS_METADATA, PurchasePriceController) ?? [];
    expect(guards).toContain(JwtAuthGuard);
  });

  it('forwards the server organization id to every read endpoint', async () => {
    service.findAll.mockResolvedValue({ data: [], total: 0, page: 1, limit: 50 });
    service.getImpact.mockResolvedValue({ closingRows: [], affectedRows: 0, affectedAmount: 0 });
    service.findSuppliers.mockResolvedValue([]);

    await target.findAll({ page: 1, limit: 50 }, 40);
    await target.getImpact({ mode: 'create', itemCode: 'A', supplierCode: 'S', lineType: 'G', dateset: '2026-07-12' }, 40);
    await target.findSuppliers({ limit: 200 }, 40);

    expect(service.findAll).toHaveBeenCalledWith(expect.any(Object), 40);
    expect(service.getImpact).toHaveBeenCalledWith(expect.any(Object), 40);
    expect(service.findSuppliers).toHaveBeenCalledWith(expect.any(Object), 40);
  });

  it('forwards the server organization id to create and update', async () => {
    service.create.mockResolvedValue({});
    service.update.mockResolvedValue({});
    const createDto = { itemCode: 'A' } as never;
    const updateDto = { itemCode: 'A' } as never;

    await target.create(createDto, 40);
    await target.update(updateDto, 40);

    expect(service.create).toHaveBeenCalledWith(createDto, 40);
    expect(service.update).toHaveBeenCalledWith(updateDto, 40);
  });

  it('does not replace an Oracle error message', async () => {
    service.create.mockRejectedValue(new BadRequestException('ORA-20003: trigger failed'));

    await expect(target.create({} as never, 40)).rejects.toThrow('ORA-20003: trigger failed');
  });
});

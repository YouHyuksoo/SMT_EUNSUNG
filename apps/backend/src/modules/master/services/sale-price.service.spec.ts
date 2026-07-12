import { getRepositoryToken } from '@nestjs/typeorm';
import { Test } from '@nestjs/testing';
import { DataSource, Repository } from 'typeorm';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { ProductSalePrice } from '../../../entities/product-sale-price.entity';
import { SalePriceService } from './sale-price.service';

describe('SalePriceService', () => {
  let target: SalePriceService;
  let repository: DeepMocked<Repository<ProductSalePrice>>;
  let dataSource: DeepMocked<DataSource>;

  beforeEach(async () => {
    repository = createMock<Repository<ProductSalePrice>>();
    dataSource = createMock<DataSource>();
    const module = await Test.createTestingModule({ providers: [
      SalePriceService,
      { provide: getRepositoryToken(ProductSalePrice), useValue: repository },
      { provide: DataSource, useValue: dataSource },
    ] }).compile();
    target = module.get(SalePriceService);
  });

  it('keeps server organization id across count and list queries', async () => {
    dataSource.query.mockImplementationOnce(async (_sql, parameters) => {
      delete (parameters as unknown as Record<string, unknown>).organizationId;
      return [{ total: 1 }];
    });
    dataSource.query.mockResolvedValueOnce([{ itemCode: 'A100' }]);

    const result = await target.findAll({ page: 1, limit: 5 }, 1);

    expect(result.total).toBe(1);
    expect(dataSource.query).toHaveBeenNthCalledWith(2, expect.any(String), expect.objectContaining({ organizationId: 1 }));
  });

  it('returns closing rows for create impact but not update impact', async () => {
    dataSource.query.mockResolvedValueOnce([{ dateset: new Date(), salePrice: 100 }]);
    const create = await target.getImpact({ mode: 'create', customerCode: 'IP', itemCode: 'A', productLineType: 'T', dateset: '2026-07-12' }, 1);
    const update = await target.getImpact({ mode: 'update', customerCode: 'IP', itemCode: 'A', productLineType: 'T', dateset: '2026-07-12' }, 1);
    expect(create.closingRows).toHaveLength(1);
    expect(update.closingRows).toEqual([]);
    expect(dataSource.query).toHaveBeenCalledTimes(1);
  });

  it('uses the server organization id when creating one row', async () => {
    repository.create.mockReturnValue({ organizationId: 1 } as ProductSalePrice);
    repository.save.mockResolvedValue({ organizationId: 1 } as ProductSalePrice);
    await target.create({ customerCode: 'IP', itemCode: 'A', productLineType: 'T', dateset: '2026-07-12', dateend: '2999-12-31', salePrice: 100, saleCurrency: 'KRW' } as never, 1);
    expect(repository.create).toHaveBeenCalledWith(expect.objectContaining({ organizationId: 1 }));
    expect(repository.save).toHaveBeenCalledTimes(1);
  });
});

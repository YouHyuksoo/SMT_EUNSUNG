import { BadRequestException } from '@nestjs/common';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Test } from '@nestjs/testing';
import { DataSource, Repository } from 'typeorm';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { PurchaseUnitPrice } from '../../../entities/purchase-unit-price.entity';
import { PurchasePriceService } from './purchase-price.service';

describe('PurchasePriceService', () => {
  let target: PurchasePriceService;
  let repository: DeepMocked<Repository<PurchaseUnitPrice>>;
  let dataSource: DeepMocked<DataSource>;

  beforeEach(async () => {
    repository = createMock<Repository<PurchaseUnitPrice>>();
    dataSource = createMock<DataSource>();
    const module = await Test.createTestingModule({
      providers: [
        PurchasePriceService,
        { provide: getRepositoryToken(PurchaseUnitPrice), useValue: repository },
        { provide: DataSource, useValue: dataSource },
      ],
    }).compile();
    target = module.get(PurchasePriceService);
  });

  it('scopes list queries to the server organization id', async () => {
    dataSource.query
      .mockResolvedValueOnce([{ TOTAL: 1 }])
      .mockResolvedValueOnce([{ ITEM_CODE: 'A100', UNIT_PRICE: 1200 }]);

    const result = await target.findAll({ page: 1, limit: 50, itemCode: 'A100' }, 40);

    expect(result.total).toBe(1);
    expect(dataSource.query).toHaveBeenNthCalledWith(
      1,
      expect.stringContaining('p.ORGANIZATION_ID = :organizationId'),
      expect.objectContaining({ organizationId: 40, itemCode: 'A100' }),
    );
    expect(dataSource.query).toHaveBeenNthCalledWith(
      2,
      expect.any(String),
      expect.objectContaining({ organizationId: 40 }),
    );
  });

  it('does not reuse a bind object mutated by the Oracle driver', async () => {
    dataSource.query.mockImplementationOnce(async (_sql, parameters) => {
      delete (parameters as unknown as Record<string, unknown>).organizationId;
      return [{ total: 1 }];
    });
    dataSource.query.mockResolvedValueOnce([{ itemCode: 'A100' }]);

    const result = await target.findAll({ page: 1, limit: 5 }, 1);

    expect(result.data).toHaveLength(1);
    expect(dataSource.query).toHaveBeenNthCalledWith(
      2,
      expect.any(String),
      expect.objectContaining({ organizationId: 1, offset: 0, limit: 5 }),
    );
  });

  it('returns closing rows only for create impact and always scopes receipt impact', async () => {
    dataSource.query
      .mockResolvedValueOnce([{ DATESET: new Date('2026-01-01'), DATEEND: new Date('9999-12-31') }])
      .mockResolvedValueOnce([{ AFFECTED_ROWS: 2, AFFECTED_AMT: 3000 }]);

    const result = await target.getImpact({
      mode: 'create', itemCode: 'A100', supplierCode: 'S01', lineType: 'G', dateset: '2026-07-12',
    }, 40);

    expect(result.closingRows).toHaveLength(1);
    expect(dataSource.query).toHaveBeenNthCalledWith(
      1,
      expect.stringContaining('IM_ITEM_UNIT_PRICE'),
      expect.objectContaining({ organizationId: 40 }),
    );
    expect(dataSource.query).toHaveBeenNthCalledWith(
      2,
      expect.stringContaining('IM_ITEM_RECEIPT'),
      expect.objectContaining({ organizationId: 40 }),
    );
  });

  it('does not report closing rows for update impact', async () => {
    dataSource.query.mockResolvedValueOnce([{ AFFECTED_ROWS: 1, AFFECTED_AMT: 900 }]);

    const result = await target.getImpact({
      mode: 'update', itemCode: 'A100', supplierCode: 'S01', lineType: 'G', dateset: '2026-07-12',
    }, 40);

    expect(result.closingRows).toEqual([]);
    expect(dataSource.query).toHaveBeenCalledTimes(1);
    expect(dataSource.query).toHaveBeenCalledWith(
      expect.stringContaining('IM_ITEM_RECEIPT'),
      expect.objectContaining({ organizationId: 40 }),
    );
  });

  it('creates one row using only the server organization id', async () => {
    const created = { itemCode: 'A100', organizationId: 40 } as PurchaseUnitPrice;
    repository.create.mockReturnValue(created);
    repository.save.mockResolvedValue(created);

    await target.create({
      dateset: '2026-07-12', itemCode: 'A100', supplierCode: 'S01', lineType: 'G',
      dateend: '9999-12-31', unitPrice: 1200, currency: 'KRW', delivery: '2',
      priceType: 'F', priceChangeReason: 'N', organizationId: 999,
    } as never, 40, 'tester');

    expect(repository.create).toHaveBeenCalledWith(expect.objectContaining({ organizationId: 40 }));
    expect(repository.create).not.toHaveBeenCalledWith(expect.objectContaining({ organizationId: 999 }));
    expect(repository.save).toHaveBeenCalledTimes(1);
  });

  it('updates by the original composite key and server organization id', async () => {
    repository.update.mockResolvedValue({ affected: 1, generatedMaps: [], raw: {} });
    repository.findOneBy.mockResolvedValue({ itemCode: 'A100', organizationId: 40 } as PurchaseUnitPrice);

    await target.update({
      originalDateset: '2026-01-01', itemCode: 'A100', supplierCode: 'S01', lineType: 'G',
      dateset: '2026-01-01', dateend: '9999-12-31', unitPrice: 1300, currency: 'KRW',
      delivery: '2', priceType: 'F', priceChangeReason: 'I', organizationId: 999,
    } as never, 40, 'tester');

    expect(repository.update).toHaveBeenCalledWith(
      expect.objectContaining({ organizationId: 40, dateset: new Date('2026-01-01') }),
      expect.not.objectContaining({ organizationId: expect.anything() }),
    );
  });

  it('preserves nested Oracle error text', async () => {
    repository.save.mockRejectedValue({
      message: 'QueryFailedError: Database query failed',
      driverError: { message: 'ORA-20003: ORA-02291: integrity constraint violated' },
    });

    await expect(target.create({
      dateset: '2026-07-12', itemCode: 'BAD', supplierCode: 'S01', lineType: 'G',
      dateend: '9999-12-31', unitPrice: 1, currency: 'KRW', delivery: '2',
      priceType: 'F', priceChangeReason: 'N',
    } as never, 40, 'tester')).rejects.toEqual(
      expect.objectContaining<Partial<BadRequestException>>({ message: 'ORA-20003: ORA-02291: integrity constraint violated' }),
    );
  });
});

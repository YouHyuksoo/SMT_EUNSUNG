import 'reflect-metadata';
import { GUARDS_METADATA } from '@nestjs/common/constants';
import { PlantController } from './plant.controller';
import { PlantService } from '../services/plant.service';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { IS_PUBLIC_KEY } from '../../../common/decorators/public.decorator';

describe('PlantController', () => {
  const service = {
    findAll: jest.fn(),
    findHierarchy: jest.fn(),
    findByType: jest.fn(),
    findById: jest.fn(),
    create: jest.fn(),
    update: jest.fn(),
    delete: jest.fn(),
  };
  let target: PlantController;

  const tenant = { company: 'EUNSUNG', plantCd: '1' };
  const key = ['EUNSUNG', '2F', 'PROD2', '50'] as const;

  beforeEach(() => {
    jest.clearAllMocks();
    target = new PlantController(service as unknown as PlantService);
  });

  it('requires JwtAuthGuard and is not public', () => {
    expect(Reflect.getMetadata(IS_PUBLIC_KEY, PlantController)).toBeFalsy();
    expect(Reflect.getMetadata(GUARDS_METADATA, PlantController) ?? []).toContain(JwtAuthGuard);
  });

  it('passes authenticated company and plant to every endpoint', async () => {
    service.findAll.mockResolvedValue({ data: [], total: 0, page: 1, limit: 10 });
    service.findHierarchy.mockResolvedValue([]);
    service.findByType.mockResolvedValue([]);
    service.findById.mockResolvedValue({});
    service.create.mockResolvedValue({});
    service.update.mockResolvedValue({});
    service.delete.mockResolvedValue({});

    const dto = { plantCode: key[0], shopCode: key[1], lineCode: key[2], cellCode: key[3], plantName: 'CMA' } as never;
    const updateDto = { plantName: 'CMA updated' } as never;

    await target.findHierarchy('EUNSUNG', tenant.company, tenant.plantCd);
    await target.findByType('CELL', tenant.company, tenant.plantCd);
    await target.findAll({ page: 1, limit: 10 } as never, tenant.company, tenant.plantCd);
    await target.findById(...key, tenant.company, tenant.plantCd);
    await target.create(dto, tenant.company, tenant.plantCd);
    await target.update(...key, updateDto, tenant.company, tenant.plantCd);
    await target.delete(...key, tenant.company, tenant.plantCd);

    expect(service.findHierarchy).toHaveBeenCalledWith('EUNSUNG', tenant.company, tenant.plantCd);
    expect(service.findByType).toHaveBeenCalledWith('CELL', tenant.company, tenant.plantCd);
    expect(service.findAll).toHaveBeenCalledWith(expect.any(Object), tenant.company, tenant.plantCd);
    expect(service.findById).toHaveBeenCalledWith(...key, tenant.company, tenant.plantCd);
    expect(service.create).toHaveBeenCalledWith(dto, tenant.company, tenant.plantCd);
    expect(service.update).toHaveBeenCalledWith(
      key[0],
      updateDto,
      key[1],
      key[2],
      key[3],
      tenant.company,
      tenant.plantCd,
    );
    expect(service.delete).toHaveBeenCalledWith(...key, tenant.company, tenant.plantCd);
  });
});

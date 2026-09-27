import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository, DataSource, getMetadataArgsStorage } from 'typeorm';
import { ConflictException, BadRequestException, NotFoundException } from '@nestjs/common';
import { MenuCategory } from '../../../entities/menu-category.entity';
import { MenuCategoryItem } from '../../../entities/menu-category-item.entity';
import { MenuCategoriesService } from './menu-categories.service';
import { TransactionService } from '../../../shared/transaction.service';
import { DEFAULT_MENU_CATEGORY_LAYOUT } from '../utils/default-menu-category-layout';

/**
 * 이 스펙의 픅스처는 기본 레이아웃 상수에서 **파생시킨다.**
 *
 * 카테고리 코드를 손으로 나열해 두면 대분류를 하나 추가할 때마다 이 스펙이 깨진다
 * (실제로 지그·피더·몰드·추적·조회·리포트를 넣는 동안 계속 깨져 있었다).
 * 검사하려는 것은 '없는 것만 채우고 있는 것은 건드리지 않는다' 이므로,
 * 몇 개가 있는지는 상수에서 읽어 오면 된다.
 */
const allCategoryCodes = DEFAULT_MENU_CATEGORY_LAYOUT.map((c) => c.categoryCode);
const allMenuCodes = DEFAULT_MENU_CATEGORY_LAYOUT.flatMap((c) => [...c.menuCodes]);
const seedCategories = (organizationId: number, except: string[] = []) =>
  allCategoryCodes
    .filter((categoryCode) => !except.includes(categoryCode))
    .map((categoryCode) => ({ organizationId, categoryCode }));

describe('MenuCategoriesService', () => {
  let service: MenuCategoriesService;
  let categoryRepo: jest.Mocked<Repository<MenuCategory>>;
  let itemRepo: jest.Mocked<Repository<MenuCategoryItem>>;
  let dataSource: jest.Mocked<DataSource>;
  let tx: jest.Mocked<TransactionService>;

  beforeEach(async () => {
    categoryRepo = {
      find: jest.fn(),
      findOne: jest.fn(),
      save: jest.fn(),
      delete: jest.fn(),
      update: jest.fn(),
      count: jest.fn(),
      create: jest.fn((x: any) => x),
    } as unknown as jest.Mocked<Repository<MenuCategory>>;

    itemRepo = {
      find: jest.fn(),
      count: jest.fn(),
      save: jest.fn(),
    } as unknown as jest.Mocked<Repository<MenuCategoryItem>>;

    dataSource = {
      transaction: jest.fn(async (cb: any) => cb({ getRepository: () => categoryRepo })),
    } as unknown as jest.Mocked<DataSource>;
    tx = {
      run: jest.fn(async (cb: any) => cb({ manager: { getRepository: () => categoryRepo } })),
    } as unknown as jest.Mocked<TransactionService>;

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MenuCategoriesService,
        { provide: getRepositoryToken(MenuCategory), useValue: categoryRepo },
        { provide: getRepositoryToken(MenuCategoryItem), useValue: itemRepo },
        { provide: DataSource, useValue: dataSource },
        { provide: TransactionService, useValue: tx },
      ],
    }).compile();

    service = module.get<MenuCategoriesService>(MenuCategoriesService);
  });

  describe('create', () => {
    it('유효한 카테고리를 생성한다', async () => {
      categoryRepo.findOne.mockResolvedValueOnce(null);
      categoryRepo.save.mockImplementation(async (e: any) => e);

      const result = await service.create(
        { code: 'NEW_CAT', labelKey: 'menu.newCat' },
        { organizationId: 1, userId: 'tester' },
      );
      expect(result.categoryCode).toBe('NEW_CAT');
      expect(categoryRepo.save).toHaveBeenCalled();
    });

    it('checks duplicate category codes within tenant scope', async () => {
      categoryRepo.findOne.mockResolvedValueOnce(null);
      categoryRepo.save.mockImplementation(async (e: any) => e);

      await service.create(
        { code: 'NEW_CAT', labelKey: 'menu.newCat' },
        { organizationId: 1, userId: 'tester' },
      );

      expect(categoryRepo.findOne).toHaveBeenCalledWith({
        where: { categoryCode: 'NEW_CAT', organizationId: 1 },
      });
    });

    it('예약어 __ROOT__ 생성 시 BadRequest', async () => {
      await expect(
        service.create(
          { code: '__ROOT__', labelKey: 'x' } as any,
          { organizationId: 1, userId: 'tester' },
        ),
      ).rejects.toBeInstanceOf(BadRequestException);
    });

    it('중복 코드 생성 시 Conflict', async () => {
      categoryRepo.findOne.mockResolvedValueOnce({ categoryCode: 'X' } as any);
      await expect(
        service.create(
          { code: 'X', labelKey: 'x' },
          { organizationId: 1, userId: 'tester' },
        ),
      ).rejects.toBeInstanceOf(ConflictException);
    });
  });

  describe('delete', () => {
    it('비어있는 카테고리는 삭제된다', async () => {
      categoryRepo.findOne.mockResolvedValueOnce({ categoryCode: 'X' } as any);
      itemRepo.count.mockResolvedValueOnce(0);
      categoryRepo.delete.mockResolvedValueOnce({} as any);

      await service.delete('X');
      expect(categoryRepo.delete).toHaveBeenCalledWith({ categoryCode: 'X' });
    });

    it('자식 메뉴가 있으면 Conflict 한국어 메시지', async () => {
      categoryRepo.findOne.mockResolvedValueOnce({ categoryCode: 'X' } as any);
      itemRepo.count.mockResolvedValueOnce(3);

      await expect(service.delete('X')).rejects.toThrow(
        '카테고리에 메뉴가 3개 있습니다. 먼저 다른 카테고리로 이동하거나 삭제해주세요',
      );
    });

    it('__ROOT__는 삭제 차단', async () => {
      await expect(service.delete('__ROOT__')).rejects.toBeInstanceOf(BadRequestException);
    });

    it('존재하지 않으면 NotFound', async () => {
      categoryRepo.findOne.mockResolvedValueOnce(null);
      await expect(service.delete('X')).rejects.toBeInstanceOf(NotFoundException);
    });
  });

  describe('tenant keys', () => {
    it('includes organizationId in MenuCategory primary key metadata', () => {
      const primaryColumnNames = getMetadataArgsStorage()
        .columns
        .filter(column => column.target === MenuCategory && column.options.primary)
        .map(column => column.propertyName);

      expect(primaryColumnNames).toEqual(expect.arrayContaining(['organizationId', 'categoryCode']));
    });
  });

  describe('ensureDefaultLayout', () => {
    it('seeds default categories and menu placements for an empty tenant', async () => {
      categoryRepo.find.mockResolvedValueOnce([]);
      itemRepo.find.mockResolvedValueOnce([]);
      categoryRepo.save.mockImplementation(async (e: any) => e);
      itemRepo.save.mockImplementation(async (e: any) => e);
      tx.run.mockImplementationOnce(async (cb: any) =>
        cb({
          manager: {
            getRepository: (entity: unknown) => (entity === MenuCategory ? categoryRepo : itemRepo),
          },
        }),
      );

      await service.ensureDefaultLayout({ organizationId: 7, userId: 'tester' });

      expect(categoryRepo.save).toHaveBeenCalledWith(
        expect.arrayContaining([
          expect.objectContaining({ organizationId: 7, categoryCode: 'MASTER' }),
          expect.objectContaining({ organizationId: 7, categoryCode: 'PROCESS_TRANSACTION' }),
          expect.objectContaining({ organizationId: 7, categoryCode: 'PRODUCT_MGMT' }),
          expect.objectContaining({ organizationId: 7, categoryCode: 'OUTSOURCING' }),
        ]),
      );
      expect(itemRepo.save).toHaveBeenCalledWith(
        expect.arrayContaining([
          expect.objectContaining({ organizationId: 7, menuCode: 'SYS_COMPANY', categoryCode: 'SYSTEM' }),
          expect.objectContaining({ organizationId: 7, menuCode: 'OEE_DASHBOARD', categoryCode: 'OEE' }),
          expect.objectContaining({ organizationId: 7, menuCode: 'SYS_CODE', categoryCode: 'SYSTEM' }),
          expect.objectContaining({ organizationId: 7, menuCode: 'SYS_SCHEDULER', categoryCode: 'SYSTEM' }),
        ]),
      );
    });

    it('adds missing default categories without overwriting an already configured tenant layout', async () => {
      categoryRepo.find.mockResolvedValueOnce(
        seedCategories(7, ['PROCESS_TRANSACTION', 'PRODUCTION']) as any,
      );
      itemRepo.find.mockResolvedValueOnce([]);
      categoryRepo.save.mockImplementation(async (e: any) => e);
      itemRepo.save.mockImplementation(async (e: any) => e);
      tx.run.mockImplementationOnce(async (cb: any) =>
        cb({
          manager: {
            getRepository: (entity: unknown) => (entity === MenuCategory ? categoryRepo : itemRepo),
          },
        }),
      );

      await service.ensureDefaultLayout({ organizationId: 7, userId: 'tester' });

      expect(categoryRepo.save).toHaveBeenCalledWith([
        expect.objectContaining({ organizationId: 7, categoryCode: 'PROCESS_TRANSACTION' }),
        expect.objectContaining({ organizationId: 7, categoryCode: 'PRODUCTION' }),
      ]);
    });

    it('uses the new OEE_MULTI_ENTRY menu layout position when it is missing', async () => {
      categoryRepo.find.mockResolvedValue([
        { organizationId: 7, categoryCode: 'MASTER' },
        { organizationId: 7, categoryCode: 'OEE' },
        { organizationId: 7, categoryCode: 'MATERIAL' },
        { organizationId: 7, categoryCode: 'PROCESS_TRANSACTION' },
        { organizationId: 7, categoryCode: 'PRODUCT_MGMT' },
        { organizationId: 7, categoryCode: 'PRODUCTION' },
        { organizationId: 7, categoryCode: 'OUTSOURCING' },
        { organizationId: 7, categoryCode: 'SYSTEM' },
      ] as any);
      itemRepo.find.mockResolvedValue([
        { menuCode: 'OEE_DASHBOARD' },
      ] as any);
      itemRepo.save.mockImplementation(async (e: any) => e);
      tx.run.mockImplementationOnce(async (cb: any) =>
        cb({
          manager: {
            getRepository: (entity: unknown) => (entity === MenuCategory ? categoryRepo : itemRepo),
          },
        }),
      );

      await service.ensureDefaultLayout({ organizationId: 7, userId: 'tester' });

      expect(itemRepo.save).toHaveBeenCalledWith(
        expect.arrayContaining([
          expect.objectContaining({ menuCode: 'OEE_MULTI_ENTRY', categoryCode: 'OEE', sortOrder: 20 }),
        ]),
      );
    });

    it('does not rewrite a fully configured tenant layout', async () => {
      categoryRepo.find.mockResolvedValueOnce(seedCategories(7) as any);
      itemRepo.find.mockResolvedValueOnce(
        allMenuCodes.map((menuCode) => ({ menuCode })) as any,
      );

      await service.ensureDefaultLayout({ organizationId: 7, userId: 'tester' });

      expect(tx.run).not.toHaveBeenCalled();
    });
  });

  describe('reorder', () => {
    it('카테고리 순서 일괄 갱신', async () => {
      categoryRepo.update.mockResolvedValue({} as any);
      await service.reorder({ items: [{ code: 'A', sortOrder: 10 }, { code: 'B', sortOrder: 20 }] });
      expect(tx.run).toHaveBeenCalled();
    });
  });
});

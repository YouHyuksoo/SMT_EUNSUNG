/**
 * @file src/modules/master/services/bom.service.spec.ts
 * @description BomService 단위 테스트 - BOM CRUD, 계층 조회, 자기참조 방지 검증
 *
 * 초보자 가이드:
 * - target: 테스트 대상(SUT), mock*: 모킹된 의존성
 * - 실행: `pnpm test -- -t "BomService"`
 */
import { Test, TestingModule } from '@nestjs/testing';
import { createMock, DeepMocked } from '@golevelup/ts-jest';
import { getRepositoryToken } from '@nestjs/typeorm';
import { NotFoundException, ConflictException } from '@nestjs/common';
import { validate } from 'class-validator';
import { Repository } from 'typeorm';
import * as XLSX from 'xlsx';
import { BomService } from './bom.service';
import { CreateBomDto } from '../dto/bom.dto';
import { BomMaster } from '../../../entities/bom-master.entity';
import { ItemMaster } from '../../../entities/item-master.entity';
import { MockLoggerService } from '@test/mock-logger.service';

describe('BomService', () => {
  let target: BomService;
  let mockBomRepo: DeepMocked<Repository<BomMaster>>;
  let mockPartRepo: DeepMocked<Repository<ItemMaster>>;

  beforeEach(async () => {
    mockBomRepo = createMock<Repository<BomMaster>>();
    mockPartRepo = createMock<Repository<ItemMaster>>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BomService,
        { provide: getRepositoryToken(BomMaster), useValue: mockBomRepo },
        { provide: getRepositoryToken(ItemMaster), useValue: mockPartRepo },
      ],
    })
      .setLogger(new MockLoggerService())
      .compile();

    target = module.get<BomService>(BomService);
  });

  describe('CreateBomDto validation', () => {
    it('should require validFrom and validTo when creating BOM rows', async () => {
      const dto = Object.assign(new CreateBomDto(), {
        parentItemCode: 'P01',
        childItemCode: 'C01',
        qtyPer: 1,
      });

      const errors = await validate(dto);
      const properties = errors.map((error) => error.property);

      expect(properties).toContain('validFrom');
      expect(properties).toContain('validTo');
    });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  // ─── findById ───
  describe('findById', () => {
    it('should return bom with part info when found', async () => {
      // Arrange
      const bom = { parentItemCode: 'P01', childItemCode: 'C01', revision: 'A' } as BomMaster;
      mockBomRepo.findOne.mockResolvedValue(bom);
      mockPartRepo.find.mockResolvedValue([
        { itemCode: 'P01', itemName: 'Parent' } as ItemMaster,
        { itemCode: 'C01', itemName: 'Child' } as ItemMaster,
      ]);

      // Act
      const result = await target.findById('P01::C01::A');

      // Assert
      expect(result.parentItemCode).toBe('P01');
      expect(result.parentPart).toEqual({ itemCode: 'P01', itemName: 'Parent' });
      expect(result.childPart).toEqual({ itemCode: 'C01', itemName: 'Child' });
    });

    it('should throw NotFoundException when bom not found', async () => {
      // Arrange
      mockBomRepo.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(target.findById('P01::C01::A')).rejects.toThrow(NotFoundException);
    });

    it('should omit validFrom condition when key has no date part', async () => {
      // Arrange
      mockBomRepo.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(target.findById('P01::C01')).rejects.toThrow(NotFoundException);
      expect(mockBomRepo.findOne).toHaveBeenCalledWith({
        where: { parentItemCode: 'P01', childItemCode: 'C01' },
      });
    });
  });

  // ─── findAll ───
  describe('findAll', () => {
    it('should return empty data when no boms found', async () => {
      // Arrange
      mockBomRepo.findAndCount.mockResolvedValue([[], 0]);

      // Act
      const result = await target.findAll({ page: 1, limit: 10 } as any);

      // Assert
      expect(result).toEqual({ data: [], total: 0, page: 1, limit: 10 });
    });

    it('should enrich bom items with part info', async () => {
      // Arrange
      const boms = [{ parentItemCode: 'P01', childItemCode: 'C01' }] as BomMaster[];
      mockBomRepo.findAndCount.mockResolvedValue([boms, 1]);
      mockPartRepo.find.mockResolvedValue([
        { itemCode: 'P01', itemName: 'Parent' } as ItemMaster,
        { itemCode: 'C01', itemName: 'Child' } as ItemMaster,
      ]);

      // Act
      const result = await target.findAll({ page: 1, limit: 10 } as any);

      // Assert
      expect(result.data[0].parentPart).toEqual({ itemCode: 'P01', itemName: 'Parent' });
      expect(result.data[0].childPart).toEqual({ itemCode: 'C01', itemName: 'Child' });
    });

    it('should enrich bom items using part info within tenant only', async () => {
      const boms = [{ parentItemCode: 'P01', childItemCode: 'C01' }] as BomMaster[];
      mockBomRepo.findAndCount.mockResolvedValue([boms, 1]);
      mockPartRepo.find.mockResolvedValue([]);

      await target.findAll({ page: 1, limit: 10 } as any, 1);

      expect(mockPartRepo.find).toHaveBeenCalledWith({
        // 은성 ID_ITEM 기준 컬럼(itemClass/itemUom)으로 조회 — HANES 의 productType/unit 은 없다
        where: { itemCode: expect.anything(), organizationId: 1 },
        select: ['itemCode', 'itemName', 'itemNo', 'itemType', 'itemClass', 'spec', 'itemUom'],
      });
    });
  });

  // ─── create ───
  describe('create', () => {
    it('should throw ConflictException when parent equals child', async () => {
      // Arrange
      const dto = { parentItemCode: 'P01', childItemCode: 'P01' } as any;

      // Act & Assert
      await expect(target.create(dto)).rejects.toThrow(ConflictException);
    });

    it('should throw ConflictException when validFrom is missing', async () => {
      // Arrange — 적용일자는 PK라 필수
      const dto = { parentItemCode: 'P01', childItemCode: 'C01', qtyPer: 1 } as any;

      // Act & Assert
      await expect(target.create(dto)).rejects.toThrow(ConflictException);
    });

    it('should throw ConflictException when same parent+child+validFrom exists (revision과 무관)', async () => {
      // Arrange
      const dto = { parentItemCode: 'P01', childItemCode: 'C01', revision: 'B', validFrom: '2026-01-01' } as any;
      mockBomRepo.find.mockResolvedValue([{ revision: 'A', validFrom: '2026-01-01' } as unknown as BomMaster]);

      // Act & Assert
      await expect(target.create(dto)).rejects.toThrow(ConflictException);
    });

    it('should allow same revision when validFrom differs (적용일자 버전 관리)', async () => {
      // Arrange
      const dto = { parentItemCode: 'P01', childItemCode: 'C01', qtyPer: 2, revision: 'A', validFrom: '2026-02-01', validTo: '2099-12-31' } as any;
      const created = { ...dto, useYn: 'Y' } as BomMaster;
      mockBomRepo.find
        .mockResolvedValueOnce([{ revision: 'A', validFrom: '2026-01-01' } as unknown as BomMaster]) // create 중복검사
        .mockResolvedValue([]); // findById part enrich
      mockBomRepo.create.mockReturnValue(created);
      mockBomRepo.save.mockResolvedValue(created);
      mockBomRepo.findOne.mockResolvedValue(created);
      mockPartRepo.find.mockResolvedValue([]);

      // Act
      const result = await target.create(dto);

      // Assert
      expect(mockBomRepo.save).toHaveBeenCalled();
      expect(result.parentItemCode).toBe('P01');
    });

    it('should create bom successfully', async () => {
      // Arrange
      const dto = { parentItemCode: 'P01', childItemCode: 'C01', qtyPer: 2, validFrom: '2026-01-01', validTo: '2099-12-31' } as any;
      const created = { ...dto, revision: 'A', useYn: 'Y' } as BomMaster;
      mockBomRepo.find.mockResolvedValue([]);
      mockBomRepo.create.mockReturnValue(created);
      mockBomRepo.save.mockResolvedValue(created);
      mockBomRepo.findOne.mockResolvedValue(created);
      mockPartRepo.find.mockResolvedValue([]);

      // Act
      const result = await target.create(dto);

      // Assert
      expect(mockBomRepo.save).toHaveBeenCalled();
      expect(result.childItemCode).toBe('C01');
    });
  });

  // ─── update ───
  describe('update', () => {
    it('should update and return bom', async () => {
      // Arrange
      const bom = { parentItemCode: 'P01', childItemCode: 'C01', revision: 'A', validFrom: '2026-01-01' } as unknown as BomMaster;
      mockBomRepo.findOne.mockResolvedValue(bom);
      mockPartRepo.find.mockResolvedValue([]);
      mockBomRepo.update.mockResolvedValue({ affected: 1 } as any);

      // Act
      await target.update('P01::C01::2026-01-01', { qtyPer: 5 } as any);

      // Assert
      expect(mockBomRepo.update).toHaveBeenCalledWith(
        expect.objectContaining({ parentItemCode: 'P01', childItemCode: 'C01', validFrom: expect.any(Date) }),
        expect.objectContaining({ qtyPer: 5 }),
      );
    });

    it('should throw ConflictException when changing validFrom to an existing sibling date', async () => {
      // Arrange
      const bom = { parentItemCode: 'P01', childItemCode: 'C01', revision: 'A', validFrom: '2026-01-01' } as unknown as BomMaster;
      mockBomRepo.findOne.mockResolvedValue(bom);
      mockPartRepo.find.mockResolvedValue([]);
      mockBomRepo.find.mockResolvedValue([{ validFrom: '2026-03-01' } as unknown as BomMaster]);

      // Act & Assert
      await expect(target.update('P01::C01::2026-01-01', { validFrom: '2026-03-01' } as any)).rejects.toThrow(ConflictException);
    });
  });

  // ─── delete ───
  describe('delete', () => {
    it('should delete and return id', async () => {
      // Arrange
      const bom = { parentItemCode: 'P01', childItemCode: 'C01', revision: 'A', validFrom: '2026-01-01' } as unknown as BomMaster;
      mockBomRepo.findOne.mockResolvedValue(bom);
      mockPartRepo.find.mockResolvedValue([]);
      mockBomRepo.delete.mockResolvedValue({ affected: 1 } as any);

      // Act
      const result = await target.delete('P01::C01::2026-01-01');

      // Assert
      expect(result).toEqual({ id: 'P01::C01::2026-01-01' });
      expect(mockBomRepo.delete).toHaveBeenCalledWith(
        expect.objectContaining({ parentItemCode: 'P01', childItemCode: 'C01', validFrom: expect.any(Date) }),
      );
    });
  });

  // ─── findParents ───
  describe('findParents', () => {
    it('should return parent items with bomCount parsed to int', async () => {
      // Arrange
      const rawRows = [
        { itemCode: 'P01', itemName: 'Parent', bomCount: '3', revisions: 'A,B' },
      ];
      mockBomRepo.query.mockResolvedValue(rawRows);

      // Act
      const result = await target.findParents();

      // Assert
      expect(result[0].bomCount).toBe(3);
      expect(result[0].revisions).toEqual(['A', 'B']);
    });

    it('should handle empty revisions', async () => {
      // Arrange
      mockBomRepo.query.mockResolvedValue([
        { itemCode: 'P01', bomCount: '1', revisions: null },
      ]);

      // Act
      const result = await target.findParents();

      // Assert
      expect(result[0].revisions).toEqual([]);
    });

    it('should select parent BOM valid date range for root row display', async () => {
      mockBomRepo.query.mockResolvedValue([
        { itemCode: 'P01', bomCount: '1', revisions: 'A', validFrom: new Date('2026-06-01'), validTo: new Date('2099-12-31') },
      ]);

      await target.findParents(undefined, '2026-06-29', 1);

      const [sql] = mockBomRepo.query.mock.calls[0] as [string, unknown[]];
      // ID_ENG_BOM 적용일자 컬럼은 DATESET/DATEEND — 모품목 행은 자품목 중 최소 시작일~최대 종료일을 보여준다
      expect(sql).toContain(`TO_CHAR(MIN(b.DATESET), 'YYYY-MM-DD') AS "validFrom"`);
      expect(sql).toContain(`TO_CHAR(MAX(b.DATEEND), 'YYYY-MM-DD') AS "validTo"`);
      expect(sql).toContain('validFrom');
      expect(sql).toContain('validTo');
    });
  });

  describe('previewUpload', () => {
    it('should reject upload rows without validFrom or validTo', async () => {
      const workbook = XLSX.utils.book_new();
      const worksheet = XLSX.utils.json_to_sheet([
        {
          상위품목코드: 'P01',
          하위품목코드: 'C01',
          소요량: 1,
          리비전: 'A',
          유효시작일: '',
          유효종료일: '',
        },
      ]);
      XLSX.utils.book_append_sheet(workbook, worksheet, 'BOM');
      const buffer = XLSX.write(workbook, { type: 'buffer', bookType: 'xlsx' }) as Buffer;

      const result = await target.previewUpload(buffer, 1);

      expect(result.errorCount).toBe(1);
      expect(result.rows[0].status).toBe('error');
      expect(result.rows[0].message).toContain('유효시작일');
      expect(result.rows[0].message).toContain('유효종료일');
      expect(mockBomRepo.find).not.toHaveBeenCalled();
    });

    it('should read excel date serials and date strings as real dates', async () => {
      const workbook = XLSX.utils.book_new();
      const worksheet = XLSX.utils.aoa_to_sheet([
        ['상위품목코드', '하위품목코드', '소요량', '유효시작일', '유효종료일'],
        ['P01', 'C01', 1, 44337, 73050],
        ['P01', 'C02', 1, '2021/5/21', '20991231'],
        ['P01', 'C03', 1, '2021.05.21', '73050'],
        ['P01', 'C04', 1, '2021-13-01', '2099-12-31'],
      ]);
      XLSX.utils.book_append_sheet(workbook, worksheet, 'BOM');
      const buffer = XLSX.write(workbook, { type: 'buffer', bookType: 'xlsx' }) as Buffer;
      mockBomRepo.find.mockResolvedValue([]);

      const result = await target.previewUpload(buffer, 1);

      expect(result.rows.slice(0, 3).map((r) => [r.validFrom, r.validTo])).toEqual([
        ['2021-05-21', '2099-12-31'],
        ['2021-05-21', '2099-12-31'],
        ['2021-05-21', '2099-12-31'],
      ]);
      expect(result.rows[3].status).toBe('error');
      expect(result.rows[3].validFrom).toBeNull();
    });
  });

  describe('BOM 주인(ITEM_CODE)·필수 코드값', () => {
    const buildUpload = (rows: [string, string][]) => {
      const wb = XLSX.utils.book_new();
      const ws = XLSX.utils.aoa_to_sheet([
        ['상위품목코드', '하위품목코드', '소요량', '유효시작일', '유효종료일'],
        ...rows.map(([p, c]) => [p, c, 1, '2026-10-12', '9999-12-31']),
      ]);
      XLSX.utils.book_append_sheet(wb, ws, 'BOM');
      return XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' }) as Buffer;
    };

    it('create: 처음 만드는 상위품목은 화면의 최상위 제품을 주인으로, T/T/* 를 넣는다', async () => {
      const dto = { parentItemCode: 'S01', childItemCode: 'C01', qtyPer: 1, validFrom: '2026-10-12', validTo: '9999-12-31', topItemCode: 'TOP1' } as any;
      mockBomRepo.find.mockResolvedValue([]);
      mockBomRepo.query.mockResolvedValue([]);
      mockBomRepo.create.mockImplementation((v) => v as BomMaster);
      mockBomRepo.save.mockResolvedValue({} as BomMaster);
      mockBomRepo.findOne.mockResolvedValue({ ...dto } as BomMaster);
      mockPartRepo.find.mockResolvedValue([]);

      await target.create(dto, 1, 'U1');

      expect(mockBomRepo.create).toHaveBeenCalledWith(expect.objectContaining({
        itemCode: 'TOP1', itemType: 'T', lineType: 'T', processCode: '*', createdBy: 'U1',
      }));
    });

    it('create: 상위품목에 이미 하위 행이 있으면 그 행들의 주인을 따른다', async () => {
      const dto = { parentItemCode: 'S01', childItemCode: 'C09', qtyPer: 1, validFrom: '2026-10-12', validTo: '9999-12-31', topItemCode: 'TOP1', processCode: 'P10' } as any;
      mockBomRepo.find.mockResolvedValue([]);
      mockBomRepo.query.mockResolvedValue([{ parentItemCode: 'S01', ownerItemCode: 'W01', cnt: 5 }]);
      mockBomRepo.create.mockImplementation((v) => v as BomMaster);
      mockBomRepo.save.mockResolvedValue({} as BomMaster);
      mockBomRepo.findOne.mockResolvedValue({ ...dto } as BomMaster);
      mockPartRepo.find.mockResolvedValue([]);

      await target.create(dto, 1);

      expect(mockBomRepo.create).toHaveBeenCalledWith(expect.objectContaining({ itemCode: 'W01', processCode: 'P10' }));
    });

    it('upload: 행마다 파일 안 자기 계통의 최상위 상위품목이 주인, DB 에 하위가 있는 반제품은 기존 주인을 따른다', async () => {
      // T01 → S01 → C01, T01 → N01 → C02, X01 → Y01. S01 은 DB 에 이미 하위 행이 있고 주인은 W01.
      const buffer = buildUpload([['T01', 'S01'], ['S01', 'C01'], ['T01', 'N01'], ['N01', 'C02'], ['X01', 'Y01']]);
      const codes = ['T01', 'S01', 'C01', 'N01', 'C02', 'X01', 'Y01'];
      mockPartRepo.find.mockResolvedValue(codes.map((itemCode) => ({ itemCode }) as ItemMaster));
      mockBomRepo.find.mockResolvedValue([]);
      mockBomRepo.query.mockResolvedValue([{ parentItemCode: 'S01', ownerItemCode: 'W01', cnt: 3 }]);
      mockBomRepo.create.mockImplementation((v) => v as BomMaster);
      mockBomRepo.save.mockResolvedValue({} as BomMaster);

      const result = await target.uploadFromExcel(buffer, 1, 'U1');

      expect(result.inserted).toBe(5);
      const owners = mockBomRepo.create.mock.calls.map(([v]) => [(v as BomMaster).parentItemCode, (v as BomMaster).childItemCode, (v as BomMaster).itemCode]);
      expect(owners).toEqual([
        ['T01', 'S01', 'T01'],
        ['S01', 'C01', 'W01'],
        ['T01', 'N01', 'T01'],
        ['N01', 'C02', 'T01'],
        ['X01', 'Y01', 'X01'],
      ]);
      expect(mockBomRepo.create).toHaveBeenCalledWith(expect.objectContaining({ itemType: 'T', lineType: 'T', processCode: '*' }));
    });
  });

  describe('findUsage', () => {
    it('위로 거슬러 올라간 최상위 제품을 돌려주고, 부모가 없으면 상위품목 자신을 돌려준다', async () => {
      mockBomRepo.query.mockResolvedValueOnce([{ itemCode: 'T02' }, { itemCode: 'T01' }]);
      mockPartRepo.find.mockResolvedValue([{ itemCode: 'T01', itemName: 'TOP 1', itemNo: 'N-1' } as ItemMaster]);

      const shared = await target.findUsage('S01', 1);

      const [sql, params] = mockBomRepo.query.mock.calls[0] as [string, unknown[]];
      expect(sql).toMatch(/CONNECT BY NOCYCLE PRIOR b\.PARENT_ITEM_CODE = b\.CHILD_ITEM_CODE/);
      expect(params).toEqual(['S01', 1, 1]);
      expect(shared.topItems.map((t) => t.itemCode)).toEqual(['T01', 'T02']);
      expect(shared.topItems[0].itemName).toBe('TOP 1');

      mockBomRepo.query.mockResolvedValueOnce([]);
      const alone = await target.findUsage('T09', 1);
      expect(alone.topItems.map((t) => t.itemCode)).toEqual(['T09']);
    });
  });

  describe('exportToExcel', () => {
    it('should export every level of the selected parent, not only direct children', async () => {
      mockBomRepo.query.mockResolvedValue([
        { id: 'P01::S01::2021-01-01', lvl: 1, parentItemCode: 'P01', childItemCode: 'S01', qtyPer: 1, seq: 1, itemNo: 'S-01', itemName: 'SUB', unit: 'EA', validFrom: '2021-01-01', validTo: '2099-12-31' },
        { id: 'S01::R01::2021-01-01', lvl: 2, parentItemCode: 'S01', childItemCode: 'R01', qtyPer: 2, seq: 1, itemNo: 'R-01', itemName: 'RAW', unit: 'EA', validFrom: '2021-01-01', validTo: '2099-12-31' },
        { id: 'R01::X01::2021-01-01', lvl: 3, parentItemCode: 'R01', childItemCode: 'X01', qtyPer: 3, seq: 1, itemNo: 'X-01', itemName: 'RAW3', unit: 'EA', validFrom: '2021-01-01', validTo: '2099-12-31' },
      ]);

      const buffer = await target.exportToExcel('P01', 1, '2026-10-12');

      const [sql, params] = mockBomRepo.query.mock.calls[0] as [string, unknown[]];
      expect(sql).toMatch(/CONNECT BY/);
      expect(params).toContain('2026-10-12');
      const wb = XLSX.read(buffer, { type: 'buffer' });
      const rows = XLSX.utils.sheet_to_json<Record<string, unknown>>(wb.Sheets[wb.SheetNames[0]]);
      expect(rows.map((r) => [r['레벨'], r['상위품목코드'], r['하위품목코드']])).toEqual([
        [1, 'P01', 'S01'],
        [2, 'S01', 'R01'],
        [3, 'R01', 'X01'],
      ]);
    });
  });

  // ─── findByParentId ───
  describe('findByParentId', () => {
    it('should return empty array when no children', async () => {
      // Arrange
      mockBomRepo.query.mockResolvedValue([]);

      // Act
      const result = await target.findByParentId('P01');

      // Assert
      expect(result).toEqual([]);
    });

    it('should enrich children with part info', async () => {
      // Arrange
      mockBomRepo.query.mockResolvedValue([
        { childItemCode: 'C01', parentItemCode: 'P01' },
      ]);
      mockPartRepo.find.mockResolvedValue([
        { itemCode: 'C01', itemName: 'Child1' } as ItemMaster,
      ]);

      // Act
      const result = await target.findByParentId('P01');

      // Assert
      expect(result[0].childPart).toEqual({ itemCode: 'C01', itemName: 'Child1' });
    });

    it('should enrich child parts within tenant only', async () => {
      mockBomRepo.query.mockResolvedValue([
        { childItemCode: 'C01', parentItemCode: 'P01' },
      ]);
      mockPartRepo.find.mockResolvedValue([]);

      await target.findByParentId('P01', undefined, 1);

      expect(mockPartRepo.find).toHaveBeenCalledWith({
        // 은성 ID_ITEM 기준 컬럼(itemClass/itemUom)으로 조회 — HANES 의 productType/unit 은 없다
        where: { itemCode: expect.anything(), organizationId: 1 },
        select: ['itemCode', 'itemName', 'itemNo', 'itemType', 'itemClass', 'spec', 'itemUom'],
      });
    });
  });

  // ─── findHierarchy: bind helper 회귀 방지 ───
  describe('findHierarchy', () => {
    /**
     * findHierarchy의 bind() 헬퍼는 호출 순서대로 :N 위치 바인드를 채운다.
     * SQL의 절 추가/위치 변경 시 묵시적으로 깨질 수 있으므로 다음을 보장한다:
     *  - params 길이 = SQL에 나타난 unique :N 의 개수
     *  - 각 :N 의 값이 절의 의미와 일치 (예: START WITH 바인드 = parentItemCode)
     *  - ORGANIZATION_ID 컬럼명 사용
     */
    it('should bind parentItemCode to START WITH and use ORGANIZATION_ID column', async () => {
      mockBomRepo.query.mockResolvedValue([]);

      await target.findHierarchy('P01', 3, undefined, 1);

      const [sql, params] = mockBomRepo.query.mock.calls[0] as [string, (string | number)[]];

      // ORGANIZATION_ID가 정확히 사용되어야 한다
      expect(sql).toContain('b.ORGANIZATION_ID');

      // SQL에 등장한 모든 :N 의 N이 1..params.length 범위 안이고 빠짐 없어야 한다
      const bindNumbers = new Set<number>();
      for (const m of sql.matchAll(/:(\d+)/g)) {
        bindNumbers.add(Number(m[1]));
      }
      const sortedBinds = [...bindNumbers].sort((a, b) => a - b);
      for (let i = 0; i < sortedBinds.length; i++) {
        expect(sortedBinds[i]).toBe(i + 1);
      }
      expect(sortedBinds.length).toBe(params.length);

      // START WITH :N 자리에 들어간 바인드 N이 parentItemCode 값과 매칭되는지
      const startWithMatch = sql.match(/START\s+WITH\s+b\.PARENT_ITEM_CODE\s*=\s*:(\d+)/i);
      expect(startWithMatch).not.toBeNull();
      const startWithIdx = Number(startWithMatch![1]);
      expect(params[startWithIdx - 1]).toBe('P01');

      // organizationId 값이 params에 포함되어야 한다
      expect(params).toContain(1);
    });

    it('should bind effectiveDate twice in WHERE and twice in CONNECT BY', async () => {
      mockBomRepo.query.mockResolvedValue([]);

      await target.findHierarchy('P01', 3, '2026-05-26');

      const [, params] = mockBomRepo.query.mock.calls[0] as [string, string[]];

      // WHERE 2개 + CONNECT BY 2개 = effectiveDate 4번, parentItemCode 1번
      const dateCount = params.filter((p) => p === '2026-05-26').length;
      expect(dateCount).toBe(4);
      expect(params).toContain('P01');
      expect(params.length).toBe(5);
    });

    it('should keep bind positions stable when only organizationId is provided (no date)', async () => {
      // 조건부 절이 모두 빠졌을 때도 :N 번호가 1부터 순차여야 한다 (헬퍼 회귀 방지)
      mockBomRepo.query.mockResolvedValue([]);

      await target.findHierarchy('P01', 3, undefined, 1);

      const [sql, params] = mockBomRepo.query.mock.calls[0] as [string, (string | number)[]];

      const bindNumbers = [...new Set(
        [...sql.matchAll(/:(\d+)/g)].map((m) => Number(m[1])),
      )].sort((a, b) => a - b);
      for (let i = 0; i < bindNumbers.length; i++) {
        expect(bindNumbers[i]).toBe(i + 1);
      }
      expect(bindNumbers.length).toBe(params.length);

      // WHERE + CONNECT BY 각각의 ORGANIZATION_ID 바인드 + parentItemCode = 3
      expect(params).toEqual(expect.arrayContaining([1, 'P01']));
      expect(params.length).toBe(3);
    });

    it('should attach children to each occurrence when the same semi-product appears twice in one tree', async () => {
      // P01 → A01 → S01 → R01, P01 → B01 → S01 → R01 (S01 은 한 트리에 두 번 나온다)
      const row = (lvl: number, parent: string, child: string) => ({
        id: `${parent}::${child}::2021-01-01`, lvl, parentItemCode: parent, childItemCode: child, itemCode: child, qtyPer: 1, seq: 1,
      });
      mockBomRepo.query.mockResolvedValue([
        row(1, 'P01', 'A01'), row(2, 'A01', 'S01'), row(3, 'S01', 'R01'),
        row(1, 'P01', 'B01'), row(2, 'B01', 'S01'), row(3, 'S01', 'R01'),
      ]);

      const tree = await target.findHierarchy('P01', 10);

      expect(tree.map((n) => n.childItemCode)).toEqual(['A01', 'B01']);
      expect(tree[0].children[0].children.map((n) => n.childItemCode)).toEqual(['R01']);
      expect(tree[1].children[0].children.map((n) => n.childItemCode)).toEqual(['R01']);
    });
  });
});

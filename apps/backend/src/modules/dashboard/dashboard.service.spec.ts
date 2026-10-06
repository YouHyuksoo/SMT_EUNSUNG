/**
 * @file src/modules/dashboard/dashboard.service.spec.ts
 * @description DashboardService 단위 테스트
 *
 * 초보자 가이드:
 * - target: 테스트 대상(SUT), mock*: 모킹된 의존성
 * - OracleService를 모킹하여 PKG_DASHBOARD 프로시저 호출 테스트
 * - DataSource를 모킹하여 getSummary 카드 조회 SQL·바인드 테스트
 * - 실행: `pnpm test -- -t "DashboardService"`
 */
import { Test, TestingModule } from '@nestjs/testing';
import { DashboardService } from './dashboard.service';
import { DataSource } from 'typeorm';
import { OracleService } from '../../common/services/oracle.service';
import { MockLoggerService } from '@test/mock-logger.service';

describe('DashboardService', () => {
  let target: DashboardService;
  let mockOracleService: {
    callProc: jest.Mock;
    callProcMultiCursor: jest.Mock;
  };
  let mockDataSource: { query: jest.Mock };

  beforeEach(async () => {
    mockOracleService = {
      callProc: jest.fn(),
      callProcMultiCursor: jest.fn(),
    };
    mockDataSource = { query: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DashboardService,
        { provide: OracleService, useValue: mockOracleService },
        { provide: DataSource, useValue: mockDataSource },
      ],
    })
      .setLogger(new MockLoggerService())
      .compile();

    target = module.get<DashboardService>(DashboardService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  // ─── getSummary ───
  describe('getSummary', () => {
    function answer(sql: string) {
      if (sql.includes('FROM IMCN_MACHINE')) return [{ total: '93', inUse: '91', notUsed: '2', down: '0' }];
      if (sql.includes('IP_PRODUCT_SMD_PLAN')) return [{ smdPlan: 75104, smdActual: 8848, miPlan: 128320, miActual: 19216 }];
      if (sql.includes('"solderInUse"')) return [{ solderInUse: 12, mslLots: 10 }];
      if (sql.includes('IP_PRODUCT_WORK_QC')) return [{ pending: 0, genuine: 46, pseudo: 3, unrepaired: 0 }];
      return [{ NG_COUNT: 1 }];
    }

    it('maps each card from the Eunsung tables', async () => {
      mockDataSource.query.mockImplementation(async (sql: string) => answer(sql));

      const result = await target.getSummary('2026-09-30');

      expect(result.equip).toEqual({ inUse: 91, down: 0, notUsed: 2, total: 93 });
      expect(result.production).toEqual({ smdPlan: 75104, smdActual: 8848, miPlan: 128320, miActual: 19216 });
      expect(result.material).toEqual({ solderInUse: 12, solderNg: 1, mslLots: 10, mslNg: 1 });
      expect(result.defect).toEqual({ pending: 0, genuine: 46, pseudo: 3, unrepaired: 0 });
      expect(mockOracleService.callProc).not.toHaveBeenCalled();
    });

    it('excludes TEMP sensors from the equipment count and binds the day by name', async () => {
      mockDataSource.query.mockImplementation(async (sql: string) => answer(sql));

      await target.getSummary('2026-09-30');

      const calls = mockDataSource.query.mock.calls as [string, unknown][];
      const equipSql = calls.find(([sql]) => sql.includes('FROM IMCN_MACHINE'))![0];
      expect(equipSql).toContain("<> 'TEMP'");
      const qc = calls.find(([sql]) => sql.includes('IP_PRODUCT_WORK_QC'))!;
      expect(qc[1]).toEqual({ day: '2026-09-30' });
    });

    it('falls back to today when no date is given', async () => {
      mockDataSource.query.mockImplementation(async (sql: string) => answer(sql));

      await target.getSummary(undefined);

      const qc = (mockDataSource.query.mock.calls as [string, unknown][]).find(([sql]) => sql.includes('IP_PRODUCT_WORK_QC'))!;
      expect(qc[1]).toEqual({ day: null });
      expect(qc[0]).toContain('TRUNC(SYSDATE)');
    });

    it('rejects a malformed date', async () => {
      await expect(target.getSummary('2026/09/30')).rejects.toThrow('YYYY-MM-DD');
      expect(mockDataSource.query).not.toHaveBeenCalled();
    });
  });

  // ─── getInsights ───
  describe('getInsights', () => {
    it('aggregates line rows once, keeps actual-only lines, and fills empty calendar days', async () => {
      const rows = [
        { selectedDate: '2026-10-06', date: '2026-10-04', productionType: null, lineCode: null, lineName: null, planQty: null, actualQty: null },
        { selectedDate: '2026-10-06', date: '2026-10-05', productionType: 'SMD', lineCode: 'S1', lineName: 'SMD 1', planQty: '100', actualQty: '120' },
        { selectedDate: '2026-10-06', date: '2026-10-06', productionType: 'SMD', lineCode: 'S1', lineName: 'SMD 1', planQty: '200', actualQty: '80' },
        { selectedDate: '2026-10-06', date: '2026-10-06', productionType: 'MI', lineCode: 'M1', lineName: '제품 1', planQty: '0', actualQty: '25' },
      ];
      mockDataSource.query.mockResolvedValue(rows);
      const result = await target.getInsights('2026-10-06');
      expect(result.date).toBe('2026-10-06');
      expect(result.trend).toEqual([
        { date: '2026-10-04', smdPlan: 0, smdActual: 0, miPlan: 0, miActual: 0 },
        { date: '2026-10-05', smdPlan: 100, smdActual: 120, miPlan: 0, miActual: 0 },
        { date: '2026-10-06', smdPlan: 200, smdActual: 80, miPlan: 0, miActual: 25 },
      ]);
      expect(result.lines).toHaveLength(2);
      expect(result.lines[0]).toMatchObject({ lineCode: 'S1', productionType: 'SMD', planQty: 200, actualQty: 80 });
      expect(result.lines[1]).toMatchObject({ lineCode: 'M1', planQty: 0, actualQty: 25 });
      const [sql, binds] = mockDataSource.query.mock.calls[0];
      expect(sql).toContain('UNION ALL');
      expect(sql).toContain('CONNECT BY LEVEL <= 7');
      expect(sql).toContain('LEFT JOIN');
      expect(binds).toEqual({ day: '2026-10-06' });
      expect(mockDataSource.query).toHaveBeenCalledTimes(1);
    });

    it('rejects a malformed date without querying', async () => {
      await expect(target.getInsights('2026/10/06')).rejects.toThrow('YYYY-MM-DD');
      expect(mockDataSource.query).not.toHaveBeenCalled();
    });
  });
  // ─── getKpi ───
  describe('getKpi', () => {
    it('should return KPI data', async () => {
      // Arrange
      mockOracleService.callProc.mockResolvedValue([{
        todayProd: 100,
        prodChange: 5,
        inventoryTotal: 500,
        invChange: -2,
        passRate: '98.5',
        rateChange: 0.5,
        defectCnt: 3,
        defectChange: -1,
      }]);

      // Act
      const result = await target.getKpi('CO', 'P01');

      // Assert
      expect(result.todayProduction).toEqual({ value: 100, change: 5 });
      expect(result.qualityPassRate).toEqual({ value: '98.5', change: 0.5 });
      expect(mockOracleService.callProc).toHaveBeenCalledWith('PKG_DASHBOARD', 'SP_KPI', { p_company: 'CO', p_plant: 'P01' });
    });

    it('should handle empty KPI result', async () => {
      // Arrange
      mockOracleService.callProc.mockResolvedValue([]);

      // Act
      const result = await target.getKpi();

      // Assert
      expect(result.todayProduction).toEqual({ value: 0, change: 0 });
      expect(mockOracleService.callProc).toHaveBeenCalledWith('PKG_DASHBOARD', 'SP_KPI', { p_company: null, p_plant: null });
    });
  });

  // ─── getRecentProductions ───
  describe('getRecentProductions', () => {
    it('should return recent productions from Oracle', async () => {
      // Arrange
      const productions = [{ orderNo: 'ORD1', itemCode: 'ITEM1' }];
      mockOracleService.callProc.mockResolvedValue(productions);

      // Act
      const result = await target.getRecentProductions('CO', 'P01');

      // Assert
      expect(result).toEqual(productions);
      expect(mockOracleService.callProc).toHaveBeenCalledWith('PKG_DASHBOARD', 'SP_RECENT_PRODUCTIONS', { p_company: 'CO', p_plant: 'P01' });
    });
  });
});

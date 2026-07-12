/**
 * @file src/modules/dashboard/dashboard.service.spec.ts
 * @description DashboardService 단위 테스트
 *
 * 초보자 가이드:
 * - target: 테스트 대상(SUT), mock*: 모킹된 의존성
 * - OracleService를 모킹하여 PKG_DASHBOARD 프로시저 호출 테스트
 * - 실행: `pnpm test -- -t "DashboardService"`
 */
import { Test, TestingModule } from '@nestjs/testing';
import { DashboardService } from './dashboard.service';
import { OracleService } from '../../common/services/oracle.service';
import { MockLoggerService } from '@test/mock-logger.service';

describe('DashboardService', () => {
  let target: DashboardService;
  let mockOracleService: {
    callProc: jest.Mock;
    callProcMultiCursor: jest.Mock;
  };

  beforeEach(async () => {
    mockOracleService = {
      callProc: jest.fn(),
      callProcMultiCursor: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DashboardService,
        { provide: OracleService, useValue: mockOracleService },
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
    it('returns the temporary summary mock without calling Oracle procedures', async () => {
      const result = await target.getSummary('2026-03-18', 'CO', 'P01');

      expect(result.equip).toEqual({ normal: 0, maint: 0, stop: 0, total: 0 });
      expect(result.job).toEqual({ wait: 0, running: 0, done: 0, total: 0 });
      expect(result.daily).toEqual({ total: 0, completed: 0, pass: 0, fail: 0, items: [] });
      expect(mockOracleService.callProc).not.toHaveBeenCalled();
      expect(mockOracleService.callProcMultiCursor).not.toHaveBeenCalled();
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

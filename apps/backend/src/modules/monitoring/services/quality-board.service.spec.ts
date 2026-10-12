/**
 * @file src/modules/monitoring/services/quality-board.service.spec.ts
 * @description QualityBoardService 단위 테스트 — DataSource.query 를 모킹해 집계/응답 형태를 검증한다
 *
 * 초보자 가이드:
 * - getBoard 는 쿼리를 byLine → topDefects → repair → dailyTrend 순서로 실행한다 (mockResolvedValueOnce 순서)
 * - 실행: `pnpm exec jest src/modules/monitoring`
 */
import { Test, TestingModule } from '@nestjs/testing';
import { DataSource } from 'typeorm';
import { MockLoggerService } from '@test/mock-logger.service';
import { QualityBoardService } from './quality-board.service';

describe('QualityBoardService', () => {
  let target: QualityBoardService;
  let mockDataSource: { query: jest.Mock };

  beforeEach(async () => {
    mockDataSource = { query: jest.fn() };
    const module: TestingModule = await Test.createTestingModule({
      providers: [QualityBoardService, { provide: DataSource, useValue: mockDataSource }],
    })
      .setLogger(new MockLoggerService())
      .compile();
    target = module.get(QualityBoardService);
  });

  afterEach(() => jest.clearAllMocks());

  it('라인별 합으로 KPI 를 만들고 진성불량률을 소수 1자리로 계산한다', async () => {
    mockDataSource.query
      .mockResolvedValueOnce([
        { processCode: 'E라인', totalQty: '30', defectQty: '27' },
        { processCode: 'G라인', totalQty: '10', defectQty: 7 },
      ])
      .mockResolvedValueOnce([
        { defectCode: 'B1020', defectName: '틀어짐', qty: '20' },
        { defectCode: '%', defectName: null, qty: 2 },
      ])
      .mockResolvedValueOnce([{ received: '1', inRepair: '2', completedToday: '30' }])
      .mockResolvedValueOnce([
        { ymd: '2026-10-05', totalQty: 0, defectQty: 0 },
        { ymd: '2026-10-06', totalQty: '40', defectQty: '34' },
      ]);

    const result = await target.getBoard();

    expect(mockDataSource.query).toHaveBeenCalledTimes(4);
    expect(result.kpi).toEqual({ totalQty: 40, defectQty: 34, defectRate: 85 });
    expect(result.byProcess).toEqual([
      { processCode: 'E라인', totalQty: 30, defectQty: 27, defectRate: 90 },
      { processCode: 'G라인', totalQty: 10, defectQty: 7, defectRate: 70 },
    ]);
    // 코드명이 없으면 코드로 대체
    expect(result.topDefects).toEqual([
      { defectCode: 'B1020', defectName: '틀어짐', qty: 20 },
      { defectCode: '%', defectName: '%', qty: 2 },
    ]);
    expect(result.repair).toEqual({ received: 1, inRepair: 2, completedToday: 30 });
    expect(result.dailyTrend).toEqual([
      { date: '2026-10-05', totalQty: 0, defectQty: 0, defectRate: 0 },
      { date: '2026-10-06', totalQty: 40, defectQty: 34, defectRate: 85 },
    ]);
  });

  it('데이터가 없으면 0/빈 배열을 돌려준다 (0 나눗셈 없음)', async () => {
    mockDataSource.query
      .mockResolvedValueOnce([])
      .mockResolvedValueOnce([])
      .mockResolvedValueOnce([])
      .mockResolvedValueOnce([]);

    const result = await target.getBoard();

    expect(result.kpi).toEqual({ totalQty: 0, defectQty: 0, defectRate: 0 });
    expect(result.byProcess).toEqual([]);
    expect(result.topDefects).toEqual([]);
    expect(result.repair).toEqual({ received: 0, inRepair: 0, completedToday: 0 });
    expect(result.dailyTrend).toEqual([]);
  });

  it('조회 전용 SQL 만 실행한다 (SELECT 로 시작)', async () => {
    mockDataSource.query.mockResolvedValue([]);
    await target.getBoard();
    for (const [sql] of mockDataSource.query.mock.calls as [string][]) {
      expect(sql.trim()).toMatch(/^SELECT/);
      expect(sql).toContain('IP_PRODUCT_WORK_QC');
    }
  });
});

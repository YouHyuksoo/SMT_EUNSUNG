/**
 * @file src/modules/monitoring/services/equipment-board.service.spec.ts
 * @description EquipmentBoardService 단위 테스트 — DataSource.query 를 모킹해 상태 매핑/응답 형태를 검증한다
 *
 * 초보자 가이드:
 * - getBoard 는 쿼리를 설비 목록 → 가동 작업 순서로 실행한다 (mockResolvedValueOnce 순서)
 * - 실행: `pnpm exec jest src/modules/monitoring`
 */
import { Test, TestingModule } from '@nestjs/testing';
import { DataSource } from 'typeorm';
import { MockLoggerService } from '@test/mock-logger.service';
import { EquipmentBoardService } from './equipment-board.service';

describe('EquipmentBoardService', () => {
  let target: EquipmentBoardService;
  let mockDataSource: { query: jest.Mock };

  beforeEach(async () => {
    mockDataSource = { query: jest.fn() };
    const module: TestingModule = await Test.createTestingModule({
      providers: [EquipmentBoardService, { provide: DataSource, useValue: mockDataSource }],
    })
      .setLogger(new MockLoggerService())
      .compile();
    target = module.get(EquipmentBoardService);
  });

  afterEach(() => jest.clearAllMocks());

  const baseRow = {
    equipName: '설비', equipTypeName: 'MOUNTER', equipType: 'M0130', lineCode: '01', lineName: 'A라인',
    processCode: 'W040', processName: 'MOUNT', useStatus: 'U', ipAddress: null, modelName: 'SM411', down: 0,
  };

  it('진행중 비가동은 STOP, USE_STATUS S/T/D 는 UNUSED, 그 외는 NORMAL 로 매핑한다', async () => {
    mockDataSource.query
      .mockResolvedValueOnce([
        { ...baseRow, equipCode: 'A1' },
        { ...baseRow, equipCode: 'A2', down: 1 },
        { ...baseRow, equipCode: 'A3', useStatus: 'S' },
        { ...baseRow, equipCode: 'A4', useStatus: 'D', down: 1 },
      ])
      .mockResolvedValueOnce([]);

    const { equips } = await target.getBoard();

    expect(equips.map((e) => [e.equipCode, e.status])).toEqual([
      ['A1', 'NORMAL'],
      ['A2', 'STOP'],
      ['A3', 'UNUSED'],
      ['A4', 'STOP'], // 비가동이 미사용보다 우선
    ]);
    expect(equips[0]).toMatchObject({ id: 'A1', equipType: 'MOUNTER', lineCode: '01', lineName: 'A라인', processName: 'MOUNT' });
  });

  it("라인 '*' 는 미배정(null)으로, 빈 문자열 컬럼은 null 로 돌려준다", async () => {
    mockDataSource.query
      .mockResolvedValueOnce([{ ...baseRow, equipCode: 'B1', lineCode: '*', lineName: null, processName: ' ' }])
      .mockResolvedValueOnce([]);

    const { equips } = await target.getBoard();

    expect(equips[0].lineCode).toBeNull();
    expect(equips[0].lineName).toBeNull();
    expect(equips[0].processName).toBeNull();
  });

  it('가동 작업은 숫자로 변환하고 누락 값은 기본값으로 채운다', async () => {
    mockDataSource.query
      .mockResolvedValueOnce([])
      .mockResolvedValueOnce([
        { lineCode: '01', itemName: ' MODEL-A ', goodQty: '12411', planQty: '14000', orderNo: 'WO1', defectQty: '3', lastActualAt: '2026-10-07 00:30' },
        { lineCode: '02', itemName: null, goodQty: 5, planQty: null, orderNo: null, defectQty: null, lastActualAt: null },
      ]);

    const { equips, runningJobs } = await target.getBoard();

    expect(equips).toEqual([]);
    expect(runningJobs).toEqual([
      { lineCode: '01', orderNo: 'WO1', itemName: 'MODEL-A', planQty: 14000, goodQty: 12411, defectQty: 3, lastActualAt: '2026-10-07 00:30' },
      { lineCode: '02', orderNo: '', itemName: null, planQty: 0, goodQty: 5, defectQty: 0, lastActualAt: null },
    ]);
  });

  it('조회 전용 SQL 만 실행한다 (SELECT/WITH 로 시작)', async () => {
    mockDataSource.query.mockResolvedValue([]);
    await target.getBoard();
    for (const [sql] of mockDataSource.query.mock.calls as [string][]) {
      expect(sql.trim()).toMatch(/^(SELECT|WITH)/);
    }
  });
});

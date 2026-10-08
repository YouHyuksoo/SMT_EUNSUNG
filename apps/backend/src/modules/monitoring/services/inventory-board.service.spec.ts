/**
 * @file src/modules/monitoring/services/inventory-board.service.spec.ts
 * @description InventoryBoardService 단위 테스트 (DataSource 모킹)
 *
 * 초보자 가이드:
 * - getBoard 는 쿼리 5개를 순서대로 부른다: 안전재고 → 솔더 → MSL → 보류 → 금일 입출고
 * - mockDataSource.query 를 SQL 내용(FROM 테이블)으로 분기해 각 응답을 돌려준다
 * - 실행: `pnpm exec jest src/modules/monitoring`
 */
import { DataSource } from 'typeorm';
import { InventoryBoardService } from './inventory-board.service';

type Rows = Record<string, unknown>[];

describe('InventoryBoardService', () => {
  let target: InventoryBoardService;
  let mockDataSource: { query: jest.Mock };

  /** SQL 문자열에 포함된 테이블명으로 응답을 고른다 */
  function mockByTable(map: {
    shortage?: Rows;
    solder?: Rows;
    msl?: Rows;
    hold?: Rows;
    inOut?: Rows;
  }) {
    mockDataSource.query.mockImplementation((sql: string) => {
      if (sql.includes('FROM IM_ITEM_SOLDER_MASTER')) return Promise.resolve(map.solder ?? []);
      if (sql.includes('FROM IM_ITEM_MSL_CHECK_VIEW')) return Promise.resolve(map.msl ?? []);
      if (sql.includes('FROM IM_ITEM_INVENTORY_HOLD')) return Promise.resolve(map.hold ?? []);
      if (sql.includes('FROM DUAL')) return Promise.resolve(map.inOut ?? [{ inCount: 0, outCount: 0 }]);
      if (sql.includes('SAFETY_INVENTORY')) return Promise.resolve(map.shortage ?? []);
      return Promise.resolve([]);
    });
  }

  beforeEach(() => {
    mockDataSource = { query: jest.fn() };
    target = new InventoryBoardService(mockDataSource as unknown as DataSource);
  });

  it('데이터가 없으면 0 / 빈 배열을 돌려준다', async () => {
    mockByTable({});
    const board = await target.getBoard();
    expect(board).toEqual({
      kpi: { shortageCount: 0, expiredCount: 0, nearExpiryCount: 0, holdCount: 0, inCount: 0, outCount: 0 },
      shortages: [],
      expiry: [],
      holds: [],
    });
    expect(mockDataSource.query).toHaveBeenCalledTimes(5);
  });

  it('안전재고 미달: 부족분 계산 + 전체 건수는 totalCount 를 쓴다', async () => {
    mockByTable({
      shortage: [
        { itemCode: 'A', itemName: '칩', qty: '30', safetyStock: '100', totalCount: 120 },
        { itemCode: 'B', itemName: null, qty: 0, safetyStock: 50, totalCount: 120 },
      ],
    });
    const board = await target.getBoard();
    expect(board.kpi.shortageCount).toBe(120);
    expect(board.shortages).toEqual([
      { itemCode: 'A', itemName: '칩', qty: 30, safetyStock: 100, shortage: 70 },
      { itemCode: 'B', itemName: null, qty: 0, safetyStock: 50, shortage: 50 },
    ]);
  });

  it('유효기한: 솔더 + MSL 을 남은 시간 순으로 합치고 초과/임박을 센다', async () => {
    mockByTable({
      solder: [
        { matUid: 'S-OLD', itemCode: 'SP', itemName: 'SOLDER PASTE', expireDate: '2026-10-01', daysLeft: -5 },
        { matUid: 'S-NEAR', itemCode: 'SP', itemName: 'SOLDER PASTE', expireDate: '2026-10-20', daysLeft: 13 },
      ],
      msl: [
        // 경과율 99% 초과 → 남은 시간이 양수여도 기한초과(-1)
        { matUid: 'M-NG', itemCode: 'IC1', itemName: 'IC', qty: 2500, remainHours: 1.2, passedRatio: 0.995, expireDate: '2026-10-07' },
        // 임박: 60시간 남음 → 2일
        { matUid: 'M-NEAR', itemCode: 'IC2', itemName: 'IC', qty: 100, remainHours: 60, passedRatio: 0.7, expireDate: '2026-10-09' },
      ],
    });
    const board = await target.getBoard();
    expect(board.kpi.expiredCount).toBe(2); // S-OLD, M-NG
    expect(board.kpi.nearExpiryCount).toBe(2); // M-NEAR, S-NEAR
    expect(board.expiry.map((e) => e.matUid)).toEqual(['S-OLD', 'M-NG', 'M-NEAR', 'S-NEAR']);
    expect(board.expiry.find((e) => e.matUid === 'M-NG')?.daysLeft).toBe(-1);
    expect(board.expiry.find((e) => e.matUid === 'M-NEAR')?.daysLeft).toBe(2);
    // 솔더는 수량 컬럼이 없어 1통 = 1
    expect(board.expiry.find((e) => e.matUid === 'S-OLD')?.qty).toBe(1);
    // remainHours 같은 내부 필드는 응답에 새지 않는다
    expect(board.expiry[0]).not.toHaveProperty('remainHours');
  });

  it('유효기한: 같은 matUid 는 하나만 남긴다', async () => {
    mockByTable({
      solder: [{ matUid: 'DUP', itemCode: 'SP', itemName: null, expireDate: '2026-10-01', daysLeft: -5 }],
      msl: [{ matUid: 'DUP', itemCode: 'IC', itemName: null, qty: 1, remainHours: 10, passedRatio: 0.9, expireDate: '2026-10-07' }],
    });
    const board = await target.getBoard();
    expect(board.expiry).toHaveLength(1);
    expect(board.expiry[0].itemCode).toBe('SP');
  });

  it('보류 재고: 상태 B 는 DEFECT, 그 외는 HOLD 로 매핑한다', async () => {
    mockByTable({
      hold: [
        { ref: 'LOT1', itemCode: 'A', itemName: '칩', qty: '500', holdStatus: 'B', totalCount: 2 },
        { ref: 'LOT2', itemCode: 'B', itemName: null, qty: 10, holdStatus: 'G', totalCount: 2 },
      ],
    });
    const board = await target.getBoard();
    expect(board.kpi.holdCount).toBe(2);
    expect(board.holds).toEqual([
      { kind: 'MATERIAL', ref: 'LOT1', itemCode: 'A', itemName: '칩', qty: 500, reason: 'DEFECT' },
      { kind: 'MATERIAL', ref: 'LOT2', itemCode: 'B', itemName: null, qty: 10, reason: 'HOLD' },
    ]);
  });

  it('금일 입출고 건수를 숫자로 돌려준다', async () => {
    mockByTable({ inOut: [{ inCount: '12', outCount: 34 }] });
    const board = await target.getBoard();
    expect(board.kpi.inCount).toBe(12);
    expect(board.kpi.outCount).toBe(34);
  });

  it('유효기한 목록은 50건으로 자르되 KPI 건수는 전체 기준', async () => {
    const solder = Array.from({ length: 60 }, (_, i) => ({
      matUid: `S${i}`, itemCode: 'SP', itemName: null, expireDate: '2026-10-01', daysLeft: -60 + i,
    }));
    mockByTable({ solder });
    const board = await target.getBoard();
    expect(board.expiry).toHaveLength(50);
    expect(board.kpi.expiredCount + board.kpi.nearExpiryCount).toBe(60);
  });

  it('쿼리는 순차 실행한다 (동시에 2개 이상 걸리지 않는다)', async () => {
    let running = 0;
    let maxRunning = 0;
    mockDataSource.query.mockImplementation(async () => {
      running += 1;
      maxRunning = Math.max(maxRunning, running);
      await Promise.resolve();
      running -= 1;
      return [{ inCount: 0, outCount: 0 }];
    });
    await target.getBoard();
    expect(maxRunning).toBe(1);
  });
});

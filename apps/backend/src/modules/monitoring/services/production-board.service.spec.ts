/**
 * @file src/modules/monitoring/services/production-board.service.spec.ts
 * @description ProductionBoardService 단위 테스트 — 계획 행 매핑·상태 파생·시간대 10칸·불량 칸 배정
 *
 * 초보자 가이드:
 * - DataSource.query 를 SQL 문자열로 구분해 모킹한다 (실제 DB 호출 없음)
 * - 실행: `pnpm exec jest src/modules/monitoring`
 */
import { Test, TestingModule } from '@nestjs/testing';
import { DataSource } from 'typeorm';
import { MockLoggerService } from '@test/mock-logger.service';
import {
  DEFAULT_SLOTS,
  ProductionBoardService,
  deriveStatus,
  slotIndexOf,
} from './production-board.service';

describe('ProductionBoardService', () => {
  let target: ProductionBoardService;
  let mockDataSource: { query: jest.Mock };

  const recent = new Date(Date.now() - 5 * 60_000);

  const smdRows = [
    // 진행 중: 일부 실적 + 방금 실적
    { planSequence: 1, workOrderNo: 'WO1', priority: 1, lineCode: '01', itemCode: 'I1', itemName: '모델1', modelName: 'M1', planQty: '1000', goodQty: '400', defectQty: '3', lastResultAt: recent },
    // 완료
    { planSequence: 2, workOrderNo: 'WO2', priority: 1, lineCode: '02', itemCode: 'I2', itemName: null, modelName: 'M2', planQty: 500, goodQty: 500, defectQty: 0, lastResultAt: recent },
    // 대기: 실적 없음
    { planSequence: 3, workOrderNo: null, priority: null, lineCode: '03', itemCode: 'I3', itemName: '모델3', modelName: 'M3', planQty: 200, goodQty: 0, defectQty: 0, lastResultAt: null },
  ];
  const miRows = [
    { planSequence: 3, workOrderNo: 'WO2', priority: 1, lineCode: '52', itemCode: 'I9', itemName: '제품', modelName: 'M9', planQty: 100, goodQty: 0, defectQty: 0, lastResultAt: null },
  ];
  const slotSum = (v: number[]) => [{ a: v[0], b: v[1], c: v[2], d: v[3], e: v[4], f: v[5], g: v[6], h: v[7], i: v[8], j: v[9] }];

  function answer(sql: string) {
    if (sql.includes('F_GET_WORK_ACTUAL_DATE')) return [{ day: '2026-10-06', startFrac: 0.354 }];
    if (sql.includes('FROM IP_PRODUCT_SMD_PLAN')) return smdRows;
    if (sql.includes('FROM IP_PRODUCT_MI_PLAN')) return miRows;
    if (sql.includes('FROM IP_ASSEMBLY_ACTUAL_TIME_V v')) return slotSum([10, 20, 0, 0, 0, 0, 5, 0, 0, 0]);
    if (sql.includes('FROM IP_PRODUCT_ACTUAL_TIME_V v')) return slotSum([1, 2, 3, 0, 0, 0, 0, 0, 0, 0]);
    if (sql.includes('FROM IP_PRODUCT_WORK_QC')) return [{ hhmm: '0900', cnt: '2' }, { hhmm: '2300', cnt: 1 }];
    if (sql.includes('FROM ICOM_WORKTIME_RANGES')) return [];
    return [];
  }

  beforeEach(async () => {
    mockDataSource = { query: jest.fn(async (sql: string) => answer(sql)) };
    const module: TestingModule = await Test.createTestingModule({
      providers: [ProductionBoardService, { provide: DataSource, useValue: mockDataSource }],
    })
      .setLogger(new MockLoggerService())
      .compile();
    target = module.get(ProductionBoardService);
  });

  afterEach(() => jest.clearAllMocks());

  describe('getBoard', () => {
    it('계획 행을 order 로 매핑하고 진행 → 대기 → 완료 순으로 정렬한다', async () => {
      const { orders } = await target.getBoard();
      expect(orders.map((o) => o.status)).toEqual(['RUNNING', 'WAITING', 'WAITING', 'DONE']);
      const first = orders[0];
      expect(first).toMatchObject({
        orderNo: 'WO1', processCode: 'SMD', equipCode: '01', itemName: '모델1',
        planQty: 1000, goodQty: 400, defectQty: 3, achieveRate: 40, priority: 1,
        startAt: null, endAt: null, updatedAt: null,
      });
    });

    it('작업지시번호가 없으면 구분-순번을, 중복이면 접미사를 붙여 orderNo 를 유일하게 만든다', async () => {
      const { orders } = await target.getBoard();
      const nos = orders.map((o) => o.orderNo);
      expect(new Set(nos).size).toBe(nos.length);
      expect(nos).toContain('SMD-3');
      expect(nos).toContain('WO2-MI3');
    });

    it('KPI: 계획 합은 행 합, 실적 합은 두 뷰의 시간대 합, 불량은 QC 건수 합', async () => {
      const { kpi } = await target.getBoard();
      expect(kpi.planQty).toBe(1800);
      expect(kpi.goodQty).toBe(10 + 20 + 5 + 1 + 2 + 3);
      expect(kpi.defectQty).toBe(3);
      expect(kpi.achieveRate).toBe(2.3);
      expect(kpi.runningCount).toBe(1);
      expect(kpi.totalCount).toBe(4);
    });

    it('hourly 는 항상 10칸이고 hour/label 이 칸 시작·범위 시각이다', async () => {
      const { hourly } = await target.getBoard();
      expect(hourly).toHaveLength(10);
      expect(hourly[0]).toEqual({ hour: '08:30', label: '08:30~10:30', goodQty: 11, defectQty: 2 });
      expect(hourly[1].goodQty).toBe(22);
      // 22:30~00:30 칸(G): 실적 5, 불량 23:00 한 건
      expect(hourly[6]).toMatchObject({ hour: '22:30', goodQty: 5, defectQty: 1 });
    });

    it('칸 정의 조회가 비어 있으면 기본 10칸을 쓴다', async () => {
      const { hourly } = await target.getBoard();
      expect(hourly.map((h) => h.hour)).toEqual(DEFAULT_SLOTS.map((s) => `${s.start.slice(0, 2)}:${s.start.slice(2)}`));
    });

    it('계획이 없으면 KPI 는 0 이고 orders 는 빈 배열이다', async () => {
      mockDataSource.query.mockImplementation(async (sql: string) =>
        sql.includes('F_GET_WORK_ACTUAL_DATE') ? [{ day: '2026-10-06', startFrac: 0.354 }] : sql.includes('PLAN') ? [] : sql.includes('FROM ICOM') ? [] : sql.includes('V v') ? slotSum([0, 0, 0, 0, 0, 0, 0, 0, 0, 0]) : [],
      );
      const { kpi, orders } = await target.getBoard();
      expect(orders).toEqual([]);
      expect(kpi).toEqual({ planQty: 0, goodQty: 0, defectQty: 0, achieveRate: 0, runningCount: 0, totalCount: 0 });
    });
  });

  describe('deriveStatus', () => {
    const now = new Date('2026-10-07T00:00:00Z');
    it('실적 0 → WAITING, 계획 이상 → DONE', () => {
      expect(deriveStatus(100, 0, null, now)).toBe('WAITING');
      expect(deriveStatus(100, 100, null, now)).toBe('DONE');
      expect(deriveStatus(100, 120, null, now)).toBe('DONE');
    });
    it('부분 실적: 최근 실적이면 RUNNING, 1시간 넘게 멈췄으면 WAITING, 시각 정보가 없으면 RUNNING', () => {
      expect(deriveStatus(100, 10, new Date('2026-10-06T23:30:00Z'), now)).toBe('RUNNING');
      expect(deriveStatus(100, 10, new Date('2026-10-06T22:00:00Z'), now)).toBe('WAITING');
      expect(deriveStatus(100, 10, null, now)).toBe('RUNNING');
    });
    it('계획 0 이고 실적이 있으면 RUNNING (DONE 으로 보지 않는다)', () => {
      expect(deriveStatus(0, 10, null, now)).toBe('RUNNING');
    });
  });

  describe('slotIndexOf', () => {
    it('자정을 넘는 칸(22:30~00:30)을 포함해 시각이 속한 칸을 찾는다', () => {
      expect(slotIndexOf('0830', DEFAULT_SLOTS)).toBe(0);
      expect(slotIndexOf('1029', DEFAULT_SLOTS)).toBe(0);
      expect(slotIndexOf('1030', DEFAULT_SLOTS)).toBe(1);
      expect(slotIndexOf('2300', DEFAULT_SLOTS)).toBe(6);
      expect(slotIndexOf('0010', DEFAULT_SLOTS)).toBe(6);
      expect(slotIndexOf('0030', DEFAULT_SLOTS)).toBe(7);
      expect(slotIndexOf('0829', DEFAULT_SLOTS)).toBe(9);
    });
  });
});

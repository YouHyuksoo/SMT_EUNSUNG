import { bomLeafSql, pickExplodeTop, wipCountedSql, wipMovedSql, wipPendingPackWhere } from './wip-bom';
import { classifyWipRows } from './wip-stocktake.service';

describe('pickExplodeTop', () => {
  const lastPack = new Map([['TOP_A', '2026-10-08'], ['TOP_B', '2026-09-01'], ['PROD', '2026-10-01']]);

  it('포장 실적이 있는 제품은 자기 BOM 전체로 푼다', () => {
    expect(pickExplodeTop('PROD', ['PROD', 'TOP_A'], lastPack)).toBe('PROD');
  });

  it('반제품은 그것을 쓰는 제품 BOM 으로 풀고, 여러 제품이면 가장 최근에 포장한 제품을 고른다', () => {
    expect(pickExplodeTop('SEMI', ['TOP_B', 'TOP_A'], lastPack)).toBe('TOP_A');
  });

  it('자기 BOM 이 있어도 포장 실적이 없고 다른 제품에 쓰이면 그 제품 BOM 으로 푼다 (생산투입과 같게)', () => {
    expect(pickExplodeTop('SUB', ['SUB', 'TOP_B'], lastPack)).toBe('TOP_B');
  });

  it('자기 BOM 만 있으면 자기 BOM, 어디에도 없으면 원자재(null)', () => {
    expect(pickExplodeTop('ONLY', ['ONLY'], lastPack)).toBe('ONLY');
    expect(pickExplodeTop('RAW', [], lastPack)).toBeNull();
  });
});

describe('wip-bom SQL', () => {
  it('생산투입 대기는 입고됐는데 안 뺀 박스와, 입고취소됐는데 이미 뺀 2026-10 이후 박스다', () => {
    const w = wipPendingPackWhere('p');
    expect(w).toMatch(/p\.RECEIPT_FLAG = 'Y' AND NVL\(p\.WIP_PROCESS_FLAG, 'N'\) = 'N'/);
    expect(w).toMatch(/NVL\(p\.RECEIPT_FLAG, 'N'\) = 'N' AND p\.WIP_PROCESS_FLAG = 'Y'/);
    expect(w).toContain(`DATE '2026-10-01'`);
  });

  it('BOM 전개는 자체 생산 반제품을 말단에서 빼는 생산투입 규칙을 쓴다', () => {
    const sql = bomLeafSql('SELECT 1 AS TOP_ITEM, 1 AS NODE, 1 AS QTY FROM DUAL');
    expect(sql).toMatch(/NOT EXISTS \(SELECT 1 FROM ID_ENG_BOM m\s+WHERE m\.ITEM_CODE = t\.child/);
    expect(sql.trim().startsWith('WITH')).toBe(true);
  });

  it('실사수량은 자재 입력은 그대로, 반제품·제품·박스 입력은 풀어서 더한다', () => {
    expect(wipCountedSql).toContain(`e.WORKSTAGE_CODE = '*'`);
    expect(wipCountedSql).toContain(`e.WORKSTAGE_CODE <> '*'`);
  });

  it('고정 뒤 입고된 박스는 실사에서 센 박스를 빼고 장부 비교에서 뺀다', () => {
    expect(wipMovedSql).toMatch(/WIP_PROCESS_DATE > \(SELECT MIN\(c\.ENTER_DATE\)/);
    expect(wipMovedSql).toMatch(/NOT EXISTS \(SELECT 1 FROM IM_ITEM_WS_INVE_CHECK_EXCEL e/);
  });
});

describe('classifyWipRows — 박스·반제품', () => {
  const input = (o: Partial<{ barcode: string; itemCode: string; qty: number }>) => [{
    rn: 1, barcode: o.barcode ?? null, lotNo: null, itemCode: o.itemCode ?? null, qty: o.qty ?? null, lineCode: null,
  }];

  it('입고 안 한 박스는 박스 수량으로 그 제품을 세고 제품 BOM 으로 푼다', () => {
    const { entries, errors } = classifyWipRows(input({ barcode: 'BOX1' }), [
      { rn: 1, itemCode: 'PROD', scanQty: 120, lineType: 'A', boxKey: '#B123', receiptFlag: 'N', wipFlag: 'N' },
    ]);
    expect(errors).toEqual([]);
    expect(entries[0]).toMatchObject({ itemCode: 'PROD', mfs: '#B123', qty: 120, top: 'PROD', box: true });
  });

  it('창고에 입고된 박스와 자재가 이미 빠진 옛 박스는 받지 않는다', () => {
    const received = classifyWipRows(input({ barcode: 'BOX1' }), [
      { rn: 1, itemCode: 'PROD', scanQty: 1, boxKey: '#B1', receiptFlag: 'Y', wipFlag: 'Y' },
    ]);
    expect(received.errors[0].reason).toContain('입고된 박스');
    const old = classifyWipRows(input({ barcode: 'BOX2' }), [
      { rn: 1, itemCode: 'PROD', scanQty: 1, boxKey: '#B2', receiptFlag: 'N', wipFlag: 'Y' },
    ]);
    expect(old.errors[0].reason).toContain('자재가 이미 빠진 박스');
  });

  it('품목코드 입력은 고른 제품 BOM 으로 풀고, 풀 제품이 없으면 원자재로 센다', () => {
    const tops = new Map<string, string | null>([['SEMI', 'TOP_A'], ['RAW', null]]);
    const semi = classifyWipRows(input({ itemCode: 'SEMI', qty: 5 }), [{ rn: 1, itemCode: 'SEMI' }], tops);
    expect(semi.entries[0]).toMatchObject({ top: 'TOP_A', mfs: '*', box: false });
    const raw = classifyWipRows(input({ itemCode: 'RAW', qty: 5 }), [{ rn: 1, itemCode: 'RAW' }], tops);
    expect(raw.entries[0].top).toBe('*');
  });

  it('릴 바코드(롯트)는 풀지 않는다', () => {
    const tops = new Map<string, string | null>([['SEMI', 'TOP_A']]);
    const { entries } = classifyWipRows(input({ barcode: 'REEL1' }), [{ rn: 1, itemCode: 'SEMI', lotNo: 'L1', scanQty: 3 }], tops);
    expect(entries[0]).toMatchObject({ top: '*', mfs: 'L1' });
  });
});

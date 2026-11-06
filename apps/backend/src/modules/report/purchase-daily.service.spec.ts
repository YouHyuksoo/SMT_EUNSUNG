import { explodeToMaterials, type BomMap } from './purchase-daily.service';

describe('explodeToMaterials', () => {
  const bom: BomMap = new Map([
    ['FG', [{ child: 'SEMI', qty: 2 }, { child: 'RAW-A', qty: 1 }]],
    ['SEMI', [{ child: 'RAW-A', qty: 3 }, { child: 'RAW-B', qty: 0.5 }]],
  ]);

  it('제품을 여러 단계로 풀어 원자재 수량을 더한다', () => {
    const out = explodeToMaterials(new Map([['FG', 10]]), bom);
    expect(out.get('RAW-A')).toBe(10 * 1 + 10 * 2 * 3);
    expect(out.get('RAW-B')).toBe(10 * 2 * 0.5);
    expect(out.has('SEMI')).toBe(false);
  });

  it('하위 BOM 이 없는 품목은 원자재로 보고 그대로 더한다', () => {
    const out = explodeToMaterials(new Map([['RAW-A', 4]]), bom);
    expect(out.get('RAW-A')).toBe(4);
  });

  it('반품으로 음수가 된 출고도 그대로 풀어 뺀다', () => {
    const out = explodeToMaterials(new Map([['SEMI', -2]]), bom);
    expect(out.get('RAW-A')).toBe(-6);
  });

  it('순환 BOM 이 있어도 멈춘다', () => {
    const loop: BomMap = new Map([['A', [{ child: 'B', qty: 1 }]], ['B', [{ child: 'A', qty: 1 }]]]);
    expect(() => explodeToMaterials(new Map([['A', 1]]), loop)).not.toThrow();
  });
});

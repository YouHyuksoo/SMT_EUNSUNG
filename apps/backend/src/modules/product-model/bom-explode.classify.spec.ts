import { BomEdge, classifyBomExplode, sideOf } from './bom-explode.classify';

const e = (parent: string, child: string, pcbItem?: string): BomEdge => ({ parent, child, pcbItem });
const names = (m: Record<string, string>) => new Map(Object.entries(m));

describe('sideOf', () => {
  it('BOM 행 면 → 품목명 → 코드 끝 순서로 본다', () => {
    expect(sideOf('X', 'TOP PCB', 'B')).toBe('B');
    expect(sideOf('X', 'CONTROL-BOTTOM', null)).toBe('B');
    expect(sideOf('X', 'TOP PCB ASSY', null)).toBe('T');
    expect(sideOf('M1590-204601-002T', null, null)).toBe('T');
    expect(sideOf('E2040100510', 'PCB ASSY', null)).toBe('');
  });
});

describe('classifyBomExplode', () => {
  it('원자재만 있는 제품은 제품 자신이 생산 품목이고 런카드 면으로 세는 면을 정한다', () => {
    const r = classifyBomExplode('P', [e('P', 'R1'), e('P', 'R2')], names({}), 'T');
    expect(r).toEqual({ type: 'RAW', topItemCode: 'P', bottomItemCode: null, subItemCode: null, note: null });
  });

  it('단면 반제품 하나 — 런카드가 양면이면 각 면을 하나의 모델로 보고 두 면 모두 센다', () => {
    const r = classifyBomExplode('P', [e('P', 'S'), e('S', 'R1'), e('P', 'C')], names({ S: 'PCB ASSY' }), 'BT');
    expect(r.type).toBe('SINGLE');
    expect(r.topItemCode).toBe('S');
    expect(r.bottomItemCode).toBe('S');
    expect(r.note).toContain('양면');
  });

  it('원자재만 — 런카드가 없으면 면을 비우고 메모를 남긴다', () => {
    const r = classifyBomExplode('P', [e('P', 'R1')], names({}), '');
    expect(r.topItemCode).toBeNull();
    expect(r.bottomItemCode).toBeNull();
    expect(r.note).toContain('런카드가 없다');
  });

  it('제품 직하 TOP·BOT', () => {
    const r = classifyBomExplode('P',
      [e('P', 'T1'), e('T1', 'R1'), e('P', 'B1'), e('B1', 'R2')],
      names({ T1: 'TOP PCB ASSY', B1: 'BOT PCB ASSY' }), 'BT');
    expect(r).toEqual({ type: 'TB', topItemCode: 'T1', bottomItemCode: 'B1', subItemCode: null, note: null });
  });

  it('SUB-Assy 아래 TOP·BOT', () => {
    const r = classifyBomExplode('P',
      [e('P', 'SUB'), e('SUB', 'T1'), e('SUB', 'B1'), e('T1', 'R1'), e('B1', 'R2'), e('SUB', 'R3')],
      names({ SUB: 'CONTROL SUB-Assy', T1: 'CONTROL-TOP', B1: 'CONTROL-BOTTOM' }), 'B');
    expect(r.type).toBe('SUB');
    expect(r.topItemCode).toBe('T1');
    expect(r.bottomItemCode).toBe('B1');
    expect(r.subItemCode).toBe('SUB');
    expect(r.note).toContain('B면만');
  });

  it('TOP 안에 BOT', () => {
    const r = classifyBomExplode('P',
      [e('P', 'T1'), e('T1', 'B1'), e('T1', 'R1'), e('B1', 'R2')],
      names({ T1: 'CONTROL TOP', B1: 'CONTROL BOT' }), 'BT');
    expect(r).toMatchObject({ type: 'NEST', topItemCode: 'T1', bottomItemCode: 'B1' });
  });

  it('SMT 반제품 2개 중 한쪽만 면이 있으면 나머지를 반대 면으로 정한다', () => {
    const r = classifyBomExplode('P',
      [e('P', 'M1590-1T'), e('M1590-1T', 'R1'), e('P', 'M1590-2'), e('M1590-2', 'R2')], names({}), 'BT');
    expect(r).toMatchObject({ type: 'TB', topItemCode: 'M1590-1T', bottomItemCode: 'M1590-2' });
    expect(r.note).toContain('반대 면');
  });

  it('면을 가를 수 없는 SMT 반제품이 여럿이면 미분류', () => {
    const r = classifyBomExplode('P',
      [e('P', 'S1'), e('S1', 'R1'), e('P', 'S2'), e('S2', 'R2')], names({ S1: 'PCB ASSY', S2: 'PCB SUB ASSY' }), 'T');
    expect(r.type).toBe('NONE');
    expect(r.note).toContain('SMT 반제품 2개');
  });

  it('BOM 이 없으면 미분류', () => {
    expect(classifyBomExplode('P', [], names({}), '').type).toBe('NONE');
  });
});

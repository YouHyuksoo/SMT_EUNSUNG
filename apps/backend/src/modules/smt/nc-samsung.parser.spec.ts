import { parseSamsungNc, samsungFeederSlots } from './nc-samsung.parser';

const step = (no: number, ref: string, fdr: string, part: string) =>
  [no, ref, '1.0', '2.0', '0.000', '0.000', fdr, part, '', 'CN040', '1', '1', 'Y', 'N', '1'].join('\t');

const file = [
  '[Board Information]',
  'Customer:\tLG',
  'Board:\tLINE5 TOP',
  '[Part Information]',
  'No\tPart\tDesc\tShape\tFeeder\tNozzle',
  '1\tP-CAP\tdesc\tCHIP\tSM8MM\tCN040',
  '2\tP-IC\tdesc\tQFP\tTRAY\tCN750',
  '[Step Information]',
  '',
  'Station:\tST1F-Work',
  '',
  'No\tRef\tX\tY\tZ\tR\tFdr\tPart',
  step(1, 'C10', 'F3', 'P-CAP'),
  step(2, 'C1', 'F3', 'P-CAP'),
  step(3, 'C1', 'F3', 'P-CAP'), // 같은 참조번호 두 번 → 한 번만 센다
  step(4, 'R5', 'R12', 'P-RES'),
  step(5, 'U1', 'TRY1', 'P-IC'),
  step(6, 'X1', 'A', 'P-NOZZLE'), // F/R/T/S 가 아니면 버린다
  '',
  'Station:\tST2F-Work',
  'No\tRef',
  step(7, 'C3', 'F3', 'P-CAP'),
  '[Fiducial]',
];

describe('parseSamsungNc', () => {
  const nc = parseSamsungNc(file);

  it('reads the board name after "Board:" keeping the tab (PB Trim removes spaces only)', () => {
    expect(nc.lotName).toBe('\tLINE5 TOP');
  });

  it('reads part information until the next section and step rows across stations', () => {
    expect(nc.parts).toEqual([
      { partName: 'P-CAP', feeder: 'SM8MM' },
      { partName: 'P-IC', feeder: 'TRAY' },
    ]);
    expect(nc.steps.map((s) => s.ref)).toEqual(['C10', 'C1', 'C1', 'R5', 'U1', 'X1', 'C3']);
  });

  it('splits on spaces as well as tabs, like PB replace(" ", tab) + ImportString', () => {
    const spaced = parseSamsungNc(['[Step Information]', '', 'Station:', '', 'No', '1 C7 1 2 0 0 F5 P-X', '[End]']);
    expect(spaced.steps).toEqual([{ ref: 'C7', fdr: 'F5', partName: 'P-X' }]);
  });
});

describe('samsungFeederSlots', () => {
  const slots = samsungFeederSlots(parseSamsungNc(file).steps, 'C');

  it('maps F → start table, R → next table, T/S → tray Z, and joins distinct refs in binary order', () => {
    expect(slots).toEqual([
      { fdr: 'F3', partName: 'P-CAP', tableId: 'C', address: '03', locationInfo: 'C1,C10,C3', itemUnitQty: 3 },
      { fdr: 'R12', partName: 'P-RES', tableId: 'D', address: '12', locationInfo: 'R5', itemUnitQty: 1 },
      { fdr: 'TRY1', partName: 'P-IC', tableId: 'Z', address: 'TRAY01', locationInfo: 'U1', itemUnitQty: 1 },
    ]);
  });
});

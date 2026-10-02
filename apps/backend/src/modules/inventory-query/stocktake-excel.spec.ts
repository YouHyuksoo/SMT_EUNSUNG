import * as XLSX from 'xlsx';
import { parseStocktakeWorkbook } from './stocktake-excel';
import { classifyUploadRows } from './stocktake.service';

const book = (rows: unknown[][]) => {
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, XLSX.utils.aoa_to_sheet(rows), '실사');
  return XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' }) as Buffer;
};

describe('parseStocktakeWorkbook', () => {
  it('머리글을 찾아 바코드·롯트·수량을 읽고 빈 줄은 건너뛴다 (줄 번호는 엑셀 기준)', () => {
    const rows = parseStocktakeWorkbook(book([
      ['자재 실사'],
      ['바코드', '롯트번호', '수량'],
      ['E1750100370-6A203831-3800', '', ''],
      ['', '', ''],
      ['', '13Q70772', '1,200'],
      ['X', '', 'abc'],
    ]));
    expect(rows).toEqual([
      { row: 3, barcode: 'E1750100370-6A203831-3800', lotNo: undefined, itemCode: undefined, qty: undefined },
      { row: 5, barcode: undefined, lotNo: '13Q70772', itemCode: undefined, qty: 1200 },
      { row: 6, barcode: 'X', lotNo: undefined, itemCode: undefined, qty: NaN },
    ]);
  });

  it('바코드·롯트번호 열이 없으면 거절한다', () => {
    expect(() => parseStocktakeWorkbook(book([['품목', '수량']]))).toThrow('바코드');
  });
});

describe('classifyUploadRows', () => {
  const hit = (rn: number, lot: string, scanQty = 100) =>
    ({ rn, itemBarcode: `A-${lot}-${scanQty}`, itemCode: 'A', lotNo: lot, scanQty, labelType: null });

  it('미등록·수량오류·파일 안 중복은 오류로, 나머지는 반영 (수량 비면 바코드 수량)', () => {
    const input = [
      { rn: 3, barcode: 'A-L1-100', lotNo: null, qty: null },
      { rn: 4, barcode: 'NOPE', lotNo: null, qty: null },
      { rn: 5, barcode: null, lotNo: 'L2', qty: NaN },
      { rn: 6, barcode: null, lotNo: 'L1', qty: 5 },
      { rn: 7, barcode: null, lotNo: 'L3', qty: 0 },
      { rn: 8, barcode: null, lotNo: null, qty: 3 },
    ];
    const resolved = [hit(3, 'L1'), { rn: 4 }, hit(5, 'L2'), hit(6, 'L1'), hit(7, 'L3'), { rn: 8 }];
    const { accepted, errors } = classifyUploadRows(input, resolved);
    expect(accepted.map((a) => [a.lotNo, a.qty])).toEqual([['L1', 100], ['L3', 0]]);
    expect(errors.map((e) => e.row)).toEqual([4, 5, 6, 8]);
    expect(errors.find((e) => e.row === 6)?.reason).toContain('겹침');
  });
});

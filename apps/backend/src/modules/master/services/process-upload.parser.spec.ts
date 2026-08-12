import * as XLSX from 'xlsx';
import { parseProcessWorkbook } from './process-upload.parser';

const headers = ['공정코드', '공정명', '공정유형', '시작공정구분', '적용라인코드'];

function workbook(rows: unknown[][], sheetName = '공정마스터'): Buffer {
  const book = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(book, XLSX.utils.aoa_to_sheet([headers, ...rows]), sheetName);
  return XLSX.write(book, { type: 'buffer', bookType: 'xlsx' });
}

describe('parseProcessWorkbook', () => {
  it('selects the named sheet, normalizes codes, and removes exact relation duplicates', () => {
    const book = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(book, XLSX.utils.aoa_to_sheet([['무관'], ['값']]), '입력안내');
    XLSX.utils.book_append_sheet(book, XLSX.utils.aoa_to_sheet([
      headers,
      [' w010 ', ' 마킹 ', '일반', ' y ', '01'],
      ['W010', '마킹', 'I', 'Y', '01'],
      ['W030', 'SPI검사', '검사', 'N', '02'],
    ]), '공정마스터');

    const result = parseProcessWorkbook(XLSX.write(book, { type: 'buffer', bookType: 'xlsx' }));

    expect(result.inputRows).toBe(3);
    expect(result.duplicateRows).toBe(1);
    expect(result.processes).toEqual([
      { processCode: 'W010', processName: '마킹', processType: 'I', startYn: 'Y', sortOrder: 10 },
      { processCode: 'W030', processName: 'SPI검사', processType: 'Q', startYn: 'N', sortOrder: 30 },
    ]);
    expect(result.relations).toHaveLength(2);
  });

  it.each([['최종', 'L'], ['Q', 'Q']])('maps process type %s to %s', (source, expected) => {
    expect(parseProcessWorkbook(workbook([['W100', '검사', source, 'N', '21']])).processes[0].processType).toBe(expected);
  });

  it('rejects a missing 공정마스터 sheet', () => {
    expect(() => parseProcessWorkbook(workbook([['W010', '마킹', '일반', 'Y', '01']], 'Sheet1')))
      .toThrow('공정마스터');
  });

  it('validates same-process startYn before deduplicating an identical relation key', () => {
    try {
      parseProcessWorkbook(workbook([
        ['W010', '마킹', '일반', 'Y', '01'],
        ['W010', '마킹', '일반', 'N', '01'],
      ]));
      throw new Error('expected parser rejection');
    } catch (error: unknown) {
      expect(JSON.stringify(error)).toContain('시작공정구분');
    }
  });

  it('collects invalid required fields and rejects codes without a numeric sort component', () => {
    expect(() => parseProcessWorkbook(workbook([
      ['ABC', '', 'unknown', 'X', ''],
    ]))).toThrow('업로드 데이터');
  });
});

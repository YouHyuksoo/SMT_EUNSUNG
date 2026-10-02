/**
 * @file src/modules/inventory-query/stocktake-excel.ts
 * @description 바코드 실사 엑셀 읽기 — 첫 시트에서 바코드·롯트번호·품목코드·수량 열을 찾는다
 *
 * 초보자 가이드:
 * 1. 머리글 줄은 위에서 20줄 안에 있어야 하고, "바코드" 나 "롯트번호" 중 하나는 있어야 한다.
 * 2. 수량 칸을 비우면 바코드 수량으로 센다. 숫자가 아니면 그 줄은 오류로 돌려준다(NaN 으로 넘긴다).
 * 3. 빈 줄은 건너뛴다. 줄 번호는 엑셀의 실제 줄 번호다.
 */
import { BadRequestException } from '@nestjs/common';
import * as XLSX from 'xlsx';
import type { StocktakeUploadRow } from './stocktake.service';

const HEADERS = {
  barcode: ['바코드', '자재바코드', 'BARCODE', 'ITEM_BARCODE'],
  lotNo: ['롯트번호', '롯트', 'LOT', 'LOT_NO', 'LOTNO'],
  itemCode: ['품목코드', 'ITEM_CODE', 'ITEMCODE'],
  qty: ['수량', '실사수량', 'QTY'],
} as const;

const norm = (v: unknown) => String(v ?? '').replace(/\s/g, '').toUpperCase();

export function parseStocktakeWorkbook(buffer: Buffer): StocktakeUploadRow[] {
  const book = XLSX.read(buffer, { type: 'buffer' });
  const sheet = book.Sheets[book.SheetNames[0]];
  if (!sheet) throw new BadRequestException('시트가 없습니다.');
  const grid = XLSX.utils.sheet_to_json<unknown[]>(sheet, { header: 1, defval: '', raw: true });

  const find = (row: unknown[], names: readonly string[]) =>
    row.findIndex((c) => names.some((n) => norm(c) === norm(n)));
  const headerAt = grid.slice(0, 20).findIndex((row) =>
    find(row, HEADERS.barcode) >= 0 || find(row, HEADERS.lotNo) >= 0);
  if (headerAt < 0) throw new BadRequestException('머리글에 "바코드" 또는 "롯트번호" 열이 없습니다.');
  const head = grid[headerAt];
  const col = {
    barcode: find(head, HEADERS.barcode),
    lotNo: find(head, HEADERS.lotNo),
    itemCode: find(head, HEADERS.itemCode),
    qty: find(head, HEADERS.qty),
  };
  const cell = (row: unknown[], i: number) => (i >= 0 ? String(row[i] ?? '').trim() : '');

  const rows: StocktakeUploadRow[] = [];
  for (let i = headerAt + 1; i < grid.length; i += 1) {
    const r = grid[i];
    const barcode = cell(r, col.barcode);
    const lotNo = cell(r, col.lotNo);
    const itemCode = cell(r, col.itemCode);
    const qtyText = cell(r, col.qty).replace(/,/g, '');
    if (!barcode && !lotNo && !itemCode && !qtyText) continue;
    rows.push({
      row: i + 1,
      barcode: barcode || undefined,
      lotNo: lotNo || undefined,
      itemCode: itemCode || undefined,
      qty: qtyText === '' ? undefined : Number(qtyText),
    });
  }
  return rows;
}

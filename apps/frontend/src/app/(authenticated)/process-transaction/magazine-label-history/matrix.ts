import type { MagazineLabelHistoryRow } from './types';

const day = (value: string | null) => value ? String(value).slice(0, 10) : '-';
export const matrixColumnKey = (row: MagazineLabelHistoryRow) => `${day(row.receiptDate)} · ${row.magazineLabelType ?? '-'}`;

export function pivotMagazineMatrix(rows: MagazineLabelHistoryRow[]) {
  const groups = new Map<string, MagazineLabelHistoryRow>();
  for (const row of rows) {
    const groupKey = [row.lineCode, row.runNo, row.modelName, row.pcbItem].join('\u0000');
    const current = groups.get(groupKey) ?? {
      lineCode: row.lineCode, lineName: row.lineName, runNo: row.runNo,
      modelName: row.modelName, pcbItem: row.pcbItem,
      // 매트릭스는 라인 단위 집계라 공정은 묶이지 않는다.
      workstageCode: null, workstageName: null,
      magazineLabelType: null, receiptDate: null, lotQty: 0,
    };
    const columnKey = matrixColumnKey(row);
    current[columnKey] = Number(current[columnKey] ?? 0) + Number(row.lotQty ?? 0);
    current.lotQty = Number(current.lotQty ?? 0) + Number(row.lotQty ?? 0);
    groups.set(groupKey, current);
  }
  return [...groups.values()];
}

export function matrixColumnKeys(rows: MagazineLabelHistoryRow[]) {
  return [...new Set(rows.map(matrixColumnKey))].sort();
}

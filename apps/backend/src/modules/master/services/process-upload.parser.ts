import { BadRequestException } from '@nestjs/common';
import * as XLSX from 'xlsx';

const REQUIRED_HEADERS = ['공정코드', '공정명', '공정유형', '시작공정구분', '적용라인코드'] as const;
const PROCESS_TYPES: Record<string, string> = { 일반: 'I', 최종: 'L', 검사: 'Q', I: 'I', L: 'L', Q: 'Q' };

export interface ParsedProcess {
  processCode: string;
  processName: string;
  processType: string;
  startYn: string;
  sortOrder: number;
}

export interface ParsedProcessRelation {
  processCode: string;
  processType: string;
  lineCode: string;
}

export interface ProcessUploadParseResult {
  inputRows: number;
  duplicateRows: number;
  processes: ParsedProcess[];
  relations: ParsedProcessRelation[];
}

interface UploadError {
  row: number;
  field: string;
  value: unknown;
  message: string;
}

function text(value: unknown): string {
  return String(value ?? '').trim();
}

export function parseProcessWorkbook(buffer: Buffer): ProcessUploadParseResult {
  const workbook = XLSX.read(buffer, { type: 'buffer' });
  const sheet = workbook.Sheets['공정마스터'];
  if (!sheet) throw new BadRequestException('공정마스터 시트를 찾을 수 없습니다.');

  const raw = XLSX.utils.sheet_to_json<unknown[]>(sheet, { header: 1, defval: '', raw: false });
  const header = (raw[0] ?? []).map(text);
  const errors: UploadError[] = [];
  for (const required of REQUIRED_HEADERS) {
    if (!header.includes(required)) errors.push({ row: 1, field: required, value: '', message: `필수 헤더가 없습니다: ${required}` });
  }
  if (errors.length) throw new BadRequestException({ message: '업로드 데이터가 올바르지 않습니다.', errors });

  const indexes = Object.fromEntries(REQUIRED_HEADERS.map((name) => [name, header.indexOf(name)])) as Record<(typeof REQUIRED_HEADERS)[number], number>;
  const parsed: Array<ParsedProcess & { lineCode: string; row: number }> = [];
  for (let index = 1; index < raw.length; index += 1) {
    const source = raw[index] ?? [];
    if (source.every((value) => text(value) === '')) continue;
    const row = index + 1;
    const processCode = text(source[indexes['공정코드']]).toUpperCase();
    const processName = text(source[indexes['공정명']]);
    const rawType = text(source[indexes['공정유형']]);
    const processType = PROCESS_TYPES[rawType] ?? '';
    const startYn = text(source[indexes['시작공정구분']]).toUpperCase();
    const lineCode = text(source[indexes['적용라인코드']]);
    const numeric = processCode.match(/\d+/)?.[0];

    if (!processCode) errors.push({ row, field: '공정코드', value: processCode, message: '공정코드는 필수입니다.' });
    else if (!numeric) errors.push({ row, field: '공정코드', value: processCode, message: '공정코드에 정렬용 숫자가 필요합니다.' });
    if (!processName) errors.push({ row, field: '공정명', value: processName, message: '공정명은 필수입니다.' });
    if (!processType) errors.push({ row, field: '공정유형', value: rawType, message: '공정유형은 일반/최종/검사 또는 I/L/Q여야 합니다.' });
    if (!['Y', 'N'].includes(startYn)) errors.push({ row, field: '시작공정구분', value: startYn, message: '시작공정구분은 Y 또는 N이어야 합니다.' });
    if (!lineCode) errors.push({ row, field: '적용라인코드', value: lineCode, message: '적용라인코드는 필수입니다.' });
    if (processCode && numeric && processName && processType && ['Y', 'N'].includes(startYn) && lineCode) {
      parsed.push({ processCode, processName, processType, startYn, lineCode, sortOrder: Number(numeric), row });
    }
  }

  const masterByCode = new Map<string, ParsedProcess>();
  for (const item of parsed) {
    const existing = masterByCode.get(item.processCode);
    if (existing && (existing.processName !== item.processName || existing.processType !== item.processType || existing.startYn !== item.startYn)) {
      const field = existing.startYn !== item.startYn ? '시작공정구분' : existing.processType !== item.processType ? '공정유형' : '공정명';
      errors.push({ row: item.row, field, value: item[field === '공정명' ? 'processName' : field === '공정유형' ? 'processType' : 'startYn'], message: `같은 공정코드의 ${field} 값이 서로 다릅니다.` });
    } else if (!existing) {
      masterByCode.set(item.processCode, { processCode: item.processCode, processName: item.processName, processType: item.processType, startYn: item.startYn, sortOrder: item.sortOrder });
    }
  }
  if (errors.length) throw new BadRequestException({ message: '업로드 데이터가 올바르지 않습니다.', errors });

  const relationByKey = new Map<string, ParsedProcessRelation>();
  for (const item of parsed) relationByKey.set(`${item.processCode}|${item.processType}|${item.lineCode}`, { processCode: item.processCode, processType: item.processType, lineCode: item.lineCode });
  return {
    inputRows: parsed.length,
    duplicateRows: parsed.length - relationByKey.size,
    processes: [...masterByCode.values()],
    relations: [...relationByKey.values()],
  };
}

/**
 * @file src/modules/smt/nc-samsung.parser.ts
 * @description 삼성 마운터 NC 파일 → 피더 배치(IB_MNT_PLANDATA) 줄 — PB w_smt_upload_nc_master.wf_samsung 이식
 *
 * 초보자 가이드:
 * 1. **파일은 섹션으로 나뉜다.** `[Board Information]`(보드명), `[Part Information]`(부품별 피더 종류),
 *    `[Step Information]`(장착 스텝: 참조번호·피더·부품) 세 곳만 읽는다.
 * 2. **한 줄은 공백을 탭으로 바꿔 탭으로 자른다.** PB 가 `f_replace_string(줄,' ','~t')` 후 ImportString 했다.
 *    공백이 두 개 붙어 있으면 빈 칸이 생겨 뒤 칸이 밀린다 — PB 와 같은 결과를 내려고 그대로 따른다.
 * 3. **피더 → 테이블·번지.** 피더 표기 첫 글자가 F/R/T/S 인 스텝만 쓴다.
 *    F12 → 시작 테이블, 번지 12 / R12 → 시작 테이블 다음 글자 / T·S 로 시작하고 4자 이상 → 트레이(Z, TRAY01).
 *    규칙에 안 맞는 표기는 바로 앞 줄의 테이블·번지를 그대로 쓴다 (PB 변수 재사용 동작).
 * 4. **참조번호 묶음.** 같은 부품·같은 피더의 참조번호를 중복 없이 이름순으로 이어 붙이고(C1,C10,C3) 그 개수가 수량이다.
 * 5. 품번을 품목코드로 바꾸는 일(공급처 품번 → ID_ITEM)과 피더 종류 찾기는 DB 가 필요해 서비스가 한다.
 */

export interface SamsungPartInfo {
  partName: string;
  feeder: string | null;
}

export interface SamsungStep {
  ref: string;
  fdr: string;
  partName: string;
}

export interface SamsungNcFile {
  lotName: string;
  parts: SamsungPartInfo[];
  steps: SamsungStep[];
}

/** 피더 한 자리 — 같은 부품·같은 피더의 스텝 묶음 */
export interface SamsungFeederSlot {
  fdr: string;
  partName: string;
  tableId: string;
  address: string;
  locationInfo: string;
  itemUnitQty: number;
}

/** PB 의 공백→탭 치환 후 탭 분리. 빈 칸은 null 이 아니라 '' 로 둔다 (ImportString 은 빈 문자열). */
const cells = (line: string) => line.replace(/ /g, '\t').split('\t');
/** PB Trim — 앞뒤 공백만 지운다 (탭은 남는다) */
const pbTrim = (value: string) => value.replace(/^ +| +$/g, '');
/** PB Integer(string) — 숫자가 아니면 0 */
const pbInteger = (value: string) => {
  const t = value.trim();
  return /^[+-]?\d+$/.test(t) ? parseInt(t, 10) : 0;
};
/** PB String(n, '00') */
const pad2 = (n: number) => (n < 0 ? `-${String(-n).padStart(2, '0')}` : String(n).padStart(2, '0'));
/** PB Mid(s, start, len) — 1부터 센다 */
const mid = (s: string, start: number, len = Number.MAX_SAFE_INTEGER) => s.substring(start - 1, start - 1 + len);

/**
 * 파일 본문(줄 배열) → 보드명·부품정보·스텝.
 * PB 의 읽기 순서를 그대로 따른다: 한 줄을 읽고 Board → Part → Step 순으로 같은 줄을 검사한다.
 * Part 섹션은 빈 줄이나 '[' 로 시작하는 줄에서 멈추고, 멈춘 그 줄이 바로 '[Step Information]' 이면 이어서 처리한다.
 */
export function parseSamsungNc(lines: string[]): SamsungNcFile {
  let i = 0;
  const eof = () => i >= lines.length;
  const read = () => (eof() ? null : lines[i++]);
  const result: SamsungNcFile = { lotName: '', parts: [], steps: [] };

  while (!eof()) {
    let text = read() ?? '';

    if (text === '[Board Information]') {
      read(); // Customer:
      text = read() ?? ''; // Board:
      result.lotName = pbTrim(mid(text, 7, 100));
    }

    if (text === '[Part Information]') {
      read(); // 제목 줄
      let line = read();
      while (line !== null && line !== '' && mid(line, 1, 1) !== '[') {
        const c = cells(line);
        result.parts.push({ partName: c[1] ?? '', feeder: c[4] ?? null });
        line = read();
      }
      text = line ?? '';
    }

    if (text === '[Step Information]') {
      read(); // 빈 줄
      read(); // Station: ...
      read(); // 빈 줄
      read(); // 제목 줄
      let line = read();
      while (line !== null && mid(line, 1, 1) !== '[') {
        if (!(line === '' || mid(line, 1, 7) === 'Station' || mid(line, 1, 2) === 'No')) {
          const c = cells(line);
          result.steps.push({ ref: c[1] ?? '', fdr: c[6] ?? '', partName: c[7] ?? '' });
        }
        line = read();
      }
      // '[' 줄은 다음 바퀴에서 다시 읽지 않는다 — PB 도 그 줄을 이미 소비했다.
    }
  }
  return result;
}

/**
 * 스텝 → 피더 자리. PB 커서(`GROUP BY partname, fdr` + `substr(fdr,1,1) in ('F','R','T','S')`)와 같은 묶음이다.
 * 테이블·번지는 앞 자리 값을 이어받을 수 있어 순서가 결과에 영향을 준다 — 피더·부품 이름순으로 고정한다.
 */
export function samsungFeederSlots(steps: SamsungStep[], startTableId: string): SamsungFeederSlot[] {
  const groups = new Map<string, { fdr: string; partName: string; refs: Set<string> }>();
  for (const s of steps) {
    if (!['F', 'R', 'T', 'S'].includes(s.fdr.charAt(0))) continue;
    const key = `${s.fdr}\u0000${s.partName}`;
    const g = groups.get(key) ?? { fdr: s.fdr, partName: s.partName, refs: new Set<string>() };
    g.refs.add(s.ref);
    groups.set(key, g);
  }
  const start = startTableId.charCodeAt(0);
  const table = (offset: number) => String.fromCharCode(start + offset);

  let tableId = '';
  let address = '';
  const slots: SamsungFeederSlot[] = [];
  const ordered = [...groups.values()].sort((a, b) => (a.fdr === b.fdr ? cmp(a.partName, b.partName) : cmp(a.fdr, b.fdr)));
  for (const g of ordered) {
    const fdr = g.fdr;
    if (fdr.length <= 3) {
      if (mid(fdr, 1, 1) === 'F') { tableId = table(0); address = pad2(pbInteger(mid(fdr, 2, 2))); }
      if (mid(fdr, 1, 1) === 'R') { tableId = table(1); address = pad2(pbInteger(mid(fdr, 2, 2))); }
    } else if (mid(fdr, 1, 2) === '1F') { tableId = table(0); address = pad2(pbInteger(mid(fdr, 4, 2))); }
    else if (mid(fdr, 1, 2) === '1R') { tableId = table(1); address = pad2(pbInteger(mid(fdr, 4, 2))); }
    else if (mid(fdr, 1, 2) === '2F') { tableId = table(2); address = pad2(pbInteger(mid(fdr, 4, 2))); }
    else if (mid(fdr, 1, 2) === '2R') { tableId = table(3); address = pad2(pbInteger(mid(fdr, 4, 2))); }
    else if (mid(fdr, 1, 1) === 'T' || mid(fdr, 1, 1) === 'S') { tableId = 'Z'; address = `TRAY${pad2(pbInteger(mid(fdr, 4, 1)))}`; }

    // 참조번호: 이 부품의 이 피더 스텝만, 중복 없이 이름순 (Oracle LISTAGG ... ORDER BY REF, 이진 정렬)
    const refs = [...g.refs].sort(cmp);
    slots.push({ fdr, partName: g.partName, tableId, address, locationInfo: refs.join(','), itemUnitQty: refs.length });
  }
  return slots;
}

/** Oracle 이진 정렬과 같은 비교 (ASCII 범위에서 바이트 순서) */
function cmp(a: string, b: string) {
  return a < b ? -1 : a > b ? 1 : 0;
}

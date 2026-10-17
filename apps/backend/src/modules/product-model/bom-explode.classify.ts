/**
 * @file src/modules/product-model/bom-explode.classify.ts
 * @description 제품별 BOM 전개 방식 자동 분류 (순수 함수)
 *
 * 초보자 가이드:
 * 1. AOI 실적이 어느 반제품을 만들었는지, 제품 입고 때 무엇을 소비하는지를 정하려고 제품 BOM 모양을 나눈다.
 *    설계: docs/specs/2026-10-17-wip-semi-product-from-aoi-design.md (5장 1).
 * 2. 반제품 = 이 제품 BOM 안에서 자식이 있는 노드. SMT 반제품 = 자식이 전부 말단(원자재)인 반제품.
 * 3. 면은 BOM 행의 PCB_ITEM(T/B) → 품목명(BOT·BOTTOM / TOP) → 코드 끝(숫자 뒤 T/B) 순서로 본다.
 *    BOM 의 PCB_ITEM 은 10,495행 중 137행에만 있다 (2026-10-17 실측).
 * 4. 결과의 topItemCode/bottomItemCode 는 그 면 AOI 실적이 만드는 품목이다.
 *    subItemCode 는 SUB 공정 품목(SUB-Assy) — SUB-Assy 아래 TOP·BOT 구조에서만 채운다.
 *    단면·원자재만은 한쪽만 채운다 — 채운 면의 AOI 만 실적으로 센다.
 *    어느 면인지는 최근 SMT 런카드 면으로 정하고, 양면이거나 런이 없으면 비워 두고 메모를 남긴다.
 */

export type BomExplodeType = 'TB' | 'SUB' | 'NEST' | 'SINGLE' | 'RAW' | 'NONE';

export interface BomEdge {
  parent: string;
  child: string;
  /** BOM 행의 면 (T/B, 없으면 빈 값) */
  pcbItem?: string | null;
}

export interface BomExplodeResult {
  type: BomExplodeType;
  topItemCode: string | null;
  bottomItemCode: string | null;
  /** SUB 공정 품목 (SUB-Assy). 모델 마스터 INSERT_ITEM_CODE 에 저장한다 */
  subItemCode: string | null;
  note: string | null;
}

type Side = 'T' | 'B' | '';

/** 품목 면 판정 — BOM 행 면 → 품목명 → 코드 끝 */
export function sideOf(code: string, name: string | null | undefined, pcbItem?: string | null): Side {
  const pcb = (pcbItem ?? '').trim().toUpperCase();
  if (pcb === 'T' || pcb === 'B') return pcb;
  const n = (name ?? '').toUpperCase();
  if (n.includes('BOT')) return 'B';
  if (n.includes('TOP')) return 'T';
  if (/\dT$/.test(code)) return 'T';
  if (/\dB$/.test(code)) return 'B';
  return '';
}

/**
 * 한 제품의 BOM 전개 방식.
 * @param top 제품 품목코드
 * @param edges 그 제품 BOM 의 (부모 → 자식) 행. 자기 자신을 가리키는 행은 빼고 넘긴다.
 * @param names 품목명
 * @param runSides 최근 SMT 런카드 면 (예: 'T', 'B', 'BT', '')
 */
export function classifyBomExplode(
  top: string,
  edges: BomEdge[],
  names: Map<string, string | null>,
  runSides: string,
): BomExplodeResult {
  const kids = new Map<string, BomEdge[]>();
  for (const e of edges) {
    if (e.child === e.parent) continue;
    const list = kids.get(e.parent) ?? [];
    list.push(e);
    kids.set(e.parent, list);
  }
  const childrenOf = (p: string) => kids.get(p) ?? [];
  const isSemi = (c: string) => childrenOf(c).length > 0;
  const isSmt = (c: string) => isSemi(c) && childrenOf(c).every((k) => !isSemi(k.child));

  // 제품 아래 노드 전부 (얕은 쪽 면 표시를 쓴다)
  const side = new Map<string, Side>();
  const seen = new Set<string>();
  const walk = (p: string) => {
    for (const e of childrenOf(p)) {
      if (!side.has(e.child)) side.set(e.child, sideOf(e.child, names.get(e.child), e.pcbItem));
      if (seen.has(e.child)) continue;
      seen.add(e.child);
      walk(e.child);
    }
  };
  walk(top);

  const sides = [...new Set(runSides.split(''))].filter((s) => s === 'T' || s === 'B').sort().join('');
  // 메모용 "코드(품목명)" — 품목명이 없으면 코드만
  const label = (c: string) => (names.get(c) ? `${c}(${names.get(c)})` : c);
  const result = (type: BomExplodeType, t: string | null, b: string | null, note: string | null = null): BomExplodeResult =>
    ({ type, topItemCode: t, bottomItemCode: b, subItemCode: null, note });
  // 양면 구조인데 런카드가 한 면뿐이면 알려 준다
  const twoSided = (type: BomExplodeType, t: string, b: string) =>
    result(type, t, b, sides && sides !== 'BT' ? `최근 SMT 런카드는 ${sides}면만 있다` : null);
  // 단면·원자재만 — 런카드 면으로 세는 면을 정한다.
  // 런카드가 양면이면 각 면을 하나의 모델 생산으로 보고 두 면 모두 같은 품목으로 센다
  // (공정재고는 P_ASSY_RESULT_ADD 가 TOP = BOTTOM 품목이면 면마다 절반씩 움직인다).
  const oneSided = (type: BomExplodeType, item: string) => {
    if (sides === 'T') return result(type, item, null);
    if (sides === 'B') return result(type, null, item);
    if (sides === 'BT') return result(type, item, item, '런카드가 양면이다 — 면마다 실적을 세고 공정재고는 면마다 절반씩 움직인다');
    return result(type, null, null, `최근 SMT 런카드가 없다 — 실적을 셀 면에 ${label(item)}을 지정한다`);
  };

  if (side.size === 0) return result('NONE', null, null, 'BOM 없음');
  const semis = [...side.keys()].filter(isSemi);
  if (semis.length === 0) return oneSided('RAW', top);
  const smts = semis.filter(isSmt);
  const direct = childrenOf(top).map((e) => e.child);
  const directSemis = direct.filter(isSemi);
  const sided = (list: string[], s: Side) => list.filter((c) => side.get(c) === s);

  // ③ TOP 안에 BOT
  for (const c of semis) {
    if (side.get(c) !== 'T') continue;
    const inner = childrenOf(c).map((e) => e.child).filter((k) => isSemi(k) && side.get(k) === 'B');
    if (inner.length) return twoSided('NEST', c, inner[0]);
  }
  // ① 제품 직하 TOP·BOT
  const t1 = sided(directSemis, 'T');
  const b1 = sided(directSemis, 'B');
  if (t1.length === 1 && b1.length === 1) return twoSided('TB', t1[0], b1[0]);
  // ② SUB-Assy(면 없음) 하나 아래 TOP·BOT
  if (directSemis.length === 1 && !side.get(directSemis[0])) {
    const inner = childrenOf(directSemis[0]).map((e) => e.child).filter(isSemi);
    const t2 = sided(inner, 'T');
    const b2 = sided(inner, 'B');
    if (t2.length === 1 && b2.length === 1) return { ...twoSided('SUB', t2[0], b2[0]), subItemCode: directSemis[0] };
  }
  // 소거: SMT 반제품 2개 중 한쪽만 면이 있으면 나머지는 반대 면
  if (smts.length === 2) {
    const [a, b] = smts;
    const sa = side.get(a) ?? '';
    const sb = side.get(b) ?? '';
    if ((sa && !sb) || (!sa && sb)) {
      const known = sa ? a : b;
      const other = sa ? b : a;
      const [t, bot] = side.get(known) === 'T' ? [known, other] : [other, known];
      const type: BomExplodeType = directSemis.includes(t) && directSemis.includes(bot) ? 'TB' : 'SUB';
      const r = twoSided(type, t, bot);
      return {
        ...r,
        subItemCode: type === 'SUB' && directSemis.length === 1 ? directSemis[0] : null,
        note: [`${other} 면은 다른 반제품의 반대 면으로 정했다`, r.note].filter(Boolean).join(' · '),
      };
    }
  }
  // ④ 단면 반제품 하나
  if (smts.length === 1) return oneSided('SINGLE', smts[0]);
  return result('NONE', null, null,
    `SMT 반제품 ${smts.length}개 · 제품 직하 반제품 ${directSemis.length}개 · TOP ${sided(semis, 'T').length} · BOT ${sided(semis, 'B').length}`);
}

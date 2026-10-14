/**
 * @file src/lib/trace/line-names.ts
 * @description LINE_CODE → IP_PRODUCT_LINE.LINE_NAME 표시 변환.
 */
import { executeQueryByProfile } from '@/lib/trace/db';

const LINE_CODE_KEYS = ['LINE_CODE', 'FROM_LINE_CODE', 'DEST_LINE_CODE'] as const;
const CACHE_TTL_MS = 10 * 60 * 1000;
const cache = new Map<string, { at: number; value: Map<string, string> }>();

export async function loadLineNameMap(profile: string): Promise<Map<string, string>> {
  const hit = cache.get(profile);
  if (hit && Date.now() - hit.at < CACHE_TTL_MS) return hit.value;

  try {
    const rows = await executeQueryByProfile<{ LINE_CODE: string; LINE_NAME: string }>(
      profile,
      `SELECT LINE_CODE, LINE_NAME
         FROM IP_PRODUCT_LINE
        WHERE LINE_CODE IS NOT NULL
          AND LINE_NAME IS NOT NULL`,
    );
    const value = new Map<string, string>();
    for (const row of rows) {
      const code = String(row.LINE_CODE ?? '').trim();
      const name = String(row.LINE_NAME ?? '').trim();
      if (code && name) value.set(code, name);
    }
    cache.set(profile, { at: Date.now(), value });
    return value;
  } catch (err) {
    console.error('[U1추적] 라인명 조회 실패:', (err as Error).message);
    return new Map();
  }
}

export function toLineName(map: Map<string, string>, code: unknown): string {
  const c = code == null ? '' : String(code).trim();
  if (!c) return '';
  return map.get(c) || c;
}

export function applyLineNames(
  row: Record<string, unknown> | null,
  map: Map<string, string>,
): Record<string, unknown> | null {
  if (!row || map.size === 0) return row;
  let changed = false;
  const next: Record<string, unknown> = { ...row };
  for (const key of LINE_CODE_KEYS) {
    if (next[key] == null) continue;
    const name = toLineName(map, next[key]);
    if (name && name !== String(next[key]).trim()) {
      next[key] = name;
      changed = true;
    }
  }
  return changed ? next : row;
}

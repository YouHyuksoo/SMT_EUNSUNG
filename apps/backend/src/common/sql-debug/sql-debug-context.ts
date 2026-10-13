import { AsyncLocalStorage } from 'async_hooks';

export interface SqlDebugQuery {
  sql: string;
  parameters?: unknown[];
  tables: string[];
}

interface SqlDebugContext {
  queries: SqlDebugQuery[];
}

const storage = new AsyncLocalStorage<SqlDebugContext>();
const MAX_QUERIES_PER_REQUEST = 30;

export function runWithSqlDebugContext<T>(callback: () => T): T {
  return storage.run({ queries: [] }, callback);
}

export function getSqlDebugQueries(): SqlDebugQuery[] {
  return storage.getStore()?.queries ?? [];
}

export function recordSqlDebugQuery(sql: string, parameters?: unknown[]): void {
  const store = storage.getStore();
  if (!store || !isSelectSql(sql)) {
    return;
  }

  store.queries.push({
    sql,
    parameters,
    tables: extractSqlTables(sql),
  });

  if (store.queries.length > MAX_QUERIES_PER_REQUEST) {
    store.queries.splice(0, store.queries.length - MAX_QUERIES_PER_REQUEST);
  }
}

/** 조회문 판정 — 앞쪽 주석·여는 괄호를 건너뛰고 SELECT 또는 WITH(CTE)로 시작하면 조회문이다. */
const LEADING_SELECT_PATTERN = /^\s*(?:(?:--[^\n]*(?:\n|$)|\/\*[\s\S]*?\*\/|\()\s*)*(?:SELECT|WITH)\b/i;

function isSelectSql(sql: string): boolean {
  return LEADING_SELECT_PATTERN.test(sql);
}

export function extractSqlTables(sql: string): string[] {
  const tables = new Set<string>();
  const tablePattern = /\b(?:FROM|JOIN)\s+(?:"([^"]+)"|([A-Z_][A-Z0-9_$#]*))/gi;
  let match: RegExpExecArray | null;

  while ((match = tablePattern.exec(sql)) !== null) {
    const table = match[1] ?? match[2];
    if (table) {
      tables.add(table.toUpperCase());
    }
  }

  return [...tables];
}

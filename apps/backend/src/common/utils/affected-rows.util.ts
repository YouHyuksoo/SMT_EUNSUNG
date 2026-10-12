/**
 * @file src/common/utils/affected-rows.util.ts
 * @description INSERT/UPDATE/DELETE 결과에서 영향 행수를 꺼낸다.
 *
 * 초보자 가이드:
 * 1. TypeORM `query(sql, binds)` (Oracle) 는 DML 결과로 **행수 숫자 자체**를 돌려준다.
 *    0행이면 `undefined` 다. `{ rowsAffected }` 객체가 아니다 (TypeORM 0.3 OracleQueryRunner,
 *    2026-09-30 ESDB 실측: 1행 UPDATE → `1`, 0행 → `undefined`).
 * 2. 그래서 `(result as { rowsAffected }).rowsAffected` 는 항상 undefined → 0 이 되어
 *    "정확히 1행" 검사가 저장마다 실패했다. 영향 행수는 반드시 이 함수로 읽는다.
 * 3. oracledb `connection.execute` 결과(`{ rowsAffected }`)와 TypeORM 구조화 결과
 *    (`query(sql, binds, true)` → `{ affected }`)도 같은 함수로 읽는다.
 */
export function affectedRows(result: unknown): number {
  if (typeof result === 'number') return result;
  if (result && typeof result === 'object') {
    const r = result as { rowsAffected?: unknown; affected?: unknown };
    const value = r.rowsAffected ?? r.affected;
    const n = Number(value ?? 0);
    return Number.isFinite(n) ? n : 0;
  }
  return 0;
}

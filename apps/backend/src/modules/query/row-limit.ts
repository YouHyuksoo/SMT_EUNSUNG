/**
 * @file src/modules/query/row-limit.ts
 * @description 조회(M_QUERY) 목록의 행 수 상한.
 *
 * 초보자 가이드:
 * 1. 서비스 SQL 의 `FETCH FIRST ${ROW_LIMIT} ROWS ONLY` 와 컨트롤러가 돌려주는
 *    `meta.rowLimit` 이 같은 값을 써야 하므로 한 곳에 둔다.
 * 2. 상한에 닿으면 `truncated` 를 참으로 돌려준다 (규칙은 src/shared/row-limit.ts).
 */
export const ROW_LIMIT = 5000;

/**
 * @file src/shared/row-limit.ts
 * @description 목록 조회 결과 상한과 '잘렸다' 표시.
 *
 * 초보자 가이드:
 * 0. **리포트에서 시작해 자재창고도 쓴다.** 백만행대 원장을 읽는 화면은 다 같은
 *    문제를 갖는다 — 그래서 대분류 폴더가 아니라 여기에 둔다.
 * 1. **목록 조회는 행 수에 상한이 있다.** 원장이 백만행대라 조건이 넓으면 브라우저가
 *    감당할 수 없는 양이 나온다. 그래서 `FETCH FIRST ${ROW_LIMIT} ROWS ONLY` 를 둔다.
 * 2. **잘렸다는 사실을 반드시 함께 돌려준다.** 이것이 이 파일이 있는 이유다.
 *    잘린 것을 알려주지 않으면 화면이 "입고수량 합계", "미스 금액 합계" 를
 *    **잘린 창 안의 값으로 계산해 전체 합계처럼** 보여준다. 리포트에서는 느린 것보다
 *    이게 위험하다 — 숫자가 틀렸는데 틀린 줄 모른다.
 * 3. **판정은 `>= ROW_LIMIT` 이다.** 정확히 상한에 닿았으면 더 있을 수 있다고 본다
 *    (딱 맞아떨어진 경우를 잘렸다고 말하는 쪽이 안전하다).
 */

/** 리포트 한 번에 내보내는 최대 행 수. */
export const ROW_LIMIT = 10000;

/** 리포트 조회 결과. `truncated` 가 참이면 합계를 전체 합계로 읽으면 안 된다. */
export interface ReportRows<T> {
  data: T[];
  total: number;
  truncated: boolean;
}

/** 조회 결과를 상한 표시와 함께 감싼다. */
export function limited<T>(rows: T[]): ReportRows<T> {
  return { data: rows, total: rows.length, truncated: rows.length >= ROW_LIMIT };
}

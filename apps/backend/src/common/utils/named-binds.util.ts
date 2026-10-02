/**
 * @file src/common/utils/named-binds.util.ts
 * @description TypeORM `query()` 에 Oracle 이름 바인드 객체를 넘기는 단일 통로
 *
 * 초보자 가이드:
 * 1. TypeORM 의 `query(sql, parameters?: any[])` 는 배열만 받는 것처럼 타입이 잡혀 있지만,
 *    Oracle 드라이버(oracledb)는 `{ organizationId: 1 }` 같은 이름 바인드 객체를 그대로 받는다.
 * 2. 그래서 예전에는 호출마다 unknown 을 거치는 이중 캐스팅으로 타입을 속였다(600곳 넘게).
 *    그 우회를 이 함수 하나로 모은다 — 호출부는 `namedBinds({ ... })` 로 쓴다.
 * 3. 값은 바꾸지 않는다. 타입만 TypeORM 시그니처에 맞춘다.
 */
export function namedBinds(binds: object): unknown[] {
  const parameters: unknown = binds;
  return parameters as unknown[];
}

/**
 * @file src/lib/trace/oracle-date.ts
 * @description Oracle DATE 를 화면에 보낼 문자열로 바꾸는 공용 규칙.
 *
 * 초보자 가이드:
 * - node-oracledb 는 시간대 없는 Oracle DATE 를 Node 프로세스 시간대로 해석해 Date 를 만든다.
 * - toISOString() 은 이를 UTC 로 바꾸고 'Z' 를 붙인다. 추적성 화면은 'Z' 만 잘라 표시하므로
 *   서버 시간대만큼(KST 9시간, 멕시코 7시간, 베트남 7시간) 이르게 보였다.
 * - 로컬 필드로 다시 조립하면 서버·브라우저 시간대와 무관하게 DB 에 저장된 벽시계 값이 복원된다.
 * - 결과 'YYYY-MM-DDTHH:mm:ss' 는 고정 길이라 문자열 정렬이 곧 시간순 정렬이다.
 */

/** Oracle DATE → 'YYYY-MM-DDTHH:mm:ss' (DB 벽시계 시각 그대로, 시간대 표기 없음) */
export function toDbWallClock(d: Date): string {
  const p = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}`
    + `T${p(d.getHours())}:${p(d.getMinutes())}:${p(d.getSeconds())}`;
}

/**
 * @file database/oracle-thick.ts
 * @description Oracle thick 클라이언트 초기화.
 *
 * 은성전장 DB 계정(INFINITY21_JSMES)은 구버전 비밀번호 verifier(0x939)를 사용해
 * node-oracledb thin 모드로는 접속할 수 없다(NJS-116/DPY-3015). 따라서 TypeORM이
 * 연결하기 전에 반드시 thick 모드를 켜야 한다. main.ts 최상단에서 1회 호출한다.
 *
 * 탐색 우선순위:
 *   1) ORACLE_CLIENT_LIB_DIR (.env 로 서버별 지정)
 *   2) 개발 PC 기본 경로
 *   3) 시스템 PATH의 Oracle Client 자동 탐색
 */
import oracledb from 'oracledb';
import * as fs from 'fs';

let initialized = false;

export function initOracleThick(): void {
  if (initialized) return;
  initialized = true;

  const explicitPaths = [
    process.env.ORACLE_CLIENT_LIB_DIR,
    'C:\\Util\\WINDOWS.X64_193000_db_home\\bin', // 개발 PC 기본값
  ].filter((p): p is string => Boolean(p));

  for (const libDir of explicitPaths) {
    if (!fs.existsSync(libDir)) continue;
    try {
      oracledb.initOracleClient({ libDir });
      console.log(`[oracle-thick] thick 모드 활성 (libDir=${libDir})`);
      return;
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      if (message.includes('already been initialized')) return;
      console.warn(`[oracle-thick] 초기화 실패 (libDir=${libDir}): ${message}`);
    }
  }

  try {
    oracledb.initOracleClient();
    console.log('[oracle-thick] thick 모드 활성 (PATH 기반 클라이언트)');
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    if (message.includes('already been initialized')) return;
    console.warn(
      `[oracle-thick] Oracle Client를 찾지 못해 thin 모드로 동작합니다. ` +
        `은성 DB(0x939 verifier) 접속 시 NJS-116이 발생하니 ORACLE_CLIENT_LIB_DIR를 ` +
        `지정하세요. (${message})`,
    );
  }
}

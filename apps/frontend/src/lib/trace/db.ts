/**
 * @file src/lib/trace/db.ts
 * @description 정추적·역추적 SQL 실행 진입점.
 *
 * 초보자 가이드:
 * - 추적 SQL 은 webdisplay 의 U1 추적(같은 Infinity21 테이블)을 가져온 것이라
 *   `executeQueryByProfile(profile, sql, binds)` 형태로 호출한다.
 * - 은성 MES 는 DB 가 하나라서 profile 은 활성 프로필 이름이고, 실제 실행은
 *   lib/db.ts 의 메인 풀(executeQuery)로 한다. profile 은 테이블·컬럼 목록 캐시 키로만 쓰인다.
 * - 서버 전용. 클라이언트 컴포넌트에서 import 하지 않는다 (fs 사용).
 */
import type oracledb from 'oracledb';
import { executeQuery, loadFileConfig } from '@/lib/db';

/** 활성 DB 프로필 이름. config 가 없으면(.env 접속) 'env'. */
export function resolveTraceProfile(): string {
  return loadFileConfig()?.activeProfile ?? 'env';
}

export function executeQueryByProfile<T = Record<string, unknown>>(
  _profile: string,
  sql: string,
  binds: oracledb.BindParameters = {},
): Promise<T[]> {
  return executeQuery<T>(sql, binds);
}

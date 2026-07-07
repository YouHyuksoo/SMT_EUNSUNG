/**
 * @file connect-string.ts
 * @description Oracle connectString 생성 (SID / SERVICE_NAME 구분).
 * 초보자 가이드: 서버(db.ts, API route)와 클라이언트(DatabasePanel 미리보기)가
 *   동일한 connectString을 쓰도록 이 한 곳에서만 생성한다.
 *   oracledb/fs 등 서버 전용 모듈을 import하지 않아 클라이언트에서도 안전하게 사용 가능.
 */
import type { DatabaseConfig } from '@/types/option';

/**
 * DatabaseConfig로부터 Oracle connectString을 생성한다.
 * - SERVICE_NAME: Easy Connect (`host:port/service`). PDB(예: 19c) 접속용.
 * - SID: 전체 디스크립터. 예전 11g(SID 기반) 접속용.
 *   node-oracledb thin mode가 host:port:SID Easy Connect 형식을 받지 않으므로
 *   디스크립터로 명시한다.
 */
export function buildConnectString(cfg: DatabaseConfig): string {
  if (cfg.connectionType === 'SERVICE_NAME') {
    return `${cfg.host}:${cfg.port}/${cfg.sidOrService}`;
  }
  return `(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=${cfg.host})(PORT=${cfg.port}))(CONNECT_DATA=(SID=${cfg.sidOrService})))`;
}

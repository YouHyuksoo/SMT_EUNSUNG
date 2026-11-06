/**
 * @file packages/shared/src/utils/oracle-connect-string.ts
 * @description Oracle 주소(백엔드 ORACLE_HOST, 프론트 DB 프로필 host)에 주소를 여러 개 적으면 앞에서부터 차례로 접속을 시도하는 connectString 을 만든다.
 *
 * 초보자 가이드:
 * 1. `ORACLE_HOST=192.168.175.100,61.105.35.54` 처럼 쉼표로 적으면 내부 주소를 먼저 시도하고,
 *    닿지 않으면 외부 주소로 넘어간다. 공장 안·밖을 오갈 때 .env 를 고치지 않아도 된다.
 * 2. 주소가 하나면 예전과 똑같은 접속 문자열을 만든다 (동작 변화 없음).
 * 3. 닿지 않는 주소는 TRANSPORT_CONNECT_TIMEOUT(초) 만큼만 기다리고 다음 주소로 넘어간다.
 *    풀이 연결을 새로 만들 때만 이 대기가 생기고, 이미 열린 연결은 영향이 없다.
 */
export interface OracleConnectParams {
    /** 쉼표로 구분한 주소 목록. 예: "192.168.175.100,61.105.35.54" */
    host: string;
    port: number | string;
    sid?: string;
    serviceName?: string;
    /** 닿지 않는 주소를 포기하기까지 기다릴 초. */
    timeoutSeconds?: number;
}
/** 쉼표로 적은 주소를 나눈다. 빈 칸과 중복은 뺀다. */
export declare function splitOracleHosts(host: string): string[];
export declare function buildOracleConnectString(params: OracleConnectParams): string;
//# sourceMappingURL=oracle-connect-string.d.ts.map
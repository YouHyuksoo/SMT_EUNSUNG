import { buildOracleConnectString, splitOracleHosts } from '@smt/shared';

describe('buildOracleConnectString', () => {
  it('주소가 하나면 예전 EZConnect 그대로다', () => {
    expect(buildOracleConnectString({ host: '192.168.175.100', port: 1521, serviceName: 'XE' }))
      .toBe('192.168.175.100:1521/XE');
  });

  it('SID 단일 주소는 예전 디스크립터 그대로다', () => {
    expect(buildOracleConnectString({ host: 'h1', port: 1521, sid: 'ORCL' }))
      .toBe('(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=h1)(PORT=1521))(CONNECT_DATA=(SID=ORCL)))');
  });

  it('쉼표 주소는 적은 순서대로 failover 한다', () => {
    const s = buildOracleConnectString({ host: '192.168.175.100, 61.105.35.54', port: 1521, serviceName: 'XE' });
    expect(s).toContain('(FAILOVER=on)(LOAD_BALANCE=off)');
    expect(s.indexOf('192.168.175.100')).toBeLessThan(s.indexOf('61.105.35.54'));
    expect(s).toContain('(TRANSPORT_CONNECT_TIMEOUT=3)');
    expect(s).toContain('(CONNECT_DATA=(SERVICE_NAME=XE))');
  });

  it('빈 칸과 중복 주소는 뺀다', () => {
    expect(splitOracleHosts(' a, ,b,a ')).toEqual(['a', 'b']);
  });
});

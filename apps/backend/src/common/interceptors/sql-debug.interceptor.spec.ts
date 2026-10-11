import { lastValueFrom, Observable } from 'rxjs';
import type { CallHandler, ExecutionContext } from '@nestjs/common';
import { SqlDebugInterceptor } from './sql-debug.interceptor';
import { recordSqlDebugQuery } from '../sql-debug/sql-debug-context';

const contextFor = (method: string, role?: string) =>
  ({
    switchToHttp: () => ({ getRequest: () => ({ method, user: role ? { role } : undefined }) }),
  }) as unknown as ExecutionContext;

/** 핸들러 안에서 SELECT 한 번을 기록하고 성공 응답을 돌려준다 */
const handler: CallHandler = {
  handle: () =>
    new Observable((subscriber) => {
      recordSqlDebugQuery('SELECT * FROM ID_ITEM WHERE ITEM_CODE = :1', ['A']);
      subscriber.next({ success: true, data: [], meta: { total: 0 } });
      subscriber.complete();
    }),
};

describe('SqlDebugInterceptor', () => {
  const interceptor = new SqlDebugInterceptor();
  const run = (method: string, role?: string) =>
    lastValueFrom(interceptor.intercept(contextFor(method, role), handler)) as Promise<{
      meta: Record<string, unknown>;
    }>;

  it('ADMIN 의 GET 응답에는 실행 SQL 을 붙인다', async () => {
    const res = await run('GET', 'ADMIN');
    expect(res.meta.debugSql).toMatchObject({ sql: 'SELECT * FROM ID_ITEM WHERE ITEM_CODE = :1', tables: ['ID_ITEM'] });
  });

  it('ADMIN 이 아니면 붙이지 않는다', async () => {
    expect((await run('GET', 'OPERATOR')).meta.debugSql).toBeUndefined();
    expect((await run('GET')).meta.debugSql).toBeUndefined();
  });

  it('GET 이 아니면 ADMIN 이어도 붙이지 않는다', async () => {
    expect((await run('POST', 'ADMIN')).meta.debugSql).toBeUndefined();
  });
});

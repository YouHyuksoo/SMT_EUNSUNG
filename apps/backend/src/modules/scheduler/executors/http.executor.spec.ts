import { SchedulerJob } from '../../../entities/scheduler-job.entity';
import { HttpExecutor } from './http.executor';

describe('HttpExecutor', () => {
  let executor: HttpExecutor;
  let originalFetch: unknown;

  const baseJob = {
    organizationId: 1,
    jobCode: 'HTTP_JOB',
    execType: 'HTTP',
    execTarget: 'POST https://api.example.com/hooks/sync',
    timeoutSec: 300,
    execParams: null,
  } as SchedulerJob;

  let fetchMock: jest.Mock;

  beforeEach(() => {
    executor = new HttpExecutor();
    originalFetch = (globalThis as { fetch?: unknown }).fetch;
    fetchMock = jest.fn().mockResolvedValue({
      ok: true,
      status: 200,
      statusText: 'OK',
      text: jest.fn().mockResolvedValue('OK'),
    } as any);
    (globalThis as unknown as { fetch: jest.Mock }).fetch = fetchMock;
  });

  afterEach(() => {
    (globalThis as unknown as { fetch?: unknown }).fetch = originalFetch;
  });

  it('should force tenant into body fields when present in execParams', async () => {
    await executor.execute({
      ...baseJob,
      execParams: JSON.stringify({ organizationId: 999, mode: 'test' }),
    });

    const [, options] = fetchMock.mock.calls[0] as [string, any];
    expect(options?.headers).toMatchObject({
      'Content-Type': 'application/json',
      'X-Organization-Id': '1',
    });
    expect(JSON.parse(options.body as string)).toEqual({
      organizationId: 1,
      mode: 'test',
    });
  });

  it('should inject tenant headers even when no execParams exists', async () => {
    await executor.execute(baseJob);

    const [, options] = fetchMock.mock.calls[0] as [string, any];
    expect(options?.headers).toMatchObject({
      'X-Organization-Id': '1',
    });
  });

  it('should reject invalid execParams JSON', async () => {
    await expect(
      executor.execute({
        ...baseJob,
        execParams: '{',
      }),
    ).rejects.toThrow('execParams JSON 파싱 실패');
  });
});

import { ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { JwtAuthGuard } from './jwt-auth.guard';

// 은성전장: Bearer 토큰 = USER_ID, ISYS_USERS + ISYS_ORGANIZATION 으로 사용자/조직을 확정한다.
type UserRecord = {
  userId: string;
  organizationId: number | null;
  userLevel: number | null;
  emailAddress: string | null;
};

const createContext = (
  method: string,
  headers: Record<string, string> = {},
  token = 'USER01',
) => {
  const request: Record<string, unknown> = {
    method,
    headers: {
      authorization: `Bearer ${token}`,
      ...headers,
    },
  };

  const context = {
    switchToHttp: () => ({
      getRequest: () => request,
    }),
    // Reflector.getAllAndOverride 호출에 필요한 핸들러/클래스 참조
    getHandler: () => undefined,
    getClass: () => undefined,
  } as unknown as ExecutionContext;

  return { context, request };
};

const createGuard = (user: UserRecord | null, org: { companyCode: string } | null = { companyCode: 'ES' }) => {
  const userRepository = {
    findOne: jest.fn().mockResolvedValue(user),
  };
  const orgRepository = {
    findOne: jest.fn().mockResolvedValue(org),
  };
  // @Public() 인식용 Reflector — 기본 false (Public 아님)로 답한다.
  const reflector = {
    getAllAndOverride: jest.fn().mockReturnValue(false),
  };

  return {
    guard: new JwtAuthGuard(userRepository as any, orgRepository as any, reflector as any),
    userRepository,
    orgRepository,
    reflector,
  };
};

describe('JwtAuthGuard', () => {
  const operator: UserRecord = {
    userId: 'USER01',
    organizationId: 1,
    userLevel: 1,
    emailAddress: 'user01@example.com',
  };

  it('skips authentication for @Public() handlers', async () => {
    const { guard, reflector, userRepository } = createGuard(operator);
    reflector.getAllAndOverride.mockReturnValue(true);

    await expect(guard.canActivate(createContext('POST', {}, '').context)).resolves.toBe(true);
    expect(userRepository.findOne).not.toHaveBeenCalled();
  });

  it('rejects requests without bearer token', async () => {
    const { guard } = createGuard(operator);
    const { context, request } = createContext('GET');
    (request.headers as Record<string, string>).authorization = '';

    await expect(guard.canActivate(context)).rejects.toBeInstanceOf(UnauthorizedException);
  });

  it('rejects unknown USER_ID token', async () => {
    const { guard } = createGuard(null);

    await expect(guard.canActivate(createContext('GET').context)).rejects.toBeInstanceOf(
      UnauthorizedException,
    );
  });

  it('rejects user without organizationId', async () => {
    const { guard } = createGuard({ ...operator, organizationId: null });

    await expect(guard.canActivate(createContext('GET').context)).rejects.toBeInstanceOf(
      UnauthorizedException,
    );
  });

  it.each([
    [1, 'OPERATOR'],
    [5, 'MANAGER'],
    [9, 'ADMIN'],
  ])('maps USER_LEVEL %i to role %s and allows mutation requests', async (level, role) => {
    const { guard } = createGuard({ ...operator, userLevel: level });
    const { context, request } = createContext('POST');

    await expect(guard.canActivate(context)).resolves.toBe(true);
    expect((request.user as { role: string }).role).toBe(role);
  });

  it('looks up bearer user by USER_ID and scopes tenant by organizationId', async () => {
    const { guard, userRepository, orgRepository } = createGuard(operator);
    const { context, request } = createContext('GET');

    await expect(guard.canActivate(context)).resolves.toBe(true);

    expect(userRepository.findOne).toHaveBeenCalledWith({ where: { userId: 'USER01' } });
    expect(orgRepository.findOne).toHaveBeenCalledWith({ where: { organizationId: 1 } });
    // 헤더가 없으면 회사코드는 조직에서, plant는 organizationId 문자열로 파생한다.
    expect(request.user).toEqual({
      id: 'USER01',
      email: 'user01@example.com',
      role: 'OPERATOR',
      organizationId: 1,
      company: 'ES',
      plant: '1',
    });
  });

  it('prefers X-Company/X-Plant headers for display company/plant', async () => {
    const { guard } = createGuard(operator);
    const { context, request } = createContext('GET', { 'x-company': 'C1', 'x-plant': 'P1' });

    await expect(guard.canActivate(context)).resolves.toBe(true);
    expect(request.user).toMatchObject({ organizationId: 1, company: 'C1', plant: 'P1' });
  });
});

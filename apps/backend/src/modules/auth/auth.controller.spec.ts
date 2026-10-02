import { UnauthorizedException } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';

describe('AuthController', () => {
  let controller: AuthController;
  let service: jest.Mocked<AuthService>;

  beforeEach(() => {
    service = {
      login: jest.fn(),
      register: jest.fn(),
      me: jest.fn(),
    } as unknown as jest.Mocked<AuthService>;

    controller = new AuthController(service);
  });

  // 은성전장은 단일 조직이라 테넌트 헤더를 넘기지 않고 토큰(USER_ID)만으로 조회한다.
  it('passes only bearer token (USER_ID) to current user lookup', async () => {
    service.me.mockResolvedValue({ userId: 'USER01' } as any);

    await controller.me({
      headers: {
        authorization: 'Bearer USER01',
        'x-company': 'C1',
        'x-plant': 'P1',
      },
    } as any);

    expect(service.me).toHaveBeenCalledWith('USER01');
  });

  it('rejects missing bearer token', async () => {
    await expect(controller.me({ headers: {} } as any)).rejects.toThrow(UnauthorizedException);
  });
});

/**
 * @file src/common/guards/jwt-auth.guard.ts
 * @description 인증 가드 (은성전장) - Bearer 토큰(USER_ID)으로 ISYS_USERS 검증.
 *
 * 초보자 가이드:
 * 1. **토큰**: 로그인이 반환한 USER_ID를 그대로 Bearer 토큰으로 사용 (JWT 라이브러리 없음)
 * 2. **회사/사업장**: X-Company/X-Plant 헤더 우선, 없으면 사용자 조직에서 파생
 * 3. **role**: USER_LEVEL(1~9) → ADMIN/MANAGER/OPERATOR
 * 4. **사용법**: 컨트롤러/메서드에 @UseGuards(JwtAuthGuard). @Public()은 건너뜀.
 */
import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
  ForbiddenException,
  Logger,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Reflector } from '@nestjs/core';
import { Repository } from 'typeorm';
import { Request } from 'express';
import { IsysUser } from '../../entities/isys-user.entity';
import { IsysOrganization } from '../../entities/isys-organization.entity';
import { IS_PUBLIC_KEY } from '../decorators/public.decorator';
import { getErrorMessage } from '../utils/error-message.util';
import { RequestUser, RequestWithUser, setRequestUser } from '../utils/request-user.util';

const READONLY_HTTP_METHODS = new Set(['GET', 'HEAD', 'OPTIONS']);
const USER_CACHE_TTL_MS = 60_000;

interface CachedUser {
  user: RequestUser;
  expiresAt: number;
}

export type AuthenticatedUser = RequestUser;
export type AuthenticatedRequest = RequestWithUser & { user: AuthenticatedUser };

@Injectable()
export class JwtAuthGuard implements CanActivate {
  private readonly logger = new Logger(JwtAuthGuard.name);
  private readonly cache = new Map<string, CachedUser>();

  constructor(
    @InjectRepository(IsysUser)
    private readonly userRepository: Repository<IsysUser>,
    @InjectRepository(IsysOrganization)
    private readonly orgRepository: Repository<IsysOrganization>,
    private readonly reflector: Reflector,
  ) {}

  /** USER_LEVEL(1~9) → role 문자열 (auth.service와 동일 규칙) */
  private roleFromLevel(level: number | null): string {
    if (level != null && level >= 9) return 'ADMIN';
    if (level != null && level >= 5) return 'MANAGER';
    return 'OPERATOR';
  }

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (isPublic) return true;

    const request = context.switchToHttp().getRequest<Request>();
    const token = this.extractTokenFromHeader(request); // = USER_ID

    if (!token) {
      throw new UnauthorizedException('인증 토큰이 필요합니다.');
    }

    try {
      const companyHeader = request.headers['x-company'] as string | undefined;
      const plantHeader = request.headers['x-plant'] as string | undefined;
      const cacheKey = `${token}|${companyHeader ?? ''}|${plantHeader ?? ''}`;
      const now = Date.now();
      const cached = this.cache.get(cacheKey);

      let resolvedUser: RequestUser;
      if (cached && cached.expiresAt > now) {
        resolvedUser = cached.user;
      } else {
        const user = await this.userRepository.findOne({ where: { userId: token } });
        if (!user) {
          this.cache.delete(cacheKey);
          throw new UnauthorizedException('유효하지 않은 토큰입니다.');
        }
        const org = await this.orgRepository.findOne({
          where: { organizationId: user.organizationId },
        });
        const company = companyHeader || org?.companyCode || '';
        const plant = plantHeader || String(user.organizationId);

        resolvedUser = {
          id: user.userId,
          email: user.emailAddress || user.userId,
          role: this.roleFromLevel(user.userLevel),
          company,
          plant,
        };
        this.cache.set(cacheKey, { user: resolvedUser, expiresAt: now + USER_CACHE_TTL_MS });
        if (this.cache.size > 500) {
          for (const [k, v] of this.cache) {
            if (v.expiresAt <= now) this.cache.delete(k);
          }
        }
      }

      if (!resolvedUser.company || !resolvedUser.plant) {
        throw new UnauthorizedException('회사/사업장 정보가 없습니다. 재로그인 해주세요.');
      }

      setRequestUser(request, resolvedUser);

      if (
        resolvedUser.role === 'VIEWER' &&
        !READONLY_HTTP_METHODS.has(request.method.toUpperCase())
      ) {
        throw new ForbiddenException('VIEWER role is read-only.');
      }

      this.logger.debug(`User authenticated: ${resolvedUser.id}`);
      return true;
    } catch (error) {
      if (error instanceof UnauthorizedException || error instanceof ForbiddenException) throw error;
      this.logger.warn(`Authentication failed: ${getErrorMessage(error)}`);
      throw new UnauthorizedException('유효하지 않은 토큰입니다.');
    }
  }

  private extractTokenFromHeader(request: Request): string | undefined {
    const authHeader = request.headers.authorization;
    if (!authHeader) return undefined;
    const [type, token] = authHeader.split(' ');
    return type === 'Bearer' ? token : undefined;
  }
}

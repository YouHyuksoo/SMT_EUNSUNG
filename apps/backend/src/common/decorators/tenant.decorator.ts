/**
 * @file src/common/decorators/tenant.decorator.ts
 * @description 멀티테넌시 파라미터 데코레이터 - Company/Plant 값 추출
 *
 * 초보자 가이드:
 * 1. **@Company()**: req.user.company를 컨트롤러 파라미터로 바로 주입
 * 2. **@Plant()**: req.user.plant를 컨트롤러 파라미터로 바로 주입
 * 3. **사용법**: @Get() findAll(@Company() company: string, @Plant() plant: string)
 * 4. **JwtAuthGuard**: X-Company, X-Plant 헤더를 req.user에 설정해줌
 */

import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { AuthenticatedRequest } from '../guards/jwt-auth.guard';

/**
 * req.user.organizationId 값을 파라미터로 추출하는 테넌트 데코레이터.
 * 은성전장은 ORGANIZATION_ID(NUMBER) 단일 키로 테넌트를 구분한다.
 * (company/plant는 폐기 예정 — 신규/전환 컨트롤러는 이 데코레이터를 사용한다)
 * @example @OrganizationId() organizationId: number
 */
export const OrganizationId = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): number | undefined => {
    const req = ctx.switchToHttp().getRequest<AuthenticatedRequest>();
    return req.user?.organizationId;
  },
);

/**
 * req.user.id 값을 파라미터로 추출하는 데코레이터 (감사컬럼 ENTER_BY/LAST_MODIFY_BY용).
 * JwtAuthGuard가 인증한 사용자의 USER_ID를 그대로 반환한다.
 * @example @UserId() userId: string | undefined
 */
export const UserId = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): string | undefined => {
    const req = ctx.switchToHttp().getRequest<AuthenticatedRequest>();
    return req.user?.id;
  },
);

/**
 * req.user.company 값을 파라미터로 추출하는 데코레이터
 * @example @Company() company: string
 */
export const Company = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): string | undefined => {
    const req = ctx.switchToHttp().getRequest<AuthenticatedRequest>();
    return req.user?.company;
  },
);

/**
 * req.user.plant 값을 파라미터로 추출하는 데코레이터
 * @example @Plant() plant: string
 */
export const Plant = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): string | undefined => {
    const req = ctx.switchToHttp().getRequest<AuthenticatedRequest>();
    return req.user?.plant;
  },
);

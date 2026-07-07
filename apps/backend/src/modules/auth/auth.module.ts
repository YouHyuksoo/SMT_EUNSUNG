/**
 * @file src/modules/auth/auth.module.ts
 * @description 인증 모듈 (은성전장) - 로그인/현재사용자 조회.
 *
 * 은성전장 스키마(ISYS_USERS / ISYS_ORGANIZATION)만 사용한다.
 * HANES의 RBAC(RoleModule)·활동로그(SystemModule) 의존은 은성 연동 전까지 제거하고
 * allowedMenus는 빈 배열(전체 허용)로 반환한다.
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { IsysUser } from '../../entities/isys-user.entity';
import { IsysOrganization } from '../../entities/isys-organization.entity';

@Module({
  imports: [TypeOrmModule.forFeature([IsysUser, IsysOrganization])],
  controllers: [AuthController],
  providers: [AuthService],
  exports: [AuthService],
})
export class AuthModule {}

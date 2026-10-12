/**
 * @file src/common/modules/guard.module.ts
 * @description 전역 가드 모듈
 *
 * 초보자 가이드:
 * 1. JwtAuthGuard와 RolesGuard, InventoryFreezeGuard를 전역으로 제공
 * 2. 기존 모듈 개별 providers 등록을 줄여 가드 누락 위험을 제거
 * 3. TypeOrmModule을 re-export하여 가드가 쓰는 repository를 전역 제공
 *    → @UseGuards(JwtAuthGuard)를 쓰는 각 모듈이 개별 forFeature 없이도
 *      JwtAuthGuard의 ISYS_USERS/ISYS_ORGANIZATION 의존성을 해결할 수 있게 한다.
 */

import { Global, Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { TypeOrmModule } from '@nestjs/typeorm';
import { IsysUser } from '../../entities/isys-user.entity';
import { IsysOrganization } from '../../entities/isys-organization.entity';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { RolesGuard } from '../guards/roles.guard';
import { InventoryFreezeGuard } from '../guards/inventory-freeze.guard';

@Global()
@Module({
  imports: [TypeOrmModule.forFeature([IsysUser, IsysOrganization])],
  providers: [
    // JwtAuthGuard를 전역 가드로 등록 — 모든 라우트 기본 인증 (@Public() 예외)
    { provide: APP_GUARD, useClass: JwtAuthGuard },
    RolesGuard,
    InventoryFreezeGuard,
  ],
  // RolesGuard·InventoryFreezeGuard는 @UseGuards로 쓰이므로 export 유지.
  // TypeOrmModule: JwtAuthGuard 가 주입하는 IsysUser/IsysOrganization repository 전역 제공.
  exports: [RolesGuard, InventoryFreezeGuard, TypeOrmModule],
})
export class GuardModule {}

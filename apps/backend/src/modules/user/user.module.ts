/**
 * @file src/modules/user/user.module.ts
 * @description 사용자 관리 모듈
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { IsysUser } from '../../entities/isys-user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([IsysUser])],
  controllers: [UserController],
  providers: [UserService],
  exports: [UserService],
})
export class UserModule {}

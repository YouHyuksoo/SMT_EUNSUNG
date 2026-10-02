/**
 * @file src/modules/menu-favorites/menu-favorites.module.ts
 * @description 사용자별 메뉴 즐겨찾기 모듈
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserMenuFavorite } from '../../entities/user-menu-favorite.entity';
import { UserMenuFavoriteFolder } from '../../entities/user-menu-favorite-folder.entity';
import { IsysUser } from '../../entities/isys-user.entity';
import { IsysOrganization } from '../../entities/isys-organization.entity';
import { MenuFavoritesService } from './services/menu-favorites.service';
import { MenuFavoritesController } from './controllers/menu-favorites.controller';

@Module({
  // JwtAuthGuard(@UseGuards)가 ISYS_USERS/ORGANIZATION 리포지토리를 주입받도록 forFeature에 포함.
  imports: [TypeOrmModule.forFeature([UserMenuFavorite, UserMenuFavoriteFolder, IsysUser, IsysOrganization])],
  controllers: [MenuFavoritesController],
  providers: [MenuFavoritesService],
  exports: [MenuFavoritesService],
})
export class MenuFavoritesModule {}

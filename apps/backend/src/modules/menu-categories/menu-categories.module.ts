/**
 * @file src/modules/menu-categories/menu-categories.module.ts
 * @description 메뉴 카테고리 관리 모듈
 */
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MenuCategory } from '../../entities/menu-category.entity';
import { MenuCategoryItem } from '../../entities/menu-category-item.entity';
import { IsysUser } from '../../entities/isys-user.entity';
import { IsysOrganization } from '../../entities/isys-organization.entity';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { TransactionService } from '../../shared/transaction.service';
import { MenuCategoriesService } from './services/menu-categories.service';
import { MenuCategoryItemsService } from './services/menu-category-items.service';
import { MenuCategoriesController } from './controllers/menu-categories.controller';
import { MenuCategoryItemsController } from './controllers/menu-category-items.controller';

@Module({
  // JwtAuthGuard(@UseGuards)가 ISYS_USERS/ORGANIZATION 리포지토리를 주입받도록 forFeature에 포함.
  imports: [
    TypeOrmModule.forFeature([MenuCategory, MenuCategoryItem, IsysUser, IsysOrganization]),
  ],
  controllers: [MenuCategoriesController, MenuCategoryItemsController],
  providers: [MenuCategoriesService, MenuCategoryItemsService, JwtAuthGuard, TransactionService],
  exports: [MenuCategoriesService, MenuCategoryItemsService],
})
export class MenuCategoriesModule {}

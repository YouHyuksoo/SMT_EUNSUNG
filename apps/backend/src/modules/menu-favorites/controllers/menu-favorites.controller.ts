/**
 * @file src/modules/menu-favorites/controllers/menu-favorites.controller.ts
 * @description 사용자별 메뉴 즐겨찾기 컨트롤러
 *
 * 엔드포인트:
 * - GET    /menu-favorites/me                   내 즐겨찾기 메뉴 코드 목록 (순서 보존)
 * - PUT    /menu-favorites/me                   내 즐겨찾기 전체 교체 (menuCodes 배열 순서 = 표시 순서)
 * - GET    /menu-favorites/folders              내 폴더 목록 + 메뉴별 폴더 배정
 * - POST   /menu-favorites/folders              폴더 생성
 * - PATCH  /menu-favorites/folders/:id          폴더 이름 변경
 * - DELETE /menu-favorites/folders/:id          폴더 삭제 (소속 메뉴는 폴더 밖으로)
 * - PUT    /menu-favorites/me/:menuCode/folder  메뉴의 폴더 변경 (null이면 폴더 밖)
 */
import { BadRequestException, Body, Controller, Get, Put, Req, Post, Patch, Delete, Param, ParseIntPipe, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { MenuFavoritesService, FavoriteScope } from '../services/menu-favorites.service';
import { ReplaceMenuFavoritesDto, FavoriteFolderNameDto, AssignFavoriteFolderDto } from '../dto/menu-favorite.dto';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { AuthenticatedRequest, JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';

@ApiTags('시스템 - 메뉴 즐겨찾기')
@UseGuards(JwtAuthGuard)
@Controller('menu-favorites')
export class MenuFavoritesController {
  constructor(private readonly favorites: MenuFavoritesService) {}

  @Get('me')
  @ApiOperation({ summary: '내 즐겨찾기 메뉴 코드 목록' })
  async findMine(@Req() req: AuthenticatedRequest) {
    const data = await this.favorites.findMine(this.scope(req));
    return ResponseUtil.success(data);
  }

  @Put('me')
  @ApiOperation({ summary: '내 즐겨찾기 전체 교체 (배열 순서 = 표시 순서)' })
  async replaceMine(@Body() dto: ReplaceMenuFavoritesDto, @Req() req: AuthenticatedRequest) {
    const data = await this.favorites.replaceMine(dto.menuCodes, this.scope(req));
    return ResponseUtil.success(data);
  }

  @Get('folders')
  @ApiOperation({ summary: '내 즐겨찾기 폴더 목록과 메뉴별 폴더 배정' })
  async findFolders(@Req() req: AuthenticatedRequest) {
    return ResponseUtil.success(await this.favorites.findFolders(this.scope(req)));
  }

  @Post('folders')
  @ApiOperation({ summary: '즐겨찾기 폴더 생성' })
  async createFolder(@Body() dto: FavoriteFolderNameDto, @Req() req: AuthenticatedRequest) {
    return ResponseUtil.success(await this.favorites.createFolder(dto.name, this.scope(req)));
  }

  @Patch('folders/:id')
  @ApiOperation({ summary: '즐겨찾기 폴더 이름 변경' })
  async renameFolder(@Param('id', ParseIntPipe) id: number, @Body() dto: FavoriteFolderNameDto, @Req() req: AuthenticatedRequest) {
    return ResponseUtil.success(await this.favorites.renameFolder(id, dto.name, this.scope(req)));
  }

  @Delete('folders/:id')
  @ApiOperation({ summary: '즐겨찾기 폴더 삭제 (소속 메뉴는 폴더 밖으로 이동)' })
  async deleteFolder(@Param('id', ParseIntPipe) id: number, @Req() req: AuthenticatedRequest) {
    return ResponseUtil.success(await this.favorites.deleteFolder(id, this.scope(req)));
  }

  @Put('me/:menuCode/folder')
  @ApiOperation({ summary: '즐겨찾기 메뉴의 폴더 변경 (null이면 폴더 밖)' })
  async assignFolder(@Param('menuCode') menuCode: string, @Body() dto: AssignFavoriteFolderDto, @Req() req: AuthenticatedRequest) {
    return ResponseUtil.success(await this.favorites.assignFolder(menuCode, dto.folderId, this.scope(req)));
  }

  private scope(req: AuthenticatedRequest): FavoriteScope {
    const user = req.user;
    if (user?.organizationId == null || !user?.id) {
      throw new BadRequestException('조직/사용자 정보가 없습니다.');
    }
    return { organizationId: user.organizationId, userId: user.id };
  }
}

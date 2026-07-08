/**
 * @file controllers/pda-role.controller.ts
 * @description PDA 역할 관리 API 컨트롤러
 *
 * 초보자 가이드:
 * 1. GET /system/pda-roles — 역할 목록 (메뉴 매핑 포함)
 * 2. GET /system/pda-roles/active — 활성 역할만 (Select 옵션용)
 * 3. GET /system/pda-roles/menu-codes — 사용 가능한 메뉴코드 상수 목록
 * 4. POST /system/pda-roles — 역할 생성 + 메뉴 매핑
 * 5. PATCH /system/pda-roles/:code — 역할 수정 + 메뉴 매핑 교체
 * 6. DELETE /system/pda-roles/:code — 역할 삭제 (CASCADE)
 */
import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiParam } from '@nestjs/swagger';
import { PdaRoleService } from '../services/pda-role.service';
import { CreatePdaRoleDto, UpdatePdaRoleDto } from '../dto/pda-role.dto';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';

@ApiTags('시스템관리 - PDA 역할')
@Controller('system/pda-roles')
export class PdaRoleController {
  constructor(private readonly pdaRoleService: PdaRoleService) {}

  @Get()
  @ApiOperation({ summary: 'PDA 역할 목록 조회 (메뉴 매핑 포함)' })
  async findAll(@OrganizationId() organizationId: number) {
    const data = await this.pdaRoleService.findAll(organizationId);
    return ResponseUtil.success(data);
  }

  @Get('active')
  @ApiOperation({ summary: '활성 PDA 역할 목록 (Select 옵션용)' })
  async findAllActive(@OrganizationId() organizationId: number) {
    const data = await this.pdaRoleService.findAllActive(organizationId);
    return ResponseUtil.success(data);
  }

  @Get('menu-codes')
  @ApiOperation({ summary: '사용 가능한 PDA 메뉴코드 목록' })
  async getMenuCodes() {
    const data = this.pdaRoleService.getMenuCodes();
    return ResponseUtil.success(data);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'PDA 역할 생성' })
  async create(@Body() dto: CreatePdaRoleDto, @OrganizationId() organizationId: number) {
    const data = await this.pdaRoleService.create(dto, organizationId);
    return ResponseUtil.success(data, 'PDA 역할이 생성되었습니다.');
  }

  @Patch(':code')
  @ApiOperation({ summary: 'PDA 역할 수정' })
  @ApiParam({ name: 'code', description: 'PDA 역할 코드' })
  async update(
    @Param('code') code: string,
    @Body() dto: UpdatePdaRoleDto,
    @OrganizationId() organizationId: number,
  ) {
    const data = await this.pdaRoleService.update(code, dto, organizationId);
    return ResponseUtil.success(data, 'PDA 역할이 수정되었습니다.');
  }

  @Delete(':code')
  @ApiOperation({ summary: 'PDA 역할 삭제' })
  @ApiParam({ name: 'code', description: 'PDA 역할 코드' })
  async remove(@Param('code') code: string, @OrganizationId() organizationId: number) {
    const data = await this.pdaRoleService.remove(code, organizationId);
    return ResponseUtil.success(data, 'PDA 역할이 삭제되었습니다.');
  }
}

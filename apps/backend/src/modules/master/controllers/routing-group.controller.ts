/**
 * @file src/modules/master/controllers/routing-group.controller.ts
 * @description 라우팅 그룹 + 공정순서 + 양품조건 API 컨트롤러
 *
 * 초보자 가이드:
 * 1. /master/routing-groups: 라우팅 그룹 CRUD
 * 2. /master/routing-groups/:code/processes: 공정순서 CRUD
 * 3. /master/routing-groups/:code/processes/:seq/conditions: 양품조건
 */
import {
  Controller, Get, Post, Put, Delete,
  Body, Param, Query, HttpCode, HttpStatus, ParseIntPipe,
} from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { RoutingGroupService } from '../services/routing-group.service';
import {
  CreateRoutingGroupDto, UpdateRoutingGroupDto, RoutingGroupQueryDto,
  CreateRoutingProcessDto, UpdateRoutingProcessDto,
  BulkSaveConditionDto, BulkSaveRoutingMaterialDto,
} from '../dto/routing-group.dto';
import { ResponseUtil } from '../../../common/dto/response.dto';

@ApiTags('기준정보 - 라우팅그룹')
@Controller('master/routing-groups')
export class RoutingGroupController {
  constructor(private readonly svc: RoutingGroupService) {}

  // ─── 라우팅 그룹 ───

  @Get()
  @ApiOperation({ summary: '라우팅 그룹 목록' })
  async findAll(@Query() q: RoutingGroupQueryDto, @OrganizationId() organizationId: number) {
    const r = await this.svc.findAllGroups(q, organizationId);
    return ResponseUtil.paged(r.data, r.total, r.page, r.limit);
  }

  @Get('by-item/:itemCode')
  @ApiOperation({ summary: '품목코드로 라우팅 그룹+공정 조회 (BOM 페이지용)' })
  async findByItem(@Param('itemCode') itemCode: string, @OrganizationId() organizationId: number) {
    const data = await this.svc.findByItemCode(itemCode, organizationId);
    return ResponseUtil.success(data);
  }

  @Get(':code')
  @ApiOperation({ summary: '라우팅 그룹 상세' })
  async findOne(@Param('code') code: string, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.findGroupByCode(code, organizationId));
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: '라우팅 그룹 생성' })
  async create(@Body() dto: CreateRoutingGroupDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.createGroup(dto, organizationId), '라우팅 그룹이 생성되었습니다.');
  }

  @Put(':code')
  @ApiOperation({ summary: '라우팅 그룹 수정' })
  async update(@Param('code') code: string, @Body() dto: UpdateRoutingGroupDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.updateGroup(code, dto, organizationId), '라우팅 그룹이 수정되었습니다.');
  }

  @Delete(':code')
  @ApiOperation({ summary: '라우팅 그룹 삭제 (하위 공정+양품조건 포함)' })
  async delete(@Param('code') code: string, @OrganizationId() organizationId: number) {
    await this.svc.deleteGroup(code, organizationId);
    return ResponseUtil.success(null, '라우팅 그룹이 삭제되었습니다.');
  }

  // ─── 공정순서 ───

  @Get(':code/processes')
  @ApiOperation({ summary: '공정순서 목록' })
  async findProcesses(@Param('code') code: string, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.findProcesses(code, organizationId));
  }

  @Post(':code/processes')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: '공정순서 추가' })
  async createProcess(
    @Param('code') code: string,
    @Body() dto: CreateRoutingProcessDto,
    @OrganizationId() organizationId: number,
  ) {
    dto.routingCode = code;
    return ResponseUtil.success(await this.svc.createProcess(dto, organizationId), '공정이 추가되었습니다.');
  }

  @Put(':code/processes/:seq')
  @ApiOperation({ summary: '공정순서 수정' })
  async updateProcess(
    @Param('code') code: string,
    @Param('seq', ParseIntPipe) seq: number,
    @Body() dto: UpdateRoutingProcessDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.svc.updateProcess(code, seq, dto, organizationId), '공정이 수정되었습니다.');
  }

  @Delete(':code/processes/:seq')
  @ApiOperation({ summary: '공정순서 삭제 (양품조건 포함)' })
  async deleteProcess(
    @Param('code') code: string,
    @Param('seq', ParseIntPipe) seq: number,
    @OrganizationId() organizationId: number,
  ) {
    await this.svc.deleteProcess(code, seq, organizationId);
    return ResponseUtil.success(null, '공정이 삭제되었습니다.');
  }

  // ─── 양품조건 ───

  @Get(':code/processes/:seq/conditions')
  @ApiOperation({ summary: '양품조건 목록' })
  async findConditions(
    @Param('code') code: string,
    @Param('seq', ParseIntPipe) seq: number,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.svc.findConditions(code, seq, organizationId));
  }

  @Put(':code/processes/:seq/conditions/bulk')
  @ApiOperation({ summary: '양품조건 일괄 저장' })
  async bulkSave(
    @Param('code') code: string,
    @Param('seq', ParseIntPipe) seq: number,
    @Body() dto: BulkSaveConditionDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(
      await this.svc.bulkSaveConditions(code, seq, dto, organizationId),
      '양품조건이 저장되었습니다.',
    );
  }

  @Get(':code/processes/:seq/materials')
  @ApiOperation({ summary: '공정별 투입자재 목록' })
  async findMaterials(
    @Param('code') code: string,
    @Param('seq', ParseIntPipe) seq: number,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.svc.findMaterials(code, seq, organizationId));
  }

  @Put(':code/processes/:seq/materials/bulk')
  @ApiOperation({ summary: '공정별 투입자재 일괄 저장' })
  async bulkSaveMaterials(
    @Param('code') code: string,
    @Param('seq', ParseIntPipe) seq: number,
    @Body() dto: BulkSaveRoutingMaterialDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(
      await this.svc.bulkSaveMaterials(code, seq, dto, organizationId),
      '공정별 투입자재가 저장되었습니다.',
    );
  }
}

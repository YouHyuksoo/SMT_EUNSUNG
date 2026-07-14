import {
  Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, ParseIntPipe,
  Post, Put, Query, UseGuards,
} from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import {
  BulkSaveRoutingMaterialDto, CreateRoutingGroupDto, CreateRoutingProcessDto,
  ReorderRoutingProcessesDto, RoutingGroupQueryDto, UpdateRoutingGroupDto,
  UpdateRoutingProcessDto,
} from '../dto/routing-group.dto';
import { RoutingGroupService } from '../services/routing-group.service';

@ApiTags('기준정보 - 라우팅그룹')
@UseGuards(JwtAuthGuard)
@Controller('master/routing-groups')
export class RoutingGroupController {
  constructor(private readonly svc: RoutingGroupService) {}

  @Get()
  async findAll(@Query() query: RoutingGroupQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.svc.findAllGroups(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get(':code')
  async findOne(@Param('code') code: string, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.findGroupByCode(code, organizationId));
  }

  @Post() @HttpCode(HttpStatus.CREATED)
  async create(@Body() dto: CreateRoutingGroupDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.createGroup(dto, organizationId), '라우팅 그룹이 생성되었습니다.');
  }

  @Put(':code')
  async update(@Param('code') code: string, @Body() dto: UpdateRoutingGroupDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.updateGroup(code, dto, organizationId), '라우팅 그룹이 수정되었습니다.');
  }

  @Delete(':code')
  async delete(@Param('code') code: string, @OrganizationId() organizationId: number) {
    await this.svc.deleteGroup(code, organizationId);
    return ResponseUtil.success(null, '라우팅 그룹이 삭제되었습니다.');
  }

  @Get(':code/processes')
  async findProcesses(@Param('code') code: string, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.findProcesses(code, organizationId));
  }

  @Post(':code/processes') @HttpCode(HttpStatus.CREATED)
  async createProcess(@Param('code') code: string, @Body() dto: CreateRoutingProcessDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.createProcess(code, dto, organizationId), '공정이 추가되었습니다.');
  }

  @Put(':code/processes/:seq')
  async updateProcess(@Param('code') code: string, @Param('seq', ParseIntPipe) seq: number, @Body() dto: UpdateRoutingProcessDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.updateProcess(code, seq, dto, organizationId), '공정이 수정되었습니다.');
  }

  @Put(':code/process-order')
  @ApiOperation({ summary: '공정 순번 일괄 변경' })
  async reorderProcesses(@Param('code') code: string, @Body() dto: ReorderRoutingProcessesDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.reorderProcesses(code, dto, organizationId), '공정 순서가 변경되었습니다.');
  }

  @Delete(':code/processes/:seq')
  async deleteProcess(@Param('code') code: string, @Param('seq', ParseIntPipe) seq: number, @OrganizationId() organizationId: number) {
    await this.svc.deleteProcess(code, seq, organizationId);
    return ResponseUtil.success(null, '공정이 삭제되었습니다.');
  }

  @Get(':code/processes/:seq/materials')
  async findMaterials(@Param('code') code: string, @Param('seq', ParseIntPipe) seq: number, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.findMaterials(code, seq, organizationId));
  }

  @Put(':code/processes/:seq/materials')
  async saveMaterials(@Param('code') code: string, @Param('seq', ParseIntPipe) seq: number, @Body() dto: BulkSaveRoutingMaterialDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.bulkSaveMaterials(code, seq, dto, organizationId), '공정별 투입자재가 저장되었습니다.');
  }
}

/**
 * @file src/modules/material/controllers/mat-lot.controller.ts
 * @description 자재LOT CRUD API 컨트롤러
 */

import { Controller, Get, Post, Put, Delete, Body, Param, Query, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiParam } from '@nestjs/swagger';
import { MatLotService } from '../services/mat-lot.service';
import { CreateMatLotDto, UpdateMatLotDto, MatLotQueryDto } from '../dto/mat-lot.dto';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';

@ApiTags('자재관리 - 자재시리얼')
@Controller('material/lots')
export class MatLotController {
  constructor(private readonly matLotService: MatLotService) {}

  @Get()
  @ApiOperation({ summary: '자재시리얼 목록 조회' })
  async findAll(@Query() query: MatLotQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.matLotService.findAll(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('by-uid/:matUid')
  @ApiOperation({ summary: '자재시리얼(matUid)로 조회' })
  @ApiParam({ name: 'matUid', description: '자재시리얼' })
  async findByMatUid(@Param('matUid') matUid: string, @OrganizationId() organizationId: number) {
    const data = await this.matLotService.findByMatUid(matUid, organizationId);
    return ResponseUtil.success(data);
  }

  @Get(':id')
  @ApiOperation({ summary: 'LOT 상세 조회' })
  async findById(@Param('id') id: string, @OrganizationId() organizationId: number) {
    const data = await this.matLotService.findById(id, organizationId);
    return ResponseUtil.success(data);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'LOT 생성 (입고)' })
  async create(@Body() dto: CreateMatLotDto, @OrganizationId() organizationId: number) {
    const data = await this.matLotService.create(dto, organizationId);
    return ResponseUtil.success(data, 'LOT이 생성되었습니다.');
  }

  @Put(':id')
  @ApiOperation({ summary: 'LOT 수정' })
  async update(@Param('id') id: string, @Body() dto: UpdateMatLotDto, @OrganizationId() organizationId: number) {
    const data = await this.matLotService.update(id, dto, organizationId);
    return ResponseUtil.success(data, 'LOT이 수정되었습니다.');
  }

  @Delete(':id')
  @ApiOperation({ summary: 'LOT 삭제' })
  async delete(@Param('id') id: string, @OrganizationId() organizationId: number) {
    await this.matLotService.delete(id, organizationId);
    return ResponseUtil.success(null, 'LOT이 삭제되었습니다.');
  }

}

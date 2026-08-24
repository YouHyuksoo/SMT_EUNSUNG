/**
 * @file src/modules/master/controllers/process.controller.ts
 * @description 공정마스터 CRUD API 컨트롤러
 *
 * 초보자 가이드:
 * 1. **GET /master/processes**: 공정 목록 조회 (페이징, 검색)
 * 2. **POST /master/processes**: 공정 생성
 * 3. **PUT /master/processes/:id**: 공정 수정
 * 4. **DELETE /master/processes/:id**: 공정 삭제 (소프트)
 */

import { BadRequestException, Controller, Get, Post, Put, Delete, Body, Param, Query, HttpCode, HttpStatus, UploadedFile, UseGuards, UseInterceptors } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiConsumes } from '@nestjs/swagger';
import { FileInterceptor } from '@nestjs/platform-express';
import { memoryStorage } from 'multer';
import { Request } from 'express';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ProcessService } from '../services/process.service';
import { CreateProcessDto, UpdateProcessDto, ProcessQueryDto } from '../dto/process.dto';
import { ResponseUtil } from '../../../common/dto/response.dto';

@ApiTags('기준정보 - 공정마스터')
@UseGuards(JwtAuthGuard)
@Controller('master/processes')
export class ProcessController {
  constructor(private readonly processService: ProcessService) {}

  @Post('upload')
  @ApiOperation({ summary: '공정마스터 엑셀 업로드' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('file', {
    storage: memoryStorage(), limits: { fileSize: 10 * 1024 * 1024 },
    fileFilter: (_req: Request, file: Express.Multer.File, callback: (error: Error | null, accept: boolean) => void) => {
      if (!/\.xlsx$/i.test(file.originalname)) return callback(new BadRequestException('.xlsx 파일만 업로드할 수 있습니다.'), false);
      callback(null, true);
    },
  }))
  async upload(@UploadedFile() file: Express.Multer.File, @Body('departmentCode') departmentCode: string, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    if (!file) throw new BadRequestException('파일이 필요합니다.');
    if (!departmentCode) throw new BadRequestException('부서를 선택하세요.');
    return ResponseUtil.success(await this.processService.uploadWorkbook(file.buffer, departmentCode, organizationId, userId));
  }

  @Get()
  @ApiOperation({ summary: '공정 목록 조회' })
  async findAll(@Query() query: ProcessQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.processService.findAll(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('equipment-counts')
  @ApiOperation({ summary: '공정별 배치 설비 수 조회' })
  async getEquipmentCounts(@OrganizationId() organizationId: number) {
    const data = await this.processService.getEquipmentCounts(organizationId);
    return ResponseUtil.success(data);
  }

  @Get(':id/equipments')
  @ApiOperation({ summary: '공정 배치 설비 목록 조회' })
  async findEquipments(@Param('id') id: string, @OrganizationId() organizationId: number) {
    const data = await this.processService.findEquipments(id, organizationId);
    return ResponseUtil.success(data);
  }

  @Post(':id/equipments')
  @ApiOperation({ summary: '공정에 설비 배치' })
  async assignEquipment(
    @Param('id') id: string,
    @Body('equipCode') equipCode: string,
    @Body('lineCode') lineCode: string,
    @OrganizationId() organizationId: number,
  ) {
    const data = await this.processService.assignEquipment(id, equipCode, organizationId, lineCode);
    return ResponseUtil.success(data, '설비가 공정에 배치되었습니다.');
  }

  @Put(':id/equipments/:equipCode/line')
  @ApiOperation({ summary: '배치 설비 라인코드 수정' })
  async updateEquipmentLine(
    @Param('id') id: string,
    @Param('equipCode') equipCode: string,
    @Body('lineCode') lineCode: string,
    @OrganizationId() organizationId: number,
  ) {
    const data = await this.processService.updateEquipmentLine(id, equipCode, lineCode, organizationId);
    return ResponseUtil.success(data, '배치 설비 라인이 수정되었습니다.');
  }

  @Delete(':id/equipments/:equipCode')
  @ApiOperation({ summary: '공정 배치 설비 삭제' })
  async removeEquipment(
    @Param('id') id: string,
    @Param('equipCode') equipCode: string,
    @OrganizationId() organizationId: number,
  ) {
    const data = await this.processService.removeEquipment(id, equipCode, organizationId);
    return ResponseUtil.success(data, '공정 배치 설비가 삭제되었습니다.');
  }

  @Get(':id')
  @ApiOperation({ summary: '공정 상세 조회' })
  async findById(@Param('id') id: string, @OrganizationId() organizationId: number) {
    const data = await this.processService.findById(id, organizationId);
    return ResponseUtil.success(data);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: '공정 생성' })
  async create(@Body() dto: CreateProcessDto, @OrganizationId() organizationId: number) {
    const data = await this.processService.create(dto, organizationId);
    return ResponseUtil.success(data, '공정이 생성되었습니다.');
  }

  @Put(':id')
  @ApiOperation({ summary: '공정 수정' })
  async update(@Param('id') id: string, @Body() dto: UpdateProcessDto, @OrganizationId() organizationId: number) {
    const data = await this.processService.update(id, dto, organizationId);
    return ResponseUtil.success(data, '공정이 수정되었습니다.');
  }

  @Delete(':id')
  @ApiOperation({ summary: '공정 삭제' })
  async delete(@Param('id') id: string, @OrganizationId() organizationId: number) {
    await this.processService.delete(id, organizationId);
    return ResponseUtil.success(null, '공정이 삭제되었습니다.');
  }
}

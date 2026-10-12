import {
  BadRequestException,
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Put,
  Query,
  Res,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { ApiConsumes, ApiOperation, ApiParam, ApiQuery, ApiTags } from '@nestjs/swagger';
import { FileInterceptor } from '@nestjs/platform-express';
import { Request, Response } from 'express';
import { memoryStorage } from 'multer';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { BomQueryDto, CreateBomDto, UpdateBomDto } from '../dto/bom.dto';
import { BomService } from '../services/bom.service';

import { formatDate } from '@smt/shared';
@ApiTags('Master - BOM')
@Controller('master/boms')
export class BomController {
  constructor(private readonly bomService: BomService) {}

  @Get('parents')
  @ApiOperation({ summary: 'Get BOM parent list' })
  @ApiQuery({ name: 'search', required: false })
  @ApiQuery({ name: 'effectiveDate', required: false })
  async findParents(
    @Query('search') search?: string,
    @Query('effectiveDate') effectiveDate?: string,
    @OrganizationId() organizationId?: number,
  ) {
    const data = await this.bomService.findParents(search, effectiveDate, organizationId);
    return ResponseUtil.success(data);
  }

  @Get('export')
  @ApiOperation({ summary: 'Export BOM to Excel' })
  @ApiQuery({ name: 'parentItemCode', required: false })
  @ApiQuery({ name: 'effectiveDate', required: false })
  async exportToExcel(
    @Query('parentItemCode') parentItemCode: string | undefined,
    @Query('effectiveDate') effectiveDate: string | undefined,
    @OrganizationId() organizationId: number,
    @Res() res: Response,
  ) {
    const buffer = await this.bomService.exportToExcel(parentItemCode, organizationId, effectiveDate);
    const dateStr = formatDate(new Date()).replace(/-/g, '');
    const filename = parentItemCode
      ? `BOM_${parentItemCode}_${dateStr}.xlsx`
      : `BOM_ALL_${dateStr}.xlsx`;

    res.set({
      'Content-Type': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'Content-Disposition': `attachment; filename="${filename}"`,
      'Content-Length': buffer.length.toString(),
    });
    res.end(buffer);
  }

  @Get('template')
  @ApiOperation({ summary: 'Download blank BOM Excel template' })
  async downloadTemplate(@Res() res: Response) {
    const buffer = this.bomService.downloadTemplate();
    res.set({
      'Content-Type': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'Content-Disposition': 'attachment; filename="BOM_template.xlsx"',
      'Content-Length': buffer.length.toString(),
    });
    res.end(buffer);
  }

  @Post('upload/preview')
  @ApiOperation({ summary: 'Preview BOM Excel upload — check duplicates before actual upload' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(
    FileInterceptor('file', {
      storage: memoryStorage(),
      limits: { fileSize: 10 * 1024 * 1024 },
      fileFilter: (_req: Request, file: Express.Multer.File, cb: (error: Error | null, accept: boolean) => void) => {
        if (!file.originalname.match(/\.xlsx$/i)) return cb(new BadRequestException('Only .xlsx is allowed'), false);
        cb(null, true);
      },
    }),
  )
  async previewUpload(
    @UploadedFile() file: Express.Multer.File,
    @OrganizationId() organizationId: number,
  ) {
    if (!file) throw new BadRequestException('File is required');
    const result = await this.bomService.previewUpload(file.buffer, organizationId);
    return ResponseUtil.success(result, `미리보기 완료 — 신규: ${result.newCount}, 중복: ${result.duplicateCount}, 오류: ${result.errorCount}`);
  }

  @Post('upload')
  @ApiOperation({ summary: 'Upload BOM from Excel' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(
    FileInterceptor('file', {
      storage: memoryStorage(),
      limits: { fileSize: 10 * 1024 * 1024 },
      fileFilter: (_req: Request, file: Express.Multer.File, cb: (error: Error | null, accept: boolean) => void) => {
        if (!file.originalname.match(/\.xlsx$/i)) {
          return cb(new BadRequestException('Only .xlsx is allowed'), false);
        }
        cb(null, true);
      },
    }),
  )
  async uploadFromExcel(
    @UploadedFile() file: Express.Multer.File,
    @OrganizationId() organizationId: number,
    @UserId() userId: string | undefined,
  ) {
    if (!file) throw new BadRequestException('File is required');
    const result = await this.bomService.uploadFromExcel(file.buffer, organizationId, userId);
    return ResponseUtil.success(
      result,
      `Inserted: ${result.inserted}, Skipped: ${result.skipped}, Errors: ${result.errors.length}`,
    );
  }

  @Get('usage')
  @ApiOperation({ summary: 'BOM 행을 함께 쓰는 최상위 제품 목록 (삭제 전 영향 확인)' })
  @ApiQuery({ name: 'parentItemCode', required: true })
  async findUsage(
    @Query('parentItemCode') parentItemCode: string,
    @OrganizationId() organizationId?: number,
  ) {
    if (!parentItemCode) throw new BadRequestException('parentItemCode is required');
    const data = await this.bomService.findUsage(parentItemCode, organizationId);
    return ResponseUtil.success(data);
  }

  @Get('hierarchy/:parentItemCode')
  @ApiOperation({ summary: 'Get BOM hierarchy' })
  @ApiParam({ name: 'parentItemCode' })
  @ApiQuery({ name: 'depth', required: false })
  @ApiQuery({ name: 'effectiveDate', required: false })
  async findHierarchy(
    @Param('parentItemCode') parentItemCode: string,
    @Query('depth') depth?: number,
    @Query('effectiveDate') effectiveDate?: string,
    @OrganizationId() organizationId?: number,
  ) {
    const data = await this.bomService.findHierarchy(parentItemCode, depth ?? 3, effectiveDate, organizationId);
    return ResponseUtil.success(data);
  }

  @Get('parent/:parentItemCode')
  @ApiOperation({ summary: 'Get BOM rows by parent item' })
  @ApiQuery({ name: 'effectiveDate', required: false })
  async findByParentId(
    @Param('parentItemCode') parentItemCode: string,
    @Query('effectiveDate') effectiveDate?: string,
    @OrganizationId() organizationId?: number,
  ) {
    const data = await this.bomService.findByParentId(parentItemCode, effectiveDate, organizationId);
    return ResponseUtil.success(data);
  }

  @Get()
  @ApiOperation({ summary: 'Get BOM list' })
  async findAll(
    @Query() query: BomQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.bomService.findAll(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get one BOM row' })
  async findById(@Param('id') id: string, @OrganizationId() organizationId?: number) {
    const data = await this.bomService.findById(id, organizationId);
    return ResponseUtil.success(data);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create BOM row' })
  async create(
    @Body() dto: CreateBomDto,
    @OrganizationId() organizationId: number,
    @UserId() userId: string | undefined,
  ) {
    const data = await this.bomService.create(dto, organizationId, userId);
    return ResponseUtil.success(data, 'BOM created');
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update BOM row' })
  async update(@Param('id') id: string, @Body() dto: UpdateBomDto, @OrganizationId() organizationId?: number) {
    const data = await this.bomService.update(id, dto, organizationId);
    return ResponseUtil.success(data, 'BOM updated');
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete BOM row' })
  async delete(@Param('id') id: string, @OrganizationId() organizationId?: number) {
    await this.bomService.delete(id, organizationId);
    return ResponseUtil.success(null, 'BOM deleted');
  }
}

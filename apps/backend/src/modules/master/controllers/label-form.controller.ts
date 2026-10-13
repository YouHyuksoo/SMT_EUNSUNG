import {
  BadRequestException, Body, Controller, Delete, Get, HttpCode, HttpStatus, Post, Put, Query, Res, UploadedFile, UseGuards, UseInterceptors,
} from '@nestjs/common';
import { ApiConsumes, ApiTags } from '@nestjs/swagger';
import { FileInterceptor } from '@nestjs/platform-express';
import { Response } from 'express';
import { memoryStorage } from 'multer';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { CopyLabelFormDto, LabelFileQueryDto, LabelFormKeyDto, LabelFormQueryDto, SaveLabelFormDto, UpdateLabelFormDto } from '../dto/label-form.dto';
import { LabelFormService } from '../services/label-form.service';

@ApiTags('기준정보 - 제품별 라벨양식')
@UseGuards(JwtAuthGuard)
@Controller('master/label-forms')
export class LabelFormController {
  constructor(private readonly service: LabelFormService) {}

  @Get()
  async findAll(@Query() query: LabelFormQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findAll(query, organizationId));
  }

  @Get('values')
  async findValues(@Query() key: LabelFormKeyDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findValues(key, organizationId));
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  async create(@Body() dto: SaveLabelFormDto, @OrganizationId() organizationId: number, @UserId() userId: string | undefined) {
    return ResponseUtil.success(await this.service.create(dto, organizationId, userId), '라벨 양식을 등록했습니다.');
  }

  @Put()
  async update(@Body() dto: UpdateLabelFormDto, @OrganizationId() organizationId: number, @UserId() userId: string | undefined) {
    return ResponseUtil.success(await this.service.update(dto, organizationId, userId), '라벨 양식을 수정했습니다.');
  }

  @Delete()
  async remove(@Query() key: LabelFormKeyDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(key, organizationId), '라벨 양식을 삭제했습니다.');
  }

  @Post('copy')
  async copy(@Body() dto: CopyLabelFormDto, @OrganizationId() organizationId: number, @UserId() userId: string | undefined) {
    const result = await this.service.copy(dto, organizationId, userId);
    return ResponseUtil.success(result, `라벨 양식 ${result.copied}건을 ${result.targetModelName} 로 복사했습니다.`);
  }

  @Post('file')
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('file', { storage: memoryStorage(), limits: { fileSize: 10 * 1024 * 1024 } }))
  async uploadFile(
    @Query() query: LabelFileQueryDto,
    @UploadedFile() file: Express.Multer.File,
    @OrganizationId() organizationId: number,
    @UserId() userId: string | undefined,
  ) {
    if (!file) throw new BadRequestException('파일을 선택하세요.');
    const result = await this.service.uploadFile(query, query.kind, file, organizationId, userId);
    return ResponseUtil.success(result, query.kind === 'syntax' ? '양식 파일을 올렸습니다.' : '이미지를 올렸습니다.');
  }

  @Get('file')
  async downloadFile(@Query() query: LabelFileQueryDto, @OrganizationId() organizationId: number, @Res() res: Response) {
    const { content, fileName, contentType } = await this.service.downloadFile(query, query.kind, organizationId);
    res.set({
      'Content-Type': contentType,
      'Content-Disposition': `attachment; filename*=UTF-8''${encodeURIComponent(fileName)}`,
      'Content-Length': content.length.toString(),
    });
    res.end(content);
  }
}

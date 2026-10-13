import {
  BadRequestException, Body, Controller, Delete, Get, Param, Post, Query, UploadedFiles, UseGuards, UseInterceptors,
} from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import { ApiConsumes, ApiOperation, ApiTags } from '@nestjs/swagger';
import { memoryStorage } from 'multer';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  SmtNcApplyDto, SmtNcCompareQueryDto, SmtNcGenerateDto, SmtNcQueryDto, SmtNcReplacePartDto,
} from './smt-nc.dto';
import { SmtNcService } from './smt-nc.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('SMT - 피더레이아웃 등록')
@UseGuards(JwtAuthGuard)
@Controller('smt/nc')
export class SmtNcController {
  constructor(private readonly service: SmtNcService) {}

  @Get()
  @ApiOperation({ summary: '피더 배치 작업표(IB_MNT_PLANDATA) 조회 (PB w_smt_upload_nc_master dw_1)' })
  async find(@Query() query: SmtNcQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Get('machine-groups')
  @ApiOperation({ summary: '라인의 설비그룹 — NC 파일을 그룹마다 하나씩 올린다' })
  async machineGroups(@Query('lineCode') lineCode: string) {
    if (!lineCode) throw new BadRequestException('lineCode 는 필수입니다.');
    return ResponseUtil.success(await this.service.findMachineGroups(lineCode));
  }

  @Get('smt-models')
  @ApiOperation({ summary: 'SMT 모델명 목록 (IP_PRODUCT_MODEL_MASTER.SMT_MODEL_NAME)' })
  async smtModels(@OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findSmtModels(organizationId));
  }

  @Post('generate')
  @ApiOperation({ summary: '삼성 마운터 NC 파일 → 피더 배치 작업표 생성 (PB Generate)' })
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FilesInterceptor('files', 10, { storage: memoryStorage(), limits: { fileSize: 20 * 1024 * 1024 } }))
  async generate(
    @Body() dto: SmtNcGenerateDto,
    @UploadedFiles() files: Express.Multer.File[] | undefined,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(await this.service.generate(dto, files ?? [], organizationId, userId || DEFAULT_USER));
  }

  @Delete('rows/:rowKey')
  @ApiOperation({ summary: '작업표 한 줄 삭제' })
  async removeRow(@Param('rowKey') rowKey: string) {
    return ResponseUtil.success(await this.service.removeRow(rowKey));
  }

  @Post('replace-part')
  @ApiOperation({ summary: '작업표 품번 → 공급처 품목코드 교체 (PB Replace PartNo)' })
  async replacePart(@Body() dto: SmtNcReplacePartDto) {
    return ResponseUtil.success(await this.service.replacePartNo(dto.supplierCode));
  }

  @Post('apply')
  @ApiOperation({ summary: '작업표 → SMT BOM(ID_ENG_BOM_SMT) 반영 (PB Apply)' })
  async apply(
    @Body() dto: SmtNcApplyDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(await this.service.apply(dto, organizationId, userId || DEFAULT_USER));
  }

  @Get('duplicates')
  @ApiOperation({ summary: '중복 적재 검증 (PB d_plandata_4_dup_check_lst)' })
  async findDuplicates(
    @Query() query: SmtNcQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    const result = await this.service.findDuplicates(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Get('bom-compare')
  @ApiOperation({ summary: '피더 ↔ BOM 대조 (PB d_smt_feeder_bom_compare_lst)' })
  async compareWithBom(
    @Query() query: SmtNcCompareQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.compareWithBom(query, organizationId));
  }
}

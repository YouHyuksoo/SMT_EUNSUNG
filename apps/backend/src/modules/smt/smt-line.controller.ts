import { Body, Controller, Delete, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  SmtLineKeyDto,
  SmtLineQueryDto,
  SmtLineUpsertDto,
  SmtLocationGenerateDto,
} from './smt-line.dto';
import { SmtLineService } from './smt-line.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('SMT - 라인관리')
@UseGuards(JwtAuthGuard)
@Controller('smt/line')
export class SmtLineController {
  constructor(private readonly service: SmtLineService) {}

  @Get()
  @ApiOperation({ summary: 'SMT 라인·설비 조회 (PB w_smt_line_master)' })
  async find(@Query() query: SmtLineQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Get('machines')
  @ApiOperation({ summary: '설비 셀렉터 목록 (PB vd_smt_machine_code)' })
  async findMachines(@OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findMachines(organizationId));
  }

  @Get('locations')
  @ApiOperation({ summary: '선택 라인·설비의 위치 목록 (PB d_ib_machine_location_lst)' })
  async findLocations(@Query() query: SmtLineKeyDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findLocations(query, organizationId));
  }

  @Post()
  @ApiOperation({ summary: '라인·설비 등록 (감사컬럼은 서버가 채운다)' })
  async create(
    @Body() dto: SmtLineUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.create(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put()
  @ApiOperation({ summary: '라인·설비 수정 (라인코드·설비코드는 키라 바꿀 수 없다)' })
  async update(
    @Body() dto: SmtLineUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.update(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({ summary: '라인·설비 삭제 (하위 위치가 남아 있으면 거부)' })
  async remove(@Body() dto: SmtLineKeyDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(dto, organizationId));
  }

  @Post('locations/generate')
  @ApiOperation({ summary: '위치 일괄생성 (PB cb_3 Generate → PKG_MES_SMT.SP_SMT_LOCATION_GENERATE)' })
  async generateLocations(
    @Body() dto: SmtLocationGenerateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.generateLocations(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete('locations')
  @ApiOperation({
    summary: '위치 일괄삭제 (PB cb_4 Delete All. PB 는 WHERE 가 없어 전 테이블을 지웠다)',
  })
  async deleteLocations(@Body() dto: SmtLineKeyDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.deleteLocations(dto, organizationId));
  }
}

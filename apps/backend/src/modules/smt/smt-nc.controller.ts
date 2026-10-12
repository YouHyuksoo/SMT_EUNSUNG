import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { SmtNcCompareQueryDto, SmtNcQueryDto } from './smt-nc.dto';
import { SmtNcService } from './smt-nc.service';

@ApiTags('SMT - 피더레이아웃 등록')
@UseGuards(JwtAuthGuard)
@Controller('smt/nc')
export class SmtNcController {
  constructor(private readonly service: SmtNcService) {}

  @Get()
  @ApiOperation({
    summary: '적재된 마운터 배치표 조회 (PB w_smt_upload_nc_master. 벤더 NC 파싱은 범위 밖)',
  })
  async find(@Query() query: SmtNcQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
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

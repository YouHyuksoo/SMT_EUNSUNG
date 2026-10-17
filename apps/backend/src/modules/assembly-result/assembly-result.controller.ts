// 조립실적(생산실적) REST (글로벌 prefix /api/v1): /production/assembly-results
import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../common/dto/response.dto';
import { AssemblyAdjustDto, AssemblyResultQueryDto } from './assembly-result.dto';
import { AssemblyResultService } from './assembly-result.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('생산 - 조립실적(생산실적)')
@UseGuards(JwtAuthGuard)
@Controller('production/assembly-results')
export class AssemblyResultController {
  constructor(private readonly service: AssemblyResultService) {}

  @Get()
  @ApiOperation({ summary: '조립실적 목록 — AOI 자동 · 수기 작업실적 · 보정' })
  async find(@Query() query: AssemblyResultQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.find(query, organizationId));
  }

  @Post('adjust')
  @ApiOperation({ summary: '조립실적 보정 등록 (쓰기). 보정 행을 추가하고, 전환 이후 실적이면 공정재고도 함께 움직인다.' })
  async adjust(@Body() dto: AssemblyAdjustDto, @UserId() userId?: string) {
    return ResponseUtil.success(await this.service.adjust(dto, userId || DEFAULT_USER));
  }
}

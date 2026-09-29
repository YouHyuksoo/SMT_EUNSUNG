import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { WorkstagePassQueryDto, WorkstagePassScanDto } from './workstage-pass.dto';
import { WorkstagePassService } from './workstage-pass.service';

@ApiTags('공정수불관리 - 공정통과이력 관리')
@UseGuards(JwtAuthGuard)
@Controller('process-transaction/workstage-pass')
export class WorkstagePassController {
  constructor(private readonly service: WorkstagePassService) {}
  @Get() @ApiOperation({ summary: 'PB W_PLN_PRODUCT_INOUT_SCAN_MASTER 공정통과이력 조회' })
  async find(@Query() query: WorkstagePassQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }
  @Post('scan') @ApiOperation({ summary: '공정통과 스캔 또는 최근 통과 취소' })
  scan(@Body() dto: WorkstagePassScanDto, @OrganizationId() organizationId: number, @UserId() userId?: string) {
    return this.service.scan(dto, organizationId, userId);
  }
}

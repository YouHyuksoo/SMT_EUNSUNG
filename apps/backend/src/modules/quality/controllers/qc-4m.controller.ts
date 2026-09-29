import { Body, Controller, Delete, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { Qc4mKeyDto, Qc4mQueryDto, Qc4mUpsertDto } from '../dto/qc-4m.dto';
import { Qc4mService } from '../services/qc-4m.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('품질관리 - 4M 이력')
@UseGuards(JwtAuthGuard)
@Controller('quality/4m')
export class Qc4mController {
  constructor(private readonly service: Qc4mService) {}

  @Get()
  @ApiOperation({ summary: '4M 이력 조회 (PB w_qc_4m_master)' })
  async find(@Query() query: Qc4mQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Post()
  @ApiOperation({ summary: '4M 이력 등록' })
  async create(
    @Body() dto: Qc4mUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.create(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put()
  @ApiOperation({ summary: '4M 이력 수정 (키는 바꿀 수 없다)' })
  async update(
    @Body() dto: Qc4mUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.update(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({ summary: '4M 이력 삭제' })
  async remove(@Body() dto: Qc4mKeyDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(dto, organizationId));
  }
}

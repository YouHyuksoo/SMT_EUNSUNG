import { Body, Controller, Delete, Get, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  SmtPickupDeleteDto,
  SmtPickupQueryDto,
  SmtPickupUploadDto,
} from './smt-pickup.dto';
import { SmtPickupService } from './smt-pickup.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('SMT - 마운터 픽업정보관리')
@UseGuards(JwtAuthGuard)
@Controller('smt/pickup')
export class SmtPickupController {
  constructor(private readonly service: SmtPickupService) {}

  @Get()
  @ApiOperation({ summary: '픽업정보 조회 (PB w_mcn_feeder_pickup_master)' })
  async find(@Query() query: SmtPickupQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Post('upload')
  @ApiOperation({ summary: '엑셀 적재 (생산일+라인 범위를 갈아끼운다)' })
  async upload(
    @Body() dto: SmtPickupUploadDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.upload(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({ summary: '생산일+라인 범위 삭제' })
  async remove(@Body() dto: SmtPickupDeleteDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(dto, organizationId));
  }
}

import { Body, Controller, Delete, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  SmtLocationKeyDto,
  SmtLocationQueryDto,
  SmtLocationUpsertDto,
} from './smt-location.dto';
import { SmtLocationService } from './smt-location.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('SMT - 라인별 테이블 관리')
@UseGuards(JwtAuthGuard)
@Controller('smt/location')
export class SmtLocationController {
  constructor(private readonly service: SmtLocationService) {}

  @Get()
  @ApiOperation({ summary: '라인별 테이블·위치 조회 (PB w_smt_location_master)' })
  async find(@Query() query: SmtLocationQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Post()
  @ApiOperation({ summary: '위치 등록' })
  async create(
    @Body() dto: SmtLocationUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.create(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put()
  @ApiOperation({ summary: '위치 수정 (라인코드·위치코드는 키라 바꿀 수 없다)' })
  async update(
    @Body() dto: SmtLocationUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.update(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({ summary: '위치 삭제 (배포계획이 쓰고 있으면 거부)' })
  async remove(@Body() dto: SmtLocationKeyDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(dto, organizationId));
  }
}

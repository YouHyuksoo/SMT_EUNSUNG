import { Body, Controller, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import {
  MoldRepairItemQueryDto,
  MoldRepairItemUpsertDto,
  MoldRepairQueryDto,
  MoldRepairRequestDto,
  MoldRepairStatusDto,
  MoldRepairTargetQueryDto,
  MoldRepairUpdateDto,
} from './mold-repair.dto';
import { MoldRepairService } from './mold-repair.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('S-PARTS관리 - S-PARTS수리')
@UseGuards(JwtAuthGuard)
@Controller('mold/repair')
export class MoldRepairController {
  constructor(private readonly service: MoldRepairService) {}

  @Get()
  @ApiOperation({ summary: 'S-PARTS 수리 조회 (PB w_mcn_mold_repair_master)' })
  async find(@Query() query: MoldRepairQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(query, organizationId);
    return ResponseUtil.paged(result.data, result.total, result.page, result.limit);
  }

  @Get('targets')
  @ApiOperation({ summary: '수리 대상 S-PARTS 목록 (수리주기 포함)' })
  async findTargets(
    @Query() query: MoldRepairTargetQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.findTargets(query, organizationId));
  }

  @Get('items')
  @ApiOperation({ summary: '선택 수리건의 수리품목' })
  async findItems(
    @Query() query: MoldRepairItemQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.findItems(query, organizationId));
  }

  @Post('request')
  @ApiOperation({ summary: '수리 접수 (신청일=오늘, 상태=신청)' })
  async request(
    @Body() dto: MoldRepairRequestDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.request(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put()
  @ApiOperation({ summary: '수리 처리 내용 저장 (상태를 수리중으로)' })
  async update(
    @Body() dto: MoldRepairUpdateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.update(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put('status')
  @ApiOperation({ summary: '수리 확정/되돌리기 (PB Confirm / Cancel)' })
  async changeStatus(
    @Body() dto: MoldRepairStatusDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.changeStatus(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('items')
  @ApiOperation({ summary: '수리품목 저장 (수리 1건당 1행 — 기본키 제약)' })
  async saveItem(
    @Body() dto: MoldRepairItemUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.saveItem(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

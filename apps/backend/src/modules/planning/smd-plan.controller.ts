/**
 * @file src/modules/planning/smd-plan.controller.ts
 * @description 반제품생산계획 (SMD) — PB w_pln_assembly_master_plan_master
 *
 * 구현은 PlanBaseService 에 있다. 이 컨트롤러는 SMD 설정을 넘기기만 한다 —
 * 제품생산계획과 규칙이 같아 한쪽만 고쳐지는 일을 막는다.
 */
import { Body, Controller, Delete, Get, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { PlanConfirmDto, PlanKeyDto, PlanQueryDto, PlanUpsertDto } from './plan.dto';
import { PLAN_TABLES, PlanBaseService } from './plan-base.service';

const DEFAULT_USER = 'ADMIN';
const CFG = PLAN_TABLES.smd;

@ApiTags('생산 - 반제품생산계획')
@UseGuards(JwtAuthGuard)
@Controller('production/smd-plan')
export class SmdPlanController {
  constructor(private readonly service: PlanBaseService) {}

  @Get()
  @ApiOperation({ summary: '반제품생산계획 조회 (시간대 10칸 + 실적 대비)' })
  async find(@Query() query: PlanQueryDto, @OrganizationId() organizationId: number) {
    const result = await this.service.find(CFG, query, organizationId);
    return ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  }

  @Post()
  @ApiOperation({ summary: '계획 등록 (순번을 비우면 서버가 최대순번 + 1)' })
  async create(
    @Body() dto: PlanUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.create(CFG, dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put()
  @ApiOperation({ summary: '계획 수정 (계획일·순번은 키라 바꿀 수 없다)' })
  async update(
    @Body() dto: PlanUpsertDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.update(CFG, dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Put('confirm')
  @ApiOperation({ summary: '계획 확정 / 해제' })
  async setConfirm(
    @Body() dto: PlanConfirmDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.setConfirm(CFG, dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({ summary: '계획 삭제 (롯트카드가 붙어 있으면 거부)' })
  async remove(@Body() dto: PlanKeyDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(CFG, dto, organizationId));
  }
}

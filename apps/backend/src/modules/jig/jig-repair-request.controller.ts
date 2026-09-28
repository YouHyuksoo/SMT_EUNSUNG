/**
 * @file src/modules/jig/jig-repair-request.controller.ts
 * @description 187 지그수리신청 · 195 스퀴지검사관리(세척) 컨트롤러.
 */
import { Body, Controller, Delete, Get, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { ROW_LIMIT } from '../../shared/row-limit';
import {
  JigCleanCheckLookupDto,
  JigCleanCheckQueryDto,
  JigCleanCheckSaveDto,
} from './jig-clean-check.dto';
import { JigCleanCheckService } from './jig-clean-check.service';
import {
  JigRepairRequestCreateDto,
  JigRepairRequestDeleteDto,
  JigRepairRequestQueryDto,
  JigRepairRequestUpdateDto,
  RepairableJigQueryDto,
} from './jig-repair-request.dto';
import { JigRepairRequestService } from './jig-repair-request.service';

const DEFAULT_USER = 'SYSTEM';

const paged = <T>(result: { data: T[]; total: number; truncated?: boolean }) => {
  const base = ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  return {
    ...base,
    meta: { ...base.meta, truncated: Boolean(result.truncated), rowLimit: ROW_LIMIT },
  };
};

@ApiTags('지그 - 수리신청')
@UseGuards(JwtAuthGuard)
@Controller('jig/repair-request')
export class JigRepairRequestController {
  constructor(private readonly service: JigRepairRequestService) {}

  @Get()
  @ApiOperation({ summary: '187 수리 신청 목록.' })
  async find(
    @Query() query: JigRepairRequestQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findRequests(query, organizationId));
  }

  @Get('jigs')
  @ApiOperation({
    summary: '187 신청할 지그 목록. 아직 끝나지 않은 신청 건수를 함께 내 중복 신청을 막는다.',
  })
  async jigs(
    @Query() query: RepairableJigQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findRepairableJigs(query, organizationId));
  }

  @Post()
  @ApiOperation({ summary: '187 수리 신청 등록 (**쓰기**). 없는 지그로는 만들지 않는다.' })
  async create(
    @Body() dto: JigRepairRequestCreateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.createRequest(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Patch()
  @ApiOperation({
    summary: '187 신청 수정 (**쓰기**). 수리가 시작된 건(REPAIR_DATE 있음)은 고치지 않는다.',
  })
  async update(
    @Body() dto: JigRepairRequestUpdateDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.updateRequest(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Delete()
  @ApiOperation({ summary: '187 신청 취소 (**쓰기**). 수리가 시작된 건은 지우지 않는다.' })
  async remove(
    @Body() dto: JigRepairRequestDeleteDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(await this.service.deleteRequest(dto, organizationId));
  }
}

@ApiTags('지그 - 스퀴지 세척검사')
@UseGuards(JwtAuthGuard)
@Controller('jig/clean-check')
export class JigCleanCheckController {
  constructor(private readonly service: JigCleanCheckService) {}

  @Post('lookup')
  @ApiOperation({
    summary: '195 스퀴지 바코드를 푼다. 기준값과 마지막 세척일을 함께 낸다.',
  })
  async lookup(
    @Body() dto: JigCleanCheckLookupDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(
      await this.service.lookupJig(dto.jigLotNo, organizationId),
    );
  }

  @Get()
  @ApiOperation({ summary: '195 세척검사 이력.' })
  async find(
    @Query() query: JigCleanCheckQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findChecks(query, organizationId));
  }

  @Post()
  @ApiOperation({
    summary: '195 세척검사 등록 (**쓰기**). 합격이면 지그가 사용가능(U), 불합격이면'
      + ' 사용정지(S)가 된다. 검사기록과 지그상태가 한 트랜잭션에서 같이 움직인다'
      + ' (PB 는 따로 커밋했다).',
  })
  async save(
    @Body() dto: JigCleanCheckSaveDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.saveCheck(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

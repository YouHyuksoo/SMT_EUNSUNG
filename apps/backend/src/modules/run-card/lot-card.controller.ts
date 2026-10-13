// 롯트카드관리 (PB w_product_run_card_duckil) 버튼 기능 — /production/lot-card
//
// 목록·수정·삭제는 기존 /production/run-card 가 맡는다. 여기에는 PB 창의 버튼만 둔다.
// 쓰기는 로그인 사용자를 감사컬럼에 남겨야 해서 인증(전역 JWT 가드)을 거친다.
import { Body, Controller, Get, Param, Post, Query } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import {
  LotCardDetailDto, LotCardFromPlanDto, LotCardPidDto, LotCardPlanQueryDto, LotCardRunNosDto,
} from './lot-card.dto';
import { LotCardService } from './lot-card.service';

const DEFAULT_USER = 'ADMIN';
const DEFAULT_ORG = 1;

@ApiTags('생산관리 - 롯트카드관리')
@Controller('production/lot-card')
export class LotCardController {
  constructor(private readonly service: LotCardService) {}

  @Get('plans')
  @ApiOperation({ summary: '롯트카드를 만들 생산계획 (라인 구분 D=SMD 계획, 그 외=조립 계획)' })
  async plans(@Query() query: LotCardPlanQueryDto, @OrganizationId() organizationId?: number) {
    return ResponseUtil.success(await this.service.findPlans(query, organizationId ?? DEFAULT_ORG));
  }

  @Post('from-plan')
  @ApiOperation({ summary: '계획 한 줄로 롯트카드 생성 (BOM 1단계 상세 포함)' })
  async fromPlan(
    @Body() dto: LotCardFromPlanDto,
    @OrganizationId() organizationId?: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.createFromPlan(dto, organizationId ?? DEFAULT_ORG, userId || DEFAULT_USER),
    );
  }

  @Get('print')
  @ApiOperation({ summary: '롯트카드 출력 자료 (여러 장)' })
  async print(@Query() query: LotCardRunNosDto, @OrganizationId() organizationId?: number) {
    return ResponseUtil.success(await this.service.findPrint(query.runNos, organizationId ?? DEFAULT_ORG));
  }

  @Get('issue-plan')
  @ApiOperation({ summary: '출고계획 — 고른 롯트카드의 투입 자재 합계' })
  async issuePlan(@Query() query: LotCardRunNosDto, @OrganizationId() organizationId?: number) {
    return ResponseUtil.success(await this.service.findIssuePlan(query.runNos, organizationId ?? DEFAULT_ORG));
  }

  @Post(':runNo/detail')
  @ApiOperation({ summary: '상세(투입 자재) 다시 만들기 — 설계 BOM 전개 또는 피더 레이아웃' })
  async detail(
    @Param('runNo') runNo: string,
    @Body() dto: LotCardDetailDto,
    @OrganizationId() organizationId?: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.generateDetail(runNo, dto.source, organizationId ?? DEFAULT_ORG, userId || DEFAULT_USER),
    );
  }

  @Get(':runNo/pids')
  @ApiOperation({ summary: 'PID(2D 바코드) 목록' })
  async pids(@Param('runNo') runNo: string, @OrganizationId() organizationId?: number) {
    return ResponseUtil.success(await this.service.findPids(runNo, organizationId ?? DEFAULT_ORG));
  }

  @Post(':runNo/pids')
  @ApiOperation({ summary: 'PID(2D 바코드) 생성 — 지시수량만큼' })
  async createPids(
    @Param('runNo') runNo: string,
    @Body() dto: LotCardPidDto,
    @OrganizationId() organizationId?: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.createPids(runNo, dto, organizationId ?? DEFAULT_ORG, userId || DEFAULT_USER),
    );
  }


  @Get(':runNo/marking-file')
  @ApiOperation({ summary: '마킹기 파일(<RUN_NO>.JOB) 내용' })
  async markingFile(@Param('runNo') runNo: string, @OrganizationId() organizationId?: number) {
    return ResponseUtil.success(await this.service.findMarkingFile(runNo, organizationId ?? DEFAULT_ORG));
  }
}

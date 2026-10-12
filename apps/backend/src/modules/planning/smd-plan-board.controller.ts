/**
 * @file src/modules/planning/smd-plan-board.controller.ts
 * @description 반제품생산계획 현황판 — 날짜 하나의 라인별 블록 보조 데이터와 특이사항·공지 저장.
 *
 * 계획 행·시간대 실적은 기존 GET /production/smd-plan 을 화면이 함께 부른다.
 */
import { Body, Controller, Get, Put, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { SmdPlanBoardNoteSaveDto, SmdPlanBoardQueryDto } from './smd-plan-board.dto';
import { SmdPlanBoardService } from './smd-plan-board.service';

const DEFAULT_USER = 'ADMIN';

@ApiTags('생산 - 반제품생산계획 현황판')
@UseGuards(JwtAuthGuard)
@Controller('production/smd-plan-board')
export class SmdPlanBoardController {
  constructor(private readonly service: SmdPlanBoardService) {}

  @Get()
  @ApiOperation({ summary: '시간대 정의·라인 목록·계획 외 실적·특이사항 (날짜 1개)' })
  async getBoard(@Query() query: SmdPlanBoardQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.getBoard(query.date, organizationId));
  }

  @Put('notes')
  @ApiOperation({ summary: "특이사항·공지 저장 (날짜+라인 단위로 통째로 바꾼다, lineCode '*' = 날짜 공지)" })
  async saveNotes(
    @Body() dto: SmdPlanBoardNoteSaveDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.saveNotes(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

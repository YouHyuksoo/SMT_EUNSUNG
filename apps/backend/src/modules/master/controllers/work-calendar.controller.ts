/**
 * @file src/modules/master/controllers/work-calendar.controller.ts
 * @description 생산월력(IP_ 모델) API 컨트롤러
 *
 * 초보자 가이드:
 * 1. lineCode 미지정 = 전사 월력, 지정 = 라인 예외 월력.
 * 2. 조회(GET /days)는 전사+라인 병합 결과를 돌려준다.
 */
import { Body, Controller, Get, HttpCode, HttpStatus, Post, Put, Query } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { WorkCalendarService } from '../services/work-calendar.service';
import {
  BulkUpdateDaysDto,
  ConfirmDaysDto,
  CopyFromCompanyDto,
  GenerateCalendarDto,
  SummaryQueryDto,
  WorkCalendarDaysQueryDto,
} from '../dto/work-calendar.dto';

@ApiTags('기준정보 - 생산월력')
@Controller('master/work-calendar')
export class WorkCalendarController {
  constructor(private readonly svc: WorkCalendarService) {}

  @Get('days')
  @ApiOperation({ summary: '월별 일자 조회 (전사 + 라인 예외 병합)' })
  async findDays(@Query() q: WorkCalendarDaysQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.findDays(q, organizationId));
  }

  @Put('days/bulk')
  @ApiOperation({ summary: '일자 일괄 저장' })
  async bulkUpdateDays(@Body() dto: BulkUpdateDaysDto, @OrganizationId() organizationId: number) {
    const count = await this.svc.bulkUpdateDays(dto, organizationId);
    return ResponseUtil.success({ count }, '월력이 저장되었습니다.');
  }

  @Post('generate')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: '연간 생성 (주말·양력 고정공휴일 자동 반영)' })
  async generate(@Body() dto: GenerateCalendarDto, @OrganizationId() organizationId: number) {
    const count = await this.svc.generateYear(dto, organizationId);
    return ResponseUtil.success({ count }, '연간 월력이 생성되었습니다.');
  }

  @Post('copy-from-company')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: '라인 월력을 전사 월력에서 복제' })
  async copyFromCompany(
    @Body() dto: CopyFromCompanyDto,
    @OrganizationId() organizationId: number,
  ) {
    const count = await this.svc.copyFromCompany(dto, organizationId);
    return ResponseUtil.success({ count }, '전사 월력을 복사했습니다.');
  }

  @Post('confirm')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: '월력 확정' })
  async confirm(@Body() dto: ConfirmDaysDto, @OrganizationId() organizationId: number) {
    const count = await this.svc.confirm(dto, organizationId);
    return ResponseUtil.success({ count }, '월력이 확정되었습니다.');
  }

  @Post('unconfirm')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: '월력 확정 취소' })
  async unconfirm(@Body() dto: ConfirmDaysDto, @OrganizationId() organizationId: number) {
    const count = await this.svc.unconfirm(dto, organizationId);
    return ResponseUtil.success({ count }, '확정이 취소되었습니다.');
  }

  @Get('summary')
  @ApiOperation({ summary: '연간 요약 (가동일수·비가동일수·총가용시간)' })
  async getSummary(@Query() q: SummaryQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.getSummary(q, organizationId));
  }
}

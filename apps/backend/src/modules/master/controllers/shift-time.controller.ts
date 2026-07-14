/**
 * @file src/modules/master/controllers/shift-time.controller.ts
 * @description 2교대 시간 마스터(IP_SHIFT_TIME_MASTER) API 컨트롤러
 */
import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, Post, Put, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { ShiftTimeService } from '../services/shift-time.service';
import { CreateShiftTimeDto, UpdateShiftTimeDto } from '../dto/work-calendar.dto';

@ApiTags('기준정보 - 교대시간')
@UseGuards(JwtAuthGuard)
@Controller('master/shift-times')
export class ShiftTimeController {
  constructor(private readonly svc: ShiftTimeService) {}

  @Get()
  @ApiOperation({ summary: '교대시간 목록 (적용 시작일 내림차순)' })
  async findAll(@OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.findAll(organizationId));
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: '교대시간 등록' })
  async create(@Body() dto: CreateShiftTimeDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.svc.create(dto, organizationId), '교대시간이 등록되었습니다.');
  }

  @Put(':dateset')
  @ApiOperation({ summary: '교대시간 수정' })
  async update(
    @Param('dateset') dateset: string,
    @Body() dto: UpdateShiftTimeDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(
      await this.svc.update(dateset, dto, organizationId),
      '교대시간이 수정되었습니다.',
    );
  }

  @Delete(':dateset')
  @ApiOperation({ summary: '교대시간 삭제' })
  async remove(@Param('dateset') dateset: string, @OrganizationId() organizationId: number) {
    await this.svc.remove(dateset, organizationId);
    return ResponseUtil.success(null, '교대시간이 삭제되었습니다.');
  }
}

import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, Post, Put, Query, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../../common/decorators/tenant.decorator';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { CopyInterlockConditionDto, InterlockConditionQueryDto, SaveInterlockConditionDto } from '../dto/interlock-condition.dto';
import { InterlockConditionService } from '../services/interlock-condition.service';

@ApiTags('기준정보 - 인터락조건')
@UseGuards(JwtAuthGuard)
@Controller('master/interlock-conditions')
export class InterlockConditionController {
  constructor(private readonly service: InterlockConditionService) {}

  @Get()
  async findAll(@Query() query: InterlockConditionQueryDto, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.findAll(query, organizationId));
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  async create(@Body() dto: SaveInterlockConditionDto, @OrganizationId() organizationId: number, @UserId() userId: string | undefined) {
    return ResponseUtil.success(await this.service.create(dto, organizationId, userId), '인터락 조건을 등록했습니다.');
  }

  @Post('copy')
  async copy(@Body() dto: CopyInterlockConditionDto, @OrganizationId() organizationId: number, @UserId() userId: string | undefined) {
    const result = await this.service.copy(dto, organizationId, userId);
    return ResponseUtil.success(result, `인터락 조건 ${result.inserted}건을 복사했습니다.${result.skipped ? ` (이미 있는 ${result.skipped}건 제외)` : ''}`);
  }

  @Put(':rowKey')
  async update(@Param('rowKey') rowKey: string, @Body() dto: SaveInterlockConditionDto, @OrganizationId() organizationId: number, @UserId() userId: string | undefined) {
    return ResponseUtil.success(await this.service.update(rowKey, dto, organizationId, userId), '인터락 조건을 수정했습니다.');
  }

  @Delete(':rowKey')
  async remove(@Param('rowKey') rowKey: string, @OrganizationId() organizationId: number) {
    return ResponseUtil.success(await this.service.remove(rowKey, organizationId), '인터락 조건을 삭제했습니다.');
  }
}

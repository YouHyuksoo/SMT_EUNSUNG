// 설비 비가동 사유코드 REST 컨트롤러
import { Body, Controller, Delete, Get, Param, Post, Put } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { IdleReasonUpsertDto } from './idle-reason.dto';
import { IdleReasonService } from './idle-reason.service';

@Public()
@Controller('oee/idle-reason')
export class IdleReasonController {
  constructor(private readonly service: IdleReasonService) {}

  @Get()
  async list() {
    return { list: await this.service.list() };
  }

  @Post()
  async create(@Body() dto: IdleReasonUpsertDto) {
    await this.service.create(dto);
    return { ok: true };
  }

  @Put()
  async update(@Body() dto: IdleReasonUpsertDto) {
    await this.service.update(dto);
    return { ok: true };
  }

  @Delete(':reasonCode')
  async remove(@Param('reasonCode') reasonCode: string) {
    await this.service.remove(reasonCode);
    return { ok: true };
  }
}

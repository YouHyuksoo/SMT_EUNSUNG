// 설비별 비가동 사유 연계 REST 컨트롤러 (글로벌 prefix /api/v1): /oee/equip-reason-map
import { Body, Controller, Delete, Get, Param, Post, Put } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { EquipReasonMapUpsertDto } from './equip-reason-map.dto';
import { EquipReasonMapService } from './equip-reason-map.service';

@Public()
@Controller('oee/equip-reason-map')
export class EquipReasonMapController {
  constructor(private readonly service: EquipReasonMapService) {}

  @Get()
  async list() {
    return { list: await this.service.list() };
  }

  @Post()
  async create(@Body() dto: EquipReasonMapUpsertDto) {
    await this.service.upsert(dto);
    return { ok: true };
  }

  @Put()
  async update(@Body() dto: EquipReasonMapUpsertDto) {
    await this.service.upsert(dto);
    return { ok: true };
  }

  @Delete(':machineCode')
  async remove(@Param('machineCode') machineCode: string) {
    await this.service.remove(machineCode);
    return { ok: true };
  }
}

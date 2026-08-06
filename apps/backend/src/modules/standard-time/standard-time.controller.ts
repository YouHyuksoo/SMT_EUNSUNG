// 표준시간 관리 API — 라우트(글로벌 prefix api/v1): /oee/standard-time
import { Body, Controller, Delete, Get, Post, Put, Query } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { Public } from '../../common/decorators/public.decorator';
import { StandardTimeService } from './standard-time.service';
import { StdTimeUpsertDto } from './standard-time.dto';

@ApiTags('OEE-StandardTime')
@Public()
@Controller('oee/standard-time')
export class StandardTimeController {
  constructor(private readonly svc: StandardTimeService) {}

  @Get()
  @ApiOperation({ summary: '표준시간 목록' })
  async list() {
    return { list: await this.svc.list() };
  }

  @Get('items')
  @ApiOperation({ summary: '모델선택 팝업용 품목 목록' })
  async items() {
    return { items: await this.svc.items() };
  }

  @Post()
  @ApiOperation({ summary: '표준시간 신규' })
  async create(@Body() dto: StdTimeUpsertDto) {
    await this.svc.upsert({ ...dto, originalItemCode: undefined, originalValidFrom: undefined });
    return { ok: true };
  }

  @Put()
  @ApiOperation({ summary: '표준시간 수정' })
  async update(@Body() dto: StdTimeUpsertDto) {
    await this.svc.upsert(dto);
    return { ok: true };
  }

  @Delete()
  @ApiOperation({ summary: '표준시간 삭제' })
  async remove(@Query('itemCode') itemCode: string, @Query('validFrom') validFrom: string) {
    await this.svc.remove(itemCode, validFrom);
    return { ok: true };
  }
}

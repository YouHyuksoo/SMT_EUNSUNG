// 작업지시관리 REST 컨트롤러 (글로벌 prefix /api/v1): /production/run-card
import { Body, Controller, Delete, Get, Param, Post, Put, Query } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { RunCardUpsertDto } from './run-card.dto';
import { RunCardService } from './run-card.service';

@Public()
@Controller('production/run-card')
export class RunCardController {
  constructor(private readonly service: RunCardService) {}

  /** 목록 — 기간 필수, 나머지는 like 검색 */
  @Get()
  async list(
    @Query('fromDate') fromDate: string,
    @Query('toDate') toDate: string,
    @Query('runNo') runNo?: string,
    @Query('modelName') modelName?: string,
    @Query('lineCode') lineCode?: string,
    @Query('lotNo') lotNo?: string,
  ) {
    return {
      list: await this.service.list({
        fromDate,
        toDate,
        runNo: runNo || undefined,
        modelName: modelName || undefined,
        lineCode: lineCode || undefined,
        lotNo: lotNo || undefined,
      }),
    };
  }

  /** 단건 조회 */
  @Get(':runNo')
  async detail(@Param('runNo') runNo: string) {
    return await this.service.detail(runNo);
  }

  /** 등록 — RUN_NO 는 서버가 채번한다 */
  @Post()
  async create(@Body() dto: RunCardUpsertDto) {
    return await this.service.create(dto);
  }

  /** 수정 */
  @Put()
  async update(@Body() dto: RunCardUpsertDto) {
    return await this.service.update(dto);
  }

  /** 삭제 — 연결 데이터가 있으면 409 */
  @Delete(':runNo')
  async remove(@Param('runNo') runNo: string) {
    return await this.service.remove(runNo);
  }
}

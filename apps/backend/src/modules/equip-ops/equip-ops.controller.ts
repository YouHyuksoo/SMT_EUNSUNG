// 설비 운영 현황 REST 컨트롤러 (글로벌 prefix /api/v1): /oee/equip-ops
import { Controller, Get, Query } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { EquipOpsService } from './equip-ops.service';

@Public()
@Controller('oee/equip-ops')
export class EquipOpsController {
  constructor(private readonly service: EquipOpsService) {}

  /** 설비 목록 + 현재 가동상태 */
  @Get('machines')
  async machines(
    @Query('machineType') machineType?: string,
    @Query('workstageCode') workstageCode?: string,
    @Query('lineCode') lineCode?: string,
    @Query('keyword') keyword?: string,
  ) {
    return {
      list: await this.service.machines({
        machineType: machineType || undefined,
        workstageCode: workstageCode || undefined,
        lineCode: lineCode || undefined,
        keyword: keyword || undefined,
      }),
    };
  }

  /** 라인 목록 */
  @Get('lines')
  async lines() {
    return { list: await this.service.lines() };
  }

  /** 당일 지표 (비가동 분·정지 회수) */
  @Get('summary')
  async summary(@Query('machineCode') machineCode?: string, @Query('lineCode') lineCode?: string) {
    return await this.service.summary({
      machineCode: machineCode || undefined,
      lineCode: lineCode || undefined,
    });
  }

  /** 당월 비가동 이력 + 합계 */
  @Get('monthly')
  async monthly(@Query('machineCode') machineCode?: string, @Query('lineCode') lineCode?: string) {
    return await this.service.monthly({
      machineCode: machineCode || undefined,
      lineCode: lineCode || undefined,
    });
  }
}

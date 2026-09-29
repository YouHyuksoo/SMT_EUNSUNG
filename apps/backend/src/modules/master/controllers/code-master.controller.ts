/**
 * @file src/modules/master/controllers/code-master.controller.ts
 * @description 코드마스터(ISYS_CODE_MASTER) 조회 API.
 *
 * 공통코드(`/master/com-codes/all-active`)와 짝을 이루는 별도 코드 체계다.
 * 어떤 컬럼이 이쪽을 써야 하는지는 docs/database/pb-dddw-inventory.md 의 `kind: codemaster` 참고.
 */
import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { OrganizationId } from '../../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../../common/dto/response.dto';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { CodeMasterService } from '../services/code-master.service';

@ApiTags('Master - CodeMaster')
@UseGuards(JwtAuthGuard)
@Controller('master/code-masters')
export class CodeMasterController {
  constructor(private readonly codeMasterService: CodeMasterService) {}

  @Get('all-active')
  @ApiOperation({ summary: 'CODE_TYPE 별로 묶은 코드마스터 전체 조회' })
  @ApiResponse({ status: 200, description: 'OK' })
  async findAllActive(@OrganizationId() organizationId?: number) {
    return ResponseUtil.success(await this.codeMasterService.findAllActive(organizationId));
  }
}

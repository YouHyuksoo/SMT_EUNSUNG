/**
 * @file src/modules/process-transaction/magazine.controllers.ts
 * @description 매거진 3화면 컨트롤러.
 *
 *   /process-transaction/magazine-label  229 매거진라벨 발행 (발행·폐기 — 쓰기)
 *   /process-transaction/magazine-split  230 매거진라벨 분할 (쓰기)
 *   /process-transaction/magazine-pid    231 매거진-PID 매핑관리 (쓰기)
 */
import { Body, Controller, Get, Post, Query, UseGuards } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { OrganizationId, UserId } from '../../common/decorators/tenant.decorator';
import { ResponseUtil } from '../../common/dto/response.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { ROW_LIMIT } from '../../shared/row-limit';
import {
  MagazineDestroyDto,
  MagazineIssueDto,
  MagazineIssuedQueryDto,
  MagazineLabelLookupDto,
  MagazinePidCancelDto,
  MagazinePidMapDto,
  MagazinePidQueryDto,
  MagazineRunCardLookupDto,
  MagazineSplitDto,
  MagazineSplitQueryDto,
} from './magazine-label.dto';
import { MagazineLabelService } from './magazine-label.service';
import { MagazinePidService } from './magazine-pid.service';
import { MagazineSplitService } from './magazine-split.service';

/** 로그인 정보가 없는 호출에 남기는 표시. 원장에 빈 작성자를 남기지 않는다. */
const DEFAULT_USER = 'SYSTEM';

/** 상한에 걸렸는지를 `meta` 로 함께 내보낸다 (자재창고와 같은 규칙). */
const paged = <T>(result: { data: T[]; total: number; truncated?: boolean }) => {
  const base = ResponseUtil.paged(result.data, result.total, 1, result.total || 1);
  return {
    ...base,
    meta: { ...base.meta, truncated: Boolean(result.truncated), rowLimit: ROW_LIMIT },
  };
};

@ApiTags('공정수불관리 - 매거진라벨 발행')
@UseGuards(JwtAuthGuard)
@Controller('process-transaction/magazine-label')
export class MagazineLabelController {
  constructor(private readonly service: MagazineLabelService) {}

  @Post('lookup')
  @ApiOperation({
    summary: '229 런카드를 푼다. 찍은 값이 런카드번호가 아니면 매거진 라벨번호로'
      + ' 보고 그 라벨이 속한 런카드를 되짚는다 (PB 와 같은 두 단계).'
      + ' 발행 대상 모델과 이미 발행된 수량을 함께 낸다.',
  })
  async lookup(
    @Body() dto: MagazineRunCardLookupDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(
      await this.service.lookupRunCard(dto.scan, organizationId),
    );
  }

  @Get('issued')
  @ApiOperation({ summary: '229 이 런카드로 발행된 라벨 목록.' })
  async issued(
    @Query() query: MagazineIssuedQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findIssued(query, organizationId));
  }

  @Post()
  @ApiOperation({
    summary: '229 정상(P) 매거진라벨 발행 (**쓰기**). 장입수량 단위로 떼어 가며'
      + ' 마지막 상자는 남은 만큼만 담는다. 이미 발행한 수량 + 이번 수량이 런카드'
      + ' 지시수량을 넘으면 거절한다. 라벨 인쇄는 포함하지 않는다 — 발행된'
      + ' 라벨번호를 돌려주므로 인쇄는 뒤에 붙일 수 있다.',
  })
  async issue(
    @Body() dto: MagazineIssueDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.issueLabels(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('destroy-lookup')
  @ApiOperation({
    summary: '229 폐기할 라벨을 풀어 본다 (읽기 전용). 세트번호가 없거나 이미'
      + ' 공정에 투입된 라벨은 폐기할 수 없다고 알려 준다.',
  })
  async destroyLookup(
    @Body() dto: MagazineDestroyDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(
      await this.service.lookupDestroy(dto.magazineLabelNo, organizationId),
    );
  }

  @Post('destroy')
  @ApiOperation({
    summary: '229 매거진라벨 폐기 (**쓰기**). 이력표로 옮기고 원본을 지운다 —'
      + ' 지워진 라벨은 조회 화면에서 사라지므로 이력표가 유일한 흔적이다.'
      + ' 투입 여부는 DELETE 문 안에서 다시 막는다.',
  })
  async destroy(
    @Body() dto: MagazineDestroyDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(
      await this.service.destroyLabel(dto, organizationId),
    );
  }
}

@ApiTags('공정수불관리 - 매거진라벨 분할')
@UseGuards(JwtAuthGuard)
@Controller('process-transaction/magazine-split')
export class MagazineSplitController {
  constructor(private readonly service: MagazineSplitService) {}

  @Get()
  @ApiOperation({ summary: '230 분할로 생긴 조각 목록 (부모 라벨이 있는 행).' })
  async find(
    @Query() query: MagazineSplitQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findSplits(query, organizationId));
  }

  @Post('lookup')
  @ApiOperation({ summary: '230 나눌 라벨을 풀어 본다 (읽기 전용).' })
  async lookup(
    @Body() dto: MagazineLabelLookupDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(
      await this.service.lookupLabel(dto.magazineLabelNo, organizationId),
    );
  }

  @Post()
  @ApiOperation({
    summary: '230 매거진라벨 분할 (**쓰기**). 잔량 + 분할 + 불량 + 폐기 = 원본'
      + ' 수량이며, 합이 다르면 거절한다. 원본은 이력표로 옮겨지고 지워진다.'
      + ' 마지막에 PS_PROD_WS_IO_SPLIT_MAGAZINE 으로 공정 재고도 같이 가른다 —'
      + ' 프로시저가 NG 를 내면 앞선 원장 변경까지 되돌린다.',
  })
  async split(
    @Body() dto: MagazineSplitDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.splitLabel(dto, organizationId, userId || DEFAULT_USER),
    );
  }
}

@ApiTags('공정수불관리 - 매거진 PID 매핑')
@UseGuards(JwtAuthGuard)
@Controller('process-transaction/magazine-pid')
export class MagazinePidController {
  constructor(private readonly service: MagazinePidService) {}

  @Post('lookup')
  @ApiOperation({ summary: '231 매거진 라벨을 푼다 — 어느 런카드·모델의 상자인지.' })
  async lookup(
    @Body() dto: MagazineLabelLookupDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(
      await this.service.lookupMagazine(dto.magazineLabelNo, organizationId),
    );
  }

  @Get()
  @ApiOperation({
    summary: '231 이 상자에 들어간 PID 목록. MAGAZINE_NO 인덱스로 상자 하나만 읽는다'
      + ' (표가 1억 8천만 행이다).',
  })
  async find(
    @Query() query: MagazinePidQueryDto,
    @OrganizationId() organizationId: number,
  ) {
    return paged(await this.service.findMappings(query, organizationId));
  }

  @Post()
  @ApiOperation({
    summary: '231 PID 한 건을 상자에 담는다 (**쓰기**). 10자보다 짧으면 거절하고,'
      + ' 이미 등록된 PID 도 거절한다 — PB 는 화면 목록만 봐서 다른 상자에 들어간'
      + ' PID 를 놓쳤다.',
  })
  async map(
    @Body() dto: MagazinePidMapDto,
    @OrganizationId() organizationId: number,
    @UserId() userId?: string,
  ) {
    return ResponseUtil.success(
      await this.service.mapPid(dto, organizationId, userId || DEFAULT_USER),
    );
  }

  @Post('cancel')
  @ApiOperation({
    summary: '231 잘못 찍은 PID 를 뺀다 (**쓰기**). 이 상자에 들어간 것만 지우며,'
      + ' 검사가 이미 읽어 간 기록(QC_SCAN_YN=Y)은 지우지 않는다.',
  })
  async cancel(
    @Body() dto: MagazinePidCancelDto,
    @OrganizationId() organizationId: number,
  ) {
    return ResponseUtil.success(
      await this.service.cancelPid(dto, organizationId),
    );
  }
}

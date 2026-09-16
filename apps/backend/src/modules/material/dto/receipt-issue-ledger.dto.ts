/**
 * @file src/modules/material/dto/receipt-issue-ledger.dto.ts
 * @description 자재입출고수불원장 5개 모드 조회 DTO
 *
 * 레거시 PowerBuilder `w_mat_ledger_report`의 라디오 5모드를 각각 옮긴 것이다.
 * 모드마다 실제로 사용하는 필터가 다르므로 공통 DTO로 묶지 않는다.
 * 설계: docs/specs/2026-09-16-material-receipt-issue-ledger-design.md
 */

import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsDateString, IsIn, IsOptional, IsString, MaxLength } from 'class-validator';
import { PaginationQueryDto } from '../../../common/dto/base-query.dto';

/** 모드 1·2·3·5가 공유하는 기간 조회 기준. */
class LedgerDateRangeQueryDto extends PaginationQueryDto {
  @ApiPropertyOptional({ description: '조회 시작일 (YYYY-MM-DD)', example: '2026-09-01' })
  @IsDateString()
  dateFrom: string;

  @ApiPropertyOptional({ description: '조회 종료일 (YYYY-MM-DD)', example: '2026-09-16' })
  @IsDateString()
  dateTo: string;
}

/**
 * 모드 1 — 수불원장 (IM_ITEM_RECEIPT ∪ IM_ITEM_ISSUE).
 *
 * 레거시 인자 17개 중 실사용 16개를 받는다.
 * - arg_etc_line: 레거시는 기타라인 목록을 stringlist로 넘겼다. PB `cbx_etc_line` 체크 시
 *   IP_PRODUCT_LINE의 LINE_DIVISION='ETC' 라인을 커서로 읽어 채운다. 웹에서는 배열 바인드 대신
 *   같은 의미의 서브쿼리로 옮기고 excludeEtcLine 플래그로 제어한다.
 * - arg_keyitem_yn: 이 DataWindow의 retrieve SQL에 등장하지 않으므로 받지 않는다.
 */
export class ReceiptIssueLedgerQueryDto extends LedgerDateRangeQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (LIKE)' })
  @IsOptional() @IsString() @MaxLength(20) itemCode?: string;

  @ApiPropertyOptional({ description: 'LOT / MATERIAL_MFS (LIKE)' })
  @IsOptional() @IsString() @MaxLength(30) lotNo?: string;

  @ApiPropertyOptional({ description: '창고 LOCATION_CODE (LIKE)' })
  @IsOptional() @IsString() @MaxLength(20) locationCode?: string;

  @ApiPropertyOptional({ description: '재고유형 (LIKE)' })
  @IsOptional() @IsString() @MaxLength(20) inventoryType?: string;

  @ApiPropertyOptional({ description: '입고 공급처 (LIKE)' })
  @IsOptional() @IsString() @MaxLength(20) supplierCode?: string;

  @ApiPropertyOptional({ description: '입고 From 공급처 (LIKE)' })
  @IsOptional() @IsString() @MaxLength(20) fromSupplierCode?: string;

  @ApiPropertyOptional({ description: '출고 라인 (LIKE)' })
  @IsOptional() @IsString() @MaxLength(20) lineCode?: string;

  @ApiPropertyOptional({ description: '출고 공정 (LIKE)' })
  @IsOptional() @IsString() @MaxLength(10) workstageCode?: string;

  @ApiPropertyOptional({ description: '출고 공급처 (LIKE)' })
  @IsOptional() @IsString() @MaxLength(20) supplierIssue?: string;

  @ApiPropertyOptional({ description: '출고구분 ISSUE_DEFICIT (3=출고+, 4=출고-)' })
  @IsOptional() @IsString() @MaxLength(1) issueDeficit?: string;

  @ApiPropertyOptional({ description: '수불구분 (R=입고, I=출고, 미지정=전체)' })
  @IsOptional() @IsIn(['R', 'I']) rcvIssCode?: string;

  @ApiPropertyOptional({ description: "W00 공정 포함 여부. 'N'이면 WORKSTAGE_CODE <> 'W00'", default: 'Y' })
  @IsOptional() @IsIn(['Y', 'N']) includeW00?: string;

  @ApiPropertyOptional({
    description: "기타라인 제외 여부. 'Y'이면 IP_PRODUCT_LINE.LINE_DIVISION='ETC' 라인의 출고를 제외한다",
    default: 'N',
  })
  @IsOptional() @IsIn(['Y', 'N']) excludeEtcLine?: string;
}

/**
 * 모드 2 — 공정 수불원장 (IM_ITEM_WORKSTAGE_RECEIPT ∪ IM_ITEM_WORKSTAGE_ISSUE).
 *
 * 레거시는 인자 16개를 전달하지만 SQL WHERE 절이 쓰는 것은 5개뿐이다.
 * 나머지 11개는 선언·전달만 되므로 받지 않는다.
 */
export class WorkstageLedgerQueryDto extends LedgerDateRangeQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (LIKE)' })
  @IsOptional() @IsString() @MaxLength(20) itemCode?: string;

  @ApiPropertyOptional({ description: '수불구분 (R=입고, I=출고, 미지정=전체)' })
  @IsOptional() @IsIn(['R', 'I']) rcvIssCode?: string;
}

/** 모드 3 — 입고 바코드 (IM_ITEM_RECEIPT_BARCODE). 레거시 인자 9개 전부 실사용. */
export class ReceiptBarcodeQueryDto extends LedgerDateRangeQueryDto {
  @ApiPropertyOptional({ description: '품목코드 (LIKE)' })
  @IsOptional() @IsString() @MaxLength(20) itemCode?: string;

  @ApiPropertyOptional({ description: 'LOT_NO (LIKE)' })
  @IsOptional() @IsString() @MaxLength(30) lotNo?: string;

  @ApiPropertyOptional({ description: '입고전표번호 (LIKE)' })
  @IsOptional() @IsString() @MaxLength(50) slipNo?: string;

  @ApiPropertyOptional({ description: 'LOT 분할여부' })
  @IsOptional() @IsString() @MaxLength(1) lotDivide?: string;

  @ApiPropertyOptional({ description: '공급처 (LIKE)' })
  @IsOptional() @IsString() @MaxLength(20) supplierCode?: string;

  @ApiPropertyOptional({ description: '주요자재 여부 (ID_ITEM.KEYITEM_YN)' })
  @IsOptional() @IsIn(['Y', 'N']) keyitemYn?: string;
}

/**
 * 모드 4 — 라인 피더 레이아웃 (ID_ENG_BOM_SMT).
 *
 * 레거시 SQL에 조직 조건이 ID_ITEM outer join 조건으로만 들어가고
 * 독립 필터가 없다. 레거시 동작을 그대로 유지하므로 organizationId를 받지 않는다.
 */
export class FeederLayoutQueryDto extends PaginationQueryDto {
  @ApiPropertyOptional({ description: '자재 품목코드 CHILD_ITEM_CODE (LIKE)' })
  @IsOptional() @IsString() @MaxLength(20) itemCode?: string;

  @ApiPropertyOptional({ description: '모델 PARENT_ITEM_CODE (LIKE)' })
  @IsOptional() @IsString() @MaxLength(20) modelName?: string;

  @ApiPropertyOptional({ description: '주요자재 여부 (ID_ITEM.KEYITEM_YN)' })
  @IsOptional() @IsIn(['Y', 'N']) keyitemYn?: string;
}

/** 모드 5 — 출고 로스 (IM_ITEM_ISSUE_LOSS). 레거시 인자 8개 전부 실사용. */
export class IssueLossQueryDto extends LedgerDateRangeQueryDto {
  @ApiPropertyOptional({ description: '라인 (LIKE)' })
  @IsOptional() @IsString() @MaxLength(20) lineCode?: string;

  @ApiPropertyOptional({ description: '모델명 (LIKE)' })
  @IsOptional() @IsString() @MaxLength(100) modelName?: string;

  @ApiPropertyOptional({ description: '품목코드 (LIKE)' })
  @IsOptional() @IsString() @MaxLength(20) itemCode?: string;

  @ApiPropertyOptional({ description: 'LOT / MATERIAL_MFS (LIKE)' })
  @IsOptional() @IsString() @MaxLength(30) materialMfs?: string;

  @ApiPropertyOptional({ description: '주요자재 여부 (ID_ITEM.KEYITEM_YN)' })
  @IsOptional() @IsIn(['Y', 'N']) keyitemYn?: string;
}

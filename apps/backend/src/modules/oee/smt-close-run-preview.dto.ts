import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, Matches, MaxLength } from 'class-validator';

/** Read-only source validation query for a closed SMT run. */
export class SmtCloseRunPreviewQueryDto {
  @ApiProperty({ description: 'SMT run number' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(50)
  runNo: string;

  @ApiProperty({ description: 'CT 기준일 (YYYY-MM-DD)', example: '2026-08-24' })
  @IsString()
  @IsNotEmpty()
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  ctDate: string;
}

export type SmtCloseRunPreviewStatus = 'SOURCE_VALID' | 'SOURCE_INVALID';
export type SmtCloseRunCtStatus =
  'VALID' | 'MISSING' | 'DUPLICATE' | 'NON_POSITIVE';

export interface SmtCloseRunValidationError {
  code: string;
  message: string;
  count?: number;
}

export interface SmtCloseRunPreviewResponse {
  run: {
    runNo: string;
    runStatus: string;
    lineCode: string | null;
    itemCode: string | null;
    modelName: string | null;
  };
  resource: {
    resourceId: number | null;
    organizationId: number;
    processCode: string;
    resourceType: string;
    refCode: string;
    useYn: string;
  } | null;
  line: {
    lineCode: string;
    lineName: string | null;
  } | null;
  item: { itemCode: string } | null;
  model: string | null;
  customer: string | null;
  status: SmtCloseRunPreviewStatus;
  spi: { uniquePidCount: number };
  aoi: {
    uniquePidCount: number;
    outputCount: number;
    goodCount: number;
    defectCount: number;
    unclassifiedCount: number;
    ambiguousCount: number;
  };
  ct: {
    candidateCount: number;
    status: SmtCloseRunCtStatus;
    candidates: Array<{
      itemCode: string;
      dateset: string | null;
      dateend: string | null;
      ctValue: number | null;
    }>;
  };
  validationErrors: SmtCloseRunValidationError[];
}

// 설비 비가동 사유코드 upsert DTO
import { IsBoolean, IsIn, IsInt, IsNotEmpty, IsNumber, IsOptional, IsString } from 'class-validator';

export class IdleReasonUpsertDto {
  @IsString() @IsNotEmpty()
  reasonCode: string;

  @IsString() @IsNotEmpty()
  reasonName: string;

  @IsOptional() @IsString()
  description?: string;

  @IsIn(['PLAN', 'UNPLAN'])
  reasonType: string;         // 비가동 사유구분

  @IsIn(['Y', 'N'])
  oeeReflect: string;         // OEE 반영여부

  @IsInt()
  displayOrder: number;

  @IsBoolean()
  stdTimeEnabled: boolean;    // 표준시간 대상 여부

  @IsNumber()
  stdTimeValue: number;

  @IsIn(['HOUR', 'MIN', 'SEC'])
  stdTimeUnit: string;

  @IsIn(['Y', 'N'])
  useYn: string;              // 사용구분

  @IsOptional() @IsString()
  userId?: string;
}

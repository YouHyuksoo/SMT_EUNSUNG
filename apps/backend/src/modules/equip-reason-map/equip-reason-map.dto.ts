// 설비별 비가동 사유 연계 저장 DTO
import { ArrayNotEmpty, IsArray, IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class EquipReasonMapUpsertDto {
  @IsString() @IsNotEmpty()
  machineCode: string;

  @IsArray() @ArrayNotEmpty() @IsString({ each: true })
  reasonCodes: string[];

  @IsOptional() @IsString()
  userId?: string;
}

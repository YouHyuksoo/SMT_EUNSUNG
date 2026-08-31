// 표준시간 관리 upsert DTO
import { IsNotEmpty, IsNumber, IsOptional, IsString } from 'class-validator';

export class StdTimeUpsertDto {
  /** 수정 시 원본 키(모델/설비/시작일 변경 대응) */
  @IsOptional() @IsString()
  originalItemCode?: string;

  @IsOptional() @IsString()
  originalMachineCode?: string;

  @IsOptional() @IsString()
  originalValidFrom?: string; // YYYY-MM-DD

  @IsString() @IsNotEmpty()
  itemCode: string;           // 품목코드(모델코드)

  @IsString() @IsNotEmpty()
  machineCode: string;        // 설비코드 (IMCN_MACHINE.MACHINE_CODE)

  @IsString() @IsNotEmpty()
  validFrom: string;          // 적용 시작일 YYYY-MM-DD

  @IsString() @IsNotEmpty()
  validTo: string;            // 적용 종료일 YYYY-MM-DD (개방형 9999-12-31)

  @IsNumber()
  st: number;

  @IsNumber()
  ct: number;

  @IsNumber()
  nt: number;

  @IsNumber()
  tt: number;

  @IsOptional() @IsString()
  remark?: string;

  @IsOptional() @IsString()
  userId?: string;            // 등록/수정자 (없으면 서버 기본값)
}

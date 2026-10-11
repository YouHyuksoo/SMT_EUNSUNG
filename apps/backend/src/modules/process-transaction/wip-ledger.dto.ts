import { IsDateString, IsIn, IsOptional, IsString } from 'class-validator';

/** 공정 입출고 내역 구분: R 입고 · I 생산투입 · A 실사조정 (빈 값 = 전체) */
export type WipLedgerKind = '' | 'R' | 'I' | 'A';

export class WipLedgerQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsIn(['', 'R', 'I', 'A']) kind?: WipLedgerKind;
}

/**
 * @file src/modules/design/apply-item.dto.ts
 * @description 149 적용모델관리 입력 규칙.
 */
import { IsNotEmpty, IsString } from 'class-validator';

export class ApplyItemQueryDto {
  /** 거슬러 올라갈 자재(품목)코드. 비우면 서비스가 거절한다. */
  @IsString() @IsNotEmpty() itemCode!: string;
}

export class ApplyModelQueryDto {
  @IsString() @IsNotEmpty() itemCode!: string;
}

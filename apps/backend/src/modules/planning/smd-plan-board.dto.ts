/**
 * @file src/modules/planning/smd-plan-board.dto.ts
 * @description 반제품생산계획 현황판 DTO — 날짜 하나로 조회하고, 특이사항·공지를 날짜+라인 단위로 저장한다.
 */
import { ApiProperty } from '@nestjs/swagger';
import { ArrayMaxSize, IsArray, IsString, Length, Matches, MaxLength } from 'class-validator';

const DATE_ONLY = /^\d{4}-\d{2}-\d{2}$/;

/** 날짜 전체 공지를 저장할 때 쓰는 라인코드 */
export const BOARD_NOTICE_LINE = '*';

/** 한 블록에 저장할 수 있는 메모 줄 수 */
export const BOARD_NOTE_MAX_LINES = 30;

/** 메모 한 줄 최대 글자 수 (IP_PRODUCT_SMD_PLAN_NOTE.NOTE_TEXT 500 CHAR) */
export const BOARD_NOTE_MAX_LENGTH = 500;

export class SmdPlanBoardQueryDto {
  @ApiProperty({ description: '조회일 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  date!: string;
}

export class SmdPlanBoardNoteSaveDto {
  @ApiProperty({ description: '조회일 (YYYY-MM-DD)' })
  @IsString() @Matches(DATE_ONLY)
  date!: string;

  @ApiProperty({ description: `라인코드. '${BOARD_NOTICE_LINE}' 이면 날짜 전체 공지` })
  @IsString() @Length(1, 10)
  lineCode!: string;

  @ApiProperty({ description: '메모 줄 목록 (순서대로 저장, 빈 줄은 버린다, 빈 배열이면 전부 삭제)', type: [String] })
  @IsArray() @ArrayMaxSize(BOARD_NOTE_MAX_LINES)
  @IsString({ each: true }) @MaxLength(BOARD_NOTE_MAX_LENGTH, { each: true })
  lines!: string[];
}

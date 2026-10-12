import { Type } from 'class-transformer';
import {
  ArrayMaxSize, ArrayNotEmpty, IsArray, IsDateString, IsInt, IsNumber,
  IsOptional, IsString, Length, Max, Min,
} from 'class-validator';

/** 품질이상발생 조회 — PB d_qc_notify_lst 의 retrieve 인자와 1:1 */
export class QcNotifyQueryDto {
  @IsDateString() dateFrom!: string;
  @IsDateString() dateTo!: string;
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() workstageCode?: string;
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() materialMaker?: string;
  @IsOptional() @IsString() machineCode?: string;
  @IsOptional() @IsString() notifyStatus?: string;
  /** PB 는 불량내용·비고를 OR 로 훑었다 */
  @IsOptional() @IsString() keyword?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/**
 * 품질이상발생 등록.
 * 발생일자·발생항번은 받지 않는다 — PB 와 같이 오늘 + SEQ_QC_NOTIFY_SEQUENCE 로 서버가 채운다.
 * 첨부 이미지 3종(NG / 검사 / 문서)은 이관 범위 밖이라 받지 않는다.
 */
export class QcNotifyCreateDto {
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() lineCode?: string;
  @IsOptional() @IsString() workstageCode?: string;
  @IsOptional() @IsString() machineCode?: string;
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() runNo?: string;
  @IsOptional() @IsString() grade?: string;
  @IsOptional() @IsString() badReasonCode?: string;
  @IsOptional() @IsString() detectLocation?: string;
  @IsOptional() @IsString() materialMaker?: string;
  @IsOptional() @IsString() locationInfo?: string;
  @IsOptional() @IsString() badDescription?: string;
  @IsOptional() @IsString() inspectCharger?: string;
  @IsOptional() @IsString() inspectManager?: string;
  @IsOptional() @IsString() departmentCode?: string;
  @IsOptional() @IsString() lineStatusNotify?: string;
  @IsOptional() @IsString() comments?: string;
  @IsOptional() @IsString() qcComments?: string;

  @IsOptional() @Type(() => Number) @IsNumber() inspectQty?: number;
  @IsOptional() @Type(() => Number) @IsNumber() inspectBadQty?: number;
  @IsOptional() @IsDateString() startTime?: string;
  @IsOptional() @IsDateString() endTime?: string;
}

/** 수정 — 키(발생일자 + 항번)는 바꿀 수 없다 */
export class QcNotifyUpdateDto extends QcNotifyCreateDto {
  @IsDateString() actionDate!: string;
  @Type(() => Number) @IsNumber() notifySequence!: number;
}

/** 단건 지정 */
export class QcNotifyKeyDto {
  @IsDateString() actionDate!: string;
  @Type(() => Number) @IsNumber() notifySequence!: number;
}

/**
 * 조치상태 변경 — PB 는 목록에서 NOTIFY_STATUS / COMPLETE_YN 을 바꿔 저장했다.
 * 완료로 바꾸면 완료일시를 서버가 찍는다.
 */
export class QcNotifyStatusDto extends QcNotifyKeyDto {
  @IsOptional() @IsString() notifyStatus?: string;
  @IsOptional() @IsString() completeYn?: string;
}

/** 품질알림(ECO) 대상 조회 — PB d_qc_eco_notify_lst (품목 기준) */
export class EcoNotifyQueryDto {
  @IsOptional() @IsString() itemCode?: string;
  @IsOptional() @IsString() itemName?: string;
  @IsOptional() @IsString() modelName?: string;
  @IsOptional() @IsString() ecoCheckYn?: string;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) page = 1;
  @IsOptional() @Type(() => Number) @IsInt() @Min(1) @Max(5000) limit = 500;
}

/**
 * 품질알림 확인 처리 — PB 는 체크한 품목의 ID_ITEM.ECO_CHECK_YN / ECO_CHECK_COMMENTS 를 바꿨다.
 * 첨부 이미지(ID_ITEM_IMAGE) 쓰기는 이관 범위 밖이다.
 */
export class EcoNotifyUpdateDto {
  @IsArray() @ArrayNotEmpty() @ArrayMaxSize(1000)
  @IsString({ each: true }) @Length(1, 30, { each: true })
  itemCodes!: string[];

  @IsString() @Length(1, 1) ecoCheckYn!: string;
  @IsOptional() @IsString() ecoCheckComments?: string;
}

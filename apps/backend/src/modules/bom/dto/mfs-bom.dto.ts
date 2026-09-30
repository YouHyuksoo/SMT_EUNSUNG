import { Transform } from 'class-transformer';
import { IsIn, IsNotEmpty, IsOptional, IsString, Matches, MaxLength } from 'class-validator';

/** ID_MFS_BOM.MFS 는 VARCHAR2(30). 공백 제거 후 대문자로 저장한다(PB 입력과 동일). */
const MFS_MAX_LENGTH = 30;
const toMfs = ({ value }: { value: unknown }) =>
  typeof value === 'string' ? value.trim().toUpperCase() : value;
/** 새 MFS 이름 규칙: 공백·% 금지 (% 는 피더 레이아웃 조회의 LIKE 와일드카드가 된다) */
const MFS_PATTERN = /^[^%\s]+$/;
const MFS_PATTERN_MESSAGE = 'MFS 에는 공백과 % 를 쓸 수 없습니다.';
const trim = ({ value }: { value: unknown }) => (typeof value === 'string' ? value.trim() : value);

/** 제품모델 목록 조건 (PB d_pln_product_model_master_lst 조건) — 둘 다 앞부분 일치 */
export class MfsModelQueryDto {
  @IsOptional() @Transform(trim) @IsString() modelName?: string;
  @IsOptional() @Transform(trim) @IsString() itemCode?: string;
}

/** 제품 품목의 MFS 목록 조건 */
export class MfsListQueryDto {
  @Transform(trim) @IsString() @IsNotEmpty() itemCode!: string;
}

/** 품목 + MFS 한 벌을 가리키는 키 (상세 조회, 삭제, 승인, 승인취소) */
export class MfsKeyDto {
  @Transform(trim) @IsString() @IsNotEmpty() itemCode!: string;

  @Transform(toMfs) @IsString() @IsNotEmpty() @MaxLength(MFS_MAX_LENGTH)
  mfs!: string;
}

/** 피더 레이아웃 조건 — 선택한 모델의 SMT 모델명 + MFS(ID_ENG_BOM_SMT.REVISION) */
export class MfsFeederQueryDto {
  @Transform(trim) @IsString() @IsNotEmpty() smtModelName!: string;
  @Transform(toMfs) @IsString() @IsNotEmpty() mfs!: string;
}

/** 생성 — 설계BOM 을 전개해 MFS 한 벌을 만든다. showHide=Y 면 PKG_DESIGN.BOM_QUERY_ALL */
export class MfsGenerateDto {
  @Transform(trim) @IsString() @IsNotEmpty() itemCode!: string;

  /** 새로 만드는 MFS 이름이므로 형식 검사를 추가한다 */
  @Transform(toMfs) @IsString() @IsNotEmpty() @MaxLength(MFS_MAX_LENGTH)
  @Matches(MFS_PATTERN, { message: MFS_PATTERN_MESSAGE })
  mfs!: string;

  @IsOptional() @IsIn(['Y', 'N']) showHide: 'Y' | 'N' = 'Y';
}

/** 복사 — 같은 품목의 원본 MFS 를 새 MFS 로 복사 */
export class MfsCopyDto {
  @Transform(trim) @IsString() @IsNotEmpty() itemCode!: string;

  @Transform(toMfs) @IsString() @IsNotEmpty() @MaxLength(MFS_MAX_LENGTH)
  sourceMfs!: string;

  @Transform(toMfs) @IsString() @IsNotEmpty() @MaxLength(MFS_MAX_LENGTH)
  @Matches(MFS_PATTERN, { message: MFS_PATTERN_MESSAGE })
  destMfs!: string;
}

/** 전체 사용 / 전체 미사용 */
export class MfsUsedDto extends MfsKeyDto {
  @IsIn(['Y', 'N']) usedYn!: 'Y' | 'N';
}

/**
 * @file packages/shared/src/utils/work-instruction-rules.ts
 * @description 작업지도서 복합키 계약 (프론트 조립 / 백엔드 파싱 단일 출처)
 *
 * 복합키 형식: `itemCode::processCode::revision`
 */
/** 복합키 구분자 */
export declare const WORK_INSTRUCTION_KEY_SEPARATOR = "::";
/** revision 미지정 시 기본값 */
export declare const WORK_INSTRUCTION_DEFAULT_REVISION = "A";
export interface WorkInstructionKeyParts {
    itemCode: string;
    processCode: string;
    revision: string;
}
/** 복합키 문자열 조립. processCode 미지정 시 빈 문자열, revision 미지정 시 'A'. */
export declare function buildWorkInstructionKey(input: {
    itemCode: string;
    processCode?: string | null;
    revision?: string | null;
}): string;
/** 복합키 문자열 파싱. 정확히 3개 파트가 아니면 null. */
export declare function parseWorkInstructionKey(id: string): WorkInstructionKeyParts | null;
//# sourceMappingURL=work-instruction-rules.d.ts.map

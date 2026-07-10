"use strict";
/**
 * @file packages/shared/src/utils/work-instruction-rules.ts
 * @description 작업지도서 복합키 계약 (프론트 조립 / 백엔드 파싱 단일 출처)
 *
 * 복합키 형식: `itemCode::processCode::revision`
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.WORK_INSTRUCTION_DEFAULT_REVISION = exports.WORK_INSTRUCTION_KEY_SEPARATOR = void 0;
exports.buildWorkInstructionKey = buildWorkInstructionKey;
exports.parseWorkInstructionKey = parseWorkInstructionKey;
/** 복합키 구분자 */
exports.WORK_INSTRUCTION_KEY_SEPARATOR = '::';
/** revision 미지정 시 기본값 */
exports.WORK_INSTRUCTION_DEFAULT_REVISION = 'A';
/** 복합키 문자열 조립. processCode 미지정 시 빈 문자열, revision 미지정 시 'A'. */
function buildWorkInstructionKey(input) {
    return [
        input.itemCode,
        input.processCode || '',
        input.revision || exports.WORK_INSTRUCTION_DEFAULT_REVISION,
    ].join(exports.WORK_INSTRUCTION_KEY_SEPARATOR);
}
/** 복합키 문자열 파싱. 정확히 3개 파트가 아니면 null. */
function parseWorkInstructionKey(id) {
    const parts = id.split(exports.WORK_INSTRUCTION_KEY_SEPARATOR);
    if (parts.length === 3) {
        return { itemCode: parts[0], processCode: parts[1], revision: parts[2] };
    }
    return null;
}

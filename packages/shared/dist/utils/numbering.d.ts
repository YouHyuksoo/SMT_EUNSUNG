/**
 * @file packages/shared/src/utils/numbering.ts
 * @description 체번(번호 생성) 유틸리티 함수
 *
 * 초보자 가이드:
 * 1. **LOT 번호**: 자재 입고 시 부여되는 추적 번호
 * 2. **박스 번호**: 포장 완료된 박스의 QR 코드
 * 3. **팔레트 번호**: 적재 팔레트의 QR 코드
 *
 * 번호 체계:
 * - LOT: LOT + YYYYMMDD + 라인코드 + 일련번호 (예: LOT20240115L01001)
 * - BOX: BOX + YYYYMMDD + 라인코드 + 일련번호 (예: BOX20240115L01001)
 * - PLT: PLT + YYYYMMDD + 일련번호 (예: PLT20240115001)
 */
/** 번호 생성 옵션 */
export interface NumberingOptions {
    prefix?: string;
    date?: Date;
    lineCode?: string;
    sequence?: number;
    sequenceLength?: number;
}
/**
 * LOT 번호 생성
 * @param options 생성 옵션
 * @returns LOT 번호 (예: LOT20240115L01001)
 *
 * @example
 * generateLotNumber({ lineCode: 'L01', sequence: 1 })
 * // 'LOT20240115L01001'
 */
export declare function generateLotNumber(options?: NumberingOptions): string;
/**
 * 박스 번호 생성
 * @param options 생성 옵션
 * @returns 박스 번호 (예: BOX20240115L01001)
 *
 * @example
 * generateBoxNumber({ lineCode: 'L01', sequence: 1 })
 * // 'BOX20240115L01001'
 */
export declare function generateBoxNumber(options?: NumberingOptions): string;
/**
 * 팔레트 번호 생성
 * @param options 생성 옵션
 * @returns 팔레트 번호 (예: PLT20240115001)
 *
 * @example
 * generatePalletNumber({ sequence: 1 })
 * // 'PLT20240115001'
 */
export declare function generatePalletNumber(options?: NumberingOptions): string;
/**
 * 시리얼 번호 생성
 * @param options 생성 옵션
 * @returns 시리얼 번호 (예: SER20240115093045001)
 *
 * @example
 * generateSerialNumber({ sequence: 1 })
 * // 'SER20240115093045001'
 */
export declare function generateSerialNumber(options?: NumberingOptions): string;
/**
 * 작업지시 번호 생성
 * @param options 생성 옵션
 * @returns 작업지시 번호 (예: WO20240115001)
 *
 * @example
 * generateJobOrderNumber({ sequence: 1 })
 * // 'WO20240115001'
 */
export declare function generateJobOrderNumber(options?: NumberingOptions): string;
/**
 * 출하 번호 생성
 * @param options 생성 옵션
 * @returns 출하 번호 (예: SHP20240115001)
 */
export declare function generateShipmentNumber(options?: NumberingOptions): string;
/**
 * 검사 번호 생성
 * @param inspType 검사 유형 (PQC, FQC, OQC)
 * @param options 생성 옵션
 * @returns 검사 번호 (예: PQC20240115001)
 */
export declare function generateInspectionNumber(inspType: 'PQC' | 'FQC' | 'OQC', options?: NumberingOptions): string;
/**
 * 불량 번호 생성
 * @param processCode 공정 코드 (CUT, CRM, ASM 등)
 * @param options 생성 옵션
 * @returns 불량 번호 (예: DEF-CUT-20240115-001)
 */
export declare function generateDefectNumber(processCode: string, options?: NumberingOptions): string;
/**
 * 수리 번호 생성
 * @param options 생성 옵션
 * @returns 수리 번호 (예: RPR20240115001)
 */
export declare function generateRepairNumber(options?: NumberingOptions): string;
/**
 * 재고 조정 번호 생성
 * @param options 생성 옵션
 * @returns 조정 번호 (예: ADJ20240115001)
 */
export declare function generateAdjustmentNumber(options?: NumberingOptions): string;
/**
 * 이동 번호 생성
 * @param options 생성 옵션
 * @returns 이동 번호 (예: TRF20240115001)
 */
export declare function generateTransferNumber(options?: NumberingOptions): string;
/**
 * 번호에서 날짜 추출
 * @param number 생성된 번호
 * @returns 날짜 문자열 (YYYYMMDD) 또는 null
 *
 * @example
 * extractDateFromNumber('LOT20240115L01001') // '20240115'
 */
export declare function extractDateFromNumber(number: string): string | null;
/**
 * 번호에서 일련번호 추출
 * @param number 생성된 번호
 * @returns 일련번호 또는 null
 *
 * @example
 * extractSequenceFromNumber('LOT20240115L01001') // 1
 */
export declare function extractSequenceFromNumber(number: string): number | null;
/**
 * 번호 유효성 검사
 * @param number 검사할 번호
 * @param prefix 예상 접두사
 * @returns 유효하면 true
 */
export declare function isValidNumber(number: string, prefix: string): boolean;
//# sourceMappingURL=numbering.d.ts.map
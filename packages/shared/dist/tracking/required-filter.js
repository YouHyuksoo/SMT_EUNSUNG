"use strict";
/**
 * @file packages/shared/src/tracking/required-filter.ts
 * @description 추적 조회의 필수조건 규칙. 프론트(조회 버튼 차단)와 백엔드(요청 거부)가
 *              같은 판정을 쓴다.
 *
 * 왜 한 곳에 두는가:
 * 추적 화면이 읽는 표는 실측으로 이만큼 크다 (2026-09 기준).
 *
 *     IP_PRODUCT_2D_BARCODE        180,403,900
 *     IQ_MACHINE_INSPECT_DATA_AOI  175,188,481
 *     IQ_MACHINE_INSPECT_AOI       116,341,116
 *     IQ_MACHINE_INSPECT_DATA_SPI  108,312,766
 *     IQ_MACHINE_INSPECT_DATA_MK   106,459,417
 *     IQ_MACHINE_INSPECT_SPI       100,515,098
 *
 * 조건 없이 열면 화면이 아니라 DB 가 멈춘다. PB 는 `값 + '%'` 관례로 빈 입력을
 * `'%'` 로 보냈으므로 **조건 없는 전체 조회가 실제로 가능했다.** 그것을 그대로
 * 옮기면 안 된다.
 *
 * 판정 기준은 '어느 표를 끌고 도는가'(driving table)다. 이름이 큰 표가 아니라
 * WHERE 가 처음 좁히는 표가 비용을 정한다. 실측 인덱스:
 *
 *     IP_PRODUCT_2D_BARCODE        (SERIAL_NO) · (RUN_NO, SERIAL_NO)
 *     IQ_MACHINE_INSPECT_SPI       (INSPECT_DATE, PID) · (PID, INSPECT_DATE)
 *     IQ_MACHINE_INSPECT_DATA_SPI  (INSPECT_DATE, PID) · (PID, INSPECT_DATE) · (RUN_NO)
 *     IQ_MACHINE_INSPECT_DATA_AOI  (INSPECT_DATE, PID) · (PID, INSPECT_DATE) · (RUN_NO)
 *     IQ_MACHINE_INSPECT_DATA_MK   (PID) · (RUN_NO)
 *     IB_SMT_CHECKHIST             (LOT_NO, CHECK_TYPE, CHECK_STATUS) · (CHECK_DATE, ...) · (RUN_NO)
 *
 * 즉 키 하나(제조번호·PID·Run No)가 있으면 인덱스 한 번으로 끝난다. 키가 없으면
 * **기간이 닫혀 있고 라인이 지정돼야** 인덱스 구간 스캔이 된다.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.TRACKING_FILTER_HINT = exports.TRACKING_DATE_RANGE_MAX_DAYS = void 0;
exports.checkTrackingFilter = checkTrackingFilter;
/**
 * 키 없이 기간으로 여는 경우 허용하는 최대 기간(일).
 * 31일은 '한 달 조회'를 막지 않는 가장 짧은 값이다. 실측 인덱스가
 * (INSPECT_DATE, PID) 선두라 기간이 닫혀 있으면 구간 스캔으로 끝난다.
 */
exports.TRACKING_DATE_RANGE_MAX_DAYS = 31;
/** 화면에 그대로 띄우는 안내 문구. 프론트·백엔드가 같은 문장을 쓴다. */
exports.TRACKING_FILTER_HINT = '제조번호 · PID · Run No 중 하나를 입력하거나, 라인과 기간(최대 '
    + `${exports.TRACKING_DATE_RANGE_MAX_DAYS}일)을 함께 지정하세요.`;
const filled = (value) => typeof value === 'string' && value.trim().length > 0 && value.trim() !== '%';
/** 두 날짜 문자열의 간격(일). 파싱 실패면 null. */
const spanDays = (from, to) => {
    const a = Date.parse(from);
    const b = Date.parse(to);
    if (Number.isNaN(a) || Number.isNaN(b))
        return null;
    return (b - a) / 86_400_000;
};
/**
 * 추적 조회를 허용할지 판정한다.
 *
 * 1. 키(제조번호·PID·Run No) 가 하나라도 있으면 통과. 인덱스 단건 조회다.
 * 2. 키가 없으면 라인 + 닫힌 기간이 모두 있어야 하고 기간이 상한 안이어야 한다.
 * 3. 그 외는 거부한다. **거부 사유를 문장으로 돌려준다** — "조회 실패" 만 띄우면
 *    사용자가 무엇을 채워야 하는지 알 수 없다.
 */
function checkTrackingFilter(input) {
    if (filled(input.lotNo) || filled(input.serialNo) || filled(input.runNo)) {
        return { ok: true };
    }
    if (!filled(input.lineCode)) {
        return { ok: false, reason: exports.TRACKING_FILTER_HINT };
    }
    if (!filled(input.dateFrom) || !filled(input.dateTo)) {
        return {
            ok: false,
            reason: `라인만으로는 조회할 수 없습니다. 기간(최대 ${exports.TRACKING_DATE_RANGE_MAX_DAYS}일)을 함께 지정하세요.`,
        };
    }
    const span = spanDays(String(input.dateFrom), String(input.dateTo));
    if (span === null) {
        return { ok: false, reason: '기간 형식을 읽을 수 없습니다. YYYY-MM-DD 로 지정하세요.' };
    }
    if (span < 0) {
        return { ok: false, reason: '기간 시작이 종료보다 늦습니다.' };
    }
    if (span > exports.TRACKING_DATE_RANGE_MAX_DAYS) {
        return {
            ok: false,
            reason: `기간이 ${Math.round(span)}일입니다. 키 없이 조회할 수 있는 최대 기간은 `
                + `${exports.TRACKING_DATE_RANGE_MAX_DAYS}일입니다.`,
        };
    }
    return { ok: true };
}

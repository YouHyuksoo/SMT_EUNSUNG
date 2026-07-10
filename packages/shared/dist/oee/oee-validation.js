"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateIntervals = validateIntervals;
/**
 * 가동일지 구간을 검증한다. 위반이 없으면 빈 배열을 반환한다.
 * 검사: ①역전(end<=start) ②겹침 ③합>계획가동 ④DOWN인데 사유없음.
 */
function validateIntervals(intervals, netLoadMinutes) {
    const errors = [];
    intervals.forEach((iv, i) => {
        if (iv.endMin <= iv.startMin) {
            errors.push({ code: 'REVERSED', index: i, message: `구간 ${i + 1}: 종료가 시작보다 같거나 빠릅니다` });
        }
        if (iv.status === 'DOWN' && !iv.reasonCode) {
            errors.push({ code: 'REASON_REQUIRED', index: i, message: `구간 ${i + 1}: 비가동은 사유가 필수입니다` });
        }
    });
    const ordered = intervals
        .map((iv, i) => ({ iv, i }))
        .sort((a, b) => a.iv.startMin - b.iv.startMin);
    for (let k = 1; k < ordered.length; k++) {
        if (ordered[k].iv.startMin < ordered[k - 1].iv.endMin) {
            errors.push({ code: 'OVERLAP', index: ordered[k].i, message: `구간 ${ordered[k].i + 1}: 이전 구간과 겹칩니다` });
        }
    }
    const total = intervals.reduce((sum, iv) => sum + Math.max(0, iv.endMin - iv.startMin), 0);
    if (netLoadMinutes > 0 && total > netLoadMinutes) {
        errors.push({ code: 'EXCEEDS_LOAD', index: -1, message: `구간 합(${total}분)이 계획가동시간(${netLoadMinutes}분)을 초과합니다` });
    }
    return errors;
}

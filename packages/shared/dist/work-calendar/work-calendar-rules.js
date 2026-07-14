"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FIXED_HOLIDAYS = void 0;
exports.shiftNetMinutes = shiftNetMinutes;
exports.defaultWorkMinutes = defaultWorkMinutes;
exports.holidayYnOf = holidayYnOf;
exports.isFixedHoliday = isFixedHoliday;
/** 양력 고정공휴일 [월, 일] */
exports.FIXED_HOLIDAYS = [
    [1, 1],
    [3, 1],
    [5, 5],
    [6, 6],
    [8, 15],
    [10, 3],
    [10, 9],
    [12, 25],
];
const MINUTES_PER_DAY = 24 * 60;
/** 'HH:MM' / 'HH:MM:SS' → 자정 기준 분. 형식이 깨지면 null. */
function toMinutes(hhmm) {
    if (!hhmm)
        return null;
    const m = /^(\d{1,2}):(\d{2})(?::\d{2})?$/.exec(hhmm.trim());
    if (!m)
        return null;
    const hours = Number(m[1]);
    const minutes = Number(m[2]);
    if (hours > 23 || minutes > 59)
        return null;
    return hours * 60 + minutes;
}
/** 교대 구간의 순근무분 = (종료 - 시작) - 휴식. 자정 넘김 처리. 음수는 0. */
function shiftNetMinutes(span) {
    const start = toMinutes(span.start);
    const end = toMinutes(span.end);
    if (start === null || end === null)
        return 0;
    const raw = end > start ? end - start : end < start ? end + MINUTES_PER_DAY - start : 0;
    return Math.max(0, raw - span.breakMinutes);
}
function dayNetMinutes(shift) {
    if (!shift?.dayTimeStart || !shift.dayTimeEnd)
        return 0;
    return shiftNetMinutes({
        start: shift.dayTimeStart,
        end: shift.dayTimeEnd,
        breakMinutes: shift.dayBreakMinutes,
    });
}
function nightNetMinutes(shift) {
    if (!shift?.nightTimeStart || !shift.nightTimeEnd)
        return 0;
    return shiftNetMinutes({
        start: shift.nightTimeStart,
        end: shift.nightTimeEnd,
        breakMinutes: shift.nightBreakMinutes,
    });
}
/**
 * 근무유형별 기본 근무분.
 * OFF=0 / WORK=주간+야간 / HALF=주간÷2(내림) / SPECIAL=주간(휴일 특근은 주간 1교대)
 * 사용자가 일자편집에서 override할 수 있으며, 저장되는 값은 최종값이다.
 */
function defaultWorkMinutes(dayType, shift) {
    if (dayType === 'OFF')
        return 0;
    const day = dayNetMinutes(shift);
    if (dayType === 'HALF')
        return Math.floor(day / 2);
    if (dayType === 'SPECIAL')
        return day;
    return day + nightNetMinutes(shift);
}
/** HOLIDAY_YN은 DAY_TYPE에서 파생한다. 직접 입력받지 않는다. */
function holidayYnOf(dayType) {
    return dayType === 'OFF' ? 'Y' : 'N';
}
/** 'YYYY-MM-DD'가 양력 고정공휴일인지. 음력·대체공휴일은 포함하지 않는다. */
function isFixedHoliday(isoDate) {
    const m = /^\d{4}-(\d{2})-(\d{2})$/.exec(isoDate);
    if (!m)
        return false;
    const month = Number(m[1]);
    const day = Number(m[2]);
    return exports.FIXED_HOLIDAYS.some(([hm, hd]) => hm === month && hd === day);
}

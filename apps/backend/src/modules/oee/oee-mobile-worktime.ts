const SEOUL_TIME_ZONE = 'Asia/Seoul';
const DAY_MS = 24 * 60 * 60 * 1000;
const BUSINESS_DAY_START_MINUTES = 8 * 60 + 30;
export const OEE_MOBILE_WORK_SEGMENTS = ['DAY', 'NIGHT'] as const;
export type OeeMobileWorkSegment = (typeof OEE_MOBILE_WORK_SEGMENTS)[number];

export interface WorktimeRangeRow {
  workType: string;
  startTime: string | Date | null | undefined;
  endTime: string | Date | null | undefined;
  attribute01?: string | number | null;
  attribute02?: string | number | null;
}

export interface OeeMobileWorkContext {
  workDate: string;
  workSegment: OeeMobileWorkSegment;
}

interface ClockTime {
  milliseconds: number;
}

interface SeoulDateTime extends ClockTime {
  day: number;
}

const seoulFormatter = new Intl.DateTimeFormat('en-US', {
  timeZone: SEOUL_TIME_ZONE,
  calendar: 'gregory',
  numberingSystem: 'latn',
  year: 'numeric',
  month: '2-digit',
  day: '2-digit',
  hour: '2-digit',
  minute: '2-digit',
  second: '2-digit',
  hourCycle: 'h23',
});

function formatDateParts(date: Date): Record<string, number> {
  const parts = seoulFormatter.formatToParts(date);
  const values: Record<string, number> = {};

  for (const part of parts) {
    if (part.type !== 'literal') values[part.type] = Number(part.value);
  }

  if (
    !Number.isInteger(values.year) ||
    !Number.isInteger(values.month) ||
    !Number.isInteger(values.day) ||
    !Number.isInteger(values.hour) ||
    !Number.isInteger(values.minute) ||
    !Number.isInteger(values.second)
  ) {
    throw new Error('Asia/Seoul 시각을 해석할 수 없습니다.');
  }

  return values;
}

function toSeoulDateTime(value: Date): SeoulDateTime {
  if (Number.isNaN(value.getTime())) throw new Error('유효하지 않은 서버 시각입니다.');

  const parts = formatDateParts(value);
  const day = Date.UTC(parts.year, parts.month - 1, parts.day);
  const milliseconds =
    (((parts.hour * 60 + parts.minute) * 60 + parts.second) * 1000) + value.getUTCMilliseconds();

  return { day, milliseconds };
}

function parseClockTime(value: string | Date | null | undefined, fieldName: string): ClockTime {
  if (value instanceof Date) {
    if (Number.isNaN(value.getTime())) throw new Error(`잘못된 ${fieldName}입니다.`);
    const parts = formatDateParts(value);
    return {
      milliseconds:
        (((parts.hour * 60 + parts.minute) * 60 + parts.second) * 1000) +
        value.getUTCMilliseconds(),
    };
  }

  if (typeof value !== 'string') throw new Error(`잘못된 ${fieldName}입니다.`);
  const normalized = value.trim();
  const match = normalized.match(
    /^(?:(\d{2}):(\d{2})(?::(\d{2})(?:\.(\d{1,6}))?|)|(\d{2})(\d{2})(\d{2})?)$/,
  );
  if (!match) throw new Error(`잘못된 ${fieldName}입니다: ${value}`);

  const hour = Number(match[1] ?? match[5]);
  const minute = Number(match[2] ?? match[6]);
  const second = Number(match[3] ?? match[7] ?? 0);
  const fraction = match[4] ?? '';
  const milliseconds = fraction ? Number(fraction.padEnd(3, '0').slice(0, 3)) : 0;

  if (hour > 23 || minute > 59 || second > 59) {
    throw new Error(`잘못된 ${fieldName}입니다: ${value}`);
  }

  return { milliseconds: (((hour * 60 + minute) * 60 + second) * 1000) + milliseconds };
}

function parseDateOffset(value: string | number | null | undefined, fieldName: string): number {
  if (value == null || (typeof value === 'string' && value.trim() === '')) return 0;

  if (typeof value === 'number') {
    if (Number.isSafeInteger(value)) return value;
    throw new Error(`잘못된 ${fieldName} 날짜 offset입니다: ${value}`);
  }

  const normalized = value.trim();
  if (!/^[+-]?\d+$/.test(normalized)) {
    throw new Error(`잘못된 ${fieldName} 날짜 offset입니다: ${value}`);
  }

  const offset = Number(normalized);
  if (!Number.isSafeInteger(offset)) {
    throw new Error(`잘못된 ${fieldName} 날짜 offset입니다: ${value}`);
  }
  return offset;
}

function getWorkDate(day: number, milliseconds: number): number {
  return milliseconds >= BUSINESS_DAY_START_MINUTES * 60 * 1000 ? day : day - DAY_MS;
}

function rangeInstant(day: number, offset: number, clock: ClockTime): number {
  return day + offset * DAY_MS + clock.milliseconds;
}

function formatYmd(day: number): string {
  return new Date(day).toISOString().slice(0, 10);
}

function mapSourceWorkType(workType: string): OeeMobileWorkSegment {
  return 'ABCDE'.includes(workType) ? 'DAY' : 'NIGHT';
}

/**
 * 서버 시각과 ICOM_WORKTIME_RANGES의 한 업무일 구간을 결합한다.
 * Date의 로컬 getter는 사용하지 않고 Intl의 Asia/Seoul 변환만 사용한다.
 */
export function resolveOeeMobileWorkContext(
  serverTime: Date,
  rows: WorktimeRangeRow[],
): OeeMobileWorkContext {
  const current = toSeoulDateTime(serverTime);
  const workDateDay = getWorkDate(current.day, current.milliseconds);
  const currentInstant = current.day + current.milliseconds;
  const matches: Array<{ workType: string; workSegment: OeeMobileWorkSegment }> = [];

  for (const row of rows) {
    if (!/^[A-J]$/.test(row.workType)) {
      throw new Error(`잘못된 WORK_TYPE입니다: ${row.workType}`);
    }

    const start = parseClockTime(row.startTime, 'START_TIME');
    const end = parseClockTime(row.endTime, 'END_TIME');
    const startOffset = parseDateOffset(row.attribute01, 'ATTRIBUTE01');
    const endOffset = parseDateOffset(row.attribute02, 'ATTRIBUTE02');
    const startInstant = rangeInstant(workDateDay, startOffset, start);
    const endInstant = rangeInstant(workDateDay, endOffset, end);

    if (endInstant <= startInstant) {
      throw new Error(`START_TIME/END_TIME 순서가 잘못된 WORK_TYPE입니다: ${row.workType}`);
    }

    if (startInstant <= currentInstant && currentInstant < endInstant) {
      matches.push({ workType: row.workType, workSegment: mapSourceWorkType(row.workType) });
    }
  }

  if (matches.length === 0) throw new Error('일치하는 업무구간이 없습니다.');
  if (matches.length > 1) {
    throw new Error(`겹치는 업무구간이 있습니다: ${matches.map((match) => match.workType).join(',')}`);
  }

  return { workDate: formatYmd(workDateDay), workSegment: matches[0].workSegment };
}

/**
 * @file src/app/(authenticated)/jig/shared-format.ts
 * @description 지그관리 화면들이 공유하는 그리드 표시 규칙.
 *
 * 코드컬럼은 그리드에 코드가 아니라 뜻이 보여야 한다. 코드는 괄호로 함께 둔다
 * (수정·필터·전송용으로 원시 값이 필요하므로 행 데이터에는 그대로 남는다).
 */
export const dateTime = (value: unknown) => {
  if (!value) return '';
  const parsed = new Date(String(value));
  if (Number.isNaN(parsed.getTime())) return String(value);
  return parsed.toLocaleString('ko-KR', { hour12: false }).replace(/\.\s?$/, '');
};

export const dateOnly = (value: unknown) => (value ? String(value).slice(0, 10) : '');

export const num = (value: unknown) => (value == null ? '' : Number(value).toLocaleString());

export const codeWithName = (code: unknown, name: unknown) => {
  const text = name ? String(name) : '';
  return text ? `${text} (${String(code ?? '')})` : String(code ?? '');
};

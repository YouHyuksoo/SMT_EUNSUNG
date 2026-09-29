/**
 * @file components/shared/grid-format.ts
 * @description 업무 화면 그리드가 공유하는 표시 규칙.
 *
 * 코드컬럼은 그리드에 코드가 아니라 뜻이 보여야 한다. 코드는 괄호로 함께 둔다
 * (수정·필터·전송용으로 원시 값이 필요하므로 행 데이터에는 그대로 남는다).
 *
 * 지그관리에서 시작해 10개 대분류가 쓰게 됐으므로 라우트 폴더에서 여기로 옮겼다 —
 * 특정 대분류 폴더 안에 두면 다음 대분류가 자기 폴더에 복제한다.
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

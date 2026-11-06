/** 서버가 돌려준 사유(중복 코드, 투입자재 때문에 이동 불가 등)를 그대로 보여 주고, 없으면 기본 문구를 쓴다. */
export const routingErrorMessage = (error: unknown, fallback: string): string => {
  const message = (error as { response?: { data?: { message?: unknown } } })?.response?.data?.message;
  if (typeof message === 'string' && message) return message;
  if (Array.isArray(message) && typeof message[0] === 'string') return message[0];
  return fallback;
};

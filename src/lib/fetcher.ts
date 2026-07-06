/**
 * @file fetcher.ts
 * @description SWR/직접 호출용 공용 fetcher.
 *
 * 초보자 가이드:
 * 1. 응답이 4xx/5xx면 백엔드가 보낸 JSON body의 `error` 필드를 추출해서 메시지에 합성한다.
 *    → 사용자가 단순한 "API 오류 (500)" 대신 실제 원인(예: ORA-00942)을 볼 수 있다.
 * 2. 네트워크 자체가 실패한 경우(서버 다운/네트워크 단절)는 별도의 친근한 한국어 메시지로 throw.
 * 3. throw되는 에러는 `FetcherError`이며 status 코드도 함께 보유 → 화면이 분기 처리 가능.
 */

export class FetcherError extends Error {
  status: number;
  constructor(message: string, status: number) {
    super(message);
    this.name = 'FetcherError';
    this.status = status;
  }
}

/** HTTP status별 사용자 친화 기본 문구 (서버가 별도 메시지를 못 줄 때 fallback). */
function statusMessage(status: number): string {
  if (status >= 500) return '서버 처리 중 오류가 발생했습니다';
  if (status === 404) return '요청한 데이터를 찾을 수 없습니다';
  if (status === 403) return '접근 권한이 없습니다';
  if (status === 401) return '인증이 필요합니다';
  if (status === 400) return '요청 형식이 올바르지 않습니다';
  return `요청 실패 (${status})`;
}

export const fetcher = async (url: string) => {
  let res: Response;
  try {
    res = await fetch(url);
  } catch {
    /* fetch 자체가 실패 — DNS/네트워크/서버 다운 등 */
    throw new FetcherError('서버에 연결할 수 없습니다. 네트워크 또는 서버 상태를 확인하세요.', 0);
  }

  if (!res.ok) {
    /* 백엔드 라우트들이 { error: "..." } 형태로 응답하므로 그 메시지를 끌어와 합성 */
    let detail = '';
    try {
      const body = await res.json();
      detail = (body?.error ?? body?.message ?? '').toString().trim();
    } catch {
      /* JSON이 아니거나 빈 body — fallback 메시지만 사용 */
    }

    const base = statusMessage(res.status);
    throw new FetcherError(detail ? `${base} — ${detail}` : base, res.status);
  }

  return res.json();
};

"use client";

/**
 * @file src/app/(authenticated)/report/components/TruncationNotice.tsx
 * @description 결과가 상한에서 잘렸을 때 알리는 줄.
 *
 * 초보자 가이드:
 * 1. **리포트 결과에는 행 수 상한이 있다** (백엔드 `ROW_LIMIT`). 원장이 백만행대라
 *    조건이 넓으면 브라우저가 감당할 수 없는 양이 나온다.
 * 2. **잘렸으면 반드시 말해야 한다.** 화면 머리의 "합계" 는 받아온 행으로 계산하므로
 *    잘린 줄 모르면 **잘린 창 안의 값을 전체 합계로 읽는다.** 리포트에서는 느린 것보다
 *    이게 위험하다 — 숫자가 틀렸는데 틀린 줄 모른다.
 * 3. 서버가 `meta.truncated` 로 알려준다. 여러 탭을 한 번에 조회하는 화면은
 *    탭마다 값이 다를 수 있으므로 `useTruncation` 으로 모아 하나라도 잘리면 알린다.
 */
import { useCallback, useState } from 'react';
import { AlertTriangle } from 'lucide-react';

/** axios 응답에서 잘림 표시를 꺼낸다. */
export function readTruncated(response: unknown): boolean {
  const meta = (response as { data?: { meta?: { truncated?: boolean } } })?.data?.meta;
  return Boolean(meta?.truncated);
}

/** 서버가 알려준 상한 행 수 (기본값은 백엔드와 같은 10,000). */
export function readRowLimit(response: unknown): number {
  const meta = (response as { data?: { meta?: { rowLimit?: number } } })?.data?.meta;
  return Number(meta?.rowLimit ?? 10000);
}

/**
 * 한 화면이 여러 탭을 함께 조회할 때 쓰는 모음.
 *
 * `mark(...responses)` 에 응답을 그대로 넘기면 하나라도 잘렸는지 기억한다.
 */
export function useTruncation() {
  const [truncated, setTruncated] = useState(false);
  const [rowLimit, setRowLimit] = useState(10000);

  const mark = useCallback((...responses: unknown[]) => {
    setTruncated(responses.some(readTruncated));
    const first = responses.find((r) => readTruncated(r));
    if (first) setRowLimit(readRowLimit(first));
  }, []);

  return { truncated, rowLimit, mark };
}

/**
 * 잘렸을 때만 보이는 줄. 합계를 전체 합계로 읽지 말라고 분명히 적는다.
 *
 * @param what 합계가 무엇인지 (예: '입고수량 합계'). 적으면 문구가 구체적이 된다.
 */
export function TruncationNotice({
  truncated,
  rowLimit,
  what,
}: {
  truncated: boolean;
  rowLimit: number;
  what?: string;
}) {
  if (!truncated) return null;
  return (
    <div className="flex items-start gap-2 rounded-lg border border-amber-500/40 bg-amber-500/10 p-3 text-sm text-text">
      <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0 text-amber-500" />
      <span>
        결과가 <span className="font-semibold">{rowLimit.toLocaleString()}건</span>에서
        잘렸습니다 — 더 있습니다. 조건을 좁혀 다시 조회하세요.
        {what
          ? ` 화면의 ${what}는 표시된 ${rowLimit.toLocaleString()}건 기준이므로 전체 합계가 아닙니다.`
          : ' 화면의 합계는 표시된 행 기준이므로 전체 합계가 아닙니다.'}
      </span>
    </div>
  );
}

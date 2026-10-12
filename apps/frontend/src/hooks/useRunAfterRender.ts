/**
 * @file src/hooks/useRunAfterRender.ts
 * @description state를 바꾼 직후 그 새 값으로 함수를 실행해야 할 때 쓰는 훅.
 *
 * 조회 함수가 useCallback으로 state를 읽는 화면에서 `setX(v); search();`를 바로 부르면 이전 값으로 조회된다.
 * 이 훅이 돌려주는 trigger()를 부르면, 다음 렌더가 끝난 뒤 그 렌더의 fn(새 state를 읽는 함수)을 한 번 실행한다.
 *
 * 사용 예 (모델 선택 즉시 조회):
 *   const searchAfterSelect = useRunAfterRender(search);
 *   <ModelSearchField value={modelName} onChange={(v) => { setModelName(v); if (v) searchAfterSelect(); }} />
 */

import { useCallback, useEffect, useRef, useState } from "react";

export function useRunAfterRender(fn: () => unknown): () => void {
  const [tick, setTick] = useState(0);
  const fnRef = useRef(fn);
  fnRef.current = fn;

  useEffect(() => {
    if (tick === 0) return;
    void fnRef.current();
  }, [tick]);

  return useCallback(() => setTick((t) => t + 1), []);
}

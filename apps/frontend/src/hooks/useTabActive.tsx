"use client";

/**
 * @file src/hooks/useTabActive.tsx
 * @description 탭(keep-alive) 활성 여부 컨텍스트와, 숨겨진 탭에서 멈추는 주기 실행 훅
 *
 * 초보자 가이드:
 * 1. TabKeepAlive 는 열린 탭을 모두 마운트한 채 display:none 으로 숨긴다.
 *    그래서 화면 안의 setInterval 은 숨겨진 탭에서도 계속 돌며 서버를 조회하고 CPU 를 쓴다.
 * 2. TabKeepAlive 가 각 탭을 TabActiveProvider 로 감싸 "지금 보이는 탭인가"를 내려준다.
 *    Provider 밖(탭 구조가 아닌 곳)에서는 항상 true 라 동작이 바뀌지 않는다.
 * 3. 주기 실행은 setInterval 대신 useActiveInterval 을 쓴다.
 *    숨겨진 동안은 타이머를 멈추고, 다시 보이게 될 때 주기를 놓쳤으면(catchUp) 한 번 즉시 실행한다.
 * 4. delayMs 가 null/0 이면 타이머를 걸지 않는다 (자동갱신 꺼짐).
 */
import { createContext, useContext, useEffect, useRef } from "react";

const TabActiveContext = createContext(true);

/** TabKeepAlive 전용 — 탭 하나를 감싸 활성 여부를 내려준다 */
export const TabActiveProvider = TabActiveContext.Provider;

/** 이 컴포넌트가 지금 보이는 탭 안에 있는지 */
export function useIsTabActive(): boolean {
  return useContext(TabActiveContext);
}

interface ActiveIntervalOptions {
  /** 숨겨졌다 돌아왔을 때 주기를 놓쳤다면 즉시 한 번 실행 (기본 false) */
  catchUp?: boolean;
}

/**
 * 보이는 탭에서만 도는 setInterval.
 * callback 은 최신 값을 쓰도록 ref 로 잡아두므로 의존성 배열을 신경 쓰지 않아도 된다.
 */
export function useActiveInterval(
  callback: () => void,
  delayMs: number | null,
  options: ActiveIntervalOptions = {},
) {
  const active = useIsTabActive();
  const catchUp = options.catchUp ?? false;
  const callbackRef = useRef(callback);
  callbackRef.current = callback;
  const lastRunRef = useRef(Date.now());
  const wasActiveRef = useRef(active);

  useEffect(() => {
    const reactivated = active && !wasActiveRef.current;
    wasActiveRef.current = active;
    if (!active || !delayMs || delayMs <= 0) return;

    if (catchUp && reactivated && Date.now() - lastRunRef.current >= delayMs) {
      lastRunRef.current = Date.now();
      callbackRef.current();
    }
    const id = setInterval(() => {
      lastRunRef.current = Date.now();
      callbackRef.current();
    }, delayMs);
    return () => clearInterval(id);
  }, [active, delayMs, catchUp]);
}
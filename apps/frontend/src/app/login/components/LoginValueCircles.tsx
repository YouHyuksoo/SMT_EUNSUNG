"use client";

/**
 * @file src/app/login/components/LoginValueCircles.tsx
 * @description 로그인 화면 왼쪽의 회사 가치 원 세 개 — Product · Environment · Quality.
 *
 * 그리는 방식:
 * - 링은 굵은 원 테두리(stroke)로 그리고, 같은 원 위에 짧은 호를 겹쳐 조각 음영을 낸다.
 * - 가운데 흰 원은 링 위에 그린다. 세 원은 서로의 흰 원과 겹치지 않는다.
 *
 * 움직임:
 * 1. 처음 열리면 원이 차례로 커지며 나타나고 링이 한 바퀴 그려진다.
 * 2. 평소에는 음영 조각이 천천히 돈다. 회전은 CSS 가 아니라 requestAnimationFrame 으로 각도를 직접 준다 —
 *    올린 원을 맨 위로 다시 그릴 때 DOM 이 옮겨져도 CSS 애니메이션처럼 처음부터 다시 돌지 않는다.
 * 3. 마우스를 올리거나(키보드 Tab 포커스 포함) 원이 커지고 조각이 빨라지며, 나머지 두 원은 흐려진다.
 *    올린 원은 등장이 끝난 뒤부터 맨 위로 다시 그려 이웃 링에 가려지지 않는다.
 * 4. 운영체제에서 "동작 줄이기"를 켜면 움직임을 끈다.
 */
import { useEffect, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';

interface ValueCircle {
  key: string;
  cx: number;
  cy: number;
  title: string;
  lines: [string, string];
  base: string;
  dark: string;
  light: string;
  text: string;
  /** 등장 순서 지연(초) */
  delay: number;
  /** 평소 회전 방향 — 이웃 원끼리 반대로 돌아 맞물린 느낌을 준다. */
  reverse?: boolean;
}

const RING_R = 93.5;
const RING_W = 37;
const INNER_R = 75;
const CIRC = 2 * Math.PI * RING_R;

/** 조각 음영 — [시작 비율, 길이 비율, 진한/밝은] */
const SHADES: [number, number, 'dark' | 'light'][] = [
  [0.02, 0.1, 'light'],
  [0.3, 0.14, 'dark'],
  [0.55, 0.08, 'light'],
  [0.78, 0.12, 'dark'],
];

/** 회전 속도(도/초) — 평소 · 마우스 올림. 바뀔 때는 조금씩 따라가 부드럽게 빨라지고 느려진다. */
const IDLE_SPEED = 14;
const ACTIVE_SPEED = 120;
/** 마지막 원의 등장(지연 0.45초 + 링 그리기 1.25초)이 끝나는 시점 */
const INTRO_MS = 1900;

const STYLE = `
.lvc-node { transform-box: fill-box; transform-origin: center; cursor: pointer; outline: none;
  transition: transform .45s cubic-bezier(.34,1.56,.64,1), opacity .35s ease, filter .35s ease; }
.lvc-intro { animation: lvc-pop .7s cubic-bezier(.34,1.56,.64,1) both; animation-delay: var(--d); }
.lvc-node.is-active { transform: scale(1.08); filter: drop-shadow(0 10px 18px var(--glow)); }
.lvc-node.is-dim { opacity: .45; }
.lvc-intro .lvc-draw { animation: lvc-draw 1.1s ease-out both; animation-delay: calc(var(--d) + .15s); }
.lvc-intro .lvc-spin { animation: lvc-fade .5s ease-out both; animation-delay: calc(var(--d) + .9s); }
.lvc-inner { transition: transform .45s cubic-bezier(.34,1.56,.64,1); transform-box: fill-box; transform-origin: center; }
.lvc-node.is-active .lvc-inner { transform: scale(1.04); }
@keyframes lvc-pop { from { transform: scale(.6); opacity: 0; } to { transform: scale(1); opacity: 1; } }
@keyframes lvc-draw { from { stroke-dashoffset: ${CIRC}; } to { stroke-dashoffset: 0; } }
@keyframes lvc-fade { from { opacity: 0; } to { opacity: 1; } }
@media (prefers-reduced-motion: reduce) {
  .lvc-intro, .lvc-intro .lvc-draw, .lvc-intro .lvc-spin { animation: none !important; }
  .lvc-node, .lvc-inner { transition: none; }
}
`;

export default function LoginValueCircles({ className }: { className?: string }) {
  const { t } = useTranslation();
  const [active, setActive] = useState<string | null>(null);
  const [introDone, setIntroDone] = useState(false);
  const spinRefs = useRef<Record<string, SVGGElement | null>>({});
  const activeRef = useRef<string | null>(null);
  activeRef.current = active;

  useEffect(() => {
    const timer = window.setTimeout(() => setIntroDone(true), INTRO_MS);
    return () => window.clearTimeout(timer);
  }, []);

  const circles: ValueCircle[] = [
    {
      key: 'environment',
      cx: 122,
      cy: 283,
      title: 'Environment',
      lines: [t('auth.valueEnvironment1', '최고의'), t('auth.valueEnvironment2', '친환경 회사 실현')],
      base: '#bad229',
      dark: '#a2bb1b',
      light: '#d2e350',
      text: '#8aa317',
      delay: 0.25,
      reverse: true,
    },
    {
      key: 'quality',
      cx: 318,
      cy: 280,
      title: 'Quality',
      lines: [t('auth.valueQuality1', '최고의'), t('auth.valueQuality2', '품질 추구')],
      base: '#2fc6dc',
      dark: '#1eaec6',
      light: '#62d8ea',
      text: '#1fb0c9',
      delay: 0.45,
      reverse: true,
    },
    {
      key: 'product',
      cx: 217,
      cy: 118,
      title: 'Product',
      lines: [t('auth.valueProduct1', '최고의'), t('auth.valueProduct2', '제품 실현')],
      base: '#16797b',
      dark: '#0f6466',
      light: '#2b9295',
      text: '#126e70',
      delay: 0.05,
    },
  ];

  // 음영 조각 회전 — 원마다 각도·속도를 들고 매 프레임 transform 을 직접 바꾼다.
  useEffect(() => {
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
    const state: Record<string, { angle: number; speed: number }> = {};
    let frame = 0;
    let last = performance.now();
    const tick = (now: number) => {
      const dt = Math.min(0.05, (now - last) / 1000);
      last = now;
      for (const c of circles) {
        const s = (state[c.key] ??= { angle: 0, speed: IDLE_SPEED });
        const target = activeRef.current === c.key ? ACTIVE_SPEED : IDLE_SPEED;
        s.speed += (target - s.speed) * Math.min(1, dt * 4);
        s.angle = (s.angle + s.speed * dt * (c.reverse ? -1 : 1)) % 360;
        spinRefs.current[c.key]?.setAttribute('transform', `rotate(${s.angle} ${c.cx} ${c.cy})`);
      }
      frame = requestAnimationFrame(tick);
    };
    frame = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(frame);
    // 원의 위치·방향은 고정값이라 처음 한 번만 돌린다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // 마우스를 올린 원은 마지막에 그려 맨 위로 올린다 (등장 애니메이션이 끝난 뒤부터).
  const ordered = active && introDone
    ? [...circles.filter((c) => c.key !== active), ...circles.filter((c) => c.key === active)]
    : circles;

  return (
    <svg
      className={`overflow-visible ${className ?? ''}`}
      viewBox="0 0 440 400"
      role="img"
      aria-label="Product · Environment · Quality"
      onMouseLeave={() => setActive(null)}
    >
      <style>{STYLE}</style>
      <defs>
        <filter id="login-inner-shadow" x="-30%" y="-30%" width="160%" height="160%">
          <feDropShadow dx="0" dy="3" stdDeviation="5" floodColor="#0b2a4a" floodOpacity="0.18" />
        </filter>
      </defs>

      {ordered.map((c) => {
        const state = active === c.key ? 'is-active' : active ? 'is-dim' : '';
        return (
          <g
            key={c.key}
            className={`lvc-node ${introDone ? '' : 'lvc-intro'} ${state}`}
            style={{ '--d': `${c.delay}s`, '--glow': `${c.base}66` } as React.CSSProperties}
            tabIndex={0}
            onMouseEnter={() => setActive(c.key)}
            onFocus={() => setActive(c.key)}
            onBlur={() => setActive(null)}
          >
            {/* 링: 바탕색이 한 바퀴 그려진 뒤 음영 조각이 돈다 */}
            <circle
              className="lvc-draw"
              cx={c.cx}
              cy={c.cy}
              r={RING_R}
              fill="none"
              stroke={c.base}
              strokeWidth={RING_W}
              strokeDasharray={CIRC}
              transform={`rotate(-90 ${c.cx} ${c.cy})`}
            />
            <g className="lvc-spin" ref={(el) => { spinRefs.current[c.key] = el; }}>
              {SHADES.map(([start, len, tone]) => (
                <circle
                  key={start}
                  cx={c.cx}
                  cy={c.cy}
                  r={RING_R}
                  fill="none"
                  stroke={tone === 'dark' ? c.dark : c.light}
                  strokeWidth={RING_W}
                  strokeDasharray={`${CIRC * len} ${CIRC}`}
                  strokeDashoffset={-CIRC * start}
                  transform={`rotate(-90 ${c.cx} ${c.cy})`}
                />
              ))}
            </g>

            <g className="lvc-inner">
              <circle cx={c.cx} cy={c.cy} r={INNER_R} fill="#ffffff" filter="url(#login-inner-shadow)" />
              <text x={c.cx} y={c.cy - 12} textAnchor="middle" fontSize="21" fontWeight="700" fill={c.text}>
                {c.title}
              </text>
              <text x={c.cx} y={c.cy + 16} textAnchor="middle" fontSize="12.5" fill="#555d6b">
                {c.lines[0]}
              </text>
              <text x={c.cx} y={c.cy + 34} textAnchor="middle" fontSize="12.5" fill="#555d6b">
                {c.lines[1]}
              </text>
            </g>
          </g>
        );
      })}
    </svg>
  );
}

"use client";

/**
 * @file src/app/login/components/LoginWorldMap.tsx
 * @description 로그인 화면 오른쪽 위 점 세계지도 — 점이 무작위로 깜박이며 색이 바뀐다.
 *
 * 1. 점 좌표는 worldDots.ts 에 있다. canvas 하나에 전부 그린다 (점 883개라 DOM 으로 만들지 않는다).
 * 2. 매 프레임 일정 확률로 점 하나를 골라 깜박임을 시작한다. 색은 가치 원과 로고의 색 중에서 무작위다.
 *    깜박임은 sin 곡선으로 밝아졌다가 사라지고, 그동안 점이 조금 커진다.
 * 3. 운영체제에서 "동작 줄이기"를 켜면 깜박이지 않고 바탕 점만 그린다.
 */
import { useEffect, useRef } from 'react';
import {
  WORLD_DOTS,
  WORLD_DOTS_HEIGHT,
  WORLD_DOTS_WIDTH,
  WORLD_DOT_STRIDE,
} from './worldDots';

const DOT_R = 4.1;
/** 바탕 점 색 [r,g,b] — 진하기는 점마다 다르다. */
const BASE_RGB = '150,172,215';
const BASE_ALPHA = 0.36;
/** 깜박일 때 쓰는 색 — 로고 파랑, 가치 원 청록·연두·하늘 */
const TWINKLE_COLORS = ['26,92,200', '22,121,123', '186,210,41', '47,198,220', '91,134,212'];
/** 초당 새로 깜박이기 시작하는 점 수 */
const SPAWN_PER_SEC = 9;

interface Twinkle {
  index: number;
  color: string;
  start: number;
  duration: number;
}

export default function LoginWorldMap({ className }: { className?: string }) {
  const canvasRef = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    const canvas = canvasRef.current;
    const ctx = canvas?.getContext('2d');
    if (!canvas || !ctx) return;

    const dpr = Math.min(2, window.devicePixelRatio || 1);
    canvas.width = WORLD_DOTS_WIDTH * dpr;
    canvas.height = WORLD_DOTS_HEIGHT * dpr;
    ctx.scale(dpr, dpr);

    const count = WORLD_DOTS.length / WORLD_DOT_STRIDE;
    const dot = (i: number, r: number, fill: string) => {
      const o = i * WORLD_DOT_STRIDE;
      ctx.beginPath();
      ctx.arc(WORLD_DOTS[o], WORLD_DOTS[o + 1], r, 0, Math.PI * 2);
      ctx.fillStyle = fill;
      ctx.fill();
    };
    const drawBase = () => {
      ctx.clearRect(0, 0, WORLD_DOTS_WIDTH, WORLD_DOTS_HEIGHT);
      for (let i = 0; i < count; i += 1) {
        const a = (WORLD_DOTS[i * WORLD_DOT_STRIDE + 2] / 255) * BASE_ALPHA * 2;
        dot(i, DOT_R, `rgba(${BASE_RGB},${Math.min(1, a).toFixed(3)})`);
      }
    };

    drawBase();
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

    const twinkles: Twinkle[] = [];
    let frame = 0;
    let last = performance.now();
    const tick = (now: number) => {
      const dt = Math.min(0.1, (now - last) / 1000);
      last = now;

      // 새 깜박임 — 프레임 간격에 비례한 확률로 만든다.
      let spawn = SPAWN_PER_SEC * dt;
      while (spawn > 0) {
        if (Math.random() < spawn) {
          twinkles.push({
            index: Math.floor(Math.random() * count),
            color: TWINKLE_COLORS[Math.floor(Math.random() * TWINKLE_COLORS.length)],
            start: now,
            duration: 1200 + Math.random() * 1600,
          });
        }
        spawn -= 1;
      }

      drawBase();
      for (let k = twinkles.length - 1; k >= 0; k -= 1) {
        const tw = twinkles[k];
        const p = (now - tw.start) / tw.duration;
        if (p >= 1) {
          twinkles.splice(k, 1);
          continue;
        }
        const glow = Math.sin(p * Math.PI);
        dot(tw.index, DOT_R + 4 * glow, `rgba(${tw.color},${(0.18 * glow).toFixed(3)})`);
        dot(tw.index, DOT_R + 0.8 * glow, `rgba(${tw.color},${(0.95 * glow).toFixed(3)})`);
      }
      frame = requestAnimationFrame(tick);
    };
    frame = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(frame);
  }, []);

  return (
    <canvas
      ref={canvasRef}
      aria-hidden
      className={className}
      style={{ aspectRatio: `${WORLD_DOTS_WIDTH} / ${WORLD_DOTS_HEIGHT}` }}
    />
  );
}

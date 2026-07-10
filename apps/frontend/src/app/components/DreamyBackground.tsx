"use client";

/**
 * @file DreamyBackground.tsx
 * @description 몽환적 소프트 블룸 배경.
 * 선·기하 요소 없이, 브랜드 컬러(primary/accent/chart-2) 오브가 크게 번지며
 * 아주 느리게 부유한다. 가장자리는 페이지 배경색으로 자연스럽게 사라진다.
 * prefers-reduced-motion 시 부유 애니메이션 정지.
 *
 * NOTE: styled-jsx 대신 일반 <style> 태그(dangerouslySetInnerHTML)를 사용한다.
 * (Turbopack에서 styled-jsx 번들 이슈 회피 + SSR 안전). 클래스는 db- 네임스페이스로 전역 충돌 방지.
 */

const CSS = `
.db-bloom { position:absolute; border-radius:9999px; filter:blur(90px); will-change:transform; }
.db-bloom-a {
  width:46rem; height:46rem; top:-16rem; left:46%;
  background:radial-gradient(circle, var(--primary) 0%, transparent 60%);
  opacity:0.32; animation:db-drift-a 20s ease-in-out infinite;
}
.db-bloom-b {
  width:38rem; height:38rem; bottom:-14rem; right:-8rem;
  background:radial-gradient(circle, var(--accent) 0%, transparent 60%);
  opacity:0.28; animation:db-drift-b 26s ease-in-out infinite;
}
.db-bloom-c {
  width:32rem; height:32rem; top:22%; left:-10rem;
  background:radial-gradient(circle, var(--chart-2) 0%, transparent 62%);
  opacity:0.22; animation:db-drift-c 30s ease-in-out infinite;
}
.db-veil {
  position:absolute; inset:0; opacity:0.55;
  background:radial-gradient(120% 90% at 50% 0%, transparent 42%, var(--background) 100%);
}
@keyframes db-drift-a { 0%,100%{transform:translate(-50%,0) scale(1)} 50%{transform:translate(-46%,5%) scale(1.1)} }
@keyframes db-drift-b { 0%,100%{transform:translate(0,0) scale(1)} 50%{transform:translate(-6%,-7%) scale(1.14)} }
@keyframes db-drift-c { 0%,100%{transform:translate(0,0) scale(1)} 50%{transform:translate(7%,5%) scale(1.08)} }
@media (prefers-reduced-motion: reduce) { .db-bloom { animation:none } }
`;

export function DreamyBackground({ className = "" }: { className?: string }) {
  return (
    <div
      className={`pointer-events-none absolute inset-0 overflow-hidden ${className}`}
      aria-hidden="true"
    >
      <style dangerouslySetInnerHTML={{ __html: CSS }} />
      <div className="db-bloom db-bloom-a" />
      <div className="db-bloom db-bloom-b" />
      <div className="db-bloom db-bloom-c" />
      <div className="db-veil" />
    </div>
  );
}

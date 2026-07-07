"use client";

/**
 * @file ThemeSelector.tsx
 * @description 랜딩용 테마 선택 컨트롤. 유리질(glassmorphic) 팝오버로
 * 화면 모드(라이트/다크/시스템)와 포인트 컬러(핑크/로즈/오키드)를 선택한다.
 * 상태는 themeStore(persist "smt-theme")에 저장되어 앱 전역에 적용된다.
 */

import { useEffect, useRef, useState } from "react";
import { Sun, Moon, Monitor, Palette, Check } from "lucide-react";
import { useThemeStore, type Theme, type ColorTheme } from "@/stores/themeStore";

const MODES: { key: Theme; label: string; icon: typeof Sun }[] = [
  { key: "light", label: "라이트", icon: Sun },
  { key: "dark", label: "다크", icon: Moon },
  { key: "system", label: "시스템", icon: Monitor },
];

const COLORS: { key: ColorTheme; label: string; dot: string }[] = [
  { key: "default", label: "핑크", dot: "#ec0b7a" },
  { key: "custom", label: "로즈", dot: "#e6096e" },
  { key: "orchid", label: "오키드", dot: "#9a7be6" },
];

export default function ThemeSelector() {
  const { theme, setTheme, colorTheme, setColorTheme } = useThemeStore();
  const [open, setOpen] = useState(false);
  const [mounted, setMounted] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => setMounted(true), []);

  useEffect(() => {
    if (!open) return;
    const onDown = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener("mousedown", onDown);
    return () => document.removeEventListener("mousedown", onDown);
  }, [open]);

  return (
    <div ref={ref} className="relative">
      <button
        type="button"
        aria-label="테마 선택"
        onClick={() => setOpen((v) => !v)}
        className="flex h-10 w-10 items-center justify-center rounded-lg border border-border/60
                   bg-card/40 text-text-muted backdrop-blur-sm transition-colors
                   hover:border-primary/40 hover:text-primary"
      >
        <Palette className="h-5 w-5" />
      </button>

      {mounted && open && (
        <div
          style={{ animation: "tselPop 0.18s ease-out" }}
          className="absolute right-0 top-12 z-50 w-60 rounded-2xl border border-border/60
                     bg-card/80 p-4 shadow-2xl backdrop-blur-xl"
        >
          <p className="mb-2 text-xs font-semibold text-text-muted">화면 모드</p>
          <div className="mb-4 grid grid-cols-3 gap-1.5">
            {MODES.map((m) => {
              const active = theme === m.key;
              const Icon = m.icon;
              return (
                <button
                  key={m.key}
                  type="button"
                  onClick={() => setTheme(m.key)}
                  className={`flex flex-col items-center gap-1 rounded-lg px-2 py-2 text-[11px] font-medium transition-colors ${
                    active
                      ? "bg-primary text-white shadow-sm shadow-primary/25"
                      : "text-text-muted hover:bg-surface"
                  }`}
                >
                  <Icon className="h-4 w-4" />
                  {m.label}
                </button>
              );
            })}
          </div>

          <p className="mb-2 text-xs font-semibold text-text-muted">포인트 컬러</p>
          <div className="flex gap-2.5">
            {COLORS.map((c) => {
              const active = colorTheme === c.key;
              return (
                <button
                  key={c.key}
                  type="button"
                  aria-label={c.label}
                  onClick={() => setColorTheme(c.key)}
                  style={{ backgroundColor: c.dot }}
                  className={`relative h-8 w-8 rounded-full transition-transform hover:scale-110 ${
                    active ? "ring-2 ring-primary ring-offset-2 ring-offset-card" : ""
                  }`}
                >
                  {active && (
                    <Check className="absolute inset-0 m-auto h-4 w-4 text-white" strokeWidth={3} />
                  )}
                </button>
              );
            })}
          </div>
        </div>
      )}

      <style
        dangerouslySetInnerHTML={{
          __html: `@keyframes tselPop{from{opacity:0;transform:translateY(-6px)}to{opacity:1;transform:translateY(0)}}`,
        }}
      />
    </div>
  );
}

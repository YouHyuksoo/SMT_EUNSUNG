"use client";

/**
 * @file components/shared/ScreenTabs.tsx
 * @description 화면 안에서 보기를 바꾸는 탭 줄.
 *
 * PB 의 라디오버튼 묶음(`rb_*`)과 탭 컨트롤을 웹으로 옮긴 모양이다.
 * 탭마다 건수를 함께 보여준다 — 어느 탭에 자료가 있는지 눌러 보지 않고 안다.
 *
 * 조회 대분류가 먼저 쓰기 시작했고(`query/components/QueryTabs`), 리포트도 같은 것을
 * 쓰므로 여기로 옮겼다. 라우트 그룹 안에 두면 다른 대분류가 복제하게 된다.
 */

export interface ScreenTabDef<K extends string> {
  key: K;
  label: string;
  /** 탭 제목 옆에 붙일 건수. 0 이면 표시하지 않는다. */
  count?: number;
  /** 이 탭이 무엇을 보여 주는지. 전역 툴팁(data-tooltip)으로 뜬다. */
  tooltip?: string;
}

export default function ScreenTabs<K extends string>({
  tabs,
  active,
  onChange,
}: {
  tabs: ScreenTabDef<K>[];
  active: K;
  onChange: (key: K) => void;
}) {
  // 탭마다 위가 둥근 칸을 두고, 고른 탭은 위쪽 포인트 색 줄 + 바탕색으로 아래 줄과 이어 붙인다.
  return (
    <div role="tablist" className="flex flex-wrap items-end gap-1 border-b border-border">
      {tabs.map((t) => {
        const selected = active === t.key;
        return (
          <button
            key={t.key}
            type="button"
            role="tab"
            aria-selected={selected}
            onClick={() => onChange(t.key)}
            data-tooltip={t.tooltip}
            className={`-mb-px flex items-center gap-1.5 rounded-t-md border px-4 py-2 text-sm transition-colors ${selected
              ? 'border-border border-t-2 border-t-primary border-b-background bg-background font-semibold text-primary'
              : 'border-border/60 bg-surface text-text-muted hover:bg-primary/5 hover:text-text'}`}
          >
            {t.label}
            {(t.count ?? 0) > 0 && (
              <span className={`rounded-full px-1.5 text-[11px] leading-5 ${selected
                ? 'bg-primary/10 text-primary'
                : 'bg-border/60 text-text-muted'}`}
              >
                {t.count?.toLocaleString()}
              </span>
            )}
          </button>
        );
      })}
    </div>
  );
}

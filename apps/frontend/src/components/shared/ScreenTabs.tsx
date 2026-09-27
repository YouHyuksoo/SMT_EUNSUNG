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
  return (
    <div className="flex flex-wrap gap-1 border-b border-border">
      {tabs.map((t) => (
        <button
          key={t.key}
          type="button"
          onClick={() => onChange(t.key)}
          className={`px-3 py-2 text-sm ${active === t.key
            ? 'border-b-2 border-primary font-semibold text-text'
            : 'text-text-muted hover:text-text'}`}
        >
          {t.label}
          {(t.count ?? 0) > 0 && (
            <span className="ml-1 text-xs text-text-muted">{t.count}</span>
          )}
        </button>
      ))}
    </div>
  );
}

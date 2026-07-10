'use client';

interface ChartCardProps {
  title: string;
  subtitle?: string;
  children: React.ReactNode;
}

export default function ChartCard({ title, subtitle, children }: ChartCardProps) {
  return (
    <div className="flex h-full flex-col rounded-xl border border-white/10 bg-zinc-900/60 backdrop-blur-sm">
      <div className="flex items-baseline gap-2 border-b border-white/5 px-4 py-2.5">
        <h3 className="text-sm font-semibold text-zinc-100">{title}</h3>
        {subtitle && <span className="text-xs text-zinc-400">{subtitle}</span>}
      </div>
      <div className="min-h-0 flex-1 p-3">
        {children}
      </div>
    </div>
  );
}

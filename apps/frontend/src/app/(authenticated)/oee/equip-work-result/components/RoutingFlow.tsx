'use client';

/**
 * @file oee/equip-work-result/components/RoutingFlow.tsx
 * @description 라우팅 흐름 띠 — 이 품목이 어느 공정에서 와서 어느 공정으로 가는지 중앙 영역 상단에 보여준다.
 *
 * 초보자 가이드:
 * 1. 품목(ID_ITEM.ROUTING_CODE)이 문 라우팅의 공정을 GET /oee/work-result/routing-flow?itemCode 로 읽는다.
 * 2. 현재 공정(workstageCode)은 강조하고, 앞 공정·뒤 공정은 따로 글로 적는다. 현재 공정이 라우팅에 없으면 흐름만 보여준다.
 * 3. 라우팅이 없는 품목은 "라우팅 미지정"으로 알린다. 조회에 실패해도 화면은 막지 않는다.
 */
import { useEffect, useMemo, useState } from 'react';
import { ArrowRight, Route } from 'lucide-react';
import api from '@/services/api';

interface Step {
  seq: number;
  workstageCode: string;
  workstageName: string | null;
  executionType: string | null;
}

interface Props {
  itemCode: string | null | undefined;
  /** 지금 실적을 넣는 공정 */
  workstageCode: string | null | undefined;
}

function label(s: Step) {
  return s.workstageName ?? s.workstageCode;
}

export default function RoutingFlow({ itemCode, workstageCode }: Props) {
  const [routingCode, setRoutingCode] = useState<string | null>(null);
  const [steps, setSteps] = useState<Step[]>([]);
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    if (!itemCode) { setSteps([]); setRoutingCode(null); setLoaded(false); return; }
    let alive = true;
    setLoaded(false);
    api.get('/oee/work-result/routing-flow', { params: { itemCode } })
      .then((res) => {
        if (!alive) return;
        setRoutingCode(res.data?.data?.routingCode ?? null);
        setSteps(res.data?.data?.steps ?? []);
      })
      .catch(() => { if (alive) { setRoutingCode(null); setSteps([]); } })
      .finally(() => { if (alive) setLoaded(true); });
    return () => { alive = false; };
  }, [itemCode]);

  const idx = useMemo(() => steps.findIndex((s) => s.workstageCode === workstageCode), [steps, workstageCode]);
  const prev = idx > 0 ? steps[idx - 1] : null;
  const next = idx >= 0 && idx < steps.length - 1 ? steps[idx + 1] : null;

  if (!itemCode || !loaded) return null;

  return (
    <div className="flex-shrink-0 rounded-xl border-2 border-slate-400 dark:border-slate-500 bg-surface shadow-md px-4 py-2.5" aria-label="라우팅 흐름">
      <div className="flex items-center gap-2 text-[11px] text-text-muted">
        <Route className="w-3.5 h-3.5" aria-hidden />
        <span>라우팅 흐름{routingCode ? <span className="ml-1.5 font-mono text-text">{routingCode}</span> : null}</span>
        {steps.length > 0 && idx >= 0 && (
          <span className="ml-auto text-xs">
            앞 공정 <b className="text-text">{prev ? label(prev) : '없음(첫 공정)'}</b>
            <span className="mx-2 text-border">|</span>
            뒤 공정 <b className="text-text">{next ? label(next) : '없음(마지막 공정)'}</b>
          </span>
        )}
      </div>
      {steps.length === 0 ? (
        <p className="mt-1 text-sm text-text-muted">이 품목에 지정된 라우팅이 없습니다.</p>
      ) : (
        <ol className="mt-1.5 flex flex-wrap items-center gap-x-1.5 gap-y-1">
          {steps.map((s, i) => {
            const current = i === idx;
            return (
              <li key={`${s.seq}-${s.workstageCode}`} className="flex items-center gap-1.5">
                {i > 0 && <ArrowRight className="w-4 h-4 text-text-muted" aria-hidden />}
                <span title={s.workstageCode}
                  className={`rounded-lg border px-2.5 py-1 text-sm font-semibold ${
                    current ? 'border-primary bg-primary text-white'
                      : idx >= 0 && i < idx ? 'border-border bg-background text-text-muted'
                      : 'border-border bg-background text-text'
                  }`}>
                  {label(s)}{current && <span className="ml-1.5 text-[11px] font-medium opacity-90">현재</span>}
                </span>
              </li>
            );
          })}
        </ol>
      )}
    </div>
  );
}

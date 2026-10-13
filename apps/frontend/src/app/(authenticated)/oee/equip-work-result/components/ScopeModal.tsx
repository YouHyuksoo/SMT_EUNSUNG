'use client';

/**
 * @file oee/equip-work-result/components/ScopeModal.tsx
 * @description 라인 → 공정 → 설비 선택 모달. 라인은 라인구분(공통코드 LINE DIVISION)별로 한 줄씩 묶어
 *              가로로 촘촘히 펼친다 — 스크롤 없이 모든 라인이 한 화면에 보인다.
 *
 * 초보자 가이드:
 * 1. 라인은 작업지시를 고르는 기준이다. 작업지시가 내려가는 조립라인·가공공정만 보인다
 *    (WORK_ORDER_LINE_DIVISIONS). SMT 는 센서 실적, 검사라인은 작업지시가 없다.
 * 2. 공정은 라인과 무관한 공통 목록이다(설비가 있는 공정). 설비는 설비 마스터에서 고른 공정에 속한 설비다
 *    — 후공정 설비는 라인에 묶이지 않는다. SMT 라인에 배정된 설비는 이 화면 대상이 아니라 뺀다.
 * 3. 공정관리 마스터 기준으로 SMT 공정(공정그룹 SMT)과 검사공정(공정유형 Q)은 뺀다 — 실적을 넣는 공정이 아니다.
 * 4. [확인]을 눌러야 반영된다. 부모가 localStorage 에 기억한다.
 */
import { useEffect, useMemo, useState } from 'react';
import { Modal } from '@/components/ui';
import { useComCodeOptions } from '@/hooks/useComCode';
import { useProcessOptions } from '@/hooks/useMasterOptions';
import { isManufacturingProcess } from '@/components/shared/processOptions.mjs';
import { SMT_LINE_DIVISIONS, WORK_ORDER_LINE_DIVISIONS } from '@smt/shared';
import type { OpsLine, OpsMachine } from '../../equip-ops-status/types';
import { workstagesOf, type Scope } from '../_lib/scope';

interface Props {
  isOpen: boolean;
  onClose: () => void;
  lines: OpsLine[];
  machines: OpsMachine[];
  value: Scope | null;
  onConfirm: (scope: Scope) => void;
}

/** 라인·공정·설비가 함께 쓰는 같은 크기의 선택 타일 — 이름 + 코드 두 줄 */
function Tile({ on, name, code, dot, onClick }: { on: boolean; name: string; code: string; dot?: 'run' | 'stop'; onClick: () => void }) {
  return (
    <button type="button" onClick={onClick} title={`${name} · ${code}`}
      className={`w-32 h-12 rounded-lg border px-2 text-left flex flex-col justify-center transition-colors ${
        on ? 'bg-primary text-white border-primary' : 'border-border bg-background text-text hover:border-primary/60'
      }`}>
      <span className="flex items-center gap-1.5 min-w-0">
        {dot && <span className={`w-2 h-2 rounded-full flex-shrink-0 ${dot === 'stop' ? 'bg-red-500' : 'bg-emerald-500'}`} />}
        <span className="text-sm font-semibold leading-tight truncate">{name}</span>
      </span>
      <span className={`text-[10px] leading-tight font-mono truncate ${on ? 'text-white/80' : 'text-text-muted'}`}>{code}</span>
    </button>
  );
}

export default function ScopeModal({ isOpen, onClose, lines, machines, value, onConfirm }: Props) {
  const [lineCode, setLineCode] = useState('');
  const [workstageCode, setWorkstageCode] = useState('');
  const [machineCode, setMachineCode] = useState('');
  const divisionOptions = useComCodeOptions('LINE DIVISION');
  const { rawData: processes } = useProcessOptions();
  // 공정관리 마스터에서 SMT 공정그룹·검사 공정유형으로 분류된 공정 — 이 화면에서 제외
  const excludedStages = useMemo(
    () => new Set(processes.filter((p) => !isManufacturingProcess(p)).map((p) => p.processCode)),
    [processes],
  );

  useEffect(() => {
    if (!isOpen) return;
    setLineCode(value?.lineCode ?? '');
    setWorkstageCode(value?.workstageCode ?? '');
    setMachineCode(value?.machineCode ?? '');
  }, [isOpen, value]);

  // 라인구분별 묶음 — 공통코드 정렬 순서를 따르고, 코드에 없는 구분은 뒤에 붙인다
  const groups = useMemo(() => {
    const target = lines.filter((l) => (WORK_ORDER_LINE_DIVISIONS as readonly string[]).includes(l.lineDivision ?? ''));
    const byDiv = new Map<string, OpsLine[]>();
    for (const l of target) {
      const key = l.lineDivision ?? '';
      if (!byDiv.has(key)) byDiv.set(key, []);
      byDiv.get(key)!.push(l);
    }
    const order = divisionOptions.map((o) => String(o.value));
    return [...byDiv.entries()]
      .sort(([a], [b]) => {
        const ia = order.indexOf(a); const ib = order.indexOf(b);
        return (ia < 0 ? 999 : ia) - (ib < 0 ? 999 : ib) || a.localeCompare(b);
      })
      .map(([div, list]) => ({
        div,
        label: divisionOptions.find((o) => o.value === div)?.label ?? (div || '미지정'),
        lines: list.sort((x, y) => x.lineCode.localeCompare(y.lineCode)),
      }))
      // 라인이 하나뿐인 구분(공용·수리 등)은 '기타' 한 줄로 합쳐 줄 수를 줄인다
      .reduce<{ div: string; label: string; lines: OpsLine[] }[]>((acc, g) => {
        if (g.lines.length > 1) return [...acc, g];
        const etc = acc.find((x) => x.div === '__ETC__');
        if (etc) { etc.lines.push(...g.lines); return acc; }
        return [...acc, { div: '__ETC__', label: '기타', lines: [...g.lines] }];
      }, []);
  }, [lines, divisionOptions]);

  // 대상 설비 — SMT 라인에 배정된 설비를 뺀 전부(라인 미배정 후공정 설비 포함)
  const candidates = useMemo(() => {
    const smtLines = new Set(lines
      .filter((l) => (SMT_LINE_DIVISIONS as readonly string[]).includes(l.lineDivision ?? ''))
      .map((l) => l.lineCode));
    return machines.filter((m) =>
      (!m.lineCode || !smtLines.has(m.lineCode)) && !(m.workstageCode && excludedStages.has(m.workstageCode)));
  }, [lines, machines, excludedStages]);
  const workstages = useMemo(() => workstagesOf(candidates), [candidates]);
  // 설비 마스터에서 고른 공정에 속한 설비
  const stageMachines = useMemo(
    () => (workstageCode ? candidates.filter((m) => m.workstageCode === workstageCode) : []),
    [candidates, workstageCode],
  );

  const canConfirm = !!lineCode && !!workstageCode && !!machineCode;

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="라인 · 공정 · 설비 선택" size="full" bodyMaxHeightClass="max-h-[85vh]"
      headerActions={
        <div className="flex items-center gap-2">
          <button type="button" onClick={onClose}
            className="h-9 px-4 rounded-lg border border-border text-sm font-medium text-text hover:bg-surface">닫기</button>
          <button type="button" disabled={!canConfirm}
            onClick={() => canConfirm && onConfirm({ lineCode, workstageCode, machineCode })}
            className="h-9 px-5 rounded-lg bg-primary text-white text-sm font-semibold hover:bg-primary/90 disabled:opacity-40">확인</button>
        </div>
      }>
      <div className="flex flex-col gap-3">
        {/* 1. 라인 — 구분별 한 줄 */}
        <section>
          <h3 className="text-sm font-semibold text-text mb-2">1. 라인</h3>
          <div className="flex flex-col divide-y divide-border rounded-lg border border-border">
            {groups.map((g) => (
              <div key={g.div} className="flex items-start gap-2 px-2.5 py-1.5">
                <span className="w-16 flex-shrink-0 pt-3.5 text-xs font-semibold text-text-muted">{g.label}</span>
                <div className="flex-1 flex flex-wrap gap-1.5">
                  {g.lines.map((l) => (
                    <Tile key={l.lineCode} on={lineCode === l.lineCode} name={l.lineName ?? l.lineCode} code={l.lineCode}
                      onClick={() => setLineCode(l.lineCode)} />
                  ))}
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* 2. 공정 — 라인과 무관한 공통 목록 */}
        <section>
          <h3 className="text-sm font-semibold text-text mb-2">2. 공정</h3>
          <div className="flex flex-wrap gap-1.5">
            {workstages.map((w) => (
              <Tile key={w.code} on={workstageCode === w.code} name={w.name} code={w.code}
                onClick={() => { setWorkstageCode(w.code); setMachineCode(''); }} />
            ))}
          </div>
        </section>

        {/* 3. 설비 — 설비 마스터에서 고른 공정에 속한 설비 */}
        <section>
          <h3 className="text-sm font-semibold text-text mb-2">3. 설비</h3>
          {!workstageCode ? <p className="text-sm text-text-muted">공정을 먼저 고르세요</p>
            : !stageMachines.length ? <p className="text-sm text-text-muted">이 공정에 등록된 설비가 없습니다</p> : (
            <div className="flex flex-wrap gap-1.5">
              {stageMachines.map((m) => (
                <Tile key={m.machineCode} on={machineCode === m.machineCode} name={m.machineName ?? m.machineCode} code={m.machineCode}
                  dot={m.openDtSeq ? 'stop' : 'run'} onClick={() => setMachineCode(m.machineCode)} />
              ))}
            </div>
          )}
        </section>
      </div>
    </Modal>
  );
}

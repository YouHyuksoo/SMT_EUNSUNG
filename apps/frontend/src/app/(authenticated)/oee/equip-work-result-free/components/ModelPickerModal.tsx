'use client';

/**
 * @file oee/equip-work-result-free/components/ModelPickerModal.tsx
 * @description 모델 선택 모달 — 모델명·품번을 입력하면 맞는 모델만 보여주고, 하나를 눌러(또는 Enter) 선택한다.
 *
 * 초보자 가이드:
 * 1. 모델이 수백 개라 전체 목록은 보여주지 않는다. 입력하기 전에는 최근 계획(IP_PRODUCT_MI_PLAN, 계획일이 3일 전보다 큼)에 있는 모델만 미리 보여준다.
 * 2. 조회는 GET /oee/work-result-free/models?keyword (모델명·품번 부분 검색, 최대 30건). 입력이 멈춘 뒤 0.3초에 자동 조회한다.
 *    검색 결과에서도 최근 계획 모델이 먼저 나오고 '계획' 표시가 붙는다.
 * 3. 폭을 넓히고 글자를 작게 해 4열로 늘어놓아 스크롤이 거의 생기지 않게 했다. 방향키 ↑↓ 로 (읽는 순서대로) 고르고 Enter 로 선택한다. 결과가 30건이면 더 입력해서 좁히라고 알려준다.
 */
import { useEffect, useRef, useState } from 'react';
import { CornerDownLeft, Search } from 'lucide-react';
import toast from 'react-hot-toast';
import { Input, Modal } from '@/components/ui';
import api from '@/services/api';
import type { ModelRow } from '../_lib/types';

const LIMIT = 30;

interface Props {
  isOpen: boolean;
  onClose: () => void;
  selected: ModelRow | null;
  onSelect: (model: ModelRow) => void;
}

export default function ModelPickerModal({ isOpen, onClose, selected, onSelect }: Props) {
  const [keyword, setKeyword] = useState('');
  const [rows, setRows] = useState<ModelRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [active, setActive] = useState(0);
  const seq = useRef(0);

  // 열 때마다 비운다 — 지난번 검색 결과를 남기지 않는다
  useEffect(() => { if (isOpen) { setKeyword(''); setRows([]); setActive(0); } }, [isOpen]);

  useEffect(() => {
    const q = keyword.trim();
    if (!isOpen) { setRows([]); setLoading(false); return; }
    const mine = ++seq.current;
    setLoading(true);
    const timer = setTimeout(async () => {
      try {
        const res = await api.get('/oee/work-result-free/models', { params: { keyword: q || undefined } });
        if (mine !== seq.current) return; // 더 나중에 친 검색이 있으면 이 응답은 버린다
        setRows(res.data?.data?.list ?? []);
        setActive(0);
      } catch {
        if (mine === seq.current) toast.error('모델 조회에 실패했습니다');
      } finally {
        if (mine === seq.current) setLoading(false);
      }
    }, q ? 300 : 0); // 비어 있을 때(열자마자)는 바로 읽는다
    return () => clearTimeout(timer);
  }, [isOpen, keyword]);

  function onKeyDown(e: React.KeyboardEvent<HTMLInputElement>) {
    if (!rows.length) return;
    if (e.key === 'ArrowDown') { e.preventDefault(); setActive((i) => (i + 1) % rows.length); }
    else if (e.key === 'ArrowUp') { e.preventDefault(); setActive((i) => (i - 1 + rows.length) % rows.length); }
    else if (e.key === 'Enter') { e.preventDefault(); onSelect(rows[active]); }
  }

  const typed = keyword.trim().length > 0;

  return (
    <Modal isOpen={isOpen} onClose={onClose} size="full" bodyMaxHeightClass="max-h-[85vh]"
      title="모델 선택"
      headerActions={
        <button type="button" onClick={onClose}
          className="h-9 px-4 rounded-lg border border-border text-sm font-medium text-text hover:bg-surface">닫기</button>
      }>
      <Input placeholder="모델명 또는 품번을 입력하세요" value={keyword} onChange={(e) => setKeyword(e.target.value)}
        onKeyDown={onKeyDown} leftIcon={<Search className="w-4 h-4" />} fullWidth autoFocus autoComplete="off" />

      <div className="mt-2 min-h-[8rem]">
        {(
          <>
            <p className="mb-1.5 text-[11px] text-text-muted">
              {typed ? '검색 결과 — 최근 계획 모델이 먼저 나옵니다.' : '최근 계획(3일 이내)에 있는 모델입니다. 다른 모델은 모델명이나 품번 일부를 입력해 찾으세요.'}
            </p>
            <ul role="listbox" className="grid grid-cols-4 gap-1.5">
              {rows.map((m, i) => {
                const on = selected?.modelName === m.modelName && selected?.itemCode === m.itemCode;
                return (
                  <li key={`${m.modelName}|${m.itemCode}`} role="option" aria-selected={i === active}>
                    <button type="button" onClick={() => onSelect(m)} onMouseEnter={() => setActive(i)}
                      className={`w-full flex items-center justify-between gap-2 rounded-md border px-2.5 py-1.5 text-left ${i === active ? 'border-primary bg-primary/10' : 'border-border hover:border-primary/60'}`}>
                      <span className="min-w-0">
                        <span className="block text-sm font-bold text-text truncate">
                          {m.modelName}{m.planned === 'Y' && <span className="ml-1.5 rounded border border-primary/40 px-1 text-[10px] font-semibold text-primary">계획</span>}
                          {on && <span className="ml-1.5 text-[10px] font-semibold text-primary">선택됨</span>}
                        </span>
                        <span className="block text-[11px] leading-tight text-text-muted font-mono truncate">
                          {m.itemCode}{m.revision ? ` | ${m.revision}` : ''}{m.customerName ? ` · ${m.customerName}` : ''}
                        </span>
                      </span>
                      {i === active && <CornerDownLeft className="w-3.5 h-3.5 shrink-0 text-primary opacity-70" />}
                    </button>
                  </li>
                );
              })}
            </ul>
            {!loading && !rows.length && (
              <p className="py-10 text-center text-sm text-text-muted">
                {typed ? '맞는 모델이 없습니다. 다른 글자로 찾아보세요.' : '최근 계획에 있는 모델이 없습니다. 모델명이나 품번을 입력해 찾으세요.'}
              </p>
            )}
            {typed && rows.length >= LIMIT && (
              <p className="mt-2 text-xs text-text-muted">{LIMIT}건까지만 보여줍니다. 더 입력해서 좁혀 주세요.</p>
            )}
          </>
        )}
      </div>
    </Modal>
  );
}

"use client";

/**
 * @file src/app/(authenticated)/smt/line/components/SmtLocationGenerateModal.tsx
 * @description 피더 위치 일괄생성 — PB w_smt_line_master cb_3('Generate') 이식
 *
 * 초보자 가이드:
 * 1. **위치코드 규칙**: 테이블문자 + 주소 2자리 + 좌우문자.
 *    테이블 C, 주소 1~3, 좌우 → C01L C01R C02L C02R C03L C03R.
 * 2. **'위치문자 없음(N)' 은 좌우를 붙이지 않는다** — C01 C02 C03 이 된다.
 * 3. **'A 부터 전부' 를 켜면** 테이블문자를 A 부터 지정한 문자까지 전부 돈다.
 *    PB 의 같은 옵션은 좌우 선택과 주소 시작값을 무시하고 언제나 0 부터 L·R 을
 *    만들었다. 여기서는 화면에 넣은 값을 그대로 쓴다.
 * 4. 이미 있는 위치는 건너뛴다. 결과에 새로 만든 건수만 나온다.
 */
import { useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import { Wand2 } from 'lucide-react';
import Select from '@/components/ui/Select';
import { Button, Input, Modal } from '@/components/ui';
import api from '@/services/api';

interface Props {
  lineCode: string;
  machine: string;
  onClose: () => void;
  onDone: () => void;
}

const POSITION_OPTIONS = [
  { value: 'LR', label: '좌우 (L, R)' },
  { value: 'L', label: '좌측만 (L)' },
  { value: 'R', label: '우측만 (R)' },
  { value: 'N', label: '위치문자 없음' },
];

export default function SmtLocationGenerateModal({ lineCode, machine, onClose, onDone }: Props) {
  const [tableId, setTableId] = useState('A');
  const [addrFrom, setAddrFrom] = useState('1');
  const [addrTo, setAddrTo] = useState('10');
  const [positions, setPositions] = useState('LR');
  const [allTables, setAllTables] = useState(false);
  const [busy, setBusy] = useState(false);

  /** 만들어질 코드를 미리 보여 준다 — 규칙을 말로 설명하는 것보다 빠르다. */
  const preview = useMemo(() => {
    const from = Number(addrFrom);
    const to = Number(addrTo);
    const upper = tableId.trim().toUpperCase();
    if (!/^[A-Z]$/.test(upper) || !Number.isInteger(from) || !Number.isInteger(to) || to < from) {
      return [];
    }
    const tables = allTables
      ? Array.from(
          { length: upper.charCodeAt(0) - 'A'.charCodeAt(0) + 1 },
          (_, i) => String.fromCharCode('A'.charCodeAt(0) + i),
        )
      : [upper];
    const suffixes = positions === 'N' ? [''] : positions.split('');
    const out: string[] = [];
    for (const t of tables) {
      for (let a = from; a <= to && out.length < 8; a += 1) {
        for (const s of suffixes) {
          if (out.length >= 8) break;
          out.push(`${t}${String(a).padStart(2, '0')}${s}`);
        }
      }
    }
    return out;
  }, [tableId, addrFrom, addrTo, positions, allTables]);

  const totalCount = useMemo(() => {
    const from = Number(addrFrom);
    const to = Number(addrTo);
    const upper = tableId.trim().toUpperCase();
    if (!/^[A-Z]$/.test(upper) || !Number.isInteger(from) || !Number.isInteger(to) || to < from) {
      return 0;
    }
    const tables = allTables ? upper.charCodeAt(0) - 'A'.charCodeAt(0) + 1 : 1;
    const perAddress = positions === 'N' ? 1 : positions.length;
    return tables * (to - from + 1) * perAddress;
  }, [tableId, addrFrom, addrTo, positions, allTables]);

  const submit = async () => {
    const from = Number(addrFrom);
    const to = Number(addrTo);
    if (!/^[A-Za-z]$/.test(tableId.trim())) {
      toast.error('테이블문자는 알파벳 한 글자여야 합니다.');
      return;
    }
    if (!Number.isInteger(from) || !Number.isInteger(to) || from < 0 || to > 99 || to < from) {
      toast.error('주소는 0~99 범위이고 시작이 끝보다 작아야 합니다.');
      return;
    }
    setBusy(true);
    try {
      const response = await api.post('/smt/line/locations/generate', {
        lineCode,
        machine,
        tableId: tableId.trim().toUpperCase(),
        addrFrom: from,
        addrTo: to,
        positions,
        allTables: allTables ? 'Y' : 'N',
      });
      const created = Number(response.data?.data?.created ?? 0);
      toast.success(
        created > 0
          ? `위치 ${created}건을 만들었습니다.`
          : '새로 만들 위치가 없습니다 (모두 이미 있습니다).',
      );
      onDone();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '위치 생성에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  };

  return (
    <Modal isOpen onClose={onClose} title="피더 위치 일괄생성">
      <div className="space-y-4">
        <p className="text-sm text-text-muted">
          대상: <b className="text-text">{lineCode} / {machine}</b>
        </p>

        <div className="grid grid-cols-3 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">테이블문자</span>
            <Input value={tableId} maxLength={1}
              onChange={(e) => setTableId(e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">주소 시작</span>
            <Input type="number" min={0} max={99} value={addrFrom}
              onChange={(e) => setAddrFrom(e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">주소 끝</span>
            <Input type="number" min={0} max={99} value={addrTo}
              onChange={(e) => setAddrTo(e.target.value)} />
          </label>
        </div>

        <label className="block text-sm">
          <span className="text-text-muted">위치</span>
          <Select options={POSITION_OPTIONS} value={positions}
            onChange={(v) => setPositions(v)} />
        </label>

        <label className="flex items-center gap-2 text-sm text-text">
          <input type="checkbox" checked={allTables}
            onChange={(e) => setAllTables(e.target.checked)} />
          A 부터 지정한 문자까지 전부 만들기
        </label>

        <div className="rounded border border-border bg-surface-muted p-3 text-sm">
          <div className="text-text-muted">
            만들어질 위치 {totalCount.toLocaleString()}건 (이미 있는 것은 건너뜁니다)
          </div>
          <div className="mt-1 font-mono text-text">
            {preview.length > 0
              ? `${preview.join(' ')}${totalCount > preview.length ? ' …' : ''}`
              : '조건을 확인하세요.'}
          </div>
        </div>
      </div>

      <div className="mt-6 flex justify-end gap-2">
        <Button variant="secondary" onClick={onClose} disabled={busy}>취소</Button>
        <Button onClick={submit} disabled={busy || totalCount === 0}>
          <Wand2 className="mr-1 h-4 w-4" />생성
        </Button>
      </div>
    </Modal>
  );
}

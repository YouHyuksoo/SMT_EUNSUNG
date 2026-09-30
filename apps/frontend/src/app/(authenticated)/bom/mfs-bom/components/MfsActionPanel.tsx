"use client";

/**
 * @file src/app/(authenticated)/bom/mfs-bom/components/MfsActionPanel.tsx
 * @description 제조BOM(MFS) 생성·복사 우측 패널 — PB w_des_mfs_bom_master 의 생성/복사 입력부 이식
 *
 * 초보자 가이드:
 * 1. **생성**: 선택 모델 품목의 설계BOM 을 전개(PKG_DESIGN.BOM_QUERY_ALL / BOM_QUERY)해 MFS 한 벌을 만든다.
 *    같은 MFS 가 있으면 지우고 다시 만든다. 승인된 MFS 는 서버가 막는다.
 * 2. **복사**: 선택한 MFS 를 같은 품목의 새 MFS 로 복사한다. 대상 MFS 에 행이 있으면 서버가 막는다.
 * 3. MFS 는 대문자로 바꿔 보낸다(서버도 한 번 더 대문자·공백 제거를 한다).
 * 4. 실행 전에 확인 모달을 띄운다.
 */
import { useCallback, useState } from 'react';
import toast from 'react-hot-toast';
import { Copy, Play } from 'lucide-react';
import { Button, ConfirmModal, Input } from '@/components/ui';
import api from '@/services/api';
import type { MfsPanelMode } from '../types';

interface Props {
  mode: MfsPanelMode;
  itemCode: string;
  modelName: string;
  /** 복사 원본 (복사 모드에서 필수) */
  sourceMfs?: string;
  /** 이미 있는 MFS — 생성 시 선택 목록으로 보여준다 */
  existingMfs: string[];
  onClose: () => void;
  /** 성공 후 새로 만들어진 MFS 를 넘긴다 */
  onDone: (mfs: string) => void;
}

const MFS_MAX_LENGTH = 30;
const errorMessage = (error: unknown) =>
  (error as { response?: { data?: { message?: string } } })?.response?.data?.message;

export default function MfsActionPanel({
  mode, itemCode, modelName, sourceMfs, existingMfs, onClose, onDone,
}: Props) {
  const isCopy = mode === 'copy';
  const [mfs, setMfs] = useState('');
  const [showHide, setShowHide] = useState(true);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [running, setRunning] = useState(false);

  const target = mfs.trim().toUpperCase();
  const valid = Boolean(target) && !/[\s%]/.test(target) && (!isCopy || target !== sourceMfs);
  const overwrite = !isCopy && existingMfs.includes(target);

  const run = useCallback(async () => {
    setRunning(true);
    try {
      if (isCopy) {
        const res = await api.post('/bom/mfs/copy', { itemCode, sourceMfs, destMfs: target });
        toast.success(`${target} 로 ${Number(res.data?.data?.inserted ?? 0)}행을 복사했습니다`);
      } else {
        const res = await api.post('/bom/mfs/generate', { itemCode, mfs: target, showHide: showHide ? 'Y' : 'N' });
        toast.success(`${target} 제조BOM ${Number(res.data?.data?.inserted ?? 0)}행을 생성했습니다`);
      }
      setConfirmOpen(false);
      onDone(target);
    } catch (error: unknown) {
      setConfirmOpen(false);
      toast.error(errorMessage(error) || (isCopy ? '복사에 실패했습니다' : '생성에 실패했습니다'));
    } finally {
      setRunning(false);
    }
  }, [isCopy, itemCode, onDone, showHide, sourceMfs, target]);

  return (
    <div className="flex h-full w-[420px] flex-col overflow-hidden border-l border-border bg-background shadow-2xl animate-slide-in-right">
      <div className="flex flex-shrink-0 items-center justify-between border-b border-border px-5 py-3">
        <h2 className="text-sm font-bold text-text">{isCopy ? '제조BOM 복사' : '제조BOM 생성'}</h2>
        <div className="flex items-center gap-2">
          <Button size="sm" variant="secondary" onClick={onClose}>취소</Button>
          <Button size="sm" onClick={() => setConfirmOpen(true)} disabled={!valid || running}>
            {isCopy ? <Copy className="mr-1 h-4 w-4" /> : <Play className="mr-1 h-4 w-4" />}
            {isCopy ? '복사' : '생성'}
          </Button>
        </div>
      </div>

      <div className="flex-1 space-y-3 overflow-y-auto p-5 text-sm">
        <dl className="grid grid-cols-[88px_1fr] gap-y-1 text-text-muted">
          <dt>모델</dt><dd className="text-text">{modelName}</dd>
          <dt>품목코드</dt><dd className="font-mono text-text">{itemCode}</dd>
          {isCopy && (<><dt>원본 MFS</dt><dd className="font-mono text-text">{sourceMfs}</dd></>)}
        </dl>

        <label className="block text-text-muted">{isCopy ? '대상 MFS' : 'MFS'} <span className="text-red-500">*</span>
          <Input aria-label={isCopy ? '대상 MFS' : 'MFS'} value={mfs} maxLength={MFS_MAX_LENGTH}
            list={isCopy ? undefined : 'mfs-existing'}
            onChange={e => setMfs(e.target.value.toUpperCase())} fullWidth />
        </label>
        {!isCopy && (
          <datalist id="mfs-existing">
            {existingMfs.map(v => <option key={v} value={v} />)}
          </datalist>
        )}
        {mfs && !valid && (
          <p className="text-red-500">
            {isCopy && target === sourceMfs ? '원본과 다른 MFS 를 입력하세요.' : 'MFS 에는 공백과 % 를 쓸 수 없습니다.'}
          </p>
        )}

        {!isCopy && (
          <label className="flex items-start gap-2 text-text">
            <input type="checkbox" className="mt-0.5" checked={showHide} onChange={e => setShowHide(e.target.checked)} />
            <span>
              반제품 전개여부와 관계없이 전체 전개
              <span className="block text-xs text-text-muted">
                체크: PKG_DESIGN.BOM_QUERY_ALL, 해제: 반제품 전개여부(Y) 품목만 전개하는 BOM_QUERY. PB의 Show Hide Item 과 같습니다.
              </span>
            </span>
          </label>
        )}

        <p className="text-xs text-text-muted">
          {isCopy
            ? '원본 MFS 의 모든 행을 대상 MFS 로 복사합니다. 복사된 행은 사용(Y)·미승인(N) 상태로 등록됩니다.'
            : '오늘 기준 유효한 설계BOM 을 전개해 MFS 를 만듭니다. 같은 MFS 가 있으면 지우고 다시 만들며, 승인된 MFS 는 생성할 수 없습니다.'}
        </p>
      </div>

      <ConfirmModal
        isOpen={confirmOpen}
        onClose={() => setConfirmOpen(false)}
        onConfirm={run}
        isLoading={running}
        variant={overwrite ? 'danger' : 'default'}
        title={isCopy ? '제조BOM 복사' : '제조BOM 생성'}
        confirmText={isCopy ? '복사' : '생성'}
        message={isCopy
          ? <span>{itemCode} 의 <strong>{sourceMfs}</strong> 를 <strong>{target}</strong> 로 복사합니다.</span>
          : <span>{itemCode} 의 <strong>{target}</strong> 제조BOM 을 생성합니다.{overwrite && ' 기존 행은 모두 지우고 다시 만듭니다.'}</span>}
      />
    </div>
  );
}

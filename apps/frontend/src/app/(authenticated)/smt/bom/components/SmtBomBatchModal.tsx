"use client";

/**
 * @file src/app/(authenticated)/smt/bom/components/SmtBomBatchModal.tsx
 * @description SMT BOM 일괄작업 — 라인 교체 / 모델명 변경 / 범위 삭제
 *              PB w_smt_bom_create_master 의 일괄 UPDATE·DELETE 이식
 *
 * 초보자 가이드:
 * 1. 세 작업 모두 **수천 행을 한 번에 바꾼다.** 되돌릴 수 없으므로 어떤 범위가
 *    바뀌는지 모달에 적어 두고, 확인 문구를 한 번 더 받는다.
 * 2. **라인 교체는 설비코드도 바꾼다.** 설비코드가 `라인코드 + 설비순번` 규칙이라
 *    라인만 바꾸면 설비코드가 옛 라인을 가리킨다.
 * 3. **모델명 변경은 배포계획까지 함께 바꾼다.** 한쪽만 바꾸면 계획이 없는 모델을
 *    가리킨다. PB 가 빠뜨린 대체BOM 도 함께 바뀐다.
 * 4. **범위 삭제는 배포된 계획이 있으면 거부된다.** 계획을 먼저 지워야 한다.
 */
import { useState } from 'react';
import toast from 'react-hot-toast';
import { Button, Input, Modal } from '@/components/ui';
import api from '@/services/api';
import { SmtModelSelect, SmtPcbItemSelect } from '../../components/SmtSelects';

export type SmtBomBatchKind = 'line-swap' | 'model-rename' | 'delete-scope';

const TITLE: Record<SmtBomBatchKind, string> = {
  'line-swap': '라인 교체',
  'model-rename': '모델명 변경',
  'delete-scope': 'BOM 범위 삭제',
};

interface Props {
  kind: SmtBomBatchKind;
  defaultModelName: string;
  defaultLineCode: string;
  onClose: () => void;
  onDone: () => void;
}

export default function SmtBomBatchModal({
  kind, defaultModelName, defaultLineCode, onClose, onDone,
}: Props) {
  const [lineCode1, setLineCode1] = useState(defaultLineCode);
  const [lineCode2, setLineCode2] = useState('');
  const [oldModelName, setOldModelName] = useState(defaultModelName);
  const [newModelName, setNewModelName] = useState('');
  const [modelName, setModelName] = useState(defaultModelName);
  const [lineCode, setLineCode] = useState(defaultLineCode);
  const [pcbItem, setPcbItem] = useState('');
  const [confirmText, setConfirmText] = useState('');
  const [busy, setBusy] = useState(false);

  const CONFIRM_WORD = kind === 'delete-scope' ? '삭제' : '변경';

  const submit = async () => {
    if (confirmText.trim() !== CONFIRM_WORD) {
      toast.error(`확인란에 '${CONFIRM_WORD}' 를 입력하세요.`);
      return;
    }
    setBusy(true);
    try {
      if (kind === 'line-swap') {
        if (lineCode1.trim() === '' || lineCode2.trim() === '') {
          toast.error('두 라인코드를 모두 입력하세요.');
          return;
        }
        const response = await api.post('/smt/bom/line-swap', {
          lineCode1: lineCode1.trim(),
          lineCode2: lineCode2.trim(),
        });
        const data = response.data?.data;
        toast.success(
          `교체 완료 — ${lineCode1} ${data?.line1 ?? 0}행 / ${lineCode2} ${data?.line2 ?? 0}행`,
        );
      } else if (kind === 'model-rename') {
        if (oldModelName.trim() === '' || newModelName.trim() === '') {
          toast.error('바꿀 모델명과 새 모델명을 입력하세요.');
          return;
        }
        const response = await api.post('/smt/bom/model-rename', {
          oldModelName: oldModelName.trim(),
          newModelName: newModelName.trim(),
        });
        toast.success(
          `${newModelName} 으로 바꿨습니다 — BOM·대체BOM·배포계획 합계 ${response.data?.data?.rows ?? 0}행`,
        );
      } else {
        if (modelName.trim() === '' || lineCode.trim() === '') {
          toast.error('모델명과 라인코드를 입력하세요.');
          return;
        }
        const response = await api.delete('/smt/bom/scope', {
          data: {
            modelName: modelName.trim(),
            lineCode: lineCode.trim(),
            pcbItem: pcbItem || undefined,
          },
        });
        toast.success(`BOM·대체BOM 합계 ${response.data?.data?.deleted ?? 0}행을 지웠습니다.`);
      }
      onDone();
    } catch (error: unknown) {
      const message = (error as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      toast.error(message ?? '작업에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  };

  return (
    <Modal isOpen onClose={onClose} title={TITLE[kind]}>
      <div className="space-y-4">
        {kind === 'line-swap' && (
          <>
            <p className="text-sm text-text-muted">
              두 라인의 SMT BOM 을 서로 맞바꿉니다. 설비코드 앞 두 자리도 새 라인코드로 바뀝니다.
            </p>
            <div className="grid grid-cols-2 gap-3">
              <label className="block text-sm">
                <span className="text-text-muted">라인 1</span>
                <Input value={lineCode1} onChange={(e) => setLineCode1(e.target.value)} />
              </label>
              <label className="block text-sm">
                <span className="text-text-muted">라인 2</span>
                <Input value={lineCode2} onChange={(e) => setLineCode2(e.target.value)} />
              </label>
            </div>
          </>
        )}

        {kind === 'model-rename' && (
          <>
            <p className="text-sm text-text-muted">
              SMT BOM · 대체 BOM · 배포계획의 모델명을 함께 바꿉니다.
              새 모델명으로 된 BOM 이 이미 있으면 거부됩니다.
            </p>
            <label className="block text-sm">
              <span className="text-text-muted">바꿀 모델명</span>
              <SmtModelSelect includeAll value={oldModelName}
                onChange={setOldModelName} />
            </label>
            <label className="block text-sm">
              <span className="text-text-muted">새 모델명</span>
              <Input value={newModelName} onChange={(e) => setNewModelName(e.target.value)} />
            </label>
          </>
        )}

        {kind === 'delete-scope' && (
          <>
            <p className="text-sm text-text-muted">
              모델 + 라인 + 면 범위의 SMT BOM 과 대체 BOM 을 지웁니다.
              배포된 계획이 있으면 거부됩니다 — 계획을 먼저 지우세요.
            </p>
            <label className="block text-sm">
              <span className="text-text-muted">모델명</span>
              <SmtModelSelect includeAll value={modelName} onChange={setModelName} />
            </label>
            <div className="grid grid-cols-2 gap-3">
              <label className="block text-sm">
                <span className="text-text-muted">라인코드</span>
                <Input value={lineCode} onChange={(e) => setLineCode(e.target.value)} />
              </label>
              <label className="block text-sm">
                <span className="text-text-muted">PCB 면 (비우면 양면)</span>
                <SmtPcbItemSelect includeAll value={pcbItem} onChange={setPcbItem} />
              </label>
            </div>
          </>
        )}

        <label className="block text-sm">
          <span className="text-text-muted">
            되돌릴 수 없습니다. 진행하려면 &apos;{CONFIRM_WORD}&apos; 를 입력하세요.
          </span>
          <Input value={confirmText} onChange={(e) => setConfirmText(e.target.value)} />
        </label>
      </div>

      <div className="mt-6 flex justify-end gap-2">
        <Button variant="secondary" onClick={onClose} disabled={busy}>취소</Button>
        <Button variant={kind === 'delete-scope' ? 'danger' : 'primary'}
          onClick={submit} disabled={busy || confirmText.trim() !== CONFIRM_WORD}>
          {TITLE[kind]}
        </Button>
      </div>
    </Modal>
  );
}

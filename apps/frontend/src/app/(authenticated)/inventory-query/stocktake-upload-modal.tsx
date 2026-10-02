/**
 * @file src/app/(authenticated)/inventory-query/barcode-check/upload-modal.tsx
 * @description 실사 엑셀 업로드 — 바코드(또는 롯트번호)·수량 목록을 한꺼번에 스캔으로 반영한다
 *
 * 초보자 가이드:
 * 1. 첫 시트의 머리글에 "바코드" 또는 "롯트번호" 열이 있어야 한다. "수량" 을 비우면 바코드 수량.
 * 2. 이미 찍은 롯트는 엑셀 수량으로 고친다. 같은 파일을 다시 올려도 결과가 같다.
 * 3. 반영하지 못한 줄(미등록·수량 오류·파일 안 중복)은 줄 번호와 사유로 보여 준다.
 */
import { useState } from 'react';
import * as XLSX from 'xlsx';
import { Download, Upload } from 'lucide-react';
import { Button, Modal } from '@/components/ui';
import api from '@/services/api';
import { apiMessage } from '../stocktake';

interface UploadResult {
  yyyymm: string;
  applied: number;
  updated: number;
  errors: { row: number; value: string; reason: string }[];
}

interface Props {
  isOpen: boolean;
  yyyymm: string;
  onClose: () => void;
  onDone: () => void;
}

/** 빈 양식 (머리글만) */
const downloadTemplate = () => {
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, XLSX.utils.aoa_to_sheet([['바코드', '롯트번호', '수량']]), '실사');
  XLSX.writeFile(wb, '자재실사_양식.xlsx');
};

export default function UploadModal({ isOpen, yyyymm, onClose, onDone }: Props) {
  const [file, setFile] = useState<File | null>(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  const [result, setResult] = useState<UploadResult | null>(null);

  const close = () => {
    setFile(null); setError(''); setResult(null);
    onClose();
  };

  const upload = async () => {
    if (!file) return;
    setBusy(true); setError(''); setResult(null);
    try {
      const body = new FormData();
      body.append('file', file);
      const r = await api.post('/inventory-query/stocktake/upload', body, {
        headers: { 'Content-Type': 'multipart/form-data' },
        timeout: 300_000,
      });
      setResult(r.data?.data as UploadResult);
      onDone();
    } catch (caught: unknown) {
      setError(apiMessage(caught) ?? '업로드에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  };

  return (
    <Modal isOpen={isOpen} onClose={close} title={`${yyyymm} 실사 엑셀 업로드`} size="lg"
      footer={(
        <>
          <Button variant="secondary" onClick={downloadTemplate}>
            <Download className="mr-1 h-4 w-4" />양식 받기
          </Button>
          <Button variant="secondary" onClick={close}>닫기</Button>
          <Button onClick={upload} disabled={!file || busy}>
            <Upload className="mr-1 h-4 w-4" />{busy ? '올리는 중' : '업로드'}
          </Button>
        </>
      )}>
      <div className="space-y-3">
        <p className="text-sm text-text-muted">
          첫 시트의 머리글에 <b>바코드</b> 또는 <b>롯트번호</b> 열이 있어야 합니다. <b>수량</b>을 비우면 바코드
          수량으로 셉니다. 이미 찍은 롯트는 엑셀 수량으로 고칩니다.
        </p>
        <label className="block cursor-pointer rounded-lg border-2 border-dashed border-border p-8 text-center text-sm"
          onDragOver={(e) => e.preventDefault()}
          onDrop={(e) => { e.preventDefault(); const next = e.dataTransfer.files[0]; if (next) { setFile(next); setResult(null); } }}>
          <input type="file" accept=".xlsx,.xls,.csv" className="hidden"
            onChange={(e) => { const next = e.target.files?.[0]; if (next) { setFile(next); setResult(null); } }} />
          {file ? file.name : '.xlsx · .xls · .csv 파일을 끌어 놓거나 누르세요'}
        </label>
        {error && <p className="text-sm text-red-500">{error}</p>}
        {result && (
          <div className="space-y-2">
            <p className="text-sm font-semibold text-emerald-600">
              {result.applied.toLocaleString()}줄 반영
              {result.updated ? ` (이미 찍은 롯트 ${result.updated.toLocaleString()}개는 수량을 고침)` : ''}
              {result.errors.length ? ` · 반영 못 함 ${result.errors.length.toLocaleString()}줄` : ''}
            </p>
            {result.errors.length > 0 && (
              <div className="max-h-60 overflow-auto rounded border border-border">
                <table className="w-full text-xs">
                  <thead className="sticky top-0 bg-surface">
                    <tr><th className="px-2 py-1 text-left">줄</th><th className="px-2 py-1 text-left">값</th><th className="px-2 py-1 text-left">사유</th></tr>
                  </thead>
                  <tbody>
                    {result.errors.map((e) => (
                      <tr key={e.row} className="border-t border-border">
                        <td className="px-2 py-1">{e.row}</td>
                        <td className="px-2 py-1">{e.value}</td>
                        <td className="px-2 py-1 text-red-500">{e.reason}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        )}
      </div>
    </Modal>
  );
}

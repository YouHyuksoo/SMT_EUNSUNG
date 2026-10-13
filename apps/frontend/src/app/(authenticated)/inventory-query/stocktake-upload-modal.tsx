/**
 * @file src/app/(authenticated)/inventory-query/stocktake-upload-modal.tsx
 * @description 실사 엑셀 업로드 — 원자재 실사(274)와 공정 실사가 같이 쓴다
 *
 * 초보자 가이드:
 * 1. 파일을 서버로 보내고 서버가 첫 시트를 읽는다. 어떤 열을 읽는지는 `guide` 문구와 양식 머리글로 알린다.
 * 2. 이미 넣은 롯트(품목)는 엑셀 수량으로 고친다. 같은 파일을 다시 올려도 결과가 같다.
 * 3. 반영하지 못한 줄은 엑셀 줄 번호와 사유로 보여 준다.
 */
import { useState } from 'react';
import * as XLSX from 'xlsx';
import { Download, Upload } from 'lucide-react';
import type { ColumnDef } from '@tanstack/react-table';
import { Button, Modal } from '@/components/ui';
import DataGrid from '@/components/data-grid/DataGrid';
import api from '@/services/api';
import { apiMessage } from './stocktake';

interface UploadError { row: number; value: string; reason: string }

interface UploadResult {
  yyyymm: string;
  applied: number;
  updated: number;
  errors: UploadError[];
}

/** 반영하지 못한 줄 그리드 컬럼 — 사유는 빨간색 */
const errorColumns: ColumnDef<UploadError>[] = [
  { accessorKey: 'row', header: '줄', size: 70, meta: { align: 'right' } },
  { accessorKey: 'value', header: '값', size: 180 },
  {
    accessorKey: 'reason', header: '사유', size: 280,
    cell: ({ getValue }) => <span className="text-red-500">{String(getValue() ?? '')}</span>,
  },
];

interface Props {
  isOpen: boolean;
  /** 제목에 붙는 이름 (예: "202610 실사") */
  title: string;
  /** 업로드 API 경로 */
  endpoint: string;
  /** 양식 머리글과 파일 이름 */
  template: { headers: string[]; fileName: string };
  /** 어떤 열을 읽는지 설명 */
  guide: React.ReactNode;
  onClose: () => void;
  onDone: () => void;
}

export default function StocktakeUploadModal({ isOpen, title, endpoint, template, guide, onClose, onDone }: Props) {
  /** 빈 양식 (머리글만) */
  const downloadTemplate = () => {
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, XLSX.utils.aoa_to_sheet([template.headers]), '실사');
    XLSX.writeFile(wb, template.fileName);
  };

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
      const r = await api.post(endpoint, body, {
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
    <Modal isOpen={isOpen} onClose={close} title={`${title} 엑셀 업로드`} size="lg"
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
        <p className="text-sm text-text-muted">{guide}</p>
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
              {result.updated ? ` (이미 넣은 ${result.updated.toLocaleString()}건은 수량을 고침)` : ''}
              {result.errors.length ? ` · 반영 못 함 ${result.errors.length.toLocaleString()}줄` : ''}
            </p>
            {result.errors.length > 0 && (
              <DataGrid data={result.errors} columns={errorColumns} maxHeight="240px" enableFullscreen={false}
                enableExport exportFileName={`${title} 업로드 오류`} />
            )}
          </div>
        )}
      </div>
    </Modal>
  );
}

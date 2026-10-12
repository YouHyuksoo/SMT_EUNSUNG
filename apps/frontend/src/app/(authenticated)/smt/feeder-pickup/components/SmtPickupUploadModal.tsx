"use client";

/**
 * @file src/app/(authenticated)/smt/feeder-pickup/components/SmtPickupUploadModal.tsx
 * @description 마운터 픽업 엑셀 업로드 — PB w_mcn_feeder_pickup_master cb('Excel Upload') 이식
 *
 * 초보자 가이드:
 * 1. **PB 는 엑셀을 DataWindow 에 올려 컬럼 위치로 읽었다** — C02 피더ID,
 *    C03 피더유형, C32 이송횟수, C34 흡착에러. 마운터가 뱉는 시트는 헤더 문구가
 *    기기마다 달라서 위치로 읽는 것이 맞다. 그 규칙을 그대로 유지한다.
 *    (엑셀 B열=C02, C열=C03, AF열=C32, AH열=C34)
 * 2. **적재는 (생산일 + 라인) 범위를 갈아끼운다.** 같은 날 같은 라인을 두 번 올리면
 *    앞의 것을 지우고 새로 넣는다 — 이 표에는 유일제약이 없어 그냥 넣으면 두 줄이 된다.
 * 3. **올리기 전에 읽은 내용을 먼저 보여준다.** 엑셀 열 위치를 잘못 잡으면
 *    숫자가 엉뚱하게 들어가므로, 앞 5줄을 확인하고 올린다.
 */
import { useState } from 'react';
import * as XLSX from 'xlsx';
import toast from 'react-hot-toast';
import { Upload } from 'lucide-react';
import { Button, Input, Modal } from '@/components/ui';
import api from '@/services/api';
import { SmtModelSelect } from '../../components/SmtSelects';

/** PB DataWindow 컬럼 ↔ 엑셀 열 번호(0-based). PB 의 C02/C03/C32/C34 다. */
const COL = { feederId: 1, feederType: 2, transferCount: 31, adsorptionErrorCount: 33 };

interface ParsedRow {
  feederId: string;
  feederType?: string;
  transferCount: number;
  adsorptionErrorCount: number;
}

interface Props {
  defaultLineCode: string;
  onClose: () => void;
  onDone: () => void;
}

const toNumber = (value: unknown) => {
  const n = Number(String(value ?? '').replace(/,/g, '').trim());
  return Number.isFinite(n) && n >= 0 ? Math.trunc(n) : 0;
};

export default function SmtPickupUploadModal({ defaultLineCode, onClose, onDone }: Props) {
  const [productDate, setProductDate] = useState(new Date().toISOString().slice(0, 10));
  const [lineCode, setLineCode] = useState(defaultLineCode);
  const [modelName, setModelName] = useState('');
  const [fileName, setFileName] = useState('');
  const [parsed, setParsed] = useState<ParsedRow[]>([]);
  const [error, setError] = useState('');
  const [busy, setBusy] = useState(false);

  const inspect = async (file: File) => {
    setError('');
    setParsed([]);
    setFileName(file.name);
    try {
      const book = XLSX.read(await file.arrayBuffer());
      const sheetName = book.SheetNames[0];
      if (!sheetName) throw new Error('시트가 없습니다.');
      const grid = XLSX.utils.sheet_to_json<unknown[]>(book.Sheets[sheetName], {
        header: 1,
        defval: '',
      });
      // 첫 줄은 헤더로 본다 (PB 도 1행부터 데이터로 읽었다)
      const rows: ParsedRow[] = [];
      for (const line of grid.slice(1)) {
        const feederId = String(line[COL.feederId] ?? '').trim();
        if (feederId === '') continue;
        rows.push({
          feederId,
          feederType: String(line[COL.feederType] ?? '').trim() || undefined,
          transferCount: toNumber(line[COL.transferCount]),
          adsorptionErrorCount: toNumber(line[COL.adsorptionErrorCount]),
        });
      }
      if (rows.length === 0) throw new Error('피더 ID(B열)가 있는 줄이 없습니다.');
      if (rows.length > 5000) throw new Error(`한 번에 5,000줄까지 올립니다 (읽은 줄 ${rows.length}).`);
      setParsed(rows);
    } catch (caught: unknown) {
      setFileName('');
      setError(caught instanceof Error ? caught.message : '파일을 읽을 수 없습니다.');
    }
  };

  const upload = async () => {
    if (lineCode.trim() === '' || parsed.length === 0) return;
    setBusy(true);
    try {
      const response = await api.post('/smt/pickup/upload', {
        productDate,
        lineCode: lineCode.trim(),
        modelName: modelName || undefined,
        rows: parsed,
      });
      const data = response.data?.data;
      toast.success(
        `${data?.inserted ?? 0}건 적재`
        + (Number(data?.replaced ?? 0) > 0 ? ` (기존 ${data.replaced}건 대체)` : ''),
      );
      onDone();
    } catch (caught: unknown) {
      const message = (caught as { response?: { data?: { message?: string } } })
        ?.response?.data?.message;
      setError(message ?? '업로드에 실패했습니다.');
    } finally {
      setBusy(false);
    }
  };

  return (
    <Modal isOpen onClose={onClose} title="마운터 픽업 엑셀 업로드">
      <div className="space-y-4">
        <div className="grid grid-cols-2 gap-3">
          <label className="block text-sm">
            <span className="text-text-muted">생산일 *</span>
            <Input type="date" value={productDate}
              onChange={(e) => setProductDate(e.target.value)} />
          </label>
          <label className="block text-sm">
            <span className="text-text-muted">라인코드 *</span>
            <Input value={lineCode} onChange={(e) => setLineCode(e.target.value)} />
          </label>
        </div>
        <label className="block text-sm">
          <span className="text-text-muted">모델명</span>
          <SmtModelSelect includeAll value={modelName} onChange={setModelName} />
        </label>

        <label
          className="block cursor-pointer rounded-lg border-2 border-dashed border-border p-8 text-center"
          onDragOver={(event) => event.preventDefault()}
          onDrop={(event) => {
            event.preventDefault();
            const next = event.dataTransfer.files[0];
            if (next) void inspect(next);
          }}
        >
          <input type="file" accept=".xlsx,.xls,.csv" className="hidden"
            onChange={(event) => {
              const next = event.target.files?.[0];
              if (next) void inspect(next);
            }} />
          {fileName || '마운터 엑셀 파일을 드래그하거나 선택하세요'}
        </label>

        <p className="text-xs text-text-muted">
          열 위치로 읽습니다 — B열 피더 ID · C열 피더유형 · AF열 이송횟수 · AH열 흡착에러.
          첫 줄은 헤더로 건너뜁니다.
        </p>

        {error && <p className="text-sm text-red-600">{error}</p>}

        {parsed.length > 0 && (
          <div className="rounded border border-border bg-surface-muted p-3 text-sm">
            <div className="text-text">
              읽은 줄 {parsed.length.toLocaleString()}건 · 같은 생산일·라인의 기존 적재는 대체됩니다
            </div>
            <table className="mt-2 w-full text-left text-xs">
              <thead className="text-text-muted">
                <tr>
                  <th className="py-1">피더 ID</th>
                  <th className="py-1">유형</th>
                  <th className="py-1 text-right">이송</th>
                  <th className="py-1 text-right">흡착에러</th>
                  <th className="py-1 text-right">에러율</th>
                </tr>
              </thead>
              <tbody className="font-mono text-text">
                {parsed.slice(0, 5).map((row) => (
                  <tr key={row.feederId}>
                    <td className="py-0.5">{row.feederId}</td>
                    <td className="py-0.5">{row.feederType ?? ''}</td>
                    <td className="py-0.5 text-right">{row.transferCount.toLocaleString()}</td>
                    <td className="py-0.5 text-right">
                      {row.adsorptionErrorCount.toLocaleString()}
                    </td>
                    <td className="py-0.5 text-right">
                      {row.transferCount === 0
                        ? '0.0%'
                        : `${((row.adsorptionErrorCount / row.transferCount) * 100).toFixed(1)}%`}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
            {parsed.length > 5 && (
              <div className="mt-1 text-text-muted">… 앞 5줄만 보여줍니다</div>
            )}
          </div>
        )}
      </div>

      <div className="mt-6 flex justify-end gap-2">
        <Button variant="secondary" onClick={onClose} disabled={busy}>취소</Button>
        <Button onClick={upload}
          disabled={busy || parsed.length === 0 || lineCode.trim() === ''}>
          <Upload className="mr-1 h-4 w-4" />업로드
        </Button>
      </div>
    </Modal>
  );
}

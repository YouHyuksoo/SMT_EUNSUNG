'use client';

import { useMemo, useState } from 'react';
import type { ReactNode } from 'react';
import { AlertTriangle, CheckCircle2, Database, FileSpreadsheet, Loader2, UploadCloud } from 'lucide-react';

type PreviewResult = {
  file: { sheetName: string; rowCount: number };
  counts: {
    records: number;
    models: number;
    runs: number;
    rowsWithEp4: number;
    rowsWithEp6: number;
    duplicateEp1: number;
    missingRequiredRows: number;
  };
  db: {
    existingModels: number;
    missingModels: string[];
    existingRuns: number;
    existingSerials: number;
    existingWorkstageSerials: number;
    bomOk: number;
    bomIssues: Array<{
      hspswChild: string;
      reason: string;
      candidates: Array<{ hspawChild: string; memwlChild: string | null }>;
    }>;
  };
  plan: {
    modelMasterInserts: number;
    miPlanInserts: number;
    runCardInserts: number;
    barcodeInserts: number;
    workstageIoInserts: number;
    workstageDetailInserts: number;
    generatedHspawBarcodes: number;
  };
  samples: {
    errors: Array<{ rowNo: number; message: string }>;
  };
};

function numberFormat(value: number) {
  return new Intl.NumberFormat('ko-KR').format(value);
}

export default function MigrationPage() {
  const [file, setFile] = useState<File | null>(null);
  const [preview, setPreview] = useState<PreviewResult | null>(null);
  const [message, setMessage] = useState('');
  const [loading, setLoading] = useState<'preview' | 'apply' | null>(null);
  const [pickerOpened, setPickerOpened] = useState(false);
  const [progressLog, setProgressLog] = useState<string[]>([]);

  const canApply = useMemo(() => {
    if (!preview) return false;
    return preview.counts.duplicateEp1 === 0
      && preview.counts.missingRequiredRows === 0
      && preview.db.existingSerials === 0;
  }, [preview]);

  async function submit(action: 'preview' | 'apply') {
    if (!file) {
      setMessage('파일을 먼저 선택하세요.');
      return;
    }
    setLoading(action);
    setMessage('');
    setProgressLog([]);
    const formData = new FormData();
    formData.append('file', file);
    formData.append('action', action);
    try {
      const response = await fetch('/api/migration/somos-product', { method: 'POST', body: formData });
      if (!response.body) throw new Error('스트림을 받을 수 없습니다.');
      const reader = response.body.getReader();
      const decoder = new TextDecoder();
      let buf = '';
      while (true) {
        const { done, value } = await reader.read();
        if (done) break;
        buf += decoder.decode(value, { stream: true });
        const lines = buf.split('\n');
        buf = lines.pop() ?? '';
        for (const line of lines) {
          if (!line.startsWith('data: ')) continue;
          try {
            const event = JSON.parse(line.slice(6)) as { log?: string; done?: boolean; result?: PreviewResult; error?: string };
            if (event.log) {
              setProgressLog((prev) => [...prev, event.log!]);
            } else if (event.done && event.result) {
              setPreview(event.result);
              setMessage(action === 'apply' ? '적용이 완료되었습니다.' : 'Preview가 완료되었습니다.');
            } else if (event.error) {
              setMessage(event.error);
            }
          } catch {
            // 불완전한 라인 무시
          }
        }
      }
    } catch (error) {
      setMessage(error instanceof Error ? error.message : '요청 중 오류가 발생했습니다.');
    } finally {
      setLoading(null);
    }
  }

  return (
    <main className="min-h-screen bg-zinc-100 text-zinc-950 dark:bg-zinc-950 dark:text-zinc-50">
      <div className="mx-auto flex w-full max-w-[1440px] flex-col gap-4 px-6 py-5">
        <header className="flex flex-wrap items-center justify-between gap-3 border-b border-zinc-300 pb-4 dark:border-zinc-800">
          <div>
            <h1 className="flex items-center gap-2 text-2xl font-semibold">
              SOMOS 생산결과 역복구
              <span className="rounded bg-zinc-200 px-2 py-0.5 text-xs font-medium text-zinc-600 dark:bg-zinc-800 dark:text-zinc-400">v1.0</span>
            </h1>
            <p className="mt-1 text-sm text-zinc-600 dark:text-zinc-400">
              Excel 결과 파일을 기준으로 제품 생산 원천 테이블을 복구합니다.
            </p>
          </div>
          <div className="flex items-center gap-2 text-sm text-zinc-600 dark:text-zinc-400">
            <Database className="h-4 w-4" />
            BJVNSET / MIGRATION
          </div>
        </header>

        <section className="grid gap-4 lg:grid-cols-[420px_1fr]">
          <div className="rounded border border-zinc-300 bg-white p-4 dark:border-zinc-800 dark:bg-zinc-900">
            <label className="block text-sm font-medium">Excel 파일</label>
            <div className={`mt-3 flex min-h-40 flex-col items-center justify-center gap-3 rounded border border-dashed p-4 text-center transition ${
              file
                ? 'border-emerald-500 bg-emerald-50 dark:border-emerald-500/70 dark:bg-emerald-950/30'
                : pickerOpened
                  ? 'border-amber-500 bg-amber-50 shadow-inner dark:border-amber-500/70 dark:bg-amber-950/30'
                  : 'border-zinc-300 bg-zinc-50 hover:border-emerald-500 hover:bg-emerald-50/60 dark:border-zinc-700 dark:bg-zinc-950 dark:hover:border-emerald-500/70 dark:hover:bg-emerald-950/20'
            }`}>
              <FileSpreadsheet className={`h-8 w-8 ${file ? 'text-emerald-700 dark:text-emerald-400' : 'text-emerald-600'}`} />
              <input
                id="somos-excel-file"
                type="file"
                accept=".xlsx,.xls"
                onChange={(event) => {
                  setFile(event.target.files?.[0] ?? null);
                  setPreview(null);
                  setMessage('');
                  setPickerOpened(false);
                }}
                className="sr-only"
              />
              <label
                htmlFor="somos-excel-file"
                onClick={() => setPickerOpened(true)}
                className="inline-flex h-10 cursor-pointer items-center justify-center gap-2 rounded bg-zinc-900 px-4 text-sm font-medium text-white shadow-sm transition hover:bg-zinc-700 active:scale-[0.98] active:bg-emerald-700 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-emerald-500 dark:bg-zinc-100 dark:text-zinc-950 dark:hover:bg-zinc-300"
              >
                {file ? <CheckCircle2 className="h-4 w-4" /> : <UploadCloud className="h-4 w-4" />}
                {file ? '파일 변경' : '파일 선택'}
              </label>
              <div className="flex max-w-full flex-col items-center gap-1">
                <p className={`max-w-full truncate text-sm font-medium ${file ? 'text-emerald-800 dark:text-emerald-300' : 'text-zinc-600 dark:text-zinc-400'}`}>
                  {file?.name ?? (pickerOpened ? '파일 선택 창 열림' : '선택된 파일 없음')}
                </p>
                <span className={`rounded px-2 py-0.5 text-[11px] font-medium ${
                  file
                    ? 'bg-emerald-100 text-emerald-800 dark:bg-emerald-900 dark:text-emerald-200'
                    : pickerOpened
                      ? 'bg-amber-100 text-amber-800 dark:bg-amber-900 dark:text-amber-200'
                      : 'bg-zinc-200 text-zinc-600 dark:bg-zinc-800 dark:text-zinc-300'
                }`}>
                  {file ? '파일 선택됨' : pickerOpened ? '선택 대기' : '대기'}
                </span>
              </div>
            </div>

            <div className="mt-4 grid grid-cols-2 gap-2">
              <button
                type="button"
                onClick={() => submit('preview')}
                disabled={!file || loading !== null}
                className="inline-flex h-10 items-center justify-center gap-2 rounded bg-zinc-900 px-3 text-sm font-medium text-white disabled:opacity-50 dark:bg-zinc-100 dark:text-zinc-950"
              >
                {loading === 'preview' ? <Loader2 className="h-4 w-4 animate-spin" /> : <UploadCloud className="h-4 w-4" />}
                Preview
              </button>
              <button
                type="button"
                onClick={() => submit('apply')}
                disabled={!file || !canApply || loading !== null}
                className="inline-flex h-10 items-center justify-center gap-2 rounded bg-emerald-700 px-3 text-sm font-medium text-white disabled:opacity-50"
              >
                {loading === 'apply' ? <Loader2 className="h-4 w-4 animate-spin" /> : <CheckCircle2 className="h-4 w-4" />}
                Apply
              </button>
            </div>

            {(loading !== null || progressLog.length > 0) && (
              <ProgressLog entries={progressLog} running={loading !== null} />
            )}

            {message && (
              <div className="mt-4 rounded border border-amber-300 bg-amber-50 p-3 text-sm text-amber-900 dark:border-amber-800 dark:bg-amber-950 dark:text-amber-100">
                {message}
              </div>
            )}

            <div className="mt-4 space-y-2 text-xs text-zinc-600 dark:text-zinc-400">
              <p>대상: MODEL_MASTER, MI_PLAN, RUN_CARD, 2D_BARCODE, WORKSTAGE_IO, WORKSTAGE_DETAIL</p>
              <p>Excel 기준값만 사용하며, HSPAW parent만 중복 방지용 MIG-HSPAW 값으로 생성합니다.</p>
            </div>
          </div>

          <div className="min-w-0 space-y-4">
            {preview ? <PreviewPanel preview={preview} /> : (
              <div className="rounded border border-zinc-300 bg-white p-8 text-center text-sm text-zinc-500 dark:border-zinc-800 dark:bg-zinc-900">
                파일을 선택하고 Preview를 실행하세요.
              </div>
            )}
          </div>
        </section>
      </div>
    </main>
  );
}

function PreviewPanel({ preview }: { preview: PreviewResult }) {
  const cards = [
    ['데이터 행', preview.counts.records],
    ['모델', preview.counts.models],
    ['RUN', preview.counts.runs],
    ['생성 Serial', preview.plan.barcodeInserts],
    ['HSPAW 생성', preview.plan.generatedHspawBarcodes],
    ['BOM 정상', preview.db.bomOk],
  ];

  return (
    <>
      <section className="grid gap-3 md:grid-cols-3 xl:grid-cols-6">
        {cards.map(([label, value]) => (
          <div key={String(label)} className="rounded border border-zinc-300 bg-white p-3 dark:border-zinc-800 dark:bg-zinc-900">
            <div className="text-xs text-zinc-500">{label}</div>
            <div className="mt-1 text-xl font-semibold">{numberFormat(Number(value))}</div>
          </div>
        ))}
      </section>

      <section className="grid gap-4 xl:grid-cols-2">
        <InfoBlock title="DB 중복/기준정보">
          <Metric label="기존 Serial" value={preview.db.existingSerials} danger={preview.db.existingSerials > 0} />
          <Metric label="기존 Workstage" value={preview.db.existingWorkstageSerials} danger={preview.db.existingWorkstageSerials > 0} />
          <Metric label="기존 RUN" value={preview.db.existingRuns} />
          <Metric label="추가 Model Master" value={preview.plan.modelMasterInserts} />
          <Metric label="필수값 누락 행" value={preview.counts.missingRequiredRows} danger={preview.counts.missingRequiredRows > 0} />
          <Metric label="e-Pass1 중복" value={preview.counts.duplicateEp1} danger={preview.counts.duplicateEp1 > 0} />
        </InfoBlock>

        <InfoBlock title="생성 계획">
          <Metric label="MI Plan" value={preview.plan.miPlanInserts} />
          <Metric label="Run Card" value={preview.plan.runCardInserts} />
          <Metric label="2D Barcode" value={preview.plan.barcodeInserts} />
          <Metric label="Workstage IO" value={preview.plan.workstageIoInserts} />
          <Metric label="Workstage Detail" value={preview.plan.workstageDetailInserts} />
        </InfoBlock>
      </section>

      {(preview.db.bomIssues.length > 0 || preview.samples.errors.length > 0) && (
        <section className="rounded border border-amber-300 bg-amber-50 p-4 dark:border-amber-800 dark:bg-amber-950">
          <div className="mb-3 flex items-center gap-2 font-medium text-amber-900 dark:text-amber-100">
            <AlertTriangle className="h-4 w-4" />
            확인 필요
          </div>
          <div className="grid gap-4 text-sm lg:grid-cols-2">
            <ListBlock title="BOM 이슈" items={preview.db.bomIssues.slice(0, 20).map((x) => `${x.hspswChild}: ${x.reason}`)} empty="없음" />
            <ListBlock title="행 오류" items={preview.samples.errors.map((x) => `${x.rowNo}: ${x.message}`)} empty="없음" />
          </div>
        </section>
      )}

    </>
  );
}

function InfoBlock({ title, children }: { title: string; children: ReactNode }) {
  return (
    <section className="rounded border border-zinc-300 bg-white p-4 dark:border-zinc-800 dark:bg-zinc-900">
      <h2 className="mb-3 text-sm font-semibold">{title}</h2>
      <div className="grid grid-cols-2 gap-2">{children}</div>
    </section>
  );
}

function Metric({ label, value, danger = false }: { label: string; value: number; danger?: boolean }) {
  return (
    <div className="rounded bg-zinc-100 px-3 py-2 dark:bg-zinc-950">
      <div className="text-xs text-zinc-500">{label}</div>
      <div className={`text-lg font-semibold ${danger ? 'text-red-600' : ''}`}>{numberFormat(value)}</div>
    </div>
  );
}

function ProgressLog({ entries, running }: { entries: string[]; running: boolean }) {
  return (
    <div className="mt-4 rounded border border-zinc-200 bg-zinc-950 p-3 dark:border-zinc-700">
      <div className="mb-1 text-[11px] font-medium uppercase tracking-wide text-zinc-400">진행 로그</div>
      <div className="max-h-44 overflow-auto font-mono text-xs text-zinc-300">
        {entries.map((msg, i) => (
          <div key={i} className="py-0.5">
            <span className="mr-2 text-emerald-400">✓</span>{msg}
          </div>
        ))}
        {running && (
          <div className="py-0.5 text-amber-400">
            <span className="mr-2 animate-pulse">●</span>처리 중...
          </div>
        )}
      </div>
    </div>
  );
}

function ListBlock({ title, items, empty }: { title: string; items: string[]; empty: string }) {
  return (
    <div>
      <div className="mb-1 text-xs font-semibold uppercase text-amber-800 dark:text-amber-200">{title}</div>
      {items.length ? (
        <ul className="max-h-40 overflow-auto rounded bg-white/70 p-2 dark:bg-black/20">
          {items.map((item) => <li key={item} className="py-0.5">{item}</li>)}
        </ul>
      ) : (
        <div className="rounded bg-white/70 p-2 dark:bg-black/20">{empty}</div>
      )}
    </div>
  );
}

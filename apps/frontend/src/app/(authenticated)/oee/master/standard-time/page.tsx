'use client';

/**
 * @file (authenticated)/oee/master/standard-time/page.tsx
 * @description 표준시간 관리 — 모델 기준 ST/CT/NT/TT 표준시간 등록·조회 (Mock-up, 실 DB 미연결)
 */
import { useMemo, useState } from 'react';
import Modal from '@/components/ui/Modal';

// 로그인 사용자(등록자 자동 적용) — Mock. 실 구현 시 인증 스토어에서 취득.
const CURRENT_USER = '관리자';

// 표준시간 분류코드 — 실 구현 시 코드관리 마스터(ISYS_BASECODE 등)에 추가할 값
const TIME_CATEGORIES = [
  { code: 'ST', name: 'Standard Time' },
  { code: 'CT', name: 'Cycle Time' },
  { code: 'NT', name: 'Neck Time' },
  { code: 'TT', name: 'Takt Time' },
] as const;
type CategoryCode = (typeof TIME_CATEGORIES)[number]['code'];
const catName = (c: string) => TIME_CATEGORIES.find((x) => x.code === c)?.name ?? c;

// 모델선택 팝업용 샘플 모델 마스터 (Mock)
const SAMPLE_MODELS = [
  { modelCode: 'DN8-PE', modelName: 'DN8 PE 컨트롤러' },
  { modelCode: 'MV-PRA', modelName: 'MV PRA 모듈' },
  { modelCode: 'SM200', modelName: 'SM200 센서보드' },
  { modelCode: 'N91H00', modelName: 'N91 H00 하네스' },
  { modelCode: 'X9800', modelName: 'X9800 인버터' },
];

interface StdTimeLine {
  key: string;
  category: CategoryCode;
  timeSec: number;
  remark: string;
}
interface StdTimeRecord {
  id: number;
  modelCode: string;
  modelName: string;
  validFrom: string;
  validTo: string; // 개방형은 '9999-12-31'
  lines: StdTimeLine[];
  registeredBy: string;
  updatedAt: string; // YYYY-MM-DD HH:mm
}

const OPEN_END = '9999-12-31';

// 화면 검증용 샘플 데이터
const SEED: StdTimeRecord[] = [
  {
    id: 1,
    modelCode: 'DN8-PE',
    modelName: 'DN8 PE 컨트롤러',
    validFrom: '2026-07-01',
    validTo: OPEN_END,
    registeredBy: '김생기',
    updatedAt: '2026-07-01 09:20',
    lines: [
      { key: 'a', category: 'ST', timeSec: 13.5, remark: '' },
      { key: 'b', category: 'CT', timeSec: 12.0, remark: 'SMT 기준' },
      { key: 'c', category: 'TT', timeSec: 15.0, remark: '' },
    ],
  },
  {
    id: 2,
    modelCode: 'DN8-PE',
    modelName: 'DN8 PE 컨트롤러',
    validFrom: '2026-04-01',
    validTo: '2026-06-30',
    registeredBy: '김생기',
    updatedAt: '2026-04-01 10:05',
    lines: [
      { key: 'a', category: 'ST', timeSec: 14.0, remark: '' },
      { key: 'b', category: 'CT', timeSec: 12.6, remark: '' },
    ],
  },
  {
    id: 3,
    modelCode: 'MV-PRA',
    modelName: 'MV PRA 모듈',
    validFrom: '2026-07-01',
    validTo: OPEN_END,
    registeredBy: '박공정',
    updatedAt: '2026-07-09 14:41',
    lines: [
      { key: 'a', category: 'CT', timeSec: 11.4, remark: '' },
      { key: 'b', category: 'NT', timeSec: 18.2, remark: '병목 검사' },
    ],
  },
];

function nowStamp() {
  const d = new Date();
  const p = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`;
}
const periodText = (f: string, t: string) => `${f} ~ ${t === OPEN_END ? '현재 적용' : t}`;

let lineSeq = 0;
const newLine = (): StdTimeLine => ({ key: `l${++lineSeq}`, category: 'ST', timeSec: 0, remark: '' });

interface EditForm {
  id: number | null;
  modelCode: string;
  modelName: string;
  validFrom: string;
  validTo: string;
  lines: StdTimeLine[];
}
const emptyForm = (): EditForm => ({ id: null, modelCode: '', modelName: '', validFrom: '', validTo: OPEN_END, lines: [newLine()] });

export default function StandardTimeMasterPage() {
  const [records, setRecords] = useState<StdTimeRecord[]>(SEED);
  const [viewId, setViewId] = useState<number | null>(null);
  const [form, setForm] = useState<EditForm | null>(null);
  const [modelPickerOpen, setModelPickerOpen] = useState(false);

  const viewRec = useMemo(() => records.find((r) => r.id === viewId) ?? null, [records, viewId]);

  function openCreate() {
    lineSeq = 0;
    setForm(emptyForm());
  }
  function openEdit(r: StdTimeRecord) {
    setForm({
      id: r.id,
      modelCode: r.modelCode,
      modelName: r.modelName,
      validFrom: r.validFrom,
      validTo: r.validTo,
      lines: r.lines.map((l) => ({ ...l })),
    });
  }

  function save() {
    if (!form) return;
    if (!form.modelCode) return alert('모델을 선택하세요');
    if (!form.validFrom) return alert('적용 시작일을 입력하세요');
    if (!form.lines.length) return alert('표준시간 분류를 1건 이상 입력하세요');

    const stamp = nowStamp();
    if (form.id == null) {
      const id = Math.max(0, ...records.map((r) => r.id)) + 1;
      setRecords((prev) => [
        { id, modelCode: form.modelCode, modelName: form.modelName, validFrom: form.validFrom, validTo: form.validTo, lines: form.lines, registeredBy: CURRENT_USER, updatedAt: stamp },
        ...prev,
      ]);
    } else {
      setRecords((prev) =>
        prev.map((r) =>
          r.id === form.id ? { ...r, modelCode: form.modelCode, modelName: form.modelName, validFrom: form.validFrom, validTo: form.validTo, lines: form.lines, updatedAt: stamp } : r,
        ),
      );
    }
    setForm(null);
  }

  return (
    <div className="p-6 space-y-4">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-bold text-text">표준시간 관리</h1>
          <p className="text-sm text-text-muted mt-1">모델 기준 ST/CT/NT/TT 표준시간 · 적용기간 리비전 관리 (Mock-up)</p>
        </div>
        <button onClick={openCreate} className="bg-primary text-white px-4 py-2 rounded h-10">표준시간 등록</button>
      </div>

      {/* 목록 화면 */}
      <div className="border border-border rounded-lg overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="bg-surface text-text-muted">
              <th className="p-2 text-left">모델코드</th>
              <th className="p-2 text-left">모델명</th>
              <th className="p-2 text-left">표준시간</th>
              <th className="p-2 text-left">적용기간</th>
              <th className="p-2 text-left">등록자</th>
              <th className="p-2 text-left">최근업데이트일자</th>
              <th className="p-2"></th>
            </tr>
          </thead>
          <tbody>
            {records.map((r) => (
              <tr key={r.id} className="border-t border-border">
                <td className="p-2 font-mono">{r.modelCode}</td>
                <td className="p-2">{r.modelName}</td>
                <td className="p-2">
                  <button onClick={() => setViewId(r.id)} className="border border-border rounded px-2 py-1 text-primary hover:bg-surface">
                    확인 ({r.lines.length})
                  </button>
                </td>
                <td className="p-2">{periodText(r.validFrom, r.validTo)}</td>
                <td className="p-2">{r.registeredBy}</td>
                <td className="p-2 font-mono text-text-muted">{r.updatedAt}</td>
                <td className="p-2 text-right">
                  <button onClick={() => openEdit(r)} className="text-primary">편집</button>
                </td>
              </tr>
            ))}
            {!records.length && (
              <tr><td colSpan={7} className="p-4 text-center text-text-muted">등록된 표준시간이 없습니다</td></tr>
            )}
          </tbody>
        </table>
      </div>

      {/* 표준시간 확인 팝업 — 분류값 복수 출력 */}
      <Modal isOpen={!!viewRec} onClose={() => setViewId(null)} title={viewRec ? `표준시간 — ${viewRec.modelCode} ${viewRec.modelName}` : ''} size="lg">
        {viewRec && (
          <div className="space-y-3">
            <p className="text-sm text-text-muted">적용기간 {periodText(viewRec.validFrom, viewRec.validTo)} · 등록자 {viewRec.registeredBy}</p>
            <table className="w-full text-sm border border-border">
              <thead>
                <tr className="bg-surface text-text-muted">
                  <th className="p-2 text-left">분류</th>
                  <th className="p-2 text-left">분류명</th>
                  <th className="p-2 text-right">시간(초)</th>
                  <th className="p-2 text-left">비고</th>
                </tr>
              </thead>
              <tbody>
                {viewRec.lines.map((l) => (
                  <tr key={l.key} className="border-t border-border">
                    <td className="p-2 font-mono">{l.category}</td>
                    <td className="p-2">{catName(l.category)}</td>
                    <td className="p-2 text-right font-mono">{l.timeSec.toFixed(1)}</td>
                    <td className="p-2 text-text-muted">{l.remark || '-'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </Modal>

      {/* 등록/수정 화면 */}
      <Modal
        isOpen={!!form}
        onClose={() => setForm(null)}
        title={form?.id == null ? '표준시간 등록' : '표준시간 수정'}
        size="2xl"
        footer={
          <div className="flex justify-end gap-2">
            <button onClick={() => setForm(null)} className="px-3 py-2 rounded border border-border text-text-muted">취소</button>
            <button onClick={save} className="px-4 py-2 rounded bg-primary text-white">저장</button>
          </div>
        }
      >
        {form && (
          <div className="space-y-4">
            {/* 모델선택 */}
            <div className="flex items-end gap-2">
              <label className="text-sm text-text-muted flex flex-col gap-1">
                모델코드
                <input value={form.modelCode} readOnly placeholder="모델선택" className="border border-border rounded p-2 bg-surface text-text w-40" />
              </label>
              <label className="text-sm text-text-muted flex flex-col gap-1 flex-1">
                모델명
                <input value={form.modelName} readOnly className="border border-border rounded p-2 bg-surface text-text w-full" />
              </label>
              <button onClick={() => setModelPickerOpen(true)} className="border border-border rounded px-3 py-2 h-10 text-primary hover:bg-surface">모델선택</button>
            </div>

            {/* 적용기간 (리비전) */}
            <div className="flex items-end gap-3">
              <label className="text-sm text-text-muted flex flex-col gap-1">
                적용 시작일
                <input type="date" value={form.validFrom} onChange={(e) => setForm({ ...form, validFrom: e.target.value })} className="border border-border rounded p-2 bg-background text-text" />
              </label>
              <label className="text-sm text-text-muted flex flex-col gap-1">
                적용 종료일
                <input type="date" value={form.validTo === OPEN_END ? '' : form.validTo} placeholder="미지정=현재적용" onChange={(e) => setForm({ ...form, validTo: e.target.value || OPEN_END })} className="border border-border rounded p-2 bg-background text-text" />
              </label>
              <p className="text-xs text-text-muted pb-2">종료일 미입력 시 현재 적용(리비전 개방)</p>
            </div>

            {/* 표준시간 분류 그리드 — 행추가/행삭제, 복수 입력 */}
            <div>
              <div className="flex items-center justify-between mb-2">
                <span className="text-sm font-semibold text-text">표준시간 분류</span>
                <button onClick={() => setForm({ ...form, lines: [...form.lines, newLine()] })} className="text-sm border border-border rounded px-2 py-1 text-primary hover:bg-surface">행추가</button>
              </div>
              <table className="w-full text-sm border border-border">
                <thead>
                  <tr className="bg-surface text-text-muted">
                    <th className="p-2 text-left w-40">분류</th>
                    <th className="p-2 text-left w-32">시간(초)</th>
                    <th className="p-2 text-left">비고</th>
                    <th className="p-2 w-16"></th>
                  </tr>
                </thead>
                <tbody>
                  {form.lines.map((l, i) => (
                    <tr key={l.key} className="border-t border-border">
                      <td className="p-2">
                        <select
                          value={l.category}
                          onChange={(e) => setForm({ ...form, lines: form.lines.map((x, j) => (j === i ? { ...x, category: e.target.value as CategoryCode } : x)) })}
                          className="border border-border rounded p-1.5 bg-background text-text w-full"
                        >
                          {TIME_CATEGORIES.map((c) => (
                            <option key={c.code} value={c.code}>{c.code} — {c.name}</option>
                          ))}
                        </select>
                      </td>
                      <td className="p-2">
                        <input
                          type="number"
                          step="0.1"
                          value={l.timeSec}
                          onChange={(e) => setForm({ ...form, lines: form.lines.map((x, j) => (j === i ? { ...x, timeSec: Number(e.target.value) } : x)) })}
                          className="border border-border rounded p-1.5 bg-background text-text w-full text-right font-mono"
                        />
                      </td>
                      <td className="p-2">
                        <input
                          value={l.remark}
                          onChange={(e) => setForm({ ...form, lines: form.lines.map((x, j) => (j === i ? { ...x, remark: e.target.value } : x)) })}
                          className="border border-border rounded p-1.5 bg-background text-text w-full"
                        />
                      </td>
                      <td className="p-2 text-center">
                        <button onClick={() => setForm({ ...form, lines: form.lines.filter((_, j) => j !== i) })} className="text-red-500 text-sm">행삭제</button>
                      </td>
                    </tr>
                  ))}
                  {!form.lines.length && (
                    <tr><td colSpan={4} className="p-3 text-center text-text-muted">행추가로 분류를 입력하세요</td></tr>
                  )}
                </tbody>
              </table>
            </div>

            {/* 등록자/업데이트 — 자동 */}
            <div className="flex gap-6 text-sm text-text-muted">
              <span>등록자 <b className="text-text">{form.id == null ? CURRENT_USER : records.find((r) => r.id === form.id)?.registeredBy}</b> (로그인 사용자 자동)</span>
              <span>업데이트일시 <b className="text-text">저장 시 자동 기록</b></span>
            </div>
          </div>
        )}
      </Modal>

      {/* 모델선택 팝업 — 기존 마스터 참조, 단일 선택 */}
      <Modal isOpen={modelPickerOpen} onClose={() => setModelPickerOpen(false)} title="모델 선택" size="lg">
        <table className="w-full text-sm border border-border">
          <thead>
            <tr className="bg-surface text-text-muted">
              <th className="p-2 text-left">모델코드</th>
              <th className="p-2 text-left">모델명</th>
              <th className="p-2"></th>
            </tr>
          </thead>
          <tbody>
            {SAMPLE_MODELS.map((m) => (
              <tr key={m.modelCode} className="border-t border-border">
                <td className="p-2 font-mono">{m.modelCode}</td>
                <td className="p-2">{m.modelName}</td>
                <td className="p-2 text-right">
                  <button
                    onClick={() => { if (form) setForm({ ...form, modelCode: m.modelCode, modelName: m.modelName }); setModelPickerOpen(false); }}
                    className="text-primary"
                  >
                    선택
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </Modal>
    </div>
  );
}

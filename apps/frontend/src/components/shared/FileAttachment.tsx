'use client';

/**
 * @file src/components/shared/FileAttachment.tsx
 * @description 파일첨부 공통 컴포넌트 — 모든 등록/수정 화면에서 공통 적용하는 첨부 영역.
 *
 * 요구사항(공통 규격):
 *  1. 등록/수정 화면에 일정 영역을 사전 확보하여 출력 (minHeight 고정)
 *  2. 기본적으로 복수 파일 업로드 지원 (multiple=true)
 *  3. 첨부 파일을 파일명 목록으로 출력
 *  4. 서버 저장은 연도/업무구분 폴더 + BFILE (businessType로 폴더 결정)
 *  5. 첨부 영역 상단 우측에 [일괄 내려받기] · [일괄 삭제] 버튼
 *  6. 향후 모든 개발에서 공통 적용
 *
 * 동작 모드:
 *  - 기본(mock=false): 백엔드 API 연동
 *      업로드  POST   /files/upload?businessType=&refKey=  (multipart, field: files)
 *      다운로드 GET   /uploads/... (서버 정적)  또는 GET /files/:id
 *      삭제     DELETE /files { ids }
 *  - mock=true: 실 DB 미연결 화면용 — 브라우저 File 보유·클라이언트 다운로드만.
 */
import { useRef, useState } from 'react';
import { Paperclip, Download, Trash2, X, Upload, Loader2 } from 'lucide-react';
import { api } from '@/services/api';
import { resolveBackendFileUrl } from '@/utils/file-url';

export interface AttachedFile {
  id: string;
  name: string;
  size?: number;
  file?: File; // 신규(미업로드) 브라우저 File
  url?: string; // 서버 저장 파일 URL (/uploads/...)
}

export interface FileAttachmentProps {
  value: AttachedFile[];
  onChange: (files: AttachedFile[]) => void;
  /** 업무구분 — 서버 저장 연도/업무구분 폴더 경로에 사용 */
  businessType?: string;
  /** 소속 레코드 키 (예: 사유코드) */
  refKey?: string;
  label?: string;
  /** 복수 첨부 여부 (기본 true) */
  multiple?: boolean;
  readOnly?: boolean;
  /** 첨부 영역 최소 높이 — 사전 영역 확보 (기본 140px) */
  minHeight?: string;
  accept?: string;
  /** true면 백엔드 미연동(클라이언트 Mock) */
  mock?: boolean;
}

let seq = 0;
const uid = () => `att_${Date.now()}_${++seq}`;
const isBackendId = (id: string) => /^\d+$/.test(id);
const fmtSize = (n?: number) =>
  n == null ? '' : n < 1024 ? `${n}B` : n < 1048576 ? `${(n / 1024).toFixed(1)}KB` : `${(n / 1048576).toFixed(1)}MB`;

export default function FileAttachment({
  value,
  onChange,
  businessType,
  refKey,
  label = '첨부파일',
  multiple = true,
  readOnly = false,
  minHeight = '140px',
  accept,
  mock = false,
}: FileAttachmentProps) {
  const inputRef = useRef<HTMLInputElement>(null);
  const [busy, setBusy] = useState(false);

  async function addFiles(list: FileList | null) {
    if (!list || !list.length) return;
    const picked = Array.from(list);

    if (mock) {
      const added: AttachedFile[] = picked.map((f) => ({ id: uid(), name: f.name, size: f.size, file: f }));
      onChange(multiple ? [...value, ...added] : added.slice(0, 1));
      return;
    }

    // 백엔드 업로드
    setBusy(true);
    try {
      const fd = new FormData();
      picked.forEach((f) => fd.append('files', f));
      const qs = new URLSearchParams();
      if (businessType) qs.set('businessType', businessType);
      if (refKey) qs.set('refKey', refKey);
      const res = await api.post(`/files/upload?${qs.toString()}`, fd, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });
      const dtos = (res.data?.data ?? res.data ?? []) as Array<{ id: string; name: string; size: number | null; url: string }>;
      const added: AttachedFile[] = dtos.map((d) => ({ id: d.id, name: d.name, size: d.size ?? undefined, url: d.url }));
      onChange(multiple ? [...value, ...added] : added.slice(0, 1));
    } catch (e) {
      alert('파일 업로드에 실패했습니다.');
      console.error(e);
    } finally {
      setBusy(false);
    }
  }

  async function deleteBackend(ids: string[]) {
    const nums = ids.filter(isBackendId).map(Number);
    if (!nums.length || mock) return;
    await api.delete('/files', { data: { ids: nums } }).catch((e) => {
      console.error(e);
    });
  }

  async function removeOne(f: AttachedFile) {
    await deleteBackend([f.id]);
    onChange(value.filter((x) => x.id !== f.id));
  }
  async function clearAll() {
    if (!value.length) return;
    if (!confirm('첨부파일을 모두 삭제할까요?')) return;
    await deleteBackend(value.map((f) => f.id));
    onChange([]);
  }
  function downloadOne(f: AttachedFile) {
    let href = '';
    const isBlob = !!f.file;
    if (f.file) href = URL.createObjectURL(f.file);
    else if (f.url) href = resolveBackendFileUrl(f.url) || f.url;
    if (!href) return;
    const a = document.createElement('a');
    a.href = href;
    a.download = f.name;
    document.body.appendChild(a);
    a.click();
    a.remove();
    if (isBlob) setTimeout(() => URL.revokeObjectURL(href), 1000);
  }
  function downloadAll() {
    value.forEach(downloadOne);
  }

  return (
    <div>
      {/* 상단: 라벨 + 우측 일괄 버튼 */}
      <div className="flex items-center justify-between mb-1">
        <span className="text-sm text-text-muted">
          {label}
          {businessType && <span className="ml-1 text-xs text-text-muted">({businessType})</span>}
        </span>
        {!readOnly && (
          <div className="flex items-center gap-1">
            <button
              type="button"
              onClick={downloadAll}
              disabled={!value.length}
              className="text-xs border border-border rounded px-2 py-1 text-text-muted hover:bg-surface disabled:opacity-40 inline-flex items-center gap-1"
            >
              <Download className="w-3 h-3" />일괄 내려받기
            </button>
            <button
              type="button"
              onClick={clearAll}
              disabled={!value.length}
              className="text-xs border border-border rounded px-2 py-1 text-red-500 hover:bg-surface disabled:opacity-40 inline-flex items-center gap-1"
            >
              <Trash2 className="w-3 h-3" />일괄 삭제
            </button>
          </div>
        )}
      </div>

      {/* 사전 확보 영역 (고정 높이) */}
      <div
        className="border border-dashed border-border rounded bg-background p-2 overflow-y-auto"
        style={{ minHeight }}
        onDragOver={(e) => e.preventDefault()}
        onDrop={(e) => {
          e.preventDefault();
          if (!readOnly && !busy) addFiles(e.dataTransfer.files);
        }}
      >
        {!readOnly && (
          <button
            type="button"
            onClick={() => inputRef.current?.click()}
            disabled={busy}
            className="w-full border border-border rounded px-3 py-2 text-primary hover:bg-surface inline-flex items-center justify-center gap-1 text-sm mb-2 disabled:opacity-50"
          >
            {busy ? <Loader2 className="w-4 h-4 animate-spin" /> : <Upload className="w-4 h-4" />}
            {busy ? '업로드 중…' : `파일 선택 ${multiple ? '(복수 가능)' : ''}`}
          </button>
        )}
        <input
          ref={inputRef}
          type="file"
          multiple={multiple}
          accept={accept}
          className="hidden"
          onChange={(e) => {
            addFiles(e.target.files);
            e.target.value = '';
          }}
        />

        {value.length === 0 ? (
          <div className="text-center text-text-muted text-xs py-4">
            첨부된 파일이 없습니다{!readOnly && ' · 파일을 끌어다 놓거나 선택하세요'}
          </div>
        ) : (
          <ul className="space-y-1">
            {value.map((f) => (
              <li key={f.id} className="flex items-center gap-2 text-sm bg-surface border border-border rounded px-2 py-1">
                <Paperclip className="w-3.5 h-3.5 text-text-muted flex-shrink-0" />
                <span className="truncate flex-1 text-text">{f.name}</span>
                <span className="text-xs text-text-muted flex-shrink-0">{fmtSize(f.size)}</span>
                <button type="button" onClick={() => downloadOne(f)} className="text-primary flex-shrink-0" title="내려받기">
                  <Download className="w-3.5 h-3.5" />
                </button>
                {!readOnly && (
                  <button type="button" onClick={() => removeOne(f)} className="text-red-500 flex-shrink-0" title="삭제">
                    <X className="w-3.5 h-3.5" />
                  </button>
                )}
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
}

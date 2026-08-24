"use client";

import { useState } from "react";
import * as XLSX from "xlsx";
import { Upload } from "lucide-react";
import { Button, Modal } from "@/components/ui";
import { DepartmentSelect } from "@/components/shared";
import api from "@/services/api";
import type { ProcessUploadResult } from "../types";

const REQUIRED = ["공정코드", "공정명", "공정유형", "시작공정구분", "적용라인코드"];

export default function ProcessUploadModal({ isOpen, onClose, onComplete }: { isOpen: boolean; onClose: () => void; onComplete: () => void }) {
  const [file, setFile] = useState<File | null>(null);
  const [departmentCode, setDepartmentCode] = useState("");
  const [summary, setSummary] = useState("");
  const [result, setResult] = useState<ProcessUploadResult | null>(null);
  const [error, setError] = useState("");
  const [uploading, setUploading] = useState(false);

  const inspect = async (next: File) => {
    setFile(next); setResult(null); setError("");
    try {
      const book = XLSX.read(await next.arrayBuffer());
      const sheet = book.Sheets["공정마스터"];
      if (!sheet) throw new Error("공정마스터 시트가 없습니다.");
      const rows = XLSX.utils.sheet_to_json<unknown[]>(sheet, { header: 1, defval: "" });
      const header = (rows[0] ?? []).map(String);
      const missing = REQUIRED.filter((item) => !header.includes(item));
      if (missing.length) throw new Error(`필수 헤더 누락: ${missing.join(", ")}`);
      setSummary(`헤더 정상 · 데이터 ${Math.max(rows.length - 1, 0)}행`);
    } catch (caught: unknown) { setFile(null); setSummary(""); setError(caught instanceof Error ? caught.message : "파일을 읽을 수 없습니다."); }
  };

  const upload = async () => {
    if (!file || !departmentCode) return;
    setUploading(true); setError("");
    try {
      const body = new FormData(); body.append("file", file); body.append("departmentCode", departmentCode);
      const response = await api.post("/master/processes/upload", body, { headers: { "Content-Type": "multipart/form-data" } });
      setResult(response.data.data); onComplete(); onClose();
    } catch (caught: unknown) {
      const message = (caught as { response?: { data?: { message?: string } } }).response?.data?.message;
      setError(message ?? "업로드에 실패했습니다.");
    } finally { setUploading(false); }
  };

  return <Modal isOpen={isOpen} onClose={onClose} title="공정 엑셀 업로드" footer={<><Button variant="secondary" onClick={onClose}>취소</Button><Button onClick={upload} disabled={!file || !departmentCode || uploading}><Upload className="w-4 h-4 mr-1" />업로드</Button></>}>
    <div className="space-y-4">
      <DepartmentSelect label="부서" value={departmentCode} onChange={setDepartmentCode} fullWidth />
      <label className="block border-2 border-dashed border-border rounded-lg p-8 text-center cursor-pointer" onDragOver={(event) => event.preventDefault()} onDrop={(event) => { event.preventDefault(); const next = event.dataTransfer.files[0]; if (next) void inspect(next); }}>
        <input type="file" accept=".xlsx" className="hidden" onChange={(event) => { const next = event.target.files?.[0]; if (next) void inspect(next); }} />
        {file ? file.name : ".xlsx 파일을 드래그하거나 선택하세요"}
      </label>
      {summary && <p className="text-sm text-emerald-600">{summary}</p>}
      {error && <p className="text-sm text-red-600">{error}</p>}
      {result && <p className="text-sm">공정 {result.processesCreated}건 · 적용라인 {result.relationsCreated}건 · 중복제거 {result.duplicateRows}건</p>}
    </div>
  </Modal>;
}

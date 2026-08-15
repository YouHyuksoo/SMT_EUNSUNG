'use client';

/**
 * @file (authenticated)/oee/equip-downtime-mobile/page.tsx
 * @description 설비비가동 관리(모바일) — IMCN_MACHINE 설비 식별
 *
 * 태블릿(아이패드/갤럭시탭 11") 세로 우선 · 가로 대응.
 * 스캔: getUserMedia + BarcodeDetector(네이티브). 미지원 시 설비코드 수동입력/샘플 스캔 폴백.
 * 비가동 처리 로직은 설비별 작업 실적관리의 설비비가동 패널과 동일.
 */
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { Camera, ScanLine, RefreshCw, CheckCircle2 } from 'lucide-react';
import toast from 'react-hot-toast';
import api from '@/services/api';

const CURRENT_USER = '관리자';

interface MachineRef { machineCode: string; machineName: string; lineCode: string; lineName: string; processCode: string; processName: string; }

// 정지(비가동) 사유코드 — 설비 비가동 사유코드 (코드·사유명·사유구분)
const STOP_REASONS = [
  { code: 'DWN-CHG', name: '모델 교체', type: '계획' },
  { code: 'DWN-MAT', name: '자재 대기', type: '비계획' },
  { code: 'DWN-BRK', name: '설비 고장', type: '비계획' },
  { code: 'DWN-CLN', name: '청소/5S', type: '계획' },
];

function nowLocal() {
  const d = new Date();
  const p = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}T${p(d.getHours())}:${p(d.getMinutes())}:${p(d.getSeconds())}`;
}

interface DowntimeState {
  status: 'RUNNING' | 'STOPPED'; savedStatus: 'RUNNING' | 'STOPPED'; initialStatus: 'RUNNING' | 'STOPPED';
  stopAt: string; stopReasonCode: string; stopMemo: string; stopWorker: string; stopBy: string;
  resumeAt: string; resumeBy: string;
}
const initDowntime = (): DowntimeState => ({
  status: 'RUNNING', savedStatus: 'RUNNING', initialStatus: 'RUNNING',
  stopAt: '', stopReasonCode: '', stopMemo: '', stopWorker: '', stopBy: '', resumeAt: '', resumeBy: '',
});

// BarcodeDetector 최소 타입 (TS lib 미포함)
type BarcodeDetectorLike = { detect: (src: CanvasImageSource) => Promise<{ rawValue: string }[]> };
interface BarcodeDetectorCtor { new (opts?: { formats?: string[] }): BarcodeDetectorLike; }

export default function EquipDowntimeMobilePage() {
  const [machine, setMachine] = useState<MachineRef | null>(null);
  const [downtime, setDowntime] = useState<DowntimeState | null>(null);
  const [manualCode, setManualCode] = useState('');
  const [scanErr, setScanErr] = useState('');
  const [cameraOn, setCameraOn] = useState(false);

  const videoRef = useRef<HTMLVideoElement | null>(null);
  const streamRef = useRef<MediaStream | null>(null);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);

  // 마운트 후 판정 (SSR/CSR 불일치 방지 위해 초기값 true)
  const [barcodeSupported, setBarcodeSupported] = useState(true);

  const stopCamera = useCallback(() => {
    if (timerRef.current) { clearInterval(timerRef.current); timerRef.current = null; }
    if (streamRef.current) { streamRef.current.getTracks().forEach((t) => t.stop()); streamRef.current = null; }
    setCameraOn(false);
  }, []);

  const onScanned = useCallback(async (code: string) => {
    const normalized = code.trim();
    if (!normalized) { setScanErr('설비코드를 입력하세요.'); return; }
    try {
      const response = await api.get(`/equipment/equips/code/${encodeURIComponent(normalized)}`);
      const row = response.data?.data ?? response.data;
      const m: MachineRef = {
        machineCode: row.equipCode,
        machineName: row.equipName,
        lineCode: row.lineCode ?? '',
        lineName: row.lineName ?? '미매핑',
        processCode: row.processCode ?? '',
        processName: row.processName ?? '미매핑',
      };
      setScanErr('');
      setMachine(m);
      setDowntime(initDowntime());
      stopCamera();
    } catch (error: unknown) {
      setScanErr(`설비코드 '${normalized}'를 IMCN_MACHINE에서 찾을 수 없습니다.`);
    }
  }, [stopCamera]);

  const startCamera = useCallback(async () => {
    setScanErr('');
    if (!navigator.mediaDevices?.getUserMedia) { setScanErr('이 기기/브라우저는 카메라를 지원하지 않습니다. 수동 입력을 사용하세요.'); return; }
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } });
      streamRef.current = stream;
      if (videoRef.current) { videoRef.current.srcObject = stream; await videoRef.current.play().catch(() => {}); }
      setCameraOn(true);
      const Ctor = (window as unknown as { BarcodeDetector?: BarcodeDetectorCtor }).BarcodeDetector;
      if (Ctor) {
        const detector = new Ctor({ formats: ['qr_code', 'code_128', 'ean_13', 'code_39', 'data_matrix'] });
        timerRef.current = setInterval(async () => {
          if (!videoRef.current) return;
          try {
            const codes = await detector.detect(videoRef.current);
            if (codes.length && codes[0].rawValue) onScanned(codes[0].rawValue);
          } catch { /* 프레임 미준비 등 무시 */ }
        }, 400);
      } else {
        setScanErr('바코드 인식(BarcodeDetector) 미지원 브라우저입니다. 수동 입력을 사용하세요.');
      }
    } catch {
      setScanErr('카메라를 열 수 없습니다(권한/기기 확인). 수동 입력을 사용하세요.');
    }
  }, [onScanned]);

  // 진입 시 지원여부 판정 + 카메라 자동 시도, 언마운트 시 정리
  useEffect(() => {
    setBarcodeSupported('BarcodeDetector' in window);
    startCamera();
    return () => stopCamera();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  function rescan() {
    setMachine(null); setDowntime(null); setManualCode(''); setScanErr('');
    startCamera();
  }

  // 파생: 토글 표시 규칙
  const dtToggled = !!downtime && downtime.status !== downtime.savedStatus;
  const dtLabelStop = downtime ? (dtToggled ? downtime.status === 'STOPPED' : downtime.status === 'RUNNING') : false;

  function toggleDowntime() {
    setDowntime((d) => {
      if (!d || d.status !== d.savedStatus) return d; // 저장 전까지 최초 토글값 유지(잠금)
      return d.status === 'RUNNING'
        ? { ...d, status: 'STOPPED', stopAt: nowLocal(), stopBy: CURRENT_USER, resumeAt: '', resumeBy: '' }
        : { ...d, status: 'RUNNING', resumeAt: nowLocal(), resumeBy: CURRENT_USER };
    });
  }
  function saveDowntime() {
    if (!downtime) return;
    setDowntime({ ...downtime, savedStatus: downtime.status });
    toast.success('설비 가동상태가 저장되었습니다');
  }

  const inputCls = 'border border-border rounded-lg p-3 bg-background text-text text-base w-full';

  return (
    <div className="h-full overflow-y-auto p-4">
      <div className="mx-auto w-full max-w-md landscape:max-w-5xl">
        <div className="mb-4">
          <h1 className="text-xl font-bold text-text flex items-center gap-2"><ScanLine className="w-6 h-6 text-primary" /> 설비비가동 관리 (모바일)</h1>
          <p className="text-sm text-text-muted mt-1">IMCN_MACHINE 설비코드를 스캔하거나 입력합니다.</p>
        </div>

        <div className="flex flex-col gap-4 landscape:grid landscape:grid-cols-2 landscape:gap-6 landscape:items-start">
          {/* 스캔 영역 */}
          <section className="border border-border rounded-xl p-4 bg-surface">
            <div className="flex items-center justify-between mb-3">
              <span className="font-semibold text-text flex items-center gap-2"><Camera className="w-5 h-5 text-primary" /> 설비 스캔</span>
              {machine && <button onClick={rescan} className="flex items-center gap-1 text-sm text-primary border border-primary rounded-lg px-3 py-1.5"><RefreshCw className="w-4 h-4" />재스캔</button>}
            </div>

            {!machine ? (
              <>
                {/* 카메라 프리뷰 */}
                <div className="relative w-full aspect-square max-h-[52vh] rounded-lg overflow-hidden bg-black flex items-center justify-center">
                  <video ref={videoRef} playsInline muted className="w-full h-full object-cover" />
                  {!cameraOn && <div className="absolute inset-0 flex flex-col items-center justify-center text-white/70 text-sm gap-2"><Camera className="w-10 h-10" />카메라 준비 중…</div>}
                  {cameraOn && <div className="absolute inset-8 border-2 border-primary/80 rounded-lg pointer-events-none" />}
                </div>
                {scanErr && <p className="text-sm text-red-500 mt-2">{scanErr}</p>}
                {!cameraOn && <button onClick={startCamera} className="mt-3 w-full py-3 rounded-lg bg-primary text-white font-semibold text-base flex items-center justify-center gap-2"><Camera className="w-5 h-5" />카메라 스캔 시작</button>}

                {/* 수동입력 폴백 */}
                <div className="mt-4 border-t border-border pt-4">
                  <label className="text-sm text-text-muted flex flex-col gap-1">설비코드 수동 입력
                    <div className="flex gap-2">
                      <input value={manualCode} onChange={(e) => setManualCode(e.target.value)} placeholder="설비코드" className={inputCls} onKeyDown={(e) => { if (e.key === 'Enter') void onScanned(manualCode); }} />
                      <button onClick={() => onScanned(manualCode)} className="px-4 rounded-lg border border-primary text-primary font-semibold whitespace-nowrap">조회</button>
                    </div>
                  </label>
                   {!barcodeSupported && <p className="text-[11px] text-amber-600 mt-2">※ 이 브라우저는 바코드 자동인식 미지원 — 수동 입력을 사용하세요.</p>}
                </div>
              </>
            ) : (
              /* 스캔된 설비 정보 */
              <div className="rounded-lg border border-emerald-300 bg-emerald-500/5 p-3">
                <div className="flex items-center gap-2 text-emerald-600 font-semibold mb-2"><CheckCircle2 className="w-5 h-5" />설비 인식 완료</div>
                <div className="grid grid-cols-2 gap-x-4 gap-y-2 text-sm">
                  <div className="flex flex-col"><span className="text-[11px] text-text-muted">설비코드</span><span className="text-text font-mono">{machine.machineCode}</span></div>
                  <div className="flex flex-col"><span className="text-[11px] text-text-muted">설비명</span><span className="text-text">{machine.machineName}</span></div>
                  <div className="flex flex-col"><span className="text-[11px] text-text-muted">라인코드</span><span className="text-text font-mono">{machine.lineCode}</span></div>
                  <div className="flex flex-col"><span className="text-[11px] text-text-muted">라인명</span><span className="text-text">{machine.lineName}</span></div>
                  <div className="flex flex-col"><span className="text-[11px] text-text-muted">공정코드</span><span className="text-text font-mono">{machine.processCode || '—'}</span></div>
                  <div className="flex flex-col"><span className="text-[11px] text-text-muted">공정명</span><span className="text-text">{machine.processName}</span></div>
                </div>
              </div>
            )}
          </section>

          {/* 비가동 처리 영역 (스캔 후) */}
          {machine && downtime && (
            <section className="border border-border rounded-xl p-4 bg-surface flex flex-col gap-4">
              <div className="flex items-center justify-between">
                <span className="font-semibold text-text">설비 가동 상태</span>
                <button onClick={saveDowntime} className="px-5 py-2 rounded-lg bg-primary text-white font-semibold">저장</button>
              </div>

              <div className="text-sm text-text-muted">현재 상태: <b className={downtime.initialStatus === 'RUNNING' ? 'text-emerald-600' : 'text-red-600'}>{downtime.initialStatus === 'RUNNING' ? '정상가동' : '정지(비가동)'}</b>{dtToggled && <span className="text-amber-600"> · 전환 대기(미저장)</span>}</div>
              <button onClick={toggleDowntime} disabled={dtToggled}
                className={`w-full py-6 rounded-xl text-2xl font-bold text-white ${dtLabelStop ? 'bg-red-500' : 'bg-emerald-500'} ${dtToggled ? 'opacity-60' : 'active:scale-[0.99]'}`}>
                {dtLabelStop ? '■ 정지' : '● 정상'}
                <span className="block text-sm font-normal opacity-90 mt-1">{dtToggled ? '선택된 상태 · 저장 전까지 유지' : (downtime.status === 'RUNNING' ? '탭하면 비가동 시작 · 시작일시 기록' : '탭하면 비가동 종료 · 종료일시 기록')}</span>
              </button>
              {dtToggled && <p className="text-xs text-amber-600 -mt-2">전환 값은 저장 전까지 유지됩니다. 저장하면 다시 전환할 수 있습니다.</p>}

              {/* 시작일시 + 처리담당자(정지) */}
              {downtime.stopAt && (
                <div className="border border-red-300 rounded-lg p-3 space-y-2 bg-red-500/5">
                  <label className="text-sm text-text-muted flex flex-col gap-1">시작일시 (비가동 시작)
                    <input type="datetime-local" step={1} value={downtime.stopAt} onChange={(e) => setDowntime({ ...downtime, stopAt: e.target.value })} className={inputCls} />
                  </label>
                  <div className="text-sm text-text-muted">처리담당자(정지) <b className="text-text">{downtime.stopBy || CURRENT_USER}</b> (자동)</div>
                </div>
              )}

              {/* 정지 사유 그리드 + 상세 + 작업자 */}
              {downtime.status === 'STOPPED' && (
                <div className="space-y-3">
                  <div className="flex flex-col gap-1">
                    <span className="text-sm text-text-muted">정지 사유 <span className="text-red-500">*</span></span>
                    <div className="border border-border rounded-lg overflow-hidden bg-background">
                      <div className="flex bg-surface text-text-muted text-xs font-semibold">
                        <div className="flex-1 p-2">비가동 사유</div>
                        <div className="w-20 p-2 text-center">사유구분</div>
                        <div className="w-20 p-2 text-center">선택</div>
                      </div>
                      {STOP_REASONS.map((r) => {
                        const sel = downtime.stopReasonCode === r.code;
                        return (
                          <div key={r.code} className={`flex items-center text-sm border-t border-border ${sel ? 'ring-2 ring-inset ring-primary bg-primary/10' : ''}`}>
                            <div className="flex-1 p-2.5"><span className="font-mono">{r.code}</span> · {r.name}</div>
                            <div className="w-20 p-2.5 text-center">{r.type}</div>
                            <div className="w-20 p-2 text-center">
                              <button onClick={() => setDowntime({ ...downtime, stopReasonCode: r.code })} className={`px-3 py-1 rounded text-xs ${sel ? 'bg-primary text-white' : 'border border-primary text-primary'}`}>{sel ? '선택됨' : '선택'}</button>
                            </div>
                          </div>
                        );
                      })}
                    </div>
                  </div>
                  <label className="text-sm text-text-muted flex flex-col gap-1">비가동 사유(상세)
                    <textarea rows={2} value={downtime.stopMemo} onChange={(e) => setDowntime({ ...downtime, stopMemo: e.target.value })} className={`${inputCls} resize-none`} />
                  </label>
                  <label className="text-sm text-text-muted flex flex-col gap-1">작업자
                    <input value={downtime.stopWorker} onChange={(e) => setDowntime({ ...downtime, stopWorker: e.target.value })} className={inputCls} />
                  </label>
                </div>
              )}

              {/* 종료일시 + 처리담당자(정상전환) */}
              {downtime.resumeAt && (
                <div className="border border-emerald-300 rounded-lg p-3 space-y-2 bg-emerald-500/5">
                  <label className="text-sm text-text-muted flex flex-col gap-1">종료일시 (비가동 종료)
                    <input type="datetime-local" step={1} value={downtime.resumeAt} onChange={(e) => setDowntime({ ...downtime, resumeAt: e.target.value })} className={inputCls} />
                  </label>
                  <div className="text-sm text-text-muted">처리담당자(정상전환) <b className="text-text">{downtime.resumeBy || CURRENT_USER}</b> (자동)</div>
                </div>
              )}

              <p className="text-[11px] text-text-muted">정지 탭 시 시작일시, 정상 탭 시 종료일시와 처리담당자가 자동 기록됩니다 (Mock-up).</p>
            </section>
          )}
        </div>
      </div>
    </div>
  );
}

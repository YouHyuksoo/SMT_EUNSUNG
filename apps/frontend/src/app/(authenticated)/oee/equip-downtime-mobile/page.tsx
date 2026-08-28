'use client';

/**
 * @file (authenticated)/oee/equip-downtime-mobile/page.tsx
 * @description 설비 조회(모바일) — IMCN_MACHINE 설비 식별
 *
 * 태블릿(아이패드/갤럭시탭 11") 세로 우선 · 가로 대응.
 * 스캔: getUserMedia + BarcodeDetector(네이티브). 미지원 시 설비코드 수동입력/샘플 스캔 폴백.
 */
import { useCallback, useEffect, useRef, useState } from 'react';
import { Camera, ScanLine, RefreshCw, CheckCircle2 } from 'lucide-react';
import api from '@/services/api';

interface MachineRef { machineCode: string; machineName: string; lineCode: string; lineName: string; processCode: string; processName: string; }

// BarcodeDetector 최소 타입 (TS lib 미포함)
type BarcodeDetectorLike = { detect: (src: CanvasImageSource) => Promise<{ rawValue: string }[]> };
interface BarcodeDetectorCtor { new (opts?: { formats?: string[] }): BarcodeDetectorLike; }

export default function EquipDowntimeMobilePage() {
  const [machine, setMachine] = useState<MachineRef | null>(null);
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
    setMachine(null); setManualCode(''); setScanErr('');
    startCamera();
  }

  const inputCls = 'border border-border rounded-lg p-3 bg-background text-text text-base w-full';

  return (
    <div className="h-full overflow-y-auto p-4">
      <div className="mx-auto w-full max-w-md landscape:max-w-3xl">
        <div className="mb-4">
          <h1 className="text-xl font-bold text-text flex items-center gap-2"><ScanLine className="w-6 h-6 text-primary" /> 설비 조회 (모바일)</h1>
          <p className="text-sm text-text-muted mt-1">IMCN_MACHINE 설비코드를 스캔하거나 입력해 설비 정보를 조회합니다.</p>
          <p role="note" className="mt-3 rounded-lg border border-amber-300 bg-amber-500/10 px-3 py-2 text-sm text-amber-700">조회 전용: 이 화면은 설비 정보만 조회하며, 비가동 상태를 변경하거나 저장하지 않습니다.</p>
        </div>

        <div className="flex flex-col gap-4">
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
              /* 조회된 설비 정보 */
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

        </div>
      </div>
    </div>
  );
}

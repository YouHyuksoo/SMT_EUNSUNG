"use client";

/**
 * @file production/run-card/components/LotCardSheets.tsx
 * @description 출력물 세 가지 — 롯트카드(A4), 출고계획(A4), PID 라벨(9×12mm)
 *
 * 초보자 가이드:
 * 1. 배치와 항목은 PB 데이터윈도를 따른다:
 *    롯트카드 d_plan_pcm_run_card_all_rpt_qr · 출고계획 d_ip_product_run_issue_plan_summary ·
 *    PID 라벨 d_pcb_label_qr_with_item_code_report.
 * 2. 종이는 늘 흰 바탕·검은 글씨다 — 다크 모드여도 출력물 색은 바꾸지 않는다.
 * 3. 롯트카드 PB 출력의 모델 부품 사진(로컬 폴더의 <모델>.JPG)은 옮기지 않았다. 서버에 사진이 없다.
 */
import BarcodeImg from './BarcodeImg';

export interface LotCardPrintRow {
  runNo: string; runDate: string; modelName: string; groupModelName: string | null;
  groupItemCode: string | null; groupModelSpec: string | null; lineCode: string; lotSize: number;
  productRunType: string | null; comments: string | null; metalMaskCode: string | null;
  metalMaskAddress: string | null; sampleCode: string | null; sampleAddress: string | null;
  itemCode: string; lotNo: string | null; markingNo: string | null; masterModelName: string | null;
  mfsGroupNo: string | null; customerCode: string | null; serialRange: string | null;
  pcbWeek: string | null; pcbItem: string | null; solderType: string | null;
  smtModelName: string | null; serialFixval: string | null;
}

export interface IssuePlanRow {
  itemCode: string; itemName: string | null; partNo: string | null; itemSpec: string | null;
  locationAddress: string | null; pcbItem: string | null; runDate: string;
  inputQty: number; materialQty: number; reelQty: number | null;
}

export interface PidRow { serialNo: string; labelText: string | null; itemCode: string | null }

const paper: React.CSSProperties = {
  width: '210mm', minHeight: '297mm', padding: '10mm', boxSizing: 'border-box',
  background: '#fff', color: '#000', fontFamily: 'Tahoma, Arial, sans-serif',
  boxShadow: '0 1px 4px rgba(0,0,0,.25)',
};
const cell = 'border border-black px-2 py-1 align-middle';
const label = `${cell} bg-neutral-100 text-[10px] font-semibold whitespace-nowrap`;
const fmt = (n: number | null | undefined) => (n == null ? '' : Number(n).toLocaleString());

/** 롯트카드 — 롯트카드 한 장에 대표모델이 같은 모델이 여러 줄로 붙는다 */
export function RunCardSheets({ rows }: { rows: LotCardPrintRow[] }) {
  const cards = new Map<string, LotCardPrintRow[]>();
  for (const row of rows) cards.set(row.runNo, [...(cards.get(row.runNo) ?? []), row]);
  const today = new Date().toLocaleDateString('ko-KR');
  const total = cards.size;

  return (
    <>
      {[...cards.values()].map((group, page) => {
        const r = group[0];
        return (
          <div key={r.runNo} className="print-page" style={paper}>
            <table className="w-full border-collapse text-[11px]">
              <tbody>
                <tr>
                  <td className={`${cell} w-[22%] text-center text-2xl font-bold`}>{r.lineCode}</td>
                  <td className={`${cell} text-center text-2xl font-bold`} colSpan={2}>Product Run Card</td>
                  <td className={`${cell} w-[18%] text-center text-2xl font-bold`}>{r.customerCode}</td>
                  <td className={`${cell} w-[12%] text-center text-2xl font-bold`}>{r.productRunType}</td>
                </tr>
                <tr>
                  <td className={`${cell} text-center text-lg font-bold`}>{r.solderType}</td>
                  <td className={`${cell} text-center`} colSpan={3}>
                    <div className="text-base font-bold">{r.modelName}</div>
                    <BarcodeImg value={r.modelName} kind="code128" className="mx-auto mt-1 h-[11mm]" />
                  </td>
                  <td className={`${cell} text-center text-lg font-bold`}>{r.pcbItem}</td>
                </tr>
                <tr>
                  <td className={label}>Run No</td>
                  <td className={`${cell} text-sm font-semibold`}>{r.runNo}</td>
                  <td className={`${cell} text-center`} colSpan={2}>
                    <BarcodeImg value={r.runNo} kind="code39" className="mx-auto h-[9mm]" />
                  </td>
                  <td className={`${cell} text-center`} rowSpan={4}>
                    <div className="text-[10px]">Lot Size</div>
                    <div className="text-2xl font-bold">{fmt(r.lotSize)}</div>
                  </td>
                </tr>
                <tr>
                  <td className={label}>MFS Group No</td>
                  <td className={cell}>{r.mfsGroupNo}</td>
                  <td className={label}>Run Date</td>
                  <td className={cell}>{r.runDate}</td>
                </tr>
                <tr>
                  <td className={label}>Master Model Name</td>
                  <td className={cell}>{r.masterModelName}</td>
                  <td className={label}>SMT Model Name</td>
                  <td className={cell}>{r.smtModelName}</td>
                </tr>
                <tr>
                  <td className={label}>PCB Week</td>
                  <td className={cell} colSpan={3}>{r.pcbWeek}</td>
                </tr>
              </tbody>
            </table>

            <table className="mt-3 w-full border-collapse text-[11px]">
              <tbody>
                <tr>
                  <td className={`${label} w-[22%] text-center`}>Line Code</td>
                  <td className={`${label} w-[14%]`}>Serial No</td>
                  <td className={cell} colSpan={3}>{r.serialRange}</td>
                </tr>
                <tr>
                  <td className={`${cell} text-center`} rowSpan={2}>
                    <BarcodeImg value={r.lineCode} kind="code39" className="mx-auto h-[10mm]" />
                    <div className="text-xs">{r.lineCode}</div>
                  </td>
                  <td className={label}>Lot No</td>
                  <td className={cell}>{r.lotNo}</td>
                  <td className={`${cell} w-[22mm] text-center`} rowSpan={2}>
                    <BarcodeImg value={r.serialFixval} kind="qrcode" className="mx-auto h-[18mm] w-[18mm]" />
                  </td>
                  <td className={`${cell} text-[10px]`} rowSpan={2}>
                    <div className="font-semibold">QR BARCODE</div>
                    <div className="break-all">{r.serialFixval}</div>
                  </td>
                </tr>
                <tr>
                  <td className={label}>Marking No</td>
                  <td className={cell}>{r.markingNo}</td>
                </tr>
              </tbody>
            </table>

            <table className="mt-3 w-full border-collapse text-[11px]">
              <tbody>
                <tr>
                  <td className={`${label} w-[18%]`}>MetalMask Jig</td>
                  <td className={`${cell} w-[32%] whitespace-pre-wrap`}>{r.metalMaskCode}</td>
                  <td className={`${label} w-[18%]`}>Sample Jig Code</td>
                  <td className={`${cell} whitespace-pre-wrap`}>{r.sampleCode}</td>
                </tr>
                <tr>
                  <td className={label}>Address</td>
                  <td className={cell}>{r.metalMaskAddress}</td>
                  <td className={label}>Address</td>
                  <td className={cell}>{r.sampleAddress}</td>
                </tr>
              </tbody>
            </table>

            <table className="mt-3 w-full border-collapse text-[11px]">
              <thead>
                <tr>
                  <th className={`${label} w-8`}>#</th>
                  <th className={label}>Model Name</th>
                  <th className={label}>Item Code</th>
                  <th className={label}>Model Spec</th>
                </tr>
              </thead>
              <tbody>
                {group.filter((g) => g.groupModelName).map((g, i) => (
                  <tr key={`${g.groupModelName}-${i}`}>
                    <td className={`${cell} text-center`}>{i + 1}</td>
                    <td className={cell}>{g.groupModelName}</td>
                    <td className={cell}>{g.groupItemCode}</td>
                    <td className={cell}>{g.groupModelSpec}</td>
                  </tr>
                ))}
              </tbody>
            </table>

            <table className="mt-3 w-full border-collapse text-[11px]">
              <tbody>
                <tr>
                  <td className={`${label} w-[18%]`}>Comments</td>
                  <td className={`${cell} h-[14mm] whitespace-pre-wrap`}>{r.comments}</td>
                </tr>
              </tbody>
            </table>

            <div className="mt-2 flex justify-between text-[10px]">
              <span>Page {page + 1} of {total}</span>
              <span>{today}</span>
            </div>
          </div>
        );
      })}
    </>
  );
}

/** 출고계획 — 롯트카드 투입 자재 합계. 지시일마다 한 장 */
export function IssuePlanSheets({ rows }: { rows: IssuePlanRow[] }) {
  const byDate = new Map<string, IssuePlanRow[]>();
  for (const row of rows) byDate.set(row.runDate, [...(byDate.get(row.runDate) ?? []), row]);
  return (
    <>
      {[...byDate.entries()].map(([runDate, items]) => (
        <div key={runDate} className="print-page" style={paper}>
          <div className="flex items-start justify-between">
            <div className="pt-3 text-xl font-bold">출고계획 리스트</div>
            <table className="border-collapse text-[10px]">
              <tbody>
                <tr>{['Charge', 'Examine', 'Confirm'].map((t) => <td key={t} className={`${cell} w-[22mm] text-center`}>{t}</td>)}</tr>
                <tr>{[0, 1, 2].map((i) => <td key={i} className={`${cell} h-[12mm]`} />)}</tr>
              </tbody>
            </table>
          </div>
          <div className="mt-3 text-[11px]"><b>Run Date</b> {runDate}</div>
          <table className="mt-2 w-full border-collapse text-[10px]">
            <thead>
              <tr>
                {['#', 'Item Code', 'Item Name', 'Part No', 'Item Spec', 'L/A', 'T/B', 'Total Qty', 'Material Qty', 'Reel Qty']
                  .map((h) => <th key={h} className={label}>{h}</th>)}
              </tr>
            </thead>
            <tbody>
              {items.map((it, i) => (
                <tr key={`${it.itemCode}-${i}`}>
                  <td className={`${cell} text-center`}>{i + 1}</td>
                  <td className={cell}>{it.itemCode}</td>
                  <td className={cell}>{it.itemName}</td>
                  <td className={cell}>{it.partNo}</td>
                  <td className={cell}>{it.itemSpec}</td>
                  <td className={cell}>{it.locationAddress}</td>
                  <td className={`${cell} text-center`}>{it.pcbItem}</td>
                  <td className={`${cell} text-right`}>{fmt(it.inputQty)}</td>
                  <td className={`${cell} text-right`}>{fmt(it.materialQty)}</td>
                  <td className={`${cell} text-right`}>{fmt(it.reelQty)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      ))}
    </>
  );
}

/** PID 라벨 — 9×12mm 한 장에 품목코드·QR·라벨 문자열 */
export function PidLabels({ rows }: { rows: PidRow[] }) {
  return (
    <>
      {rows.map((p) => (
        <div
          key={p.serialNo}
          className="print-page flex flex-col items-center justify-between overflow-hidden"
          style={{ width: '9mm', height: '12mm', padding: '0.3mm', boxSizing: 'border-box', background: '#fff', color: '#000', fontFamily: 'Tahoma, Arial, sans-serif', boxShadow: '0 1px 3px rgba(0,0,0,.3)' }}
        >
          <div style={{ fontSize: '1.3mm', lineHeight: 1, whiteSpace: 'nowrap' }}>{p.itemCode}</div>
          <BarcodeImg value={p.serialNo} kind="qrcode" style={{ width: '7.4mm', height: '7.4mm' }} />
          <div style={{ fontSize: '1.1mm', lineHeight: 1.05, wordBreak: 'break-all', textAlign: 'center' }}>{p.labelText}</div>
        </div>
      ))}
    </>
  );
}

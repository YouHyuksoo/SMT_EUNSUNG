"use client";

/**
 * @file src/app/(authenticated)/smt/plan/components/FeederLayoutPrintModal.tsx
 * @description 피더 레이아웃 출력 — PB d_smt_plandata_list_rpt (Feeder Layout(Plan)) 와 같은 A4 출력물
 *
 * 초보자 가이드:
 * 1. 라인·모델·테이블마다 새 쪽이다 (PB group newpage). 쪽 안에서는 대체여부(Replace)로 묶는다.
 * 2. 머리글에 라인·모델·PCB 바코드(Code39), 본문 줄마다 위치 바코드를 찍는다 — 현장이 스캔해 피더를 맞춘다.
 * 3. 바코드 이미지는 비동기로 그려진다. 미리보기에 바코드가 보인 뒤 인쇄를 누른다.
 */
import { useEffect, useMemo, useState } from 'react';
import toast from 'react-hot-toast';
import api from '@/services/api';
import { getTodayLocal } from '@/utils/date';
import BarcodeImg from '../../../production/run-card/components/BarcodeImg';
import PrintPreviewModal from '../../../production/run-card/components/PrintPreviewModal';
import type { SmtPlanSummaryRow } from '../../types';

interface LayoutRow {
  div: string | null;
  modelName: string;
  itemCode: string | null;
  itemUnitQty: number | null;
  itemSpec: string | null;
  parentItemName: string | null;
  locationAddress: string | null;
  locationCode: string | null;
  lineCode: string;
  machine: string | null;
  lineName: string | null;
  tableId: string | null;
  feederType: string | null;
  pcbItem: string | null;
  unitPrice: number | null;
  pcbItemCode: string | null;
  revision: string | null;
  mslLevel: string | null;
}

interface Page {
  key: string;
  rows: LayoutRow[];
}

const cell = 'border border-black px-1 py-0.5';

/** PB 바코드 글꼴(Free 3 of 9)은 소문자를 대문자 막대로 찍었다 — 같은 값이 스캔되게 대문자로 그린다 */
const code39 = (value: string | null | undefined) => (value ? value.toUpperCase() : value);

function LayoutPage({ page, index, total, today }: { page: Page; index: number; total: number; today: string }) {
  const head = page.rows[0];
  const groups = new Map<string, LayoutRow[]>();
  for (const r of page.rows) {
    const k = r.div ?? '';
    groups.set(k, [...(groups.get(k) ?? []), r]);
  }
  return (
    <div className="print-page flex flex-col bg-white text-black shadow" style={{ width: '210mm', minHeight: '297mm', padding: '10mm', fontFamily: 'Tahoma, sans-serif' }}>
      <div className="flex items-end justify-between">
        <div className="text-2xl font-bold">Feeder Layout(Plan)</div>
        <div className="text-sm">{today}</div>
      </div>
      <table className="mt-2 w-full border-collapse text-xs">
        <tbody>
          <tr>
            <td className={`${cell} w-[18mm] font-semibold`}>Line</td>
            <td className={cell}><BarcodeImg value={code39(`${head.lineCode}-${head.machine ?? ''}`)} kind="code39" style={{ height: '9mm' }} /></td>
            <td className={`${cell} text-lg font-bold`}>{head.lineName ?? head.lineCode}</td>
            <td className={`${cell} font-semibold`}>PCB</td>
            <td className={cell}>
              <div>{head.pcbItemCode}</div>
              {head.pcbItemCode && head.pcbItemCode !== '*' && <BarcodeImg value={code39(head.pcbItemCode)} kind="code39" style={{ height: '6mm' }} />}
            </td>
          </tr>
          <tr>
            <td className={`${cell} font-semibold`}>Model Name</td>
            <td className={cell}>{head.modelName}</td>
            <td className={cell}><BarcodeImg value={code39(head.modelName)} kind="code39" style={{ height: '9mm', maxWidth: '70mm' }} /></td>
            <td className={`${cell} font-semibold`}>Top / Bot</td>
            <td className={`${cell} text-base font-bold`}>{head.pcbItem}</td>
          </tr>
          <tr>
            <td className={`${cell} font-semibold`}>Model Spec</td>
            <td className={cell} colSpan={2}>{head.parentItemName}</td>
            <td className={`${cell} font-semibold`}>Machine</td>
            <td className={cell}>{head.machine}</td>
          </tr>
        </tbody>
      </table>

      <table className="mt-3 w-full border-collapse text-[10px]">
        <thead>
          <tr className="bg-gray-100">
            <th className={cell}>Location Code</th>
            <th className={cell}>Child Item Code</th>
            <th className={cell}>Rev.</th>
            <th className={cell}>Item Spec</th>
            <th className={cell}>Location</th>
            <th className={cell}>Price</th>
            <th className={cell}>F/Type</th>
            <th className={cell}>Qty</th>
            <th className={cell}>MSL</th>
            <th className={cell}>Location Address</th>
          </tr>
        </thead>
        <tbody>
          <tr><td colSpan={10} className={`${cell} text-base font-bold`}>Table: {head.tableId}</td></tr>
          {[...groups.entries()].map(([div, rows]) => (
            <GroupRows key={div} div={div} rows={rows} />
          ))}
        </tbody>
      </table>

      <div className="mt-auto flex justify-between pt-2 text-[10px]">
        <span />
        <span>Page {index + 1} of {total}</span>
        <span>Type1</span>
      </div>
    </div>
  );
}

function GroupRows({ div, rows }: { div: string; rows: LayoutRow[] }) {
  return (
    <>
      <tr><td colSpan={10} className={`${cell} text-sm font-bold`}>Replace: {div || '-'}</td></tr>
      {rows.map((r, i) => (
        <tr key={`${r.locationCode}-${r.itemCode}-${i}`}>
          <td className={`${cell} font-semibold`}>{r.locationCode}</td>
          <td className={cell}>{r.itemCode}</td>
          <td className={`${cell} text-center`}>{r.revision}</td>
          <td className={cell}>{r.itemSpec}</td>
          <td className={cell}>{r.locationCode && <BarcodeImg value={code39(r.locationCode)} kind="code39" style={{ height: '6mm' }} />}</td>
          <td className={`${cell} text-right`}>{r.unitPrice ?? ''}</td>
          <td className={cell}>{r.feederType}</td>
          <td className={`${cell} text-right`}>{r.itemUnitQty ?? ''}</td>
          <td className={`${cell} text-center`}>{r.mslLevel}</td>
          <td className={cell}>{r.locationAddress}</td>
        </tr>
      ))}
    </>
  );
}

export default function FeederLayoutPrintModal({ plan, revision, onClose }: { plan: SmtPlanSummaryRow; revision: string; onClose: () => void }) {
  const [rows, setRows] = useState<LayoutRow[]>([]);
  const [loading, setLoading] = useState(true);
  const today = useMemo(() => getTodayLocal(), []);

  useEffect(() => {
    setLoading(true);
    api.get('/smt/plan/layout-print', {
      params: { lineCode: plan.lineCode, modelName: plan.modelName, pcbItem: plan.pcbItem === 'B' ? 'B' : 'T', revision: revision || undefined },
    })
      .then((res) => setRows(res.data?.data ?? []))
      .catch(() => { setRows([]); toast.error('피더 레이아웃 출력 데이터를 가져오지 못했습니다.'); })
      .finally(() => setLoading(false));
  }, [plan.lineCode, plan.modelName, plan.pcbItem, revision]);

  // 라인·모델·테이블마다 새 쪽 (PB group level 1·3 newpage)
  const pages = useMemo<Page[]>(() => {
    const map = new Map<string, LayoutRow[]>();
    for (const r of rows) {
      const k = [r.lineCode, r.modelName, r.tableId].join('|');
      map.set(k, [...(map.get(k) ?? []), r]);
    }
    return [...map.entries()].map(([key, list]) => ({ key, rows: list }));
  }, [rows]);

  return (
    <PrintPreviewModal
      isOpen
      title="피더 레이아웃 출력"
      pageSize="A4 portrait"
      onClose={onClose}
      summary={loading ? '불러오는 중…' : `${plan.lineCode} / ${plan.modelName} / ${plan.pcbItem ?? ''} · ${pages.length}쪽 · ${rows.length}행`}
    >
      {pages.map((page, i) => (
        <LayoutPage key={page.key} page={page} index={i} total={pages.length} today={today} />
      ))}
    </PrintPreviewModal>
  );
}

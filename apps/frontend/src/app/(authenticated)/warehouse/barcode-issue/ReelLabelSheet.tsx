"use client";

/**
 * @file warehouse/barcode-issue/ReelLabelSheet.tsx
 * @description 자재 릴 라벨 한 장 — PB `d_mat_receipt_lot_barcode_rpt` 와 같은 칸 배치(80×40mm).
 *
 * 초보자 가이드:
 * 1. 출고반품(양품)을 하면 바코드가 `품목-롯트-남은수량` 으로 바뀌므로 새 라벨을 붙인다.
 *    PB 는 반품 직후 이 라벨을 바로 찍었다 (Auto Print).
 * 2. 출력할 때 이 노드를 PNG 로 바꿔(services/label-print) 브라우저 인쇄나 Print Agent 로 보낸다.
 *    PNG 변환은 화면 CSS 를 가져가지 못하므로 **모든 스타일을 inline 으로** 쓴다.
 * 3. 바코드는 PB 와 같은 Code 128 이다 (PB F_BACODE_CODE128 + Code 128 글꼴).
 */
import type { CSSProperties } from 'react';

export const REEL_LABEL_MM = { width: 80, height: 40 } as const;

/** GET /warehouse/barcode-issue/reel-label 한 행 */
export interface ReelLabelRow {
  itemCode: string;
  itemBarcode: string;
  lotNo: string;
  scanQty: number | null;
  itemName: string | null;
  itemSpec: string | null;
  mslLevel: string | null;
  locationAddress: string | null;
  supplierCode: string | null;
  labelType: string | null;
  receiptType: string | null;
  printDate: string | null;
}

export interface ReelLabelItem {
  row: ReelLabelRow;
  barcodeSrc: string;
}

/** Code 128 바코드 PNG(data URL). 인쇄해도 흐려지지 않게 scale 을 넉넉히 준다. */
export async function makeCode128Png(value: string): Promise<string> {
  const bwipjs = await import('bwip-js');
  const canvas = document.createElement('canvas');
  bwipjs.toCanvas(canvas, {
    bcid: 'code128',
    text: value,
    scale: 4,
    height: 9,
    includetext: false,
    paddingwidth: 0,
    paddingheight: 0,
  });
  return canvas.toDataURL('image/png');
}

const text: CSSProperties = { overflow: 'hidden', whiteSpace: 'nowrap', textOverflow: 'clip' };

export default function ReelLabelSheet({ item }: { item: ReelLabelItem }) {
  const { row, barcodeSrc } = item;
  return (
    <div style={{
      width: `${REEL_LABEL_MM.width}mm`, height: `${REEL_LABEL_MM.height}mm`, boxSizing: 'border-box',
      padding: '1.8mm 3mm', background: '#fff', color: '#000', fontFamily: 'Tahoma, Arial, sans-serif',
      display: 'flex', flexDirection: 'column', gap: '0.8mm',
    }}>
      <div style={{ display: 'flex', fontSize: '2.6mm', gap: '2mm' }}>
        <span style={{ ...text, flex: 1 }}>{row.supplierCode ?? ''}</span>
        <span style={{ ...text, width: '10mm', textAlign: 'center' }}>{row.receiptType ?? ''}</span>
        <span style={{ ...text, width: '10mm', textAlign: 'center' }}>{row.labelType ?? ''}</span>
      </div>
      <div style={{ ...text, fontSize: '3.6mm', fontWeight: 700 }}>{row.itemBarcode}</div>
      <img src={barcodeSrc} alt={row.itemBarcode} style={{ width: '100%', height: '7mm', objectFit: 'fill' }} />
      <div style={{ display: 'flex', fontSize: '3mm', gap: '2mm' }}>
        <span style={{ ...text, width: '30mm', fontWeight: 700 }}>{row.itemName ?? ''}</span>
        <span style={{ ...text, flex: 1 }}>{row.itemSpec ?? ''}</span>
      </div>
      <div style={{ display: 'flex', fontSize: '3mm', gap: '2mm', marginTop: 'auto' }}>
        <span style={{ ...text, flex: 1 }}>LOT {row.lotNo} · {Number(row.scanQty ?? 0).toLocaleString()}</span>
        <span style={{ ...text, width: '20mm' }}>LOC: {row.locationAddress ?? ''}</span>
        <span style={{ ...text, width: '12mm' }}>MSL: {row.mslLevel ?? ''}</span>
      </div>
    </div>
  );
}

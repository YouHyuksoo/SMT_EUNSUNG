"use client";

/**
 * @file process-transaction/magazine-label/MagazineLabelSheet.tsx
 * @description 매거진 라벨 한 장 — PB `d_pln_product_magazine_label_rpt_es` 와 같은 칸 배치(105×70mm).
 *
 * 초보자 가이드:
 * 1. 출력할 때 이 노드를 PNG 로 바꿔(services/label-print) 브라우저 인쇄나 Print Agent 로 보낸다.
 *    PNG 변환은 화면 CSS 를 가져가지 못하므로 **모든 스타일을 inline 으로** 쓴다.
 * 2. 바코드는 PB 와 같은 Code 39 다(PB 는 `*번호*` 를 Free 3 of 9 글꼴로 찍었다).
 *    값은 `makeCode39Png` 로 미리 PNG 로 만들어 넘긴다.
 * 3. 칸 위치는 DataWindow 좌표(1/1000cm)를 mm 로 옮긴 것이다.
 */
import type { CSSProperties } from 'react';

export const MAGAZINE_LABEL_MM = { width: 105, height: 70 } as const;

/** POST /process-transaction/magazine-label/print-data 한 행 */
export interface MagazinePrintRow {
  magazineLabelNo: string;
  modelName: string | null;
  lineName: string | null;
  workstageName: string | null;
  lotQty: number | null;
  pcbItemName: string | null;
  labelTypeName: string | null;
  enterBy: string | null;
  runNo: string | null;
  lotSize: number | null;
  receiptDate: string | null;
}

export interface MagazinePrintItem {
  row: MagazinePrintRow;
  barcodeSrc: string;
}

/** Code 39 바코드 PNG(data URL). 인쇄해도 흐려지지 않게 scale 을 넉넉히 준다. */
export async function makeCode39Png(value: string): Promise<string> {
  const bwipjs = await import('bwip-js');
  const canvas = document.createElement('canvas');
  bwipjs.toCanvas(canvas, {
    bcid: 'code39',
    text: value,
    scale: 4,
    height: 10,
    includetext: false,
    paddingwidth: 0,
    paddingheight: 0,
  });
  return canvas.toDataURL('image/png');
}

const line = '0.26mm solid #000';
const cell: CSSProperties = {
  display: 'flex', alignItems: 'center', justifyContent: 'center',
  overflow: 'hidden', whiteSpace: 'nowrap', padding: '0 1mm',
};
const head: CSSProperties = { ...cell, borderRight: line, fontWeight: 700 };
const row: CSSProperties = { display: 'flex', borderTop: line, height: '7.15mm' };
const fmt = (n: number | null) => (n == null ? '' : Number(n).toLocaleString());

/** 이름칸 | 값칸 | 이름칸 | 값칸 한 줄 */
function Pair({ a, av, b, bv }: { a: string; av: string; b: string; bv: string }) {
  return (
    <div style={row}>
      <div style={{ ...head, width: '17.8mm' }}>{a}</div>
      <div style={{ ...cell, width: '28.3mm', borderRight: line }}>{av}</div>
      <div style={{ ...head, width: '18mm' }}>{b}</div>
      <div style={{ ...cell, flex: 1 }}>{bv}</div>
    </div>
  );
}

function Single({ a, av }: { a: string; av: string }) {
  return (
    <div style={row}>
      <div style={{ ...head, width: '17.8mm' }}>{a}</div>
      <div style={{ ...cell, flex: 1, justifyContent: 'flex-start' }}>{av}</div>
    </div>
  );
}

export default function MagazineLabelSheet({ item }: { item: MagazinePrintItem }) {
  const r = item.row;
  return (
    <div
      style={{
        width: `${MAGAZINE_LABEL_MM.width}mm`, height: `${MAGAZINE_LABEL_MM.height}mm`,
        boxSizing: 'border-box', padding: '2.38mm', background: '#fff', color: '#000',
        fontFamily: "'Malgun Gothic', 'Apple SD Gothic Neo', Arial, sans-serif", fontSize: '3.4mm',
      }}
    >
      <div style={{ border: line, height: '100%', display: 'flex', flexDirection: 'column', boxSizing: 'border-box' }}>
        {/* 라벨구분 · 제목 · 작업자 */}
        <div style={{ display: 'flex', alignItems: 'center', height: '8.7mm' }}>
          <div style={{ ...cell, width: '20mm', fontWeight: 700, fontSize: '4.6mm' }}>{r.labelTypeName ?? ''}</div>
          <div style={{ ...cell, flex: 1, fontWeight: 700, fontSize: '5.2mm' }}>매거진 라벨</div>
          <div style={{ ...cell, width: '18mm', fontSize: '3mm' }}>{r.enterBy ?? ''}</div>
        </div>
        {/* 라벨번호 바코드 */}
        <div style={{ borderTop: line, height: '12.2mm', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src={item.barcodeSrc} alt={r.magazineLabelNo} style={{ height: '8.2mm', maxWidth: '92mm' }} />
          <div style={{ fontSize: '2.8mm', fontWeight: 700, letterSpacing: '0.3mm' }}>{r.magazineLabelNo}</div>
        </div>
        <Single a="차종" av={r.modelName ?? ''} />
        <Pair a="라인" av={r.lineName ?? ''} b="공정명" bv={r.workstageName ?? ''} />
        <Pair a="수량" av={fmt(r.lotQty)} b="TOP/BOT" bv={r.pcbItemName ?? ''} />
        <Single a="일자" av={r.receiptDate ?? ''} />
        <Pair a="런카드번호" av={r.runNo ?? ''} b="런카드수량" bv={fmt(r.lotSize)} />
        <div style={{ ...row, flex: 1 }}>
          <div style={{ ...head, width: '17.8mm' }}>비고</div>
          <div style={{ flex: 1 }} />
        </div>
      </div>
    </div>
  );
}

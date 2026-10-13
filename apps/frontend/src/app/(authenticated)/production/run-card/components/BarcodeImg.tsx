"use client";

/**
 * @file production/run-card/components/BarcodeImg.tsx
 * @description 출력물에 넣는 바코드·QR 이미지 (bwip-js 로 브라우저에서 그린다)
 *
 * 초보자 가이드:
 * 1. PB 는 바코드 글꼴(Free 3 of 9, Code 128)과 DB 패키지가 만든 QR 파일을 썼다.
 *    웹은 bwip-js 로 PNG 를 만들어 <img> 로 넣는다 — 인쇄해도 흐려지지 않게 scale 을 넉넉히 준다.
 * 2. 값이 비면 아무것도 그리지 않는다 (빈 자리에 깨진 이미지가 찍히지 않게).
 */
import { useEffect, useState } from 'react';

type Kind = 'code128' | 'code39' | 'qrcode';

export default function BarcodeImg({ value, kind, className, style }: {
  value: string | null | undefined;
  kind: Kind;
  className?: string;
  style?: React.CSSProperties;
}) {
  const [src, setSrc] = useState('');

  useEffect(() => {
    if (!value) { setSrc(''); return; }
    let cancelled = false;
    (async () => {
      try {
        const bwipjs = await import('bwip-js');
        const canvas = document.createElement('canvas');
        bwipjs.toCanvas(canvas, {
          bcid: kind,
          text: value,
          scale: 4,
          includetext: false,
          paddingwidth: 0,
          paddingheight: 0,
          ...(kind === 'qrcode' ? {} : { height: 10 }),
        });
        if (!cancelled) setSrc(canvas.toDataURL('image/png'));
      } catch {
        if (!cancelled) setSrc('');
      }
    })();
    return () => { cancelled = true; };
  }, [kind, value]);

  if (!src) return null;
  // eslint-disable-next-line @next/next/no-img-element
  return <img src={src} alt={value ?? ''} className={className} style={style} />;
}

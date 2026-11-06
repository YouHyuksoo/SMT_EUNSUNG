'use client';

/**
 * @file oee/multi-entry/page.tsx
 * @description OEE 비가동 입력 — SMT 작업장 (ASSY 는 /oee/multi-entry-assy)
 */
import MultiEntryBoard from './_components/MultiEntryBoard';

export default function OeeMultiEntrySmtPage() {
  return <MultiEntryBoard processCode="SMT" />;
}

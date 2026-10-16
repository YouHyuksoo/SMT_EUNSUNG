'use client';

/**
 * @file oee/multi-entry-assy/page.tsx
 * @description OEE 비가동 입력 — ASSY 작업장 (SMT 는 /oee/multi-entry)
 */
import MultiEntryBoard from '../multi-entry/_components/MultiEntryBoard';

export default function OeeMultiEntryAssyPage() {
  return <MultiEntryBoard processCode="ASSY" />;
}

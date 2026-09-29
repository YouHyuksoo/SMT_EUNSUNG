"use client";

/**
 * @file src/components/shared/codeCells.tsx
 * @description 그리드 코드 컬럼 셀 렌더러 — PB DataWindow 의 DDDW 표시값을 대신한다.
 *
 * 초보자 가이드:
 * 1. **왜 필요한가**: PB 는 코드 컬럼에 DDDW 를 붙여 저장값은 코드, 화면에는 뜻을 보여준다.
 *    웹에서 accessorKey 만 두면 `P`, `B1020` 같은 원시 코드가 그대로 노출된다.
 * 2. **어느 렌더러를 쓰나**: docs/database/pb-dddw-inventory.md 의 `kind` 열을 본다.
 *    `basecode`(ISYS_BASECODE) → `comCodeCell`, `codemaster`(ISYS_CODE_MASTER) → `codeMasterCell`.
 *    이름으로 넘겨짚으면 라벨이 통째로 빈칸이 된다.
 * 3. **원시 코드는 유지**: 표시만 바꾼다. 필터·정렬·API 전송에는 코드 값이 그대로 쓰인다.
 */
import type { CellContext } from '@tanstack/react-table';
import { ComCodeBadge } from '@/components/ui';
import { useCodeMasterLabel } from '@/hooks/useCodeMaster';

/**
 * 공통코드(ISYS_BASECODE) 셀. 값이 없으면 배지를 그리지 않는다(빈 배지 노이즈 방지).
 * PB 대응: `dddw.name=vd_basecode`
 */
export function comCodeCell<TRow>(groupCode: string) {
  return function ComCodeCell(ctx: CellContext<TRow, unknown>) {
    const value = ctx.getValue();
    return value ? <ComCodeBadge groupCode={groupCode} code={String(value)} /> : null;
  };
}

/**
 * 코드마스터(ISYS_CODE_MASTER) 셀.
 * PB 대응: `dddw.name=vd_standard_code` 계열(`vd_wqc_standard_code` 등)
 */
export function codeMasterCell<TRow>(codeType: string) {
  return function CodeMasterCell(ctx: CellContext<TRow, unknown>) {
    const value = ctx.getValue();
    const label = useCodeMasterLabel(codeType, value == null ? null : String(value));
    return label ? <span>{label}</span> : null;
  };
}

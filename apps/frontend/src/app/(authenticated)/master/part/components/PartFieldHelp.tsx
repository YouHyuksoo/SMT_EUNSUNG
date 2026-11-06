"use client";

/**
 * @file src/app/(authenticated)/master/part/components/PartFieldHelp.tsx
 * @description 품목마스터 등록창 칸 — 컬럼 목록(ITEM_MASTER_COLUMNS) 한 줄을 받아 알맞은 입력을 그린다.
 *
 * 초보자 가이드:
 * 1. **입력 방식은 컬럼 목록의 input 이 정한다.** code=기준코드 선택, yn=예/아니오, abc=등급,
 *    supplier·customer·line=기준정보 선택, text·textarea·number·date=직접 입력.
 * 2. **NOT NULL 이 아닌 선택 칸은 맨 위에 '선택 안 함'이 있다** — 값을 비울 수 있다.
 * 3. **라벨 옆 ? 에 DB 컬럼과 설명이 뜬다.**
 * 4. 폼 값은 전부 문자열이다. 숫자·날짜 변환은 저장할 때 한다 (PartFormPanel).
 */
import { useMemo } from "react";
import { ITEM_MASTER_COLUMNS, ITEM_MASTER_SECTIONS, type ItemMasterColumn } from "@smt/shared";
import { Input, Select } from "@/components/ui";
import type { SelectOption } from "@/components/ui";
import { ComCodeSelect, HelpTooltip, ProdLineSelect } from "@/components/shared";
import { useComCodeOptions } from "@/hooks/useComCode";
import { useCustomerOptions, useSupplierOptions } from "@/hooks/useMasterOptions";

export const NONE_OPTION: SelectOption = { value: "", label: "선택 안 함" };
const YN_OPTIONS: SelectOption[] = [{ value: "Y", label: "Y (예)" }, { value: "N", label: "N (아니오)" }];
const ABC_OPTIONS: SelectOption[] = ["A", "B", "C"].map((v) => ({ value: v, label: v }));

/** 컬럼 키 → 컬럼 정보 */
export const ITEM_COLUMN_BY_KEY: Record<string, ItemMasterColumn> = Object.fromEntries(
  ITEM_MASTER_COLUMNS.map((c) => [c.key, c]),
);

/** 기본정보 구역에서 앞에 둘 칸 — 그리드 규칙(품목코드 → 품명 → 나머지)과 같다 */
const LEAD_KEYS = ["itemCode", "itemName", "itemNo", "custPartNo", "spec", "itemUom"];

/** 구역 순서로 정렬한 컬럼. 같은 구역 안은 DB 컬럼 순서, 기본정보는 LEAD_KEYS 를 앞에 둔다. */
export const ORDERED_ITEM_COLUMNS: readonly ItemMasterColumn[] = ITEM_MASTER_SECTIONS.flatMap((section) => {
  const cols = ITEM_MASTER_COLUMNS.filter((c) => c.section === section.key);
  const lead = LEAD_KEYS.map((k) => cols.find((c) => c.key === k)).filter((c): c is ItemMasterColumn => !!c);
  return [...lead, ...cols.filter((c) => !LEAD_KEYS.includes(c.key))];
});

const DATE_ONLY = /^\d{4}-\d{2}-\d{2}$/;

/**
 * API 날짜 → KST 일자 YYYY-MM-DD. 응답은 보통 이미 YYYY-MM-DD 다.
 * ISO 시각이 오면 KST 로 바꾼다 — DB DATE 는 KST 0시라 ISO 앞 10자리를 자르면 하루 앞당겨진다.
 */
export function kstDate(value: unknown): string {
  if (!value) return "";
  const text = String(value);
  if (DATE_ONLY.test(text)) return text;
  const d = new Date(text);
  return Number.isNaN(d.getTime()) ? text : d.toLocaleDateString("sv-SE", { timeZone: "Asia/Seoul" });
}

/** API 날짜 → KST 일시 YYYY-MM-DD HH:mm. 일자만 오면 일자만 보여 준다. */
export function kstDateTime(value: unknown): string {
  if (!value) return "";
  const text = String(value);
  if (DATE_ONLY.test(text)) return text;
  const d = new Date(text);
  return Number.isNaN(d.getTime())
    ? text
    : d.toLocaleString("sv-SE", { timeZone: "Asia/Seoul", hour12: false }).slice(0, 16);
}

export function FieldLabel({ col, required }: { col: ItemMasterColumn; required?: boolean }) {
  return (
    <label className="mb-1.5 flex items-center gap-1 text-sm font-medium text-text">
      <span>{col.label}</span>
      {required && <span className="text-red-500">*</span>}
      <HelpTooltip description={col.help} db={`ID_ITEM.${col.column}`} dataField={col.key} />
    </label>
  );
}

/** 선택 칸 — 비울 수 있으면 '선택 안 함'을 앞에 붙인다 */
function OptionSelect({ col, options, value, onChange, disabled }: {
  col: ItemMasterColumn;
  options: SelectOption[];
  value: string;
  onChange: (value: string) => void;
  disabled?: boolean;
}) {
  const shown = useMemo(() => (col.required ? options : [NONE_OPTION, ...options]), [col.required, options]);
  return <Select fullWidth options={shown} value={value} onChange={onChange} disabled={disabled} placeholder="선택" />;
}

function CodeSelect({ col, value, onChange, disabled }: FieldInputProps) {
  const options = useComCodeOptions(col.codeGroup ?? "", false, true);
  if (col.required) {
    return (
      <ComCodeSelect groupCode={col.codeGroup ?? ""} includeAll={false} showCode fullWidth placeholder="선택"
        value={value} onChange={onChange} disabled={disabled} />
    );
  }
  return <OptionSelect col={col} options={options} value={value} onChange={onChange} disabled={disabled} />;
}

function SupplierField(props: FieldInputProps) {
  const { options } = useSupplierOptions();
  return <OptionSelect {...props} options={options} />;
}

function CustomerField(props: FieldInputProps) {
  const { options } = useCustomerOptions();
  return <OptionSelect {...props} options={options} />;
}

interface FieldInputProps {
  col: ItemMasterColumn;
  value: string;
  onChange: (value: string) => void;
  disabled?: boolean;
}

/** 컬럼 하나의 입력 */
export function ItemFieldInput({ col, value, onChange, disabled }: FieldInputProps) {
  switch (col.input) {
    case "code":
      return <CodeSelect col={col} value={value} onChange={onChange} disabled={disabled} />;
    case "yn":
      return <OptionSelect col={col} options={YN_OPTIONS} value={value} onChange={onChange} disabled={disabled} />;
    case "abc":
      return <OptionSelect col={col} options={ABC_OPTIONS} value={value} onChange={onChange} disabled={disabled} />;
    case "supplier":
      return <SupplierField col={col} value={value} onChange={onChange} disabled={disabled} />;
    case "customer":
      return <CustomerField col={col} value={value} onChange={onChange} disabled={disabled} />;
    case "line":
      return (
        <ProdLineSelect fullWidth includeUnassigned placeholder="라인 선택"
          value={value} onChange={onChange} disabled={disabled} />
      );
    case "textarea":
      return (
        <textarea
          value={value}
          maxLength={col.maxLength}
          disabled={disabled}
          rows={3}
          onChange={(e) => onChange(e.target.value)}
          className="w-full rounded-[var(--radius)] border border-gray-400 bg-surface px-3 py-2 text-sm text-text focus:outline-none focus:ring-2 focus:ring-primary disabled:opacity-50 dark:border-gray-500"
        />
      );
    case "number":
      return (
        <Input fullWidth type="number" value={value} disabled={disabled}
          step={col.scale ? 10 ** -col.scale : "any"}
          onChange={(e) => onChange(e.target.value)} />
      );
    case "date":
      return <Input fullWidth type="date" value={value} disabled={disabled} onChange={(e) => onChange(e.target.value)} />;
    default:
      return (
        <Input fullWidth value={value} maxLength={col.maxLength} disabled={disabled}
          onChange={(e) => onChange(e.target.value)} />
      );
  }
}

/** 라벨 + 입력. readOnly 면 값만 보여 준다 (키·표시 전용 컬럼). */
export function ItemField({ col, value, onChange, readOnly, required, className = "" }: {
  col: ItemMasterColumn;
  value: string;
  onChange: (value: string) => void;
  readOnly?: boolean;
  required?: boolean;
  className?: string;
}) {
  return (
    <div className={className}>
      <FieldLabel col={col} required={required} />
      {readOnly ? (
        <Input fullWidth value={value} readOnly tabIndex={-1} className="cursor-default bg-background" />
      ) : (
        <ItemFieldInput col={col} value={value} onChange={onChange} />
      )}
    </div>
  );
}

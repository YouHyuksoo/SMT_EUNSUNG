/**
 * @file src/components/shared/ModelSearchField.tsx
 * @description 모델 선택 필드 — 클릭하면 모델마스터(ModelSearchModal)를 열고, 선택 값을 문자열로 돌려준다.
 *
 * 조회 필터의 "모델명" 자유 입력칸을 대체하는 공용 컴포넌트다. 품목 필터(품목 선택 박스)와 같은 방식이다.
 * 값은 문자열 하나라서 화면의 기존 state·API 파라미터를 그대로 쓴다.
 *
 * 사용 예:
 *   <ModelSearchField value={modelName} onChange={setModelName} className="w-44" />
 *   <ModelSearchField value={partNo} valueKey="partNo" onChange={setPartNo} />
 *   <ModelSearchField value={modelName} onChange={(v) => { setModelName(v); search(v); }} />
 */

"use client";

import { useState } from "react";
import { Search, X } from "lucide-react";
import ModelSearchModal, { type ModelItem } from "./ModelSearchModal";

export interface ModelSearchFieldProps {
  /** 선택된 값 (valueKey 기준: 모델명 또는 모델코드) */
  value: string;
  /** 선택·해제 시 호출. 해제하면 value="" / model=null */
  onChange: (value: string, model: ModelItem | null) => void;
  /** 돌려줄 값: 모델명(기본) 또는 모델코드(PART_NO) */
  valueKey?: "modelName" | "partNo";
  placeholder?: string;
  label?: string;
  required?: boolean;
  disabled?: boolean;
  /** 폭 지정용 (예: "w-44") */
  className?: string;
  "aria-label"?: string;
}

export default function ModelSearchField({
  value,
  onChange,
  valueKey = "modelName",
  placeholder = "모델 선택",
  label,
  required,
  disabled,
  className = "w-44",
  "aria-label": ariaLabel = "모델 선택",
}: ModelSearchFieldProps) {
  const [open, setOpen] = useState(false);

  return (
    <div className={label ? className : undefined}>
      {label && (
        <label className="mb-1.5 block text-sm font-medium text-text">
          {label}
          {required && <span className="ml-0.5 text-red-500">*</span>}
        </label>
      )}
      <div
        className={`flex h-10 items-center gap-1 rounded-[var(--radius)] border border-gray-400 bg-surface px-2 text-sm dark:border-gray-500 ${
          disabled ? "cursor-not-allowed opacity-50" : ""
        } ${label ? "w-full" : className}`}
      >
        <button
          type="button"
          aria-label={ariaLabel}
          title={value || placeholder}
          disabled={disabled}
          onClick={() => setOpen(true)}
          className="flex min-w-0 flex-1 items-center gap-2 text-left disabled:cursor-not-allowed"
        >
          <Search className="h-4 w-4 shrink-0 text-text-muted" />
          <span className={`truncate font-data ${value ? "text-text" : "text-text-muted"}`}>
            {value || placeholder}
          </span>
        </button>
        {value && !disabled && (
          <button
            type="button"
            aria-label="모델 선택 해제"
            title="선택 해제"
            onClick={() => onChange("", null)}
            className="shrink-0 text-text-muted hover:text-text"
          >
            <X className="h-4 w-4" />
          </button>
        )}
      </div>
      <ModelSearchModal
        isOpen={open}
        onClose={() => setOpen(false)}
        onSelect={(model) => {
          onChange(model[valueKey], model);
          setOpen(false);
        }}
      />
    </div>
  );
}

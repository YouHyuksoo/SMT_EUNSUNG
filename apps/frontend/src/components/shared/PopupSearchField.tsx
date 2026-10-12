"use client";

/**
 * @file src/components/shared/PopupSearchField.tsx
 * @description 마스터 코드 입력 필드 — 직접 입력 + 칸 안 돋보기로 PB 팝업 카탈로그 조회 모달(SearchSelectModal) 선택
 *
 * PartSearchField 와 같은 방식의 범용판이다. 카탈로그 id(popupId)만 바꾸면 고객·공급처·설비 등에 쓴다.
 * `Input` 과 같은 props 를 받으므로 기존 `<Input ... />` 을 `<PopupSearchField popupId=… returnKey=… ... />` 로 바꾸면 된다.
 *
 * 초보자 가이드:
 * 1. **직접 입력**: 타이핑·Enter 조회가 그대로 동작한다
 * 2. **돋보기**: 카탈로그 조회 모달을 연다. 입력해 둔 값을 returnKey 필터 초기값으로 넘긴다
 * 3. **선택 반영**: 고른 행의 returnKey 값을 입력칸에 넣고, 화면의 onChange 를 실제 input 이벤트로 호출한다
 * 4. **onPick**: 이름 등 다른 값이 필요하면 선택 행 전체를 받는다
 *
 * 사용 예:
 *   <PopupSearchField popupId="customer-search" returnKey="customerCode" placeholder="고객코드"
 *     value={customerCode} onChange={(e) => setCustomerCode(e.target.value)} className="w-40" />
 */

import { forwardRef, useImperativeHandle, useRef, useState } from "react";
import { Search } from "lucide-react";
import Input, { type InputProps } from "@/components/ui/Input";
import SearchSelectModal, { type PopupRow } from "@/components/popups/SearchSelectModal";

export interface PopupSearchFieldProps extends Omit<InputProps, "rightIcon"> {
  /** PB 팝업 카탈로그 id (@smt/shared POPUP_CATALOG, 예: customer-search) */
  popupId: string;
  /** 선택 행에서 입력칸에 넣을 필드 (예: customerCode) */
  returnKey: string;
  /** 선택 행 전체가 필요할 때 */
  onPick?: (row: PopupRow) => void;
}

/** React 가 관리하는 input 에 값을 넣고 onChange 가 실행되도록 input 이벤트를 발생시킨다 */
function setNativeInputValue(el: HTMLInputElement, value: string) {
  const setter = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, "value")?.set;
  setter?.call(el, value);
  el.dispatchEvent(new Event("input", { bubbles: true }));
}

const PopupSearchField = forwardRef<HTMLInputElement, PopupSearchFieldProps>(function PopupSearchField(
  { popupId, returnKey, onPick, disabled, readOnly, ...inputProps },
  ref,
) {
  const inputRef = useRef<HTMLInputElement>(null);
  useImperativeHandle(ref, () => inputRef.current as HTMLInputElement);
  const [open, setOpen] = useState(false);
  const [initial, setInitial] = useState<Record<string, string>>({});

  const openModal = () => {
    const typed = inputRef.current?.value ?? "";
    setInitial(typed ? { [returnKey]: typed } : {});
    setOpen(true);
  };

  const handleSelect = (row: PopupRow) => {
    const el = inputRef.current;
    if (el) {
      setNativeInputValue(el, String(row[returnKey] ?? ""));
      el.focus();
    }
    onPick?.(row);
    setOpen(false);
  };

  return (
    <>
      <Input
        ref={inputRef}
        disabled={disabled}
        readOnly={readOnly}
        {...inputProps}
        rightIcon={
          <button
            type="button"
            onClick={openModal}
            disabled={Boolean(disabled || readOnly)}
            aria-label="조회"
            title="조회"
            className="flex items-center text-text-muted hover:text-primary disabled:opacity-40 disabled:cursor-not-allowed"
          >
            <Search className="h-4 w-4" />
          </button>
        }
      />
      {open && (
        <SearchSelectModal
          popupId={popupId}
          isOpen={open}
          onClose={() => setOpen(false)}
          onSelect={handleSelect}
          initialFilters={initial}
        />
      )}
    </>
  );
});

export default PopupSearchField;

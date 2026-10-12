"use client";

/**
 * @file src/components/shared/PartSearchField.tsx
 * @description 품목코드 입력 필드 — 직접 입력 + 돋보기 버튼으로 품목 조회 모달(PartSearchModal) 선택
 *
 * 조회 필터·폼의 품목코드 자유 입력칸을 대체하는 공용 컴포넌트다.
 * `Input` 과 같은 props 를 그대로 받으므로 기존 `<Input ... />` 을 `<PartSearchField ... />` 로 바꾸면 된다.
 *
 * 초보자 가이드:
 * 1. **직접 입력**: 기존처럼 타이핑·Enter 조회가 그대로 동작한다 (앞부분 일치 검색 유지)
 * 2. **돋보기 버튼**: 품목 조회 모달을 연다. 입력해 둔 값이 있으면 그 값으로 바로 검색한다
 * 3. **선택 반영**: 모달에서 고른 품목코드를 입력칸에 넣고, 화면의 onChange 를 실제 input 이벤트로 호출한다
 *    (화면마다 onChange 형태가 달라도 수정 없이 동작하도록 네이티브 value setter + input 이벤트 사용)
 * 4. **onPartSelect**: 품목명 등 다른 값이 필요하면 선택된 PartItem 을 받는다
 *
 * 사용 예:
 *   <PartSearchField placeholder="품목코드" value={itemCode} className="w-40"
 *     onChange={(e) => setItemCode(e.target.value)}
 *     onKeyDown={(e) => { if (e.key === 'Enter') void search(); }} />
 */

import { forwardRef, useImperativeHandle, useRef, useState } from "react";
import { Search } from "lucide-react";
import Input, { type InputProps } from "@/components/ui/Input";
import PartSearchModal, { type PartItem } from "./PartSearchModal";

export interface PartSearchFieldProps extends Omit<InputProps, "rightIcon"> {
  /** 모달에서 품목을 선택했을 때 추가로 호출 (품목명 등 함께 쓰는 화면용) */
  onPartSelect?: (part: PartItem) => void;
  /** 모달 품목유형 사전 필터 */
  itemType?: string;
  /** 모달 허용 품목유형 제한 */
  allowedItemTypes?: string[];
}

/** React 가 관리하는 input 에 값을 넣고 onChange 가 실행되도록 input 이벤트를 발생시킨다 */
function setNativeInputValue(el: HTMLInputElement, value: string) {
  const setter = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, "value")?.set;
  setter?.call(el, value);
  el.dispatchEvent(new Event("input", { bubbles: true }));
}

const PartSearchField = forwardRef<HTMLInputElement, PartSearchFieldProps>(function PartSearchField(
  { onPartSelect, itemType, allowedItemTypes, disabled, readOnly, ...inputProps },
  ref,
) {
  const inputRef = useRef<HTMLInputElement>(null);
  useImperativeHandle(ref, () => inputRef.current as HTMLInputElement);
  const [open, setOpen] = useState(false);
  const [keyword, setKeyword] = useState("");

  const locked = Boolean(disabled || readOnly);

  const openModal = () => {
    setKeyword(inputRef.current?.value ?? "");
    setOpen(true);
  };

  const handleSelect = (part: PartItem) => {
    const el = inputRef.current;
    if (el) {
      setNativeInputValue(el, part.itemCode);
      el.focus();
    }
    onPartSelect?.(part);
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
            disabled={locked}
            aria-label="품목 조회"
            title="품목 조회"
            className="flex items-center text-text-muted hover:text-primary disabled:opacity-40 disabled:cursor-not-allowed"
          >
            <Search className="h-4 w-4" />
          </button>
        }
      />
      <PartSearchModal
        isOpen={open}
        onClose={() => setOpen(false)}
        onSelect={handleSelect}
        itemType={itemType}
        allowedItemTypes={allowedItemTypes}
        initialKeyword={keyword}
      />
    </>
  );
});

export default PartSearchField;

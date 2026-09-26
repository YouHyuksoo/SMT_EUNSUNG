"use client";

/**
 * @file src/app/(authenticated)/mold/components/MoldCodeField.tsx
 * @description S-PARTS 코드 / 보관위치 입력 — PB 조회팝업(w_mcn_mold_popup,
 *              w_mcn_mold_location_popup)을 팝업 레지스트리로 연결한 입력 필드.
 *
 * 초보자 가이드:
 * 1. **코드성 값을 자유 입력으로 두지 않는다.** PB 도 이 칸에서 오른클릭·버튼으로
 *    조회팝업을 띄웠다. 타이핑도 되게 두되(현장에서 코드를 외운 경우가 많다)
 *    돋보기로 팝업을 열 수 있게 한다.
 * 2. 팝업은 전용 컴포넌트가 아니라 **엔진 설정형**이다 — 카탈로그 엔트리 id 만 넘기면
 *    필터·컬럼·조회 SQL 이 레지스트리와 백엔드 화이트리스트에서 온다.
 * 3. S-PARTS 를 고르면 코드만 쓰는 화면도 있고 버전·SET번호까지 받는 화면도 있다.
 *    그래서 `onPick` 으로 선택 행 전체를 넘긴다(PB 전역구조체 다중 반환과 같은 이유).
 */
import { useState } from 'react';
import { Search } from 'lucide-react';
import SearchSelectModal, { type PopupRow } from '@/components/popups/SearchSelectModal';
import { Input } from '@/components/ui';

interface Props {
  /** 'mold-search' = S-PARTS 검색, 'mold-location-search' = 보관위치 검색 */
  popupId: 'mold-search' | 'mold-location-search';
  /** 팝업에서 값을 읽어 올 필드명 */
  returnKey: string;
  value: string;
  onChange: (value: string) => void;
  /** 선택 행 전체가 필요할 때 (버전·SET번호·공급처 등) */
  onPick?: (row: PopupRow) => void;
  label?: string;
  placeholder?: string;
  className?: string;
  disabled?: boolean;
  /** Enter 로 바로 다음 동작을 실행하는 화면용 */
  onEnter?: () => void;
}

export default function MoldCodeField({
  popupId, returnKey, value, onChange, onPick,
  label, placeholder, className = 'w-48', disabled, onEnter,
}: Props) {
  const [open, setOpen] = useState(false);

  return (
    <>
      <Input
        aria-label={label ?? placeholder ?? returnKey}
        placeholder={placeholder}
        value={value}
        disabled={disabled}
        className={className}
        onChange={(event) => onChange(event.target.value)}
        onKeyDown={(event) => { if (event.key === 'Enter' && onEnter) onEnter(); }}
        rightIcon={
          <button
            type="button"
            aria-label={`${label ?? placeholder ?? ''} 검색`}
            disabled={disabled}
            onClick={() => setOpen(true)}
            className="text-text-muted hover:text-text disabled:opacity-40"
          >
            <Search className="h-4 w-4" />
          </button>
        }
      />
      <SearchSelectModal
        popupId={popupId}
        isOpen={open}
        onClose={() => setOpen(false)}
        onSelect={(row) => {
          onChange(String(row[returnKey] ?? ''));
          onPick?.(row);
          setOpen(false);
        }}
      />
    </>
  );
}

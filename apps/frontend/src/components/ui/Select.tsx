"use client";

/**
 * @file src/components/ui/Select.tsx
 * @description 셀렉트박스 컴포넌트
 */
import { forwardRef, SelectHTMLAttributes } from 'react';
import { ChevronDown } from 'lucide-react';

export interface SelectOption {
  value: string;
  label: string;
}

export interface SelectProps extends Omit<SelectHTMLAttributes<HTMLSelectElement>, 'value' | 'onChange'> {
  label?: string;
  error?: string;
  options: SelectOption[];
  value?: string | number;
  onChange?: (value: string) => void;
  fullWidth?: boolean;
  placeholder?: string;
}

const Select = forwardRef<HTMLSelectElement, SelectProps>(
  ({ className = '', label, error, options, value, onChange, fullWidth = false, placeholder, disabled, required, id, ...props }, ref) => {
    const effectivePlaceholder = placeholder || label || '전체';
    const inputId = id || label?.toLowerCase().replace(/\s+/g, '-');
    // 저장된 값이 목록에 없으면(사용 중지된 코드, 옛 데이터, 목록 로딩 전) 그 값을 그대로 옵션으로 붙인다.
    // 없으면 브라우저가 첫 옵션(안내문)을 보여 줘 값이 빈 것처럼 보인다.
    const strValue = value === undefined || value === null ? '' : String(value);
    const shownOptions = strValue !== '' && !options.some(o => String(o.value) === strValue)
      ? [...options, { value: strValue, label: strValue }]
      : options;
    // 폭을 채우지 않는 셀렉트는 감싸는 칸도 박스 폭에 맞춘다. 칸이 줄 전체면 화살표가 박스 밖 오른쪽 끝에 뜬다.
    // 박스는 max-w-full 로 부모 폭을 넘지 않는다 — 긴 옵션이 고정폭 칸 밖으로 넘쳐 옆 버튼을 덮지 않게.
    const fill = fullWidth || /(^|\s)w-full(\s|$)/.test(className);

    return (
      <div className={fullWidth ? 'w-full' : ''}>
        {label && (
          <label htmlFor={inputId} className="block text-sm font-medium text-text mb-1.5">
            {label}
            {required && <span className="text-red-500 ml-0.5">*</span>}
          </label>
        )}

        <div className={fill ? 'relative' : 'relative inline-block max-w-full align-top'}>
          <select
            ref={ref}
            id={inputId}
            disabled={disabled}
            required={required}
            value={value}
            onChange={(e) => onChange?.(e.target.value)}
            className={`
              h-10 px-3 pr-10 bg-surface border border-border rounded-lg
              text-text text-sm transition-all duration-200
              focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent
              disabled:opacity-50 disabled:cursor-not-allowed
              appearance-none cursor-pointer max-w-full
              ${error ? 'border-red-500 focus:ring-red-500' : ''}
              ${fullWidth ? 'w-full' : ''}
              ${!value ? 'text-text-muted' : ''}
              ${className}
            `}
            {...props}
          >
            {!shownOptions.some(o => o.value === "") && (
              <option value="" disabled>{effectivePlaceholder}</option>
            )}
            {shownOptions.map((option, idx) => (
              <option key={`${option.value}-${idx}`} value={option.value}>{option.label}</option>
            ))}
          </select>

          <div className="absolute right-3 top-1/2 -translate-y-1/2 pointer-events-none text-text-muted">
            <ChevronDown className="w-4 h-4" />
          </div>
        </div>

        {error && <p className="mt-1.5 text-sm text-red-500">{error}</p>}
      </div>
    );
  }
);

Select.displayName = 'Select';

export default Select;

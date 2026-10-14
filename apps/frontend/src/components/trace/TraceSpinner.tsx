/**
 * @file src/components/trace/TraceSpinner.tsx
 * @description 추적 화면용 스피너. 공용 Spinner 에 라벨(가로/세로)을 붙인다.
 */
'use client';

import Spinner from '@/components/ui/Spinner';

interface Props {
  size?: 'sm' | 'md' | 'lg';
  label?: string;
  vertical?: boolean;
  className?: string;
  labelClassName?: string;
}

export default function TraceSpinner({
  size = 'md',
  label,
  vertical = false,
  className = '',
  labelClassName = '',
}: Props) {
  return (
    <div className={`inline-flex items-center justify-center ${vertical ? 'flex-col gap-2' : 'flex-row gap-3'} ${className}`}>
      <Spinner size={size} />
      {label && <span className={`text-sm text-text-muted ${labelClassName}`}>{label}</span>}
    </div>
  );
}

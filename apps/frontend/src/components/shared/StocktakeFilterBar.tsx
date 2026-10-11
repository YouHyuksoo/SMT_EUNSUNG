"use client";

/**
 * @file src/components/shared/StocktakeFilterBar.tsx
 * @description 재고실사 실사표 조회조건 — 자재·공정·제품재고실사가 같이 쓴다
 *
 * 초보자 가이드:
 * 1. 상태(전체 · 차이만 · 안 센 것만)와 앞부분 검색칸 두 개로 실사표를 좁힌다.
 * 2. 검색칸의 뜻은 재고 종류마다 다르다 (자재: 품목코드·롯트, 공정: 품목코드·품목명, 제품: 박스 바코드·모델).
 * 3. `truncatedLimit` 을 주면 일부만 표시한다는 안내가 붙는다.
 */
import { Card, CardContent, Input, Select } from '@/components/ui';

export type StocktakeStatusFilter = '' | 'diff' | 'unscanned';

export interface StocktakeFilterField {
  key: string;
  label: string;
  value: string;
  onChange: (value: string) => void;
  className?: string;
}

interface Props {
  status: StocktakeStatusFilter;
  onStatusChange: (status: StocktakeStatusFilter) => void;
  fields: StocktakeFilterField[];
  /** 일부만 표시 중이면 그 최대 행 수 */
  truncatedLimit?: number | null;
}

/** 앞부분 일치 (대소문자 무시). 조건이 비어 있으면 통과. */
export const startsWithCond = (value: string | null | undefined, cond: string) =>
  !cond.trim() || (value ?? '').toUpperCase().startsWith(cond.trim().toUpperCase());

export default function StocktakeFilterBar({ status, onStatusChange, fields, truncatedLimit }: Props) {
  return (
    <Card padding="none">
      <CardContent className="flex flex-wrap items-center gap-3 p-3">
        <Select aria-label="상태" placeholder="전체" value={status}
          onChange={(v) => onStatusChange(v as StocktakeStatusFilter)}
          options={[{ value: '', label: '전체' }, { value: 'diff', label: '차이만' }, { value: 'unscanned', label: '안 센 것만' }]} />
        {fields.map((f) => (
          <Input key={f.key} aria-label={f.label} placeholder={`${f.label} (앞부분)`}
            className={f.className ?? 'w-56'} value={f.value}
            onChange={(e) => f.onChange(e.target.value)} />
        ))}
        {truncatedLimit ? (
          <span className="text-sm text-amber-500">
            일부만 표시합니다 (최대 {truncatedLimit.toLocaleString()}행). 조건으로 좁혀 보세요.
          </span>
        ) : null}
      </CardContent>
    </Card>
  );
}

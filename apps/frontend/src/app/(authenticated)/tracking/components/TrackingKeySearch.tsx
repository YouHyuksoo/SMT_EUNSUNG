"use client";

/**
 * @file src/app/(authenticated)/tracking/components/TrackingKeySearch.tsx
 * @description 추적 화면의 키 입력줄. 313·314·315·317 이 공유한다.
 *
 * 초보자 가이드:
 * 1. **키가 없으면 조회 버튼이 눌리지 않는다.** 추적이 읽는 표는 1억행이 넘어서
 *    조건 없이 열면 화면이 아니라 DB 가 멈춘다. 판정은 `@smt/shared` 의
 *    checkTrackingFilter 가 하고 **백엔드도 같은 함수로 거부한다** — 규칙을
 *    두 곳에 두면 한쪽만 고쳐진다.
 * 2. **스캐너는 키보드로 동작한다.** 별도 연동이 없고 입력 필드에 그대로 찍힌다.
 *    그래서 Enter 로 바로 조회한다.
 * 3. **바코드를 넣어도 된다** (313·315). 서버가 PB 와 같은 DB 함수로 제조번호를
 *    뽑는다. 무엇으로 찾았는지 오른쪽에 되돌려 보여준다.
 */
import { useCallback, useMemo } from 'react';
import { Search } from 'lucide-react';
import { checkTrackingFilter } from '@smt/shared';
import { Button, Card, CardContent, Input } from '@/components/ui';

export interface TrackingKeySearchProps {
  /** 입력 라벨 — '자재 제조번호 / 바코드' 처럼 무엇을 넣는지 적는다 */
  label: string;
  /** 키 종류. 판정과 백엔드 파라미터 이름이 여기서 갈린다. */
  keyKind: 'lotNo' | 'serialNo' | 'runNo';
  value: string;
  onChange: (value: string) => void;
  onSearch: () => void;
  loading?: boolean;
  /** 서버가 실제로 무엇으로 찾았는지 (바코드 → 제조번호 변환 결과) */
  resolvedNote?: string | null;
  /** 오른쪽에 덧붙일 조건 (모델·기간 등) */
  children?: React.ReactNode;
}

export default function TrackingKeySearch({
  label,
  keyKind,
  value,
  onChange,
  onSearch,
  loading,
  resolvedNote,
  children,
}: TrackingKeySearchProps) {
  const verdict = useMemo(() => checkTrackingFilter({ [keyKind]: value }), [keyKind, value]);

  const submit = useCallback(() => {
    if (!verdict.ok || loading) return;
    onSearch();
  }, [verdict.ok, loading, onSearch]);

  return (
    <Card padding="none">
      <CardContent className="flex flex-wrap items-center gap-3 p-3">
        <label className="flex items-center gap-2 text-sm text-text">
          {label}
          <Input
            aria-label={label}
            placeholder={label}
            value={value}
            className="w-64"
            autoFocus
            onChange={(e) => onChange(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === 'Enter') submit();
            }}
          />
        </label>
        <Button size="sm" onClick={submit} disabled={!verdict.ok || loading}>
          <Search className="mr-1 h-4 w-4" />조회
        </Button>
        {children}
        {!verdict.ok && (
          <span className="text-sm text-amber-500">{verdict.reason}</span>
        )}
        {verdict.ok && resolvedNote && (
          <span className="text-sm text-text-muted">{resolvedNote}</span>
        )}
      </CardContent>
    </Card>
  );
}

/**
 * @file src/components/data-grid/utils.ts
 * @description DataGrid 공통 유틸리티 함수 모음
 *
 * 초보자 가이드:
 * 1. **detectAlignment**: 셀 값의 타입을 분석하여 텍스트 정렬 방향 자동 결정
 *    - 숫자 → 우측(right), 날짜 → 중앙(center), 문자 → 좌측(left)
 * 2. **getAlignmentClass**: 정렬 방향에 맞는 Tailwind CSS 클래스 반환
 * 3. **getPinnedStyle**: 고정 컬럼(pinned column)에 필요한 sticky 스타일 생성
 * 4. **withLeadingPinnedColumns**: 좌측 고정이 있으면 관리→선택→품목코드→품목명 컬럼을 고정 맨 앞에 넣는다
 * 5. 이 파일은 DataGrid 내부에서만 사용되는 헬퍼로, 외부 직접 사용은 불필요
 */
import React from 'react';

/** 날짜 패턴 감지 (YYYY-MM-DD, YYYY/MM/DD, YYYY.MM.DD, DD-MM-YYYY 등) */
const datePatterns = [
  /^\d{4}[-/.]\d{2}[-/.]\d{2}$/,
  /^\d{4}[-/.]\d{2}[-/.]\d{2}\s+\d{2}:\d{2}(:\d{2})?$/,
  /^\d{2}[-/.]\d{2}[-/.]\d{4}$/,
  /^\d{4}년\s*\d{1,2}월\s*\d{1,2}일$/,
];

/** 값 타입 감지하여 정렬 방향 결정 */
export function detectAlignment(value: unknown): 'left' | 'center' | 'right' {
  if (value === null || value === undefined) return 'left';
  if (typeof value === 'number') return 'right';
  if (typeof value === 'string') {
    const trimmed = value.trim();
    if (/^-?[\d,]+(\.\d+)?$/.test(trimmed) || /^-?\d+(\.\d+)?%$/.test(trimmed)) {
      return 'right';
    }
    for (const pattern of datePatterns) {
      if (pattern.test(trimmed)) return 'center';
    }
  }
  if (value instanceof Date) return 'center';
  return 'left';
}

/** 정렬 클래스 반환 */
export function getAlignmentClass(align: 'left' | 'center' | 'right'): string {
  switch (align) {
    case 'right': return 'text-right';
    case 'center': return 'text-center';
    default: return 'text-left';
  }
}

/** 고정 컬럼(pinned column)용 인라인 스타일 생성 */
export function getPinnedStyle(
  pinned: false | 'left' | 'right',
  startLeft: number,
  afterRight: number,
  isLastLeft: boolean,
  isFirstRight: boolean,
  zIndex: number,
): React.CSSProperties {
  return {
    ...(pinned === 'left' ? { position: 'sticky', left: startLeft, zIndex } : {}),
    ...(pinned === 'right' ? { position: 'sticky', right: afterRight, zIndex } : {}),
    ...(isLastLeft ? { boxShadow: '4px 0 8px -2px rgba(0,0,0,0.1)' } : {}),
    ...(isFirstRight ? { boxShadow: '-4px 0 8px -2px rgba(0,0,0,0.1)' } : {}),
  };
}

/**
 * 그리드 앞쪽 고정 순서: 관리 → 선택 체크박스 → 품목코드 → 품목명.
 * 컬럼 배열 순서는 gridItemColumnOrder.structure.test.mjs 가 강제하지만, 화면이 다른 컬럼(예: issueDate)을
 * 좌측 고정하면 고정 컬럼이 먼저 그려져 그 순서가 깨진다. 그래서 좌측 고정 목록 앞에도 같은 순서로 넣는다.
 */
export const LEADING_COLUMN_IDS = ['actions', 'select', 'check', 'itemCode', 'itemName'] as const;

export function withLeadingPinnedColumns(
  pinning: { left?: string[]; right?: string[] } | undefined,
  columnIds: string[],
): { left?: string[]; right?: string[] } {
  if (!pinning?.left?.length) return pinning ?? {};
  const present = new Set(columnIds);
  const leading: string[] = LEADING_COLUMN_IDS.filter((id) => present.has(id));
  return {
    ...pinning,
    left: [...leading, ...pinning.left.filter((id) => !leading.includes(id))],
  };
}

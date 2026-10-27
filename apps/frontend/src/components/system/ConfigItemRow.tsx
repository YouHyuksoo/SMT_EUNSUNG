'use client';

/**
 * @file components/system/ConfigItemRow.tsx
 * @description 환경설정 개별 항목 행 - 타입별 입력 UI (토글/선택/숫자/텍스트)
 *
 * 초보자 가이드:
 * 1. BOOLEAN: 토글 스위치 (Y/N)
 * 2. SELECT: 드롭다운 (options JSON 파싱)
 * 3. NUMBER: 숫자 입력 필드
 * 4. TEXT: 텍스트 입력 필드
 * 5. 변경된 항목은 좌측 파란 보더로 강조
 * 6. locked 면 값을 바꾸거나 지울 수 없다 (관리자 전용 키를 관리자가 아닌 사람이 볼 때)
 */
import { useMemo } from 'react';
import { Lock, Trash2 } from 'lucide-react';
import { Input, Select } from '@/components/ui';
import type { SysConfigItem } from '@/stores/sysConfigStore';

interface Props {
  config: SysConfigItem;
  currentValue: string;
  isChanged: boolean;
  onValueChange: (value: string) => void;
  onDelete: () => void;
  /** 관리자만 바꿀 수 있는 키라 잠근다 */
  locked?: boolean;
}

export default function ConfigItemRow({ config, currentValue, isChanged, onValueChange, onDelete, locked = false }: Props) {
  const selectOptions = useMemo(() => {
    if (config.configType !== 'SELECT' || !config.options) return [];
    try {
      return JSON.parse(config.options) as { value: string; label: string }[];
    } catch {
      return [];
    }
  }, [config.configType, config.options]);

  return (
    <div
      className={`flex items-center gap-3 py-2.5 px-3 rounded-lg border transition-colors ${
        isChanged
          ? 'border-primary bg-primary/5 dark:bg-primary/10'
          : 'border-border'
      }`}
    >
      {/* 라벨 + 설명 */}
      <div className="flex-1 min-w-0">
        <div className="font-medium text-sm text-text truncate">{config.label}</div>
        {config.description && (
          <div className="text-xs text-text-muted mt-0.5 line-clamp-2">{config.description}</div>
        )}
        <div className="text-xs text-text-muted/60 mt-0.5 font-mono truncate">{config.configKey}</div>
        {locked && (
          <div className="mt-0.5 flex items-center gap-1 text-xs text-text-muted">
            <Lock className="h-3 w-3" />관리자만 바꿀 수 있습니다
          </div>
        )}
      </div>

      {/* 입력 UI */}
      <div className="w-44 sm:w-52 flex-shrink-0">
        {config.configType === 'BOOLEAN' && (
          <button
            type="button"
            disabled={locked}
            onClick={() => onValueChange(currentValue === 'Y' ? 'N' : 'Y')}
            className={`relative inline-flex h-7 w-12 items-center rounded-full transition-colors disabled:cursor-not-allowed disabled:opacity-60 ${
              currentValue === 'Y'
                ? 'bg-primary'
                : 'bg-gray-300 dark:bg-gray-600'
            }`}
          >
            <span
              className={`inline-block h-5 w-5 rounded-full bg-white shadow transition-transform ${
                currentValue === 'Y' ? 'translate-x-6' : 'translate-x-1'
              }`}
            />
            <span className="sr-only">{config.label}</span>
          </button>
        )}

        {config.configType === 'SELECT' && (
          <Select
            options={selectOptions}
            value={currentValue}
            onChange={onValueChange}
            disabled={locked}
            fullWidth
          />
        )}

        {config.configType === 'NUMBER' && (
          <Input
            type="number"
            value={currentValue}
            onChange={(e) => onValueChange(e.target.value)}
            disabled={locked}
            fullWidth
          />
        )}

        {config.configType === 'TEXT' && (
          <Input
            value={currentValue}
            onChange={(e) => onValueChange(e.target.value)}
            disabled={locked}
            fullWidth
          />
        )}
      </div>

      {/* 삭제 버튼 */}
      <button
        type="button"
        onClick={onDelete}
        disabled={locked}
        className="p-1.5 text-text-muted hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 rounded transition-colors disabled:cursor-not-allowed disabled:opacity-40"
        title="삭제"
      >
        <Trash2 className="w-4 h-4" />
      </button>
    </div>
  );
}

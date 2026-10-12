"use client";

/**
 * @file src/app/(authenticated)/smt/components/SmtSelects.tsx
 * @description SMT 화면들이 쓰는 코드성 셀렉터.
 *
 * 왜 이 파일이 필요한가:
 *   - **설비(MACHINE)는 IB_LINE_MASTER 에만 있다.** 공용 LineSelect/ProdLineSelect 는
 *     IP_PRODUCT_LINE 을 읽으므로 설비를 낼 수 없다. PB vd_smt_machine_code 와 같다.
 *   - **모델은 IP_PRODUCT_MODEL_MASTER 다** (PB d_smt_bom_model_list, 327행).
 *   조회조건을 자유 입력으로 두면 레거시가 막던 오입력이 웹에서 통과하므로
 *   두 값 모두 셀렉터로 만든다.
 *
 * 라인 셀렉터는 새로 만들지 않는다 — 공용 ProdLineSelect(IP_PRODUCT_LINE)가
 * PB vd_line_code 와 같은 원천이다.
 */
import { useEffect, useMemo, useState } from 'react';
import Select from '@/components/ui/Select';
import type { SelectProps } from '@/components/ui/Select';
import api from '@/services/api';

interface Option { value: string; label: string }

/** 한 번 읽어 화면이 살아 있는 동안 재사용한다. 둘 다 수백 건 이하다. */
function useRemoteOptions(path: string, toOption: (row: Record<string, unknown>) => Option) {
  const [options, setOptions] = useState<Option[]>([]);
  const [isLoading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    api.get(path)
      .then((response) => {
        if (cancelled) return;
        const rows: Record<string, unknown>[] = response.data?.data ?? [];
        setOptions(rows.map(toOption));
      })
      .catch(() => {
        if (!cancelled) setOptions([]);
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });
    return () => { cancelled = true; };
    // path 는 상수로 넘어온다. toOption 은 렌더마다 새로 만들어지므로 의존성에 넣지 않는다.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [path]);

  return { options, isLoading };
}

interface WrapperProps extends Omit<SelectProps, 'options'> {
  /** 필터용: 라벨 앞에 접두어 + '전체' 옵션 */
  labelPrefix?: string;
  /** 필터용: 접두어 없이 '전체'(값 '') 만 맨 앞에 추가 */
  includeAll?: boolean;
}

function withAll(options: Option[], labelPrefix?: string, includeAll?: boolean) {
  if (labelPrefix) {
    return [
      { value: '', label: `${labelPrefix}: 전체` },
      ...options.map((o) => ({ ...o, label: `${labelPrefix}: ${o.label}` })),
    ];
  }
  return includeAll ? [{ value: '', label: '전체' }, ...options] : options;
}

/** 설비 셀렉터 — PB vd_smt_machine_code (IB_LINE_MASTER.MACHINE) */
export function SmtMachineSelect({ labelPrefix, includeAll, ...props }: WrapperProps) {
  const { options, isLoading } = useRemoteOptions('/smt/line/machines', (row) => ({
    value: String(row.machine ?? ''),
    label: row.machineName ? `${String(row.machineName)} (${String(row.machine)})` : String(row.machine ?? ''),
  }));
  const finalOptions = useMemo(
    () => withAll(options, labelPrefix, includeAll),
    [options, labelPrefix, includeAll],
  );
  return <Select options={finalOptions} disabled={isLoading || props.disabled} {...props} />;
}

/** 모델 셀렉터 — PB d_smt_bom_model_list (IP_PRODUCT_MODEL_MASTER) */
export function SmtModelSelect({ labelPrefix, includeAll, ...props }: WrapperProps) {
  const { options, isLoading } = useRemoteOptions('/smt/bom/models', (row) => ({
    value: String(row.modelName ?? ''),
    label: String(row.modelName ?? ''),
  }));
  const finalOptions = useMemo(
    () => withAll(options, labelPrefix, includeAll),
    [options, labelPrefix, includeAll],
  );
  return <Select options={finalOptions} disabled={isLoading || props.disabled} {...props} />;
}

/**
 * PCB 면 셀렉터. ISYS_BASECODE 'PCB ITEM' 에 2건 있으므로 공용 ComCodeSelect 로도 되지만,
 * 배포·비교 API 가 'T'/'B' 만 받으므로 그 두 값으로 못박아 오입력을 막는다.
 */
export function SmtPcbItemSelect({ labelPrefix, includeAll, ...props }: WrapperProps) {
  const finalOptions = useMemo(
    () => withAll([{ value: 'T', label: '앞면 (T)' }, { value: 'B', label: '뒷면 (B)' }],
      labelPrefix, includeAll),
    [labelPrefix, includeAll],
  );
  return <Select options={finalOptions} {...props} />;
}

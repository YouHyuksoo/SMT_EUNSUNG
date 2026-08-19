/**
 * @file src/components/shared/ProcessSelect.tsx
 * @description 공정 셀렉터 래퍼 - useProcessOptions 훅 + Select UI
 *
 * 사용 예:
 *   필터: <ProcessSelect value={v} onChange={fn} labelPrefix="공정" fullWidth />
 *   폼:   <ProcessSelect value={v} onChange={fn} fullWidth />
 */

import { useMemo } from "react";
import Select from "@/components/ui/Select";
import type { SelectProps } from "@/components/ui/Select";
import { useProcessOptions } from "@/hooks/useMasterOptions";
import { useComCodeMap } from "@/hooks/useComCode";
import { buildProcessOptions } from "./processOptions.mjs";

interface ProcessSelectProps extends Omit<SelectProps, "options"> {
  /** 필터용: 모든 옵션 라벨 앞에 접두어 추가 + "전체" 옵션 자동 추가 */
  labelPrefix?: string;
  /** 공정코드 | 공정명 | 공정유형 형식으로 표시 */
  showProcessType?: boolean;
}

export default function ProcessSelect({ labelPrefix, showProcessType = false, ...props }: ProcessSelectProps) {
  const { options, isLoading, rawData } = useProcessOptions();
  const processTypeMap = useComCodeMap("WORKSTAGE TYPE");
  const displayOptions = useMemo(
    () => showProcessType ? buildProcessOptions(rawData, processTypeMap, showProcessType) : options,
    [options, processTypeMap, rawData, showProcessType],
  );
  const finalOptions = useMemo(() => {
    if (!labelPrefix) return displayOptions;
    return [
      { value: "", label: `${labelPrefix}: 전체` },
      ...displayOptions.map(o => ({ ...o, label: `${labelPrefix}: ${o.label}` })),
    ];
  }, [displayOptions, labelPrefix]);
  return <Select options={finalOptions} disabled={isLoading || props.disabled} {...props} />;
}

/**
 * @file src/components/shared/ProdLineSelect.tsx
 * @description 생산라인 셀렉터 - useProdLineOptions 훅 + Select UI
 *   생산라인관리(IP_PRODUCT_LINE) 데이터를 참조하며, 옵션 라벨은 "라인코드 - 라인명 - 라인구분",
 *   내부 저장/전달 값은 라인코드다.
 *
 * 사용 예:
 *   <ProdLineSelect value={lineCode} onChange={setLineCode} fullWidth />
 */

import { useMemo } from "react";
import Select from "@/components/ui/Select";
import type { SelectProps } from "@/components/ui/Select";
import { useProdLineOptions } from "@/hooks/useMasterOptions";

interface ProdLineSelectProps extends Omit<SelectProps, "options"> {
  /** 필터용: 모든 옵션 라벨 앞에 접두어 추가 + "전체" 옵션 자동 추가 */
  labelPrefix?: string;
  /** '미지정'(값 '*') 옵션을 선택 가능하도록 맨 앞에 추가 */
  includeUnassigned?: boolean;
}

export default function ProdLineSelect({ labelPrefix, includeUnassigned, ...props }: ProdLineSelectProps) {
  const { options, isLoading } = useProdLineOptions();
  const finalOptions = useMemo(() => {
    const base = includeUnassigned ? [{ value: "*", label: "미지정" }, ...options] : options;
    if (!labelPrefix) return base;
    return [
      { value: "", label: `${labelPrefix}: 전체` },
      ...base.map((o) => ({ ...o, label: `${labelPrefix}: ${o.label}` })),
    ];
  }, [options, labelPrefix, includeUnassigned]);
  return <Select options={finalOptions} disabled={isLoading || props.disabled} {...props} />;
}

"use client";

import Select, { type SelectProps } from "@/components/ui/Select";
import { useSupplierOptions } from "@/hooks/useMasterOptions";

interface SupplierSelectProps extends Omit<SelectProps, "options"> {
  includeAll?: boolean;
  /** ComCodeSelect와 동일 규약. 필터용 접두어 (예: "공급처: 전체") */
  labelPrefix?: string;
}

export default function SupplierSelect({ includeAll = false, labelPrefix, ...props }: SupplierSelectProps) {
  const { options, isLoading } = useSupplierOptions();
  const baseOptions = includeAll ? [{ value: "", label: "전체" }, ...options] : options;
  const finalOptions = labelPrefix
    ? baseOptions.map(o => ({ ...o, label: `${labelPrefix}: ${o.label}` }))
    : baseOptions;
  return (
    <Select
      {...props}
      disabled={props.disabled || isLoading}
      options={finalOptions}
    />
  );
}

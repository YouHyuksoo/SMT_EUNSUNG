"use client";

import Select, { type SelectProps } from "@/components/ui/Select";
import { useSupplierOptions } from "@/hooks/useMasterOptions";

interface SupplierSelectProps extends Omit<SelectProps, "options"> {
  includeAll?: boolean;
}

export default function SupplierSelect({ includeAll = false, ...props }: SupplierSelectProps) {
  const { options, isLoading } = useSupplierOptions();
  return (
    <Select
      {...props}
      disabled={props.disabled || isLoading}
      options={includeAll ? [{ value: "", label: "전체" }, ...options] : options}
    />
  );
}

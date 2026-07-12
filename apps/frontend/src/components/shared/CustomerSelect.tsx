"use client";
import Select, { type SelectProps } from "@/components/ui/Select";
import { useCustomerOptions } from "@/hooks/useMasterOptions";
export default function CustomerSelect({ includeAll=false, ...props }: Omit<SelectProps,"options"> & { includeAll?: boolean }) { const { options, isLoading }=useCustomerOptions(); return <Select {...props} disabled={props.disabled||isLoading} options={includeAll?[{value:"",label:"전체"},...options]:options}/>; }

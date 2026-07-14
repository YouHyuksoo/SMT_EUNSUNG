import type { ColumnDef } from "@tanstack/react-table";
import { ComCodeBadge } from "@/components/ui";
import type { ItemSupplierItem } from "./types";
const d=(v?:string)=>v?.slice(0,10)??"-",n=(v?:number)=>v==null?"-":v.toLocaleString();
const c=(g:string,v:unknown)=><ComCodeBadge groupCode={g} code={String(v??"")}/>;
export const itemSupplierColumns=():ColumnDef<ItemSupplierItem,unknown>[]=>[
 {accessorKey:"itemCode",header:"품목코드",size:130},{accessorKey:"itemName",header:"품목명",size:180},{accessorKey:"supplierCode",header:"공급처코드",size:110},{accessorKey:"supplierName",header:"공급처명",size:160},
 {accessorKey:"dateset",header:"시작일",cell:({getValue})=>d(getValue<string>()),size:95},{accessorKey:"dateend",header:"종료일",cell:({getValue})=>d(getValue<string>()),size:95},
 {accessorKey:"orderType",header:"발주형태",cell:({getValue})=>c("ORDER_TYPE",getValue()),size:85},{accessorKey:"orderRate",header:"발주율",cell:({getValue})=>n(getValue<number>()),size:75},{accessorKey:"orderLeadtime",header:"리드타임",size:80},{accessorKey:"orderBadRate",header:"불량률",size:75},
 {accessorKey:"mimOrderQty",header:"최소발주량",cell:({getValue})=>n(getValue<number>()),size:95},{accessorKey:"packingQty",header:"포장수량",cell:({getValue})=>n(getValue<number>()),size:85},
 {accessorKey:"mainVendorYn",header:"주거래선",cell:({getValue})=>c("MAIN_VENDOR_YN",getValue()),size:85},{accessorKey:"paymentType",header:"지불유형",cell:({getValue})=>c("PAYMENT_TYPE",getValue()),size:85},
 {accessorKey:"inspectMethod",header:"검사방법",cell:({getValue})=>c("INSPECT_METHOD",getValue()),size:85},{accessorKey:"inspectRule",header:"검사여부",cell:({getValue})=>c("INSPECT_RULE",getValue()),size:85},
 {accessorKey:"longtermDeliveryYn",header:"장기납기",cell:({getValue})=>c("LONGTERM_DELIVERY_YN",getValue()),size:80},{accessorKey:"incidentalExpenseCode",header:"부대비용",cell:({getValue})=>c("INCIDENTAL_EXPENSE_CODE",getValue()),size:90},
 {accessorKey:"warehouseCharge",header:"창고담당",size:90},{accessorKey:"orderCharge",header:"발주담당",size:90},{accessorKey:"inspectProcess",header:"검사공정",size:90},{accessorKey:"esdCheckCycleValue",header:"ESD주기",size:75},
];

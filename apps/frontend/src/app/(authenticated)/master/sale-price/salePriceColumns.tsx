import type { ColumnDef } from "@tanstack/react-table";
import { ComCodeBadge } from "@/components/ui";
import type { SalePriceItem } from "./types";

const dateText = (value?: string) => value?.slice(0, 10) ?? "-";
const numberText = (value?: number) => value == null ? "-" : value.toLocaleString();
const codeCell = (groupCode: string, code: unknown) => (
  <ComCodeBadge groupCode={groupCode} code={String(code ?? "")} />
);

export const salePriceColumns = (): ColumnDef<SalePriceItem, unknown>[] => [
  { accessorKey: "customerCode", header: "고객코드", size: 100 },
  { accessorKey: "customerName", header: "고객명", size: 150 },
  { accessorKey: "itemCode", header: "품목코드", size: 140 },
  { accessorKey: "itemName", header: "품목명", size: 180 },
  { accessorKey: "productLineType", header: "제품라인유형", size: 105, cell: ({ getValue }) => codeCell("PRODUCT_LINE_TYPE", getValue()) },
  { accessorKey: "dateset", header: "시작일", cell: ({ getValue }) => dateText(getValue<string>()), size: 100 },
  { accessorKey: "dateend", header: "종료일", cell: ({ getValue }) => dateText(getValue<string>()), size: 100 },
  { accessorKey: "salePrice", header: "판매단가", cell: ({ getValue }) => numberText(getValue<number>()), meta: { align: "right" }, size: 110 },
  { accessorKey: "standardSalePrice", header: "기준판매단가", cell: ({ getValue }) => numberText(getValue<number>()), meta: { align: "right" }, size: 120 },
  { accessorKey: "foreignSalePrice", header: "외화판매단가", cell: ({ getValue }) => numberText(getValue<number>()), meta: { align: "right" }, size: 120 },
  { accessorKey: "saleCurrency", header: "통화", size: 70, cell: ({ getValue }) => codeCell("SALE_CURRENCY", getValue()) },
  { accessorKey: "foreignSaleCurrency", header: "외화통화", size: 80, cell: ({ getValue }) => codeCell("FOREIGN_SALE_CURRENCY", getValue()) },
  { accessorKey: "taxRate", header: "세율", size: 70 },
  { accessorKey: "priceType", header: "단가형태", size: 85, cell: ({ getValue }) => codeCell("PRICE_TYPE", getValue()) },
  { accessorKey: "priceChangeReason", header: "변경사유", size: 90, cell: ({ getValue }) => codeCell("PRICE_CHANGE_REASON", getValue()) },
  { accessorKey: "modelName", header: "모델명", size: 140 },
  { accessorKey: "saleCharge", header: "영업담당", size: 90 },
  { accessorKey: "priceChangeConfirmYn", header: "승인여부", size: 85, cell: ({ getValue }) => codeCell("PRICE_CHANGE_CONFIRM_YN", getValue()) },
  { accessorKey: "enterBy", header: "등록자", size: 85 },
];

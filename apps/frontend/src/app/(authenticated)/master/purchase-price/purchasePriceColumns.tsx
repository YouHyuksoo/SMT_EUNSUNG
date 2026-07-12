import type { ColumnDef } from "@tanstack/react-table";
import { ComCodeBadge } from "@/components/ui";
import type { PurchasePriceItem } from "./types";

const dateText = (value?: string | null) => value ? value.slice(0, 10) : "-";
const moneyText = (value?: number | null) => value == null ? "-" : value.toLocaleString();

export function createPurchasePriceGridColumns(): ColumnDef<PurchasePriceItem, unknown>[] {
  return [
    { accessorKey: "itemCode", header: "품목코드", size: 130 },
    { accessorKey: "itemName", header: "품목명", size: 180 },
    { accessorKey: "supplierCode", header: "공급사코드", size: 120 },
    { accessorKey: "supplierName", header: "공급사명", size: 160 },
    { accessorKey: "lineType", header: "구입유형", size: 90, cell: ({ getValue }) => <ComCodeBadge groupCode="LINE_TYPE" code={getValue<string>()} /> },
    { accessorKey: "dateset", header: "시작일", size: 105, cell: ({ getValue }) => dateText(getValue<string>()) },
    { accessorKey: "dateend", header: "종료일", size: 105, cell: ({ getValue }) => dateText(getValue<string>()) },
    { accessorKey: "unitPrice", header: "단가", size: 110, cell: ({ getValue }) => moneyText(getValue<number>()), meta: { align: "right" } },
    { accessorKey: "standardUnitPrice", header: "기준단가", size: 110, cell: ({ getValue }) => moneyText(getValue<number | null>()), meta: { align: "right" } },
    { accessorKey: "currency", header: "통화", size: 75, cell: ({ getValue }) => <ComCodeBadge groupCode="CURRENCY" code={getValue<string>()} /> },
    { accessorKey: "taxRate", header: "세율", size: 75, meta: { align: "right" } },
    { accessorKey: "priceType", header: "단가형태", size: 85, cell: ({ getValue }) => <ComCodeBadge groupCode="PRICE_TYPE" code={getValue<string>()} /> },
    { accessorKey: "delivery", header: "납선", size: 70, cell: ({ getValue }) => <ComCodeBadge groupCode="DELIVERY" code={getValue<string>()} /> },
    { accessorKey: "priceChangeReason", header: "변경사유", size: 90, cell: ({ getValue }) => <ComCodeBadge groupCode="PRICE_CHANGE_REASON" code={getValue<string>()} /> },
    { accessorKey: "priceChangeConfirmYn", header: "승인여부", size: 85, cell: ({ getValue }) => <ComCodeBadge groupCode="PRICE_CHANGE_CONFIRM_YN" code={getValue<string>()} /> },
    { accessorKey: "approvalNo", header: "승인번호", size: 110 },
    { accessorKey: "confirmBy", header: "승인자", size: 90 },
    { accessorKey: "confirmDate", header: "승인일", size: 105, cell: ({ getValue }) => dateText(getValue<string | null>()) },
    { accessorKey: "enterBy", header: "등록자", size: 90 },
    { accessorKey: "enterDate", header: "등록일", size: 105, cell: ({ getValue }) => dateText(getValue<string | null>()) },
  ];
}

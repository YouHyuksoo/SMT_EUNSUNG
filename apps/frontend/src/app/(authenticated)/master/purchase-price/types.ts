export interface PurchasePriceItem {
  dateset: string;
  dateend: string;
  itemCode: string;
  itemName?: string | null;
  supplierCode: string;
  supplierName?: string | null;
  lineType: string;
  unitPrice: number;
  standardUnitPrice?: number | null;
  taxRate?: number | null;
  currency: string;
  delivery: string;
  priceType: string;
  priceChangeReason: string;
  approvalNo?: string | null;
  priceChangeConfirmYn?: string | null;
  confirmBy?: string | null;
  confirmDate?: string | null;
  enterBy?: string | null;
  enterDate?: string | null;
}

export interface PurchasePriceImpact {
  mode: "create" | "update";
  closingRows: Array<{ dateset: string; dateend: string; unitPrice: number }>;
  affectedRows: number;
  affectedAmount: number;
}

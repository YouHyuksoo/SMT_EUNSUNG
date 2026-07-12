export interface ItemSupplierItem {
  supplierCode:string;supplierName?:string;itemCode:string;itemName?:string;dateset:string;dateend:string;
  orderType?:string;orderRate:number;orderLeadtime?:number;orderBadRate?:number;mimOrderQty?:number;packingQty?:number;
  longtermDeliveryYn?:string;warehouseCharge?:string;orderCharge?:string;mainVendorYn?:string;paymentType:string;
  inspectMethod?:string;inspectRule?:string;incidentalExpenseCode?:string;inspectProcess?:string;esdCheckCycleValue?:number;
  enterBy?:string;enterDate?:string;lastModifyBy?:string;lastModifyDate?:string;
}

export interface RoutingGroupItem { routingCode:string; itemCode:string; itemName?:string|null; routingName:string; description:string|null; useYn:"Y"|"N" }
export interface RoutingProcessItem { routingCode:string; seq:number; workstageCode:string; workstageName?:string|null; executionType:"INTERNAL"|"SUBCON"; jobOrderYn:"Y"|"N"; subconSupplierCode:string|null; subconSupplierName?:string|null; standardTime:number|null; setupTime:number|null; useYn:"Y"|"N" }
export interface RoutingMaterial { childItemCode:string; childItemName?:string|null; bomQty:number|null; allocQty:number|null; bomMatchYn:"Y"|"N"; mismatchReason:string|null; assignedProcessSeq:number|null; selectableYn:"Y"|"N"; issueMethod:"BACKFLUSH"|"PRE_ISSUE" }
export interface EditableRoutingMaterial extends RoutingMaterial { selected:boolean; allocQtyInput:string; deleteRequested:boolean }
export interface SelectedProcess { routingCode:string; routingName:string; seq:number; workstageCode:string; workstageName:string }

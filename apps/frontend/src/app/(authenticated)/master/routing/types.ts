export interface RoutingGroupItem { routingCode:string; routingName:string; description:string|null; useYn:"Y"|"N"; itemCount?:number }
export interface RoutingProcessItem { routingCode:string; processSeq:number; workstageCode:string; workstageName?:string|null; executionType:"INTERNAL"|"SUBCON"; jobOrderYn:"Y"|"N"; subconSupplierCode:string|null; subconSupplierName?:string|null; standardTime:number|null; setupTime:number|null; useYn:"Y"|"N" }
export interface RoutingMaterial { childItemCode:string; childItemName?:string|null; bomQty:number|null; allocQty:number|null; bomMatchYn:"Y"|"N"; mismatchReason:string|null; assignedProcessSeq:number|null; selectableYn:"Y"|"N"; issueMethod:"BACKFLUSH"|"PRE_ISSUE" }
export interface EditableRoutingMaterial extends RoutingMaterial { selected:boolean; allocQtyInput:string; deleteRequested:boolean }
/** 라우팅을 따르는 품목(ID_ITEM.ROUTING_CODE). 투입자재 배정은 이 품목 기준이다. */
export interface RoutingItem { itemCode:string; itemName:string; modelName:string|null; itemDivision:string; materialCount:number }
/** 라우팅을 붙일 수 있는 반제품·완제품. routingCode 는 지금 따르는 라우팅이다. */
export interface RoutingCandidateItem { itemCode:string; itemName:string; modelName:string|null; itemDivision:string; routingCode:string|null; routingName:string|null; bomRegisteredYn:"Y"|"N" }
/** itemCode: 투입자재를 다루는 품목. 품목을 고르기 전에는 null 이다. */
export interface SelectedProcess { routingCode:string; routingName:string; seq:number; workstageCode:string; workstageName:string; itemCode:string|null }

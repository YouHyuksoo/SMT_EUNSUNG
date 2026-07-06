HA$PBExportHeader$w_mat_item_departure_excel_form_popup.srw
$PBExportComments$$$HEX8$$01c6c5c585c7e0acd1c540c191c5ddc2$$ENDHEX$$
forward
global type w_mat_item_departure_excel_form_popup from w_popup_root
end type
type cb_delete from so_commandbutton within w_mat_item_departure_excel_form_popup
end type
type cb_update from so_commandbutton within w_mat_item_departure_excel_form_popup
end type
type cb_insert from so_commandbutton within w_mat_item_departure_excel_form_popup
end type
type cb_2 from so_commandbutton within w_mat_item_departure_excel_form_popup
end type
type pb_1 from so_commandbutton within w_mat_item_departure_excel_form_popup
end type
type cbx_departure_subsitute_arrival from so_checkbox within w_mat_item_departure_excel_form_popup
end type
type gb_3 from so_groupbox within w_mat_item_departure_excel_form_popup
end type
end forward

global type w_mat_item_departure_excel_form_popup from w_popup_root
integer width = 4128
integer height = 1956
string title = "Departure Form Popup"
boolean controlmenu = false
cb_delete cb_delete
cb_update cb_update
cb_insert cb_insert
cb_2 cb_2
pb_1 pb_1
cbx_departure_subsitute_arrival cbx_departure_subsitute_arrival
gb_3 gb_3
end type
global w_mat_item_departure_excel_form_popup w_mat_item_departure_excel_form_popup

type variables
datawindow idw_datawindow
end variables

on w_mat_item_departure_excel_form_popup.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.cb_insert=create cb_insert
this.cb_2=create cb_2
this.pb_1=create pb_1
this.cbx_departure_subsitute_arrival=create cbx_departure_subsitute_arrival
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.cb_update
this.Control[iCurrent+3]=this.cb_insert
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.cbx_departure_subsitute_arrival
this.Control[iCurrent+7]=this.gb_3
end on

on w_mat_item_departure_excel_form_popup.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.cb_insert)
destroy(this.cb_2)
destroy(this.pb_1)
destroy(this.cbx_departure_subsitute_arrival)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)

end event

event key;call super::key;if key = keyf2! then 
   cb_insert.triggerevent(clicked!)
elseif key = keyf3! then 
   cb_delete.triggerevent(clicked!)   
	
elseif key = keyf6! then 
   cb_update.triggerevent(clicked!)
   
end if
end event

event activate;call super::activate;ivs_resize_type = 'DEFAULT'
end event

event ue_post_open;call super::ue_post_open;dw_2.SETTRANSOBJECT(SQLCA)


end event

event close;call super::close;MSG = F_MSGBOX(1170)

long lvl_rowcount

IF MSG = 1 THEN
	
	if dw_2.rowcount( ) > 0 then 
	
			lvl_rowcount = dw_2.rowcount( ) + 1
			
			DO
				lvl_rowcount = lvl_rowcount -1
				
				if dw_2.isselected( lvl_rowcount) then
				else
					dw_2.deleterow(lvl_rowcount)
				end if 
				
			LOOP UNTIL lvl_rowcount <= 1
		else
				rollback;
	end if 			
	
	IF DW_1.ROWCOUNT() > 0 THEN 
		IF DW_1.UPDATE( ) < 0 THEN 
			ROLLBACK;
		ELSE
			COMMIT ;
			f_msgbox(170)		
			DW_1.RESET()
	
		END IF
	ELSE
		DW_1.RESET()	
		ROLLBACK ;
		RETURN
	END IF 
	
END IF	
end event

type p_title from w_popup_root`p_title within w_mat_item_departure_excel_form_popup
integer width = 4110
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
end type

type cb_sort from w_popup_root`cb_sort within w_mat_item_departure_excel_form_popup
integer x = 1024
integer y = 0
integer taborder = 40
end type

type cb_close from w_popup_root`cb_close within w_mat_item_departure_excel_form_popup
boolean visible = true
integer x = 3739
integer y = 248
integer width = 352
integer height = 128
integer taborder = 0
end type

event cb_close::clicked;rollback;
close(parent)
end event

type st_msg from w_popup_root`st_msg within w_mat_item_departure_excel_form_popup
boolean visible = true
integer y = 420
integer width = 4110
integer weight = 400
end type

type dw_1 from w_popup_root`dw_1 within w_mat_item_departure_excel_form_popup
boolean visible = true
integer y = 516
integer width = 2217
integer height = 1324
integer taborder = 20
boolean titlebar = true
string title = "Departure List"
string dataobject = "d_mat_departure_confirm_lst"
boolean controlmenu = true
end type

event dw_1::rbuttondown;call super::rbuttondown;decimal lvf_dc_rate , lvf_dc_sale_price

if dwo.name = 'item_code' then 
	
     openwithparm( w_sal_sale_price_popup , string(this.object.item_code[row]))
	  
	if gst_return.gvb_return = true then 
		
		this.object.item_code[row] = message.stringparm
		trigger event itemchanged( row , dwo, string( this.object.item_code[row] ) )		
		
	 //======================================================
	 // $$HEX8$$e0ac1dacc4bc200060d578c728c72000$$ENDHEX$$/ $$HEX17$$18c2fcc8c4bc200060d578c728c744c72000e4b2dcc2200001c8a9c65cd5e4b22000$$ENDHEX$$
	 //======================================================
	 lvf_dc_rate = f_get_order_dc_rate( this.object.customer_code[row] , this.object.customer_order_no_origin[row]	, this.object.customer_order_no[row]	)
	 //======================================================
	 lvf_dc_sale_price = Gst_return.gvf_return[1] * lvf_dc_rate			
	 
		this.object.product_sale_price_origin[row] =  Gst_return.gvf_return[1] 
		this.object.product_sale_price[row] = lvf_dc_sale_price
		this.object.sale_currency[row] = Gst_return.gvs_return[1]
		this.object.customer_code[row] = Gst_return.gvs_return[2]
		trigger event itemchanged( row , dwo, string( this.object.customer_code[row] ) )		
		this.object.product_line_type[row] = Gst_return.gvs_return[3]		
		   
		Gst_return.gvf_return[1] = 0
		Gst_return.gvs_return[1] = ''
		Gst_return.gvs_return[2] = ''
		Gst_return.gvs_return[3] = ''		

	else
	end if
	  
elseif dwo.name = 'customer_code' then 

	openwithparm(w_sal_sale_price_popup , string(this.object.item_code[row] ))
	if gst_return.gvb_return = true then 
		
		this.object.customer_code[row] = gst_return.gvs_return[2]
		
		trigger event itemchanged( row , dwo, string( this.object.customer_code[row] ) )
	end if 
	
end if

if dwo.name = 'mfs' THEN 
	
//	openwithparm(w_sal_product_inventory_popup , string(this.object.item_code[row]))
	
	if gst_return.gvb_return = true then
		
		this.object.mfs[this.getrow()]           = message.stringparm
		this.object.item_code[this.getrow()] = gst_return.gvs_return[1]
		gst_return.gvs_return[1] = ''

	end if 
	
end if 
end event

event dw_1::itemchanged;call super::itemchanged;Decimal lvf_sale_price , lvf_usefull_qty , lvf_exchange_rate , lvf_dc_rate , lvf_dc_sale_price
string lvs_currency
this.accepttext( )


if dwo.name = 'customer_code' then 
	
	this.object.product_line_type[row] = ''
	
end if

if dwo.name = 'sale_currency' then 
	
	if this.object.sale_currency[row] = Gvs_currency then 
		this.object.exchange_rate[row] = 1
		this.object.foreign_shipping_amt[row] = 0
		this.object.shipping_amt[row] = round(this.object.shipping_qty[row] * this.object.product_sale_price[row], integer(Gvs_SHIPPING_AMT_PRECISION)) 
	else
		this.object.exchange_rate[row] = 	 f_get_sale_exchange_rate( this.object.shipping_date[row] , this.object.sale_currency[row] )
		this.object.shipping_amt[row] = round(this.object.shipping_qty[row] * this.object.product_sale_price[row] * this.object.exchange_rate[row], integer(Gvs_SHIPPING_AMT_PRECISION))
		this.object.foreign_shipping_amt[row] = round(this.object.shipping_qty[row] * this.object.product_sale_price[row], integer(Gvs_SHIPPING_AMT_PRECISION)) 	 
	end if
	
end if


if dwo.name = 'work_division'  or dwo.name = 'customer_code' then 
	
	this.object.product_sale_price[row] = 0
	this.object.shipping_amt[row] = 0
	
	this.object.product_work_cost[row] = 0
	this.object.product_work_cost_amt[row] = 0	
	
end if
//========================================================
// $$HEX11$$6cad85c7200020c715d674c72000c0bc58d574ba2000$$ENDHEX$$
//========================================================
if dwo.name = 'product_line_type' then
	
   if  this.object.customer_code[row] = '' or isnull(this.object.customer_code[row]	) or this.object.model_delivery_code[row] = '' or isnull(this.object.model_delivery_code[row]	) then 
	 this.object.product_line_type[row] = ''
	 this.setcolumn( 'customer_code')
	 return 1
   end if
//============================================================
// $$HEX15$$1cc888d4200010d3e4b92000e8b200ac7cb9200000ac38c828c6e4b22000$$ENDHEX$$
//============================================================

//	if f_get_customer_business_type(this.object.customer_code[row]) = 'H' then //$$HEX7$$78c680bd20003dcce0ac74ba2000$$ENDHEX$$
//
//		lvf_sale_price = f_get_product_inventory_price(this.object.mfs[row],this.object.item_code[row] , this.object.product_line_type[row]  )		
//		
//			if lvf_sale_price < 0 or isnull(lvf_sale_price) then 
//					f_msgbox1( 9072 , string(this.object.mfs[row] +'  '+this.object.item_code[row]+'  '+this.object.product_line_type[row]) )
//			else
//							lvs_currency = Gvs_currency
//							lvf_exchange_rate = 1
//							if  this.object.work_division[row] = 'P' then //$$HEX5$$ddc0b0c074c774ba2000$$ENDHEX$$
//								dw_2.object.product_sale_price_origin[row] = lvf_sale_price
//								dw_2.object.product_sale_price[row] = lvf_sale_price
//								dw_2.object.sale_currency[row] = lvs_currency
//								dw_2.object.shipping_amt[row] = round(this.object.shipping_qty[row] * lvf_sale_price	* lvf_exchange_rate, integer(Gvs_SHIPPING_AMT_PRECISION))
//								dw_2.object.foreign_shipping_amt[row] = round(this.object.shipping_qty[row] * lvf_sale_price, integer(Gvs_SHIPPING_AMT_PRECISION))			
//								
//								elseif this.object.work_division[row] = 'W' then //$$HEX6$$00acf5ac200074c774ba2000$$ENDHEX$$
//								dw_2.object.product_sale_price_origin[row] = lvf_sale_price
//								dw_2.object.product_work_cost[row] = lvf_sale_price
//								dw_2.object.work_currency[row] = lvs_currency
//								dw_2.object.product_work_cost_amt[row] = round(this.object.shipping_qty[row] * lvf_sale_price, integer(Gvs_SHIPPING_AMT_PRECISION))					
//							else
//								Messagebox("Notify" , "Product Work Division Unknown")
//								Return
//							end if
//	
//			end if	
//
//	else //$$HEX10$$78c680bd3dcce0ac00ac200044c5c8b274ba2000$$ENDHEX$$
//		  //$$HEX12$$b9c278c71cb4200010d3e4b9e8b200ac200070c88cd62000$$ENDHEX$$
//		 
//		//$$HEX31$$68d518c2200048c5d0c51cc12000d0c5ecb7200054ba38c1c0c920005cb8f8ad20003dcc74c72000f4c5acb98cac200018b4b4c5200088c74cc720002000$$ENDHEX$$
//		lvf_sale_price = f_get_product_sale_price_confirm( this.object.customer_code[row] , this.object.item_code[row]  , this.object.product_line_type[row] , this.object.work_division[row] , this.object.shipping_date[row] , this.object.model_delivery_code[row]  )
//		 
//		if lvf_sale_price <= 0 or isnull(lvf_sale_price) then 
//			     if f_get_item_division(this.object.item_code[row]) = 'V' then //$$HEX14$$d8c00cd5200010b694b2200030ae9dc988d4200078c7bdacb0c62000$$ENDHEX$$
//				  //$$HEX10$$54badcc2c0c920009ccd25b8200048c568d52000$$ENDHEX$$
//				else
//					f_msgbox1( 9072 , string(this.object.customer_code[row] +'  '+this.object.item_code[row]+'  '+this.object.product_line_type[row]) )
//				end if 
//		else
//				lvs_currency = gst_return.gvs_return[1]
//				lvf_exchange_rate = gst_return.gvf_return[2]
//				
//				if lvf_exchange_rate = 0 or isnull(lvf_exchange_rate) then 
//					Messagebox("Notify" , "Exchange Rate Not Found! Please Check Exchange Rate")
//					return
//				end if
//			
//			 //======================================================
//			 // $$HEX8$$e0ac1dacc4bc200060d578c728c72000$$ENDHEX$$/ $$HEX17$$18c2fcc8c4bc200060d578c728c744c72000e4b2dcc2200001c8a9c65cd5e4b22000$$ENDHEX$$
//			 //======================================================
//			 lvf_dc_rate = f_get_order_dc_rate( this.object.customer_code[row] , this.object.customer_order_no_origin[row]	, this.object.customer_order_no[row]	)
//			 //======================================================
//			 lvf_dc_sale_price = lvf_sale_price * lvf_dc_rate		
//		
//				if  this.object.work_division[row] = 'P' then //$$HEX5$$ddc0b0c074c774ba2000$$ENDHEX$$
//					dw_2.object.product_sale_price_origin[row] = lvf_sale_price
//					dw_2.object.product_sale_price[row] = lvf_dc_sale_price
//					dw_2.object.sale_currency[row] = lvs_currency
//					dw_2.object.shipping_amt[row] = round(this.object.shipping_qty[row] * lvf_dc_sale_price	* lvf_exchange_rate, integer(Gvs_SHIPPING_AMT_PRECISION))
//					dw_2.object.foreign_shipping_amt[row] = round(this.object.shipping_qty[row] * lvf_dc_sale_price, integer(Gvs_SHIPPING_AMT_PRECISION))			
//					
//				elseif this.object.work_division[row] = 'W' then //$$HEX6$$00acf5ac200074c774ba2000$$ENDHEX$$
//					dw_2.object.product_sale_price_origin[row] = lvf_sale_price
//					dw_2.object.product_work_cost[row] = lvf_dc_sale_price
//					dw_2.object.work_currency[row] = lvs_currency
//					dw_2.object.product_work_cost_amt[row] = round(this.object.shipping_qty[row] * lvf_dc_sale_price, integer(Gvs_SHIPPING_AMT_PRECISION))					
//				else
//					Messagebox("Notify" , "Product Work Division Unknown")
//					Return
//				end if
//
//	end if
//end if //$$HEX8$$78c680bd3dcce0ac20006cad84bd2000$$ENDHEX$$
//============================================================
//
//============================================================

end if

if dwo.name = 'shipping_qty' or dwo.name = 'product_sale_price' or dwo.name = 'product_work_cost'  then 
	
     if this.object.work_division[row]  = 'P' then
		this.object.shipping_amt[row] = round(this.object.shipping_qty[row]  * this.object.product_sale_price[row] * this.object.exchange_rate[row], integer(Gvs_SHIPPING_AMT_PRECISION))
		
		if this.object.sale_currency[row] <> Gvs_currency then
			this.object.foreign_shipping_amt[row] = round(this.object.shipping_qty[row]  * this.object.product_sale_price[row] , integer(Gvs_SHIPPING_AMT_PRECISION))
		else
			this.object.foreign_shipping_amt[row]  = 0 
		end if
	else
		this.object.product_work_cost_amt_amt[row] = round(this.object.shipping_qty[row]  * this.object.product_work_cost[row], integer(Gvs_SHIPPING_AMT_PRECISION)) 		
	end if
	
	
//	lvf_usefull_qty = f_sal_product_usefull_inventory( this.object.mfs[row] , this.object.item_code[row] )
//	
//	if lvf_usefull_qty <= 0 then 
//		Messagebox("Notify" , string(this.object.mfs[row])+'  '+string(this.object.item_code[row])+'  '+"Usefull Inventory qty not found" )
//		Return 1
//	end if
	
//	if dwo.name = 'shipping_qty' then 
//		if lvf_usefull_qty < Dec(this.object.shipping_qty[row]) then 
//			this.object.shipping_qty[row] = 0
//			Messagebox("Notify" , ' Usefull Qty= '+string(lvf_usefull_qty)+'  '+string(this.object.mfs[row])+'  '+string(this.object.item_code[row])+'  '+"Usefull Inventory qty not enough" )
//			Return 1			
//		end if
//			this.object.inventory_price[row] = f_get_product_inventory_price(this.object.mfs[row] , this.object.item_code[row] , this.object.product_line_type[row])
//			this.object.cost_amt[row] = this.object.shipping_qty[row] * this.object.inventory_price[row]
//     end if
	
end if
	
	
end event

type dw_2 from w_popup_root`dw_2 within w_mat_item_departure_excel_form_popup
boolean visible = true
integer x = 2222
integer y = 516
integer width = 1874
integer height = 1324
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_item_departure_excel_popup"
boolean controlmenu = true
boolean maxbox = true
end type

event dw_2::constructor;//override
end event

type dw_3 from w_popup_root`dw_3 within w_mat_item_departure_excel_form_popup
integer y = 856
integer taborder = 50
end type

type cb_delete from so_commandbutton within w_mat_item_departure_excel_form_popup
integer x = 800
integer y = 256
integer width = 352
boolean bringtotop = true
string text = "Delete [F3]"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 
dw_1.deleterow( dw_1.getrow())
end event

type cb_update from so_commandbutton within w_mat_item_departure_excel_form_popup
integer x = 1152
integer y = 256
integer width = 352
integer taborder = 30
boolean bringtotop = true
string text = "Update [F6]"
boolean default = true
end type

event clicked;MSG = F_MSGBOX(1170)

long lvl_rowcount

IF MSG = 1 THEN
	
	if dw_2.rowcount( ) > 0 then 
	
			lvl_rowcount = dw_2.rowcount( ) + 1
			
			DO
				lvl_rowcount = lvl_rowcount -1
				
				if dw_2.isselected( lvl_rowcount) then
				else
					dw_2.deleterow(lvl_rowcount)
				end if 
				
			LOOP UNTIL lvl_rowcount <= 1
			
	end if 			
	
	IF DW_1.ROWCOUNT() > 0 THEN 
		IF DW_1.UPDATE( ) < 0 THEN 
			ROLLBACK;
		ELSE
			COMMIT ;
			f_msgbox(170)		
			DW_1.RESET()
	
		END IF
	ELSE
		DW_1.RESET()	
		ROLLBACK ;
		RETURN
	END IF 
	
END IF	
end event

type cb_insert from so_commandbutton within w_mat_item_departure_excel_form_popup
integer x = 453
integer y = 256
integer width = 352
integer taborder = 10
boolean bringtotop = true
string text = "Insert [F2]"
end type

event clicked;call super::clicked;LONG N = 1  , I =0  , LVL_ARRIVAL_SEQ , J  , K 
DECIMAL LVL_DEPARTURE_QTY
STRING  LVS_INVOICE_NO, LVS_ORDER_NO , LVS_ORDER_GROUP_NO , LVS_SUPPLIER_CODE  , LVS_SUPPLIER_CODE_COND , LVS_ROWID
STRING LVS_MATERIAL_MFS , LVS_ORIGIN_MFS , LVS_INSPECT_RULE , LVS_ARRIVAL_LOCATION_CODE 
DATETIME LVDT_DEPARTURE_DATE

STRING LVS_ITEM_CODE_COND , LVS_LINE_TYPE , LVS_ORDER_TYPE , LVS_CURRENCY , LVS_DELIVERY , LVS_INCIDENTAL_EXPENSE_CODE , LVS_SUBCONTRACT_INVOICE_NO					
DECIMAL LVF_UNIT_PRICE , LVF_ARRIVAL_AMT  , LVF_ORDER_REMAIN_QTY
DATETIME LVDT_DELIVERY_DATE
STRING LVS_ORDER_GROUP_NO1 , LVS_ERROR_YN

IF DW_2.ROWCOUNT() < 1 THEN RETURN 

DECLARE CL_ORDER CURSOR FOR 
	SELECT     ORDER_NO , ORDER_GROUP_NO , SUPPLIER_CODE , LINE_TYPE , ORDER_TYPE , UNIT_PRICE ,  CURRENCY ,DELIVERY , DELIVERY_DATE ,
	                INCIDENTAL_EXPENSE_CODE , SUBCONTRACT_INVOICE_NO , 
				   ORDER_QTY - NVL(ARRIVAL_QTY,0) ,
				   ROWID
           FROM IM_ITEM_PURCHASE_ORDER
        WHERE  ITEM_CODE       = :LVS_ITEM_CODE_COND
		   AND SUPPLIER_CODE  = :LVS_SUPPLIER_CODE_COND
	        AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  
		   AND ORDER_QTY - NVL(ARRIVAL_QTY,0) > 0   //$$HEX12$$94c7c9b774c72000a8b044c588c794b22000fcc838bb2000$$ENDHEX$$
		  ORDER BY ITEM_CODE , DELIVERY_DATE , SUPPLIER_CODE  
		  ;
		  
//============================================
// $$HEX3$$dcc291c72000$$ENDHEX$$
//============================================
DO
	yield()
	I++
	
	LVS_INVOICE_NO = DW_2.OBJECT.INVOICE_NO[I] 
	LVS_ITEM_CODE_COND =  DW_2.OBJECT.ITEM_CODE[I]		

	LVDT_DEPARTURE_DATE = DW_2.OBJECT.DEPARTURE_DATE[I]
	LVL_DEPARTURE_QTY = DW_2.OBJECT.DEPARTURE_QTY[I]
	LVS_SUPPLIER_CODE_COND = DW_2.OBJECT.SUPPLIER_CODE[I]

	//=======================================                          
	//
	//=======================================		

	OPEN CL_ORDER;  
	IF F_SQL_CHECK() < 0 THEN
		CLOSE CL_ORDER ;
		RETURN
	END IF
	
			 K = 0;
	
			 
			 DO 
				
					LVF_ORDER_REMAIN_QTY = 0 ;
					LVS_ORDER_NO = ''
					LVS_SUPPLIER_CODE = ''
					LVS_DELIVERY = ''
					LVS_ROWID = ''				
					yield()
					 FETCH CL_ORDER INTO :LVS_ORDER_NO ,
													:LVS_ORDER_GROUP_NO,
					 								:LVS_SUPPLIER_CODE , 
					                                    :LVS_LINE_TYPE ,
					 								:LVS_ORDER_TYPE , 
													:LVF_UNIT_PRICE , 
													:LVS_CURRENCY ,
													:LVS_DELIVERY , 
													:LVDT_DELIVERY_DATE ,
										             :LVS_INCIDENTAL_EXPENSE_CODE , 
												    :LVS_SUBCONTRACT_INVOICE_NO ,
													:LVF_ORDER_REMAIN_QTY ,
													:LVS_ROWID ;
					 
					 IF F_SQL_CHECK() < 0 THEN
						 LVS_ERROR_YN = 'Y'
						 CLOSE CL_ORDER ;
						 EXIT
					 END IF
		  
					 IF SQLCA.SQLCODE = 100 THEN 
						  IF K = 0 THEN 
							 CLOSE CL_ORDER;							
							 DW_2.SELECTROW(i , true )
//							 ROLLBACK;
//							 MESSAGEBOX("ERROR" , LVS_SUPPLIER_CODE_COND+"  "+LVS_ITEM_CODE_COND+"  ORDER NOT FOUND" )
//							 DW_1.RESET()
//	 						 LVS_ERROR_YN = 'Y'
							 EXIT							 
						  END IF 
						  
						  //$$HEX23$$c4b329cc200094c7c9b774c72000a8b044c5200088c794b270b3c4b32000fcc838bb74c72000c6c53cc774ba2000$$ENDHEX$$
						  IF LVL_DEPARTURE_QTY > 0 THEN 
							  CLOSE CL_ORDER;
							  DW_2.SELECTROW(i , true )
							  DW_2.OBJECT.DEPARTURE_QTY[I] = LVL_DEPARTURE_QTY 
//							 ROLLBACK;
//							 MESSAGEBOX("ERROR" , LVS_SUPPLIER_CODE_COND+'  '+LVS_ITEM_CODE_COND+"  Order Less Then Departure Qty" )
//							 DW_1.RESET()
//	 						 LVS_ERROR_YN = 'Y'
							 EXIT
						  END IF 
						  
						  CLOSE CL_ORDER;
						  EXIT
					 END IF
					 
		    K++					 
			N = DW_1.INSERTROW(0)
			DW_1.SCROLLTOROW(N)
			F_SET_SECURITY_ROW(DW_1, N, 'ALL')
			DW_1.OBJECT.ARRIVAL_DATE[N] =LVDT_DEPARTURE_DATE
		
					//=======================================
					//$$HEX6$$30aef8bc2000acc06dd52000$$ENDHEX$$
					//=======================================	
					DW_1.OBJECT.DEPARTURE_DATE[N]   = LVDT_DEPARTURE_DATE
					DW_1.OBJECT.ORDER_NO[N]            = LVS_ORDER_NO
					DW_1.OBJECT.ITEM_CODE[N]          = LVS_ITEM_CODE_COND
					DW_1.OBJECT.INVOICE_NO[N]          = LVS_INVOICE_NO
			
					LVL_ARRIVAL_SEQ = LONG(F_GET_SEQUENCE('SEQ_MAT_ARRIVAL'))
					DW_1.OBJECT.ARRIVAL_SEQ_NO[N] = LVL_ARRIVAL_SEQ
					DW_1.OBJECT.ARRIVAL_SEQ_NO_ORIGIN[N] = LVL_ARRIVAL_SEQ
					DW_1.OBJECT.ARRIVAL_STATUS[N] = 'N'
					DW_1.OBJECT.MFS[N] = '*'	
					DW_1.OBJECT.MATERIAL_MFS[N] =  '*'		
					DW_1.OBJECT.ARRIVAL_LOCATION_CODE[N] = 'INSIDE'	
					DW_1.OBJECT.ORIGIN_MFS[N] =  '*'	
					DW_1.OBJECT.COMMENTS[N] ='BATCH UPLOAD'						 
	
					//===========================================
					//$$HEX21$$fcc838bb200015c8f4bc5cb8200080bd30d1200038cc70c874d57cc5200058d594b22000acc06dd52000$$ENDHEX$$
					//===========================================	
					DW_1.OBJECT.ORDER_GROUP_NO[N]  = LVS_ORDER_GROUP_NO	
					DW_1.OBJECT.SUPPLIER_CODE[N]     = LVS_SUPPLIER_CODE                      
					DW_1.OBJECT.LINE_TYPE[N] = LVS_LINE_TYPE
					DW_1.OBJECT.ORDER_TYPE[N] = LVS_ORDER_TYPE
					DW_1.OBJECT.DELIVERY[N]             = LVS_DELIVERY
					DW_1.OBJECT.DELIVERY_DATE[N]     = LVDT_DELIVERY_DATE
				
					DW_1.OBJECT.INCIDENTAL_EXPENSE_CODE[N] = LVS_INCIDENTAL_EXPENSE_CODE
					DW_1.OBJECT.SUBCONTRACT_INVOICE_NO[N] =  LVS_SUBCONTRACT_INVOICE_NO
					//=============================================================
					//
					//=============================================================
					LVS_INSPECT_RULE = F_GET_MAT_INSPECT_RULE(LVS_SUPPLIER_CODE_COND ,LVS_ITEM_CODE_COND )
					
					IF LVS_INSPECT_RULE = 'P' THEN
						DW_1.OBJECT.INSPECT_RESULT[N] = 'P'
						DW_1.OBJECT.INSPECT_RULE[N] = LVS_INSPECT_RULE
					ELSE
						DW_1.OBJECT.INSPECT_RESULT[N] = 'W'
						DW_1.OBJECT.INSPECT_RULE[N] = LVS_INSPECT_RULE
					END IF
				
					IF CBX_DEPARTURE_SUBSITUTE_ARRIVAL.CHECKED = TRUE THEN 
						DW_1.OBJECT.ARRIVAL_TYPE[N] = 'A'   //$$HEX16$$9ccd1cbc44c72000c4b329cc3cc75cb8200000b3e0c268d5200035c658c12000$$ENDHEX$$
					ELSE
						DW_1.OBJECT.ARRIVAL_TYPE[N] = 'D'		
					END IF
					
					DW_1.OBJECT.SELECTED_ROW[N] = I					
					//======================================
					// $$HEX19$$fcc838bb200094c7c9b774c720009ccd1cbc200018c2c9b72000f4bce4b220006cd074ba2000$$ENDHEX$$
					//======================================
					IF LVF_ORDER_REMAIN_QTY >= LVL_DEPARTURE_QTY THEN 
						//========================================
						// $$HEX14$$30ae2000c4b329cc18c2c9b744c72000c0bcbdac20005cd5e4b22000$$ENDHEX$$
						//========================================
						UPDATE IM_ITEM_PURCHASE_ORDER SET ARRIVAL_QTY = NVL(ARRIVAL_QTY,0) + :LVL_DEPARTURE_QTY
						WHERE ROWID = :LVS_ROWID  ;
							IF F_SQL_CHECK() < 0 THEN 
								LVS_ERROR_YN = 'Y'
								RETURN 
							END IF 
							
						DW_1.OBJECT.ORDER_GROUP_NO[N]  = LVS_ORDER_GROUP_NO
						DW_1.OBJECT.ARRIVAL_QTY[N]          = LVL_DEPARTURE_QTY					
						DW_1.OBJECT.UNIT_PRICE[N]     = LVF_UNIT_PRICE
						DW_1.OBJECT.ARRIVAL_AMT[N]  =  LVF_UNIT_PRICE  *  LVL_DEPARTURE_QTY
						DW_1.OBJECT.CURRENCY[N]       = LVS_CURRENCY							
						
						LVL_DEPARTURE_QTY = 0 	
						DW_2.OBJECT.DEPARTURE_QTY[I] = 0  //$$HEX11$$98ccacb9c4d6200094c7c9b744c720005cd4dcc22000$$ENDHEX$$
						CLOSE CL_ORDER ;
						EXIT 
						
					ELSE //$$HEX18$$fcc838bb94c7c9b774c72000c4b329cc200018c2c9b7f4bce4b2200001c83cc774ba2000$$ENDHEX$$
						//========================================
						// $$HEX25$$30ae2000c4b329cc18c2c9b744c72000fcc838bb18c2c9b7fcac2000d9b37cc758d58cac2000c0bcbdac20005cd5e4b22000$$ENDHEX$$
						//========================================
						UPDATE IM_ITEM_PURCHASE_ORDER SET ARRIVAL_QTY = ORDER_QTY // ARRIVAL_QTY + :LVF_ORDER_REMAIN_QTY
						WHERE ROWID = :LVS_ROWID  ;
							
						IF F_SQL_CHECK() < 0 THEN 
							LVS_ERROR_YN = 'Y'							
							RETURN 
						END IF 						
						
						DW_1.OBJECT.ORDER_GROUP_NO[N]  = LVS_ORDER_GROUP_NO
						DW_1.OBJECT.ARRIVAL_QTY[N]          = LVF_ORDER_REMAIN_QTY //$$HEX22$$fcc838bb94c7c9b774c72000c4b329cc200018c2c9b73cc75cb8200018b4e0ac200009000900090009000900$$ENDHEX$$
						DW_1.OBJECT.UNIT_PRICE[N]             = LVF_UNIT_PRICE
						DW_1.OBJECT.ARRIVAL_AMT[N]          = LVF_UNIT_PRICE  *  LVF_ORDER_REMAIN_QTY
						DW_1.OBJECT.CURRENCY[N]               = LVS_CURRENCY				
						
						LVL_DEPARTURE_QTY = LVL_DEPARTURE_QTY - LVF_ORDER_REMAIN_QTY //$$HEX26$$c4b329cc200094c7c9b740c7200074c7f8bb2000c4b329cc5cd5200018c2c9b744c720007cbe1cc12000e4b2dcc22000f4bc00ad$$ENDHEX$$
						DW_2.OBJECT.DEPARTURE_QTY[I] = LVL_DEPARTURE_QTY 
						
					END IF 
					
			LOOP UNTIL 1= 2 		//$$HEX12$$fcc838bb94c7c9b7d0c5200000b35cd52000e4ce1cc12000$$ENDHEX$$
					
	 J++
	 st_msg.text = string(j)+"/"+string(DW_2.ROWCOUNT( ))
	 
LOOP UNTIL I = DW_2.ROWCOUNT( )

//=================================================
//
//=================================================


end event

event rbuttondown;call super::rbuttondown;//LONG N = 1  , I =0  , LVL_ARRIVAL_SEQ , J 
//DECIMAL LVL_DEPARTURE_QTY
//STRING  LVS_INVOICE_NO, LVS_ORDER_NO , LVS_ORDER_GROUP_NO , LVS_SUPPLIER_CODE  , LVS_SUPPLIER_CODE_COND
//STRING LVS_MATERIAL_MFS , LVS_ORIGIN_MFS , LVS_INSPECT_RULE , LVS_ARRIVAL_LOCATION_CODE 
//DATETIME LVDT_DEPARTURE_DATE
//
//STRING LVS_ITEM_CODE_COND , LVS_LINE_TYPE , LVS_ORDER_TYPE , LVS_CURRENCY , LVS_DELIVERY , LVS_INCIDENTAL_EXPENSE_CODE , LVS_SUBCONTRACT_INVOICE_NO					
//DECIMAL LVF_UNIT_PRICE , LVF_ARRIVAL_AMT 
//DATETIME LVDT_DELIVERY_DATE
//STRING LVS_ORDER_GROUP_NO1
//
//IF DW_2.ROWCOUNT() < 1 THEN RETURN 
//
////============================================
//// $$HEX3$$dcc291c72000$$ENDHEX$$
////============================================
//DO
//	I++
//	
//	IF ISNULL(DW_2.OBJECT.ORDER_GROUP_NO[I]) THEN 
//		MESSAGEBOX('NOTIFY','PLEASE CHECK ORDER GROUP NO')
//		RETURN 
//	END IF 
//	
//	LVS_INVOICE_NO = DW_2.OBJECT.INVOICE_NO[I] 
//	LVS_ITEM_CODE_COND =  DW_2.OBJECT.ITEM_CODE[I]		
//	LVS_ORDER_NO  =  DW_2.OBJECT.ORDER_NO[I]		
//	
//	LVS_ORDER_GROUP_NO = DW_2.OBJECT.ORDER_GROUP_NO[I]
//	LVDT_DEPARTURE_DATE = DW_2.OBJECT.DEPARTURE_DATE[I]
//	LVL_DEPARTURE_QTY = DW_2.OBJECT.DEPARTURE_QTY[I]
//	LVS_SUPPLIER_CODE_COND = DW_2.OBJECT.SUPPLIER_CODE[I]
//	
//	
//	N = DW_1.INSERTROW(0)
//	DW_1.SCROLLTOROW(N)
//	F_SET_SECURITY_ROW(DW_1, N, 'ALL')
//	DW_1.OBJECT.ARRIVAL_DATE[N] = F_T_SYSDATE()
//
//	//=======================================
//	//
//	//=======================================	
//	DW_1.OBJECT.DEPARTURE_DATE[N]   = LVDT_DEPARTURE_DATE
//	DW_1.OBJECT.ORDER_NO[N]            = LVS_ORDER_NO
//	DW_1.OBJECT.ITEM_CODE[N]          = LVS_ITEM_CODE_COND
//	DW_1.OBJECT.INVOICE_NO[N]          = LVS_INVOICE_NO
//	DW_1.OBJECT.ORDER_GROUP_NO[N]  = LVS_ORDER_GROUP_NO
//	DW_1.OBJECT.ARRIVAL_QTY[N]          = LVL_DEPARTURE_QTY
//   
//	LVL_ARRIVAL_SEQ = LONG(F_GET_SEQUENCE('SEQ_MAT_ARRIVAL'))
//	DW_1.OBJECT.ARRIVAL_SEQ_NO[N] = LVL_ARRIVAL_SEQ
//	DW_1.OBJECT.ARRIVAL_SEQ_NO_ORIGIN[N] = LVL_ARRIVAL_SEQ
//	DW_1.OBJECT.ARRIVAL_STATUS[N] = 'N'
//	DW_1.OBJECT.MFS[N] = '*'	
//	DW_1.OBJECT.MATERIAL_MFS[N] =  '*'		
//	DW_1.OBJECT.ARRIVAL_LOCATION_CODE[N] = 'INSIDE'	
//	DW_1.OBJECT.ORIGIN_MFS[N] =  '*'	
//	DW_1.OBJECT.COMMENTS[N] ='BATCH UPLOAD'	
//
//	//=======================================                          
//	//
//	//=======================================		
//
//	SELECT SUPPLIER_CODE , LINE_TYPE , ORDER_TYPE , UNIT_PRICE ,  CURRENCY ,DELIVERY , DELIVERY_DATE ,
//	            INCIDENTAL_EXPENSE_CODE , SUBCONTRACT_INVOICE_NO
//        INTO  :LVS_SUPPLIER_CODE , :LVS_LINE_TYPE , :LVS_ORDER_TYPE , :LVF_UNIT_PRICE , :LVS_CURRENCY ,:LVS_DELIVERY , :LVDT_DELIVERY_DATE ,
//	            :LVS_INCIDENTAL_EXPENSE_CODE , :LVS_SUBCONTRACT_INVOICE_NO					
//        FROM IM_ITEM_PURCHASE_ORDER
//      WHERE  ITEM_CODE = :LVS_ITEM_CODE_COND
//	       AND ORDER_GROUP_NO = :LVS_ORDER_GROUP_NO
//		  AND SUPPLIER_CODE = :LVS_SUPPLIER_CODE_COND
//	       AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;		  
//			 
//	IF F_SQL_CHECK() < 0 THEN 
//		RETURN 
//	END IF 	
//	
//	//==============================================
//	//$$HEX30$$fcc838bbb4b0edc574c72000c6c53cc774ba20002000fcc838bb2000f8adf9b8200088bc38d67cb920001cc878c6200058d5e0ac200098ccacb92000$$ENDHEX$$
//	//==============================================
//	
//
//	IF  LVS_LINE_TYPE = '' OR ISNULL(LVS_LINE_TYPE) THEN 
//		
//				SELECT SUPPLIER_CODE , LINE_TYPE , ORDER_TYPE , UNIT_PRICE ,  CURRENCY ,DELIVERY , DELIVERY_DATE ,
//						   INCIDENTAL_EXPENSE_CODE , SUBCONTRACT_INVOICE_NO , ORDER_GROUP_NO
//				INTO  :LVS_SUPPLIER_CODE , :LVS_LINE_TYPE , :LVS_ORDER_TYPE , :LVF_UNIT_PRICE , :LVS_CURRENCY ,:LVS_DELIVERY , :LVDT_DELIVERY_DATE ,
//						:LVS_INCIDENTAL_EXPENSE_CODE , :LVS_SUBCONTRACT_INVOICE_NO ,:LVS_ORDER_GROUP_NO					
//				  FROM IM_ITEM_PURCHASE_ORDER
//				WHERE  ITEM_CODE = :LVS_ITEM_CODE_COND 
//					AND SUPPLIER_CODE = :LVS_SUPPLIER_CODE_COND
//					AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
//					AND ROWNUM = 1 ;		  
//					 
//			IF F_SQL_CHECK() < 0 THEN 
//				RETURN 
//			END IF 		
//			
//			IF  LVS_LINE_TYPE = '' OR ISNULL(LVS_LINE_TYPE) THEN 
//		
//				MESSAGEBOX("ERROR" , LVS_SUPPLIER_CODE_COND+'  '+LVS_ORDER_NO+"  "+LVS_ITEM_CODE_COND+"  ORDER NOT FOUND" )
//				RETURN
//				
//			END IF
//	END IF 	
//	//===========================================
//	//
//	//===========================================	
//	DW_1.OBJECT.ORDER_GROUP_NO[N]  = LVS_ORDER_GROUP_NO	
//	DW_1.OBJECT.SUPPLIER_CODE[N]     = LVS_SUPPLIER_CODE                        // CHOI
//	DW_1.OBJECT.LINE_TYPE[N] = LVS_LINE_TYPE
//	DW_1.OBJECT.ORDER_TYPE[N] = LVS_ORDER_TYPE
//	DW_1.OBJECT.UNIT_PRICE[N]   = LVF_UNIT_PRICE
//	DW_1.OBJECT.ARRIVAL_AMT[N] =  LVF_UNIT_PRICE  *  LVL_DEPARTURE_QTY
//	DW_1.OBJECT.CURRENCY[N]     = LVS_CURRENCY
//
//	DW_1.OBJECT.DELIVERY[N]             = LVS_DELIVERY
//	DW_1.OBJECT.DELIVERY_DATE[N]     = LVDT_DELIVERY_DATE
//
//	DW_1.OBJECT.INCIDENTAL_EXPENSE_CODE[N] = LVS_INCIDENTAL_EXPENSE_CODE
//	DW_1.OBJECT.SUBCONTRACT_INVOICE_NO[N] =  LVS_SUBCONTRACT_INVOICE_NO
//	//=============================================================
//	//
//	//=============================================================
//	LVS_INSPECT_RULE = F_GET_MAT_INSPECT_RULE(LVS_SUPPLIER_CODE_COND ,LVS_ITEM_CODE_COND )
//	
//	IF LVS_INSPECT_RULE = 'P' THEN
//		DW_1.OBJECT.INSPECT_RESULT[N] = 'P'
//		DW_1.OBJECT.INSPECT_RULE[N] = LVS_INSPECT_RULE
//	ELSE
//		DW_1.OBJECT.INSPECT_RESULT[N] = 'W'
//		DW_1.OBJECT.INSPECT_RULE[N] = LVS_INSPECT_RULE
//	END IF
//
//	IF CBX_DEPARTURE_SUBSITUTE_ARRIVAL.CHECKED = TRUE THEN 
//		DW_1.OBJECT.ARRIVAL_TYPE[N] = 'A'   //$$HEX16$$9ccd1cbc44c72000c4b329cc3cc75cb8200000b3e0c268d5200035c658c12000$$ENDHEX$$
//	ELSE
//		DW_1.OBJECT.ARRIVAL_TYPE[N] = 'D'		
//	END IF
//
//	//========================================
//	// $$HEX14$$30ae2000c4b329cc18c2c9b744c72000c0bcbdac20005cd5e4b22000$$ENDHEX$$
//	//========================================
//	
//	UPDATE IM_ITEM_PURCHASE_ORDER SET ARRIVAL_QTY = ARRIVAL_QTY + :LVL_DEPARTURE_QTY
//	WHERE SUPPLIER_CODE = :LVS_SUPPLIER_CODE_COND
//	   AND ITEM_CODE = :LVS_ITEM_CODE_COND
//	   AND ORDER_GROUP_NO =:LVS_ORDER_GROUP_NO //OLD 
//	   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID  ;
//		
//	IF F_SQL_CHECK() < 0 THEN 
//		RETURN 
//	END IF 
//	
//	DW_1.OBJECT.SELECTED_ROW[N] = I
//	 J++
//	 st_msg.text = string(j)+"/"+string(DW_2.ROWCOUNT( ))
//LOOP UNTIL I = DW_2.ROWCOUNT( )
//
////=================================================
////
////=================================================
//
//MSG = F_MSGBOX(1170)
//IF MSG = 1 THEN 
//   IF DW_1.UPDATE( ) < 0 THEN 
//		ROLLBACK;
//	ELSE
//		COMMIT ;
//		f_msgbox(170)		
//	END IF
//ELSE
//	RETURN
//END IF 
end event

type cb_2 from so_commandbutton within w_mat_item_departure_excel_form_popup
integer x = 27
integer y = 256
integer width = 425
integer taborder = 50
boolean bringtotop = true
string text = "Excel Paste"
end type

event clicked;call super::clicked;string lvs_line_code , lvs_item_code , lvs_order_no , lvs_supplier_code , lvs_invoice_no
long i , lvi_count

dw_2.reset()
dw_2.importclipboard( )
//=========================================
//
//=========================================

if dw_2.rowcount( ) < 1 then return 

open(w_progress_popup)
w_progress_popup.f_set_range( 1,  dw_2.rowcount( ) )
w_progress_popup.f_setstep(1)
										
do
	i++
	lvs_item_code = dw_2.object.item_code[i]
	lvs_supplier_code = dw_2.object.supplier_code[i]
	lvs_invoice_no  = dw_2.object.invoice_no[i]

	lvi_count = 0
	select count(*) into :lvi_count from im_item_unit_price
	where item_code = :lvs_item_code
	     and supplier_code = :lvs_supplier_code
	     and organization_id = :gvi_organization_id ;
		  
		  if f_sql_check() < 0 then 
			close(w_progress_popup)
			return
		  end if 
		  
	if lvi_count < 1 then 
		close(w_progress_popup)
		f_msgbox1(815 , string(i)+"  "+lvs_item_code +" "+lvs_supplier_code )
		return 
	end if 		
	
	lvi_count = 0;
	select count(*) into :lvi_count 
	from im_item_receipt 
   where item_code = :lvs_item_code
	  and supplier_code = :lvs_supplier_code
	  and receipt_date >= trunc(sysdate -30)
	  and invoice_no = :lvs_invoice_no
      and organization_id = :gvi_organization_id ;
		
		  if f_sql_check() < 0 then 
			close(w_progress_popup)
			return
		  end if 
		  
	if lvi_count > 0 then 
		close(w_progress_popup)
		f_msgbox1(813 , string(i)+" "+lvs_invoice_no+"  "+lvs_item_code +" "+lvs_supplier_code )
		return 
	end if 				
	
	w_progress_popup.f_stepit()
	
loop until i = dw_2.rowcount( )

close(w_progress_popup)


end event

type pb_1 from so_commandbutton within w_mat_item_departure_excel_form_popup
integer x = 3383
integer y = 248
integer width = 352
integer taborder = 40
boolean bringtotop = true
string text = "Save Form"
end type

event clicked;call super::clicked;string     docname, named 
Long iret

SETPOINTER(HOURGLASS!)		
iret = GetFileSaveName("Select Excel File ("+dw_2.classname()+")" , docname, named, "xls", "Excel Files (*.xls),*.xls")		

IF iret =1 THEN 
		if dw_2.rowcount( ) > 0 then 
		else
		     dw_2.insertrow( 0)	
		end if 
		uf_save_dw_as_excel( dw_2  , docname )
ELSE
	RETURN
END IF
		

end event

type cbx_departure_subsitute_arrival from so_checkbox within w_mat_item_departure_excel_form_popup
integer x = 1541
integer y = 280
integer width = 759
integer height = 80
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Substitute for the arrival"
boolean checked = true
end type

event constructor;call super::constructor;if Gvs_substitute_for_arrival = 'Y' then
	this.checked = True
else
	this.checked = False	
end if
end event

type gb_3 from so_groupbox within w_mat_item_departure_excel_form_popup
integer y = 176
integer width = 4110
integer height = 240
long textcolor = 16711680
string text = "Process"
end type


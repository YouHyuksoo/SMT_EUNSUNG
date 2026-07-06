HA$PBExportHeader$w_mat_item_purchase_excel_form_popup.srw
forward
global type w_mat_item_purchase_excel_form_popup from w_popup_root
end type
type cb_delete from so_commandbutton within w_mat_item_purchase_excel_form_popup
end type
type cb_update from so_commandbutton within w_mat_item_purchase_excel_form_popup
end type
type cb_insert from so_commandbutton within w_mat_item_purchase_excel_form_popup
end type
type cb_2 from so_commandbutton within w_mat_item_purchase_excel_form_popup
end type
type pb_1 from so_commandbutton within w_mat_item_purchase_excel_form_popup
end type
type cbx_auto_po_no from so_checkbox within w_mat_item_purchase_excel_form_popup
end type
type cbx_1 from so_checkbox within w_mat_item_purchase_excel_form_popup
end type
type gb_3 from so_groupbox within w_mat_item_purchase_excel_form_popup
end type
end forward

global type w_mat_item_purchase_excel_form_popup from w_popup_root
integer width = 4887
integer height = 1956
string title = "Purchase Order Form Popup"
cb_delete cb_delete
cb_update cb_update
cb_insert cb_insert
cb_2 cb_2
pb_1 pb_1
cbx_auto_po_no cbx_auto_po_no
cbx_1 cbx_1
gb_3 gb_3
end type
global w_mat_item_purchase_excel_form_popup w_mat_item_purchase_excel_form_popup

type variables
datawindow idw_datawindow
end variables

on w_mat_item_purchase_excel_form_popup.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.cb_insert=create cb_insert
this.cb_2=create cb_2
this.pb_1=create pb_1
this.cbx_auto_po_no=create cbx_auto_po_no
this.cbx_1=create cbx_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.cb_update
this.Control[iCurrent+3]=this.cb_insert
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.cbx_auto_po_no
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.gb_3
end on

on w_mat_item_purchase_excel_form_popup.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.cb_insert)
destroy(this.cb_2)
destroy(this.pb_1)
destroy(this.cbx_auto_po_no)
destroy(this.cbx_1)
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

type p_title from w_popup_root`p_title within w_mat_item_purchase_excel_form_popup
integer width = 4855
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
end type

type cb_sort from w_popup_root`cb_sort within w_mat_item_purchase_excel_form_popup
integer x = 1024
integer y = 0
integer taborder = 40
end type

type cb_close from w_popup_root`cb_close within w_mat_item_purchase_excel_form_popup
boolean visible = true
integer x = 4475
integer y = 248
integer width = 352
integer height = 128
integer taborder = 0
end type

event cb_close::clicked;close(parent)
end event

type st_msg from w_popup_root`st_msg within w_mat_item_purchase_excel_form_popup
boolean visible = true
integer y = 420
integer width = 4864
integer weight = 400
end type

type dw_1 from w_popup_root`dw_1 within w_mat_item_purchase_excel_form_popup
boolean visible = true
integer y = 516
integer width = 2619
integer height = 1324
integer taborder = 20
boolean titlebar = true
string title = "Departure List"
string dataobject = "d_mat_purchase_order_mst"
boolean controlmenu = true
end type

event dw_1::rbuttondown;call super::rbuttondown;decimal lvf_dc_rate , lvf_dc_sale_price

if dwo.name = 'item_code' then 
	
  //   openwithparm( w_sal_sale_price_popup , string(this.object.item_code[row]))
	  
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

//	openwithparm(w_sal_sale_price_popup , string(this.object.item_code[row] ))
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

event dw_1::itemchanged;call super::itemchanged;string lvs_return  , lvs_currency , lvs_delivery
Decimal lvd_unit_price

if dwo.name = 'supplier_code' then 	
	lvs_return = f_get_supplier_name(data , gvi_organization_id)	
	if lvs_return =  'ERROR' then 
		return 1 
	end if 
	if lvs_return = 'NOTFOUND' then 
		return 1  
	end if 
	this.object.supplier_name[row] = lvs_return 	
	this.object.item_code[row] = ''
	this.object.line_type[row] = ''		
end if 
if dwo.name = 'item_code' then    
   lvs_return = f_set_item_name_spec_uom( this , row , this.object.item_code[row] )		
   if 	lvs_return = 'ERROR' THEN 
		return 1
   end if	
	if lvs_return = 'NOTFOUND' then 
		return 1  
	end if 		
   this.object.line_type[row] = ''
   this.object.unit_price[row] = 0
   this.object.currency[row] = ''	 
end if

if  dwo.name = 'line_type' then 	
	
	if Gvs_unit_price_check_yn_4_po = 'N'  then
					this.object.unit_price[row] = 0
					this.object.currency[row] = Gvs_currency
					this.object.delivery[row] = '2'			
	else
	
				lvd_unit_price = f_get_item_unit_price_confirm(this.object.supplier_code[row], this.object.item_code[row], this.object.line_type[row], f_t_sysdate())
				if lvd_unit_price <= 0 or isnull(lvd_unit_price) then 
					this.object.unit_price[row] = 0
					this.object.currency[row] = ''
					this.object.delivery[row] = ''					
					f_msgbox1(9086 , string(this.object.item_code[row]) )
					return 
				else
					this.object.unit_price[row] = lvd_unit_price 			
					lvs_currency = gst_return.gvs_return[1]
					if lvs_currency  = '' or isnull( lvs_currency  ) then 
						f_msgbox1(815 , 'CURRENCY' )
						return 
					end if
					lvs_delivery = gst_return.gvs_return[2]
					if lvs_delivery = '' or isnull(lvs_delivery) then 
						f_msgbox1(815 , 'DELIVERY' )			
						return 
					end if			
					this.object.currency[row] = lvs_currency
					this.object.delivery[row]  = lvs_delivery 			
					gst_return.gvs_return[1] = ''//currency reset						
					gst_return.gvs_return[2] = '' //delivery reset		
				end if
		end if 
end if
		
if  dwo.name = 'order_group_no' then 			
    
string    lvs_order_group_no , LVS_INCIDENTAL_EXPENSE_CODE,LVS_ORIGIN_NATION_CODE,LVS_DELIVERY_PLACE, LVS_DELIVERY_METHOD, LVS_SHIPMENT_COMMENT,   LVS_ATTN_NAME, LVS_CC_NAME
  this.accepttext()
  lvs_order_group_no = THIS.OBJECT.ORDER_GROUP_NO[ROW]
  
  SELECT 
         MAX(IM_ITEM_PURCHASE_ORDER.DELIVERY),   
         MAX(IM_ITEM_PURCHASE_ORDER.INCIDENTAL_EXPENSE_CODE),   
         MAX(IM_ITEM_PURCHASE_ORDER.ORIGIN_NATION_CODE),   
         MAX(IM_ITEM_PURCHASE_ORDER.DELIVERY_PLACE),   
         MAX(IM_ITEM_PURCHASE_ORDER.DELIVERY_METHOD),   
         MAX(IM_ITEM_PURCHASE_ORDER.SHIPMENT_COMMENT),   
         MAX(IM_ITEM_PURCHASE_ORDER.ATTN_NAME),   
         MAX(IM_ITEM_PURCHASE_ORDER.CC_NAME)

    INTO  :LVS_DELIVERY,   
         :LVS_INCIDENTAL_EXPENSE_CODE,   
         :LVS_ORIGIN_NATION_CODE,   
         :LVS_DELIVERY_PLACE,   
         :LVS_DELIVERY_METHOD,   
         :LVS_SHIPMENT_COMMENT,   
         :LVS_ATTN_NAME,   
         :LVS_CC_NAME
    FROM "IM_ITEM_PURCHASE_ORDER"   
  WHERE ORDER_GROUP_NO = :lvs_order_group_no
       AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
   GROUP BY 	ORDER_GROUP_NO , ORGANIZATION_ID	 ;
	
	IF F_SQL_CHECK() < 0 THEN 
		RETURN
	END IF
	
	this.object.delivery[row] = lvs_delivery
	this.object.INCIDENTAL_EXPENSE_CODE[row] = LVS_INCIDENTAL_EXPENSE_CODE
	this.object.origin_nation_code[row] = LVS_ORIGIN_NATION_CODE
     this.object.delivery_place[row]=  LVS_DELIVERY_PLACE
     this.object.delivery_method[row]=    LVS_DELIVERY_METHOD
     this.object.shipment_comment[row]=   LVS_SHIPMENT_COMMENT
     this.object.attn_name[row]=    LVS_ATTN_NAME
     this.object.cc_name[row] =    LVS_CC_NAME
	
end if

if dwo.name = 'order_qty' or dwo.name = 'unit_price' then
	this.object.order_amt[row] = this.object.order_qty[row] * this.object.unit_price[row]
end if
end event

type dw_2 from w_popup_root`dw_2 within w_mat_item_purchase_excel_form_popup
boolean visible = true
integer x = 2619
integer y = 508
integer width = 2240
integer height = 1324
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_item_purchase_excel_popup"
boolean controlmenu = true
boolean maxbox = true
end type

event dw_2::constructor;//override
end event

type dw_3 from w_popup_root`dw_3 within w_mat_item_purchase_excel_form_popup
integer y = 856
integer taborder = 50
end type

type cb_delete from so_commandbutton within w_mat_item_purchase_excel_form_popup
integer x = 750
integer y = 256
integer width = 352
boolean bringtotop = true
string text = "Delete [F3]"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 
dw_1.deleterow( dw_1.getrow())
end event

type cb_update from so_commandbutton within w_mat_item_purchase_excel_form_popup
integer x = 1106
integer y = 256
integer width = 352
integer taborder = 30
boolean bringtotop = true
string text = "Update [F6]"
boolean default = true
end type

event clicked;if dw_1.update( ) < 0 then 
	rollback ;
else
	commit ;
end if 
end event

type cb_insert from so_commandbutton within w_mat_item_purchase_excel_form_popup
integer x = 393
integer y = 256
integer width = 352
integer taborder = 10
boolean bringtotop = true
string text = "Insert [F2]"
end type

event clicked;call super::clicked;LONG N = 1  , I =0  ,  J 
DECIMAL LVL_ORDER_QTY
STRING LVS_ITEM_CODE , LVS_ORDER_NO , LVS_ORDER_GROUO_NO , LVS_SUPPLIER_CODE ,LVS_LINE_TYPE , LVS_ORDER_TYPE , LVS_CURRENCY , LVS_DELIVERY	, LVS_shipment_comment	
DATETIME LVDT_PURCHASE_ORDER_DATE , LVDT_DELIVERY_DATE

IF DW_2.ROWCOUNT() < 1 THEN RETURN 

//============================================
// $$HEX3$$dcc291c72000$$ENDHEX$$
//============================================
DO
	i++
	
	IF ISNULL(DW_2.OBJECT.ORDER_GROUP_NO[I]) THEN 
		//MESS AGEBOX('NOTIFY','PLEASE CHECK ORDER GROUP NO')
		f_msg( 'PLEASE CHECK ORDER GROUP NO', 'P') 
		RETURN 
	END IF

     LVDT_PURCHASE_ORDER_DATE = DW_2.OBJECT.PURCHASE_ORDER_DATE[I]
	LVS_ORDER_GROUO_NO = DW_2.OBJECT.ORDER_GROUP_NO[I]
	
	IF CBX_AUTO_PO_NO.CHECKED = TRUE THEN 
		LVS_ORDER_NO = string(dw_2.object.purchase_order_date[I],'yyyymmdd') + string( f_get_sequence( 'SEQ_PURCHASE_ORDER_NO'),'000')
	ELSE
		LVS_ORDER_NO  =  DW_2.OBJECT.ORDER_NO[I]			 //$$HEX6$$fcc838bb200088bc38d62000$$ENDHEX$$
	END IF 
	
	LVS_ITEM_CODE =  trim(DW_2.OBJECT.ITEM_CODE[I])		 //$$HEX6$$88d4a9ba200054cfdcb42000$$ENDHEX$$
	LVS_LINE_TYPE = trim(DW_2.OBJECT.LINE_TYPE[I]) //$$HEX6$$6cade4b9200020c715d62000$$ENDHEX$$
	LVL_ORDER_QTY = DW_2.OBJECT.ORDER_QTY[I] //$$HEX6$$fcc838bb200018c2c9b72000$$ENDHEX$$
	LVS_SUPPLIER_CODE = trim(DW_2.OBJECT.SUPPLIER_CODE[I]) //$$HEX4$$f5ac09aec1c02000$$ENDHEX$$
	LVDT_DELIVERY_DATE = DW_2.OBJECT.DELIVERY_DATE[I] //$$HEX5$$a9b030ae7cc790c72000$$ENDHEX$$
	LVS_shipment_comment  = DW_2.OBJECT.comments[i] //$$HEX3$$24c185ba2000$$ENDHEX$$
	
	N = DW_1.INSERTROW(0)
	DW_1.SCROLLTOROW(N)
	F_SET_SECURITY_ROW(DW_1, N, 'ALL')

	//=======================================
	//
	//=======================================	
	DW_1.OBJECT.PURCHASE_ORDER_DATE[N]   = LVDT_PURCHASE_ORDER_DATE
	DW_1.OBJECT.ORDER_NO[N]              = LVS_ORDER_NO
	DW_1.OBJECT.ITEM_CODE[N]             = LVS_ITEM_CODE
	DW_1.OBJECT.ORDER_GROUP_NO[N]  = LVS_ORDER_GROUO_NO
	DW_1.OBJECT.ORDER_QTY[N]            = LVL_ORDER_QTY
	DW_1.OBJECT.ARRIVAL_QTY[N]          = 0
	DW_1.OBJECT.shipment_comment[N]   =LVS_shipment_comment
	DW_1.OBJECT.SUPPLIER_CODE[N]       = LVS_SUPPLIER_CODE
	DW_1.OBJECT.LINE_TYPE[N] = LVS_LINE_TYPE
	DW_1.OBJECT.ORDER_TYPE[N]             = 'M'
	DW_1.OBJECT.DELIVERY[N]                  = '2' 
	DW_1.OBJECT.DELIVERY_DATE[N]        = LVDT_DELIVERY_DATE
	DW_1.OBJECT.MFS[N]     = '*'	

	dw_1.trigger event itemchanged( n, dw_1.object.line_type ,string(dw_1.object.line_type[n]) )
	
 J++
 st_msg.text = string(j)+"/"+string(DW_2.ROWCOUNT( ))
LOOP UNTIL I = DW_2.ROWCOUNT( )

//=================================================
//
//=================================================

//MSG = F_MSGBOX(1170)
MSG = 1 
IF MSG = 1 THEN 
   IF DW_1.UPDATE( ) < 0 THEN 
		ROLLBACK;
	ELSE
		COMMIT ;
		f_msgbox(170)
		DW_1.RESET()
		DW_2.RESET()
	END IF
ELSE
	RETURN
END IF 
end event

type cb_2 from so_commandbutton within w_mat_item_purchase_excel_form_popup
integer x = 27
integer y = 256
integer width = 352
integer taborder = 50
boolean bringtotop = true
string text = "Excel Paste"
end type

event clicked;call super::clicked;string  lvs_item_code , lvs_supplier_code
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
	
	lvi_count = 0
	select count(*) into :lvi_count from im_item_unit_price
	where item_code = :lvs_item_code
	    and supplier_code =:lvs_supplier_code
	     and organization_id = :gvi_organization_id ;
		  
		  if f_sql_check() < 0 then 
			close(w_progress_popup)
			return
		  end if 
		  
	if lvi_count < 1 then 
		close(w_progress_popup)
		f_msgbox1(815 , string(i)+"  "+lvs_item_code +"  "+lvs_supplier_code)
		DW_2.RESET()
	    return 
	end if 		
	
	w_progress_popup.f_stepit()
	
loop until i = dw_2.rowcount( )
close(w_progress_popup)

end event

type pb_1 from so_commandbutton within w_mat_item_purchase_excel_form_popup
integer x = 4119
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
		dw_2.insertrow( 0)
		uf_save_dw_as_excel( dw_2  , docname )
ELSE
	RETURN
END IF
		

end event

type cbx_auto_po_no from so_checkbox within w_mat_item_purchase_excel_form_popup
integer x = 1495
integer y = 236
integer width = 759
integer height = 80
boolean bringtotop = true
integer weight = 700
string text = "Auto PO No"
boolean checked = true
end type

type cbx_1 from so_checkbox within w_mat_item_purchase_excel_form_popup
integer x = 1495
integer y = 308
integer width = 759
integer height = 80
boolean bringtotop = true
integer weight = 700
string text = "PO Cancel"
end type

type gb_3 from so_groupbox within w_mat_item_purchase_excel_form_popup
integer y = 176
integer width = 4859
integer height = 240
long textcolor = 16711680
string text = "Process"
end type


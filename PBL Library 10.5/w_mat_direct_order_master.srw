HA$PBExportHeader$w_mat_direct_order_master.srw
$PBExportComments$Material Purchase Order Master
forward
global type w_mat_direct_order_master from w_main_root
end type
type st_1 from so_statictext within w_mat_direct_order_master
end type
type ddlb_item_code from uo_item_code within w_mat_direct_order_master
end type
type st_3 from so_statictext within w_mat_direct_order_master
end type
type uo_dateset from uo_ymd_calendar within w_mat_direct_order_master
end type
type rb_lst from so_radiobutton within w_mat_direct_order_master
end type
type rb_hst from so_radiobutton within w_mat_direct_order_master
end type
type st_4 from so_statictext within w_mat_direct_order_master
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_direct_order_master
end type
type sle_item_name from so_singlelineedit within w_mat_direct_order_master
end type
type st_14 from so_statictext within w_mat_direct_order_master
end type
type sle_1 from so_singlelineedit within w_mat_direct_order_master
end type
type st_5 from so_statictext within w_mat_direct_order_master
end type
type uo_dateend from uo_ymdend_calendar within w_mat_direct_order_master
end type
type tab_1 from tab within w_mat_direct_order_master
end type
type tabpage_2 from userobject within tab_1
end type
type cb_1 from so_commandbutton within tabpage_2
end type
type cb_merge from so_commandbutton within tabpage_2
end type
type cb_divide from so_commandbutton within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_1 cb_1
cb_merge cb_merge
cb_divide cb_divide
end type
type tabpage_3 from userobject within tab_1
end type
type cb_cancel from so_commandbutton within tabpage_3
end type
type cb_group from so_commandbutton within tabpage_3
end type
type cbx_auto_group_no from so_checkbox within tabpage_3
end type
type tabpage_3 from userobject within tab_1
cb_cancel cb_cancel
cb_group cb_group
cbx_auto_group_no cbx_auto_group_no
end type
type tab_1 from tab within w_mat_direct_order_master
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type sle_order_group_no from so_singlelineedit within w_mat_direct_order_master
end type
type st_7 from so_statictext within w_mat_direct_order_master
end type
type cbx_show_all from so_checkbox within w_mat_direct_order_master
end type
type gb_1 from so_groupbox within w_mat_direct_order_master
end type
type gb_5 from so_groupbox within w_mat_direct_order_master
end type
end forward

global type w_mat_direct_order_master from w_main_root
integer width = 4754
integer height = 2972
string title = "Material Direct Order Master"
st_1 st_1
ddlb_item_code ddlb_item_code
st_3 st_3
uo_dateset uo_dateset
rb_lst rb_lst
rb_hst rb_hst
st_4 st_4
ddlb_supplier_code ddlb_supplier_code
sle_item_name sle_item_name
st_14 st_14
sle_1 sle_1
st_5 st_5
uo_dateend uo_dateend
tab_1 tab_1
sle_order_group_no sle_order_group_no
st_7 st_7
cbx_show_all cbx_show_all
gb_1 gb_1
gb_5 gb_5
end type
global w_mat_direct_order_master w_mat_direct_order_master

type variables
string ivs_preview_yn = 'N'
end variables

on w_mat_direct_order_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.uo_dateset=create uo_dateset
this.rb_lst=create rb_lst
this.rb_hst=create rb_hst
this.st_4=create st_4
this.ddlb_supplier_code=create ddlb_supplier_code
this.sle_item_name=create sle_item_name
this.st_14=create st_14
this.sle_1=create sle_1
this.st_5=create st_5
this.uo_dateend=create uo_dateend
this.tab_1=create tab_1
this.sle_order_group_no=create sle_order_group_no
this.st_7=create st_7
this.cbx_show_all=create cbx_show_all
this.gb_1=create gb_1
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.uo_dateset
this.Control[iCurrent+5]=this.rb_lst
this.Control[iCurrent+6]=this.rb_hst
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.ddlb_supplier_code
this.Control[iCurrent+9]=this.sle_item_name
this.Control[iCurrent+10]=this.st_14
this.Control[iCurrent+11]=this.sle_1
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.uo_dateend
this.Control[iCurrent+14]=this.tab_1
this.Control[iCurrent+15]=this.sle_order_group_no
this.Control[iCurrent+16]=this.st_7
this.Control[iCurrent+17]=this.cbx_show_all
this.Control[iCurrent+18]=this.gb_1
this.Control[iCurrent+19]=this.gb_5
end on

on w_mat_direct_order_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.uo_dateset)
destroy(this.rb_lst)
destroy(this.rb_hst)
destroy(this.st_4)
destroy(this.ddlb_supplier_code)
destroy(this.sle_item_name)
destroy(this.st_14)
destroy(this.sle_1)
destroy(this.st_5)
destroy(this.uo_dateend)
destroy(this.tab_1)
destroy(this.sle_order_group_no)
destroy(this.st_7)
destroy(this.cbx_show_all)
destroy(this.gb_1)
destroy(this.gb_5)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property 
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('DATA_CONTROL' , FALSE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')

if Gvi_user_level >= 8 then 

else
ddlb_supplier_code.text = Gvs_user_id
end if 

end event

event ue_data_control;call super::ue_data_control;Long row
String lvs_date , lvs_user_id
choose case gvs_ue_data_control
		
	case 'RETRIEVE'			
		dw_1.reset()
		dw_2.reset()
		dw_3.reset()
		if rb_lst.checked then 
			
			if cbx_show_all.checked = true then 
				lvs_user_id = '%'
			else
				lvs_user_id = Gvs_user_id+'%'				
			end if
			
			dw_1.retrieve(ddlb_supplier_code.text+'%' , ddlb_item_code.text() + '%',  uo_dateset.text() , uo_dateend.text(),  sle_order_group_no.text+'%' , '%' ,  gvi_organization_id)
		else
			dw_3.retrieve(ddlb_supplier_code.text+'%' , ddlb_item_code.text() + '%',  uo_dateset.text() , uo_dateend.text(),   '%' , gvi_organization_id)
		end if

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_direct_order_master
integer y = 564
integer height = 396
end type

type dw_4 from w_main_root`dw_4 within w_mat_direct_order_master
integer y = 564
integer height = 396
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_mat_direct_order_master
integer y = 564
integer width = 4544
integer height = 1360
boolean titlebar = true
string title = "Material Direct Order History"
string dataobject = "d_mat_direct_order_group_lst"
end type

event dw_3::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
dw_4.retrieve(this.object.order_group_no[currentrow], this.object.supplier_code[currentrow], gvi_organization_id)
					

end event

event dw_3::doubleclicked;call super::doubleclicked;if row < 1 then return
dw_4.retrieve(this.object.order_group_no[row], this.object.supplier_code[row], gvi_organization_id)
					

end event

type dw_2 from w_main_root`dw_2 within w_mat_direct_order_master
integer y = 1928
integer width = 4535
integer height = 724
string dataobject = "d_mat_direct_order_mst"
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::itemchanged;call super::itemchanged;string lvs_return  , lvs_currency , lvs_delivery
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
	lvd_unit_price = f_get_item_unit_price_confirm(this.object.supplier_code[row], this.object.item_code[row], this.object.line_type[row], f_t_sysdate())
	if lvd_unit_price <= 0 or isnull(lvd_unit_price) then 
		this.object.unit_price[row] = 0
		this.object.currency[row] = ''
		this.object.delivery[row] = ''					
		f_msgbox1(9086 , string(this.object.item_code[row]) )
//		messagebox('Notify','Return unit price is error!')
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

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'item_code' or dwo.name = 'supplier_code' then
	
	open(w_mat_unit_price_popup)
	
	if gst_return.gvb_return = false then 
		
	else
	      this.object.supplier_code[row] = Gst_return.Gvs_return[2]
		trigger event itemchanged( row , this.object.supplier_code , this.object.supplier_code[row] ) 				 		
		
		this.object.item_code[row] =Gst_return.Gvs_return[4]
		trigger event itemchanged( row , this.object.item_code , this.object.item_code[row] ) 		
		this.object.item_name[row] = gst_return.gvs_return[7]
		this.object.item_spec[row] = gst_return.gvs_return[8]	
 
		this.object.supplier_name[row] = Gst_return.Gvs_return[3] 
		this.object.line_type[row] = Gst_return.Gvs_return[6] 
		trigger event itemchanged( row , this.object.line_type , this.object.line_type[row] ) 				
		this.object.item_uom[row] = gst_return.gvs_return[9]	

		gst_return.gvs_return[1] = ''
		gst_return.gvs_return[2] = ''
		gst_return.gvs_return[3] = ''
		gst_return.gvs_return[4] = ''
		gst_return.gvs_return[5] = ''
		gst_return.gvs_return[6] = ''
		gst_return.gvs_return[7] = ''
		gst_return.gvs_return[8] = ''	
		gst_return.gvs_return[9] = ''				

	end if 

end if 
		

end event

event dw_2::clicked;call super::clicked;if dwo.name = 'b_group_no' then 
	this.object.order_group_no[row] = string(f_t_sysdate(),'yyyymmdd') + string( f_get_sequence( 'SEQ_PURCHASE_ORDER_NO'),'000')
end if
end event

type dw_1 from w_main_root`dw_1 within w_mat_direct_order_master
integer y = 564
integer width = 4544
integer height = 1360
boolean titlebar = true
string title = "Direct Order List"
string dataobject = "d_mat_direct_order_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF CURRENTROW = 0 THEN RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( CURRENTROW , 'ROWID' ) )

end event

event dw_1::doubleclicked;call super::doubleclicked;IF ROW < 1  THEN RETURN
DW_2.RETRIEVE( DW_1.GETITEMSTRING( ROW , 'ROWID' ) )

end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_direct_order_master
end type

type st_1 from so_statictext within w_mat_direct_order_master
integer x = 1038
integer y = 88
integer width = 521
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_direct_order_master
integer x = 1038
integer y = 164
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_direct_order_master
integer x = 1563
integer y = 88
integer width = 805
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Delivery Date"
end type

type uo_dateset from uo_ymd_calendar within w_mat_direct_order_master
integer x = 1559
integer y = 164
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type rb_lst from so_radiobutton within w_mat_direct_order_master
integer x = 37
integer y = 80
integer width = 507
boolean bringtotop = true
integer weight = 700
string text = "Order List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

end event

type rb_hst from so_radiobutton within w_mat_direct_order_master
integer x = 37
integer y = 180
integer width = 507
boolean bringtotop = true
integer weight = 700
string text = "Order History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3

f_retrieve()
end event

type st_4 from so_statictext within w_mat_direct_order_master
integer x = 594
integer y = 88
integer width = 439
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type ddlb_supplier_code from uo_supplier_code within w_mat_direct_order_master
integer x = 594
integer y = 164
integer width = 439
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;if Gvi_user_level >=3 then 
	this.enabled = true
else
	this.enabled = false
end if 
end event

type sle_item_name from so_singlelineedit within w_mat_direct_order_master
integer x = 2793
integer y = 164
integer width = 402
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN


IF rb_lst.Checked = TRUE THEN 

	DW_1.SETFILTER('')
	DW_1.FILTER()
	
	LVS_COLUMN = 'ITEM_NAME'
	IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
		RETURN 
	END IF
	
	IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
		 DW_1.SETFILTER('')
		 DW_1.FILTER()	
		 RETURN
	ELSE
		LVS_VALUE = '%'+this.text+'%'
	END IF
	
	DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
	DW_1.FILTER()
	F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found" )
ELSE
	
	DW_3.SETFILTER('')
	DW_3.FILTER()
	
	LVS_COLUMN = 'ITEM_NAME'
	IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
		RETURN 
	END IF
	
	IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
		 DW_3.SETFILTER('')
		 DW_3.FILTER()	
		 RETURN
	ELSE
		LVS_VALUE = '%'+this.text+'%'
	END IF
	
	DW_3.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
	DW_3.FILTER()
	F_MSG_MDI_HELP( STRING( DW_3.ROWCOUNT() ) + " Found" )
END IF
	
	
end event

type st_14 from so_statictext within w_mat_direct_order_master
integer x = 2793
integer y = 88
integer width = 402
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Name"
end type

type sle_1 from so_singlelineedit within w_mat_direct_order_master
integer x = 3195
integer y = 164
integer width = 416
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN


IF rb_lst.Checked = TRUE THEN 

	DW_1.SETFILTER('')
	DW_1.FILTER()
	
	LVS_COLUMN = 'ITEM_SPEC'
	IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
		RETURN 
	END IF
	
	IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
		 DW_1.SETFILTER('')
		 DW_1.FILTER()	
		 RETURN
	ELSE
		LVS_VALUE = '%'+this.text+'%'
	END IF
	
	DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
	DW_1.FILTER()
	F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found" )
ELSE
	
	DW_3.SETFILTER('')
	DW_3.FILTER()
	
	LVS_COLUMN = 'ITEM_SPEC'
	IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
		RETURN 
	END IF
	
	IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
		 DW_3.SETFILTER('')
		 DW_3.FILTER()	
		 RETURN
	ELSE
		LVS_VALUE = '%'+this.text+'%'
	END IF
	
	DW_3.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
	DW_3.FILTER()
	F_MSG_MDI_HELP( STRING( DW_3.ROWCOUNT() ) + " Found" )
END IF
	
	
end event

type st_5 from so_statictext within w_mat_direct_order_master
integer x = 3195
integer y = 88
integer width = 416
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Spec"
end type

type uo_dateend from uo_ymdend_calendar within w_mat_direct_order_master
integer x = 1970
integer y = 160
integer height = 92
integer taborder = 70
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymdend_calendar::destroy
end on

type tab_1 from tab within w_mat_direct_order_master
event create ( )
event destroy ( )
integer y = 312
integer width = 3223
integer height = 248
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean fixedwidth = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
integer selectedtab = 1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3186
integer height = 120
long backcolor = 15780518
string text = "Lot Divide"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "ArrangeTables!"
long picturemaskcolor = 12632256
cb_1 cb_1
cb_merge cb_merge
cb_divide cb_divide
end type

on tabpage_2.create
this.cb_1=create cb_1
this.cb_merge=create cb_merge
this.cb_divide=create cb_divide
this.Control[]={this.cb_1,&
this.cb_merge,&
this.cb_divide}
end on

on tabpage_2.destroy
destroy(this.cb_1)
destroy(this.cb_merge)
destroy(this.cb_divide)
end on

type cb_1 from so_commandbutton within tabpage_2
integer x = 667
integer y = 12
integer width = 315
integer height = 100
integer taborder = 50
boolean bringtotop = true
string text = "Copy"
end type

event clicked;call super::clicked;LONG LVS_ROW 
String lvs_data
Msg= F_MSGBOX( 9016 ) //$$HEX10$$f5bcacc0200058d5dcc2a0acb5c2c8b24cae2000$$ENDHEX$$?

IF MSG = 1 THEN 
	dw_2.selectrow( 0 , FALSE)
	LVS_ROW  = dw_2.GetRow()
	
	dw_2.RowsCopy(dw_2.GetRow(), dw_2.GetRow(), Primary!, dw_2, dw_2.GetRow(), Primary!)
	dw_2.SCROLLTOROW(LVS_ROW)
	dw_2.SELECTROW(LVS_ROW , TRUE)
	
	lvs_data = string(dw_2.object.purchase_order_date[lvs_row],'yyyymmdd') + string( f_get_sequence( 'SEQ_PURCHASE_ORDER_NO'),'000')
	dw_2.object.order_no[lvs_row] = lvs_data
	dw_2.object.item_code[lvs_row] = ''
	dw_2.object.line_type[lvs_row] = ''	
	dw_2.object.item_name[lvs_row] = ''	
	dw_2.object.item_spec[lvs_row] = ''		
	dw_2.object.item_uom[lvs_row] = ''		
	dw_2.object.order_qty[lvs_row] = 0 
	dw_2.object.unit_price[lvs_row] = 0 	
	dw_2.object.currency[lvs_row] = ''
     dw_2.setcolumn( 'item_code')
	
ELSE
	 RETURN
END IF

end event

type cb_merge from so_commandbutton within tabpage_2
integer x = 343
integer y = 12
integer width = 315
integer height = 100
integer taborder = 40
boolean bringtotop = true
string text = "Merge"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1  then return 

long i , j= 0 , k= 1 , lvl_row[]
Decimal lvl_order_qty
msg = f_msgbox1(1161, this.text)
if msg = 1 then 
else
	return 
end if 
for i = 1 to dw_1.rowcount() 
     if dw_1.object.check_yn[i] = 'Y'  then 
		if dw_1.object.arrival_qty[i] = 0 then 
		else
		     messagebox('Notify','The arrival qty of this record is found,so it can not be performed!')
		     return 
		end if 
		j++
		lvl_row[k] = dw_1.object.selected_row[i]
		k++
	else
		continue 
	end if 				
next 
if j <>  2  then 
	messagebox('Notify','You would select two records.') 
	return 
end if 
if (dw_1.object.item_code[lvl_row[1]] = dw_1.object.item_code[lvl_row[2]]) and (dw_1.object.supplier_code[lvl_row[1]] = dw_1.object.supplier_code[lvl_row[2]])  and &
   (dw_1.object.unit_price[lvl_row[1]] = dw_1.object.unit_price[lvl_row[2]]) and (dw_1.object.line_type[lvl_row[1]] = dw_1.object.line_type[lvl_row[2]]) then 
	
	lvl_order_qty = dw_1.object.order_qty[lvl_row[1]]  + dw_1.object.order_qty[lvl_row[2]]
	dw_1.object.order_qty[lvl_row[1]]  = lvl_order_qty
	dw_1.object.order_amt[lvl_row[1]] = dw_1.object.order_qty[lvl_row[1]] * dw_1.object.unit_price[lvl_row[1]]	
	dw_1.object.check_yn[lvl_row[1]] = 'N'
	dw_1.deleterow(lvl_row[2])
else
	messagebox('Notify','Two records are not match,please select again.')
	return 
end if 

msg = f_msgbox(1170)
if msg = 1 then 

	if dw_1.update() < 0 then 
		rollback; 
		f_msg_mdi_help(f_msg_st(9026))
	else
		commit; 
		f_msg_mdi_help(f_msg_st(170))
		f_retrieve()
	end if 
else
	f_retrieve()
end if

	

		
end event

type cb_divide from so_commandbutton within tabpage_2
integer x = 23
integer y = 12
integer width = 315
integer height = 100
integer taborder = 30
boolean bringtotop = true
string text = "Divide"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1 then return 
Long j
Decimal  lvl_origin_qty, lvl_new_qty, lvl_arrival_qty
String lvs_date
msg = f_msgbox1(1161, this.text)
if msg = 1 then 
else
	return 
end if 
if dw_1.object.check_yn[dw_1.getrow()] = 'Y' then 		
else
	return 
end if 
lvl_arrival_qty = dw_1.object.arrival_qty[dw_1.getrow()]
if dw_1.object.arrival_qty[dw_1.getrow()] = 0 then 
else
	messagebox('Notify','The arrival qty of this record is found,so it can not be performed!')
	return 
end if 

lvl_origin_qty =  dw_1.object.order_qty[dw_1.getrow()]
openwithparm(w_mat_order_qty_divide_popup, lvl_origin_qty)
if gst_return.gvb_return = false then 
	return
else 	
	lvl_new_qty = gst_return.gvl_return[1]
	gst_return.gvl_return[1] = 0 
end if 
if lvl_new_qty >= lvl_origin_qty  then 
	messagebox('Notify','Divide Qty Should be smaller than the origin qty, please do again!')
	return 
end if 
j = dw_1.getrow()

dw_1.rowscopy(j, j, Primary!, dw_1, j+1 , Primary!)
dw_1.object.order_qty[j] = lvl_origin_qty -  lvl_new_qty
dw_1.object.order_amt[j] = dw_1.object.order_qty[j] * dw_1.object.unit_price[j]

dw_1.object.order_qty[j + 1]  = lvl_new_qty
dw_1.object.order_amt[j +1] = dw_1.object.order_qty[j+1] * dw_1.object.unit_price[j+1]
lvs_date =  string(dw_1.object.purchase_order_date[j],'yyyymmdd') + string( f_get_sequence( 'SEQ_PURCHASE_ORDER_NO'),'000')
dw_1.object.mfs[j + 1]  = lvs_date
dw_1.object.order_no[j + 1]  = lvs_date
dw_1.object.check_yn[j] = 'N'
dw_1.object.check_yn[j+1] = 'N'
if dw_1.update() < 0 then 
	rollback; 
	f_msg_mdi_help(f_msg_st(9026))
else
	commit; 
	f_msg_mdi_help(f_msg_st(170))
	f_retrieve()
end if 


end event

type tabpage_3 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3186
integer height = 120
long backcolor = 15780518
string text = "Order Group"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "GroupBox!"
long picturemaskcolor = 12632256
cb_cancel cb_cancel
cb_group cb_group
cbx_auto_group_no cbx_auto_group_no
end type

on tabpage_3.create
this.cb_cancel=create cb_cancel
this.cb_group=create cb_group
this.cbx_auto_group_no=create cbx_auto_group_no
this.Control[]={this.cb_cancel,&
this.cb_group,&
this.cbx_auto_group_no}
end on

on tabpage_3.destroy
destroy(this.cb_cancel)
destroy(this.cb_group)
destroy(this.cbx_auto_group_no)
end on

type cb_cancel from so_commandbutton within tabpage_3
integer x = 1051
integer y = 8
integer width = 315
integer height = 112
integer taborder = 70
boolean bringtotop = true
string text = "Cancel"
end type

event clicked;call super::clicked;long  i 

if f_object_role_check() = false then return 

if dw_1.rowcount() < 1 then return 

for i = 1 to dw_1.rowcount() 
	if dw_1.object.check_yn[i] = 'Y' then 
		
		if isnull(dw_1.object.order_group_no[i]) then 
			messagebox('Notify','Order group no is null, please try it again')
			return 
		else
			dw_1.object.order_group_no[i] = ''
		end if 
	end if 
next

msg = f_msgbox(1171)
if msg = 1 then
		
	if dw_1.update() < 0 then 
		rollback; 
		f_msg_mdi_help(f_msg_st(9026))
	else
		commit ; 
		f_msg_mdi_help(f_msg_st(170))
		f_retrieve()
	end if 
else
		f_retrieve()
end if 
end event

type cb_group from so_commandbutton within tabpage_3
integer x = 727
integer y = 8
integer width = 315
integer height = 112
integer taborder = 60
boolean bringtotop = true
string text = "Generate"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1 then return 
long i , j 
string lvs_supplier_code, lvs_date
msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else
	return 
end if 
for i = 1 to dw_1.rowcount() 
	
	if dw_1.object.check_yn[i] = 'Y' and  dw_1.object.arrival_qty[i] = 0 then 
		lvs_supplier_code = dw_1.object.supplier_code[i]
		exit 
	elseif dw_1.object.check_yn[i] = 'Y' and  dw_1.object.arrival_qty[i] <> 0 then 
		messagebox('Notify','Arrival qty is exists, so you can not generate order group no!')
		return 
	end if 
next
//if i > 1 then 	
	for j =  i   to dw_1.rowcount()
		if dw_1.object.check_yn[j] = 'Y'  and dw_1.object.arrival_qty[i] = 0 then 
			if lvs_supplier_code <> dw_1.object.supplier_code[j] then 
				messagebox('Notify','Supplier code should be the same, please try it again.')
				return 
			end if 
		elseif dw_1.object.check_yn[i] = 'Y' and  dw_1.object.arrival_qty[i] <> 0 then 
		    messagebox('Notify','Arrival qty is exists, so you can not generate order group no!')
		    return 
		end if
	next
//else
//	messagebox('Notify','Please select records, first!')
//	return 
//end if 
lvs_date = string(f_t_sysdate(),'yyyymmdd') + string( f_get_sequence( 'SEQ_PURCHASE_ORDER_NO'),'000')
for i = 1 to dw_1.rowcount() 
	if dw_1.object.check_yn[i] = 'Y' and dw_1.object.arrival_qty[i] = 0  then 
		dw_1.object.order_group_no[i] = lvs_date
	end if 
next
//====================================
//
//====================================

//msg = f_msgbox(1171)
//if msg = 1 then 
	
	if dw_1.update() < 0 then 
		rollback ; 
		f_msg_mdi_help(f_msg_st(9026))
	else
		commit ; 
		f_msg_mdi_help(f_msg_st(170))
		f_retrieve()
	end if 
//else
//		f_retrieve()
//end if 
//
		
		
	
end event

type cbx_auto_group_no from so_checkbox within tabpage_3
integer x = 23
integer y = 20
integer width = 631
integer height = 80
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Auto Group No"
end type

type sle_order_group_no from so_singlelineedit within w_mat_direct_order_master
integer x = 2382
integer y = 164
integer width = 411
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN


IF rb_lst.Checked = TRUE THEN 

	DW_1.SETFILTER('')
	DW_1.FILTER()
	
	LVS_COLUMN = 'ORDER_GROUP_NO'
	IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
		RETURN 
	END IF
	
	IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
		 DW_1.SETFILTER('')
		 DW_1.FILTER()	
		 RETURN
	ELSE
		LVS_VALUE = '%'+this.text+'%'
	END IF
	
	DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
	DW_1.FILTER()
	F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found" )
ELSE
	
	DW_3.SETFILTER('')
	DW_3.FILTER()
	
	LVS_COLUMN = 'ORDER_GROUP_NO'
	IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
		RETURN 
	END IF
	
	IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
		 DW_3.SETFILTER('')
		 DW_3.FILTER()	
		 RETURN
	ELSE
		LVS_VALUE = '%'+this.text+'%'
	END IF
	
	DW_3.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
	DW_3.FILTER()
	F_MSG_MDI_HELP( STRING( DW_3.ROWCOUNT() ) + " Found" )
END IF
	
	
end event

type st_7 from so_statictext within w_mat_direct_order_master
integer x = 2382
integer y = 88
integer width = 411
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Order Group No"
end type

type cbx_show_all from so_checkbox within w_mat_direct_order_master
integer x = 3250
integer y = 448
integer width = 526
boolean bringtotop = true
integer weight = 700
string text = "Show All"
boolean checked = true
end type

type gb_1 from so_groupbox within w_mat_direct_order_master
integer x = 571
integer y = 4
integer width = 3072
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_5 from so_groupbox within w_mat_direct_order_master
integer y = 4
integer width = 567
integer height = 300
integer taborder = 50
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type


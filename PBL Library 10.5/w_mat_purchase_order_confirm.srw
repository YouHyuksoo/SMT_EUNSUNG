HA$PBExportHeader$w_mat_purchase_order_confirm.srw
$PBExportComments$Material Buy Price Master
forward
global type w_mat_purchase_order_confirm from w_main_root
end type
type gb_1 from so_groupbox within w_mat_purchase_order_confirm
end type
type cb_confirm from so_commandbutton within w_mat_purchase_order_confirm
end type
type cb_cancel from so_commandbutton within w_mat_purchase_order_confirm
end type
type rb_wait from so_radiobutton within w_mat_purchase_order_confirm
end type
type rb_confirmed from so_radiobutton within w_mat_purchase_order_confirm
end type
type st_4 from so_statictext within w_mat_purchase_order_confirm
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_purchase_order_confirm
end type
type ddlb_item_code from uo_item_code within w_mat_purchase_order_confirm
end type
type st_1 from so_statictext within w_mat_purchase_order_confirm
end type
type uo_dateset from uo_ymd_calendar within w_mat_purchase_order_confirm
end type
type st_3 from so_statictext within w_mat_purchase_order_confirm
end type
type uo_dateend from uo_ymdend_calendar within w_mat_purchase_order_confirm
end type
type sle_order_group_no from so_singlelineedit within w_mat_purchase_order_confirm
end type
type st_7 from so_statictext within w_mat_purchase_order_confirm
end type
type sle_item_name from so_singlelineedit within w_mat_purchase_order_confirm
end type
type st_14 from so_statictext within w_mat_purchase_order_confirm
end type
type sle_1 from so_singlelineedit within w_mat_purchase_order_confirm
end type
type st_5 from so_statictext within w_mat_purchase_order_confirm
end type
type ddlb_order_type from uo_basecode within w_mat_purchase_order_confirm
end type
type st_8 from so_statictext within w_mat_purchase_order_confirm
end type
type gb_2 from so_groupbox within w_mat_purchase_order_confirm
end type
type gb_3 from so_groupbox within w_mat_purchase_order_confirm
end type
end forward

global type w_mat_purchase_order_confirm from w_main_root
integer width = 4681
integer height = 2848
string title = "Material Buy Price Confirm Master"
gb_1 gb_1
cb_confirm cb_confirm
cb_cancel cb_cancel
rb_wait rb_wait
rb_confirmed rb_confirmed
st_4 st_4
ddlb_supplier_code ddlb_supplier_code
ddlb_item_code ddlb_item_code
st_1 st_1
uo_dateset uo_dateset
st_3 st_3
uo_dateend uo_dateend
sle_order_group_no sle_order_group_no
st_7 st_7
sle_item_name sle_item_name
st_14 st_14
sle_1 sle_1
st_5 st_5
ddlb_order_type ddlb_order_type
st_8 st_8
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_purchase_order_confirm w_mat_purchase_order_confirm

on w_mat_purchase_order_confirm.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.cb_confirm=create cb_confirm
this.cb_cancel=create cb_cancel
this.rb_wait=create rb_wait
this.rb_confirmed=create rb_confirmed
this.st_4=create st_4
this.ddlb_supplier_code=create ddlb_supplier_code
this.ddlb_item_code=create ddlb_item_code
this.st_1=create st_1
this.uo_dateset=create uo_dateset
this.st_3=create st_3
this.uo_dateend=create uo_dateend
this.sle_order_group_no=create sle_order_group_no
this.st_7=create st_7
this.sle_item_name=create sle_item_name
this.st_14=create st_14
this.sle_1=create sle_1
this.st_5=create st_5
this.ddlb_order_type=create ddlb_order_type
this.st_8=create st_8
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.cb_confirm
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.rb_wait
this.Control[iCurrent+5]=this.rb_confirmed
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.ddlb_supplier_code
this.Control[iCurrent+8]=this.ddlb_item_code
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.uo_dateset
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.uo_dateend
this.Control[iCurrent+13]=this.sle_order_group_no
this.Control[iCurrent+14]=this.st_7
this.Control[iCurrent+15]=this.sle_item_name
this.Control[iCurrent+16]=this.st_14
this.Control[iCurrent+17]=this.sle_1
this.Control[iCurrent+18]=this.st_5
this.Control[iCurrent+19]=this.ddlb_order_type
this.Control[iCurrent+20]=this.st_8
this.Control[iCurrent+21]=this.gb_2
this.Control[iCurrent+22]=this.gb_3
end on

on w_mat_purchase_order_confirm.destroy
call super::destroy
destroy(this.gb_1)
destroy(this.cb_confirm)
destroy(this.cb_cancel)
destroy(this.rb_wait)
destroy(this.rb_confirmed)
destroy(this.st_4)
destroy(this.ddlb_supplier_code)
destroy(this.ddlb_item_code)
destroy(this.st_1)
destroy(this.uo_dateset)
destroy(this.st_3)
destroy(this.uo_dateend)
destroy(this.sle_order_group_no)
destroy(this.st_7)
destroy(this.sle_item_name)
destroy(this.st_14)
destroy(this.sle_1)
destroy(this.st_5)
destroy(this.ddlb_order_type)
destroy(this.st_8)
destroy(this.gb_2)
destroy(this.gb_3)
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
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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

end event

event ue_data_control;call super::ue_data_control;string lvs_confirm_status
choose case gvs_ue_data_control

	case 'RETRIEVE'
			
			if rb_wait.checked = true then 
				lvs_confirm_status = "W"
			else
				lvs_confirm_status = "Y"
			end if			
			dw_1.retrieve(ddlb_supplier_code.text+'%' , ddlb_item_code.text() + '%',  uo_dateset.text() , uo_dateend.text(),  sle_order_group_no.text+'%' , lvs_confirm_status, gvi_organization_id)

	case 'UPDATE'
		
			IF DW_1.UPDATE() < 0  THEN
			  	 ROLLBACK;
			      RETURN
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
	              F_RETRIEVE()
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_purchase_order_confirm
integer y = 540
end type

type dw_4 from w_main_root`dw_4 within w_mat_purchase_order_confirm
integer y = 540
end type

type dw_3 from w_main_root`dw_3 within w_mat_purchase_order_confirm
integer y = 540
end type

type dw_2 from w_main_root`dw_2 within w_mat_purchase_order_confirm
integer y = 540
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_purchase_order_confirm
integer y = 540
integer width = 4544
integer height = 2192
boolean titlebar = true
string title = "Material Purchase Order List"
string dataobject = "d_mat_forecast_order_4_confirm_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_purchase_order_confirm
end type

type gb_1 from so_groupbox within w_mat_purchase_order_confirm
integer y = 312
integer width = 1253
integer height = 212
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Confirm/Cancel"
end type

type cb_confirm from so_commandbutton within w_mat_purchase_order_confirm
integer x = 1326
integer y = 376
integer width = 411
integer height = 120
integer taborder = 50
boolean bringtotop = true
string text = "All Confirm"
end type

event clicked;call super::clicked;long i
string lvs_rowid

if dw_1.getrow() < 1 then return

do
	i++
	
	if dw_1.object.check_yn[i] = 'Y' then
		
		lvs_rowid = dw_1.object.rowid[i]
	else
		continue
	end if
	
	dw_1.object.confirm_yn[i] = 'Y'
	
	  INSERT INTO "IM_ITEM_PURCHASE_ORDER"  
         ( "ORDER_NO",   
           "ORGANIZATION_ID",   
           "ORDER_GROUP_NO",   
           "SUPPLIER_CODE",   
           "PURCHASE_ORDER_DATE",   
           "DELIVERY_DATE",   
           "DELIVERY",   
           "LINE_TYPE",   
           "INCIDENTAL_EXPENSE_CODE",   
           "ORIGIN_NATION_CODE",   
           "ORDER_TYPE",   
           "DELIVERY_PLACE",   
           "ORDER_QTY",   
           "UNIT_PRICE",   
           "DELIVERY_METHOD",   
           "CURRENCY",   
           "ARRIVAL_QTY",   
           "MFS",   
           "ENTER_DATE",   
           "ENTER_BY",   
           "ITEM_CODE",   
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY",   
           "SHIPMENT_COMMENT",   
           "ATTN_NAME",   
           "CC_NAME",   
           "MATERIAL_MFS",   
           "ORDER_AMT",   
           "ORIGIN_MFS" )  
     SELECT "IM_ITEM_PURCHASE_ORDER_WAIT"."ORDER_NO",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."ORGANIZATION_ID",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."ORDER_GROUP_NO",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."SUPPLIER_CODE",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."PURCHASE_ORDER_DATE",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."DELIVERY_DATE",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."DELIVERY",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."LINE_TYPE",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."INCIDENTAL_EXPENSE_CODE",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."ORIGIN_NATION_CODE",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."ORDER_TYPE",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."DELIVERY_PLACE",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."ORDER_QTY",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."UNIT_PRICE",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."DELIVERY_METHOD",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."CURRENCY",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."ARRIVAL_QTY",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."MFS",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."ENTER_DATE",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."ENTER_BY",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."ITEM_CODE",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."LAST_MODIFY_DATE",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."LAST_MODIFY_BY",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."SHIPMENT_COMMENT",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."ATTN_NAME",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."CC_NAME",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."MATERIAL_MFS",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."ORDER_AMT",   
            "IM_ITEM_PURCHASE_ORDER_WAIT"."ORIGIN_MFS"  
       FROM "IM_ITEM_PURCHASE_ORDER_WAIT" 
	   WHERE ROWID = :lvs_rowid;

	IF F_SQL_CHECK() < 0 THEN 
		RETURN
	END IF 
	
loop until i = dw_1.rowcount( )

msg = f_msgbox(1170)

if msg = 1 then 
	
	if dw_1.update() < 0 then 
		rollback;
	else
		commit ;
		F_RETRIEVE()
	end if 
else
	rollback ;
end if

end event

type cb_cancel from so_commandbutton within w_mat_purchase_order_confirm
integer x = 1742
integer y = 376
integer width = 411
integer height = 120
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string text = "All Cancel"
end type

event clicked;call super::clicked;long i
string lvs_rowid

if dw_1.getrow() < 1 then return

do
	i++
	if dw_1.object.check_yn[i] = 'Y' then
		lvs_rowid = dw_1.object.rowid[i]
		 dw_1.object.confirm_yn[i] = 'W'		
		 
		 DELETE FROM  IM_ITEM_PURCHASE_ORDER  
		 WHERE (ORDER_NO ,ORGANIZATION_ID,ORDER_GROUP_NO,SUPPLIER_CODE)
				IN (SELECT ORDER_NO,  ORGANIZATION_ID, ORDER_GROUP_NO, SUPPLIER_CODE 
						 FROM IM_ITEM_PURCHASE_ORDER_WAIT 
					 WHERE ROWID = :lvs_rowid ) ;

		IF F_SQL_CHECK() < 0 THEN 
			RETURN
		END IF 		 
		
	else
		continue
	end if
	
loop until i = dw_1.rowcount( )

msg = f_msgbox(1170)

if msg = 1 then 
	if dw_1.update() < 0 then 
		rollback;
	else
		commit ;
		F_RETRIEVE()
	end if 
else
	rollback ;
end if

end event

type rb_wait from so_radiobutton within w_mat_purchase_order_confirm
integer x = 82
integer y = 400
boolean bringtotop = true
integer weight = 700
string text = "Wait"
boolean checked = true
end type

event clicked;call super::clicked;cb_confirm.enabled = true
cb_cancel.enabled = false

F_RETRIEVE()
end event

type rb_confirmed from so_radiobutton within w_mat_purchase_order_confirm
integer x = 713
integer y = 396
boolean bringtotop = true
integer weight = 700
string text = "Confirmed"
end type

event clicked;call super::clicked;cb_confirm.enabled = false
cb_cancel.enabled = true

F_RETRIEVE()
end event

type st_4 from so_statictext within w_mat_purchase_order_confirm
integer x = 55
integer y = 92
integer width = 439
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type ddlb_supplier_code from uo_supplier_code within w_mat_purchase_order_confirm
integer x = 55
integer y = 172
integer width = 439
integer taborder = 40
boolean bringtotop = true
end type

type ddlb_item_code from uo_item_code within w_mat_purchase_order_confirm
integer x = 498
integer y = 172
integer width = 631
integer taborder = 50
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mat_purchase_order_confirm
integer x = 498
integer y = 100
integer width = 631
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type uo_dateset from uo_ymd_calendar within w_mat_purchase_order_confirm
event destroy ( )
integer x = 1134
integer y = 172
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_3 from so_statictext within w_mat_purchase_order_confirm
integer x = 1138
integer y = 100
integer width = 805
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Delivery Date"
end type

type uo_dateend from uo_ymdend_calendar within w_mat_purchase_order_confirm
event destroy ( )
integer x = 1545
integer y = 168
integer height = 92
integer taborder = 80
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymdend_calendar::destroy
end on

type sle_order_group_no from so_singlelineedit within w_mat_purchase_order_confirm
integer x = 1957
integer y = 172
integer width = 411
integer height = 84
integer taborder = 70
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

end event

type st_7 from so_statictext within w_mat_purchase_order_confirm
integer x = 1957
integer y = 100
integer width = 411
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Order Group No"
end type

type sle_item_name from so_singlelineedit within w_mat_purchase_order_confirm
integer x = 2368
integer y = 172
integer width = 402
integer height = 84
integer taborder = 80
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

end event

type st_14 from so_statictext within w_mat_purchase_order_confirm
integer x = 2368
integer y = 104
integer width = 402
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Name"
end type

type sle_1 from so_singlelineedit within w_mat_purchase_order_confirm
integer x = 2770
integer y = 172
integer width = 416
integer height = 84
integer taborder = 90
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

end event

type st_5 from so_statictext within w_mat_purchase_order_confirm
integer x = 2770
integer y = 104
integer width = 416
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Item Spec"
end type

type ddlb_order_type from uo_basecode within w_mat_purchase_order_confirm
integer x = 3191
integer y = 172
integer width = 475
integer taborder = 100
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'ORDER TYPE')
end event

type st_8 from so_statictext within w_mat_purchase_order_confirm
integer x = 3191
integer y = 96
integer width = 475
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Order Type"
end type

type gb_2 from so_groupbox within w_mat_purchase_order_confirm
integer y = 4
integer width = 3712
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_purchase_order_confirm
integer x = 1262
integer y = 312
integer width = 951
integer height = 212
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


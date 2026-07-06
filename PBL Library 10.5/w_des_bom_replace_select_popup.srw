HA$PBExportHeader$w_des_bom_replace_select_popup.srw
$PBExportComments$BOM$$HEX4$$70c88cd61dd3c5c5$$ENDHEX$$
forward
global type w_des_bom_replace_select_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_des_bom_replace_select_popup
end type
type st_1 from so_statictext within w_des_bom_replace_select_popup
end type
type uo_start from uo_ymd_calendar within w_des_bom_replace_select_popup
end type
type sle_item_code from so_singlelineedit within w_des_bom_replace_select_popup
end type
type st_2 from so_statictext within w_des_bom_replace_select_popup
end type
type st_3 from so_statictext within w_des_bom_replace_select_popup
end type
type sle_item_name from so_singlelineedit within w_des_bom_replace_select_popup
end type
type cbx_show_mold from so_checkbox within w_des_bom_replace_select_popup
end type
type cbx_show_hide from checkbox within w_des_bom_replace_select_popup
end type
type cbx_show_replace_item from checkbox within w_des_bom_replace_select_popup
end type
type pb_select from so_commandbutton within w_des_bom_replace_select_popup
end type
type gb_where_condition from so_groupbox within w_des_bom_replace_select_popup
end type
type gb_2 from so_groupbox within w_des_bom_replace_select_popup
end type
end forward

global type w_des_bom_replace_select_popup from w_popup_root
integer width = 4155
integer height = 2176
string title = "BOM Replace Select Popup"
cb_retrieve cb_retrieve
st_1 st_1
uo_start uo_start
sle_item_code sle_item_code
st_2 st_2
st_3 st_3
sle_item_name sle_item_name
cbx_show_mold cbx_show_mold
cbx_show_hide cbx_show_hide
cbx_show_replace_item cbx_show_replace_item
pb_select pb_select
gb_where_condition gb_where_condition
gb_2 gb_2
end type
global w_des_bom_replace_select_popup w_des_bom_replace_select_popup

on w_des_bom_replace_select_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.st_1=create st_1
this.uo_start=create uo_start
this.sle_item_code=create sle_item_code
this.st_2=create st_2
this.st_3=create st_3
this.sle_item_name=create sle_item_name
this.cbx_show_mold=create cbx_show_mold
this.cbx_show_hide=create cbx_show_hide
this.cbx_show_replace_item=create cbx_show_replace_item
this.pb_select=create pb_select
this.gb_where_condition=create gb_where_condition
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.uo_start
this.Control[iCurrent+4]=this.sle_item_code
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.sle_item_name
this.Control[iCurrent+8]=this.cbx_show_mold
this.Control[iCurrent+9]=this.cbx_show_hide
this.Control[iCurrent+10]=this.cbx_show_replace_item
this.Control[iCurrent+11]=this.pb_select
this.Control[iCurrent+12]=this.gb_where_condition
this.Control[iCurrent+13]=this.gb_2
end on

on w_des_bom_replace_select_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.st_1)
destroy(this.uo_start)
destroy(this.sle_item_code)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_item_name)
destroy(this.cbx_show_mold)
destroy(this.cbx_show_hide)
destroy(this.cbx_show_replace_item)
destroy(this.pb_select)
destroy(this.gb_where_condition)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)
sle_item_code.TEXT =MESSAGE.STRINGPARM

CB_RETRIEVE.TRIGGEREVENT(CLICKED!)

SLE_ITEM_CODE.SETFOCUS()
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_des_bom_replace_select_popup
integer x = 14
integer width = 4142
end type

type cb_sort from w_popup_root`cb_sort within w_des_bom_replace_select_popup
boolean visible = true
integer x = 2802
integer y = 308
integer width = 288
integer height = 152
end type

type cb_close from w_popup_root`cb_close within w_des_bom_replace_select_popup
boolean visible = true
integer x = 3753
integer y = 308
integer width = 288
integer height = 152
end type

event cb_close::clicked;call super::clicked;Gst_return.Gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_des_bom_replace_select_popup
boolean visible = true
integer y = 516
integer width = 4142
end type

type dw_1 from w_popup_root`dw_1 within w_des_bom_replace_select_popup
boolean visible = true
integer y = 612
integer width = 4142
integer height = 1484
boolean titlebar = true
string title = "BOM List"
string dataobject = "d_des_bom_query"
end type

event dw_1::doubleclicked;call super::doubleclicked;if row < 1 then return 

pb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_des_bom_replace_select_popup
boolean visible = true
integer y = 612
end type

type dw_3 from w_popup_root`dw_3 within w_des_bom_replace_select_popup
integer y = 620
end type

type cb_retrieve from so_commandbutton within w_des_bom_replace_select_popup
integer x = 3099
integer y = 308
integer width = 288
integer height = 152
integer taborder = 60
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DOUBLE LVDB_SESSION_ID

IF  sle_item_code.TEXT = '' OR ISNULL( sle_item_code.TEXT) OR  sle_item_code.TEXT = '%' THEN 
		F_MSGBOX(9050) //SET $$HEX9$$80bd88d444c7200085c725b858d538c194c6$$ENDHEX$$
		RETURN
END IF

LVDB_SESSION_ID = F_BOM_QUERY_PRC(sle_item_code.TEXT , UO_START.TEXT())


if cbx_show_hide.checked = true  then
	
	LVDB_SESSION_ID = F_BOM_QUERY_ALL_PRC( sle_item_code.TEXT , UO_START.TEXT())
	
else
	
	LVDB_SESSION_ID = F_BOM_QUERY_PRC(sle_item_code.TEXT , UO_START.TEXT())

end if 

IF LVDB_SESSION_ID <= 0 THEN 
	ROLLBACK;
     f_msgbox1(9051 , sle_item_code.TEXT )    
	
ELSE
	DW_1.RETRIEVE( LVDB_SESSION_ID , GVI_ORGANIZATION_ID )
	DW_1.SETFOCUS()
	ROLLBACK;
	
	
	
	//$$HEX8$$00b3b4cc80bd88d420005cd4dcc22000$$ENDHEX$$
	IF CBX_SHOW_REPLACE_ITEM.CHECKED = TRUE THEN 
		
		F_SET_REPLACE_ITEM_4_BOM_QUERY( DW_1 )
		DW_1.RESETUPDATE()

	END IF	
	
	//$$HEX5$$08ae15d65cd4dcc22000$$ENDHEX$$
	IF CBX_SHOW_MOLD.CHECKED = TRUE THEN 
		F_SET_MOLD_4_BOM_QUERY( DW_1 )
		DW_1.RESETUPDATE()
	END IF	
	
END IF
end event

type st_1 from so_statictext within w_des_bom_replace_select_popup
integer x = 965
integer y = 288
integer width = 398
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Dateset"
end type

type uo_start from uo_ymd_calendar within w_des_bom_replace_select_popup
event destroy ( )
integer x = 965
integer y = 360
integer width = 402
integer taborder = 100
boolean bringtotop = true
end type

on uo_start.destroy
call uo_ymd_calendar::destroy
end on

type sle_item_code from so_singlelineedit within w_des_bom_replace_select_popup
integer x = 55
integer y = 360
integer width = 494
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer weight = 700
boolean autohscroll = false
end type

type st_2 from so_statictext within w_des_bom_replace_select_popup
integer x = 55
integer y = 288
integer width = 494
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Item Code"
end type

type st_3 from so_statictext within w_des_bom_replace_select_popup
integer x = 553
integer y = 292
integer width = 407
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Item Name"
end type

type sle_item_name from so_singlelineedit within w_des_bom_replace_select_popup
event ue_editchange pbm_enchange
integer x = 553
integer y = 360
integer width = 407
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer weight = 700
boolean autohscroll = false
end type

event ue_editchange;STRING LVS_item_name
DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	LVS_item_name = '%'
ELSE
	LVS_item_name = '%'+this.text+'%'
END IF

DW_1.SETFILTER("item_name LIKE '"+LVS_item_name+"'")
DW_1.FILTER()

end event

type cbx_show_mold from so_checkbox within w_des_bom_replace_select_popup
integer x = 1385
integer y = 276
integer width = 622
boolean bringtotop = true
integer weight = 700
string text = "Show Mold"
end type

type cbx_show_hide from checkbox within w_des_bom_replace_select_popup
integer x = 1385
integer y = 368
integer width = 622
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Show Hide Item"
boolean checked = true
end type

type cbx_show_replace_item from checkbox within w_des_bom_replace_select_popup
integer x = 2048
integer y = 280
integer width = 631
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Show Replace Item"
boolean checked = true
end type

type pb_select from so_commandbutton within w_des_bom_replace_select_popup
integer x = 3392
integer y = 308
integer width = 288
integer height = 152
integer taborder = 70
boolean bringtotop = true
string text = "Select"
end type

event clicked;call super::clicked;IF dw_1.rowcount( ) < 1   THEN 
	gst_return.gvb_return = false
	RETURN -1
END IF

gst_return.gvb_return = true 

MESSAGE.STRINGPARM= DW_1.GETITEMSTRING( DW_1.GETROW() , 'child_item_code')

CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type gb_where_condition from so_groupbox within w_des_bom_replace_select_popup
integer y = 224
integer width = 2720
integer height = 272
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_des_bom_replace_select_popup
integer x = 2752
integer y = 220
integer width = 1371
integer height = 272
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


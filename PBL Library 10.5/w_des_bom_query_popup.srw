HA$PBExportHeader$w_des_bom_query_popup.srw
$PBExportComments$BOM$$HEX4$$70c88cd61dd3c5c5$$ENDHEX$$
forward
global type w_des_bom_query_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_des_bom_query_popup
end type
type st_1 from so_statictext within w_des_bom_query_popup
end type
type uo_start from uo_ymd_calendar within w_des_bom_query_popup
end type
type sle_child_item_code from so_singlelineedit within w_des_bom_query_popup
end type
type st_2 from so_statictext within w_des_bom_query_popup
end type
type st_3 from so_statictext within w_des_bom_query_popup
end type
type sle_item_name from so_singlelineedit within w_des_bom_query_popup
end type
type cbx_show_hide from checkbox within w_des_bom_query_popup
end type
type cbx_show_replace_item from checkbox within w_des_bom_query_popup
end type
type st_6 from so_statictext within w_des_bom_query_popup
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_des_bom_query_popup
end type
type mle_location_infor from so_multilineedit within w_des_bom_query_popup
end type
type gb_where_condition from so_groupbox within w_des_bom_query_popup
end type
type gb_2 from so_groupbox within w_des_bom_query_popup
end type
end forward

global type w_des_bom_query_popup from w_popup_root
integer width = 4530
integer height = 2824
string title = "BOM Query Popup"
boolean minbox = true
windowtype windowtype = popup!
cb_retrieve cb_retrieve
st_1 st_1
uo_start uo_start
sle_child_item_code sle_child_item_code
st_2 st_2
st_3 st_3
sle_item_name sle_item_name
cbx_show_hide cbx_show_hide
cbx_show_replace_item cbx_show_replace_item
st_6 st_6
ddlb_model_name ddlb_model_name
mle_location_infor mle_location_infor
gb_where_condition gb_where_condition
gb_2 gb_2
end type
global w_des_bom_query_popup w_des_bom_query_popup

on w_des_bom_query_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.st_1=create st_1
this.uo_start=create uo_start
this.sle_child_item_code=create sle_child_item_code
this.st_2=create st_2
this.st_3=create st_3
this.sle_item_name=create sle_item_name
this.cbx_show_hide=create cbx_show_hide
this.cbx_show_replace_item=create cbx_show_replace_item
this.st_6=create st_6
this.ddlb_model_name=create ddlb_model_name
this.mle_location_infor=create mle_location_infor
this.gb_where_condition=create gb_where_condition
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.uo_start
this.Control[iCurrent+4]=this.sle_child_item_code
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.sle_item_name
this.Control[iCurrent+8]=this.cbx_show_hide
this.Control[iCurrent+9]=this.cbx_show_replace_item
this.Control[iCurrent+10]=this.st_6
this.Control[iCurrent+11]=this.ddlb_model_name
this.Control[iCurrent+12]=this.mle_location_infor
this.Control[iCurrent+13]=this.gb_where_condition
this.Control[iCurrent+14]=this.gb_2
end on

on w_des_bom_query_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.st_1)
destroy(this.uo_start)
destroy(this.sle_child_item_code)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_item_name)
destroy(this.cbx_show_hide)
destroy(this.cbx_show_replace_item)
destroy(this.st_6)
destroy(this.ddlb_model_name)
destroy(this.mle_location_infor)
destroy(this.gb_where_condition)
destroy(this.gb_2)
end on

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

event ue_post_open;call super::ue_post_open;dw_1.settransobject(sqlca)
ddlb_model_name.TEXT =MESSAGE.STRINGPARM
ddlb_model_name.SETFOCUS()
end event

type p_title from w_popup_root`p_title within w_des_bom_query_popup
integer x = 14
integer width = 4512
end type

type cb_sort from w_popup_root`cb_sort within w_des_bom_query_popup
boolean visible = true
integer x = 3470
integer y = 276
integer width = 288
integer height = 156
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_des_bom_query_popup
boolean visible = true
integer x = 4137
integer y = 276
integer width = 288
integer height = 156
integer weight = 400
end type

type st_msg from w_popup_root`st_msg within w_des_bom_query_popup
boolean visible = true
integer y = 516
integer width = 4512
end type

type dw_1 from w_popup_root`dw_1 within w_des_bom_query_popup
boolean visible = true
integer y = 848
integer width = 4512
integer height = 1244
boolean titlebar = true
string title = "BOM List"
string dataobject = "d_des_bom_query_popup"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
mle_location_infor.text = this.object.location_info[currentrow]
end event

type dw_2 from w_popup_root`dw_2 within w_des_bom_query_popup
boolean visible = true
integer y = 852
integer width = 4512
integer height = 640
end type

type dw_3 from w_popup_root`dw_3 within w_des_bom_query_popup
integer y = 620
end type

type cb_retrieve from so_commandbutton within w_des_bom_query_popup
integer x = 3762
integer y = 276
integer width = 366
integer height = 156
integer taborder = 60
boolean bringtotop = true
integer weight = 400
string text = "Retrieve"
end type

event clicked;DOUBLE LVDB_SESSION_ID

IF  ddlb_model_name.getitem() = '' OR ISNULL(ddlb_model_name.getitem()) OR ddlb_model_name.getitem() = '%' THEN 
		F_MSGBOX(9050) //SET $$HEX9$$80bd88d444c7200085c725b858d538c194c6$$ENDHEX$$
		RETURN
END IF

LVDB_SESSION_ID = F_BOM_QUERY_PRC(ddlb_model_name.getitem() , UO_START.TEXT())

if cbx_show_hide.checked = true  then
	
	LVDB_SESSION_ID = F_BOM_QUERY_ALL_PRC( ddlb_model_name.getitem() , UO_START.TEXT())
	
else
	
	LVDB_SESSION_ID = F_BOM_QUERY_PRC(ddlb_model_name.getitem() , UO_START.TEXT())

end if 

IF LVDB_SESSION_ID <= 0 THEN 
	ROLLBACK;
     f_msgbox1(9051 , ddlb_model_name.getitem() )    
	
ELSE
	DW_1.RETRIEVE( LVDB_SESSION_ID , sle_child_item_code.text +'%' ,  GVI_ORGANIZATION_ID )
	DW_1.SETFOCUS()
	ROLLBACK;

//	//$$HEX8$$00b3b4cc80bd88d420005cd4dcc22000$$ENDHEX$$
//	IF CBX_SHOW_REPLACE_ITEM.CHECKED = TRUE THEN 
//		
//		F_SET_REPLACE_ITEM_4_BOM_QUERY( DW_1 )
//		DW_1.RESETUPDATE()
//
//	END IF	
	

	
END IF
end event

type st_1 from so_statictext within w_des_bom_query_popup
integer x = 2299
integer y = 296
integer width = 398
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Dateset"
end type

type uo_start from uo_ymd_calendar within w_des_bom_query_popup
event destroy ( )
integer x = 2299
integer y = 368
integer width = 402
integer taborder = 100
boolean bringtotop = true
end type

on uo_start.destroy
call uo_ymd_calendar::destroy
end on

type sle_child_item_code from so_singlelineedit within w_des_bom_query_popup
integer x = 823
integer y = 364
integer width = 581
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer weight = 700
boolean autohscroll = false
end type

type st_2 from so_statictext within w_des_bom_query_popup
integer x = 823
integer y = 292
integer width = 581
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Child Item Code"
end type

type st_3 from so_statictext within w_des_bom_query_popup
integer x = 1413
integer y = 296
integer width = 873
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Item Name"
end type

type sle_item_name from so_singlelineedit within w_des_bom_query_popup
event ue_editchange pbm_enchange
integer x = 1413
integer y = 364
integer width = 873
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

type cbx_show_hide from checkbox within w_des_bom_query_popup
integer x = 2720
integer y = 376
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

type cbx_show_replace_item from checkbox within w_des_bom_query_popup
integer x = 2715
integer y = 288
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

type st_6 from so_statictext within w_des_bom_query_popup
integer x = 18
integer y = 296
integer width = 791
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Model Name"
end type

type ddlb_model_name from uo_set_model_name_ddlb within w_des_bom_query_popup
integer x = 18
integer y = 364
integer width = 791
integer taborder = 110
boolean bringtotop = true
end type

type mle_location_infor from so_multilineedit within w_des_bom_query_popup
integer x = 5
integer y = 608
integer width = 4494
integer height = 228
integer taborder = 120
boolean bringtotop = true
string text = ""
end type

type gb_where_condition from so_groupbox within w_des_bom_query_popup
integer y = 200
integer width = 3378
integer height = 296
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_des_bom_query_popup
integer x = 3424
integer y = 204
integer width = 1083
integer height = 272
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


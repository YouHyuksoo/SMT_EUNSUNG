HA$PBExportHeader$w_mat_inventory_4_lv_analysis_popup.srw
$PBExportComments$(Item Query)-$$HEX6$$80bd88d470c88cd60d000a00$$ENDHEX$$forward
global type w_mat_inventory_4_lv_analysis_popup from w_popup_root
end type
type cb_select from commandbutton within w_mat_inventory_4_lv_analysis_popup
end type
type cb_retrieve from commandbutton within w_mat_inventory_4_lv_analysis_popup
end type
type sle_rank_no from singlelineedit within w_mat_inventory_4_lv_analysis_popup
end type
type st_1 from statictext within w_mat_inventory_4_lv_analysis_popup
end type
type st_2 from statictext within w_mat_inventory_4_lv_analysis_popup
end type
type sle_group_id from singlelineedit within w_mat_inventory_4_lv_analysis_popup
end type
type gb_1 from so_groupbox within w_mat_inventory_4_lv_analysis_popup
end type
type gb_2 from so_groupbox within w_mat_inventory_4_lv_analysis_popup
end type
end forward

global type w_mat_inventory_4_lv_analysis_popup from w_popup_root
integer width = 3785
integer height = 2156
string title = "Item Master Popup"
cb_select cb_select
cb_retrieve cb_retrieve
sle_rank_no sle_rank_no
st_1 st_1
st_2 st_2
sle_group_id sle_group_id
gb_1 gb_1
gb_2 gb_2
end type
global w_mat_inventory_4_lv_analysis_popup w_mat_inventory_4_lv_analysis_popup

on w_mat_inventory_4_lv_analysis_popup.create
int iCurrent
call super::create
this.cb_select=create cb_select
this.cb_retrieve=create cb_retrieve
this.sle_rank_no=create sle_rank_no
this.st_1=create st_1
this.st_2=create st_2
this.sle_group_id=create sle_group_id
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.sle_rank_no
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_group_id
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_mat_inventory_4_lv_analysis_popup.destroy
call super::destroy
destroy(this.cb_select)
destroy(this.cb_retrieve)
destroy(this.sle_rank_no)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_group_id)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)

sle_rank_no.text = message.stringparm

CB_RETRIEVE.TRIGGEREVENT(CLICKED!)

end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_mat_inventory_4_lv_analysis_popup
integer width = 3771
integer height = 188
long backcolor = 16777215
end type

type cb_sort from w_popup_root`cb_sort within w_mat_inventory_4_lv_analysis_popup
integer x = 2615
integer y = 260
integer height = 164
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_mat_inventory_4_lv_analysis_popup
boolean visible = true
integer x = 3333
integer y = 268
integer width = 370
integer height = 164
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_mat_inventory_4_lv_analysis_popup
boolean visible = true
integer y = 484
integer width = 3771
end type

type dw_1 from w_popup_root`dw_1 within w_mat_inventory_4_lv_analysis_popup
boolean visible = true
integer y = 576
integer width = 3771
integer height = 1304
integer taborder = 70
boolean titlebar = true
string title = "Item List"
string dataobject = "d_mat_item_inventory_4_lv_analysis_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

event dw_1::clicked;//OVERDIRDE
end event

type dw_2 from w_popup_root`dw_2 within w_mat_inventory_4_lv_analysis_popup
boolean visible = true
integer y = 584
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_mat_inventory_4_lv_analysis_popup
integer y = 676
end type

type cb_select from commandbutton within w_mat_inventory_4_lv_analysis_popup
boolean visible = false
integer x = 2967
integer y = 268
integer width = 370
integer height = 164
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select"
boolean default = true
end type

type cb_retrieve from commandbutton within w_mat_inventory_4_lv_analysis_popup
integer x = 2962
integer y = 268
integer width = 370
integer height = 164
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE( SLE_RANK_NO.TEXT+'%' , SLE_GROUP_ID.TEXT+'%', GVI_ORGANIZATION_ID )
end event

type sle_rank_no from singlelineedit within w_mat_inventory_4_lv_analysis_popup
event ue_editchange pbm_enchange
integer x = 64
integer y = 344
integer width = 576
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;STRING LVS_item_name
DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	
	SELECTED_DATA_WINDOW.SETFILTER('')
	SELECTED_DATA_WINDOW.FILTER()	
	RETURN 
ELSE
	LVS_item_name = '%'+this.text+'%'
END IF

DW_1.SETFILTER("RANK_NO LIKE '"+LVS_item_name+"'")
DW_1.FILTER()

end event

type st_1 from statictext within w_mat_inventory_4_lv_analysis_popup
integer x = 64
integer y = 276
integer width = 576
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Rank No"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_mat_inventory_4_lv_analysis_popup
integer x = 649
integer y = 272
integer width = 576
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Group ID"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_group_id from singlelineedit within w_mat_inventory_4_lv_analysis_popup
event ue_editchange pbm_enchange
integer x = 649
integer y = 344
integer width = 576
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;STRING LVS_item_name
DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	
	SELECTED_DATA_WINDOW.SETFILTER('')
	SELECTED_DATA_WINDOW.FILTER()	
	RETURN 
ELSE
	LVS_item_name = '%'+this.text+'%'
END IF

DW_1.SETFILTER("GROUP_ID LIKE '"+LVS_item_name+"'")
DW_1.FILTER()

end event

type gb_1 from so_groupbox within w_mat_inventory_4_lv_analysis_popup
integer x = 14
integer y = 196
integer width = 1253
integer height = 268
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_mat_inventory_4_lv_analysis_popup
integer x = 2930
integer y = 196
integer width = 841
integer height = 264
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


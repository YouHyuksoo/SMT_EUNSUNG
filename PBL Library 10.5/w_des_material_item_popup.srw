HA$PBExportHeader$w_des_material_item_popup.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_des_material_item_popup from w_popup_root
end type
type st_1 from statictext within w_des_material_item_popup
end type
type sle_item_name from singlelineedit within w_des_material_item_popup
end type
type cb_select from commandbutton within w_des_material_item_popup
end type
type cb_retrieve from commandbutton within w_des_material_item_popup
end type
type st_2 from statictext within w_des_material_item_popup
end type
type sle_item_code from singlelineedit within w_des_material_item_popup
end type
type gb_1 from so_groupbox within w_des_material_item_popup
end type
type gb_2 from so_groupbox within w_des_material_item_popup
end type
end forward

global type w_des_material_item_popup from w_popup_root
integer width = 3785
integer height = 2156
string title = "Item Master Popup"
boolean controlmenu = false
st_1 st_1
sle_item_name sle_item_name
cb_select cb_select
cb_retrieve cb_retrieve
st_2 st_2
sle_item_code sle_item_code
gb_1 gb_1
gb_2 gb_2
end type
global w_des_material_item_popup w_des_material_item_popup

on w_des_material_item_popup.create
int iCurrent
call super::create
this.st_1=create st_1
this.sle_item_name=create sle_item_name
this.cb_select=create cb_select
this.cb_retrieve=create cb_retrieve
this.st_2=create st_2
this.sle_item_code=create sle_item_code
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_item_name
this.Control[iCurrent+3]=this.cb_select
this.Control[iCurrent+4]=this.cb_retrieve
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_item_code
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_des_material_item_popup.destroy
call super::destroy
destroy(this.st_1)
destroy(this.sle_item_name)
destroy(this.cb_select)
destroy(this.cb_retrieve)
destroy(this.st_2)
destroy(this.sle_item_code)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)

SLE_ITEM_CODE.TEXT = message.stringparm
cb_retrieve.triggerevent( clicked!)
sle_item_code.setfocus( )
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

event ue_post_open;call super::ue_post_open;//CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
//SLE_ITEM_CODE.SETFOCUS()
end event

type p_title from w_popup_root`p_title within w_des_material_item_popup
integer width = 3771
integer height = 188
long backcolor = 16777215
end type

type cb_sort from w_popup_root`cb_sort within w_des_material_item_popup
boolean visible = true
integer x = 2578
integer y = 288
integer height = 112
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_des_material_item_popup
boolean visible = true
integer x = 3415
integer y = 288
integer height = 112
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_des_material_item_popup
boolean visible = true
integer y = 484
integer width = 3771
end type

type dw_1 from w_popup_root`dw_1 within w_des_material_item_popup
boolean visible = true
integer y = 576
integer width = 3771
integer height = 1484
integer taborder = 70
boolean titlebar = true
string title = "Item List"
string dataobject = "d_des_material_item_popup_tree"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

event dw_1::retrieveend;call super::retrieveend;CB_CLOSE.ENabled = TRUE
end event

type dw_2 from w_popup_root`dw_2 within w_des_material_item_popup
boolean visible = true
integer y = 584
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_des_material_item_popup
integer y = 676
end type

type st_1 from statictext within w_des_material_item_popup
integer x = 608
integer y = 264
integer width = 974
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
string text = "Item Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_item_name from singlelineedit within w_des_material_item_popup
event ue_editchange pbm_enchange
integer x = 608
integer y = 332
integer width = 974
integer height = 84
integer taborder = 20
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
	
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()	
	RETURN 
ELSE
	LVS_item_name = '%'+this.text+'%'
END IF

DW_1.SETFILTER("item_name LIKE '"+LVS_item_name+"'")
DW_1.FILTER()

end event

type cb_select from commandbutton within w_des_material_item_popup
integer x = 3136
integer y = 288
integer width = 274
integer height = 112
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

event clicked;IF DW_1.GETROW() = 0  THEN 
	gst_return.gvb_return = false
	RETURN -1
END IF
gst_return.gvb_return = true 

MESSAGE.STRINGPARM= DW_1.GETITEMSTRING( DW_1.GETROW() , 'item_code')
Gst_return.Gvs_return[1] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'item_type')
Gst_return.Gvs_return[2] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'line_type')
Gst_return.Gvs_return[3] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'item_name')
Gst_return.Gvs_return[4] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'item_spec')
Gst_return.Gvs_return[5] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'item_uom')
Gst_return.Gvs_return[6] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'item_class')
Gst_return.Gvs_return[7] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'drawing_no')
CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type cb_retrieve from commandbutton within w_des_material_item_popup
integer x = 2857
integer y = 288
integer width = 274
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;CB_CLOSE.ENabled = FALSE
DW_1.RESET()
DW_1.RETRIEVE(SLE_ITEM_CODE.TEXT+'%' , '%'+SLE_ITEM_NAME.TEXT+'%', GVI_ORGANIZATION_ID )

end event

type st_2 from statictext within w_des_material_item_popup
integer x = 27
integer y = 268
integer width = 576
integer height = 52
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
string text = "Item Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_item_code from singlelineedit within w_des_material_item_popup
event ue_editchange pbm_enchange
integer x = 27
integer y = 332
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
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;STRING LVS_item_name
DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()	
	RETURN 
ELSE
	LVS_item_name = '%'+this.text+'%'
END IF

DW_1.SETFILTER("item_code LIKE '"+LVS_item_name+"'")
DW_1.FILTER()

end event

type gb_1 from so_groupbox within w_des_material_item_popup
integer y = 196
integer width = 1600
integer height = 284
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_des_material_item_popup
integer x = 2533
integer y = 196
integer width = 1202
integer height = 284
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


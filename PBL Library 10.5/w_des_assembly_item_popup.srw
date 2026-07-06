HA$PBExportHeader$w_des_assembly_item_popup.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_des_assembly_item_popup from w_popup_root
end type
type st_1 from statictext within w_des_assembly_item_popup
end type
type sle_item_name from singlelineedit within w_des_assembly_item_popup
end type
type cb_select from commandbutton within w_des_assembly_item_popup
end type
type cb_retrieve from commandbutton within w_des_assembly_item_popup
end type
type st_2 from statictext within w_des_assembly_item_popup
end type
type ddlb_line_type from uo_line_type within w_des_assembly_item_popup
end type
type st_3 from statictext within w_des_assembly_item_popup
end type
type ddlb_item_type from uo_item_type within w_des_assembly_item_popup
end type
type st_4 from statictext within w_des_assembly_item_popup
end type
type uo_dateset from uo_ymd_calendar within w_des_assembly_item_popup
end type
type st_5 from statictext within w_des_assembly_item_popup
end type
type sle_drawing_no from singlelineedit within w_des_assembly_item_popup
end type
type st_6 from statictext within w_des_assembly_item_popup
end type
type sle_item_code from singlelineedit within w_des_assembly_item_popup
end type
type st_7 from statictext within w_des_assembly_item_popup
end type
type sle_1 from singlelineedit within w_des_assembly_item_popup
end type
type gb_1 from so_groupbox within w_des_assembly_item_popup
end type
type gb_2 from so_groupbox within w_des_assembly_item_popup
end type
end forward

global type w_des_assembly_item_popup from w_popup_root
integer width = 3918
integer height = 2156
string title = "Assembly Item Master Popup"
st_1 st_1
sle_item_name sle_item_name
cb_select cb_select
cb_retrieve cb_retrieve
st_2 st_2
ddlb_line_type ddlb_line_type
st_3 st_3
ddlb_item_type ddlb_item_type
st_4 st_4
uo_dateset uo_dateset
st_5 st_5
sle_drawing_no sle_drawing_no
st_6 st_6
sle_item_code sle_item_code
st_7 st_7
sle_1 sle_1
gb_1 gb_1
gb_2 gb_2
end type
global w_des_assembly_item_popup w_des_assembly_item_popup

on w_des_assembly_item_popup.create
int iCurrent
call super::create
this.st_1=create st_1
this.sle_item_name=create sle_item_name
this.cb_select=create cb_select
this.cb_retrieve=create cb_retrieve
this.st_2=create st_2
this.ddlb_line_type=create ddlb_line_type
this.st_3=create st_3
this.ddlb_item_type=create ddlb_item_type
this.st_4=create st_4
this.uo_dateset=create uo_dateset
this.st_5=create st_5
this.sle_drawing_no=create sle_drawing_no
this.st_6=create st_6
this.sle_item_code=create sle_item_code
this.st_7=create st_7
this.sle_1=create sle_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_item_name
this.Control[iCurrent+3]=this.cb_select
this.Control[iCurrent+4]=this.cb_retrieve
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.ddlb_line_type
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.ddlb_item_type
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.uo_dateset
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.sle_drawing_no
this.Control[iCurrent+13]=this.st_6
this.Control[iCurrent+14]=this.sle_item_code
this.Control[iCurrent+15]=this.st_7
this.Control[iCurrent+16]=this.sle_1
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.gb_2
end on

on w_des_assembly_item_popup.destroy
call super::destroy
destroy(this.st_1)
destroy(this.sle_item_name)
destroy(this.cb_select)
destroy(this.cb_retrieve)
destroy(this.st_2)
destroy(this.ddlb_line_type)
destroy(this.st_3)
destroy(this.ddlb_item_type)
destroy(this.st_4)
destroy(this.uo_dateset)
destroy(this.st_5)
destroy(this.sle_drawing_no)
destroy(this.st_6)
destroy(this.sle_item_code)
destroy(this.st_7)
destroy(this.sle_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
SLE_ITEM_CODE.SETFOCUS()
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_des_assembly_item_popup
integer width = 3922
end type

type cb_sort from w_popup_root`cb_sort within w_des_assembly_item_popup
boolean visible = true
integer x = 50
integer y = 676
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_des_assembly_item_popup
boolean visible = true
integer x = 887
integer y = 676
integer taborder = 0
end type

type st_msg from w_popup_root`st_msg within w_des_assembly_item_popup
boolean visible = true
integer y = 504
integer width = 3922
end type

type dw_1 from w_popup_root`dw_1 within w_des_assembly_item_popup
boolean visible = true
integer y = 832
integer width = 3922
integer height = 1244
integer taborder = 70
boolean titlebar = true
string title = "Assembly Item List"
string dataobject = "d_des_assembly_item_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

type dw_2 from w_popup_root`dw_2 within w_des_assembly_item_popup
boolean visible = true
integer y = 832
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_des_assembly_item_popup
integer y = 860
end type

type st_1 from statictext within w_des_assembly_item_popup
integer x = 590
integer y = 272
integer width = 494
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

type sle_item_name from singlelineedit within w_des_assembly_item_popup
event ue_editchange pbm_enchange
integer x = 590
integer y = 340
integer width = 494
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

type cb_select from commandbutton within w_des_assembly_item_popup
integer x = 608
integer y = 676
integer width = 274
integer height = 100
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

MESSAGE.STRINGPARM = DW_1.GETITEMSTRING( DW_1.GETROW() , 'item_code')
Gst_return.Gvs_return[1] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'item_type')
Gst_return.Gvs_return[2] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'line_type')
Gst_return.Gvs_return[3] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'item_name')
Gst_return.Gvs_return[4] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'item_spec')
Gst_return.Gvs_return[5] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'item_uom')
CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type cb_retrieve from commandbutton within w_des_assembly_item_popup
integer x = 329
integer y = 676
integer width = 274
integer height = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(SLE_ITEM_CODE.TEXT+'%' , '%'+SLE_ITEM_NAME.TEXT+'%' , DDLB_ITEM_TYPE.GETCODE()+'%' ,  DDLB_LINE_TYPE.GETCODE()+'%' , UO_DATESET.TEXT() , GVI_ORGANIZATION_ID )
end event

type st_2 from statictext within w_des_assembly_item_popup
integer x = 50
integer y = 276
integer width = 539
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

type ddlb_line_type from uo_line_type within w_des_assembly_item_popup
integer x = 2469
integer y = 340
integer width = 457
integer taborder = 50
boolean bringtotop = true
boolean autohscroll = true
end type

type st_3 from statictext within w_des_assembly_item_popup
integer x = 2469
integer y = 272
integer width = 457
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
string text = "Line Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_item_type from uo_item_type within w_des_assembly_item_popup
integer x = 2011
integer y = 340
integer width = 453
integer taborder = 40
boolean bringtotop = true
boolean autohscroll = true
end type

type st_4 from statictext within w_des_assembly_item_popup
integer x = 2025
integer y = 272
integer width = 453
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
string text = "Item Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_dateset from uo_ymd_calendar within w_des_assembly_item_popup
integer x = 2926
integer y = 340
integer width = 402
integer height = 84
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_5 from statictext within w_des_assembly_item_popup
integer x = 2930
integer y = 272
integer width = 398
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
string text = "Dateset"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_drawing_no from singlelineedit within w_des_assembly_item_popup
event ue_editchange pbm_enchange
integer x = 1577
integer y = 340
integer width = 434
integer height = 84
integer taborder = 30
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

DW_1.SETFILTER("drawing_no LIKE '"+LVS_item_name+"'")
DW_1.FILTER()

end event

type st_6 from statictext within w_des_assembly_item_popup
integer x = 1577
integer y = 272
integer width = 434
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
string text = "Drawing No"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_item_code from singlelineedit within w_des_assembly_item_popup
event ue_editchange pbm_enchange
integer x = 50
integer y = 340
integer width = 539
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

type st_7 from statictext within w_des_assembly_item_popup
integer x = 1079
integer y = 272
integer width = 494
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
string text = "Item Spec"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_des_assembly_item_popup
event ue_editchange pbm_enchange
integer x = 1083
integer y = 340
integer width = 494
integer height = 84
integer taborder = 70
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

DW_1.SETFILTER("item_spec LIKE '"+LVS_item_name+"'")
DW_1.FILTER()

end event

type gb_1 from so_groupbox within w_des_assembly_item_popup
integer y = 604
integer width = 1207
integer height = 212
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_des_assembly_item_popup
integer y = 204
integer width = 3351
integer height = 284
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


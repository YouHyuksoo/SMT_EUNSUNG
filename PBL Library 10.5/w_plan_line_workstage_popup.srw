HA$PBExportHeader$w_plan_line_workstage_popup.srw
$PBExportComments$(Sal Customerr Query)-$$HEX5$$70ac98b798cc70c88cd6$$ENDHEX$$
forward
global type w_plan_line_workstage_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_plan_line_workstage_popup
end type
type cb_select from so_commandbutton within w_plan_line_workstage_popup
end type
type st_workstage_code from statictext within w_plan_line_workstage_popup
end type
type ddlb_line_code from uo_line_code within w_plan_line_workstage_popup
end type
type gb_1 from so_groupbox within w_plan_line_workstage_popup
end type
type gb_2 from so_groupbox within w_plan_line_workstage_popup
end type
end forward

global type w_plan_line_workstage_popup from w_popup_root
integer width = 3730
integer height = 2128
string title = "Workstage Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_workstage_code st_workstage_code
ddlb_line_code ddlb_line_code
gb_1 gb_1
gb_2 gb_2
end type
global w_plan_line_workstage_popup w_plan_line_workstage_popup

on w_plan_line_workstage_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_workstage_code=create st_workstage_code
this.ddlb_line_code=create ddlb_line_code
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_workstage_code
this.Control[iCurrent+4]=this.ddlb_line_code
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.gb_2
end on

on w_plan_line_workstage_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_workstage_code)
destroy(this.ddlb_line_code)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)
IVD_SELECTED_DATA_WINDOW = DW_1
ddlb_line_code.text = message.stringparm
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_plan_line_workstage_popup
integer width = 3707
end type

type cb_sort from w_popup_root`cb_sort within w_plan_line_workstage_popup
boolean visible = true
integer x = 2519
integer y = 296
integer height = 168
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_plan_line_workstage_popup
boolean visible = true
integer x = 3355
integer y = 296
integer height = 168
integer taborder = 0
end type

type st_msg from w_popup_root`st_msg within w_plan_line_workstage_popup
boolean visible = true
integer y = 520
integer width = 3707
end type

type dw_1 from w_popup_root`dw_1 within w_plan_line_workstage_popup
boolean visible = true
integer y = 612
integer width = 3707
integer height = 1428
integer taborder = 30
boolean titlebar = true
string title = "Workstage List"
string dataobject = "d_pln_line_workstage_popup_lst"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_plan_line_workstage_popup
boolean visible = true
integer y = 792
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_plan_line_workstage_popup
integer y = 612
end type

type cb_retrieve from so_commandbutton within w_plan_line_workstage_popup
integer x = 2798
integer y = 296
integer width = 274
integer height = 168
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(  ddlb_line_code.getcode()+'%' ,  GVI_ORGANIZATION_ID )
end event

type cb_select from so_commandbutton within w_plan_line_workstage_popup
integer x = 3077
integer y = 296
integer width = 274
integer height = 168
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;IF DW_1.GETROW() = 0  THEN 
	RETURN -1
END IF
gst_return.gvb_return = true
MESSAGE.STRINGPARM = DW_1.GETITEMSTRING( DW_1.GETROW() , 'line_code')
gst_return.gvs_return[1] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'workstage_code')

CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type st_workstage_code from statictext within w_plan_line_workstage_popup
integer x = 41
integer y = 304
integer width = 631
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_line_code from uo_line_code within w_plan_line_workstage_popup
integer x = 41
integer y = 388
integer taborder = 30
boolean bringtotop = true
boolean allowedit = true
end type

event selectionchanged;call super::selectionchanged;cb_retrieve.triggerevent( clicked!)
end event

type gb_1 from so_groupbox within w_plan_line_workstage_popup
integer x = 2450
integer y = 212
integer width = 1248
integer height = 304
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_plan_line_workstage_popup
integer y = 212
integer width = 718
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


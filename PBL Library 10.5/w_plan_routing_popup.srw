HA$PBExportHeader$w_plan_routing_popup.srw
$PBExportComments$(Sal Customerr Query)-$$HEX5$$70ac98b798cc70c88cd6$$ENDHEX$$
forward
global type w_plan_routing_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_plan_routing_popup
end type
type cb_select from so_commandbutton within w_plan_routing_popup
end type
type ddlb_route_code from uo_route_code within w_plan_routing_popup
end type
type st_line_code from statictext within w_plan_routing_popup
end type
type cb_1 from so_commandbutton within w_plan_routing_popup
end type
type gb_1 from so_groupbox within w_plan_routing_popup
end type
type gb_2 from so_groupbox within w_plan_routing_popup
end type
end forward

global type w_plan_routing_popup from w_popup_root
integer width = 3730
integer height = 2128
string title = "Routing Operation Popup"
cb_retrieve cb_retrieve
cb_select cb_select
ddlb_route_code ddlb_route_code
st_line_code st_line_code
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
end type
global w_plan_routing_popup w_plan_routing_popup

on w_plan_routing_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.ddlb_route_code=create ddlb_route_code
this.st_line_code=create st_line_code
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.ddlb_route_code
this.Control[iCurrent+4]=this.st_line_code
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.gb_2
end on

on w_plan_routing_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.ddlb_route_code)
destroy(this.st_line_code)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)
IVD_SELECTED_DATA_WINDOW = DW_1
ddlb_route_code.text = message.stringparm
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_plan_routing_popup
integer width = 3707
end type

type cb_sort from w_popup_root`cb_sort within w_plan_routing_popup
boolean visible = true
integer x = 2181
integer y = 332
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_plan_routing_popup
boolean visible = true
integer x = 3355
integer y = 336
integer taborder = 0
end type

type st_msg from w_popup_root`st_msg within w_plan_routing_popup
boolean visible = true
integer y = 512
integer width = 3707
end type

type dw_1 from w_popup_root`dw_1 within w_plan_routing_popup
boolean visible = true
integer y = 612
integer width = 3707
integer height = 1428
integer taborder = 30
boolean titlebar = true
string title = "Operation List"
string dataobject = "d_pln_product_routing_query_lst_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_plan_routing_popup
boolean visible = true
integer y = 792
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_plan_routing_popup
integer y = 612
end type

type cb_retrieve from so_commandbutton within w_plan_routing_popup
integer x = 2459
integer y = 332
integer width = 274
integer height = 100
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(  ddlb_route_code.getcode()+'%' ,  GVI_ORGANIZATION_ID )
end event

type cb_select from so_commandbutton within w_plan_routing_popup
integer x = 2738
integer y = 332
integer width = 274
integer height = 100
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;IF DW_1.GETROW() = 0  THEN 
	RETURN -1
END IF
gst_return.gvb_return = true
MESSAGE.STRINGPARM = DW_1.GETITEMSTRING( DW_1.GETROW() , 'route_no')

CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type ddlb_route_code from uo_route_code within w_plan_routing_popup
integer x = 55
integer y = 384
integer taborder = 30
boolean bringtotop = true
end type

type st_line_code from statictext within w_plan_routing_popup
integer x = 55
integer y = 300
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
string text = "Route No"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from so_commandbutton within w_plan_routing_popup
integer x = 3022
integer y = 332
integer width = 274
integer height = 100
integer taborder = 40
boolean bringtotop = true
string text = "Update"
boolean default = true
end type

event clicked;call super::clicked;if dw_1.update( ) < 0 then 
	rollback;
else
	commit;
	f_msgbox(1170) 
end if
end event

type gb_1 from so_groupbox within w_plan_routing_popup
integer x = 2117
integer y = 212
integer width = 1582
integer height = 304
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_plan_routing_popup
integer y = 212
integer width = 727
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


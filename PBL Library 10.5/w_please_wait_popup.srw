HA$PBExportHeader$w_please_wait_popup.srw
$PBExportComments$$$HEX8$$91c7c5c598ccacb911c954ba38c1c0c9$$ENDHEX$$
forward
global type w_please_wait_popup from w_none_dw_popup_root
end type
type pb_info_msg from so_picturebutton within w_please_wait_popup
end type
type p_1 from picture within w_please_wait_popup
end type
end forward

global type w_please_wait_popup from w_none_dw_popup_root
integer x = 1074
integer y = 840
integer width = 2318
integer height = 628
boolean titlebar = false
boolean controlmenu = false
boolean resizable = true
windowtype windowtype = popup!
long backcolor = 16777215
boolean contexthelp = false
pb_info_msg pb_info_msg
p_1 p_1
end type
global w_please_wait_popup w_please_wait_popup

on w_please_wait_popup.create
int iCurrent
call super::create
this.pb_info_msg=create pb_info_msg
this.p_1=create p_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_info_msg
this.Control[iCurrent+2]=this.p_1
end on

on w_please_wait_popup.destroy
call super::destroy
destroy(this.pb_info_msg)
destroy(this.p_1)
end on

type p_title from w_none_dw_popup_root`p_title within w_please_wait_popup
boolean visible = false
integer width = 1998
end type

type cb_close from w_none_dw_popup_root`cb_close within w_please_wait_popup
integer x = 46
integer y = 908
end type

type st_msg from w_none_dw_popup_root`st_msg within w_please_wait_popup
integer x = 14
integer y = 1028
end type

type pb_info_msg from so_picturebutton within w_please_wait_popup
integer x = 91
integer y = 60
integer width = 1563
integer height = 468
integer textsize = -18
integer weight = 700
string text = "$$HEX16$$98ccacb9200011c9200085c7c8b2e4b2200030aee4b224b82000fcc838c194c6$$ENDHEX$$"
boolean flatstyle = true
boolean originalsize = false
alignment htextalign = center!
vtextalign vtextalign = vcenter!
end type

event clicked;call super::clicked;Close(Parent)
end event

type p_1 from picture within w_please_wait_popup
integer x = 1801
integer y = 144
integer width = 343
integer height = 300
boolean bringtotop = true
boolean originalsize = true
string picturename = "timer.gif"
boolean focusrectangle = false
end type


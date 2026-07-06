HA$PBExportHeader$w_clipboard.srw
forward
global type w_clipboard from w_popup_root
end type
type cb_1 from so_commandbutton within w_clipboard
end type
type cb_2 from so_commandbutton within w_clipboard
end type
type cb_3 from so_commandbutton within w_clipboard
end type
end forward

global type w_clipboard from w_popup_root
integer width = 1527
integer height = 1044
string title = "Clipboard"
boolean minbox = true
windowtype windowtype = popup!
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
end type
global w_clipboard w_clipboard

on w_clipboard.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_3
end on

on w_clipboard.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
end on

type p_title from w_popup_root`p_title within w_clipboard
integer width = 1509
end type

type cb_sort from w_popup_root`cb_sort within w_clipboard
boolean visible = true
integer x = 18
integer y = 208
integer width = 297
integer height = 104
end type

type cb_close from w_popup_root`cb_close within w_clipboard
boolean visible = true
integer x = 1198
integer y = 208
integer width = 297
integer height = 104
end type

type st_msg from w_popup_root`st_msg within w_clipboard
integer y = 1052
integer width = 1509
end type

type dw_1 from w_popup_root`dw_1 within w_clipboard
boolean visible = true
integer y = 320
integer width = 1509
integer height = 632
boolean titlebar = true
string dataobject = "d_clipboard"
end type

type dw_2 from w_popup_root`dw_2 within w_clipboard
integer y = 380
integer height = 436
end type

type dw_3 from w_popup_root`dw_3 within w_clipboard
end type

type cb_1 from so_commandbutton within w_clipboard
integer x = 311
integer y = 208
integer width = 297
integer height = 104
integer taborder = 20
boolean bringtotop = true
string text = "Delete"
end type

event clicked;dw_1.deleterow(dw_1.getrow())
end event

type cb_2 from so_commandbutton within w_clipboard
integer x = 905
integer y = 208
integer width = 297
integer height = 104
integer taborder = 30
boolean bringtotop = true
string text = "Select"
end type

event clicked;if dw_1.getrow() < 1 then return
Gvs_clipboard = dw_1.getitemstring( dw_1.getrow() , 'text')
st_msg.text = Gvs_clipboard
end event

type cb_3 from so_commandbutton within w_clipboard
integer x = 608
integer y = 208
integer width = 297
integer height = 104
integer taborder = 30
boolean bringtotop = true
string text = "All Delete"
end type

event clicked;dw_1.reset()
end event


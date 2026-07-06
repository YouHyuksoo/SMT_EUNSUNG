HA$PBExportHeader$w_clipboard_info.srw
forward
global type w_clipboard_info from w_popup_root
end type
type cb_1 from so_commandbutton within w_clipboard_info
end type
type pb_import from so_commandbutton within w_clipboard_info
end type
end forward

global type w_clipboard_info from w_popup_root
integer width = 1527
integer height = 1676
string title = "Clipboard"
boolean minbox = true
windowtype windowtype = popup!
cb_1 cb_1
pb_import pb_import
end type
global w_clipboard_info w_clipboard_info

on w_clipboard_info.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.pb_import=create pb_import
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.pb_import
end on

on w_clipboard_info.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.pb_import)
end on

event ue_post_open;call super::ue_post_open;pb_import.triggerevent( clicked!)
end event

type p_title from w_popup_root`p_title within w_clipboard_info
integer width = 1509
end type

type cb_sort from w_popup_root`cb_sort within w_clipboard_info
boolean visible = true
integer x = 18
integer y = 208
integer width = 297
integer height = 104
end type

type cb_close from w_popup_root`cb_close within w_clipboard_info
boolean visible = true
integer x = 919
integer y = 204
integer width = 297
integer height = 104
end type

type st_msg from w_popup_root`st_msg within w_clipboard_info
integer y = 1052
integer width = 1509
end type

type dw_1 from w_popup_root`dw_1 within w_clipboard_info
boolean visible = true
integer y = 320
integer width = 1509
integer height = 1272
boolean titlebar = true
string dataobject = "d_clipboard_info"
end type

type dw_2 from w_popup_root`dw_2 within w_clipboard_info
integer y = 380
integer height = 436
end type

type dw_3 from w_popup_root`dw_3 within w_clipboard_info
end type

type cb_1 from so_commandbutton within w_clipboard_info
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

type pb_import from so_commandbutton within w_clipboard_info
integer x = 613
integer y = 208
integer width = 297
integer height = 104
integer taborder = 30
boolean bringtotop = true
string text = "Paste"
end type

event clicked;call super::clicked;dw_1.importstring( message.stringparm  )
end event


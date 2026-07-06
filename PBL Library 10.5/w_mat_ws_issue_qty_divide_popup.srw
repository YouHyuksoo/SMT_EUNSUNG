HA$PBExportHeader$w_mat_ws_issue_qty_divide_popup.srw
$PBExportComments$Purchase Order Lot Divide Popup
forward
global type w_mat_ws_issue_qty_divide_popup from w_none_dw_popup_root
end type
type cb_2 from so_commandbutton within w_mat_ws_issue_qty_divide_popup
end type
type em_origin from so_editmask within w_mat_ws_issue_qty_divide_popup
end type
type st_origin from so_statictext within w_mat_ws_issue_qty_divide_popup
end type
type em_new from so_editmask within w_mat_ws_issue_qty_divide_popup
end type
type st_new from so_statictext within w_mat_ws_issue_qty_divide_popup
end type
type gb_1 from so_groupbox within w_mat_ws_issue_qty_divide_popup
end type
end forward

global type w_mat_ws_issue_qty_divide_popup from w_none_dw_popup_root
integer width = 1678
integer height = 856
cb_2 cb_2
em_origin em_origin
st_origin st_origin
em_new em_new
st_new st_new
gb_1 gb_1
end type
global w_mat_ws_issue_qty_divide_popup w_mat_ws_issue_qty_divide_popup

on w_mat_ws_issue_qty_divide_popup.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.em_origin=create em_origin
this.st_origin=create st_origin
this.em_new=create em_new
this.st_new=create st_new
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.em_origin
this.Control[iCurrent+3]=this.st_origin
this.Control[iCurrent+4]=this.em_new
this.Control[iCurrent+5]=this.st_new
this.Control[iCurrent+6]=this.gb_1
end on

on w_mat_ws_issue_qty_divide_popup.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.em_origin)
destroy(this.st_origin)
destroy(this.em_new)
destroy(this.st_new)
destroy(this.gb_1)
end on

event open;call super::open;em_origin.text = string(message.doubleparm)
em_new.setfocus()
end event

type p_title from w_none_dw_popup_root`p_title within w_mat_ws_issue_qty_divide_popup
end type

type cb_close from w_none_dw_popup_root`cb_close within w_mat_ws_issue_qty_divide_popup
boolean visible = true
integer x = 837
integer y = 624
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_none_dw_popup_root`st_msg within w_mat_ws_issue_qty_divide_popup
boolean visible = true
integer y = 0
end type

type cb_2 from so_commandbutton within w_mat_ws_issue_qty_divide_popup
integer x = 558
integer y = 624
integer width = 274
integer height = 100
integer taborder = 20
boolean bringtotop = true
string text = "Ok"
end type

event clicked;call super::clicked;gst_return.gvb_return = true 
gst_return.gvf_return[1] = dec(em_new.text)
close(parent)
end event

type em_origin from so_editmask within w_mat_ws_issue_qty_divide_popup
integer x = 718
integer y = 328
integer width = 617
boolean bringtotop = true
string text = ""
maskdatatype maskdatatype = decimalmask!
string mask = "###,##0.####"
end type

type st_origin from so_statictext within w_mat_ws_issue_qty_divide_popup
integer x = 183
integer y = 332
integer width = 535
boolean bringtotop = true
integer weight = 700
string text = "Original Qty"
alignment alignment = right!
end type

type em_new from so_editmask within w_mat_ws_issue_qty_divide_popup
integer x = 718
integer y = 412
integer width = 617
integer taborder = 10
boolean bringtotop = true
string text = ""
maskdatatype maskdatatype = decimalmask!
string mask = "###,##0.####"
end type

type st_new from so_statictext within w_mat_ws_issue_qty_divide_popup
integer x = 183
integer y = 420
integer width = 535
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "New Qty"
alignment alignment = right!
end type

type gb_1 from so_groupbox within w_mat_ws_issue_qty_divide_popup
integer x = 137
integer y = 204
integer width = 1371
integer height = 368
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


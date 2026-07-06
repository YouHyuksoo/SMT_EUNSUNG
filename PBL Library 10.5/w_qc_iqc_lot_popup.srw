HA$PBExportHeader$w_qc_iqc_lot_popup.srw
$PBExportComments$Lqc Lot Divide Popup
forward
global type w_qc_iqc_lot_popup from w_none_dw_popup_root
end type
type cb_2 from so_commandbutton within w_qc_iqc_lot_popup
end type
type em_order_weight from so_editmask within w_qc_iqc_lot_popup
end type
type st_3 from so_statictext within w_qc_iqc_lot_popup
end type
type em_lot_qty from so_editmask within w_qc_iqc_lot_popup
end type
type st_4 from so_statictext within w_qc_iqc_lot_popup
end type
type gb_1 from so_groupbox within w_qc_iqc_lot_popup
end type
end forward

global type w_qc_iqc_lot_popup from w_none_dw_popup_root
integer width = 1678
integer height = 912
cb_2 cb_2
em_order_weight em_order_weight
st_3 st_3
em_lot_qty em_lot_qty
st_4 st_4
gb_1 gb_1
end type
global w_qc_iqc_lot_popup w_qc_iqc_lot_popup

on w_qc_iqc_lot_popup.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.em_order_weight=create em_order_weight
this.st_3=create st_3
this.em_lot_qty=create em_lot_qty
this.st_4=create st_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.em_order_weight
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.em_lot_qty
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.gb_1
end on

on w_qc_iqc_lot_popup.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.em_order_weight)
destroy(this.st_3)
destroy(this.em_lot_qty)
destroy(this.st_4)
destroy(this.gb_1)
end on

event open;call super::open;em_order_weight.text = string(message.doubleparm)
em_lot_qty.setfocus()
end event

type p_title from w_none_dw_popup_root`p_title within w_qc_iqc_lot_popup
end type

type cb_close from w_none_dw_popup_root`cb_close within w_qc_iqc_lot_popup
boolean visible = true
integer x = 832
integer y = 696
integer taborder = 0
end type

type st_msg from w_none_dw_popup_root`st_msg within w_qc_iqc_lot_popup
boolean visible = true
integer y = 0
boolean enabled = true
end type

type cb_2 from so_commandbutton within w_qc_iqc_lot_popup
integer x = 553
integer y = 696
integer width = 274
integer height = 100
integer taborder = 20
boolean bringtotop = true
string text = "Ok"
end type

event clicked;call super::clicked;message.doubleparm = double(em_lot_qty.text)
gst_return.gvb_return = true
closewithreturn(parent, message.doubleparm )
end event

type em_order_weight from so_editmask within w_qc_iqc_lot_popup
integer x = 791
integer y = 384
integer width = 535
boolean bringtotop = true
boolean enabled = false
string mask = "#,###,###,##0."
end type

type st_3 from so_statictext within w_qc_iqc_lot_popup
integer x = 197
integer y = 380
integer width = 553
boolean bringtotop = true
integer weight = 700
string text = "Original Qty"
alignment alignment = right!
end type

type em_lot_qty from so_editmask within w_qc_iqc_lot_popup
integer x = 791
integer y = 468
integer width = 535
integer taborder = 10
boolean bringtotop = true
string mask = "#,###,###,##0."
end type

type st_4 from so_statictext within w_qc_iqc_lot_popup
integer x = 197
integer y = 468
integer width = 553
boolean bringtotop = true
integer weight = 700
long textcolor = 255
string text = "Lot Qty"
alignment alignment = right!
end type

type gb_1 from so_groupbox within w_qc_iqc_lot_popup
integer x = 151
integer y = 252
integer width = 1303
integer height = 388
end type


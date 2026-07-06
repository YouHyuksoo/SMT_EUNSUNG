HA$PBExportHeader$w_mat_item_receipt_barcode_scan_popup.srw
$PBExportComments$Purchase Order Lot Divide Popup
forward
global type w_mat_item_receipt_barcode_scan_popup from w_none_dw_popup_root
end type
type em_barcode from so_editmask within w_mat_item_receipt_barcode_scan_popup
end type
type st_origin from so_statictext within w_mat_item_receipt_barcode_scan_popup
end type
type p_1 from picture within w_mat_item_receipt_barcode_scan_popup
end type
type gb_1 from so_groupbox within w_mat_item_receipt_barcode_scan_popup
end type
end forward

global type w_mat_item_receipt_barcode_scan_popup from w_none_dw_popup_root
integer width = 1797
integer height = 784
boolean titlebar = false
boolean controlmenu = false
boolean contexthelp = false
em_barcode em_barcode
st_origin st_origin
p_1 p_1
gb_1 gb_1
end type
global w_mat_item_receipt_barcode_scan_popup w_mat_item_receipt_barcode_scan_popup

type variables
window ivw_window
end variables

on w_mat_item_receipt_barcode_scan_popup.create
int iCurrent
call super::create
this.em_barcode=create em_barcode
this.st_origin=create st_origin
this.p_1=create p_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_barcode
this.Control[iCurrent+2]=this.st_origin
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.gb_1
end on

on w_mat_item_receipt_barcode_scan_popup.destroy
call super::destroy
destroy(this.em_barcode)
destroy(this.st_origin)
destroy(this.p_1)
destroy(this.gb_1)
end on

event open;call super::open;ivw_window = message.powerobjectparm // $$HEX10$$08c7c4b3b0c600ac200018b1b4c528c6e4b22000$$ENDHEX$$
em_barcode.setfocus( )
end event

event rbuttondown;call super::rbuttondown;em_barcode.setfocus( )
end event

event resize;call super::resize;em_barcode.setfocus( )
end event

event ue_post_open;call super::ue_post_open;em_barcode.setfocus( )
end event

event clicked;call super::clicked;em_barcode.setfocus( )
end event

event activate;call super::activate;em_barcode.setfocus( )
end event

event doubleclicked;call super::doubleclicked;em_barcode.setfocus( )
end event

type p_title from w_none_dw_popup_root`p_title within w_mat_item_receipt_barcode_scan_popup
end type

event p_title::getfocus;call super::getfocus;em_barcode.setfocus( )
end event

event p_title::clicked;call super::clicked;em_barcode.setfocus( )
end event

type cb_close from w_none_dw_popup_root`cb_close within w_mat_item_receipt_barcode_scan_popup
boolean visible = true
integer x = 745
integer y = 628
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_none_dw_popup_root`st_msg within w_mat_item_receipt_barcode_scan_popup
boolean visible = true
integer y = 0
end type

type em_barcode from so_editmask within w_mat_item_receipt_barcode_scan_popup
integer x = 599
integer y = 348
integer width = 1111
integer height = 136
integer taborder = 1
boolean bringtotop = true
integer textsize = -14
string text = ""
alignment alignment = left!
textcase textcase = upper!
maskdatatype maskdatatype = stringmask!
end type

event modified;call super::modified;f_retrieve()
this.setfocus( )
this.selecttext( 1, len(this.text))
end event

type st_origin from so_statictext within w_mat_item_receipt_barcode_scan_popup
integer x = 46
integer y = 360
integer width = 535
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 700
string text = "Barcode"
alignment alignment = right!
end type

type p_1 from picture within w_mat_item_receipt_barcode_scan_popup
integer x = 1522
integer width = 251
integer height = 196
boolean bringtotop = true
string picturename = "D:\Project\ERP\Infinity21 ERP Common\PBL Library 10.5\confirm.bmp"
boolean focusrectangle = false
end type

event clicked;em_barcode.setfocus( )
end event

type gb_1 from so_groupbox within w_mat_item_receipt_barcode_scan_popup
integer x = 18
integer y = 204
integer width = 1742
integer height = 368
integer weight = 700
long textcolor = 16711680
string text = "Invoice Barcode"
end type


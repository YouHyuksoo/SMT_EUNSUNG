HA$PBExportHeader$w_mat_item_barcode_checkhist_4_feeder_popup.srw
$PBExportComments$$$HEX8$$6cade4b9e8b200ac20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_mat_item_barcode_checkhist_4_feeder_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_mat_item_barcode_checkhist_4_feeder_popup
end type
type uo_dateset from uo_ymd_calendar within w_mat_item_barcode_checkhist_4_feeder_popup
end type
type st_2 from so_statictext within w_mat_item_barcode_checkhist_4_feeder_popup
end type
type sle_lot_no from singlelineedit within w_mat_item_barcode_checkhist_4_feeder_popup
end type
type st_7 from statictext within w_mat_item_barcode_checkhist_4_feeder_popup
end type
type gb_3 from so_groupbox within w_mat_item_barcode_checkhist_4_feeder_popup
end type
type gb_1 from so_groupbox within w_mat_item_barcode_checkhist_4_feeder_popup
end type
end forward

global type w_mat_item_barcode_checkhist_4_feeder_popup from w_popup_root
integer width = 5211
integer height = 2776
string title = "Receipt Barcode Popup"
string ivs_resize_type = "DEFAULT"
cb_retrieve cb_retrieve
uo_dateset uo_dateset
st_2 st_2
sle_lot_no sle_lot_no
st_7 st_7
gb_3 gb_3
gb_1 gb_1
end type
global w_mat_item_barcode_checkhist_4_feeder_popup w_mat_item_barcode_checkhist_4_feeder_popup

on w_mat_item_barcode_checkhist_4_feeder_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.uo_dateset=create uo_dateset
this.st_2=create st_2
this.sle_lot_no=create sle_lot_no
this.st_7=create st_7
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.uo_dateset
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_lot_no
this.Control[iCurrent+5]=this.st_7
this.Control[iCurrent+6]=this.gb_3
this.Control[iCurrent+7]=this.gb_1
end on

on w_mat_item_barcode_checkhist_4_feeder_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.uo_dateset)
destroy(this.st_2)
destroy(this.sle_lot_no)
destroy(this.st_7)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event open;call super::open;IVS_RESIZE_TYPE= 'DEFAULT'

dw_1.settransobject(sqlca)
sle_lot_no.text = message.stringparm
cb_retrieve.triggerevent(CLICKED!)

end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_mat_item_barcode_checkhist_4_feeder_popup
integer x = 5
integer width = 5216
end type

type cb_sort from w_popup_root`cb_sort within w_mat_item_barcode_checkhist_4_feeder_popup
boolean visible = true
integer x = 3986
integer y = 312
integer height = 168
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_mat_item_barcode_checkhist_4_feeder_popup
boolean visible = true
integer x = 4823
integer y = 312
integer height = 168
integer weight = 400
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_mat_item_barcode_checkhist_4_feeder_popup
boolean visible = true
integer x = 9
integer y = 560
integer width = 5202
end type

type dw_1 from w_popup_root`dw_1 within w_mat_item_barcode_checkhist_4_feeder_popup
boolean visible = true
integer y = 648
integer width = 3319
integer height = 2032
boolean titlebar = true
string title = "Barcode List"
string dataobject = "d_smt_checklist_4_feeder_popup"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
dw_2.retrieve( this.object.lot_no[currentrow] , gvi_organization_id)
dw_3.retrieve( this.object.lot_no[currentrow] , gvi_organization_id )
end event

type dw_2 from w_popup_root`dw_2 within w_mat_item_barcode_checkhist_4_feeder_popup
boolean visible = true
integer x = 3328
integer y = 1396
integer width = 1874
integer height = 1280
boolean titlebar = true
string title = "Issue Date"
string dataobject = "d_mat_issue_4_barcode_lst"
end type

type dw_3 from w_popup_root`dw_3 within w_mat_item_barcode_checkhist_4_feeder_popup
boolean visible = true
integer x = 3328
integer y = 656
integer width = 1874
integer height = 732
boolean titlebar = true
string title = "Receipt List"
string dataobject = "d_mat_receipt_4_barcode_popup"
end type

type cb_retrieve from so_commandbutton within w_mat_item_barcode_checkhist_4_feeder_popup
integer x = 4265
integer y = 312
integer width = 274
integer height = 168
integer taborder = 70
boolean bringtotop = true
integer weight = 400
string text = "Retrieve"
end type

event clicked; 
	DW_1.RETRIEVE( sle_lot_no.text+'%'  )

end event

type uo_dateset from uo_ymd_calendar within w_mat_item_barcode_checkhist_4_feeder_popup
integer x = 123
integer y = 392
integer width = 402
integer taborder = 110
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_2 from so_statictext within w_mat_item_barcode_checkhist_4_feeder_popup
integer x = 123
integer y = 320
integer width = 402
integer height = 68
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Dateset"
end type

type sle_lot_no from singlelineedit within w_mat_item_barcode_checkhist_4_feeder_popup
event ue_editchange pbm_enchange
integer x = 539
integer y = 392
integer width = 741
integer height = 84
integer taborder = 80
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

type st_7 from statictext within w_mat_item_barcode_checkhist_4_feeder_popup
integer x = 535
integer y = 324
integer width = 741
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
string text = "Lot No"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_3 from so_groupbox within w_mat_item_barcode_checkhist_4_feeder_popup
integer x = 3877
integer y = 216
integer width = 1312
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_mat_item_barcode_checkhist_4_feeder_popup
integer x = 23
integer y = 212
integer width = 1344
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


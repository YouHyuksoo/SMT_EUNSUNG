HA$PBExportHeader$w_mat_item_barcode_inventory_detail_popup.srw
$PBExportComments$$$HEX8$$6cade4b9e8b200ac20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_mat_item_barcode_inventory_detail_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_mat_item_barcode_inventory_detail_popup
end type
type st_item_code from so_statictext within w_mat_item_barcode_inventory_detail_popup
end type
type ddlb_item_code from uo_item_code within w_mat_item_barcode_inventory_detail_popup
end type
type uo_dateset from uo_ymd_calendar within w_mat_item_barcode_inventory_detail_popup
end type
type st_2 from so_statictext within w_mat_item_barcode_inventory_detail_popup
end type
type sle_feeder_location_code from so_singlelineedit within w_mat_item_barcode_inventory_detail_popup
end type
type st_1 from so_statictext within w_mat_item_barcode_inventory_detail_popup
end type
type sle_feeder_shaft from so_singlelineedit within w_mat_item_barcode_inventory_detail_popup
end type
type st_3 from so_statictext within w_mat_item_barcode_inventory_detail_popup
end type
type sle_line_code from so_singlelineedit within w_mat_item_barcode_inventory_detail_popup
end type
type st_4 from so_statictext within w_mat_item_barcode_inventory_detail_popup
end type
type dw_4 from so_datawindow within w_mat_item_barcode_inventory_detail_popup
end type
type pb_1 from so_commandbutton within w_mat_item_barcode_inventory_detail_popup
end type
type gb_3 from so_groupbox within w_mat_item_barcode_inventory_detail_popup
end type
type gb_1 from so_groupbox within w_mat_item_barcode_inventory_detail_popup
end type
end forward

global type w_mat_item_barcode_inventory_detail_popup from w_popup_root
integer width = 5211
integer height = 2776
string title = "Receipt Barcode Popup"
string ivs_resize_type = "DEFAULT"
cb_retrieve cb_retrieve
st_item_code st_item_code
ddlb_item_code ddlb_item_code
uo_dateset uo_dateset
st_2 st_2
sle_feeder_location_code sle_feeder_location_code
st_1 st_1
sle_feeder_shaft sle_feeder_shaft
st_3 st_3
sle_line_code sle_line_code
st_4 st_4
dw_4 dw_4
pb_1 pb_1
gb_3 gb_3
gb_1 gb_1
end type
global w_mat_item_barcode_inventory_detail_popup w_mat_item_barcode_inventory_detail_popup

on w_mat_item_barcode_inventory_detail_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.st_item_code=create st_item_code
this.ddlb_item_code=create ddlb_item_code
this.uo_dateset=create uo_dateset
this.st_2=create st_2
this.sle_feeder_location_code=create sle_feeder_location_code
this.st_1=create st_1
this.sle_feeder_shaft=create sle_feeder_shaft
this.st_3=create st_3
this.sle_line_code=create sle_line_code
this.st_4=create st_4
this.dw_4=create dw_4
this.pb_1=create pb_1
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.st_item_code
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.uo_dateset
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_feeder_location_code
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.sle_feeder_shaft
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.sle_line_code
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.dw_4
this.Control[iCurrent+13]=this.pb_1
this.Control[iCurrent+14]=this.gb_3
this.Control[iCurrent+15]=this.gb_1
end on

on w_mat_item_barcode_inventory_detail_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.st_item_code)
destroy(this.ddlb_item_code)
destroy(this.uo_dateset)
destroy(this.st_2)
destroy(this.sle_feeder_location_code)
destroy(this.st_1)
destroy(this.sle_feeder_shaft)
destroy(this.st_3)
destroy(this.sle_line_code)
destroy(this.st_4)
destroy(this.dw_4)
destroy(this.pb_1)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event open;call super::open;IVS_RESIZE_TYPE= 'DEFAULT'

dw_1.settransobject(sqlca)
dw_4.settransobject(sqlca)
f_set_column_dddw(dw_4)

ddlb_item_code.text = message.stringparm
sle_line_code.text =  Gst_return.gvs_return[1]
sle_feeder_shaft.text  = Gst_return.gvs_return[2]
sle_feeder_location_code.text  = Gst_return.gvs_return[3]
cb_retrieve.triggerevent(CLICKED!)

end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_mat_item_barcode_inventory_detail_popup
integer x = 5
integer width = 5216
end type

type cb_sort from w_popup_root`cb_sort within w_mat_item_barcode_inventory_detail_popup
boolean visible = true
integer x = 3456
integer y = 312
integer width = 416
integer height = 168
end type

type cb_close from w_popup_root`cb_close within w_mat_item_barcode_inventory_detail_popup
boolean visible = true
integer x = 4823
integer y = 312
integer height = 168
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_mat_item_barcode_inventory_detail_popup
boolean visible = true
integer x = 9
integer y = 560
integer width = 5202
end type

type dw_1 from w_popup_root`dw_1 within w_mat_item_barcode_inventory_detail_popup
boolean visible = true
integer y = 648
integer width = 3319
integer height = 732
boolean titlebar = true
string title = "Barcode List"
string dataobject = "d_mat_rcviss_barcode_detail_lst_popup"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
dw_2.retrieve( this.object.lot_no[currentrow] , gvi_organization_id)
dw_3.retrieve( this.object.lot_no[currentrow] , gvi_organization_id )
end event

type dw_2 from w_popup_root`dw_2 within w_mat_item_barcode_inventory_detail_popup
boolean visible = true
integer x = 3328
integer y = 1396
integer width = 1874
integer height = 1292
boolean titlebar = true
string title = "Issue Date"
string dataobject = "d_mat_issue_4_barcode_detail_lst"
end type

type dw_3 from w_popup_root`dw_3 within w_mat_item_barcode_inventory_detail_popup
boolean visible = true
integer x = 3328
integer y = 656
integer width = 1874
integer height = 732
boolean titlebar = true
string title = "Receipt List"
string dataobject = "d_mat_receipt_4_barcode_popup"
end type

type cb_retrieve from so_commandbutton within w_mat_item_barcode_inventory_detail_popup
integer x = 3881
integer y = 312
integer width = 443
integer height = 168
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE( ddlb_item_code.text  , sle_line_code.text+'%' , sle_feeder_shaft.text+'%'  , sle_feeder_location_code.text+'%' ,  GVI_ORGANIZATION_ID )
end event

type st_item_code from so_statictext within w_mat_item_barcode_inventory_detail_popup
integer x = 530
integer y = 308
integer width = 590
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_item_barcode_inventory_detail_popup
integer x = 530
integer y = 384
integer width = 590
integer taborder = 20
boolean bringtotop = true
end type

type uo_dateset from uo_ymd_calendar within w_mat_item_barcode_inventory_detail_popup
integer x = 119
integer y = 380
integer width = 402
integer taborder = 110
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_2 from so_statictext within w_mat_item_barcode_inventory_detail_popup
integer x = 119
integer y = 308
integer width = 402
integer height = 68
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Dateset"
end type

type sle_feeder_location_code from so_singlelineedit within w_mat_item_barcode_inventory_detail_popup
integer x = 1129
integer y = 384
integer width = 434
integer height = 84
integer taborder = 30
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mat_item_barcode_inventory_detail_popup
integer x = 1134
integer y = 308
integer width = 430
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Feeder Location"
end type

type sle_feeder_shaft from so_singlelineedit within w_mat_item_barcode_inventory_detail_popup
integer x = 1577
integer y = 384
integer width = 434
integer height = 84
integer taborder = 40
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_item_barcode_inventory_detail_popup
integer x = 1577
integer y = 308
integer width = 434
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Feeder Shaft"
end type

type sle_line_code from so_singlelineedit within w_mat_item_barcode_inventory_detail_popup
integer x = 2021
integer y = 384
integer width = 283
integer height = 84
integer taborder = 50
boolean bringtotop = true
end type

type st_4 from so_statictext within w_mat_item_barcode_inventory_detail_popup
integer x = 2021
integer y = 304
integer width = 283
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type dw_4 from so_datawindow within w_mat_item_barcode_inventory_detail_popup
integer y = 1392
integer width = 3319
integer height = 1292
integer taborder = 110
boolean bringtotop = true
boolean titlebar = true
string title = "Reel Change History"
string dataobject = "d_smt_checkhist_4_feeding_monitor_lst"
end type

type pb_1 from so_commandbutton within w_mat_item_barcode_inventory_detail_popup
integer x = 4334
integer y = 312
integer width = 443
integer height = 168
integer taborder = 80
boolean bringtotop = true
string text = "Change History"
end type

event clicked;call super::clicked;if dw_1.getrow() <  0 then return 
dw_4.retrieve(  dw_1.object.line_code[dw_1.getrow()]  , dw_1.object.feeding_model[dw_1.getrow()] , dw_1.object.location_code[dw_1.getrow()]  ,   dw_1.object.item_code[dw_1.getrow()] )
end event

type gb_3 from so_groupbox within w_mat_item_barcode_inventory_detail_popup
integer x = 3406
integer y = 216
integer width = 1783
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_mat_item_barcode_inventory_detail_popup
integer x = 14
integer y = 200
integer width = 2304
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


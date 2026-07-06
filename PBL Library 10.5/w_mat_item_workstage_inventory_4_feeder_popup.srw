HA$PBExportHeader$w_mat_item_workstage_inventory_4_feeder_popup.srw
$PBExportComments$$$HEX8$$6cade4b9e8b200ac20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_mat_item_workstage_inventory_4_feeder_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_mat_item_workstage_inventory_4_feeder_popup
end type
type cb_select from so_commandbutton within w_mat_item_workstage_inventory_4_feeder_popup
end type
type st_item_code from so_statictext within w_mat_item_workstage_inventory_4_feeder_popup
end type
type ddlb_item_code from uo_item_code within w_mat_item_workstage_inventory_4_feeder_popup
end type
type sle_line_code from so_singlelineedit within w_mat_item_workstage_inventory_4_feeder_popup
end type
type st_14 from so_statictext within w_mat_item_workstage_inventory_4_feeder_popup
end type
type sle_location_code from so_singlelineedit within w_mat_item_workstage_inventory_4_feeder_popup
end type
type st_1 from so_statictext within w_mat_item_workstage_inventory_4_feeder_popup
end type
type gb_2 from so_groupbox within w_mat_item_workstage_inventory_4_feeder_popup
end type
type gb_3 from so_groupbox within w_mat_item_workstage_inventory_4_feeder_popup
end type
end forward

global type w_mat_item_workstage_inventory_4_feeder_popup from w_popup_root
integer width = 4448
integer height = 2232
string title = "Material Item Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_item_code st_item_code
ddlb_item_code ddlb_item_code
sle_line_code sle_line_code
st_14 st_14
sle_location_code sle_location_code
st_1 st_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_item_workstage_inventory_4_feeder_popup w_mat_item_workstage_inventory_4_feeder_popup

on w_mat_item_workstage_inventory_4_feeder_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_item_code=create st_item_code
this.ddlb_item_code=create ddlb_item_code
this.sle_line_code=create sle_line_code
this.st_14=create st_14
this.sle_location_code=create sle_location_code
this.st_1=create st_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_item_code
this.Control[iCurrent+4]=this.ddlb_item_code
this.Control[iCurrent+5]=this.sle_line_code
this.Control[iCurrent+6]=this.st_14
this.Control[iCurrent+7]=this.sle_location_code
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_3
end on

on w_mat_item_workstage_inventory_4_feeder_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_item_code)
destroy(this.ddlb_item_code)
destroy(this.sle_line_code)
destroy(this.st_14)
destroy(this.sle_location_code)
destroy(this.st_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)
sle_line_code.text = Gst_return.gvs_return[1]
ddlb_item_code.text = message.stringparm
sle_location_code.text = Gst_return.gvs_return[2]
cb_retrieve.triggerevent(clicked!)
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_mat_item_workstage_inventory_4_feeder_popup
integer width = 4443
end type

type cb_sort from w_popup_root`cb_sort within w_mat_item_workstage_inventory_4_feeder_popup
boolean visible = true
integer x = 1856
integer y = 324
integer width = 325
integer height = 164
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_mat_item_workstage_inventory_4_feeder_popup
boolean visible = true
integer x = 2811
integer y = 324
integer width = 325
integer height = 164
integer weight = 400
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_mat_item_workstage_inventory_4_feeder_popup
boolean visible = true
integer x = 5
integer y = 556
integer width = 4448
end type

type dw_1 from w_popup_root`dw_1 within w_mat_item_workstage_inventory_4_feeder_popup
boolean visible = true
integer y = 660
integer width = 4453
integer height = 1504
boolean titlebar = true
string title = "Workstage  Inventory List"
string dataobject = "d_mat_workstage_inventory_4_feeder_lst"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_mat_item_workstage_inventory_4_feeder_popup
integer y = 660
end type

type dw_3 from w_popup_root`dw_3 within w_mat_item_workstage_inventory_4_feeder_popup
integer y = 736
end type

type cb_retrieve from so_commandbutton within w_mat_item_workstage_inventory_4_feeder_popup
integer x = 2171
integer y = 324
integer width = 325
integer height = 164
integer taborder = 70
boolean bringtotop = true
integer weight = 400
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(  sle_line_code.text , ddlb_item_code.text  , sle_location_code.text , GVI_ORGANIZATION_ID )
end event

type cb_select from so_commandbutton within w_mat_item_workstage_inventory_4_feeder_popup
integer x = 2491
integer y = 324
integer width = 325
integer height = 164
integer taborder = 80
boolean bringtotop = true
integer weight = 400
string text = "Select"
boolean default = true
end type

type st_item_code from so_statictext within w_mat_item_workstage_inventory_4_feeder_popup
integer x = 530
integer y = 324
integer width = 709
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_item_workstage_inventory_4_feeder_popup
integer x = 530
integer y = 396
integer width = 709
integer taborder = 20
boolean bringtotop = true
end type

type sle_line_code from so_singlelineedit within w_mat_item_workstage_inventory_4_feeder_popup
integer x = 41
integer y = 392
integer width = 480
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type st_14 from so_statictext within w_mat_item_workstage_inventory_4_feeder_popup
integer x = 41
integer y = 308
integer width = 480
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type sle_location_code from so_singlelineedit within w_mat_item_workstage_inventory_4_feeder_popup
integer x = 1248
integer y = 396
integer width = 421
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
textcase textcase = upper!
end type

type st_1 from so_statictext within w_mat_item_workstage_inventory_4_feeder_popup
integer x = 1248
integer y = 316
integer width = 421
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Location Code"
end type

type gb_2 from so_groupbox within w_mat_item_workstage_inventory_4_feeder_popup
integer x = 5
integer y = 204
integer width = 1829
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_item_workstage_inventory_4_feeder_popup
integer x = 1833
integer y = 212
integer width = 1335
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


HA$PBExportHeader$w_smt_plan_feeder_list_popup.srw
$PBExportComments$$$HEX12$$3cd530d1a8bac8b230d1c1b970c88cd61dd3c5c50d000a00$$ENDHEX$$forward
global type w_smt_plan_feeder_list_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_smt_plan_feeder_list_popup
end type
type gb_2 from so_groupbox within w_smt_plan_feeder_list_popup
end type
end forward

global type w_smt_plan_feeder_list_popup from w_popup_root
integer width = 2569
integer height = 2092
string title = "Feeder Status Popup"
boolean minbox = true
windowtype windowtype = popup!
cb_retrieve cb_retrieve
gb_2 gb_2
end type
global w_smt_plan_feeder_list_popup w_smt_plan_feeder_list_popup

type variables
String ivs_line_code
String ivs_model_name
String ivs_active

Long  ivl_limit_time
Long  ivl_item_unit_qty
Long  ivl_limit_qty


end variables

on w_smt_plan_feeder_list_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.gb_2
end on

on w_smt_plan_feeder_list_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.gb_2)
end on

event ue_post_open;call super::ue_post_open;ivs_line_code      = Gst_return.gvs_return[1]
ivs_model_name = Gst_return.gvs_return[2]

dw_1.settransobject(sqlca)
cb_retrieve.triggerevent(clicked!)	

end event

type p_title from w_popup_root`p_title within w_smt_plan_feeder_list_popup
integer width = 2555
end type

type cb_sort from w_popup_root`cb_sort within w_smt_plan_feeder_list_popup
integer x = 46
integer y = 260
integer width = 288
integer height = 108
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_smt_plan_feeder_list_popup
boolean visible = true
integer x = 713
integer y = 260
integer width = 288
integer height = 108
integer weight = 400
end type

type st_msg from w_popup_root`st_msg within w_smt_plan_feeder_list_popup
boolean visible = true
integer y = 428
integer width = 2546
end type

type dw_1 from w_popup_root`dw_1 within w_smt_plan_feeder_list_popup
boolean visible = true
integer y = 520
integer width = 2546
integer height = 1484
boolean titlebar = true
string title = "Feeder Status"
string dataobject = "d_des_item_4_bom_smt_modify_lst"
end type

type dw_2 from w_popup_root`dw_2 within w_smt_plan_feeder_list_popup
boolean visible = true
integer y = 492
integer width = 2546
integer height = 640
end type

type dw_3 from w_popup_root`dw_3 within w_smt_plan_feeder_list_popup
integer y = 620
end type

type cb_retrieve from so_commandbutton within w_smt_plan_feeder_list_popup
boolean visible = false
integer x = 338
integer y = 260
integer width = 366
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer weight = 400
string text = "Retrieve"
end type

event clicked;dw_1.Retrieve(  message.stringparm , gvi_organization_id )
dw_1.SetFocus()

end event

type gb_2 from so_groupbox within w_smt_plan_feeder_list_popup
boolean visible = false
integer y = 188
integer width = 1083
integer height = 224
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


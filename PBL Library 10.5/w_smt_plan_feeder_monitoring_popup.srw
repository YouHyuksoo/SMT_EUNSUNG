HA$PBExportHeader$w_smt_plan_feeder_monitoring_popup.srw
$PBExportComments$$$HEX10$$3cd530d1a8bac8b230d1c1b970c88cd61dd3c5c5$$ENDHEX$$
forward
global type w_smt_plan_feeder_monitoring_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_smt_plan_feeder_monitoring_popup
end type
type gb_2 from so_groupbox within w_smt_plan_feeder_monitoring_popup
end type
end forward

global type w_smt_plan_feeder_monitoring_popup from w_popup_root
integer width = 4155
integer height = 2824
string title = "Feeder Status Popup"
boolean minbox = true
windowtype windowtype = popup!
cb_retrieve cb_retrieve
gb_2 gb_2
end type
global w_smt_plan_feeder_monitoring_popup w_smt_plan_feeder_monitoring_popup

type variables
String ivs_line_code
String ivs_model_name
String ivs_active

Long  ivl_limit_time
Long  ivl_item_unit_qty
Long  ivl_limit_qty


end variables

on w_smt_plan_feeder_monitoring_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.gb_2
end on

on w_smt_plan_feeder_monitoring_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.gb_2)
end on

event key;call super::key;//if key = keyf1! then 
//   cb_retrieve.triggerevent(clicked!)	
//end if
end event

event ue_post_open;call super::ue_post_open; f_set_column_dddw( dw_1 )
 
//$$HEX9$$70c88cd6200070c874ac0900090009000900$$ENDHEX$$
ivs_line_code      = Gst_return.gvs_return[1]
ivs_model_name = Gst_return.gvs_return[2]
ivs_active           = Gst_return.gvs_return[3] 
ivl_item_unit_qty = Gst_return.gvl_return[4] 

dw_1.settransobject(sqlca)
cb_retrieve.triggerevent(clicked!)	

end event

type p_title from w_popup_root`p_title within w_smt_plan_feeder_monitoring_popup
integer x = 14
integer width = 4142
end type

type cb_sort from w_popup_root`cb_sort within w_smt_plan_feeder_monitoring_popup
integer x = 3086
integer y = 292
integer width = 288
integer height = 156
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_smt_plan_feeder_monitoring_popup
boolean visible = true
integer x = 3753
integer y = 292
integer width = 288
integer height = 156
integer weight = 400
end type

type st_msg from w_popup_root`st_msg within w_smt_plan_feeder_monitoring_popup
boolean visible = true
integer y = 516
integer width = 4142
end type

type dw_1 from w_popup_root`dw_1 within w_smt_plan_feeder_monitoring_popup
boolean visible = true
integer y = 608
integer width = 4142
integer height = 1484
boolean titlebar = true
string title = "Feeder Status"
string dataobject = "d_smt_plan_master_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_smt_plan_feeder_monitoring_popup
boolean visible = true
integer y = 2100
integer width = 4133
integer height = 640
end type

type dw_3 from w_popup_root`dw_3 within w_smt_plan_feeder_monitoring_popup
integer y = 620
end type

type cb_retrieve from so_commandbutton within w_smt_plan_feeder_monitoring_popup
boolean visible = false
integer x = 3378
integer y = 292
integer width = 366
integer height = 156
integer taborder = 60
boolean bringtotop = true
integer weight = 400
string text = "Retrieve"
end type

event clicked;
dw_1.Retrieve(ivs_line_code , ivs_model_name, ivs_active , ivl_item_unit_qty , gvi_organization_id )
dw_1.SetFocus()

end event

type gb_2 from so_groupbox within w_smt_plan_feeder_monitoring_popup
boolean visible = false
integer x = 3040
integer y = 220
integer width = 1083
integer height = 272
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


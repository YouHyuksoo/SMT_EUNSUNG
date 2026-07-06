HA$PBExportHeader$w_smt_bom_replace_popup.srw
$PBExportComments$$$HEX12$$3cd530d1a8bac8b230d1c1b970c88cd61dd3c5c50d000a00$$ENDHEX$$forward
global type w_smt_bom_replace_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_smt_bom_replace_popup
end type
type sle_model_name from so_singlelineedit within w_smt_bom_replace_popup
end type
type st_1 from so_statictext within w_smt_bom_replace_popup
end type
type gb_2 from so_groupbox within w_smt_bom_replace_popup
end type
end forward

global type w_smt_bom_replace_popup from w_popup_root
integer width = 4590
integer height = 2180
string title = "Feeder Status Popup"
boolean minbox = true
windowtype windowtype = popup!
cb_retrieve cb_retrieve
sle_model_name sle_model_name
st_1 st_1
gb_2 gb_2
end type
global w_smt_bom_replace_popup w_smt_bom_replace_popup

type variables
String ivs_line_code
String ivs_model_name
String ivs_active

Long  ivl_limit_time
Long  ivl_item_unit_qty
Long  ivl_limit_qty


end variables

on w_smt_bom_replace_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.sle_model_name=create sle_model_name
this.st_1=create st_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.sle_model_name
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.gb_2
end on

on w_smt_bom_replace_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.sle_model_name)
destroy(this.st_1)
destroy(this.gb_2)
end on

event key;call super::key;//if key = keyf1! then 
//   cb_retrieve.triggerevent(clicked!)	
//end if
end event

event ue_post_open;call super::ue_post_open; f_set_column_dddw( dw_1 )
 
sle_model_name.text = message.stringparm

dw_1.settransobject(sqlca)
cb_retrieve.triggerevent(clicked!)	

end event

event activate;call super::activate;ivs_resize_type = 'DEFAULT'
end event

type p_title from w_popup_root`p_title within w_smt_bom_replace_popup
integer x = 14
integer width = 4553
end type

type cb_sort from w_popup_root`cb_sort within w_smt_bom_replace_popup
boolean visible = true
integer x = 3529
integer y = 280
integer width = 288
integer height = 156
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_smt_bom_replace_popup
boolean visible = true
integer x = 4197
integer y = 280
integer width = 288
integer height = 156
integer weight = 400
end type

type st_msg from w_popup_root`st_msg within w_smt_bom_replace_popup
boolean visible = true
integer y = 516
integer width = 4571
end type

type dw_1 from w_popup_root`dw_1 within w_smt_bom_replace_popup
boolean visible = true
integer x = 14
integer y = 604
integer width = 2277
integer height = 1484
boolean titlebar = true
string title = "Replace List"
string dataobject = "d_des_bom_smt_replace_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_smt_bom_replace_popup
boolean visible = true
integer x = 2299
integer y = 608
integer width = 2277
integer height = 1484
boolean titlebar = true
string title = "ENG BOM Replace List"
string dataobject = "d_des_item_replace_popup"
end type

type dw_3 from w_popup_root`dw_3 within w_smt_bom_replace_popup
boolean visible = true
integer x = 14
integer y = 604
integer width = 1865
integer height = 1484
boolean titlebar = true
string title = "ENG BOM Replace List"
end type

type cb_retrieve from so_commandbutton within w_smt_bom_replace_popup
integer x = 3822
integer y = 280
integer width = 366
integer height = 156
integer taborder = 60
boolean bringtotop = true
integer weight = 400
string text = "Retrieve"
end type

event clicked;
dw_1.Retrieve( sle_model_name.text+'%' , gvi_organization_id)
dw_2.Retrieve( sle_model_name.text+'%' , gvi_organization_id)
dw_1.SetFocus()

end event

type sle_model_name from so_singlelineedit within w_smt_bom_replace_popup
integer x = 114
integer y = 356
integer width = 805
integer taborder = 30
boolean bringtotop = true
end type

type st_1 from so_statictext within w_smt_bom_replace_popup
integer x = 114
integer y = 272
integer width = 805
boolean bringtotop = true
string text = "Model Name"
end type

type gb_2 from so_groupbox within w_smt_bom_replace_popup
boolean visible = false
integer x = 3483
integer y = 208
integer width = 1083
integer height = 272
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


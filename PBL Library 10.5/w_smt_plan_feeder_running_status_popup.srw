HA$PBExportHeader$w_smt_plan_feeder_running_status_popup.srw
$PBExportComments$$$HEX12$$3cd530d1a8bac8b230d1c1b970c88cd61dd3c5c50d000a00$$ENDHEX$$forward
global type w_smt_plan_feeder_running_status_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_smt_plan_feeder_running_status_popup
end type
type rb_all from so_radiobutton within w_smt_plan_feeder_running_status_popup
end type
type rb_gt from so_radiobutton within w_smt_plan_feeder_running_status_popup
end type
type sle_2 from so_singlelineedit within w_smt_plan_feeder_running_status_popup
end type
type st_18 from so_statictext within w_smt_plan_feeder_running_status_popup
end type
type sle_1 from so_singlelineedit within w_smt_plan_feeder_running_status_popup
end type
type st_1 from so_statictext within w_smt_plan_feeder_running_status_popup
end type
type gb_2 from so_groupbox within w_smt_plan_feeder_running_status_popup
end type
type gb_1 from so_groupbox within w_smt_plan_feeder_running_status_popup
end type
end forward

global type w_smt_plan_feeder_running_status_popup from w_popup_root
integer width = 5221
integer height = 2824
string title = "Feeder Status Popup"
boolean minbox = true
windowtype windowtype = popup!
cb_retrieve cb_retrieve
rb_all rb_all
rb_gt rb_gt
sle_2 sle_2
st_18 st_18
sle_1 sle_1
st_1 st_1
gb_2 gb_2
gb_1 gb_1
end type
global w_smt_plan_feeder_running_status_popup w_smt_plan_feeder_running_status_popup

type variables
String ivs_line_code
String ivs_model_name
String ivs_active

Long  ivl_limit_time
Long  ivl_item_unit_qty
Long  ivl_limit_qty


end variables

on w_smt_plan_feeder_running_status_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.rb_all=create rb_all
this.rb_gt=create rb_gt
this.sle_2=create sle_2
this.st_18=create st_18
this.sle_1=create sle_1
this.st_1=create st_1
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.rb_all
this.Control[iCurrent+3]=this.rb_gt
this.Control[iCurrent+4]=this.sle_2
this.Control[iCurrent+5]=this.st_18
this.Control[iCurrent+6]=this.sle_1
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.gb_2
this.Control[iCurrent+9]=this.gb_1
end on

on w_smt_plan_feeder_running_status_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.rb_all)
destroy(this.rb_gt)
destroy(this.sle_2)
destroy(this.st_18)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event key;call super::key;//if key = keyf1! then 
//   cb_retrieve.triggerevent(clicked!)	
//end if
end event

event ue_post_open;call super::ue_post_open; f_set_column_dddw( dw_1 )
cb_retrieve.triggerevent(clicked!)	

end event

event activate;call super::activate;IVS_RESIZE_TYPE = 'DEFAULT'
end event

type p_title from w_popup_root`p_title within w_smt_plan_feeder_running_status_popup
integer x = 14
integer width = 5193
end type

type cb_sort from w_popup_root`cb_sort within w_smt_plan_feeder_running_status_popup
integer x = 37
integer y = 8
integer width = 288
integer height = 156
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_smt_plan_feeder_running_status_popup
boolean visible = true
integer x = 443
integer y = 260
integer width = 288
integer height = 156
integer weight = 400
end type

type st_msg from w_popup_root`st_msg within w_smt_plan_feeder_running_status_popup
boolean visible = true
integer y = 476
integer width = 5193
end type

type dw_1 from w_popup_root`dw_1 within w_smt_plan_feeder_running_status_popup
boolean visible = true
integer y = 568
integer width = 2107
integer height = 2160
boolean titlebar = true
string title = "Feeder Status"
string dataobject = "d_smt_feeder_shaft_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve( this.object.line_code[currentrow] ,  this.object.model_name[currentrow] ,  this.object.feeder_shaft[currentrow] , this.object.pcb_item[currentrow] ,  gvi_organization_id )
end event

type dw_2 from w_popup_root`dw_2 within w_smt_plan_feeder_running_status_popup
boolean visible = true
integer x = 2126
integer y = 572
integer width = 3063
integer height = 2156
boolean titlebar = true
string title = "Wait Inventory List"
string dataobject = "d_mat_barcode_lst_4_issue_popup"
end type

type dw_3 from w_popup_root`dw_3 within w_smt_plan_feeder_running_status_popup
integer x = 5
integer y = 580
end type

type cb_retrieve from so_commandbutton within w_smt_plan_feeder_running_status_popup
integer x = 69
integer y = 260
integer width = 366
integer height = 156
integer taborder = 60
boolean bringtotop = true
integer weight = 400
string text = "Retrieve"
end type

event clicked;dw_1.Retrieve( '%' , gvi_organization_id )
dw_1.SetFocus()

end event

type rb_all from so_radiobutton within w_smt_plan_feeder_running_status_popup
integer x = 2167
integer y = 272
integer width = 663
integer height = 84
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_2.setfilter( '')
dw_2.filter( )
end event

type rb_gt from so_radiobutton within w_smt_plan_feeder_running_status_popup
integer x = 2167
integer y = 348
integer width = 663
integer height = 84
boolean bringtotop = true
integer weight = 700
string text = "Wait"
end type

event clicked;call super::clicked;dw_2.setfilter( "feedingyn='N'")
dw_2.filter( )
end event

type sle_2 from so_singlelineedit within w_smt_plan_feeder_running_status_popup
integer x = 2802
integer y = 344
integer taborder = 60
boolean bringtotop = true
long backcolor = 16777215
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX9$$15c82cb860d52000eccefcb712ac0d000a00$$ENDHEX$$//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_2.SETFILTER('')
dw_2.FILTER()

LVS_COLUMN = 'item_code'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_2.SETFILTER('')
    dw_2.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+UPPER(this.text)+'%'
END IF

dw_2.SETFILTER( " item_code LIKE "+ STRING(LVS_VALUE))
dw_2.FILTER()
F_MSG_MDI_HELP( STRING( dw_2.ROWCOUNT() ) + " Found" )


end event

type st_18 from so_statictext within w_smt_plan_feeder_running_status_popup
integer x = 2802
integer y = 264
integer height = 76
boolean bringtotop = true
integer textsize = -10
long textcolor = 16711680
string text = "Item Code"
end type

type sle_1 from so_singlelineedit within w_smt_plan_feeder_running_status_popup
integer x = 3310
integer y = 344
integer taborder = 70
boolean bringtotop = true
long backcolor = 16777215
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX9$$15c82cb860d52000eccefcb712ac0d000a00$$ENDHEX$$//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_2.SETFILTER('')
dw_2.FILTER()

LVS_COLUMN = 'lot_no'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_2.SETFILTER('')
    dw_2.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+UPPER(this.text)+'%'
END IF

dw_2.SETFILTER( " item_code LIKE "+ STRING(LVS_VALUE))
dw_2.FILTER()
F_MSG_MDI_HELP( STRING( dw_2.ROWCOUNT() ) + " Found" )


end event

type st_1 from so_statictext within w_smt_plan_feeder_running_status_popup
integer x = 3310
integer y = 264
integer height = 76
boolean bringtotop = true
integer textsize = -10
long textcolor = 16711680
string text = "Lot No"
end type

type gb_2 from so_groupbox within w_smt_plan_feeder_running_status_popup
boolean visible = false
integer x = 2107
integer y = 192
integer width = 1829
integer height = 272
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

type gb_1 from so_groupbox within w_smt_plan_feeder_running_status_popup
boolean visible = false
integer x = 18
integer y = 188
integer width = 795
integer height = 272
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


HA$PBExportHeader$w_qc_inspect_4_gmes_popup.srw
forward
global type w_qc_inspect_4_gmes_popup from w_popup_root
end type
type gb_3 from so_groupbox within w_qc_inspect_4_gmes_popup
end type
type gb_2 from so_groupbox within w_qc_inspect_4_gmes_popup
end type
type cb_retrieve from so_commandbutton within w_qc_inspect_4_gmes_popup
end type
type cb_select from so_commandbutton within w_qc_inspect_4_gmes_popup
end type
type st_1 from so_statictext within w_qc_inspect_4_gmes_popup
end type
type sle_pid from so_singlelineedit within w_qc_inspect_4_gmes_popup
end type
end forward

shared variables

end variables

global type w_qc_inspect_4_gmes_popup from w_popup_root
integer width = 3355
integer height = 2280
string title = "Machine Master Popup"
gb_3 gb_3
gb_2 gb_2
cb_retrieve cb_retrieve
cb_select cb_select
st_1 st_1
sle_pid sle_pid
end type
global w_qc_inspect_4_gmes_popup w_qc_inspect_4_gmes_popup

on w_qc_inspect_4_gmes_popup.create
int iCurrent
call super::create
this.gb_3=create gb_3
this.gb_2=create gb_2
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_1=create st_1
this.sle_pid=create sle_pid
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_3
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.cb_retrieve
this.Control[iCurrent+4]=this.cb_select
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.sle_pid
end on

on w_qc_inspect_4_gmes_popup.destroy
call super::destroy
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_1)
destroy(this.sle_pid)
end on

event open;call super::open;//===============================
//
//===============================
dw_1.settransobject(sqlca)

sle_pid.text = message.stringparm
cb_retrieve.triggerevent(CLICKED!)


selected_data_window = dw_1
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

event activate;call super::activate;//===============================
//
//===============================
IVS_RESIZE_TYPE = 'DEFAULT'
IVS_MOUSEMOVE_YN = 'N'

end event

type p_title from w_popup_root`p_title within w_qc_inspect_4_gmes_popup
integer width = 3337
end type

type cb_sort from w_popup_root`cb_sort within w_qc_inspect_4_gmes_popup
boolean visible = true
integer x = 2190
integer y = 308
integer height = 160
end type

type cb_close from w_popup_root`cb_close within w_qc_inspect_4_gmes_popup
boolean visible = true
integer x = 3035
integer y = 308
integer height = 160
end type

event cb_close::clicked;call super::clicked;Gst_return.gvb_return = FALSE
end event

type st_msg from w_popup_root`st_msg within w_qc_inspect_4_gmes_popup
boolean visible = true
integer y = 544
integer width = 3337
end type

type dw_1 from w_popup_root`dw_1 within w_qc_inspect_4_gmes_popup
boolean visible = true
integer y = 644
integer width = 3337
integer height = 1552
boolean titlebar = true
string title = "PID Tracking"
string dataobject = "d_qc_pid_tracking_gmes_popup"
boolean maxbox = true
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_qc_inspect_4_gmes_popup
boolean visible = true
integer y = 644
integer width = 503
integer height = 396
boolean titlebar = true
boolean maxbox = true
end type

type dw_3 from w_popup_root`dw_3 within w_qc_inspect_4_gmes_popup
boolean visible = true
integer y = 644
integer width = 503
integer height = 396
boolean titlebar = true
boolean maxbox = true
end type

type gb_3 from so_groupbox within w_qc_inspect_4_gmes_popup
integer x = 2149
integer y = 200
integer width = 1189
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_qc_inspect_4_gmes_popup
integer x = 5
integer y = 204
integer width = 1079
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type cb_retrieve from so_commandbutton within w_qc_inspect_4_gmes_popup
integer x = 2464
integer y = 308
integer width = 274
integer height = 160
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(   sle_pid.text )

end event

type cb_select from so_commandbutton within w_qc_inspect_4_gmes_popup
integer x = 2734
integer y = 308
integer width = 274
integer height = 160
integer taborder = 80
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;if dw_1.getrow() < 1 then 
	gst_return.gvb_return = false
	return -1 
end if 

gst_return.gvb_return = true 
message.stringparm = dw_1.object.model[dw_1.getrow()]

closewithreturn (parent , message.stringparm )



end event

type st_1 from so_statictext within w_qc_inspect_4_gmes_popup
integer x = 27
integer y = 308
integer width = 1019
boolean bringtotop = true
integer weight = 700
string text = "PID"
end type

type sle_pid from so_singlelineedit within w_qc_inspect_4_gmes_popup
integer x = 27
integer y = 388
integer width = 1019
integer taborder = 30
boolean bringtotop = true
end type


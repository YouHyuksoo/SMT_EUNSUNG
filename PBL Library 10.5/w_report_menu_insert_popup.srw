HA$PBExportHeader$w_report_menu_insert_popup.srw
$PBExportComments$$$HEX7$$38bb90c7b8d3d1c908c7c4b3b0c6$$ENDHEX$$
forward
global type w_report_menu_insert_popup from w_popup_root
end type
type cb_2 from so_commandbutton within w_report_menu_insert_popup
end type
type cb_1 from so_commandbutton within w_report_menu_insert_popup
end type
type cb_3 from so_commandbutton within w_report_menu_insert_popup
end type
type cb_4 from so_commandbutton within w_report_menu_insert_popup
end type
type cb_5 from so_commandbutton within w_report_menu_insert_popup
end type
type sle_datawindow_name from so_singlelineedit within w_report_menu_insert_popup
end type
type st_1 from so_statictext within w_report_menu_insert_popup
end type
end forward

global type w_report_menu_insert_popup from w_popup_root
integer x = 827
integer y = 576
integer width = 3694
integer height = 2280
string title = "Report Menu Insert"
long backcolor = 79741120
cb_2 cb_2
cb_1 cb_1
cb_3 cb_3
cb_4 cb_4
cb_5 cb_5
sle_datawindow_name sle_datawindow_name
st_1 st_1
end type
global w_report_menu_insert_popup w_report_menu_insert_popup

type variables
string is_path
end variables

on w_report_menu_insert_popup.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_5=create cb_5
this.sle_datawindow_name=create sle_datawindow_name
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.cb_4
this.Control[iCurrent+5]=this.cb_5
this.Control[iCurrent+6]=this.sle_datawindow_name
this.Control[iCurrent+7]=this.st_1
end on

on w_report_menu_insert_popup.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.sle_datawindow_name)
destroy(this.st_1)
end on

event open;call super::open;Gst_return.gvb_return = false
sle_datawindow_name.text = message.stringparm
end event

type p_title from w_popup_root`p_title within w_report_menu_insert_popup
integer width = 3680
end type

type cb_sort from w_popup_root`cb_sort within w_report_menu_insert_popup
integer x = 0
integer y = 2300
end type

type cb_close from w_popup_root`cb_close within w_report_menu_insert_popup
integer x = 0
integer y = 2404
end type

type st_msg from w_popup_root`st_msg within w_report_menu_insert_popup
boolean visible = true
integer y = 204
integer width = 3680
end type

type dw_1 from w_popup_root`dw_1 within w_report_menu_insert_popup
boolean visible = true
integer y = 524
integer width = 3680
integer height = 1672
boolean titlebar = true
string dataobject = "d_report_menu_insert_lst_tree"
end type

event dw_1::rbuttondown;call super::rbuttondown;if row < 1 then return

if dwo.name = 'datawindow_name' then 
else
	return
end if 

open(w_datawindow_source_popup )

if Gst_return.Gvb_return = true then 
	
	this.object.datawindow_name[row] = message.stringparm
else
end if 

end event

type dw_2 from w_popup_root`dw_2 within w_report_menu_insert_popup
integer y = 300
end type

type dw_3 from w_popup_root`dw_3 within w_report_menu_insert_popup
end type

type cb_2 from so_commandbutton within w_report_menu_insert_popup
integer x = 3291
integer y = 364
integer width = 375
integer height = 104
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string text = "Close"
end type

event clicked;call super::clicked;close(parent)
end event

type cb_1 from so_commandbutton within w_report_menu_insert_popup
integer x = 1646
integer y = 364
integer width = 375
integer height = 104
integer taborder = 50
boolean bringtotop = true
integer weight = 400
string text = "Insert"
end type

event clicked;call super::clicked;int row
row = dw_1.insertrow(dw_1.getrow())
f_set_security_row( dw_1 , row , 'ALL')
dw_1.groupcalc( )

end event

type cb_3 from so_commandbutton within w_report_menu_insert_popup
integer x = 2043
integer y = 364
integer width = 375
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer weight = 400
string text = "Delete"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 
dw_1.deleterow( dw_1.getrow() )
dw_1.groupcalc( )
end event

type cb_4 from so_commandbutton within w_report_menu_insert_popup
integer x = 2441
integer y = 364
integer width = 375
integer height = 104
integer taborder = 70
boolean bringtotop = true
integer weight = 400
string text = "Save"
end type

event clicked;call super::clicked;if dw_1.update( ) < 0 then 
	rollback ;
else
	Gst_return.gvb_return = true
	commit ;
	f_msgbox(170)
end if 

dw_1.groupcalc( )
end event

type cb_5 from so_commandbutton within w_report_menu_insert_popup
integer x = 1248
integer y = 364
integer width = 375
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer weight = 400
string text = "Retrieve"
end type

event clicked;call super::clicked;dw_1.retrieve( sle_datawindow_name.text+'%' , gvi_organization_id )
dw_1.groupcalc( )
end event

type sle_datawindow_name from so_singlelineedit within w_report_menu_insert_popup
integer x = 41
integer y = 404
integer width = 969
integer taborder = 120
boolean bringtotop = true
end type

type st_1 from so_statictext within w_report_menu_insert_popup
integer x = 41
integer y = 324
integer width = 969
integer height = 68
boolean bringtotop = true
long backcolor = 67108864
string text = "Datawindow Name"
end type


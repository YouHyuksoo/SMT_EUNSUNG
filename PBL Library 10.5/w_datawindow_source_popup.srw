HA$PBExportHeader$w_datawindow_source_popup.srw
$PBExportComments$$$HEX7$$38bb90c7b8d3d1c908c7c4b3b0c6$$ENDHEX$$
forward
global type w_datawindow_source_popup from w_popup_root
end type
type cb_2 from so_commandbutton within w_datawindow_source_popup
end type
type cb_1 from so_commandbutton within w_datawindow_source_popup
end type
type cb_3 from so_commandbutton within w_datawindow_source_popup
end type
type cb_4 from so_commandbutton within w_datawindow_source_popup
end type
type cb_5 from so_commandbutton within w_datawindow_source_popup
end type
type cb_select from so_commandbutton within w_datawindow_source_popup
end type
end forward

global type w_datawindow_source_popup from w_popup_root
integer x = 827
integer y = 576
integer width = 3035
integer height = 1856
string title = "Report Datawindow Source"
long backcolor = 79741120
cb_2 cb_2
cb_1 cb_1
cb_3 cb_3
cb_4 cb_4
cb_5 cb_5
cb_select cb_select
end type
global w_datawindow_source_popup w_datawindow_source_popup

type variables
string is_path
end variables

on w_datawindow_source_popup.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_5=create cb_5
this.cb_select=create cb_select
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.cb_4
this.Control[iCurrent+5]=this.cb_5
this.Control[iCurrent+6]=this.cb_select
end on

on w_datawindow_source_popup.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.cb_select)
end on

event open;call super::open;Gst_return.gvb_return = false

end event

type p_title from w_popup_root`p_title within w_datawindow_source_popup
integer width = 3017
end type

type cb_sort from w_popup_root`cb_sort within w_datawindow_source_popup
integer x = 0
integer y = 2300
end type

type cb_close from w_popup_root`cb_close within w_datawindow_source_popup
integer x = 0
integer y = 2404
end type

type st_msg from w_popup_root`st_msg within w_datawindow_source_popup
boolean visible = true
integer y = 204
integer width = 3017
end type

type dw_1 from w_popup_root`dw_1 within w_datawindow_source_popup
boolean visible = true
integer y = 436
integer width = 3017
integer height = 1336
boolean titlebar = true
string dataobject = "d_datawindow_source_lst"
end type

event dw_1::doubleclicked;call super::doubleclicked;cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_datawindow_source_popup
integer y = 300
end type

type dw_3 from w_popup_root`dw_3 within w_datawindow_source_popup
end type

type cb_2 from so_commandbutton within w_datawindow_source_popup
integer x = 2624
integer y = 312
integer width = 370
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string text = "Close"
end type

event clicked;call super::clicked;close(parent)
end event

type cb_1 from so_commandbutton within w_datawindow_source_popup
integer x = 416
integer y = 316
integer width = 370
integer height = 96
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

type cb_3 from so_commandbutton within w_datawindow_source_popup
integer x = 791
integer y = 316
integer width = 370
integer height = 96
integer taborder = 60
boolean bringtotop = true
integer weight = 400
string text = "Delete"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 
dw_1.deleterow( dw_1.getrow() )
dw_1.groupcalc( )
end event

type cb_4 from so_commandbutton within w_datawindow_source_popup
integer x = 1170
integer y = 316
integer width = 370
integer height = 96
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
end if 

end event

type cb_5 from so_commandbutton within w_datawindow_source_popup
integer x = 46
integer y = 316
integer width = 370
integer height = 96
integer taborder = 60
boolean bringtotop = true
integer weight = 400
string text = "Retrieve"
end type

event clicked;call super::clicked;dw_1.retrieve( '%' , gvi_organization_id )
dw_1.groupcalc( )
end event

type cb_select from so_commandbutton within w_datawindow_source_popup
integer x = 1545
integer y = 316
integer width = 370
integer height = 96
integer taborder = 80
boolean bringtotop = true
integer weight = 400
string text = "Select"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return

Message.stringparm= dw_1.object.datawindow_name[dw_1.getrow()]
Gst_return.Gvb_return = true

Closewithreturn( parent  , Message.stringparm)
end event


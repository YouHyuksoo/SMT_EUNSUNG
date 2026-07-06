HA$PBExportHeader$w_msgbox_dual.srw
$PBExportComments$$$HEX7$$dcc200d0a4c220c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_msgbox_dual from w_popup_root
end type
type cb_save from so_commandbutton within w_msgbox_dual
end type
end forward

global type w_msgbox_dual from w_popup_root
integer width = 3675
integer height = 2352
cb_save cb_save
end type
global w_msgbox_dual w_msgbox_dual

on w_msgbox_dual.create
int iCurrent
call super::create
this.cb_save=create cb_save
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_save
end on

on w_msgbox_dual.destroy
call super::destroy
destroy(this.cb_save)
end on

event open;call super::open;dw_1.settransobject(sqlca)
gst_return.gvb_return = False


end event

event activate;call super::activate;IVS_RESIZE_TYPE = 'NORMAL'
end event

event ue_post_open;call super::ue_post_open;int row
dw_1.retrieve(message.stringparm)
//
//if dw_1.getrow() < 1 then 
//	
//	row = dw_1.insertrow(0)
//	dw_1.scrolltorow(row)
//	f_set_security_row(dw_1 , row , 'ALL')
//	dw_1.object.origin_msg[row] = message.stringparm
//	cb_save.triggerevent( clicked!)
//	
//end if 
end event

type p_title from w_popup_root`p_title within w_msgbox_dual
integer width = 3671
end type

type cb_sort from w_popup_root`cb_sort within w_msgbox_dual
integer x = 23
integer y = 32
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_msgbox_dual
boolean visible = true
integer x = 3150
integer y = 288
integer width = 517
integer height = 160
integer taborder = 0
end type

type st_msg from w_popup_root`st_msg within w_msgbox_dual
boolean visible = true
integer y = 188
integer width = 3680
end type

type dw_1 from w_popup_root`dw_1 within w_msgbox_dual
boolean visible = true
integer x = 5
integer y = 460
integer width = 3662
integer height = 1788
integer taborder = 0
string dataobject = "d_dual_message_direct"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type dw_2 from w_popup_root`dw_2 within w_msgbox_dual
boolean visible = true
integer y = 484
integer width = 3131
integer height = 1236
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_msgbox_dual
integer y = 616
end type

type cb_save from so_commandbutton within w_msgbox_dual
integer x = 2610
integer y = 292
integer height = 156
integer taborder = 120
boolean bringtotop = true
string text = "Save"
end type

event clicked;call super::clicked;dw_1.update()
st_msg.text = "OK"
commit ;
end event


HA$PBExportHeader$w_des_work_no_popup.srw
$PBExportComments$$$HEX6$$91c7c5c588bc38d61dd3c5c5$$ENDHEX$$
forward
global type w_des_work_no_popup from w_popup_root
end type
type cb_retrieve from commandbutton within w_des_work_no_popup
end type
type cb_select from commandbutton within w_des_work_no_popup
end type
type uo_user from uo_user_id within w_des_work_no_popup
end type
type gb_1 from so_groupbox within w_des_work_no_popup
end type
type gb_2 from so_groupbox within w_des_work_no_popup
end type
end forward

global type w_des_work_no_popup from w_popup_root
integer width = 2674
integer height = 1952
string title = "New BOM Work No Popup"
cb_retrieve cb_retrieve
cb_select cb_select
uo_user uo_user
gb_1 gb_1
gb_2 gb_2
end type
global w_des_work_no_popup w_des_work_no_popup

on w_des_work_no_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.uo_user=create uo_user
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.uo_user
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.gb_2
end on

on w_des_work_no_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.uo_user)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)


end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_des_work_no_popup
integer width = 2656
end type

type cb_sort from w_popup_root`cb_sort within w_des_work_no_popup
boolean visible = true
integer x = 1509
integer y = 304
end type

type cb_close from w_popup_root`cb_close within w_des_work_no_popup
boolean visible = true
integer x = 2341
integer y = 304
end type

type st_msg from w_popup_root`st_msg within w_des_work_no_popup
boolean visible = true
integer y = 492
integer width = 2656
end type

type dw_1 from w_popup_root`dw_1 within w_des_work_no_popup
boolean visible = true
integer y = 588
integer width = 2656
integer height = 1268
string dataobject = "d_des_work_no_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

type dw_2 from w_popup_root`dw_2 within w_des_work_no_popup
boolean visible = true
integer y = 588
end type

type dw_3 from w_popup_root`dw_3 within w_des_work_no_popup
integer y = 596
end type

type cb_retrieve from commandbutton within w_des_work_no_popup
integer x = 1783
integer y = 304
integer width = 274
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(UO_USER.GETID()+'%' , GVI_ORGANIZATION_ID)
end event

type cb_select from commandbutton within w_des_work_no_popup
integer x = 2062
integer y = 304
integer width = 274
integer height = 100
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select"
boolean default = true
end type

event clicked;IF DW_1.GETROW() < 1 THEN RETURN 
MESSAGE.DOUBLEPARM = DW_1.GETITEMNUMBER( DW_1.GETROW() , 'bom_work_no')
CLOSEWITHRETURN(PARENT , MESSAGE.DOUBLEPARM )
end event

type uo_user from uo_user_id within w_des_work_no_popup
integer x = 178
integer y = 276
integer taborder = 30
boolean bringtotop = true
end type

on uo_user.destroy
call uo_user_id::destroy
end on

type gb_1 from so_groupbox within w_des_work_no_popup
integer x = 1445
integer y = 204
integer width = 1202
integer height = 284
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_des_work_no_popup
integer y = 204
integer width = 1166
integer height = 284
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


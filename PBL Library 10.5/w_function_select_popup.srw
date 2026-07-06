HA$PBExportHeader$w_function_select_popup.srw
$PBExportComments$$$HEX7$$dcc200d0a4c220c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_function_select_popup from w_popup_root
end type
type cb_retrieve from commandbutton within w_function_select_popup
end type
type cb_select from commandbutton within w_function_select_popup
end type
type gb_1 from so_groupbox within w_function_select_popup
end type
end forward

global type w_function_select_popup from w_popup_root
integer width = 3141
integer height = 1936
cb_retrieve cb_retrieve
cb_select cb_select
gb_1 gb_1
end type
global w_function_select_popup w_function_select_popup

on w_function_select_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.gb_1
end on

on w_function_select_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.gb_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
gst_return.gvb_return = False
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)



end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

event activate;call super::activate;IVS_RESIZE_TYPE = 'NORMAL'
end event

type p_title from w_popup_root`p_title within w_function_select_popup
integer width = 3131
end type

type cb_sort from w_popup_root`cb_sort within w_function_select_popup
boolean visible = true
integer x = 41
integer y = 312
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_function_select_popup
boolean visible = true
integer x = 873
integer y = 312
integer taborder = 0
end type

type st_msg from w_popup_root`st_msg within w_function_select_popup
boolean visible = true
integer y = 492
integer width = 3131
end type

type dw_1 from w_popup_root`dw_1 within w_function_select_popup
boolean visible = true
integer y = 588
integer width = 3131
integer height = 1236
integer taborder = 0
string dataobject = "d_user_function_lst_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

type dw_2 from w_popup_root`dw_2 within w_function_select_popup
boolean visible = true
integer y = 588
integer width = 3131
integer height = 1236
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_function_select_popup
integer y = 616
end type

type cb_retrieve from commandbutton within w_function_select_popup
integer x = 315
integer y = 312
integer width = 274
integer height = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE( )
end event

type cb_select from commandbutton within w_function_select_popup
integer x = 594
integer y = 312
integer width = 274
integer height = 100
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
gst_return.gvb_return = true
MESSAGE.STRINGPARM		=	DW_1.GETITEMSTRING( DW_1.GETROW() , 'object_name')+"( )"
CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type gb_1 from so_groupbox within w_function_select_popup
integer x = 14
integer y = 208
integer width = 1170
integer height = 272
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


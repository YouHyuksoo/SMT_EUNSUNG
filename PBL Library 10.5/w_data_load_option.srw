HA$PBExportHeader$w_data_load_option.srw
forward
global type w_data_load_option from window
end type
type cb_5 from so_commandbutton within w_data_load_option
end type
type cb_4 from so_commandbutton within w_data_load_option
end type
type cb_3 from so_commandbutton within w_data_load_option
end type
type cb_2 from so_commandbutton within w_data_load_option
end type
type cb_1 from so_commandbutton within w_data_load_option
end type
type dw_1 from datawindow within w_data_load_option
end type
end forward

global type w_data_load_option from window
integer width = 2400
integer height = 1408
boolean titlebar = true
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "OleGenReg!"
boolean center = true
event ue_post_open ( )
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
dw_1 dw_1
end type
global w_data_load_option w_data_load_option

type variables
uo_item_code uo_item
Boolean ib_getfocus = false
end variables

forward prototypes
public function integer of_search (string as_item_code)
end prototypes

event ue_post_open();f_set_column_dddw(dw_1)
f_dual_lang_change_text(this)
dw_1.reset()
dw_1.retrieve(  gvi_organization_id )

end event

public function integer of_search (string as_item_code);return 1
end function

on w_data_load_option.create
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.cb_5,&
this.cb_4,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.dw_1}
end on

on w_data_load_option.destroy
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_1)
end on

event open;dw_1.settransobject( sqlca)
this.setredraw( false)
f_set_layered_window( handle(this) , 85 )
postevent('ue_post_open')
end event

event key;if Key = KeyEscape! then 
	close(this)

end if
end event

type cb_5 from so_commandbutton within w_data_load_option
integer x = 1746
integer y = 32
integer width = 352
integer height = 140
integer taborder = 30
string text = "Close"
end type

event clicked;call super::clicked;close(parent)
end event

type cb_4 from so_commandbutton within w_data_load_option
integer x = 297
integer y = 32
integer width = 352
integer height = 140
integer taborder = 10
string text = "Retrieve"
end type

event clicked;call super::clicked;dw_1.retrieve(gvi_organization_id)
end event

type cb_3 from so_commandbutton within w_data_load_option
integer x = 667
integer y = 32
integer width = 352
integer height = 140
integer taborder = 30
string text = "Insert"
end type

event clicked;call super::clicked;int row 

row = dw_1.insertrow(0)
dw_1.scrolltorow(row)
f_set_security_row( dw_1 , row , 'ALL') 


end event

type cb_2 from so_commandbutton within w_data_load_option
integer x = 1390
integer y = 32
integer width = 352
integer height = 140
integer taborder = 20
string text = "Update"
end type

event clicked;call super::clicked;if dw_1.update() < 0 then
	rollback;
else
	commit;
	f_msgbox(170)
end if 
end event

type cb_1 from so_commandbutton within w_data_load_option
integer x = 1024
integer y = 32
integer width = 352
integer height = 140
integer taborder = 10
string text = "Dalete"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return
dw_1.deleterow(dw_1.getrow())
end event

type dw_1 from datawindow within w_data_load_option
integer y = 224
integer width = 2386
integer height = 1100
string title = "none"
string dataobject = "d_data_load_option_lst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event doubleclicked;string lvs_item_code

if row < 1 then
	return
else

	lvs_item_code = string(this.object.item_code[row])
	CLOSEwithreturn(w_item_search_flat ,lvs_item_code )

end if 
end event

event rowfocuschanged;This.SelectRow(0, false)
This.SelectRow(currentrow, true)
end event


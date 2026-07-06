HA$PBExportHeader$w_window_popup.srw
$PBExportComments$(Supplier Query)-$$HEX5$$70ac98b798cc70c88cd6$$ENDHEX$$
forward
global type w_window_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_window_popup
end type
type cb_select from so_commandbutton within w_window_popup
end type
type st_14 from so_statictext within w_window_popup
end type
type sle_window_name from so_singlelineedit within w_window_popup
end type
type gb_2 from so_groupbox within w_window_popup
end type
type gb_1 from so_groupbox within w_window_popup
end type
end forward

global type w_window_popup from w_popup_root
integer width = 3799
integer height = 2428
cb_retrieve cb_retrieve
cb_select cb_select
st_14 st_14
sle_window_name sle_window_name
gb_2 gb_2
gb_1 gb_1
end type
global w_window_popup w_window_popup

type variables

end variables

on w_window_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_14=create st_14
this.sle_window_name=create sle_window_name
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_14
this.Control[iCurrent+4]=this.sle_window_name
this.Control[iCurrent+5]=this.gb_2
this.Control[iCurrent+6]=this.gb_1
end on

on w_window_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_14)
destroy(this.sle_window_name)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
SLE_WINDOW_NAME.SETFOCUS()
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_window_popup
integer width = 3785
end type

type cb_sort from w_popup_root`cb_sort within w_window_popup
boolean visible = true
integer x = 1426
integer y = 320
integer width = 270
integer height = 136
end type

type cb_close from w_popup_root`cb_close within w_window_popup
boolean visible = true
integer x = 2263
integer y = 320
integer width = 270
integer height = 136
end type

type st_msg from w_popup_root`st_msg within w_window_popup
boolean visible = true
integer y = 548
integer width = 3785
long backcolor = 134217731
long bordercolor = 134217731
end type

type dw_1 from w_popup_root`dw_1 within w_window_popup
boolean visible = true
integer y = 644
integer width = 3785
integer height = 1708
string dataobject = "d_window_lst_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_window_popup
boolean visible = true
integer x = 9
integer y = 768
end type

type dw_3 from w_popup_root`dw_3 within w_window_popup
end type

type cb_retrieve from so_commandbutton within w_window_popup
integer x = 1705
integer y = 320
integer width = 270
integer height = 136
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE('%'+SLE_WINDOW_NAME.TEXT+'%' , GVS_LANGUAGE , GVI_ORGANIZATION_ID )
end event

type cb_select from so_commandbutton within w_window_popup
integer x = 1984
integer y = 320
integer width = 270
integer height = 136
integer taborder = 80
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;IF DW_1.GETROW() = 0  THEN 
	RETURN -1
END IF
MESSAGE.STRINGPARM = DW_1.GETITEMSTRING( DW_1.GETROW() , 'window_name')
Gst_return.Gvs_return[1] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'window_description')
CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type st_14 from so_statictext within w_window_popup
integer x = 142
integer y = 308
integer width = 983
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Window Name"
end type

type sle_window_name from so_singlelineedit within w_window_popup
integer x = 142
integer y = 388
integer width = 983
integer taborder = 30
boolean bringtotop = true
end type

type gb_2 from so_groupbox within w_window_popup
integer y = 204
integer width = 1280
integer height = 336
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_window_popup
integer x = 1294
integer y = 204
integer width = 1367
integer height = 336
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


HA$PBExportHeader$w_user_4_bring_in_out_confirm_popup.srw
$PBExportComments$(Supplier Query)-$$HEX5$$70ac98b798cc70c88cd6$$ENDHEX$$
forward
global type w_user_4_bring_in_out_confirm_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_user_4_bring_in_out_confirm_popup
end type
type cb_select from so_commandbutton within w_user_4_bring_in_out_confirm_popup
end type
type st_14 from so_statictext within w_user_4_bring_in_out_confirm_popup
end type
type sle_user_name from so_singlelineedit within w_user_4_bring_in_out_confirm_popup
end type
type gb_1 from so_groupbox within w_user_4_bring_in_out_confirm_popup
end type
type gb_2 from so_groupbox within w_user_4_bring_in_out_confirm_popup
end type
end forward

global type w_user_4_bring_in_out_confirm_popup from w_popup_root
integer width = 3305
string title = "Bringout Confirmer List"
cb_retrieve cb_retrieve
cb_select cb_select
st_14 st_14
sle_user_name sle_user_name
gb_1 gb_1
gb_2 gb_2
end type
global w_user_4_bring_in_out_confirm_popup w_user_4_bring_in_out_confirm_popup

on w_user_4_bring_in_out_confirm_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_14=create st_14
this.sle_user_name=create sle_user_name
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_14
this.Control[iCurrent+4]=this.sle_user_name
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.gb_2
end on

on w_user_4_bring_in_out_confirm_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_14)
destroy(this.sle_user_name)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
SLE_USER_NAME.SETFOCUS()
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_user_4_bring_in_out_confirm_popup
integer width = 3296
end type

type cb_sort from w_popup_root`cb_sort within w_user_4_bring_in_out_confirm_popup
boolean visible = true
integer x = 2153
integer y = 268
integer height = 160
end type

type cb_close from w_popup_root`cb_close within w_user_4_bring_in_out_confirm_popup
boolean visible = true
integer x = 2990
integer y = 268
integer height = 160
end type

type st_msg from w_popup_root`st_msg within w_user_4_bring_in_out_confirm_popup
boolean visible = true
integer x = 5
integer y = 476
integer width = 3296
end type

type dw_1 from w_popup_root`dw_1 within w_user_4_bring_in_out_confirm_popup
boolean visible = true
integer x = 5
integer y = 572
integer width = 3296
integer height = 1488
string dataobject = "d_user_4_bring_in_out_confirm_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_user_4_bring_in_out_confirm_popup
integer y = 580
end type

type dw_3 from w_popup_root`dw_3 within w_user_4_bring_in_out_confirm_popup
integer y = 572
end type

type cb_retrieve from so_commandbutton within w_user_4_bring_in_out_confirm_popup
integer x = 2432
integer y = 268
integer width = 274
integer height = 160
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE('%'+SLE_USER_NAME.TEXT+'%' , GVI_ORGANIZATION_ID )
end event

type cb_select from so_commandbutton within w_user_4_bring_in_out_confirm_popup
integer x = 2711
integer y = 268
integer width = 274
integer height = 160
integer taborder = 80
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;string lvs_auto_confirm 
IF DW_1.GETROW() = 0  THEN 
	RETURN -1
END IF
MESSAGE.STRINGPARM = DW_1.GETITEMSTRING( DW_1.GETROW() , 'user_id')

lvs_auto_confirm = string(dw_1.object.bring_in_out_auto_confirm[dw_1.getrow( )] )

if GVS_BRING_IN_OUT_AUTO_SELECT = 'Y' then 
	Gst_return.gvs_return[1] = lvs_auto_confirm
else
	Gst_return.gvs_return[1] =  'N'	
end if 

CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type st_14 from so_statictext within w_user_4_bring_in_out_confirm_popup
integer x = 50
integer y = 264
integer width = 640
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "User Name"
end type

type sle_user_name from so_singlelineedit within w_user_4_bring_in_out_confirm_popup
integer x = 50
integer y = 348
integer width = 640
integer taborder = 30
boolean bringtotop = true
end type

type gb_1 from so_groupbox within w_user_4_bring_in_out_confirm_popup
integer x = 2117
integer y = 192
integer width = 1175
integer height = 272
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_user_4_bring_in_out_confirm_popup
integer y = 192
integer width = 1280
integer height = 272
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


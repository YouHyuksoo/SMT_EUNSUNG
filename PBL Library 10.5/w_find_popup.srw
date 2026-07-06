HA$PBExportHeader$w_find_popup.srw
$PBExportComments$$$HEX5$$3ecc30ae08c7c4b3b0c6$$ENDHEX$$
forward
global type w_find_popup from w_none_dw_popup_root
end type
type rb_2 from so_radiobutton within w_find_popup
end type
type rb_1 from so_radiobutton within w_find_popup
end type
type st_1 from so_statictext within w_find_popup
end type
type sle_find from so_singlelineedit within w_find_popup
end type
type cb_1 from so_commandbutton within w_find_popup
end type
type gb_1 from so_groupbox within w_find_popup
end type
end forward

global type w_find_popup from w_none_dw_popup_root
integer x = 800
integer y = 876
integer width = 2016
integer height = 656
string title = "Search Tool"
windowtype windowtype = popup!
rb_2 rb_2
rb_1 rb_1
st_1 st_1
sle_find sle_find
cb_1 cb_1
gb_1 gb_1
end type
global w_find_popup w_find_popup

on w_find_popup.create
int iCurrent
call super::create
this.rb_2=create rb_2
this.rb_1=create rb_1
this.st_1=create st_1
this.sle_find=create sle_find
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_find
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.gb_1
end on

on w_find_popup.destroy
call super::destroy
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.st_1)
destroy(this.sle_find)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event key;IF key = keyescape! THEN 
	CB_CLOSE.TRIGGEREVENT('CLICKED')
END IF
end event

type p_title from w_none_dw_popup_root`p_title within w_find_popup
integer width = 1993
end type

type cb_close from w_none_dw_popup_root`cb_close within w_find_popup
integer x = 1682
integer y = 424
end type

type st_msg from w_none_dw_popup_root`st_msg within w_find_popup
integer y = 600
end type

type rb_2 from so_radiobutton within w_find_popup
integer x = 448
integer y = 444
integer width = 320
integer height = 72
integer weight = 700
string text = "Under"
end type

type rb_1 from so_radiobutton within w_find_popup
integer x = 73
integer y = 444
integer width = 265
integer height = 72
integer weight = 700
string text = "All"
boolean checked = true
end type

type st_1 from so_statictext within w_find_popup
integer x = 41
integer y = 248
integer width = 384
integer height = 68
integer weight = 700
boolean enabled = false
string text = "Search Word :"
end type

type sle_find from so_singlelineedit within w_find_popup
integer x = 439
integer y = 224
integer width = 1550
integer height = 92
integer taborder = 10
integer weight = 700
boolean autohscroll = false
end type

type cb_1 from so_commandbutton within w_find_popup
integer x = 1413
integer y = 420
integer width = 270
integer height = 108
integer taborder = 20
string text = "Search"
boolean default = true
end type

event clicked;window activesheet
string mtext
activesheet = w_main_frame.GetActiveSheet( )
IF IsValid(activesheet) THEN
	Gvs_Ue_data_control = 'FIND'
	activesheet.TRIGGEREVENT('UE_DATA_CONTROL')
ELSE 

END IF
end event

type gb_1 from so_groupbox within w_find_popup
integer x = 14
integer y = 372
integer width = 1970
integer height = 172
integer taborder = 21
integer weight = 700
string text = "Execute Condition"
end type


HA$PBExportHeader$w_basecode_select_popup.srw
$PBExportComments$$$HEX8$$30ae00c954cfdcb420c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_basecode_select_popup from w_popup_root
end type
type cb_retrieve from commandbutton within w_basecode_select_popup
end type
type cb_select from commandbutton within w_basecode_select_popup
end type
type sle_code_type from singlelineedit within w_basecode_select_popup
end type
type st_1 from statictext within w_basecode_select_popup
end type
type sle_code_mean_eng from so_singlelineedit within w_basecode_select_popup
end type
type st_3 from so_statictext within w_basecode_select_popup
end type
type gb_1 from so_groupbox within w_basecode_select_popup
end type
type gb_2 from so_groupbox within w_basecode_select_popup
end type
end forward

global type w_basecode_select_popup from w_popup_root
integer width = 2185
integer height = 1660
cb_retrieve cb_retrieve
cb_select cb_select
sle_code_type sle_code_type
st_1 st_1
sle_code_mean_eng sle_code_mean_eng
st_3 st_3
gb_1 gb_1
gb_2 gb_2
end type
global w_basecode_select_popup w_basecode_select_popup

on w_basecode_select_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.sle_code_type=create sle_code_type
this.st_1=create st_1
this.sle_code_mean_eng=create sle_code_mean_eng
this.st_3=create st_3
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.sle_code_type
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_code_mean_eng
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_basecode_select_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.sle_code_type)
destroy(this.st_1)
destroy(this.sle_code_mean_eng)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)
gst_return.gvb_return = False
sle_code_type.text = Message.stringparm
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)



end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_basecode_select_popup
integer width = 2167
boolean enabled = true
end type

type cb_sort from w_popup_root`cb_sort within w_basecode_select_popup
boolean visible = true
integer x = 1033
integer y = 320
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_basecode_select_popup
boolean visible = true
integer x = 1865
integer y = 320
integer taborder = 0
end type

type st_msg from w_popup_root`st_msg within w_basecode_select_popup
boolean visible = true
integer x = 14
integer y = 504
integer width = 2167
boolean enabled = true
end type

type dw_1 from w_popup_root`dw_1 within w_basecode_select_popup
boolean visible = true
integer y = 600
integer width = 2167
integer height = 980
integer taborder = 0
string dataobject = "d_basecode_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

type dw_2 from w_popup_root`dw_2 within w_basecode_select_popup
boolean visible = true
integer y = 600
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_basecode_select_popup
integer y = 616
end type

type cb_retrieve from commandbutton within w_basecode_select_popup
integer x = 1307
integer y = 320
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

event clicked;DW_1.RETRIEVE( GVS_LANGUAGE , SLE_CODE_TYPE.TEXT  , GVI_ORGANIZATION_ID)
end event

type cb_select from commandbutton within w_basecode_select_popup
integer x = 1586
integer y = 320
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
MESSAGE.STRINGPARM		=	DW_1.GETITEMSTRING( DW_1.GETROW() , 'code_name')
CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type sle_code_type from singlelineedit within w_basecode_select_popup
integer x = 41
integer y = 352
integer width = 471
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_basecode_select_popup
integer x = 41
integer y = 280
integer width = 471
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Code Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_code_mean_eng from so_singlelineedit within w_basecode_select_popup
integer x = 517
integer y = 352
integer width = 448
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "CODE_MEAN"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

IVD_SELECTED_DATA_WINDOW.SETFILTER('')
IVD_SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

IVD_SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
IVD_SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( IVD_SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found")
end event

type st_3 from so_statictext within w_basecode_select_popup
integer x = 517
integer y = 280
integer width = 448
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Code Mean"
end type

type gb_1 from so_groupbox within w_basecode_select_popup
integer x = 1006
integer y = 216
integer width = 1170
integer height = 272
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_basecode_select_popup
integer y = 216
integer width = 992
integer height = 272
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


HA$PBExportHeader$w_standard_code_select_popup.srw
$PBExportComments$$$HEX8$$30ae08cd54cfdcb420c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_standard_code_select_popup from w_popup_root
end type
type cb_retrieve from commandbutton within w_standard_code_select_popup
end type
type cb_select from commandbutton within w_standard_code_select_popup
end type
type sle_code_type from singlelineedit within w_standard_code_select_popup
end type
type st_1 from statictext within w_standard_code_select_popup
end type
type sle_code_mean_eng from so_singlelineedit within w_standard_code_select_popup
end type
type st_3 from so_statictext within w_standard_code_select_popup
end type
type sle_code_mean_kor from so_singlelineedit within w_standard_code_select_popup
end type
type st_2 from so_statictext within w_standard_code_select_popup
end type
type sle_code_mean_local from so_singlelineedit within w_standard_code_select_popup
end type
type st_4 from so_statictext within w_standard_code_select_popup
end type
type gb_1 from so_groupbox within w_standard_code_select_popup
end type
type gb_2 from so_groupbox within w_standard_code_select_popup
end type
end forward

global type w_standard_code_select_popup from w_popup_root
integer width = 3529
integer height = 2168
cb_retrieve cb_retrieve
cb_select cb_select
sle_code_type sle_code_type
st_1 st_1
sle_code_mean_eng sle_code_mean_eng
st_3 st_3
sle_code_mean_kor sle_code_mean_kor
st_2 st_2
sle_code_mean_local sle_code_mean_local
st_4 st_4
gb_1 gb_1
gb_2 gb_2
end type
global w_standard_code_select_popup w_standard_code_select_popup

on w_standard_code_select_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.sle_code_type=create sle_code_type
this.st_1=create st_1
this.sle_code_mean_eng=create sle_code_mean_eng
this.st_3=create st_3
this.sle_code_mean_kor=create sle_code_mean_kor
this.st_2=create st_2
this.sle_code_mean_local=create sle_code_mean_local
this.st_4=create st_4
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.sle_code_type
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_code_mean_eng
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.sle_code_mean_kor
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.sle_code_mean_local
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_standard_code_select_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.sle_code_type)
destroy(this.st_1)
destroy(this.sle_code_mean_eng)
destroy(this.st_3)
destroy(this.sle_code_mean_kor)
destroy(this.st_2)
destroy(this.sle_code_mean_local)
destroy(this.st_4)
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

type p_title from w_popup_root`p_title within w_standard_code_select_popup
integer width = 3511
end type

type cb_sort from w_popup_root`cb_sort within w_standard_code_select_popup
boolean visible = true
integer x = 2176
integer y = 324
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_standard_code_select_popup
boolean visible = true
integer x = 3008
integer y = 324
integer taborder = 0
end type

type st_msg from w_popup_root`st_msg within w_standard_code_select_popup
boolean visible = true
integer y = 508
integer width = 3511
end type

type dw_1 from w_popup_root`dw_1 within w_standard_code_select_popup
boolean visible = true
integer y = 604
integer width = 3497
integer height = 1484
integer taborder = 0
boolean titlebar = true
string title = "Standard Code List"
string dataobject = "d_standard_code_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

type dw_2 from w_popup_root`dw_2 within w_standard_code_select_popup
boolean visible = true
integer y = 604
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_standard_code_select_popup
end type

type cb_retrieve from commandbutton within w_standard_code_select_popup
integer x = 2450
integer y = 324
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

event clicked;DW_1.RETRIEVE(SLE_CODE_TYPE.TEXT  ,GVS_LANGUAGE ,  GVI_ORGANIZATION_ID)
end event

type cb_select from commandbutton within w_standard_code_select_popup
integer x = 2729
integer y = 324
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
gst_return.gvs_return[1]	=	DW_1.GETITEMSTRING( DW_1.GETROW() , 'code_group')
CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type sle_code_type from singlelineedit within w_standard_code_select_popup
integer x = 41
integer y = 356
integer width = 558
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_standard_code_select_popup
integer x = 41
integer y = 284
integer width = 558
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

type sle_code_mean_eng from so_singlelineedit within w_standard_code_select_popup
integer x = 603
integer y = 356
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "CODE_MEAN_ENG"

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

type st_3 from so_statictext within w_standard_code_select_popup
integer x = 622
integer y = 284
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Code Mean Eng"
end type

type sle_code_mean_kor from so_singlelineedit within w_standard_code_select_popup
integer x = 1106
integer y = 356
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "CODE_MEAN_KOR"

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

type st_2 from so_statictext within w_standard_code_select_popup
integer x = 1102
integer y = 284
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Code Mean Kor"
end type

type sle_code_mean_local from so_singlelineedit within w_standard_code_select_popup
integer x = 1609
integer y = 356
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "CODE_MEAN_LOCAL"

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

type st_4 from so_statictext within w_standard_code_select_popup
integer x = 1605
integer y = 284
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Code Mean Local"
end type

type gb_1 from so_groupbox within w_standard_code_select_popup
integer x = 2149
integer y = 220
integer width = 1170
integer height = 272
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_standard_code_select_popup
integer y = 220
integer width = 2126
integer height = 272
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


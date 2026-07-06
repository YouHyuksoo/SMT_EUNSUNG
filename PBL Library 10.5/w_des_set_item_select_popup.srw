HA$PBExportHeader$w_des_set_item_select_popup.srw
$PBExportComments$$$HEX7$$a8ba78b3c8b9a4c230d11dd3c5c5$$ENDHEX$$
forward
global type w_des_set_item_select_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_des_set_item_select_popup
end type
type cb_select from so_commandbutton within w_des_set_item_select_popup
end type
type st_14 from statictext within w_des_set_item_select_popup
end type
type sle_item_code from singlelineedit within w_des_set_item_select_popup
end type
type st_1 from statictext within w_des_set_item_select_popup
end type
type sle_item_name from singlelineedit within w_des_set_item_select_popup
end type
type sle_1 from singlelineedit within w_des_set_item_select_popup
end type
type st_7 from statictext within w_des_set_item_select_popup
end type
type gb_1 from so_groupbox within w_des_set_item_select_popup
end type
type gb_2 from so_groupbox within w_des_set_item_select_popup
end type
end forward

global type w_des_set_item_select_popup from w_popup_root
integer width = 3611
integer height = 2008
string title = "Set Item Select Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_14 st_14
sle_item_code sle_item_code
st_1 st_1
sle_item_name sle_item_name
sle_1 sle_1
st_7 st_7
gb_1 gb_1
gb_2 gb_2
end type
global w_des_set_item_select_popup w_des_set_item_select_popup

on w_des_set_item_select_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_14=create st_14
this.sle_item_code=create sle_item_code
this.st_1=create st_1
this.sle_item_name=create sle_item_name
this.sle_1=create sle_1
this.st_7=create st_7
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_14
this.Control[iCurrent+4]=this.sle_item_code
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.sle_item_name
this.Control[iCurrent+7]=this.sle_1
this.Control[iCurrent+8]=this.st_7
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
end on

on w_des_set_item_select_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_14)
destroy(this.sle_item_code)
destroy(this.st_1)
destroy(this.sle_item_name)
destroy(this.sle_1)
destroy(this.st_7)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
SLE_ITEM_CODE.SETFOCUS()
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_des_set_item_select_popup
integer width = 3598
end type

type cb_sort from w_popup_root`cb_sort within w_des_set_item_select_popup
boolean visible = true
integer x = 2455
integer y = 332
end type

type cb_close from w_popup_root`cb_close within w_des_set_item_select_popup
boolean visible = true
integer x = 3291
integer y = 332
end type

type st_msg from w_popup_root`st_msg within w_des_set_item_select_popup
boolean visible = true
integer y = 500
integer width = 3598
end type

type dw_1 from w_popup_root`dw_1 within w_des_set_item_select_popup
boolean visible = true
integer y = 596
integer width = 3598
integer height = 1328
boolean titlebar = true
string dataobject = "d_des_set_item_select_popup_tree"
end type

type dw_2 from w_popup_root`dw_2 within w_des_set_item_select_popup
boolean visible = true
integer y = 596
end type

type dw_3 from w_popup_root`dw_3 within w_des_set_item_select_popup
integer y = 624
end type

type cb_retrieve from so_commandbutton within w_des_set_item_select_popup
integer x = 2734
integer y = 332
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

event clicked;DW_1.RETRIEVE( SLE_ITEM_CODE.TEXT+'%' , GVI_ORGANIZATION_ID  )
end event

type cb_select from so_commandbutton within w_des_set_item_select_popup
integer x = 3013
integer y = 332
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

event clicked;LONG I , LVL_ROW
STRING LVS_MODEL , LVS_SUFFIX , LVS_CHECK_YN , LVS_ITEM_CODE
DATAWINDOW PARM_DW

PARM_DW = Message.PowerObjectParm

IF DW_1.GETROW() < 1 THEN RETURN 
DO
	I++
	
	LVS_CHECK_YN = DW_1.GETITEMSTRING( I , 'CHECK_YN' )
	
	IF LVS_CHECK_YN = 'Y' THEN
	
	   LVS_MODEL = '' ;LVS_SUFFIX ='' ;LVS_ITEM_CODE =''
		
		LVS_ITEM_CODE= DW_1.GETITEMSTRING( I , 'ITEM_CODE' )
		
		LVL_ROW = PARM_DW.INSERTROW(0)
		PARM_DW.SETITEM( LVL_ROW , 'ITEM_CODE' , LVS_ITEM_CODE )	
		PARM_DW.SETITEM( LVL_ROW , 'APPLY_YN' , 'N' )	
          F_SET_SECURITY_ROW(PARM_DW , LVL_ROW , 'ALL')
		PARM_DW.SETITEM( LVL_ROW, 'requirment_plan_date' , F_T_SYSDATE() )		
		PARM_DW.SETITEM( LVL_ROW, 'requirment_plan_seq' , f_get_requirment_plan_seq() )				
		PARM_DW.SETITEM( LVL_ROW, 'plan_date' , F_T_SYSDATE() )				
		
	END IF
	
LOOP UNTIL I = DW_1.ROWCOUNT()

CLOSE(PARENT)
end event

type st_14 from statictext within w_des_set_item_select_popup
integer x = 55
integer y = 296
integer width = 494
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Item Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_item_code from singlelineedit within w_des_set_item_select_popup
event ue_editchange pbm_enchange
integer x = 46
integer y = 360
integer width = 494
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "h_beam.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN ='ITEM_CODE'

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

IVD_SELECTED_DATA_WINDOW.SETFILTER('')
IVD_SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	LVS_VALUE = '%'
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

IVD_SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
IVD_SELECTED_DATA_WINDOW.FILTER()
ST_MSG.TEXT = STRING( IVD_SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found"
end event

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type st_1 from statictext within w_des_set_item_select_popup
integer x = 544
integer y = 296
integer width = 494
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
boolean enabled = false
string text = "Item Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_item_name from singlelineedit within w_des_set_item_select_popup
event ue_editchange pbm_enchange
integer x = 544
integer y = 360
integer width = 494
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "ITEM_NAME"

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

type sle_1 from singlelineedit within w_des_set_item_select_popup
event ue_editchange pbm_enchange
integer x = 1047
integer y = 360
integer width = 494
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "ITEM_SPEC"

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

type st_7 from statictext within w_des_set_item_select_popup
integer x = 1042
integer y = 296
integer width = 494
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
boolean enabled = false
string text = "Item Spec"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from so_groupbox within w_des_set_item_select_popup
integer y = 212
integer width = 1582
integer height = 284
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_des_set_item_select_popup
integer x = 2423
integer y = 212
integer width = 1170
integer height = 284
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


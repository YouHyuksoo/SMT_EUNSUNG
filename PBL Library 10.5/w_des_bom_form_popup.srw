HA$PBExportHeader$w_des_bom_form_popup.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_des_bom_form_popup from w_popup_root
end type
type cb_retrieve from commandbutton within w_des_bom_form_popup
end type
type st_2 from statictext within w_des_bom_form_popup
end type
type sle_parent_item_code from singlelineedit within w_des_bom_form_popup
end type
type sle_child_item_code from singlelineedit within w_des_bom_form_popup
end type
type st_1 from statictext within w_des_bom_form_popup
end type
type uo_dateset from uo_ymd_calendar within w_des_bom_form_popup
end type
type st_3 from so_statictext within w_des_bom_form_popup
end type
type cb_1 from commandbutton within w_des_bom_form_popup
end type
type st_4 from so_statictext within w_des_bom_form_popup
end type
type sle_line_code from so_singlelineedit within w_des_bom_form_popup
end type
type sle_machine_code from so_singlelineedit within w_des_bom_form_popup
end type
type st_5 from so_statictext within w_des_bom_form_popup
end type
type gb_1 from so_groupbox within w_des_bom_form_popup
end type
type gb_2 from so_groupbox within w_des_bom_form_popup
end type
end forward

global type w_des_bom_form_popup from w_popup_root
integer width = 3077
integer height = 1540
string title = "BOM Popup"
cb_retrieve cb_retrieve
st_2 st_2
sle_parent_item_code sle_parent_item_code
sle_child_item_code sle_child_item_code
st_1 st_1
uo_dateset uo_dateset
st_3 st_3
cb_1 cb_1
st_4 st_4
sle_line_code sle_line_code
sle_machine_code sle_machine_code
st_5 st_5
gb_1 gb_1
gb_2 gb_2
end type
global w_des_bom_form_popup w_des_bom_form_popup

on w_des_bom_form_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.st_2=create st_2
this.sle_parent_item_code=create sle_parent_item_code
this.sle_child_item_code=create sle_child_item_code
this.st_1=create st_1
this.uo_dateset=create uo_dateset
this.st_3=create st_3
this.cb_1=create cb_1
this.st_4=create st_4
this.sle_line_code=create sle_line_code
this.sle_machine_code=create sle_machine_code
this.st_5=create st_5
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_parent_item_code
this.Control[iCurrent+4]=this.sle_child_item_code
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.uo_dateset
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.sle_line_code
this.Control[iCurrent+11]=this.sle_machine_code
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_des_bom_form_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.st_2)
destroy(this.sle_parent_item_code)
destroy(this.sle_child_item_code)
destroy(this.st_1)
destroy(this.uo_dateset)
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.st_4)
destroy(this.sle_line_code)
destroy(this.sle_machine_code)
destroy(this.st_5)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)

SLE_PARENT_ITEM_CODE.TEXT = message.stringparm
SLE_CHILD_ITEM_CODE.TEXT = gst_return.gvs_return[1]
SLE_LINE_CODE.TEXT = gst_return.gvs_return[3]
SLE_MACHINE_CODE.TEXT = gst_return.gvs_return[4]

UO_DATESET.SETTEXT( gst_return.gvs_return[2] )
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)


end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_des_bom_form_popup
integer width = 3067
end type

type cb_sort from w_popup_root`cb_sort within w_des_bom_form_popup
integer x = 2665
integer y = 28
integer height = 140
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_des_bom_form_popup
boolean visible = true
integer x = 2770
integer y = 284
integer height = 140
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_des_bom_form_popup
boolean visible = true
integer y = 484
integer width = 3067
end type

type dw_1 from w_popup_root`dw_1 within w_des_bom_form_popup
boolean visible = true
integer y = 580
integer width = 3067
integer height = 872
integer taborder = 70
boolean titlebar = true
string title = "Set Item List"
string dataobject = "d_des_bom_form_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_des_bom_form_popup
boolean visible = true
integer y = 580
integer taborder = 0
string dataobject = "d_des_bom_form_popup"
end type

type dw_3 from w_popup_root`dw_3 within w_des_bom_form_popup
integer y = 784
end type

type cb_retrieve from commandbutton within w_des_bom_form_popup
integer x = 2217
integer y = 284
integer width = 274
integer height = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(SLE_PARENT_ITEM_CODE.TEXT , SLE_CHILD_ITEM_CODE.TEXT, UO_DATESET.TEXT()  , GVI_ORGANIZATION_ID )
end event

type st_2 from statictext within w_des_bom_form_popup
integer x = 37
integer y = 268
integer width = 453
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Parent Item Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_parent_item_code from singlelineedit within w_des_bom_form_popup
event ue_editchange pbm_enchange
integer x = 37
integer y = 344
integer width = 453
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
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type sle_child_item_code from singlelineedit within w_des_bom_form_popup
integer x = 489
integer y = 344
integer width = 462
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_des_bom_form_popup
integer x = 489
integer y = 268
integer width = 462
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Child Item Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_dateset from uo_ymd_calendar within w_des_bom_form_popup
event destroy ( )
integer x = 955
integer y = 344
integer height = 84
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_3 from so_statictext within w_des_bom_form_popup
integer x = 942
integer y = 268
integer width = 430
integer height = 52
boolean bringtotop = true
string text = "Dateset"
end type

type cb_1 from commandbutton within w_des_bom_form_popup
integer x = 2496
integer y = 284
integer width = 274
integer height = 140
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
end type

event clicked;if dw_1.update( ) < 0 then 
	rollback;
else
	commit ;
end if
end event

type st_4 from so_statictext within w_des_bom_form_popup
integer x = 1371
integer y = 264
integer width = 407
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type sle_line_code from so_singlelineedit within w_des_bom_form_popup
integer x = 1371
integer y = 340
integer width = 407
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'LINE_CODE'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type sle_machine_code from so_singlelineedit within w_des_bom_form_popup
integer x = 1778
integer y = 340
integer width = 393
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'MACHINE'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type st_5 from so_statictext within w_des_bom_form_popup
integer x = 1778
integer y = 272
integer width = 393
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Machine"
end type

type gb_1 from so_groupbox within w_des_bom_form_popup
integer y = 196
integer width = 2190
integer height = 284
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_des_bom_form_popup
integer x = 2190
integer y = 196
integer width = 882
integer height = 284
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


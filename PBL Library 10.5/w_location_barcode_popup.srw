HA$PBExportHeader$w_location_barcode_popup.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_location_barcode_popup from w_popup_root
end type
type cb_select from commandbutton within w_location_barcode_popup
end type
type cb_retrieve from commandbutton within w_location_barcode_popup
end type
type st_2 from so_statictext within w_location_barcode_popup
end type
type sle_line_code from so_singlelineedit within w_location_barcode_popup
end type
type sle_machine_code from so_singlelineedit within w_location_barcode_popup
end type
type st_1 from so_statictext within w_location_barcode_popup
end type
type rb_left from radiobutton within w_location_barcode_popup
end type
type rb_right from radiobutton within w_location_barcode_popup
end type
type rb_none from radiobutton within w_location_barcode_popup
end type
type rb_1 from radiobutton within w_location_barcode_popup
end type
type gb_1 from so_groupbox within w_location_barcode_popup
end type
type gb_2 from so_groupbox within w_location_barcode_popup
end type
end forward

global type w_location_barcode_popup from w_popup_root
integer width = 3323
integer height = 2988
string title = "Location Barcode Popup"
cb_select cb_select
cb_retrieve cb_retrieve
st_2 st_2
sle_line_code sle_line_code
sle_machine_code sle_machine_code
st_1 st_1
rb_left rb_left
rb_right rb_right
rb_none rb_none
rb_1 rb_1
gb_1 gb_1
gb_2 gb_2
end type
global w_location_barcode_popup w_location_barcode_popup

on w_location_barcode_popup.create
int iCurrent
call super::create
this.cb_select=create cb_select
this.cb_retrieve=create cb_retrieve
this.st_2=create st_2
this.sle_line_code=create sle_line_code
this.sle_machine_code=create sle_machine_code
this.st_1=create st_1
this.rb_left=create rb_left
this.rb_right=create rb_right
this.rb_none=create rb_none
this.rb_1=create rb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_line_code
this.Control[iCurrent+5]=this.sle_machine_code
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.rb_left
this.Control[iCurrent+8]=this.rb_right
this.Control[iCurrent+9]=this.rb_none
this.Control[iCurrent+10]=this.rb_1
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_location_barcode_popup.destroy
call super::destroy
destroy(this.cb_select)
destroy(this.cb_retrieve)
destroy(this.st_2)
destroy(this.sle_line_code)
destroy(this.sle_machine_code)
destroy(this.st_1)
destroy(this.rb_left)
destroy(this.rb_right)
destroy(this.rb_none)
destroy(this.rb_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)

sle_Line_code.TEXT = message.stringparm
sle_machine_code.TEXT = Gst_return.gvs_return[1]

CB_RETRIEVE.TRIGGEREVENT(CLICKED!)


end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_location_barcode_popup
integer width = 3314
integer height = 188
long backcolor = 16777215
end type

type cb_sort from w_popup_root`cb_sort within w_location_barcode_popup
integer x = 1979
integer y = 292
integer height = 144
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_location_barcode_popup
boolean visible = true
integer x = 2994
integer y = 292
integer height = 144
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_location_barcode_popup
boolean visible = true
integer y = 488
integer width = 3314
end type

type dw_1 from w_popup_root`dw_1 within w_location_barcode_popup
boolean visible = true
integer y = 584
integer width = 3314
integer height = 2324
integer taborder = 0
boolean titlebar = true
string dataobject = "d_location_barcode_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

type dw_2 from w_popup_root`dw_2 within w_location_barcode_popup
boolean visible = true
integer y = 588
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_location_barcode_popup
integer y = 864
integer taborder = 30
end type

type cb_select from commandbutton within w_location_barcode_popup
integer x = 2615
integer y = 292
integer width = 357
integer height = 144
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

event clicked;IF DW_1.GETROW() = 0  THEN 
	gst_return.gvb_return = false
	RETURN -1
END IF
gst_return.gvb_return = true 

MESSAGE.STRINGPARM= DW_1.GETITEMSTRING( DW_1.GETROW() , 'location_code')

CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type cb_retrieve from commandbutton within w_location_barcode_popup
integer x = 2286
integer y = 292
integer width = 306
integer height = 144
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(SLE_LINE_CODE.TEXT+'%' , SLE_MACHINE_CODE.TEXT+'%' ,  GVI_ORGANIZATION_ID )
end event

type st_2 from so_statictext within w_location_barcode_popup
integer x = 55
integer y = 280
integer width = 590
integer height = 56
boolean bringtotop = true
string text = "Line Code"
end type

type sle_line_code from so_singlelineedit within w_location_barcode_popup
integer x = 55
integer y = 356
integer width = 590
integer height = 84
integer taborder = 10
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

event ue_editchange;//=====================================
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

type sle_machine_code from so_singlelineedit within w_location_barcode_popup
integer x = 649
integer y = 356
integer width = 590
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event ue_editchange;call super::ue_editchange;//=====================================
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

type st_1 from so_statictext within w_location_barcode_popup
integer x = 649
integer y = 288
integer width = 590
integer height = 56
boolean bringtotop = true
string text = "Machine"
end type

type rb_left from radiobutton within w_location_barcode_popup
integer x = 1275
integer y = 376
integer width = 293
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Left"
end type

event clicked;dw_1.setfilter("POSITION = 'L' ")
dw_1.filter()
end event

type rb_right from radiobutton within w_location_barcode_popup
integer x = 1637
integer y = 380
integer width = 261
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Right"
end type

event clicked;dw_1.setfilter("POSITION = 'R' ")
dw_1.filter()
end event

type rb_none from radiobutton within w_location_barcode_popup
integer x = 1637
integer y = 276
integer width = 261
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "None"
end type

event clicked;dw_1.setfilter("POSITION = 'N' ")
dw_1.filter()
end event

type rb_1 from radiobutton within w_location_barcode_popup
integer x = 1275
integer y = 280
integer width = 293
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "All"
boolean checked = true
end type

event clicked;dw_1.setfilter('')
dw_1.filter()
end event

type gb_1 from so_groupbox within w_location_barcode_popup
integer y = 196
integer width = 1957
integer height = 284
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_location_barcode_popup
integer x = 2240
integer y = 204
integer width = 1056
integer height = 284
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


HA$PBExportHeader$w_pln_serial_info_popup.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_pln_serial_info_popup from w_popup_root
end type
type cb_select from commandbutton within w_pln_serial_info_popup
end type
type cb_retrieve from commandbutton within w_pln_serial_info_popup
end type
type st_mrm_no from statictext within w_pln_serial_info_popup
end type
type sle_run_no from so_singlelineedit within w_pln_serial_info_popup
end type
type sle_pcb_serial_no from so_singlelineedit within w_pln_serial_info_popup
end type
type st_2 from statictext within w_pln_serial_info_popup
end type
type sle_model_name from so_singlelineedit within w_pln_serial_info_popup
end type
type st_4 from statictext within w_pln_serial_info_popup
end type
type cb_3 from so_commandbutton within w_pln_serial_info_popup
end type
type sle_label_text from so_singlelineedit within w_pln_serial_info_popup
end type
type st_5 from statictext within w_pln_serial_info_popup
end type
type uo_dateset from uo_ymd_calendar within w_pln_serial_info_popup
end type
type st_6 from so_statictext within w_pln_serial_info_popup
end type
type uo_dateend from uo_ymd_calendar within w_pln_serial_info_popup
end type
type cb_1 from commandbutton within w_pln_serial_info_popup
end type
type sle_marking_no from so_singlelineedit within w_pln_serial_info_popup
end type
type st_1 from statictext within w_pln_serial_info_popup
end type
type cb_2 from commandbutton within w_pln_serial_info_popup
end type
type gb_2 from so_groupbox within w_pln_serial_info_popup
end type
type gb_1 from so_groupbox within w_pln_serial_info_popup
end type
end forward

global type w_pln_serial_info_popup from w_popup_root
integer width = 4233
integer height = 2200
string title = "Run No Master Popup"
cb_select cb_select
cb_retrieve cb_retrieve
st_mrm_no st_mrm_no
sle_run_no sle_run_no
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
sle_model_name sle_model_name
st_4 st_4
cb_3 cb_3
sle_label_text sle_label_text
st_5 st_5
uo_dateset uo_dateset
st_6 st_6
uo_dateend uo_dateend
cb_1 cb_1
sle_marking_no sle_marking_no
st_1 st_1
cb_2 cb_2
gb_2 gb_2
gb_1 gb_1
end type
global w_pln_serial_info_popup w_pln_serial_info_popup

on w_pln_serial_info_popup.create
int iCurrent
call super::create
this.cb_select=create cb_select
this.cb_retrieve=create cb_retrieve
this.st_mrm_no=create st_mrm_no
this.sle_run_no=create sle_run_no
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_2=create st_2
this.sle_model_name=create sle_model_name
this.st_4=create st_4
this.cb_3=create cb_3
this.sle_label_text=create sle_label_text
this.st_5=create st_5
this.uo_dateset=create uo_dateset
this.st_6=create st_6
this.uo_dateend=create uo_dateend
this.cb_1=create cb_1
this.sle_marking_no=create sle_marking_no
this.st_1=create st_1
this.cb_2=create cb_2
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.st_mrm_no
this.Control[iCurrent+4]=this.sle_run_no
this.Control[iCurrent+5]=this.sle_pcb_serial_no
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.sle_model_name
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.cb_3
this.Control[iCurrent+10]=this.sle_label_text
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.uo_dateset
this.Control[iCurrent+13]=this.st_6
this.Control[iCurrent+14]=this.uo_dateend
this.Control[iCurrent+15]=this.cb_1
this.Control[iCurrent+16]=this.sle_marking_no
this.Control[iCurrent+17]=this.st_1
this.Control[iCurrent+18]=this.cb_2
this.Control[iCurrent+19]=this.gb_2
this.Control[iCurrent+20]=this.gb_1
end on

on w_pln_serial_info_popup.destroy
call super::destroy
destroy(this.cb_select)
destroy(this.cb_retrieve)
destroy(this.st_mrm_no)
destroy(this.sle_run_no)
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.sle_model_name)
destroy(this.st_4)
destroy(this.cb_3)
destroy(this.sle_label_text)
destroy(this.st_5)
destroy(this.uo_dateset)
destroy(this.st_6)
destroy(this.uo_dateend)
destroy(this.cb_1)
destroy(this.sle_marking_no)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
//CB_RETRIEVE.TRIGGEREVENT(CLICKED!)

end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_pln_serial_info_popup
integer width = 4233
integer height = 188
long backcolor = 16777215
end type

type cb_sort from w_popup_root`cb_sort within w_pln_serial_info_popup
boolean visible = true
integer x = 41
integer y = 560
integer width = 361
integer height = 124
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_pln_serial_info_popup
boolean visible = true
integer x = 1563
integer y = 560
integer width = 361
integer height = 124
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_pln_serial_info_popup
boolean visible = true
integer y = 716
integer width = 4224
end type

type dw_1 from w_popup_root`dw_1 within w_pln_serial_info_popup
boolean visible = true
integer y = 808
integer width = 4224
integer height = 1296
integer taborder = 70
boolean titlebar = true
string title = "Item List"
string dataobject = "d_pln_product_barcode_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

event dw_1::retrieverow;call super::retrieverow;st_msg.text = string(setrow)
end event

event dw_1::retrievestart;call super::retrievestart;st_msg.text = "Please Wait..."
end event

type dw_2 from w_popup_root`dw_2 within w_pln_serial_info_popup
boolean visible = true
integer y = 772
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_pln_serial_info_popup
integer y = 864
end type

type cb_select from commandbutton within w_pln_serial_info_popup
integer x = 1198
integer y = 560
integer width = 361
integer height = 124
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

MESSAGE.STRINGPARM= DW_1.GETITEMSTRING( DW_1.GETROW() , 'serial_no')
Gst_return.gvs_return[1] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'run_no')
CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type cb_retrieve from commandbutton within w_pln_serial_info_popup
integer x = 402
integer y = 560
integer width = 361
integer height = 124
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;setpointer(hourglass!)
DW_1.RETRIEVE( SLE_RUN_NO.TEXT+'%' , sle_pcb_serial_no.TEXT+'%' , sle_label_text.text+'%' ,  uo_dateset.text() , uo_dateend.text() , sle_marking_no.text+'%' , GVI_ORGANIZATION_ID )

end event

type st_mrm_no from statictext within w_pln_serial_info_popup
integer x = 55
integer y = 280
integer width = 631
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Run No"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_run_no from so_singlelineedit within w_pln_serial_info_popup
integer x = 55
integer y = 360
integer width = 631
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

type sle_pcb_serial_no from so_singlelineedit within w_pln_serial_info_popup
integer x = 2519
integer y = 360
integer width = 690
integer taborder = 20
boolean bringtotop = true
end type

type st_2 from statictext within w_pln_serial_info_popup
integer x = 2519
integer y = 280
integer width = 690
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "PCB Serial No"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_model_name from so_singlelineedit within w_pln_serial_info_popup
integer x = 695
integer y = 360
integer width = 581
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
textcase textcase = upper!
end type

type st_4 from statictext within w_pln_serial_info_popup
integer x = 695
integer y = 280
integer width = 581
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_3 from so_commandbutton within w_pln_serial_info_popup
integer x = 539
integer y = 252
integer width = 151
integer height = 108
integer taborder = 10
boolean bringtotop = true
string text = "?"
end type

type sle_label_text from so_singlelineedit within w_pln_serial_info_popup
integer x = 1285
integer y = 360
integer width = 608
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

type st_5 from statictext within w_pln_serial_info_popup
integer x = 1285
integer y = 280
integer width = 617
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Label Text"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_dateset from uo_ymd_calendar within w_pln_serial_info_popup
event destroy ( )
integer x = 3218
integer y = 360
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_6 from so_statictext within w_pln_serial_info_popup
integer x = 3218
integer y = 280
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Run Date"
end type

type uo_dateend from uo_ymd_calendar within w_pln_serial_info_popup
event destroy ( )
integer x = 3630
integer y = 360
integer taborder = 70
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type cb_1 from commandbutton within w_pln_serial_info_popup
integer x = 773
integer y = 560
integer width = 361
integer height = 124
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Stop"
end type

event clicked;dw_1.dbcancel()
end event

type sle_marking_no from so_singlelineedit within w_pln_serial_info_popup
integer x = 1902
integer y = 360
integer width = 608
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
end type

type st_1 from statictext within w_pln_serial_info_popup
integer x = 1902
integer y = 268
integer width = 617
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Marking No"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_pln_serial_info_popup
integer x = 2011
integer y = 556
integer width = 485
integer height = 124
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Capture Barcode"
end type

event clicked;run('barcapture.exe')
end event

type gb_2 from so_groupbox within w_pln_serial_info_popup
integer y = 504
integer width = 2546
integer height = 200
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_pln_serial_info_popup
integer y = 196
integer width = 4073
integer height = 304
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


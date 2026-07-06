HA$PBExportHeader$w_mat_solder_scan_barcode_popup.srw
$PBExportComments$Purchase Order Lot Divide Popup
forward
global type w_mat_solder_scan_barcode_popup from w_none_dw_popup_root
end type
type cb_2 from so_commandbutton within w_mat_solder_scan_barcode_popup
end type
type sle_barcode from singlelineedit within w_mat_solder_scan_barcode_popup
end type
type rb_receipt from so_radiobutton within w_mat_solder_scan_barcode_popup
end type
type rb_rereceipt from so_radiobutton within w_mat_solder_scan_barcode_popup
end type
type rb_mixin from so_radiobutton within w_mat_solder_scan_barcode_popup
end type
type rb_mixout from so_radiobutton within w_mat_solder_scan_barcode_popup
end type
type rb_issue from so_radiobutton within w_mat_solder_scan_barcode_popup
end type
type rb_destroy from so_radiobutton within w_mat_solder_scan_barcode_popup
end type
type rb_nomral from so_radiobutton within w_mat_solder_scan_barcode_popup
end type
type rb_cancel from so_radiobutton within w_mat_solder_scan_barcode_popup
end type
type st_1 from so_statictext within w_mat_solder_scan_barcode_popup
end type
type sle_line from singlelineedit within w_mat_solder_scan_barcode_popup
end type
type st_2 from so_statictext within w_mat_solder_scan_barcode_popup
end type
type rb_reissue from so_radiobutton within w_mat_solder_scan_barcode_popup
end type
type gb_1 from so_groupbox within w_mat_solder_scan_barcode_popup
end type
type gb_2 from so_groupbox within w_mat_solder_scan_barcode_popup
end type
type gb_3 from so_groupbox within w_mat_solder_scan_barcode_popup
end type
end forward

global type w_mat_solder_scan_barcode_popup from w_none_dw_popup_root
integer width = 2661
integer height = 1996
cb_2 cb_2
sle_barcode sle_barcode
rb_receipt rb_receipt
rb_rereceipt rb_rereceipt
rb_mixin rb_mixin
rb_mixout rb_mixout
rb_issue rb_issue
rb_destroy rb_destroy
rb_nomral rb_nomral
rb_cancel rb_cancel
st_1 st_1
sle_line sle_line
st_2 st_2
rb_reissue rb_reissue
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_solder_scan_barcode_popup w_mat_solder_scan_barcode_popup

on w_mat_solder_scan_barcode_popup.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.sle_barcode=create sle_barcode
this.rb_receipt=create rb_receipt
this.rb_rereceipt=create rb_rereceipt
this.rb_mixin=create rb_mixin
this.rb_mixout=create rb_mixout
this.rb_issue=create rb_issue
this.rb_destroy=create rb_destroy
this.rb_nomral=create rb_nomral
this.rb_cancel=create rb_cancel
this.st_1=create st_1
this.sle_line=create sle_line
this.st_2=create st_2
this.rb_reissue=create rb_reissue
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.sle_barcode
this.Control[iCurrent+3]=this.rb_receipt
this.Control[iCurrent+4]=this.rb_rereceipt
this.Control[iCurrent+5]=this.rb_mixin
this.Control[iCurrent+6]=this.rb_mixout
this.Control[iCurrent+7]=this.rb_issue
this.Control[iCurrent+8]=this.rb_destroy
this.Control[iCurrent+9]=this.rb_nomral
this.Control[iCurrent+10]=this.rb_cancel
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.sle_line
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.rb_reissue
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_2
this.Control[iCurrent+17]=this.gb_3
end on

on w_mat_solder_scan_barcode_popup.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.sle_barcode)
destroy(this.rb_receipt)
destroy(this.rb_rereceipt)
destroy(this.rb_mixin)
destroy(this.rb_mixout)
destroy(this.rb_issue)
destroy(this.rb_destroy)
destroy(this.rb_nomral)
destroy(this.rb_cancel)
destroy(this.st_1)
destroy(this.sle_line)
destroy(this.st_2)
destroy(this.rb_reissue)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;sle_barcode.setfocus()
end event

event activate;call super::activate;sle_barcode.setfocus()
end event

type p_title from w_none_dw_popup_root`p_title within w_mat_solder_scan_barcode_popup
integer x = 5
integer width = 2647
end type

type cb_close from w_none_dw_popup_root`cb_close within w_mat_solder_scan_barcode_popup
boolean visible = true
integer x = 1317
integer y = 1512
integer width = 366
integer height = 116
integer taborder = 0
integer textsize = -10
integer weight = 400
end type

type st_msg from w_none_dw_popup_root`st_msg within w_mat_solder_scan_barcode_popup
boolean visible = true
integer y = 1632
integer width = 2647
integer height = 288
end type

type cb_2 from so_commandbutton within w_mat_solder_scan_barcode_popup
integer x = 937
integer y = 1512
integer width = 366
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 400
string text = "Clear"
end type

event clicked;call super::clicked;sle_barcode.text  = ''
sle_barcode.setfocus()
end event

type sle_barcode from singlelineedit within w_mat_solder_scan_barcode_popup
integer x = 763
integer y = 1284
integer width = 1632
integer height = 152
integer taborder = 10
boolean bringtotop = true
integer textsize = -20
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

event modified;string lvs_out  , lvs_deficit , lvs_line_code , lvs_model_name , lvs_barcode , lvs_type

lvs_out = space(4000)

if rb_cancel.checked = true then 
	lvs_deficit = 'C'
else
	lvs_deficit = 'N'
end if 

lvs_line_code = sle_line.text
lvs_model_name = '*' 
lvs_barcode = this.text

//===========================================
//
//===========================================
if rb_receipt.checked = true then 
	lvs_type = 'R'
	
elseif rb_issue.checked = true then 
	lvs_type = 'I'
elseif rb_reissue.checked = true then 
	lvs_type = 'B'	
elseif rb_rereceipt.checked = true then 
	lvs_type = 'A'
elseif  rb_mixin.checked = true then 
	
	lvs_type = 'M'
elseif rb_mixout.checked = true then
	lvs_type = 'O'
elseif rb_destroy.checked = true then
	lvs_type = 'D'	
//elseif rb_check.checked = true then
//	lvs_type = 'C'		
end if 
	
sqlca.P_CHECK_SOLDER_SCAN( lvs_line_code,lvs_model_name, lvs_barcode , lvs_type , lvs_deficit ,ref lvs_out)

if f_sql_check() < 0 then 
	return 
end if 

if lvs_out <> 'OK' then 	
	st_msg.text = lvs_out
	rollback ;
	this.text = ''
else
	st_msg.text = 'OK'	
	commit ;
	this.text = ''
	this.setfocus()
end if 


end event

type rb_receipt from so_radiobutton within w_mat_solder_scan_barcode_popup
integer x = 197
integer y = 348
boolean bringtotop = true
integer textsize = -12
string text = "Receipt"
boolean checked = true
end type

event clicked;call super::clicked;sle_barcode.setfocus()
end event

type rb_rereceipt from so_radiobutton within w_mat_solder_scan_barcode_popup
integer x = 197
integer y = 500
boolean bringtotop = true
integer textsize = -12
string text = "Re- Receipt"
end type

event clicked;call super::clicked;sle_barcode.setfocus()
end event

type rb_mixin from so_radiobutton within w_mat_solder_scan_barcode_popup
integer x = 197
integer y = 660
boolean bringtotop = true
integer textsize = -12
string text = "Mix In"
end type

event clicked;call super::clicked;sle_barcode.setfocus()
end event

type rb_mixout from so_radiobutton within w_mat_solder_scan_barcode_popup
integer x = 1001
integer y = 656
boolean bringtotop = true
integer textsize = -12
string text = "Mix Out"
end type

event clicked;call super::clicked;sle_barcode.setfocus()
end event

type rb_issue from so_radiobutton within w_mat_solder_scan_barcode_popup
integer x = 1001
integer y = 348
boolean bringtotop = true
integer textsize = -12
string text = "Issue"
end type

event clicked;call super::clicked;sle_barcode.setfocus()
end event

type rb_destroy from so_radiobutton within w_mat_solder_scan_barcode_popup
integer x = 197
integer y = 828
boolean bringtotop = true
integer textsize = -12
string text = "Destroy"
end type

event clicked;call super::clicked;sle_barcode.setfocus()
end event

type rb_nomral from so_radiobutton within w_mat_solder_scan_barcode_popup
integer x = 1957
integer y = 444
boolean bringtotop = true
integer textsize = -12
string text = "Normal"
boolean checked = true
end type

event clicked;call super::clicked;sle_barcode.setfocus()
end event

type rb_cancel from so_radiobutton within w_mat_solder_scan_barcode_popup
integer x = 1957
integer y = 680
boolean bringtotop = true
integer textsize = -12
string text = "Cancel"
end type

event clicked;call super::clicked;sle_barcode.setfocus()
end event

type st_1 from so_statictext within w_mat_solder_scan_barcode_popup
integer x = 174
integer y = 1344
boolean bringtotop = true
string text = "Barcode"
alignment alignment = right!
end type

type sle_line from singlelineedit within w_mat_solder_scan_barcode_popup
integer x = 759
integer y = 1104
integer width = 1632
integer height = 152
integer taborder = 20
boolean bringtotop = true
integer textsize = -20
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

event modified;sle_barcode.setfocus()
end event

type st_2 from so_statictext within w_mat_solder_scan_barcode_popup
integer x = 174
integer y = 1136
boolean bringtotop = true
string text = "Line / Show Case"
alignment alignment = right!
end type

type rb_reissue from so_radiobutton within w_mat_solder_scan_barcode_popup
integer x = 1001
integer y = 500
boolean bringtotop = true
integer textsize = -12
string text = "Re-Issue"
end type

event clicked;call super::clicked;sle_barcode.setfocus()
end event

type gb_1 from so_groupbox within w_mat_solder_scan_barcode_popup
integer x = 32
integer y = 240
integer width = 1723
integer height = 736
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_mat_solder_scan_barcode_popup
integer x = 1774
integer y = 244
integer width = 864
integer height = 732
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_3 from so_groupbox within w_mat_solder_scan_barcode_popup
integer x = 32
integer y = 1020
integer width = 2619
integer height = 480
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


HA$PBExportHeader$w_smt_check_material_position_popup.srw
forward
global type w_smt_check_material_position_popup from w_popup_root
end type
type gb_2 from so_groupbox within w_smt_check_material_position_popup
end type
type uo_dateset from uo_ymd_calendar within w_smt_check_material_position_popup
end type
type st_1 from so_statictext within w_smt_check_material_position_popup
end type
type sle_line from so_singlelineedit within w_smt_check_material_position_popup
end type
type sle_model from so_singlelineedit within w_smt_check_material_position_popup
end type
type sle_address from so_singlelineedit within w_smt_check_material_position_popup
end type
type sle_item_code from so_singlelineedit within w_smt_check_material_position_popup
end type
type st_2 from so_statictext within w_smt_check_material_position_popup
end type
type st_3 from so_statictext within w_smt_check_material_position_popup
end type
type cb_1 from so_commandbutton within w_smt_check_material_position_popup
end type
type st_4 from so_statictext within w_smt_check_material_position_popup
end type
type st_5 from so_statictext within w_smt_check_material_position_popup
end type
type st_message from so_statictext within w_smt_check_material_position_popup
end type
type rb_normal from so_radiobutton within w_smt_check_material_position_popup
end type
type rb_cancel from so_radiobutton within w_smt_check_material_position_popup
end type
type gb_1 from so_groupbox within w_smt_check_material_position_popup
end type
end forward

global type w_smt_check_material_position_popup from w_popup_root
integer width = 1970
integer height = 2212
string title = "BOM Copy"
gb_2 gb_2
uo_dateset uo_dateset
st_1 st_1
sle_line sle_line
sle_model sle_model
sle_address sle_address
sle_item_code sle_item_code
st_2 st_2
st_3 st_3
cb_1 cb_1
st_4 st_4
st_5 st_5
st_message st_message
rb_normal rb_normal
rb_cancel rb_cancel
gb_1 gb_1
end type
global w_smt_check_material_position_popup w_smt_check_material_position_popup

on w_smt_check_material_position_popup.create
int iCurrent
call super::create
this.gb_2=create gb_2
this.uo_dateset=create uo_dateset
this.st_1=create st_1
this.sle_line=create sle_line
this.sle_model=create sle_model
this.sle_address=create sle_address
this.sle_item_code=create sle_item_code
this.st_2=create st_2
this.st_3=create st_3
this.cb_1=create cb_1
this.st_4=create st_4
this.st_5=create st_5
this.st_message=create st_message
this.rb_normal=create rb_normal
this.rb_cancel=create rb_cancel
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_2
this.Control[iCurrent+2]=this.uo_dateset
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_line
this.Control[iCurrent+5]=this.sle_model
this.Control[iCurrent+6]=this.sle_address
this.Control[iCurrent+7]=this.sle_item_code
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.st_message
this.Control[iCurrent+14]=this.rb_normal
this.Control[iCurrent+15]=this.rb_cancel
this.Control[iCurrent+16]=this.gb_1
end on

on w_smt_check_material_position_popup.destroy
call super::destroy
destroy(this.gb_2)
destroy(this.uo_dateset)
destroy(this.st_1)
destroy(this.sle_line)
destroy(this.sle_model)
destroy(this.sle_address)
destroy(this.sle_item_code)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_message)
destroy(this.rb_normal)
destroy(this.rb_cancel)
destroy(this.gb_1)
end on

event open;call super::open;sle_line.setfocus()
end event

type p_title from w_popup_root`p_title within w_smt_check_material_position_popup
integer width = 1947
end type

type cb_sort from w_popup_root`cb_sort within w_smt_check_material_position_popup
integer x = 0
integer y = 2432
integer width = 320
integer height = 140
integer taborder = 70
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_smt_check_material_position_popup
boolean visible = true
integer x = 942
integer y = 1968
integer width = 320
integer height = 140
integer taborder = 60
integer weight = 400
end type

type st_msg from w_popup_root`st_msg within w_smt_check_material_position_popup
boolean visible = true
integer y = 200
integer width = 1947
end type

type dw_1 from w_popup_root`dw_1 within w_smt_check_material_position_popup
boolean visible = true
integer y = 2432
integer taborder = 0
boolean titlebar = true
end type

type dw_2 from w_popup_root`dw_2 within w_smt_check_material_position_popup
boolean visible = true
integer y = 2432
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_smt_check_material_position_popup
integer y = 2432
integer taborder = 80
end type

type gb_2 from so_groupbox within w_smt_check_material_position_popup
integer y = 1012
integer width = 1947
integer height = 632
integer textsize = -14
integer weight = 700
long textcolor = 16711680
string text = "Address / Item Code"
end type

type uo_dateset from uo_ymd_calendar within w_smt_check_material_position_popup
integer x = 763
integer y = 520
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_1 from so_statictext within w_smt_check_material_position_popup
integer x = 96
integer y = 504
integer width = 603
integer height = 116
boolean bringtotop = true
integer textsize = -18
string text = "Plan Date"
alignment alignment = right!
end type

type sle_line from so_singlelineedit within w_smt_check_material_position_popup
integer x = 763
integer y = 620
integer width = 887
integer height = 128
integer taborder = 40
boolean bringtotop = true
integer textsize = -18
textcase textcase = upper!
end type

event modified;call super::modified;sle_model.setfocus()
end event

type sle_model from so_singlelineedit within w_smt_check_material_position_popup
integer x = 763
integer y = 752
integer width = 887
integer height = 128
integer taborder = 50
boolean bringtotop = true
integer textsize = -18
textcase textcase = upper!
end type

event modified;call super::modified;sle_address.setfocus()
end event

type sle_address from so_singlelineedit within w_smt_check_material_position_popup
integer x = 777
integer y = 1132
integer width = 887
integer height = 128
integer taborder = 60
boolean bringtotop = true
integer textsize = -18
textcase textcase = upper!
end type

event modified;call super::modified;sle_item_code.setfocus()
st_message.text = "Do Scan Barcode"
end event

type sle_item_code from so_singlelineedit within w_smt_check_material_position_popup
integer x = 777
integer y = 1268
integer width = 887
integer height = 128
integer taborder = 70
boolean bringtotop = true
integer textsize = -18
textcase textcase = upper!
end type

event modified;call super::modified;sle_address.setfocus()
string lvs_plan_date , lvs_model_name ,  lvs_line_code , lvs_address , lvs_barcode , lvs_deficit 
string lvs_return

lvs_plan_date = string( uo_dateset.text() , 'YYYYMMDD')
lvs_model_name = sle_model.text
lvs_line_code = sle_line.text 
lvs_address = sle_address.text
lvs_barcode = sle_item_code.text

if rb_normal.checked = true then 
	lvs_deficit = '3'
else
	lvs_deficit = '4'	
end if 

lvs_return = STRING( '','@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@')
SQLCA.P_CHECK_PDA_SCAN( lvs_plan_date , lvs_model_name , lvs_line_code  , lvs_address , lvs_barcode , lvs_deficit , ref lvs_return )  ;

st_message.text = lvs_return 

if lvs_return = 'OK' then 
	f_play_sound("Kittingok.wav")
else
	f_play_sound("scanfailed.wav")	
end if 
	
sle_address.text = ''
sle_item_code.text = ''

end event

type st_2 from so_statictext within w_smt_check_material_position_popup
integer x = 96
integer y = 640
integer width = 603
integer height = 104
boolean bringtotop = true
integer textsize = -16
string text = "Line Code"
alignment alignment = right!
end type

type st_3 from so_statictext within w_smt_check_material_position_popup
integer x = 96
integer y = 764
integer width = 603
integer height = 104
boolean bringtotop = true
integer textsize = -16
string text = "Model Name"
alignment alignment = right!
end type

type cb_1 from so_commandbutton within w_smt_check_material_position_popup
integer x = 594
integer y = 1968
integer width = 320
integer height = 140
integer taborder = 70
boolean bringtotop = true
string text = "Reset"
end type

event clicked;call super::clicked;sle_line.setfocus()
sle_line.text = ''
sle_model.text = ''
sle_address.text = ''
sle_item_code.text = ''
end event

type st_4 from so_statictext within w_smt_check_material_position_popup
integer x = 119
integer y = 1156
integer width = 603
integer height = 104
boolean bringtotop = true
integer textsize = -16
string text = "Address"
alignment alignment = right!
end type

type st_5 from so_statictext within w_smt_check_material_position_popup
integer x = 119
integer y = 1280
integer width = 603
integer height = 104
boolean bringtotop = true
integer textsize = -16
string text = "Barcode"
alignment alignment = right!
end type

type st_message from so_statictext within w_smt_check_material_position_popup
integer x = 5
integer y = 1648
integer width = 1947
integer height = 304
boolean bringtotop = true
integer textsize = -22
long backcolor = 65535
end type

type rb_normal from so_radiobutton within w_smt_check_material_position_popup
integer x = 379
integer y = 1476
integer height = 104
boolean bringtotop = true
integer textsize = -20
string text = "Normal"
boolean checked = true
end type

event clicked;call super::clicked;sle_address.setfocus()
end event

type rb_cancel from so_radiobutton within w_smt_check_material_position_popup
integer x = 1042
integer y = 1472
integer height = 104
boolean bringtotop = true
integer textsize = -20
long textcolor = 255
string text = "Cancel"
end type

event clicked;call super::clicked;sle_address.setfocus()
end event

type gb_1 from so_groupbox within w_smt_check_material_position_popup
integer y = 328
integer width = 1947
integer height = 648
integer taborder = 40
integer textsize = -14
integer weight = 700
long textcolor = 16711680
string text = "Line / Model"
end type


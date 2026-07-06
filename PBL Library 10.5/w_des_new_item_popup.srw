HA$PBExportHeader$w_des_new_item_popup.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_des_new_item_popup from w_popup_root
end type
type cbx_product_class from so_checkbox within w_des_new_item_popup
end type
type cbx_raw_material from so_checkbox within w_des_new_item_popup
end type
type cbx_3 from so_checkbox within w_des_new_item_popup
end type
type cbx_4 from so_checkbox within w_des_new_item_popup
end type
type cbx_user_define from so_checkbox within w_des_new_item_popup
end type
type em_serial from editmask within w_des_new_item_popup
end type
type ddlb_item_division from uo_item_division within w_des_new_item_popup
end type
type ddlb_line_type from uo_line_type within w_des_new_item_popup
end type
type sle_user_define from so_singlelineedit within w_des_new_item_popup
end type
type sle_item_code from so_singlelineedit within w_des_new_item_popup
end type
type st_1 from so_statictext within w_des_new_item_popup
end type
type cb_1 from so_commandbutton within w_des_new_item_popup
end type
type ddlb_raw_material from uo_item_class_code_name within w_des_new_item_popup
end type
type ddlb_product_class from uo_product_class_code_name within w_des_new_item_popup
end type
type cb_2 from so_commandbutton within w_des_new_item_popup
end type
type cb_3 from so_commandbutton within w_des_new_item_popup
end type
type st_2 from statictext within w_des_new_item_popup
end type
type cbx_1 from so_checkbox within w_des_new_item_popup
end type
type gb_1 from so_groupbox within w_des_new_item_popup
end type
type gb_2 from so_groupbox within w_des_new_item_popup
end type
type gb_3 from so_groupbox within w_des_new_item_popup
end type
type gb_4 from so_groupbox within w_des_new_item_popup
end type
type gb_5 from so_groupbox within w_des_new_item_popup
end type
type gb_6 from so_groupbox within w_des_new_item_popup
end type
type gb_7 from so_groupbox within w_des_new_item_popup
end type
type gb_8 from so_groupbox within w_des_new_item_popup
end type
end forward

global type w_des_new_item_popup from w_popup_root
integer width = 2894
integer height = 1432
cbx_product_class cbx_product_class
cbx_raw_material cbx_raw_material
cbx_3 cbx_3
cbx_4 cbx_4
cbx_user_define cbx_user_define
em_serial em_serial
ddlb_item_division ddlb_item_division
ddlb_line_type ddlb_line_type
sle_user_define sle_user_define
sle_item_code sle_item_code
st_1 st_1
cb_1 cb_1
ddlb_raw_material ddlb_raw_material
ddlb_product_class ddlb_product_class
cb_2 cb_2
cb_3 cb_3
st_2 st_2
cbx_1 cbx_1
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_6 gb_6
gb_7 gb_7
gb_8 gb_8
end type
global w_des_new_item_popup w_des_new_item_popup

on w_des_new_item_popup.create
int iCurrent
call super::create
this.cbx_product_class=create cbx_product_class
this.cbx_raw_material=create cbx_raw_material
this.cbx_3=create cbx_3
this.cbx_4=create cbx_4
this.cbx_user_define=create cbx_user_define
this.em_serial=create em_serial
this.ddlb_item_division=create ddlb_item_division
this.ddlb_line_type=create ddlb_line_type
this.sle_user_define=create sle_user_define
this.sle_item_code=create sle_item_code
this.st_1=create st_1
this.cb_1=create cb_1
this.ddlb_raw_material=create ddlb_raw_material
this.ddlb_product_class=create ddlb_product_class
this.cb_2=create cb_2
this.cb_3=create cb_3
this.st_2=create st_2
this.cbx_1=create cbx_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_6=create gb_6
this.gb_7=create gb_7
this.gb_8=create gb_8
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_product_class
this.Control[iCurrent+2]=this.cbx_raw_material
this.Control[iCurrent+3]=this.cbx_3
this.Control[iCurrent+4]=this.cbx_4
this.Control[iCurrent+5]=this.cbx_user_define
this.Control[iCurrent+6]=this.em_serial
this.Control[iCurrent+7]=this.ddlb_item_division
this.Control[iCurrent+8]=this.ddlb_line_type
this.Control[iCurrent+9]=this.sle_user_define
this.Control[iCurrent+10]=this.sle_item_code
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.cb_1
this.Control[iCurrent+13]=this.ddlb_raw_material
this.Control[iCurrent+14]=this.ddlb_product_class
this.Control[iCurrent+15]=this.cb_2
this.Control[iCurrent+16]=this.cb_3
this.Control[iCurrent+17]=this.st_2
this.Control[iCurrent+18]=this.cbx_1
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_2
this.Control[iCurrent+21]=this.gb_3
this.Control[iCurrent+22]=this.gb_4
this.Control[iCurrent+23]=this.gb_5
this.Control[iCurrent+24]=this.gb_6
this.Control[iCurrent+25]=this.gb_7
this.Control[iCurrent+26]=this.gb_8
end on

on w_des_new_item_popup.destroy
call super::destroy
destroy(this.cbx_product_class)
destroy(this.cbx_raw_material)
destroy(this.cbx_3)
destroy(this.cbx_4)
destroy(this.cbx_user_define)
destroy(this.em_serial)
destroy(this.ddlb_item_division)
destroy(this.ddlb_line_type)
destroy(this.sle_user_define)
destroy(this.sle_item_code)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.ddlb_raw_material)
destroy(this.ddlb_product_class)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.st_2)
destroy(this.cbx_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_6)
destroy(this.gb_7)
destroy(this.gb_8)
end on

event open;call super::open;ddlb_product_class.setfocus( )
end event

type p_title from w_popup_root`p_title within w_des_new_item_popup
integer width = 2880
end type

type cb_sort from w_popup_root`cb_sort within w_des_new_item_popup
integer x = 672
integer y = 1968
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_des_new_item_popup
boolean visible = true
integer x = 955
integer y = 1968
integer taborder = 0
end type

type st_msg from w_popup_root`st_msg within w_des_new_item_popup
integer y = 204
integer width = 2880
end type

type dw_1 from w_popup_root`dw_1 within w_des_new_item_popup
integer x = 123
integer y = 2032
integer taborder = 0
end type

type dw_2 from w_popup_root`dw_2 within w_des_new_item_popup
integer x = 123
integer y = 2032
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_des_new_item_popup
integer x = 123
integer y = 2032
integer taborder = 0
end type

type cbx_product_class from so_checkbox within w_des_new_item_popup
integer x = 142
integer y = 544
boolean bringtotop = true
integer weight = 700
string text = "Product Class"
boolean checked = true
end type

type cbx_raw_material from so_checkbox within w_des_new_item_popup
integer x = 1074
integer y = 544
boolean bringtotop = true
integer weight = 700
string text = "Raw Material"
boolean checked = true
end type

type cbx_3 from so_checkbox within w_des_new_item_popup
integer x = 2030
integer y = 540
boolean bringtotop = true
integer weight = 700
string text = "Item Division"
boolean checked = true
end type

type cbx_4 from so_checkbox within w_des_new_item_popup
integer x = 133
integer y = 844
boolean bringtotop = true
integer weight = 700
string text = "Line Type"
boolean checked = true
end type

type cbx_user_define from so_checkbox within w_des_new_item_popup
integer x = 1074
integer y = 844
boolean bringtotop = true
integer weight = 700
string text = "User Define"
boolean checked = true
end type

type em_serial from editmask within w_des_new_item_popup
integer x = 2167
integer y = 988
integer width = 402
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "000"
boolean spin = true
double increment = 1
string minmax = "1~~999"
end type

type ddlb_item_division from uo_item_division within w_des_new_item_popup
integer x = 2075
integer y = 672
integer width = 594
integer taborder = 30
boolean bringtotop = true
boolean allowedit = false
boolean autohscroll = true
boolean hscrollbar = true
end type

type ddlb_line_type from uo_line_type within w_des_new_item_popup
integer x = 146
integer y = 1000
integer width = 667
integer height = 356
integer taborder = 40
boolean bringtotop = true
boolean allowedit = false
boolean autohscroll = true
boolean hscrollbar = true
end type

type sle_user_define from so_singlelineedit within w_des_new_item_popup
integer x = 1102
integer y = 1000
integer width = 654
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
integer limit = 2
end type

type sle_item_code from so_singlelineedit within w_des_new_item_popup
integer x = 585
integer y = 380
integer width = 846
boolean bringtotop = true
end type

type st_1 from so_statictext within w_des_new_item_popup
integer x = 101
integer y = 392
integer width = 439
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
alignment alignment = right!
end type

type cb_1 from so_commandbutton within w_des_new_item_popup
integer x = 1655
integer y = 372
integer width = 375
integer height = 100
integer taborder = 60
boolean bringtotop = true
string text = "Generate"
end type

event clicked;call super::clicked;
string lvs_item_gen  , lvs_serial

 select max( substr(item_code , 1, length(item_code) - 3 ) )
    into :lvs_serial
   from id_item 
 where item_code = :lvs_item_gen
 and organization_id = :gvi_organization_id ;
 
 if f_sql_check() < 0 then 
	return -1
end if 

if isnull(lvs_serial) or sqlca.sqlnrows = 0  then 
	lvs_serial = '001'
	em_serial.text = lvs_serial
else
	em_serial.text = lvs_serial
	
end if 


sle_item_code.text  = UPPER(ddlb_product_class.getcode() + ddlb_raw_material.getcode() + ddlb_item_division.getcode( ) + ddlb_line_type.getcode( ) + sle_user_define.text + lvs_serial)
end event

type ddlb_raw_material from uo_item_class_code_name within w_des_new_item_popup
integer x = 1102
integer y = 672
integer width = 663
integer taborder = 20
boolean bringtotop = true
boolean allowedit = false
boolean autohscroll = true
boolean hscrollbar = true
end type

type ddlb_product_class from uo_product_class_code_name within w_des_new_item_popup
integer x = 151
integer y = 672
integer width = 658
boolean bringtotop = true
boolean allowedit = false
boolean autohscroll = true
boolean hscrollbar = true
end type

type cb_2 from so_commandbutton within w_des_new_item_popup
integer x = 2409
integer y = 372
integer width = 375
integer height = 100
boolean bringtotop = true
string text = "Close"
end type

event clicked;call super::clicked;Gst_return.gvb_return = false 
close( parent )
end event

type cb_3 from so_commandbutton within w_des_new_item_popup
integer x = 2030
integer y = 372
integer width = 375
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "OK"
end type

event clicked;call super::clicked;Gst_return.gvb_return = true
message.stringparm = sle_item_code.text

closewithreturn( parent , message.stringparm )
end event

type st_2 from statictext within w_des_new_item_popup
integer x = 1221
integer y = 1160
integer width = 411
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "2 Digit"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_1 from so_checkbox within w_des_new_item_popup
integer x = 2048
integer y = 844
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Serial No"
boolean checked = true
end type

type gb_1 from so_groupbox within w_des_new_item_popup
integer x = 50
integer y = 552
integer width = 891
integer height = 292
end type

type gb_2 from so_groupbox within w_des_new_item_popup
integer x = 997
integer y = 552
integer width = 891
integer height = 292
end type

type gb_3 from so_groupbox within w_des_new_item_popup
integer x = 50
integer y = 856
integer width = 891
end type

type gb_4 from so_groupbox within w_des_new_item_popup
integer x = 1934
integer y = 552
integer width = 891
integer height = 292
end type

type gb_5 from so_groupbox within w_des_new_item_popup
integer x = 997
integer y = 856
integer width = 891
end type

type gb_6 from so_groupbox within w_des_new_item_popup
integer x = 1934
integer y = 856
integer width = 891
end type

type gb_7 from so_groupbox within w_des_new_item_popup
integer x = 55
integer y = 296
integer width = 1417
integer height = 220
end type

type gb_8 from so_groupbox within w_des_new_item_popup
integer x = 1614
integer y = 300
integer width = 1211
integer height = 220
end type


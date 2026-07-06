HA$PBExportHeader$w_product_material_tracking_history_rpt.srw
$PBExportComments$new a led project
forward
global type w_product_material_tracking_history_rpt from w_main_root
end type
type st_5 from so_statictext within w_product_material_tracking_history_rpt
end type
type sle_serial_no from so_singlelineedit within w_product_material_tracking_history_rpt
end type
type st_2 from statictext within w_product_material_tracking_history_rpt
end type
type uo_dateend from uo_ymd_calendar within w_product_material_tracking_history_rpt
end type
type uo_dateset from uo_ymd_calendar within w_product_material_tracking_history_rpt
end type
type st_1 from so_statictext within w_product_material_tracking_history_rpt
end type
type sle_set_item_code from so_singlelineedit within w_product_material_tracking_history_rpt
end type
type st_4 from statictext within w_product_material_tracking_history_rpt
end type
type sle_item_code from so_singlelineedit within w_product_material_tracking_history_rpt
end type
type st_6 from statictext within w_product_material_tracking_history_rpt
end type
type ddlb_customer_code from uo_customer_code_name within w_product_material_tracking_history_rpt
end type
type st_7 from statictext within w_product_material_tracking_history_rpt
end type
type st_8 from statictext within w_product_material_tracking_history_rpt
end type
type sle_lot_id from so_singlelineedit within w_product_material_tracking_history_rpt
end type
type lb_lot_id from listbox within w_product_material_tracking_history_rpt
end type
type cb_2 from so_commandbutton within w_product_material_tracking_history_rpt
end type
type cb_1 from so_commandbutton within w_product_material_tracking_history_rpt
end type
type rb_like from so_radiobutton within w_product_material_tracking_history_rpt
end type
type rb_2 from so_radiobutton within w_product_material_tracking_history_rpt
end type
type rb_multi_serial from so_radiobutton within w_product_material_tracking_history_rpt
end type
type sle_1 from so_singlelineedit within w_product_material_tracking_history_rpt
end type
type st_3 from statictext within w_product_material_tracking_history_rpt
end type
type cb_3 from so_commandbutton within w_product_material_tracking_history_rpt
end type
type cb_4 from so_commandbutton within w_product_material_tracking_history_rpt
end type
type dw_6 from datawindow within w_product_material_tracking_history_rpt
end type
type cb_5 from so_commandbutton within w_product_material_tracking_history_rpt
end type
type rb_vendor_lot from so_radiobutton within w_product_material_tracking_history_rpt
end type
type sle_vendor_lot from so_singlelineedit within w_product_material_tracking_history_rpt
end type
type st_9 from statictext within w_product_material_tracking_history_rpt
end type
type dw_7 from datawindow within w_product_material_tracking_history_rpt
end type
type cb_8 from so_commandbutton within w_product_material_tracking_history_rpt
end type
type cb_6 from so_commandbutton within w_product_material_tracking_history_rpt
end type
type cb_7 from so_commandbutton within w_product_material_tracking_history_rpt
end type
type gb_1 from so_groupbox within w_product_material_tracking_history_rpt
end type
type gb_2 from so_groupbox within w_product_material_tracking_history_rpt
end type
end forward

global type w_product_material_tracking_history_rpt from w_main_root
integer width = 5870
string title = "Material Tracking Query(History)"
st_5 st_5
sle_serial_no sle_serial_no
st_2 st_2
uo_dateend uo_dateend
uo_dateset uo_dateset
st_1 st_1
sle_set_item_code sle_set_item_code
st_4 st_4
sle_item_code sle_item_code
st_6 st_6
ddlb_customer_code ddlb_customer_code
st_7 st_7
st_8 st_8
sle_lot_id sle_lot_id
lb_lot_id lb_lot_id
cb_2 cb_2
cb_1 cb_1
rb_like rb_like
rb_2 rb_2
rb_multi_serial rb_multi_serial
sle_1 sle_1
st_3 st_3
cb_3 cb_3
cb_4 cb_4
dw_6 dw_6
cb_5 cb_5
rb_vendor_lot rb_vendor_lot
sle_vendor_lot sle_vendor_lot
st_9 st_9
dw_7 dw_7
cb_8 cb_8
cb_6 cb_6
cb_7 cb_7
gb_1 gb_1
gb_2 gb_2
end type
global w_product_material_tracking_history_rpt w_product_material_tracking_history_rpt

type variables

end variables

on w_product_material_tracking_history_rpt.create
int iCurrent
call super::create
this.st_5=create st_5
this.sle_serial_no=create sle_serial_no
this.st_2=create st_2
this.uo_dateend=create uo_dateend
this.uo_dateset=create uo_dateset
this.st_1=create st_1
this.sle_set_item_code=create sle_set_item_code
this.st_4=create st_4
this.sle_item_code=create sle_item_code
this.st_6=create st_6
this.ddlb_customer_code=create ddlb_customer_code
this.st_7=create st_7
this.st_8=create st_8
this.sle_lot_id=create sle_lot_id
this.lb_lot_id=create lb_lot_id
this.cb_2=create cb_2
this.cb_1=create cb_1
this.rb_like=create rb_like
this.rb_2=create rb_2
this.rb_multi_serial=create rb_multi_serial
this.sle_1=create sle_1
this.st_3=create st_3
this.cb_3=create cb_3
this.cb_4=create cb_4
this.dw_6=create dw_6
this.cb_5=create cb_5
this.rb_vendor_lot=create rb_vendor_lot
this.sle_vendor_lot=create sle_vendor_lot
this.st_9=create st_9
this.dw_7=create dw_7
this.cb_8=create cb_8
this.cb_6=create cb_6
this.cb_7=create cb_7
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.sle_serial_no
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.uo_dateend
this.Control[iCurrent+5]=this.uo_dateset
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.sle_set_item_code
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.sle_item_code
this.Control[iCurrent+10]=this.st_6
this.Control[iCurrent+11]=this.ddlb_customer_code
this.Control[iCurrent+12]=this.st_7
this.Control[iCurrent+13]=this.st_8
this.Control[iCurrent+14]=this.sle_lot_id
this.Control[iCurrent+15]=this.lb_lot_id
this.Control[iCurrent+16]=this.cb_2
this.Control[iCurrent+17]=this.cb_1
this.Control[iCurrent+18]=this.rb_like
this.Control[iCurrent+19]=this.rb_2
this.Control[iCurrent+20]=this.rb_multi_serial
this.Control[iCurrent+21]=this.sle_1
this.Control[iCurrent+22]=this.st_3
this.Control[iCurrent+23]=this.cb_3
this.Control[iCurrent+24]=this.cb_4
this.Control[iCurrent+25]=this.dw_6
this.Control[iCurrent+26]=this.cb_5
this.Control[iCurrent+27]=this.rb_vendor_lot
this.Control[iCurrent+28]=this.sle_vendor_lot
this.Control[iCurrent+29]=this.st_9
this.Control[iCurrent+30]=this.dw_7
this.Control[iCurrent+31]=this.cb_8
this.Control[iCurrent+32]=this.cb_6
this.Control[iCurrent+33]=this.cb_7
this.Control[iCurrent+34]=this.gb_1
this.Control[iCurrent+35]=this.gb_2
end on

on w_product_material_tracking_history_rpt.destroy
call super::destroy
destroy(this.st_5)
destroy(this.sle_serial_no)
destroy(this.st_2)
destroy(this.uo_dateend)
destroy(this.uo_dateset)
destroy(this.st_1)
destroy(this.sle_set_item_code)
destroy(this.st_4)
destroy(this.sle_item_code)
destroy(this.st_6)
destroy(this.ddlb_customer_code)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.sle_lot_id)
destroy(this.lb_lot_id)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.rb_like)
destroy(this.rb_2)
destroy(this.rb_multi_serial)
destroy(this.sle_1)
destroy(this.st_3)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.dw_6)
destroy(this.cb_5)
destroy(this.rb_vendor_lot)
destroy(this.sle_vendor_lot)
destroy(this.st_9)
destroy(this.dw_7)
destroy(this.cb_8)
destroy(this.cb_6)
destroy(this.cb_7)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = True  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property 
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('REPORT' , TRUE)  // All Data Control
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


end event

event ue_data_control;call super::ue_data_control;long i 
string lvas_lot_id[]  , lvas_serial_no[] , lvs_lot_id
CHOOSE CASE Gvs_Ue_DATA_control
		
	CASE 'RETRIEVE'
					

				
				if rb_like.checked = true then 
					
					DW_1.RETRIEVE( sle_serial_no.TEXT+'%' , sle_lot_id.text+'%',  sle_set_item_code.text+'%' , sle_item_code.text+'%' , uo_dateset.text() , uo_dateend.text() ,   ddlb_customer_code.getcode( )+'%'  , GVI_ORGANIZATION_ID )			
	
				elseif rb_2.checked = true then 
					
						if lb_lot_id.totalitems( ) = 0 then 
							return 
						end if 
						do
							i++
							lvas_lot_id[i] =  lb_lot_id.text(i)
						loop until i = lb_lot_id.totalitems( )

						if  lvas_lot_id[1] = '' OR isnull(  lvas_lot_id[1] )   then 
						
						else
						
							DW_2.RESET()
							DW_2.RETRIEVE( sle_serial_no.TEXT+'%' ,lvas_lot_id,  sle_set_item_code.text+'%' , sle_item_code.text+'%' , uo_dateset.text() , uo_dateend.text() ,   ddlb_customer_code.getcode( )+'%'  , GVI_ORGANIZATION_ID )
						
						END IF 
					//==============================================================	
				elseif rb_multi_serial.checked = true then 

						if dw_6.rowcount() = 0 then 
								return 
							end if 
							
							do
								i++
								lvas_serial_no[i] = string( dw_6.object.serial_no[i] )
							loop until i =dw_6.rowcount()
					
						
							if  lvas_serial_no[1] = '' OR isnull(  lvas_serial_no[1] )   then 
							
							else
							
								DW_3.RESET()
								DW_3.RETRIEVE( lvas_serial_no  , sle_lot_id.text+'%' ,  sle_set_item_code.text+'%' , sle_item_code.text+'%' , uo_dateset.text() , uo_dateend.text() ,   ddlb_customer_code.getcode( )+'%'  , GVI_ORGANIZATION_ID )
							
							end if 		
							
				else
					
							if dw_7.rowcount() = 0 then 
								return 
							end if 
							i = 0 
							do
								i++
								lvas_serial_no[i] = string( dw_7.object.serial_no[i] )
							loop until i =dw_7.rowcount()
					
						
							if  lvas_serial_no[1] = '' OR isnull(  lvas_serial_no[1] )   then 
							
							else
							
							DW_4.RESET()
							DW_4.RETRIEVE( sle_serial_no.TEXT+'%' ,lvas_serial_no,  sle_set_item_code.text+'%' , sle_item_code.text+'%' , uo_dateset.text() , uo_dateend.text() ,   ddlb_customer_code.getcode( )+'%'  , GVI_ORGANIZATION_ID )
						
							end if 	
			   end if 
	CASE ELSE
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_product_material_tracking_history_rpt
integer y = 528
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_product_material_tracking_history_rpt
integer y = 524
integer width = 2203
integer height = 1276
integer taborder = 0
boolean titlebar = true
string title = "Vendor Lot"
string dataobject = "d_ip_product_material_tracking_kfc_vendor_multi_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_product_material_tracking_history_rpt
integer y = 524
integer width = 2880
integer height = 1356
integer taborder = 0
boolean titlebar = true
string title = "Multi Serial No"
string dataobject = "d_ip_product_material_tracking_kfc_serial_multi_rpt"
boolean controlmenu = true
boolean minbox = true
end type

type dw_2 from w_main_root`dw_2 within w_product_material_tracking_history_rpt
integer y = 524
integer width = 4306
integer height = 1356
integer taborder = 0
boolean titlebar = true
string title = "Multi Material MFS"
string dataobject = "d_ip_product_material_tracking_kfc_multi_rpt"
boolean controlmenu = true
boolean minbox = true
end type

type dw_1 from w_main_root`dw_1 within w_product_material_tracking_history_rpt
integer y = 524
integer width = 5189
integer height = 1356
integer taborder = 0
boolean titlebar = true
string title = "Single"
string dataobject = "d_ip_product_material_tracking_kfc_rpt"
boolean controlmenu = true
boolean minbox = true
end type

type uo_tabpages from w_main_root`uo_tabpages within w_product_material_tracking_history_rpt
integer taborder = 0
end type

type st_5 from so_statictext within w_product_material_tracking_history_rpt
integer x = 2162
integer y = 288
integer width = 809
integer height = 196
boolean bringtotop = true
integer textsize = -10
long textcolor = 255
string text = "Reflow (W50) $$HEX41$$f5ac15c844c72000b5d1fcac5cd52000dcc204ac44c7200030ae00c93cc75cb8200074d5f9b22000dcc204ac00b3d0c520003cd554b3d0c5200078ac24b888c794b2200090c7acc720007cb9200070c88cd6$$ENDHEX$$"
alignment alignment = left!
end type

type sle_serial_no from so_singlelineedit within w_product_material_tracking_history_rpt
integer x = 1312
integer y = 380
integer width = 818
integer height = 84
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

type st_2 from statictext within w_product_material_tracking_history_rpt
integer x = 786
integer y = 392
integer width = 498
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
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_dateend from uo_ymd_calendar within w_product_material_tracking_history_rpt
event destroy ( )
integer x = 2583
integer y = 176
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateset from uo_ymd_calendar within w_product_material_tracking_history_rpt
event destroy ( )
integer x = 2153
integer y = 176
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_1 from so_statictext within w_product_material_tracking_history_rpt
integer x = 2158
integer y = 80
integer width = 832
integer height = 68
boolean bringtotop = true
string text = "Date"
end type

type sle_set_item_code from so_singlelineedit within w_product_material_tracking_history_rpt
integer x = 1312
integer y = 176
integer width = 818
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
end type

type st_4 from statictext within w_product_material_tracking_history_rpt
integer x = 786
integer y = 188
integer width = 498
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Set Item Code"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_item_code from so_singlelineedit within w_product_material_tracking_history_rpt
integer x = 1312
integer y = 280
integer width = 818
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
end type

type st_6 from statictext within w_product_material_tracking_history_rpt
integer x = 786
integer y = 280
integer width = 498
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Item Code"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_customer_code from uo_customer_code_name within w_product_material_tracking_history_rpt
integer x = 1312
integer y = 72
integer width = 818
integer taborder = 30
boolean bringtotop = true
boolean autohscroll = true
boolean hscrollbar = true
end type

type st_7 from statictext within w_product_material_tracking_history_rpt
integer x = 786
integer y = 84
integer width = 498
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Customer Code"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_8 from statictext within w_product_material_tracking_history_rpt
integer x = 3835
integer y = 20
integer width = 594
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Material MFS"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_lot_id from so_singlelineedit within w_product_material_tracking_history_rpt
integer x = 3840
integer y = 96
integer width = 594
integer height = 84
integer taborder = 11
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;lb_lot_id.additem(this.text)
this.text = ''
end event

type lb_lot_id from listbox within w_product_material_tracking_history_rpt
integer x = 3840
integer y = 184
integer width = 594
integer height = 200
integer taborder = 21
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type cb_2 from so_commandbutton within w_product_material_tracking_history_rpt
integer x = 3840
integer y = 400
integer width = 297
integer height = 92
integer taborder = 31
boolean bringtotop = true
string text = "Delete"
end type

event clicked;call super::clicked;lb_lot_id.deleteitem(lb_lot_id.selectedindex( ) )
end event

type cb_1 from so_commandbutton within w_product_material_tracking_history_rpt
integer x = 4137
integer y = 400
integer width = 297
integer height = 92
integer taborder = 21
boolean bringtotop = true
string text = "Reset"
end type

event clicked;call super::clicked;lb_lot_id.reset( )
end event

type rb_like from so_radiobutton within w_product_material_tracking_history_rpt
integer x = 32
integer y = 76
integer width = 485
boolean bringtotop = true
string text = "Like Condition"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type rb_2 from so_radiobutton within w_product_material_tracking_history_rpt
integer x = 32
integer y = 176
integer width = 654
boolean bringtotop = true
string text = "IN Condition (Material MFS)"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type rb_multi_serial from so_radiobutton within w_product_material_tracking_history_rpt
integer x = 32
integer y = 276
integer width = 681
boolean bringtotop = true
string text = "IN Condition (PCB Serial No)"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
end event

type sle_1 from so_singlelineedit within w_product_material_tracking_history_rpt
integer x = 3045
integer y = 96
integer width = 594
integer height = 84
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified; int row 
row = dw_6.insertrow(0) 
dw_6.object.serial_no[row] = this.text
this.text = ''
end event

type st_3 from statictext within w_product_material_tracking_history_rpt
integer x = 3045
integer y = 20
integer width = 594
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

type cb_3 from so_commandbutton within w_product_material_tracking_history_rpt
integer x = 3342
integer y = 400
integer width = 297
integer height = 92
integer taborder = 31
boolean bringtotop = true
string text = "Reset"
end type

event clicked;call super::clicked;dw_6.reset( )
end event

type cb_4 from so_commandbutton within w_product_material_tracking_history_rpt
integer x = 3045
integer y = 400
integer width = 297
integer height = 92
integer taborder = 41
boolean bringtotop = true
string text = "Delete"
end type

event clicked;call super::clicked;if dw_6.getrow() = 0 then return 
dw_6.deleterow( dw_6.getrow())
end event

type dw_6 from datawindow within w_product_material_tracking_history_rpt
integer x = 3045
integer y = 184
integer width = 590
integer height = 208
integer taborder = 31
boolean bringtotop = true
string title = "none"
string dataobject = "vd_serial_no"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_5 from so_commandbutton within w_product_material_tracking_history_rpt
integer x = 3639
integer y = 176
integer width = 192
integer height = 224
integer taborder = 41
boolean bringtotop = true
string text = "Paste"
end type

event clicked;call super::clicked;dw_6.importclipboard( )
end event

type rb_vendor_lot from so_radiobutton within w_product_material_tracking_history_rpt
integer x = 32
integer y = 376
integer width = 681
boolean bringtotop = true
string text = "IN Condition (Vendor Lot)"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4
end event

type sle_vendor_lot from so_singlelineedit within w_product_material_tracking_history_rpt
integer x = 4462
integer y = 96
integer width = 594
integer height = 84
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified; int row 
row = dw_7.insertrow(0) 
dw_7.object.serial_no[row] = this.text
this.text = ''
end event

type st_9 from statictext within w_product_material_tracking_history_rpt
integer x = 4471
integer y = 20
integer width = 594
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Vendor Lot"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_7 from datawindow within w_product_material_tracking_history_rpt
integer x = 4457
integer y = 184
integer width = 590
integer height = 208
integer taborder = 41
boolean bringtotop = true
string title = "none"
string dataobject = "vd_serial_no"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_8 from so_commandbutton within w_product_material_tracking_history_rpt
integer x = 5051
integer y = 184
integer width = 192
integer height = 224
integer taborder = 51
boolean bringtotop = true
string text = "Paste"
end type

event clicked;call super::clicked;dw_7.reset()
dw_7.importclipboard()
end event

type cb_6 from so_commandbutton within w_product_material_tracking_history_rpt
integer x = 4768
integer y = 408
integer width = 297
integer height = 92
integer taborder = 41
boolean bringtotop = true
string text = "Reset"
end type

event clicked;call super::clicked;dw_7.reset( )
end event

type cb_7 from so_commandbutton within w_product_material_tracking_history_rpt
integer x = 4471
integer y = 408
integer width = 297
integer height = 92
integer taborder = 41
boolean bringtotop = true
string text = "Delete"
end type

event clicked;call super::clicked;if dw_7.getrow() = 0 then return 
dw_7.deleterow( dw_7.getrow())
end event

type gb_1 from so_groupbox within w_product_material_tracking_history_rpt
integer x = 750
integer width = 2263
integer height = 508
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_product_material_tracking_history_rpt
integer x = 9
integer width = 736
integer height = 512
integer taborder = 41
string text = "Category"
end type


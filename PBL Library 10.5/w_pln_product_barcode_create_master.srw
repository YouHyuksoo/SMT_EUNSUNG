HA$PBExportHeader$w_pln_product_barcode_create_master.srw
$PBExportComments$Line Master
forward
global type w_pln_product_barcode_create_master from w_main_root
end type
type sle_pcb_serial_no from so_singlelineedit within w_pln_product_barcode_create_master
end type
type st_2 from statictext within w_pln_product_barcode_create_master
end type
type sle_magazine_no from so_singlelineedit within w_pln_product_barcode_create_master
end type
type st_5 from statictext within w_pln_product_barcode_create_master
end type
type st_status from so_statictext within w_pln_product_barcode_create_master
end type
type em_count from so_editmask within w_pln_product_barcode_create_master
end type
type st_1 from statictext within w_pln_product_barcode_create_master
end type
type rb_normal from so_radiobutton within w_pln_product_barcode_create_master
end type
type rb_cancel from so_radiobutton within w_pln_product_barcode_create_master
end type
type rb_good from so_radiobutton within w_pln_product_barcode_create_master
end type
type rb_repair from so_radiobutton within w_pln_product_barcode_create_master
end type
type cb_excel from so_commandbutton within w_pln_product_barcode_create_master
end type
type gb_1 from so_groupbox within w_pln_product_barcode_create_master
end type
type gb_2 from so_groupbox within w_pln_product_barcode_create_master
end type
end forward

global type w_pln_product_barcode_create_master from w_main_root
integer width = 5454
integer height = 2748
string title = "Magazine PID Mapping Master"
long backcolor = 16777215
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
sle_magazine_no sle_magazine_no
st_5 st_5
st_status st_status
em_count em_count
st_1 st_1
rb_normal rb_normal
rb_cancel rb_cancel
rb_good rb_good
rb_repair rb_repair
cb_excel cb_excel
gb_1 gb_1
gb_2 gb_2
end type
global w_pln_product_barcode_create_master w_pln_product_barcode_create_master

type variables
Long Lvl_row 

end variables

on w_pln_product_barcode_create_master.create
int iCurrent
call super::create
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_2=create st_2
this.sle_magazine_no=create sle_magazine_no
this.st_5=create st_5
this.st_status=create st_status
this.em_count=create em_count
this.st_1=create st_1
this.rb_normal=create rb_normal
this.rb_cancel=create rb_cancel
this.rb_good=create rb_good
this.rb_repair=create rb_repair
this.cb_excel=create cb_excel
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_pcb_serial_no
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_magazine_no
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.st_status
this.Control[iCurrent+6]=this.em_count
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.rb_normal
this.Control[iCurrent+9]=this.rb_cancel
this.Control[iCurrent+10]=this.rb_good
this.Control[iCurrent+11]=this.rb_repair
this.Control[iCurrent+12]=this.cb_excel
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_pln_product_barcode_create_master.destroy
call super::destroy
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.sle_magazine_no)
destroy(this.st_5)
destroy(this.st_status)
destroy(this.em_count)
destroy(this.st_1)
destroy(this.rb_normal)
destroy(this.rb_cancel)
destroy(this.rb_good)
destroy(this.rb_repair)
destroy(this.cb_excel)
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
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'MASTER_DETAIL_1L2R'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
*  Menu Property
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control




end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
st_status.width = dw_1.width + dw_2.width

sle_magazine_no.setfocus( )
end event

event ue_data_control;call super::ue_data_control;
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
			DW_1.RETRIEVE(  sle_magazine_no.text+'%' ,  GVI_ORGANIZATION_ID )
	
		CASE 'INSERT'
			dw_2.enabled = true
			Lvl_row = dw_2.insertrow(dw_2.getrow())
			dw_2.scrolltorow(Lvl_row)
			f_set_security_row(dw_2 , Lvl_row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )		
			
			
	CASE ELSE
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_barcode_create_master
integer y = 512
integer height = 1648
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_barcode_create_master
integer y = 516
integer height = 1648
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_barcode_create_master
integer y = 528
integer height = 1648
integer taborder = 0
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_barcode_create_master
integer x = 2638
integer y = 492
integer width = 2181
integer height = 1648
integer taborder = 0
string dataobject = "d_pln_product_2d_barcode_create_lst"
borderstyle borderstyle = stylebox!
end type

event dw_2::clicked;call super::clicked;sle_pcb_serial_no.setfocus( )
end event

event dw_2::retrieveend;call super::retrieveend;em_count.text = string(rowcount)
end event

type dw_1 from w_main_root`dw_1 within w_pln_product_barcode_create_master
integer y = 492
integer width = 2633
integer height = 1648
integer taborder = 0
string title = "PCB 2D List"
string dataobject = "d_pln_product_run_card_4_create_lst"
borderstyle borderstyle = stylebox!
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow <= 0 then return 

sle_magazine_no.text = this.object.magazine_label_no[currentrow]
dw_2.retrieve( dw_1.object.magazine_label_no[currentrow] , gvi_organization_id )


sle_pcb_serial_no.setfocus()
end event

event dw_1::clicked;call super::clicked;sle_pcb_serial_no.setfocus()
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_barcode_create_master
integer taborder = 0
end type

type sle_pcb_serial_no from so_singlelineedit within w_pln_product_barcode_create_master
integer x = 654
integer y = 160
integer width = 864
integer taborder = 1
boolean bringtotop = true
textcase textcase = upper!
borderstyle borderstyle = stylebox!
end type

event modified;call super::modified;string lvs_barcode_status , lvs_pid , lvs_magazine_label_no
long ll_row , LVI_PID_EXISTS_CHECK

if sle_magazine_no.text = '' then 
   sle_magazine_no.setfocus()
   this.text = ''
   return 
else
	lvs_magazine_label_no = sle_magazine_no.text
end if 

lvs_pid = sle_pcb_serial_no.text 

if len(LVS_PID) < 10 then 

	f_msg("$$HEX16$$14bc54cfdcb4200015d6ddc274c7200098c7bbba200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$" , "P") 
	sle_pcb_serial_no.text = ''
	sle_pcb_serial_no.setfocus()
	st_status.backcolor = 255 
	return 
else
	st_status.backcolor = rgb( 192,192,192)
end if 

if rb_repair.checked = true then 
	lvs_barcode_status ='R'
ELSE
	lvs_barcode_status = 'N'
END IF 

//=========================================================
//  PID $$HEX9$$74c8acc7200020c734bb2000b4cc6cd02000$$ENDHEX$$
//=========================================================

SELECT COUNT(*) INTO :LVI_PID_EXISTS_CHECK FROM IP_PRODUCT_2D_BARCODE 
WHERE SERIAL_NO = :LVS_PID 
    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	 
IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 

//=========================================================
// $$HEX9$$15c8c1c02000f1b45db878c7bdacb0c62000$$ENDHEX$$
//=========================================================
	
			if rb_normal.checked = true  then 
			
//			         //2D $$HEX11$$14bc54cfdcb400ac200074c8acc7200058d574ba2000$$ENDHEX$$
//					IF LVI_PID_EXISTS_CHECK = 0 THEN 
//						
//						
//						UPDATE IP_PRODUCT_2D_BARCODE SET magazine_no = :lvs_magazine_label_no
//						  WHERE SERIAL_NO = :LVS_PID 
//						      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ; 
//								
//						 IF F_SQL_CHECK() < 0 THEN 
//							RETURN 
//						END IF 
//						
//					ELSE
			
			
						ll_row = dw_2.find ( "serial_no='" + lvs_pid +"'" , 1, dw_2.rowcount() )
						
						//==============================
						// $$HEX18$$74c7f8bb20007dc740c7200070b374c730d17cb920003ecc58c544c72000bdacb0c62000$$ENDHEX$$
						// $$HEX10$$a4c294ce44c7200088d544c72000bdacb0c62000$$ENDHEX$$
						//==============================
						if ll_row > 0  then 
							st_status.text =f_get_dual_lang_text( gvs_language , "Already Exists" )
							
							f_play_sound("kittingfailed.wav")		
							sle_pcb_serial_no.text = ''
							sle_pcb_serial_no.setfocus()
							return 
						end if 
						
						//================================================
						//
						//================================================
						
						f_insert()
						
						
						dw_2.object.serial_no[lvl_row] =lvs_pid
						dw_2.object.run_no[lvl_row] = dw_1.object.run_no[1]
						dw_2.object.model_name[lvl_row] = dw_1.object.model_name[1]
						dw_2.object.model_suffix[lvl_row] = dw_1.object.model_suffix[1] 
						dw_2.object.item_code[lvl_row] =dw_1.object.item_code[1]
						dw_2.object.magazine_no[lvl_row] =dw_1.object.magazine_label_no[1]
							
						dw_2.object.line_code[lvl_row] =dw_1.object.line_code[1]
						dw_2.object.run_date[lvl_row]   =dw_1.object.run_date[1]
						dw_2.object.qc_scan_yn[lvl_row]   ='N'
						dw_2.object.workstage_code[lvl_row] =dw_1.object.workstage_code[1]
						dw_2.object.barcode_status[lvl_row] = lvs_barcode_status
						
						dw_2.object.lot_qty[lvl_row] =1
						
						if dw_2.update() < 0 then 
							Rollback;
							dw_2.retrieve( dw_1.object.magazine_label_no[1] , gvi_organization_id )
							sle_pcb_serial_no.text = ''
							sle_pcb_serial_no.setfocus( )
							return 
						end if 
						commit ;
						em_count.text = string( long(em_count.text) +1 )
						sle_pcb_serial_no.text = ''
						sle_pcb_serial_no.setfocus( )
						
						
			 //    END IF 		
			//==============================================================
			//  $$HEX7$$e8cd8cc178c72000bdacb0c62000$$ENDHEX$$
			//==============================================================
			elseif  rb_cancel.checked = true then 
				
						ll_row = dw_2.find ( "serial_no='" + lvs_pid +"'" , 1, dw_2.rowcount() )
						
						//==============================
						// $$HEX18$$74c7f8bb20007dc740c7200070b374c730d17cb920003ecc58c544c72000bdacb0c62000$$ENDHEX$$
						// $$HEX10$$a4c294ce44c7200088d544c72000bdacb0c62000$$ENDHEX$$
						//==============================
						if ll_row > 0  then 
							
								st_status.text =f_get_dual_lang_text( gvs_language , "Cancel OK" )
								
								dw_2.deleterow( ll_row)
								
								f_play_sound("kittingok.wav")		
								sle_pcb_serial_no.text = ''
								sle_pcb_serial_no.setfocus()
					
								if dw_2.update() < 0 then 
									Rollback;
									dw_2.retrieve( dw_1.object.magazine_label_no[1] , gvi_organization_id )
									sle_pcb_serial_no.text = ''
									sle_pcb_serial_no.setfocus( )
									return 
								end if 	
								em_count.text = string( long(em_count.text) -1 )
								sle_pcb_serial_no.text = ''
								sle_pcb_serial_no.setfocus( )
								commit ;
								
						else
								
								f_msgbox(117)
								sle_pcb_serial_no.text = ''
								sle_pcb_serial_no.setfocus( )
						end if 
			end if 

end event

type st_2 from statictext within w_pln_product_barcode_create_master
integer x = 654
integer y = 80
integer width = 864
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "PCB Serial No"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_magazine_no from so_singlelineedit within w_pln_product_barcode_create_master
integer x = 69
integer y = 160
integer width = 571
boolean bringtotop = true
textcase textcase = upper!
borderstyle borderstyle = stylebox!
end type

event modified;call super::modified;STRING LVS_MAGAZINE_NO

LVS_MAGAZINE_NO = THIS.TEXT 
EM_COUNT.TEXT = '0' 


dw_1.retrieve(  LVS_MAGAZINE_NO , gvi_organization_id )

if dw_1.rowcount( ) < 1 then 
	f_msgbox(117)
	return 
end if 

sle_pcb_serial_no.setfocus( )
st_status.text = "Scan PID"
end event

type st_5 from statictext within w_pln_product_barcode_create_master
integer x = 64
integer y = 76
integer width = 571
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Magazine Label  No"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_status from so_statictext within w_pln_product_barcode_create_master
integer y = 316
integer width = 4818
integer height = 172
boolean bringtotop = true
integer textsize = -22
long textcolor = 0
long backcolor = 134217750
string text = "Message"
boolean border = true
end type

type em_count from so_editmask within w_pln_product_barcode_create_master
integer x = 3099
integer y = 116
integer width = 393
integer height = 172
integer taborder = 10
boolean bringtotop = true
integer textsize = -22
boolean enabled = false
string text = "0"
boolean displayonly = true
string mask = "##0"
end type

type st_1 from statictext within w_pln_product_barcode_create_master
integer x = 3104
integer y = 28
integer width = 389
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "Scan Qty"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_normal from so_radiobutton within w_pln_product_barcode_create_master
integer x = 2368
integer y = 84
integer width = 430
boolean bringtotop = true
long backcolor = 16777215
string text = "Normal"
boolean checked = true
end type

event clicked;call super::clicked;sle_pcb_serial_no.setfocus()
end event

type rb_cancel from so_radiobutton within w_pln_product_barcode_create_master
integer x = 2368
integer y = 184
integer width = 430
boolean bringtotop = true
long backcolor = 16777215
string text = "Cancel"
end type

event clicked;call super::clicked;sle_pcb_serial_no.setfocus()
end event

type rb_good from so_radiobutton within w_pln_product_barcode_create_master
integer x = 1637
integer y = 68
boolean bringtotop = true
long backcolor = 16777215
string text = "Goods"
boolean checked = true
end type

event clicked;call super::clicked;sle_pcb_serial_no.setfocus()
end event

type rb_repair from so_radiobutton within w_pln_product_barcode_create_master
integer x = 1637
integer y = 188
boolean bringtotop = true
long backcolor = 16777215
string text = "Repair"
end type

event clicked;call super::clicked;sle_pcb_serial_no.setfocus()
end event

type cb_excel from so_commandbutton within w_pln_product_barcode_create_master
integer x = 3529
integer y = 120
integer height = 160
integer taborder = 20
boolean bringtotop = true
string text = "Paste Excel"
end type

event clicked;call super::clicked;open(w_pln_2d_baarcode_excel_popup)
end event

type gb_1 from so_groupbox within w_pln_product_barcode_create_master
integer x = 2281
integer width = 553
integer height = 304
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Process"
end type

type gb_2 from so_groupbox within w_pln_product_barcode_create_master
integer x = 9
integer y = 4
integer width = 2258
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Where Condition"
end type


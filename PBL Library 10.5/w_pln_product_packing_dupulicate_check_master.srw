HA$PBExportHeader$w_pln_product_packing_dupulicate_check_master.srw
$PBExportComments$$$HEX17$$b9c278c7d0c658c7a8ba78b3d0c5200000b35cd52000b9d231c144c7200000adacb9$$ENDHEX$$
forward
global type w_pln_product_packing_dupulicate_check_master from w_main_root
end type
type sle_pid from so_singlelineedit within w_pln_product_packing_dupulicate_check_master
end type
type cbx_check_mode from so_checkbox within w_pln_product_packing_dupulicate_check_master
end type
type rb_receipt_wait from so_radiobutton within w_pln_product_packing_dupulicate_check_master
end type
type rb_history from so_radiobutton within w_pln_product_packing_dupulicate_check_master
end type
type rb_inventory from so_radiobutton within w_pln_product_packing_dupulicate_check_master
end type
type em_qty from so_editmask within w_pln_product_packing_dupulicate_check_master
end type
type st_3 from so_statictext within w_pln_product_packing_dupulicate_check_master
end type
type cbx_sound_on from so_checkbox within w_pln_product_packing_dupulicate_check_master
end type
type gb_2 from so_groupbox within w_pln_product_packing_dupulicate_check_master
end type
type gb_5 from so_groupbox within w_pln_product_packing_dupulicate_check_master
end type
type st_status from so_statictext within w_pln_product_packing_dupulicate_check_master
end type
type rb_inventory_sum from so_radiobutton within w_pln_product_packing_dupulicate_check_master
end type
type sle_pack_barcode from so_singlelineedit within w_pln_product_packing_dupulicate_check_master
end type
type st_2 from so_statictext within w_pln_product_packing_dupulicate_check_master
end type
type st_4 from so_statictext within w_pln_product_packing_dupulicate_check_master
end type
type em_ng from so_editmask within w_pln_product_packing_dupulicate_check_master
end type
type st_1 from so_statictext within w_pln_product_packing_dupulicate_check_master
end type
type gb_1 from so_groupbox within w_pln_product_packing_dupulicate_check_master
end type
end forward

global type w_pln_product_packing_dupulicate_check_master from w_main_root
integer width = 6441
integer height = 3332
string title = "Packing Dupulicate Check Master"
long backcolor = 16777215
sle_pid sle_pid
cbx_check_mode cbx_check_mode
rb_receipt_wait rb_receipt_wait
rb_history rb_history
rb_inventory rb_inventory
em_qty em_qty
st_3 st_3
cbx_sound_on cbx_sound_on
gb_2 gb_2
gb_5 gb_5
st_status st_status
rb_inventory_sum rb_inventory_sum
sle_pack_barcode sle_pack_barcode
st_2 st_2
st_4 st_4
em_ng em_ng
st_1 st_1
gb_1 gb_1
end type
global w_pln_product_packing_dupulicate_check_master w_pln_product_packing_dupulicate_check_master

type variables
STRING IVS_LINE_CODE , IVS_WORKSTAGE_CODE , IVS_TYPE
end variables

on w_pln_product_packing_dupulicate_check_master.create
int iCurrent
call super::create
this.sle_pid=create sle_pid
this.cbx_check_mode=create cbx_check_mode
this.rb_receipt_wait=create rb_receipt_wait
this.rb_history=create rb_history
this.rb_inventory=create rb_inventory
this.em_qty=create em_qty
this.st_3=create st_3
this.cbx_sound_on=create cbx_sound_on
this.gb_2=create gb_2
this.gb_5=create gb_5
this.st_status=create st_status
this.rb_inventory_sum=create rb_inventory_sum
this.sle_pack_barcode=create sle_pack_barcode
this.st_2=create st_2
this.st_4=create st_4
this.em_ng=create em_ng
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_pid
this.Control[iCurrent+2]=this.cbx_check_mode
this.Control[iCurrent+3]=this.rb_receipt_wait
this.Control[iCurrent+4]=this.rb_history
this.Control[iCurrent+5]=this.rb_inventory
this.Control[iCurrent+6]=this.em_qty
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.cbx_sound_on
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_5
this.Control[iCurrent+11]=this.st_status
this.Control[iCurrent+12]=this.rb_inventory_sum
this.Control[iCurrent+13]=this.sle_pack_barcode
this.Control[iCurrent+14]=this.st_2
this.Control[iCurrent+15]=this.st_4
this.Control[iCurrent+16]=this.em_ng
this.Control[iCurrent+17]=this.st_1
this.Control[iCurrent+18]=this.gb_1
end on

on w_pln_product_packing_dupulicate_check_master.destroy
call super::destroy
destroy(this.sle_pid)
destroy(this.cbx_check_mode)
destroy(this.rb_receipt_wait)
destroy(this.rb_history)
destroy(this.rb_inventory)
destroy(this.em_qty)
destroy(this.st_3)
destroy(this.cbx_sound_on)
destroy(this.gb_2)
destroy(this.gb_5)
destroy(this.st_status)
destroy(this.rb_inventory_sum)
destroy(this.sle_pack_barcode)
destroy(this.st_2)
destroy(this.st_4)
destroy(this.em_ng)
destroy(this.st_1)
destroy(this.gb_1)
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
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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
st_status.width = dw_1.width
sle_pack_barcode.setfocus()

end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_SETYN
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'

	if rb_receipt_wait.checked = true then
		     dw_1.reset()
			dw_1.RETRIEVE(  sle_pack_barcode.text+'%'  , sle_pid.text + '%' , GVI_ORGANIZATION_ID )
			dw_1.SETFOCUS()
			sle_pid.setfocus()
   elseif rb_history.checked = true then 
			dw_2.reset()
			dw_2.RETRIEVE(  sle_pack_barcode.text+'%'  , sle_pid.text + '%' , GVI_ORGANIZATION_ID )
			dw_2.SETFOCUS()
			sle_pid.setfocus()		

	end if 
//		
//	CASE 'INSERT'
//	
//			row = dw_2.insertrow(dw_2.getrow())
//			dw_2.scrolltorow(row)
//			f_set_security_row(dw_2 , row , 'ALL')
//			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
//	CASE 'APPEND'
//	
//			row = dw_2.insertrow(0)
//			dw_2.scrolltorow(row)
//			f_set_security_row(dw_2 , row , 'ALL')
//			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )	
//	CASE 'DELETE'
//		
//		  	if dw_2.getrow() < 1 then return 
//			  
//			msg =f_msgbox(1003)
//			if msg = 1 then
//				gvl_row_deleted = dw_2.getrow()			
//				dw_2.deleterow(gvl_row_deleted)		
//				dw_2.setfocus()
//				row = dw_2.getrow()
//				dw_2.scrolltorow(row)
//				dw_2.setcolumn(1)
//			end if
			
//	CASE 'UPDATE'
//		
//		dw_2.ACCEPTTEXT()
// 
//	      IF dw_2.UPDATE() < 0 THEN
//				ROLLBACK;
//				RETURN
//		ELSE
//				 COMMIT;
//       			 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
//		END IF
		sle_pid.setfocus()
		
	CASE ELSE
END CHOOSE


end event

type dw_5 from w_main_root`dw_5 within w_pln_product_packing_dupulicate_check_master
integer y = 596
integer taborder = 0
string dataobject = "d_pln_workstage_io_scan_by_current"
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_packing_dupulicate_check_master
integer y = 596
integer width = 4818
integer height = 1164
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_product_workstage_io_inventory_sum_list"
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_packing_dupulicate_check_master
integer y = 596
integer width = 4818
integer height = 1164
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_product_workstage_io_inventory_list"
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_packing_dupulicate_check_master
integer y = 596
integer width = 4818
integer height = 1164
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_product_pack_dupulicate_hst"
borderstyle borderstyle = styleraised!
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_packing_dupulicate_check_master
integer y = 596
integer width = 4841
integer height = 1164
integer taborder = 0
boolean titlebar = true
string title = "Product PID Scan List"
string dataobject = "d_pln_product_pack_dupulicate_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;sle_pid.setfocus()
end event

event dw_1::clicked;call super::clicked;sle_pid.setfocus()
end event

event dw_1::itemchanged;//over 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_packing_dupulicate_check_master
integer taborder = 0
end type

type sle_pid from so_singlelineedit within w_pln_product_packing_dupulicate_check_master
integer x = 1792
integer y = 420
integer width = 1134
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -12
long textcolor = 0
long backcolor = 16777215
end type

event modified;call super::modified;string LVS_PID , LVS_PACK_BARCODE , LVS_CHECK_MSG
long lvl_row

if rb_history.checked = true then 
	return 
end if 


//==================================================
//
//==================================================
LVS_PID = THIS.TEXT  
LVS_PACK_BARCODE = sle_pack_barcode.text
//==================================================
// 
//==================================================
IF LVS_PACK_BARCODE = ''  or LVS_PACK_BARCODE = '%' or isnull(LVS_PACK_BARCODE) THEN 
		f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'PACK BARCODE'))
		sle_pid.text = ''
		RETURN 
END IF 

IF LVS_PID = ''  or LVS_PID = '%' or isnull(LVS_PID) THEN 
	sle_pid.text = ''
	RETURN 
END IF 
st_status.text = "Processing..."
//==================================================
//  $$HEX11$$30ae74c8d0c5200088c794b2c0c92000b4cc6cd02000$$ENDHEX$$
//==================================================	
		SELECT F_GET_PACK_BARCODE_BY_PID(:LVS_PID)
			INTO :LVS_CHECK_MSG 
			FROM DUAL ; 
		
		if f_sql_check() < 0 then 
			return 
		end if 

		//$$HEX16$$30ae74c8d0c52000f1b45db81cb42000b4b0edc574c72000c6c53cc774ba2000$$ENDHEX$$ok 
		if LVS_CHECK_MSG <> 'NOTFOUND' then 
			
			if cbx_check_mode.checked = true then 
				//$$HEX23$$b4cc6cd02000a9ba01c83cc75cb82000a4c294ce20005cd5bdacb0c694b22000a0c7f8adc0c920004ac54cc72000$$ENDHEX$$
				f_msgbox1( 813 , LVS_PID ) 
				cbx_check_mode.checked = false
				sle_pid.text = ''
				sle_pid.setfocus()
				return 
			else
			
					f_play_sound( "Kittingfailed.wav")
					st_status.text = f_msg_st(long(lvs_check_msg)) + ' ' + lvs_pid 
					em_ng.text = string(long(em_ng.text) + 1 )
		
					OPEN(W_LOCK_BY_ADMIN)
					sle_pid.text = ''
					sle_pid.setfocus()
					return 
					
				end if 
		end if 
//===================================================
//
//===================================================
		  INSERT INTO IP_PRODUCT_PACK_SERIAL  
         ( PACK_BARCODE,   
           BARCODE,   
           ATTR1,   
           ATTR2,   
           ATTR3,   
           ATTR4,   
           ATTR5,   
           ATTR6,   
           ATTR7,   
           ATTR8,   
           ATTR9,   
           ATTR10,   
           ATTR11,   
           ATTR12,   
           SCAN_DATE,   
           ORAGANIZATION_ID,   
           ENTER_DATE,   
           ENTER_BY,   
           LAST_MODIFY_DATE,   
           LAST_MODIFY_BY )  
  VALUES (:LVS_PACK_BARCODE,   
           :LVS_PID,   
           '*'  ,    
           '*',   
           '*',   
           '*',   
           '*',   
           '*',   
           '*',   
           '*',   
           '*',   
           '*',   
           '*',   
           '*',   
           SYSDATE,   
           :GVI_ORGANIZATION_ID,   
           SYSDATE,   
           :GVS_USER_ID,   
           SYSDATE,   
           :GVS_USER_ID )  ;

		if f_sql_check() < 0 then 
			sle_pid.text = ''
			sle_pid.setfocus()
			return 
		end if 	

//====================================================
//cbx_cancel $$HEX14$$e8cd8cc1200074d5f9b22000f5ac15c8d0c51cc12000adc01cc82000$$ENDHEX$$
//====================================================
	
if cbx_check_mode.checked  then 
else
	  lvl_row = dw_1.insertrow(1)
	  dw_1.object.pack_barcode[lvl_row] = lvs_pack_barcode
	  dw_1.object.barcode[lvl_row] = lvs_pid
	  dw_1.object.scan_date[lvl_row] = f_sysdate()
end if


//==================================================
//
//==================================================
st_status.text =f_msg_st1(107 , LVS_PID) // "$$HEX11$$15c8c1c0200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$" --107
COMMIT ;

if cbx_sound_on.checked = true then 
	f_play_sound( "Kittingok.wav")
end if 

em_qty.text = string(long(em_qty.text) + 1 )
sle_pid.text = ''
sle_pid.setfocus( )


end event

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

type cbx_check_mode from so_checkbox within w_pln_product_packing_dupulicate_check_master
integer x = 4329
integer y = 328
integer width = 421
integer height = 92
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
long backcolor = 16777215
string text = "Check Mode"
end type

event clicked;call super::clicked;sle_pid.setfocus()
end event

type rb_receipt_wait from so_radiobutton within w_pln_product_packing_dupulicate_check_master
integer x = 64
integer y = 320
boolean bringtotop = true
long backcolor = 16777215
string text = "Scan List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
sle_pid.setfocus()
end event

type rb_history from so_radiobutton within w_pln_product_packing_dupulicate_check_master
integer x = 64
integer y = 424
boolean bringtotop = true
long backcolor = 16777215
string text = "Scan History"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
sle_pid.setfocus()
end event

type rb_inventory from so_radiobutton within w_pln_product_packing_dupulicate_check_master
boolean visible = false
integer x = 64
integer y = 536
boolean bringtotop = true
long backcolor = 16777215
string text = "Inventory List"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
sle_pid.setfocus()
end event

type em_qty from so_editmask within w_pln_product_packing_dupulicate_check_master
integer x = 2944
integer y = 332
integer width = 567
integer height = 196
boolean bringtotop = true
integer textsize = -28
string text = "0"
alignment alignment = center!
boolean displayonly = true
string mask = "###,##0"
end type

type st_3 from so_statictext within w_pln_product_packing_dupulicate_check_master
integer x = 2944
integer y = 240
integer width = 567
integer height = 92
boolean bringtotop = true
integer textsize = -12
integer weight = 700
long textcolor = 134217734
long backcolor = 16777215
string text = "Scan Qty"
end type

type cbx_sound_on from so_checkbox within w_pln_product_packing_dupulicate_check_master
integer x = 4329
integer y = 440
integer width = 421
integer height = 72
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
long backcolor = 16777215
string text = "Sound On"
boolean checked = true
end type

event clicked;call super::clicked;sle_pid.setfocus()
end event

type gb_2 from so_groupbox within w_pln_product_packing_dupulicate_check_master
integer x = 603
integer y = 196
integer width = 3639
integer height = 396
integer textsize = -10
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Where Condition"
end type

type gb_5 from so_groupbox within w_pln_product_packing_dupulicate_check_master
integer y = 204
integer width = 594
integer height = 380
integer textsize = -10
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Category"
end type

type st_status from so_statictext within w_pln_product_packing_dupulicate_check_master
integer width = 4992
integer height = 196
integer textsize = -28
long textcolor = 16711680
long backcolor = 15780518
string text = "Message"
end type

type rb_inventory_sum from so_radiobutton within w_pln_product_packing_dupulicate_check_master
boolean visible = false
integer x = 64
integer y = 632
boolean bringtotop = true
long backcolor = 16777215
string text = "Inventory Sum"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4
sle_pid.setfocus()
end event

type sle_pack_barcode from so_singlelineedit within w_pln_product_packing_dupulicate_check_master
integer x = 654
integer y = 420
integer width = 1134
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -12
long textcolor = 0
long backcolor = 16777215
end type

event modified;call super::modified;sle_pid.setfocus()
end event

type st_2 from so_statictext within w_pln_product_packing_dupulicate_check_master
integer x = 654
integer y = 312
integer width = 1134
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
long textcolor = 134217734
long backcolor = 16777215
string text = "Packing Box Barcode"
end type

type st_4 from so_statictext within w_pln_product_packing_dupulicate_check_master
integer x = 1797
integer y = 308
integer width = 1134
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
long textcolor = 134217734
long backcolor = 16777215
string text = "PID"
end type

type em_ng from so_editmask within w_pln_product_packing_dupulicate_check_master
integer x = 3575
integer y = 336
integer width = 567
integer height = 196
integer taborder = 20
boolean bringtotop = true
integer textsize = -28
string text = "0"
alignment alignment = center!
boolean displayonly = true
string mask = "###,##0"
end type

type st_1 from so_statictext within w_pln_product_packing_dupulicate_check_master
integer x = 3575
integer y = 244
integer width = 567
integer height = 92
boolean bringtotop = true
integer textsize = -12
integer weight = 700
long textcolor = 134217734
long backcolor = 16777215
string text = "Dup Qty"
end type

type gb_1 from so_groupbox within w_pln_product_packing_dupulicate_check_master
integer x = 4265
integer y = 204
integer width = 567
integer height = 380
integer taborder = 10
integer textsize = -10
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Option"
end type


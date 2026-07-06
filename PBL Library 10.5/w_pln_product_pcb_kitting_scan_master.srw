HA$PBExportHeader$w_pln_product_pcb_kitting_scan_master.srw
$PBExportComments$Line Master
forward
global type w_pln_product_pcb_kitting_scan_master from w_main_root
end type
type st_mrm_no from so_statictext within w_pln_product_pcb_kitting_scan_master
end type
type sle_run_no from so_singlelineedit within w_pln_product_pcb_kitting_scan_master
end type
type sle_pcb_serial_no from so_singlelineedit within w_pln_product_pcb_kitting_scan_master
end type
type st_2 from so_statictext within w_pln_product_pcb_kitting_scan_master
end type
type cb_2 from so_commandbutton within w_pln_product_pcb_kitting_scan_master
end type
type em_lot_size from so_editmask within w_pln_product_pcb_kitting_scan_master
end type
type st_5 from so_statictext within w_pln_product_pcb_kitting_scan_master
end type
type st_status from so_statictext within w_pln_product_pcb_kitting_scan_master
end type
type em_scan_total from so_editmask within w_pln_product_pcb_kitting_scan_master
end type
type st_10 from so_statictext within w_pln_product_pcb_kitting_scan_master
end type
type rb_normal from so_radiobutton within w_pln_product_pcb_kitting_scan_master
end type
type rb_cancel from so_radiobutton within w_pln_product_pcb_kitting_scan_master
end type
type rb_kitting from so_radiobutton within w_pln_product_pcb_kitting_scan_master
end type
type rb_2 from so_radiobutton within w_pln_product_pcb_kitting_scan_master
end type
type sle_model_name from so_singlelineedit within w_pln_product_pcb_kitting_scan_master
end type
type st_1 from so_statictext within w_pln_product_pcb_kitting_scan_master
end type
type sle_run_no_4_delete from so_singlelineedit within w_pln_product_pcb_kitting_scan_master
end type
type st_3 from so_statictext within w_pln_product_pcb_kitting_scan_master
end type
type cb_1 from so_commandbutton within w_pln_product_pcb_kitting_scan_master
end type
type sle_pcb_serial_no_cond from so_singlelineedit within w_pln_product_pcb_kitting_scan_master
end type
type st_4 from so_statictext within w_pln_product_pcb_kitting_scan_master
end type
type uo_dateset from uo_ymd_calendar within w_pln_product_pcb_kitting_scan_master
end type
type uo_dateend from uo_ymd_calendar within w_pln_product_pcb_kitting_scan_master
end type
type st_6 from so_statictext within w_pln_product_pcb_kitting_scan_master
end type
type cbx_check_lot_size from so_checkbox within w_pln_product_pcb_kitting_scan_master
end type
type cbx_model_matching from so_checkbox within w_pln_product_pcb_kitting_scan_master
end type
type gb_1 from so_groupbox within w_pln_product_pcb_kitting_scan_master
end type
type gb_2 from so_groupbox within w_pln_product_pcb_kitting_scan_master
end type
type gb_3 from so_groupbox within w_pln_product_pcb_kitting_scan_master
end type
type gb_4 from so_groupbox within w_pln_product_pcb_kitting_scan_master
end type
type gb_5 from so_groupbox within w_pln_product_pcb_kitting_scan_master
end type
type gb_6 from so_groupbox within w_pln_product_pcb_kitting_scan_master
end type
end forward

global type w_pln_product_pcb_kitting_scan_master from w_main_root
integer width = 6606
integer height = 2748
string title = "PCB Kitting Scan Master"
st_mrm_no st_mrm_no
sle_run_no sle_run_no
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
cb_2 cb_2
em_lot_size em_lot_size
st_5 st_5
st_status st_status
em_scan_total em_scan_total
st_10 st_10
rb_normal rb_normal
rb_cancel rb_cancel
rb_kitting rb_kitting
rb_2 rb_2
sle_model_name sle_model_name
st_1 st_1
sle_run_no_4_delete sle_run_no_4_delete
st_3 st_3
cb_1 cb_1
sle_pcb_serial_no_cond sle_pcb_serial_no_cond
st_4 st_4
uo_dateset uo_dateset
uo_dateend uo_dateend
st_6 st_6
cbx_check_lot_size cbx_check_lot_size
cbx_model_matching cbx_model_matching
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_6 gb_6
end type
global w_pln_product_pcb_kitting_scan_master w_pln_product_pcb_kitting_scan_master

type variables

long lvl_row
end variables

on w_pln_product_pcb_kitting_scan_master.create
int iCurrent
call super::create
this.st_mrm_no=create st_mrm_no
this.sle_run_no=create sle_run_no
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_2=create st_2
this.cb_2=create cb_2
this.em_lot_size=create em_lot_size
this.st_5=create st_5
this.st_status=create st_status
this.em_scan_total=create em_scan_total
this.st_10=create st_10
this.rb_normal=create rb_normal
this.rb_cancel=create rb_cancel
this.rb_kitting=create rb_kitting
this.rb_2=create rb_2
this.sle_model_name=create sle_model_name
this.st_1=create st_1
this.sle_run_no_4_delete=create sle_run_no_4_delete
this.st_3=create st_3
this.cb_1=create cb_1
this.sle_pcb_serial_no_cond=create sle_pcb_serial_no_cond
this.st_4=create st_4
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_6=create st_6
this.cbx_check_lot_size=create cbx_check_lot_size
this.cbx_model_matching=create cbx_model_matching
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_mrm_no
this.Control[iCurrent+2]=this.sle_run_no
this.Control[iCurrent+3]=this.sle_pcb_serial_no
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.em_lot_size
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.st_status
this.Control[iCurrent+9]=this.em_scan_total
this.Control[iCurrent+10]=this.st_10
this.Control[iCurrent+11]=this.rb_normal
this.Control[iCurrent+12]=this.rb_cancel
this.Control[iCurrent+13]=this.rb_kitting
this.Control[iCurrent+14]=this.rb_2
this.Control[iCurrent+15]=this.sle_model_name
this.Control[iCurrent+16]=this.st_1
this.Control[iCurrent+17]=this.sle_run_no_4_delete
this.Control[iCurrent+18]=this.st_3
this.Control[iCurrent+19]=this.cb_1
this.Control[iCurrent+20]=this.sle_pcb_serial_no_cond
this.Control[iCurrent+21]=this.st_4
this.Control[iCurrent+22]=this.uo_dateset
this.Control[iCurrent+23]=this.uo_dateend
this.Control[iCurrent+24]=this.st_6
this.Control[iCurrent+25]=this.cbx_check_lot_size
this.Control[iCurrent+26]=this.cbx_model_matching
this.Control[iCurrent+27]=this.gb_1
this.Control[iCurrent+28]=this.gb_2
this.Control[iCurrent+29]=this.gb_3
this.Control[iCurrent+30]=this.gb_4
this.Control[iCurrent+31]=this.gb_5
this.Control[iCurrent+32]=this.gb_6
end on

on w_pln_product_pcb_kitting_scan_master.destroy
call super::destroy
destroy(this.st_mrm_no)
destroy(this.sle_run_no)
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.em_lot_size)
destroy(this.st_5)
destroy(this.st_status)
destroy(this.em_scan_total)
destroy(this.st_10)
destroy(this.rb_normal)
destroy(this.rb_cancel)
destroy(this.rb_kitting)
destroy(this.rb_2)
destroy(this.sle_model_name)
destroy(this.st_1)
destroy(this.sle_run_no_4_delete)
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.sle_pcb_serial_no_cond)
destroy(this.st_4)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_6)
destroy(this.cbx_check_lot_size)
destroy(this.cbx_model_matching)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_6)
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
Ivs_resize_type                      = 'MASTER_DETAIL_1L2FR'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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

sle_run_no.setfocus()
st_status.width = this.width
end event

event ue_data_control;call super::ue_data_control;CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
		
		if rb_kitting.checked = true then 
			
			DW_1.RETRIEVE( SLE_RUN_NO.TEXT+'%' ,  sle_run_no_4_delete.text+'%' , GVI_ORGANIZATION_ID )
			SLE_RUN_NO.SETFOCUS()

			em_scan_total.text = '0'
			sle_pcb_serial_no.setfocus()
			
		else
			
			DW_3.RETRIEVE( sle_run_no_4_delete.TEXT+'%' ,  sle_pcb_serial_no_cond.text +'%' ,  sle_model_name.text+'%' , uo_dateset.text() , uo_dateend.text() ,   GVI_ORGANIZATION_ID )
			SLE_RUN_NO.SETFOCUS()

		end if 
			
		CASE 'INSERT'
			
			if rb_kitting.checked = true then 
				Lvl_row = dw_2.insertrow(dw_2.getrow())
				dw_2.scrolltorow(Lvl_row)
				f_set_security_row(dw_2 , Lvl_row , 'ALL')
				F_MSG_MDI_HELP ( F_MSG_ST(152)	 )		
			end if
			
	CASE 'DELETE'
		
	
			
	CASE 'UPDATE'

			dw_2.ACCEPTTEXT()
			IF dw_2.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				COMMIT;
				F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
      
	CASE ELSE
END CHOOSE


end event

event resize;call super::resize;st_status.width =this.width
end event

event close;call super::close;//======================
//
//======================
	f_update()
//======================
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_pcb_kitting_scan_master
integer y = 840
integer width = 2354
integer height = 1648
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_pcb_kitting_scan_master
integer y = 840
integer width = 2354
integer height = 1648
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_pcb_kitting_scan_master
integer y = 840
integer width = 5070
integer height = 1648
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_product_2d_barcode_4_kitting_lst"
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_pcb_kitting_scan_master
integer x = 2354
integer y = 844
integer width = 3095
integer height = 1648
integer taborder = 0
boolean titlebar = true
string title = "PID List"
string dataobject = "d_pln_product_2d_barcode_4_kitting"
end type

event dw_2::retrieveend;call super::retrieveend;em_scan_total.text = string( rowcount)
end event

type dw_1 from w_main_root`dw_1 within w_pln_product_pcb_kitting_scan_master
integer y = 840
integer width = 2354
integer height = 1648
integer taborder = 0
boolean titlebar = true
string title = "Run Card ist"
string dataobject = "d_ip_product_run_card_4_kitting_lst"
end type

event dw_1::clicked;call super::clicked;SLE_RUN_NO.SETFOCUS()
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 

if rb_kitting.checked = true then 
	dw_2.reset()
	dw_2.retrieve( this.object.run_no[currentrow] , gvi_organization_id ) 
	
	em_lot_size.text = string(dw_1.object.lot_size[currentrow])
	
	
else
	dw_3.reset()
	dw_3.retrieve( this.object.run_no[currentrow] , gvi_organization_id ) 	
	
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_pcb_kitting_scan_master
integer y = 3288
integer taborder = 0
end type

type st_mrm_no from so_statictext within w_pln_product_pcb_kitting_scan_master
integer x = 585
integer y = 116
integer width = 677
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "MFS Group No"
end type

type sle_run_no from so_singlelineedit within w_pln_product_pcb_kitting_scan_master
integer x = 585
integer y = 196
integer width = 677
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;
long lvl_lot_size
//======================================
// $$HEX3$$70c88cd62000$$ENDHEX$$
//======================================
//lvl_lot_size = f_get_lot_size_by_run_no( this.text)

//if lvl_lot_size <= 0 then 
//   
//	f_msg("$$HEX28$$f0b774cedcb4200015c8f4bc00ac2000c6c570ac98b020006fb8b8d2200018c2c9b774c720002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"  ,'P' )
//	this.text = ''
//	return 
//	
//else
//	em_lot_size.text  = string (lvl_lot_size)
//end if 
//
//sle_model_name.text = f_get_model_name_by_run_no( this.text )
 
f_retrieve()


end event

event rbuttondown;call super::rbuttondown;OPEN(W_PLN_RUN_NO_POPUP)

if Gst_return.Gvb_return = true then 
	this.text = message.stringparm
	this.triggerevent(modified!)

else
	this.text = 	''
end if 
end event

event getfocus;call super::getfocus;this.selecttext( 1 , len(this.text))

end event

type sle_pcb_serial_no from so_singlelineedit within w_pln_product_pcb_kitting_scan_master
integer x = 1271
integer y = 196
integer width = 777
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;string lvs_barcode_status , lvs_pid , lvs_run_no ,LVS_LINE_CODE , LVS_MODEL_NAME , LVS_MODEL_SUFFIX , LVS_ITEM_CODE
datetime LVDT_RUN_DATE
long ll_row , LVI_PID_EXISTS_CHECK , i , j


if rb_kitting.checked = true then 
else
	return 
end if 
st_status.backcolor = rgb(0,0,255)

if sle_run_no.text = '' then 
   sle_run_no.setfocus()
   this.text = ''
   return 
else
	lvs_run_no = sle_run_no.text
end if 


if dw_1.getrow() < 1 then 
	sle_run_no.setfocus()
	st_status.text =f_get_dual_lang_text( gvs_language , "Not Found" )
	this.text = ''
	return 
end if 


//=========================
//  PID 
//=========================
lvs_pid = sle_pcb_serial_no.text 
lvs_barcode_status = 'N'

//=========================================================
//  PID $$HEX9$$74c8acc7200020c734bb2000b4cc6cd02000$$ENDHEX$$
//=========================================================

SELECT COUNT(*) 
    INTO :LVI_PID_EXISTS_CHECK
  FROM IP_PRODUCT_2D_BARCODE 
WHERE SERIAL_NO = :LVS_PID 
    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
	AND ROWNUM = 1 ;
	 
IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 

if rb_normal.checked = true and em_scan_total.text = em_lot_size.text and cbx_check_lot_size.checked = true then
	
	f_msg("$$HEX16$$6fb8b8d218c2c9b744c7200004c880bd2000a4c294ce200088d5b5c2c8b2e4b2$$ENDHEX$$" , 'P' )
	st_status.text =f_msg("$$HEX16$$6fb8b8d218c2c9b744c7200004c880bd2000a4c294ce200088d5b5c2c8b2e4b2$$ENDHEX$$" , 'S' )
	f_play_sound("call4.wav")		
	sle_pcb_serial_no.text = ''
	sle_pcb_serial_no.setfocus()
	st_status.backcolor = 255 
	return 
end if 

//===========================================
//$$HEX16$$f1b45db878c770b3200074c7f8bb200074c8acc7200058d594b2bdacb0c62000$$ENDHEX$$
//===========================================
if rb_normal.checked = true and   LVI_PID_EXISTS_CHECK > 0  then 
	st_status.text =f_get_dual_lang_text( gvs_language , "Already Exists" )
	f_play_sound("call4.wav")		
	sle_pcb_serial_no.text = ''
	sle_pcb_serial_no.setfocus()
	st_status.backcolor = 255 
	return 
end if 

//===========================================
// $$HEX18$$e8cd8cc1200078c770b3200074c8acc7200058d5c0c920004ac594b22000bdacb0c62000$$ENDHEX$$
//===========================================
if rb_normal.checked = false and   LVI_PID_EXISTS_CHECK = 0  then 
	st_status.text =f_get_dual_lang_text( gvs_language , "Not Found" )
	f_play_sound("call4.wav")		
	sle_pcb_serial_no.text = ''
	sle_pcb_serial_no.setfocus()
	st_status.backcolor = 255 
	return 
end if 


LVS_MODEL_NAME = ''
LVS_MODEL_SUFFIX = ''
LVS_LINE_CODE = ''
LVS_ITEM_CODE = ''

//if rb_normal.checked = true then 
//			DO
//					i++
//					//=========================================
//						// $$HEX26$$dcc2acb9bcc5200088bc38d658c72000a8ba78b385bafcac200044be50ad200024c6a4c294ce200029bcc0c9200044be50ad2000$$ENDHEX$$
//						//=========================================
//						LVS_MODEL_NAME = dw_1.object.model_name[i] 
//						
//						if   mid(LVS_MODEL_NAME , 7, 5 ) = MID(lvs_pid , 7,5 ) then 
//							 j++
//							 lvs_run_no     = dw_1.object.run_no[i] 
//							 lvs_line_code  = dw_1.object.line_code[i] 
//							 lvs_item_code = dw_1.object.item_code[i]
//							 lvdt_run_date = dw_1.object.run_date[i]
//							 exit  //$$HEX9$$3ecc58c53cc774ba200098b004ace4b22000$$ENDHEX$$
//						else
//							 continue
//						end if 
//						
//				LOOP UNTIL i = dw_1.rowcount() 
//				
//				//=============================================
//				//
//				//=============================================
//			
//				if j = 0 then 
//					
//							st_status.text =f_msg( "$$HEX19$$a8ba78b374c720007cc758ce58d5c0c920004ac5b5c2c8b2e4b2200055d678c758d538c194c6$$ENDHEX$$" , "S")
//							f_msg( "$$HEX19$$a8ba78b374c720007cc758ce58d5c0c920004ac5b5c2c8b2e4b2200055d678c758d538c194c6$$ENDHEX$$" , "P") 
//							f_play_sound("call4.wav")		
//							sle_pcb_serial_no.text = ''
//							sle_pcb_serial_no.setfocus()
//							st_status.backcolor = 255 
//							return 	 	
//				end if 
//end if 

//=========================================================
// $$HEX9$$15c8c1c02000f1b45db878c7bdacb0c62000$$ENDHEX$$
//=========================================================

	
			if rb_normal.checked = true  then 
			
						ll_row = dw_2.find ( "serial_no='" + lvs_pid +"'" , 1, dw_2.rowcount() )
						
						//==============================
						// $$HEX18$$74c7f8bb20007dc740c7200070b374c730d17cb920003ecc58c544c72000bdacb0c62000$$ENDHEX$$
						// $$HEX10$$a4c294ce44c7200088d544c72000bdacb0c62000$$ENDHEX$$
						//==============================
						if ll_row > 0  then 
							st_status.text =f_get_dual_lang_text( gvs_language , "Already Exists" )
							f_play_sound("call4.wav")		
							sle_pcb_serial_no.text = ''
							sle_pcb_serial_no.setfocus()
							st_status.backcolor = 255 
							return 
						end if 
						
						//==============================
						// $$HEX7$$3ecc40c72000c1c0dcd058c72000$$ENDHEX$$i $$HEX6$$12ac200030ae00c920002000$$ENDHEX$$dw_1$$HEX11$$58c7200015c8f4bc7cb9200000ac38c828c6e4b22000$$ENDHEX$$
						//==============================
						lvs_run_no = dw_1.object.run_no[dw_1.getrow()]
						LVS_MODEL_NAME = dw_1.object.model_name[dw_1.getrow()] 
						lvs_line_code  = dw_1.object.line_code[dw_1.getrow()] 
						lvs_item_code = dw_1.object.item_code[dw_1.getrow()]
						lvdt_run_date = dw_1.object.run_date[dw_1.getrow()]
						
//						lvs_run_no = dw_1.object.run_no[i]
//						LVS_MODEL_NAME = dw_1.object.model_name[i] 
//						lvs_line_code  = dw_1.object.line_code[i] 
//						lvs_item_code = dw_1.object.item_code[i]
//						lvdt_run_date = dw_1.object.run_date[i]					

					if cbx_model_matching.checked = true then 
								if   mid(LVS_MODEL_NAME , 7, 5 ) = MID(lvs_pid , 7,5 ) then 
								
								else
										
										st_status.text =f_msg( "$$HEX19$$a8ba78b374c720007cc758ce58d5c0c920004ac5b5c2c8b2e4b2200055d678c758d538c194c6$$ENDHEX$$" , "S")
										f_msg( "$$HEX19$$a8ba78b374c720007cc758ce58d5c0c920004ac5b5c2c8b2e4b2200055d678c758d538c194c6$$ENDHEX$$" , "P") 
										f_play_sound("call4.wav")		
										sle_pcb_serial_no.text = ''
										sle_pcb_serial_no.setfocus()
										st_status.backcolor = 255 
										return 	 							
								end if 
					end if 						
						
						//================================================
						//
						//================================================
						
						f_insert()
						
						dw_2.object.serial_no[lvl_row] =lvs_pid
						dw_2.object.label_text[lvl_row] =lvs_pid
						dw_2.object.run_no[lvl_row] = lvs_run_no
						dw_2.object.model_name[lvl_row] = lvs_model_name
						dw_2.object.model_suffix[lvl_row] = lvs_model_suffix 
						dw_2.object.item_code[lvl_row] =lvs_item_code
	
						dw_2.object.line_code[lvl_row] =LVS_LINE_CODE
						dw_2.object.run_date[lvl_row]   =LVDT_RUN_DATE
						dw_2.object.qc_scan_yn[lvl_row]   ='N'
						dw_2.object.workstage_code[lvl_row] ='*'
						dw_2.object.barcode_status[lvl_row] = lvs_barcode_status
						
						dw_2.object.lot_qty[lvl_row] =1
						
						if dw_2.update() < 0 then 
							Rollback;
							dw_2.retrieve( lvs_run_no , gvi_organization_id )
							sle_pcb_serial_no.text = ''
							sle_pcb_serial_no.setfocus( )
							return 
						end if 
						commit ;
						st_status.text =f_get_dual_lang_text( gvs_language , "Waiting..." )
						f_play_sound("call6.wav")	
						em_scan_total.text = string(long(em_scan_total.text) +1 )
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
							
								if dw_2.object.qc_scan_yn[ll_row] = 'Y' then 
									f_msg("$$HEX5$$ddc0b0c011c978c72000$$ENDHEX$$PCB $$HEX12$$94b22000adc01cc8200060d518c22000c6c5b5c2c8b2e4b2$$ENDHEX$$" , "P") 
									sle_pcb_serial_no.text = ''
									sle_pcb_serial_no.setfocus()
									return 
								end if 
							
								st_status.text =f_get_dual_lang_text( gvs_language , "Cancel OK" )
								
								dw_2.deleterow( ll_row)
								
								f_play_sound("call6.wav")		
								sle_pcb_serial_no.text = ''
								sle_pcb_serial_no.setfocus()
					
								if dw_2.update() < 0 then 
									Rollback;
									dw_2.retrieve( lvs_run_no , gvi_organization_id )
									sle_pcb_serial_no.text = ''
									sle_pcb_serial_no.setfocus( )
									return 
								end if 	
                                    em_scan_total.text = string(long(em_scan_total.text) -1 )
								sle_pcb_serial_no.text = ''
								sle_pcb_serial_no.setfocus( )
								commit ;
								
						else
								st_status.text =f_get_dual_lang_text( gvs_language , "Not Found" )
								f_msgbox(117)
								sle_pcb_serial_no.text = ''
								sle_pcb_serial_no.setfocus( )
						end if 
			end if 
end event

type st_2 from so_statictext within w_pln_product_pcb_kitting_scan_master
integer x = 1271
integer y = 116
integer width = 777
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "PCB Serial No"
end type

type cb_2 from so_commandbutton within w_pln_product_pcb_kitting_scan_master
integer x = 4137
integer y = 132
integer width = 370
integer height = 172
boolean bringtotop = true
string text = "Reset"
end type

event clicked;call super::clicked;sle_run_no.text = ''
sle_pcb_serial_no.text = ''
em_lot_size.text = '0'
em_scan_total.text = '0'
dw_1.reset()
sle_run_no.setfocus( )


end event

type em_lot_size from so_editmask within w_pln_product_pcb_kitting_scan_master
integer x = 3163
integer y = 124
integer width = 480
integer height = 180
boolean bringtotop = true
integer textsize = -24
long backcolor = 12632256
string text = "0"
string mask = "##0"
end type

type st_5 from so_statictext within w_pln_product_pcb_kitting_scan_master
integer x = 3173
integer y = 60
integer width = 475
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Lot Size"
end type

type st_status from so_statictext within w_pln_product_pcb_kitting_scan_master
integer y = 660
integer width = 5454
integer height = 176
boolean bringtotop = true
integer textsize = -24
integer weight = 700
long textcolor = 65535
long backcolor = 16711680
string text = "Wait"
end type

type em_scan_total from so_editmask within w_pln_product_pcb_kitting_scan_master
integer x = 3648
integer y = 124
integer width = 480
integer height = 180
boolean bringtotop = true
integer textsize = -24
long backcolor = 65535
string text = "0"
string mask = "##0"
end type

type st_10 from so_statictext within w_pln_product_pcb_kitting_scan_master
integer x = 3648
integer y = 64
integer width = 475
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Scan Total"
end type

type rb_normal from so_radiobutton within w_pln_product_pcb_kitting_scan_master
integer x = 91
integer y = 428
integer width = 430
boolean bringtotop = true
string text = "Normal"
boolean checked = true
end type

event clicked;call super::clicked;parent.backcolor =rgb(192,192,192)
end event

type rb_cancel from so_radiobutton within w_pln_product_pcb_kitting_scan_master
integer x = 91
integer y = 512
integer width = 430
boolean bringtotop = true
string text = "Cancel"
end type

event clicked;call super::clicked;sle_pcb_serial_no.setfocus()
parent.backcolor = 255
end event

type rb_kitting from so_radiobutton within w_pln_product_pcb_kitting_scan_master
integer x = 73
integer y = 100
integer width = 430
boolean bringtotop = true
string text = "Kitting"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
dw_2.bringtotop = true 
selected_data_window = dw_2



sle_model_name.enabled = false
sle_pcb_serial_no_cond.enabled = false

end event

type rb_2 from so_radiobutton within w_pln_product_pcb_kitting_scan_master
integer x = 73
integer y = 200
integer width = 430
boolean bringtotop = true
string text = "Kitting History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3

sle_model_name.enabled = true
sle_pcb_serial_no_cond.enabled = true

end event

type sle_model_name from so_singlelineedit within w_pln_product_pcb_kitting_scan_master
integer x = 613
integer y = 504
integer width = 677
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
textcase textcase = upper!
end type

type st_1 from so_statictext within w_pln_product_pcb_kitting_scan_master
integer x = 613
integer y = 428
integer width = 677
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Model Name"
end type

type sle_run_no_4_delete from so_singlelineedit within w_pln_product_pcb_kitting_scan_master
integer x = 2062
integer y = 196
integer width = 526
integer taborder = 60
boolean bringtotop = true
textcase textcase = upper!
end type

type st_3 from so_statictext within w_pln_product_pcb_kitting_scan_master
integer x = 2085
integer y = 88
integer width = 475
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Run No"
end type

type cb_1 from so_commandbutton within w_pln_product_pcb_kitting_scan_master
integer x = 2706
integer y = 100
integer width = 370
integer height = 172
integer taborder = 50
boolean bringtotop = true
string text = "Delete All"
end type

event clicked;call super::clicked;string lvs_run_no
int lvi_count

if dw_1.getrow() < 1 then return 

lvs_run_no = dw_1.object.run_no[dw_1.getrow()]
if lvs_run_no = '' or isnull(lvs_run_no) then 
	return 
end if 


select count(*) into :lvi_count 
 from ip_product_run_card_io 
 where run_no = :lvs_run_no 
    and organization_id = :gvi_organization_id ;
	 
 if f_sql_check() < 0 then 
	return 
end if 

if lvi_count > 0 then 
	f_msg("$$HEX26$$e4b970acc4c920001cbc89d5200074c725b874c7200088c7b5c2c8b2e4b22000adc01cc8200060d518c22000c6c5b5c2c8b2e4b2$$ENDHEX$$" , "P" )
	return 
end if 


msg = f_msgbox1( 1161 , this.text ) 
if msg = 1 then 
	
	delete from ip_product_2d_barcode where run_no = :lvs_run_no 
	 and organization_id = :gvi_organization_id  ;
	 
	 if f_sql_check() < 0 then 
		return 
	end if 
	commit ;
	
	st_status.text = "Delete OK" 
end if 
end event

type sle_pcb_serial_no_cond from so_singlelineedit within w_pln_product_pcb_kitting_scan_master
integer x = 1289
integer y = 504
integer width = 777
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
textcase textcase = upper!
end type

type st_4 from so_statictext within w_pln_product_pcb_kitting_scan_master
integer x = 1289
integer y = 412
integer width = 777
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "PCB Serial No"
end type

type uo_dateset from uo_ymd_calendar within w_pln_product_pcb_kitting_scan_master
event destroy ( )
integer x = 2053
integer y = 500
integer taborder = 60
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_pln_product_pcb_kitting_scan_master
event destroy ( )
integer x = 2473
integer y = 500
integer taborder = 70
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_6 from so_statictext within w_pln_product_pcb_kitting_scan_master
integer x = 2062
integer y = 408
integer width = 823
boolean bringtotop = true
string text = "Run Date"
end type

type cbx_check_lot_size from so_checkbox within w_pln_product_pcb_kitting_scan_master
integer x = 3214
integer y = 364
boolean bringtotop = true
string text = "Check Lot Size"
boolean checked = true
end type

type cbx_model_matching from so_checkbox within w_pln_product_pcb_kitting_scan_master
integer x = 3214
integer y = 480
integer width = 553
boolean bringtotop = true
string text = "Check Model Matching"
boolean checked = true
end type

type gb_1 from so_groupbox within w_pln_product_pcb_kitting_scan_master
integer x = 2647
integer y = 24
integer width = 494
integer height = 304
integer weight = 700
long textcolor = 16711680
string text = "Delete Kitting Data"
end type

type gb_2 from so_groupbox within w_pln_product_pcb_kitting_scan_master
integer x = 5
integer y = 328
integer width = 553
integer height = 304
integer taborder = 50
integer weight = 700
long textcolor = 16711680
string text = "Option"
end type

type gb_3 from so_groupbox within w_pln_product_pcb_kitting_scan_master
integer x = 5
integer y = 24
integer width = 553
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_4 from so_groupbox within w_pln_product_pcb_kitting_scan_master
integer x = 3150
integer y = 24
integer width = 1399
integer height = 608
integer taborder = 10
integer weight = 700
long textcolor = 16711680
end type

type gb_5 from so_groupbox within w_pln_product_pcb_kitting_scan_master
integer x = 562
integer y = 24
integer width = 2062
integer height = 304
integer taborder = 60
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_6 from so_groupbox within w_pln_product_pcb_kitting_scan_master
integer x = 567
integer y = 324
integer width = 2569
integer height = 304
integer taborder = 60
integer weight = 700
long textcolor = 16711680
string text = "History Where Condition"
end type


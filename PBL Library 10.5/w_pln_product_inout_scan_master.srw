HA$PBExportHeader$w_pln_product_inout_scan_master.srw
$PBExportComments$$$HEX17$$b9c278c7d0c658c7a8ba78b3d0c5200000b35cd52000b9d231c144c7200000adacb9$$ENDHEX$$
forward
global type w_pln_product_inout_scan_master from w_main_root
end type
type st_11 from so_statictext within w_pln_product_inout_scan_master
end type
type sle_pid from so_singlelineedit within w_pln_product_inout_scan_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_inout_scan_master
end type
type st_2 from so_statictext within w_pln_product_inout_scan_master
end type
type cbx_cancel from so_checkbox within w_pln_product_inout_scan_master
end type
type rb_receipt_wait from so_radiobutton within w_pln_product_inout_scan_master
end type
type rb_history from so_radiobutton within w_pln_product_inout_scan_master
end type
type rb_inventory from so_radiobutton within w_pln_product_inout_scan_master
end type
type sle_model_name from so_singlelineedit within w_pln_product_inout_scan_master
end type
type st_mrm_no from so_statictext within w_pln_product_inout_scan_master
end type
type em_qty from so_editmask within w_pln_product_inout_scan_master
end type
type st_model_name from so_statictext within w_pln_product_inout_scan_master
end type
type st_model_suffix from so_statictext within w_pln_product_inout_scan_master
end type
type st_1 from so_statictext within w_pln_product_inout_scan_master
end type
type st_3 from so_statictext within w_pln_product_inout_scan_master
end type
type cbx_sound_on from so_checkbox within w_pln_product_inout_scan_master
end type
type gb_5 from so_groupbox within w_pln_product_inout_scan_master
end type
type st_status from so_statictext within w_pln_product_inout_scan_master
end type
type sle_model_suffix from so_singlelineedit within w_pln_product_inout_scan_master
end type
type st_4 from so_statictext within w_pln_product_inout_scan_master
end type
type sle_workstage_type from so_singlelineedit within w_pln_product_inout_scan_master
end type
type st_5 from so_statictext within w_pln_product_inout_scan_master
end type
type rb_workstae_sum from so_radiobutton within w_pln_product_inout_scan_master
end type
type rb_today from so_radiobutton within w_pln_product_inout_scan_master
end type
type uo_dateset from uo_ymd_calendar within w_pln_product_inout_scan_master
end type
type st_6 from so_statictext within w_pln_product_inout_scan_master
end type
type ddlb_line_code from uo_line_code_dd within w_pln_product_inout_scan_master
end type
type cbx_allow_mix_model from so_checkbox within w_pln_product_inout_scan_master
end type
type cbx_rework from so_checkbox within w_pln_product_inout_scan_master
end type
type gb_1 from so_groupbox within w_pln_product_inout_scan_master
end type
type gb_2 from so_groupbox within w_pln_product_inout_scan_master
end type
type cbx_lot_user from so_checkbox within w_pln_product_inout_scan_master
end type
type uo_dateend from uo_ymd_calendar within w_pln_product_inout_scan_master
end type
type cbx_xout_auto_destroy from so_checkbox within w_pln_product_inout_scan_master
end type
type dw_xout_list from so_datawindow within w_pln_product_inout_scan_master
end type
type cb_paste from so_commandbutton within w_pln_product_inout_scan_master
end type
type cb_1 from so_commandbutton within w_pln_product_inout_scan_master
end type
type cb_2 from so_commandbutton within w_pln_product_inout_scan_master
end type
type sle_serial from so_singlelineedit within w_pln_product_inout_scan_master
end type
type st_7 from so_statictext within w_pln_product_inout_scan_master
end type
type em_lotqty from so_editmask within w_pln_product_inout_scan_master
end type
type cb_3 from commandbutton within w_pln_product_inout_scan_master
end type
type st_8 from so_statictext within w_pln_product_inout_scan_master
end type
type gb_3 from so_groupbox within w_pln_product_inout_scan_master
end type
end forward

global type w_pln_product_inout_scan_master from w_main_root
integer width = 7415
integer height = 2292
string title = "Product Workstage Inout Scan Master"
long backcolor = 16777215
st_11 st_11
sle_pid sle_pid
ddlb_workstage_code ddlb_workstage_code
st_2 st_2
cbx_cancel cbx_cancel
rb_receipt_wait rb_receipt_wait
rb_history rb_history
rb_inventory rb_inventory
sle_model_name sle_model_name
st_mrm_no st_mrm_no
em_qty em_qty
st_model_name st_model_name
st_model_suffix st_model_suffix
st_1 st_1
st_3 st_3
cbx_sound_on cbx_sound_on
gb_5 gb_5
st_status st_status
sle_model_suffix sle_model_suffix
st_4 st_4
sle_workstage_type sle_workstage_type
st_5 st_5
rb_workstae_sum rb_workstae_sum
rb_today rb_today
uo_dateset uo_dateset
st_6 st_6
ddlb_line_code ddlb_line_code
cbx_allow_mix_model cbx_allow_mix_model
cbx_rework cbx_rework
gb_1 gb_1
gb_2 gb_2
cbx_lot_user cbx_lot_user
uo_dateend uo_dateend
cbx_xout_auto_destroy cbx_xout_auto_destroy
dw_xout_list dw_xout_list
cb_paste cb_paste
cb_1 cb_1
cb_2 cb_2
sle_serial sle_serial
st_7 st_7
em_lotqty em_lotqty
cb_3 cb_3
st_8 st_8
gb_3 gb_3
end type
global w_pln_product_inout_scan_master w_pln_product_inout_scan_master

type variables
STRING IVS_LINE_CODE , IVS_WORKSTAGE_CODE , IVS_TYPE
end variables

on w_pln_product_inout_scan_master.create
int iCurrent
call super::create
this.st_11=create st_11
this.sle_pid=create sle_pid
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_2=create st_2
this.cbx_cancel=create cbx_cancel
this.rb_receipt_wait=create rb_receipt_wait
this.rb_history=create rb_history
this.rb_inventory=create rb_inventory
this.sle_model_name=create sle_model_name
this.st_mrm_no=create st_mrm_no
this.em_qty=create em_qty
this.st_model_name=create st_model_name
this.st_model_suffix=create st_model_suffix
this.st_1=create st_1
this.st_3=create st_3
this.cbx_sound_on=create cbx_sound_on
this.gb_5=create gb_5
this.st_status=create st_status
this.sle_model_suffix=create sle_model_suffix
this.st_4=create st_4
this.sle_workstage_type=create sle_workstage_type
this.st_5=create st_5
this.rb_workstae_sum=create rb_workstae_sum
this.rb_today=create rb_today
this.uo_dateset=create uo_dateset
this.st_6=create st_6
this.ddlb_line_code=create ddlb_line_code
this.cbx_allow_mix_model=create cbx_allow_mix_model
this.cbx_rework=create cbx_rework
this.gb_1=create gb_1
this.gb_2=create gb_2
this.cbx_lot_user=create cbx_lot_user
this.uo_dateend=create uo_dateend
this.cbx_xout_auto_destroy=create cbx_xout_auto_destroy
this.dw_xout_list=create dw_xout_list
this.cb_paste=create cb_paste
this.cb_1=create cb_1
this.cb_2=create cb_2
this.sle_serial=create sle_serial
this.st_7=create st_7
this.em_lotqty=create em_lotqty
this.cb_3=create cb_3
this.st_8=create st_8
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_11
this.Control[iCurrent+2]=this.sle_pid
this.Control[iCurrent+3]=this.ddlb_workstage_code
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cbx_cancel
this.Control[iCurrent+6]=this.rb_receipt_wait
this.Control[iCurrent+7]=this.rb_history
this.Control[iCurrent+8]=this.rb_inventory
this.Control[iCurrent+9]=this.sle_model_name
this.Control[iCurrent+10]=this.st_mrm_no
this.Control[iCurrent+11]=this.em_qty
this.Control[iCurrent+12]=this.st_model_name
this.Control[iCurrent+13]=this.st_model_suffix
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.st_3
this.Control[iCurrent+16]=this.cbx_sound_on
this.Control[iCurrent+17]=this.gb_5
this.Control[iCurrent+18]=this.st_status
this.Control[iCurrent+19]=this.sle_model_suffix
this.Control[iCurrent+20]=this.st_4
this.Control[iCurrent+21]=this.sle_workstage_type
this.Control[iCurrent+22]=this.st_5
this.Control[iCurrent+23]=this.rb_workstae_sum
this.Control[iCurrent+24]=this.rb_today
this.Control[iCurrent+25]=this.uo_dateset
this.Control[iCurrent+26]=this.st_6
this.Control[iCurrent+27]=this.ddlb_line_code
this.Control[iCurrent+28]=this.cbx_allow_mix_model
this.Control[iCurrent+29]=this.cbx_rework
this.Control[iCurrent+30]=this.gb_1
this.Control[iCurrent+31]=this.gb_2
this.Control[iCurrent+32]=this.cbx_lot_user
this.Control[iCurrent+33]=this.uo_dateend
this.Control[iCurrent+34]=this.cbx_xout_auto_destroy
this.Control[iCurrent+35]=this.dw_xout_list
this.Control[iCurrent+36]=this.cb_paste
this.Control[iCurrent+37]=this.cb_1
this.Control[iCurrent+38]=this.cb_2
this.Control[iCurrent+39]=this.sle_serial
this.Control[iCurrent+40]=this.st_7
this.Control[iCurrent+41]=this.em_lotqty
this.Control[iCurrent+42]=this.cb_3
this.Control[iCurrent+43]=this.st_8
this.Control[iCurrent+44]=this.gb_3
end on

on w_pln_product_inout_scan_master.destroy
call super::destroy
destroy(this.st_11)
destroy(this.sle_pid)
destroy(this.ddlb_workstage_code)
destroy(this.st_2)
destroy(this.cbx_cancel)
destroy(this.rb_receipt_wait)
destroy(this.rb_history)
destroy(this.rb_inventory)
destroy(this.sle_model_name)
destroy(this.st_mrm_no)
destroy(this.em_qty)
destroy(this.st_model_name)
destroy(this.st_model_suffix)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.cbx_sound_on)
destroy(this.gb_5)
destroy(this.st_status)
destroy(this.sle_model_suffix)
destroy(this.st_4)
destroy(this.sle_workstage_type)
destroy(this.st_5)
destroy(this.rb_workstae_sum)
destroy(this.rb_today)
destroy(this.uo_dateset)
destroy(this.st_6)
destroy(this.ddlb_line_code)
destroy(this.cbx_allow_mix_model)
destroy(this.cbx_rework)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.cbx_lot_user)
destroy(this.uo_dateend)
destroy(this.cbx_xout_auto_destroy)
destroy(this.dw_xout_list)
destroy(this.cb_paste)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.sle_serial)
destroy(this.st_7)
destroy(this.em_lotqty)
destroy(this.cb_3)
destroy(this.st_8)
destroy(this.gb_3)
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
//f_retrieve()
f_set_column_dddw( dw_1 )
sle_pid.setfocus()

end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_SETYN
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'

	if rb_receipt_wait.checked = true then
		     dw_1.reset()
			dw_1.RETRIEVE( ddlb_line_code.getcode() ,  ddlb_workstage_code.getcode( ) ,   sle_model_name.text+'%' ,uo_dateset.text(),  GVI_ORGANIZATION_ID )
			dw_1.SETFOCUS()
			sle_pid.setfocus()
   elseif rb_history.checked = true then 
			dw_2.reset()
			dw_2.RETRIEVE( ddlb_line_code.getcode()+'%' ,  ddlb_workstage_code.getcode( )+'%' ,   sle_model_name.text+'%' , sle_serial.text+'%',uo_dateset.text() , uo_dateend.text() ,  GVI_ORGANIZATION_ID )
			dw_2.SETFOCUS()
			sle_pid.setfocus()		
   elseif rb_inventory.checked = true then 
			dw_3.reset()
			dw_3.RETRIEVE(uo_dateset.text() , uo_dateend.text() ,  ddlb_line_code.getcode()+'%' ,  ddlb_workstage_code.getcode( )+'%' ,   sle_model_name.text+'%' ,  GVI_ORGANIZATION_ID )
			dw_3.SETFOCUS()
		    f_set_column_dddw(dw_3)
			sle_pid.setfocus()		
			
		
	elseif rb_today.checked = true then 
		     em_qty.text = '0'
		    dw_5.reset()
			dw_5.RETRIEVE( ddlb_line_code.getcode() ,  ddlb_workstage_code.getcode( ) ,uo_dateset.text(), GVI_ORGANIZATION_ID )
			dw_5.SETFOCUS()
			sle_pid.setfocus()
		
	else 
		    em_qty.text = '0'
		    dw_4.reset()
			 
			dw_4.RETRIEVE(uo_dateset.text() , uo_dateend.text() ,  ddlb_line_code.getcode()+'%' ,  ddlb_workstage_code.getcode( )+'%' ,   sle_model_name.text+'%' ,  GVI_ORGANIZATION_ID )
			dw_4.SETFOCUS()
		    f_set_column_dddw(dw_4)
			sle_pid.setfocus()		
	end if 

	sle_pid.setfocus()
		
	CASE ELSE
END CHOOSE


end event

type dw_5 from w_main_root`dw_5 within w_pln_product_inout_scan_master
integer y = 832
integer width = 5531
integer height = 732
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_product_workstage_io_ws_list"
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_inout_scan_master
integer y = 832
integer width = 5531
integer height = 732
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_product_workstage_io_workstage_sum_list"
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_inout_scan_master
integer y = 832
integer width = 5531
integer height = 732
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_product_workstage_io_scan_ws_sum_list"
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_inout_scan_master
integer y = 832
integer width = 5531
integer height = 732
integer taborder = 0
boolean titlebar = true
string dataobject = "d_pln_product_workstage_io_list"
borderstyle borderstyle = styleraised!
end type

event dw_2::retrieveend;call super::retrieveend;em_qty.text = string(rowcount)

st_model_name.text = ''
st_model_suffix.text = ''
end event

type dw_1 from w_main_root`dw_1 within w_pln_product_inout_scan_master
integer y = 832
integer width = 5531
integer height = 732
integer taborder = 0
boolean titlebar = true
string title = "Product PID Scan List"
string dataobject = "d_pln_product_workstage_io_scan_list"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;sle_pid.setfocus()
end event

event dw_1::clicked;call super::clicked;sle_pid.setfocus()
end event

event dw_1::itemchanged;//over 
end event

event dw_1::retrieveend;call super::retrieveend;em_qty.text = string(rowcount)
if rowcount > 0 then 
	st_model_name.text = this.object.model_name[1]
	st_model_suffix.text = this.object.model_suffix[1]
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_inout_scan_master
integer taborder = 0
end type

type st_11 from so_statictext within w_pln_product_inout_scan_master
integer x = 649
integer y = 292
integer width = 713
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 134217734
long backcolor = 16777215
string text = "Line Code"
end type

type sle_pid from so_singlelineedit within w_pln_product_inout_scan_master
integer x = 4073
integer y = 676
integer width = 1394
integer height = 120
integer taborder = 10
boolean bringtotop = true
integer textsize = -14
long textcolor = 65280
long backcolor = 0
end type

event modified;call super::modified;STRING LVS_MODEL_NAME , LVS_MODEL_SUFFIX ,LVS_LINE_CODE ,LVS_WORKSTAGE_CODE   , lvs_interlock_return, lvs_run_no
STRING LVS_DEST_LINE_CODE ,LVS_DEST_WORKSTAGE_CODE  ,  LVS_ITEM_CODE , LVS_PID , LVS_WORKSTAGE_TYPE, LVS_CHECK_MSG  ,LVS_LOT_NO , lvs_barcode_status
LONG LVI_EXISTS , LVI_WIP_SEQ, last_wip_seq
long  i,j ,lvl_row , LVI_COUNT , LVL_IO_QTY 
DOUBLE LVDB_REECEIPT_SEQUENCE
datetime LVDT_DATE


if rb_inventory.checked = true then 
	return 
end if 

st_status.text = "Processing..."

//==================================================
// LVS_WORKSTAGE_TYPE $$HEX2$$74c72000$$ENDHEX$$L $$HEX19$$74c774ba2000e4c201c8200098ccacb97cb92000b8d2acb970acd0c51cc12000e4c289d52000$$ENDHEX$$
//==================================================
LVS_PID = THIS.TEXT  
LVS_LINE_CODE = ddlb_line_code.GETCODE() 
LVS_WORKSTAGE_CODE =ddlb_workstage_code.getcode()
LVS_WORKSTAGE_TYPE = sle_workstage_type.text 

//2018.07.31 $$HEX3$$94cd00ac2000$$ENDHEX$$
if lvs_pid = 'RESET' then 
	em_lotqty.text = '0'
	this.text = ''
	this.setfocus()
	return 
end if 


//==================================================
// $$HEX7$$78c730d17db72000b4cc6cd02000$$ENDHEX$$
//==================================================
  st_status.text = "Interlock Check Processing..."
  
  lvs_interlock_return = f_check_interlock_condition( LVS_LINE_CODE , LVS_WORKSTAGE_CODE , LVS_PID ) 
  if lvs_interlock_return <> 'OK'  then 
	 st_status.text = "Interlock Check => " +lvs_interlock_return
	return 
  else
	  st_status.text = "Interlock Check OK"
  end if 

//===================================================
//  $$HEX19$$e4b970acc4c9200085c79ccde0ac2000b4b0edc5d0c51cc12000a8ba78b385ba200070c88cd6$$ENDHEX$$
//  $$HEX7$$ecc530ae2000c6c53cc774ba2000$$ENDHEX$$pid $$HEX10$$29bcddc2200074c77cb7e0ac200010d3e8b22000$$ENDHEX$$
//===================================================

st_status.text = "Step #1 : Model Chceck"
SELECT   item_code, model_name, nvl(model_suffix , '*'), run_no , sysdate
	INTO  :lvs_item_code, :lvs_model_name, :lvs_model_suffix, :lvs_run_no , :LVDT_DATE
  FROM   IP_PRODUCT_RUN_CARD_IO
WHERE   MAGAZINE_LABEL_NO  =:LVS_PID 
     and rownum = 1 ;		
		
	
IF F_SQL_CHECK() < 0 THEN 
	f_play_sound( "S1.wav")
	sle_pid.text = ''
	sle_pid.setfocus()
	RETURN 
END IF 	
//===================================================
//
//===================================================
if lvs_model_name <> '' then 
	cbx_lot_user.checked = true 
else
	
		st_status.text = "Step #2 : Model Chceck"	
		//===================================================
		//  $$HEX7$$a8ba78b385ba200070c88cd62000$$ENDHEX$$
		//===================================================
		SELECT   item_code, model_name, nvl(model_suffix , '*') , BARCODE_STATUS , run_no , sysdate 
			INTO   :lvs_item_code, :lvs_model_name, :lvs_model_suffix , :lvs_barcode_status , :lvs_run_no , :LVDT_DATE
		  FROM   IP_PRODUCT_2D_BARCODE
		WHERE   SERIAL_NO  =:LVS_PID 
		     AND ROWNUM = 1 ;
		
			
			IF F_SQL_CHECK() < 0 THEN 
				f_play_sound( "S1.wav")
				sle_pid.text = ''
				sle_pid.setfocus()
				RETURN 
			END IF 	
			
			if lvs_model_name <> '' then 
				cbx_lot_user.checked = false 
			else	
					//====================================================
					//
					//====================================================
					IF LVS_MODEL_NAME = '' or isnull(LVS_MODEL_NAME) THEN 
						f_play_sound( "scanfailed.wav") 
						f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'MODEL NAME'))
						//======================================
						st_status.backcolor = rgb(255,255,0)
						st_status.textcolor = rgb(255,0,0)
						st_status.text = this.text + ' PID Can not Scan !!'
						//======================================
						sle_pid.text = ''
						sle_pid.setfocus()
						return 
					END IF 
			end if 
end if 

//==================================================
// $$HEX25$$74c7f8bb200018c2acb9e4c2d0c52000e4b4b4c504ac200018b174c774ba2000f5ac15c82000f1b45db8200088bd00ac2000$$ENDHEX$$
//==================================================
    lvi_count = 0 
st_status.text = "Step #4 : Repair Chceck"	 
		//$$HEX21$$18c2acb9e4c22000d0c51cc1200044c5c1c9200048c598b028c62000c1c0dcd074ba2000200020002000$$ENDHEX$$
  		SELECT F_CHECK_PID_STATUS_4_WS(:LVS_PID)
			INTO :LVS_CHECK_MSG 
			FROM DUAL ; 
		
			IF F_SQL_CHECK() < 0 THEN 
				f_play_sound( "S1.wav")
				sle_pid.text = ''
				sle_pid.setfocus()
				RETURN 
			END IF 		
			

if cbx_xout_auto_destroy.checked = true and lvs_barcode_status = 'X' then 

	//==================================================
	// x-out $$HEX22$$74c72000e4b4b4c524c674ba200018c2acb9e4c22000d0d330ae5cb8200090c7d9b32000f1b45db820000900$$ENDHEX$$
	//==================================================

		if LVS_CHECK_MSG <> 'OK' then 
		
			f_play_sound( "call4.wav")
			lvl_row = dw_xout_list.insertrow(0)
st_status.text = "Step #5 : X-out Build"	 			
			dw_xout_list.object.serial_no[lvl_row] = lvs_pid
			//===========================
			//$$HEX5$$15c8c1c0c1c0dcd02000$$ENDHEX$$
			//st_status.backcolor = rgb(0,0,0)
		     //st_status.textcolor = rgb(0,255,0)
			//=========================
			//$$HEX5$$d0c5ecb7c1c0dcd02000$$ENDHEX$$
			st_status.backcolor = rgb(255,255,0)
		     st_status.textcolor = rgb(255,0,0)
			//===========================
			st_status.text = f_msg("$$HEX17$$74c7f8bb200018c2acb92000f1b45db81cb4200000b330ae88d4200085c7c8b2e4b2$$ENDHEX$$" , "S" ) 
			st_status.text = f_msg_st(long(lvs_check_msg)) + ' ' + lvs_pid 
			sle_pid.text = ''
			sle_pid.setfocus()
			return 	
		end if 	
		
st_status.text = "Step #5 :Data Insert"	 
			  INSERT INTO "IP_PRODUCT_WORK_QC"  
					( "SERIAL_NO",   
					  "ITEM_CODE",   
					  "QC_DATE",   
					  "QC_SEQUENCE",   
					  "QC_RESULT",   
					  "SHIFT_CODE",   
					  "DEFECT_QTY",   
					  "RECEIPT_DEFICIT",   
					  "REPAIR_RESULT_CODE",   
					  "LINE_CODE",   
					  "WORKSTAGE_CODE",   
					  "MACHINE_CODE",   
					  "BAD_REASON_CODE",   
					  "BAD_QTY",   
					  "CHARGER",   
					  "REPAIR_BY",   
					  "REPAIR_DATE",   
					  "QC_INSPECT_HANDLING",   
					  "COMMENTS",   
					  "ORGANIZATION_ID",   
					  "ENTER_DATE",   
					  "ENTER_BY",   
					  "LAST_MODIFY_DATE",   
					  "LAST_MODIFY_BY",   
					  "MODEL_NAME",   
					  "LOCATION_CODE",   
					  "COMPLAINT_NO",   
					  "MODEL_SUFFIX",   
					  "REPAIR_WORKSTAGE_CODE",   
					  "REPAIR_LINE_CODE",   
					  "REPAIR_SUPPLIER_CODE",   
					  "REPAIR_DIVISION",   
					  "BAD_POSITION",   
					  "CARRIER_BARCODE",   
					  "RUN_DATE",   
					  "RUN_NO",   
					  "ARRAY_YN",   
					  "NEW_RUN_NO" )  
		  VALUES ( :LVS_PID,   
					  :LVS_ITEM_CODE,   
					  SYSDATE , //QC_DATE,   
					  SEQ_QC_REPAIR_SEQUENCE.NEXTVAL , //QC_SEQUENCE,   
					  'W'  , //QC_RESULT,   
					  F_GET_WORK_SHIFT_CODE( SYSDATE)  , //SHIFT_CODE,   
					  1 , //DEFECT_QTY,   
					  '1' , //RECEIPT_DEFICIT,   
					  'W' , //REPAIR_RESULT_CODE,   
					  :LVS_LINE_CODE,   
					  :LVS_WORKSTAGE_CODE,   
					  '*' , //MACHINE_CODE,   
					  'X-OUT' , //BAD_REASON_CODE,   
					  1 , //BAD_QTY,   
					  :GVS_USER_ID , //CHARGER,   
					  :GVS_USER_ID ,//REPAIR_BY,   
					  NULL , //REPAIR_DATE,   
					  'D' , //QC_INSPECT_HANDLING,   $$HEX6$$d0d330ae200098ccacb92000$$ENDHEX$$
					  'XOUT' , //COMMENTS,   
					  :GVI_ORGANIZATION_ID,   
					  SYSDATE , // ENTER_DATE,   
					  :GVS_USER_ID , //ENTER_BY,   
					  SYSDATE , //LAST_MODIFY_DATE,   
					  :GVS_USER_ID , //LAST_MODIFY_BY,   
					  :LVS_MODEL_NAME,   
					  NULL , //LOCATION_CODE,   
					  '*' , //COMPLAINT_NO,   
					  '*' , //MODEL_SUFFIX,   
					  '*', // REPAIR_WORKSTAGE_CODE,   
					  '*' , //REPAIR_LINE_CODE,   
					  '*' , //REPAIR_SUPPLIER_CODE,   
					  NULL , //REPAIR_DIVISION,   
					  NULL , //BAD_POSITION,   
					  NULL , //CARRIER_BARCODE,   
					  NULL , //RUN_DATE,   
					  NULL , //RUN_NO,   
					  'Y' ,   
					  NULL //NEW_RUN_NO
				 )  ;

			IF F_SQL_CHECK() < 0 THEN 
				f_play_sound( "S1.wav")
				sle_pid.text = ''
				sle_pid.setfocus()
				RETURN 
			END IF 	
			
	f_play_sound( "call4.wav")
	COMMIT ;
	lvl_row = dw_xout_list.insertrow(0)
st_status.text = "Step #6 : X-OUT Build"	 	
	dw_xout_list.object.serial_no[lvl_row] = lvs_pid
	
	sle_pid.text = ''
	sle_pid.setfocus()
	return 	
	
	
//$$HEX39$$d1c5a4c244c5c3c6200044c5c8b2e0ac200074c7f8bb200018c2acb9e4c2d0c5200088c73cc774ba20001dd3c5c5200054ba38c1c0c92000f0b6b0c6e0ac20002000f1b45db870ac80bd20000900$$ENDHEX$$
else
		//========================================
		//$$HEX16$$74c7f8bb200018c2acb9e4c2d0c52000f1b45db81cb4200018b174c774ba2000$$ENDHEX$$
		//$$HEX12$$74c7f8bb200028d3b9d074c720001cb418b174c774ba2000$$ENDHEX$$
		//========================================
		if LVS_CHECK_MSG <> 'OK' then 
			
			f_play_sound( "call4.wav")
			
		     //===========================
			//$$HEX5$$15c8c1c0c1c0dcd02000$$ENDHEX$$
			//st_status.backcolor = rgb(0,0,0)
		     //st_status.textcolor = rgb(0,255,0)
			//=========================
			//$$HEX5$$d0c5ecb7c1c0dcd02000$$ENDHEX$$
			st_status.backcolor = rgb(255,255,0)
		     st_status.textcolor = rgb(255,0,0)
			//===========================
			
			//f_msg("$$HEX40$$18c2acb92000f1b45db81cb4200000b330ae88d4200085c7c8b2e4b22000f5ac15c8200085c79ccde0ac2000f1b45db8200088bd00ac200018c2acb944c6ccb82000c4d62000f1b45db858d538c194c6$$ENDHEX$$" , "P" ) 
			f_msg(f_msg_st(long(lvs_check_msg)), "P")
			//st_status.text = f_msg("$$HEX40$$18c2acb92000f1b45db81cb4200000b330ae88d4200085c7c8b2e4b22000f5ac15c8200085c79ccde0ac2000f1b45db8200088bd00ac200018c2acb944c6ccb82000c4d62000f1b45db858d538c194c6$$ENDHEX$$" , "S" ) 
			st_status.text = f_msg_st(long(lvs_check_msg)) + ' ' + lvs_pid 
			
			sle_pid.text = ''
			sle_pid.setfocus()
			return 	
		end if 	
	
end if 

//==================================================
//
//==================================================
//if f_get_marking_yn(lvs_model_name) = 'Y' then 
//	cbx_lot_user.checked = true 
//else 
//	cbx_lot_user.checked = false 
//end if 
//==================================================
// $$HEX25$$18c2acb9e4c2d0c5200074c8acc7200058d5e0ac200018c2acb9e4c2d0c51cc120009ccde0ac18b4c0c920004ac540c72000$$ENDHEX$$PID $$HEX6$$7cc74cb52000c9b94cc72000$$ENDHEX$$
//==================================================


IF  cbx_lot_user.checked = true    THEN  
	
	   LVL_IO_QTY = F_GET_MAGAZINE_LOT_QTY(LVS_PID )
	   if LVL_IO_QTY = 0 then 
			LVL_IO_QTY = 1 
	  end if 
//================================================
// lot use $$HEX7$$00ac200044c5c8b274ba20002000$$ENDHEX$$pid $$HEX3$$29bcddc22000$$ENDHEX$$
//================================================
ELSE
	     LVL_IO_QTY = 1 ;
//		  
//		//$$HEX21$$18c2acb9e4c22000d0c51cc1200044c5c1c9200048c598b028c62000c1c0dcd074ba2000200020002000$$ENDHEX$$
//  		SELECT F_CHECK_PID_STATUS_4_WS(:LVS_PID)
//			INTO :LVS_CHECK_MSG 
//			FROM DUAL ; 
//		
//		if f_sql_check() < 0 then 
//			return 
//		end if 
//
//		if LVS_CHECK_MSG <> 'OK' then 
//			st_status.text = f_msg_st(long(lvs_check_msg)) + ' ' + lvs_pid 
//			sle_pid.text = ''
//			sle_pid.setfocus()
//			return 
//		end if 
 END IF 		
 
 

//===================================================
//
//===================================================

IF LVS_LINE_CODE = ''  or LVS_LINE_CODE = '%' or isnull(LVS_LINE_CODE) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'LINE CODE'))
	sle_pid.text = ''
	RETURN 
END IF 

IF LVS_WORKSTAGE_CODE = ''  or LVS_WORKSTAGE_CODE = '%' or isnull(LVS_WORKSTAGE_CODE) THEN 
	f_msgbox1(102  ,f_get_dual_lang_text ( gvs_language , 'WORKSTAGE CODE'))
	sle_pid.text = ''
	RETURN 
END IF 

//====================================================
//cbx_cancel $$HEX14$$e8cd8cc1200074d5f9b22000f5ac15c8d0c51cc12000adc01cc82000$$ENDHEX$$
//====================================================

	if cbx_cancel.checked = true then 
	

			SELECT COUNT(*)  , MAX( DEST_LINE_CODE ) , MAX(DEST_WORKSTAGE_CODE) , MAX(WIP_SEQ)
				 INTO :LVI_COUNT , :LVS_DEST_LINE_CODE ,:LVS_DEST_WORKSTAGE_CODE  , :LVI_WIP_SEQ
				from IP_PRODUCT_WORKSTAGE_IO 
			where SERIAL_NO        = :lvs_pid 
			      and line_code            = :lvs_line_code 
				 and workstage_code = :lvs_workstage_code
				 and io_deficit           = 'I' ;  //$$HEX26$$c0d02000f5ac15c83cc75cb8200018b1b4c500acc0c920004ac540c7200070b374c730d194b2200058d598b0d0bf84c720002000$$ENDHEX$$
				 
			IF F_SQL_CHECK() < 0 THEN 
				sle_pid.text = ''
				f_play_sound( "S1.wav")
				RETURN 
			END IF 
		
			IF LVI_COUNT > 0 THEN 
			
						SELECT nvl(max(wip_seq),0)
							 into :last_wip_seq 
						  FROM IP_PRODUCT_WORKSTAGE_IO
						  where serial_no = :lvs_pid
							 and wip_seq   < :LVI_WIP_SEQ ; 
									 
						//$$HEX21$$f5ac15c8200058c720009ccde0ac2000c1c0dcd07cb9200078c72000c1c0dcd05cb82000c0bcbdac2000$$ENDHEX$$
						//Trigger $$HEX8$$91c7c5c53cc75cb82000c0bcbdac2000$$ENDHEX$$2015.12.21
						UPDATE IP_PRODUCT_WORKSTAGE_IO 
								SET IO_DEFICIT = 'I' , 
									 OUT_DATE = NULL  , 
									DEST_LINE_CODE = NULL , 
									DEST_WORKSTAGE_CODE = NULL
							where  SERIAL_NO       = :lvs_pid 
							 and     dest_line_code  = :lvs_line_code 
							 and     dest_workstage_code = :lvs_workstage_code
							 and     io_deficit = 'O' 
							 and     wip_seq  = :last_wip_seq ;	
							 
						IF F_SQL_CHECK() < 0 THEN 
							sle_pid.text = ''
							f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
							RETURN 
						END IF 		
			
							//$$HEX12$$04d6f5ac15c858c7200070b374c730d12000adc01cc82000$$ENDHEX$$
							delete from IP_PRODUCT_WORKSTAGE_IO 
							where  SERIAL_NO        = :lvs_pid 
							     and line_code            = :lvs_line_code 
								 and workstage_code = :lvs_workstage_code
								 and io_deficit           = 'I' 
								 and wip_seq            = :LVI_WIP_SEQ ;
								 
							IF F_SQL_CHECK() < 0 THEN 
								sle_pid.text = ''
								f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
								RETURN 
							END IF 
							em_qty.text = string(long(em_qty.text) - 1 )
							//$$HEX3$$94cd00ac2000$$ENDHEX$$2018.07.31
							em_lotqty.text = string(long(em_lotqty.text) - 1) 
		
			
			ELSE 
			
				f_msgbox1(9200  , lvs_pid )
				st_status.text = f_msg_st1(9200  , lvs_pid )
			
				sle_pid.text = ''
				f_play_sound( "$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
				RETURN 
		END IF 
//=====================================================
// $$HEX8$$e8cd8cc100ac200044c5c8b274ba2000$$ENDHEX$$
//=====================================================
else

						IF  LVS_MODEL_NAME <> st_model_name.text  and cbx_allow_mix_model.checked = false THEN 
						//$$HEX5$$a8ba78b3c0bcbdac2000$$ENDHEX$$
										MSG = F_MSGBOX1(1161 ,f_get_dual_lang_text( gvs_language , 'MODEL CHANGE') )
										IF MSG = 1 THEN 
										
										em_qty.text = '0' 
										//20128.07.31 $$HEX3$$94cd00ac2000$$ENDHEX$$
										em_lotqty.text = '0' 
										/////////////////////////
										dw_1.reset()
										st_model_name.text = LVS_MODEL_NAME
										st_model_suffix.text = LVS_MODEL_SUFFIX
										
										ELSE
												f_play_sound( "S1.wav")
												sle_pid.text = ''
												sle_pid.setfocus()
												RETURN 
										END IF 
						ELSE
								st_model_name.text = LVS_MODEL_NAME
								st_model_suffix.text = LVS_MODEL_SUFFIX
						END IF 

						//====================================================
						//
						//====================================================
						IF cbx_rework.checked = false    THEN   
						
							//====================================================
							// $$HEX11$$74c7f8bb74c8acc7200020c734bb2000b4cc6cd02000$$ENDHEX$$
							// $$HEX19$$74d5f9b22000f5ac15c83cc75cb82000e4b2dcc220002cc6200018c2c4b3200088c74cc72000$$ENDHEX$$
							// $$HEX31$$74d5f9b2f5ac15c8d0c51cc1200044c5c1c9200060be38c8200098b000acc0c920004ac540c7200070b374c730d1200088c794b2c0c92000b4cc6cd02000$$ENDHEX$$
							//====================================================
							st_status.text = "Step #7 : Inout Status Check"	 
								 SELECT COUNT(*) 
									INTO :LVI_EXISTS 
									FROM  IP_PRODUCT_WORKSTAGE_IO
								 WHERE SERIAL_NO            = :LVS_PID
									 AND LINE_CODE             = :LVS_LINE_CODE
									 AND WORKSTAGE_CODE = :LVS_WORKSTAGE_CODE 
									 AND IO_DEFICIT = 'I' ;     //$$HEX21$$74d5f9b22000f5ac15c844c7200060be38c8200098b000acc0c92000bbba5cd5200070b374c730d12000$$ENDHEX$$
									
								  IF F_SQL_CHECK() < 0 THEN 
									  sle_pid.text = ''
									  sle_pid.setfocus()
										RETURN 
								  END IF 
							
									IF 	LVI_EXISTS > 0 THEN 
									 //F_MSGBOX1(813 , LVS_PID)
									//$$HEX5$$15c8c1c0c1c0dcd02000$$ENDHEX$$
									st_status.backcolor = rgb(0,0,0)
									st_status.textcolor = rgb(0,255,0)
									 st_status.text = f_msg_st1(813 , LVS_PID)
									 f_play_sound( "scanfailed.wav")
									 sle_pid.text = ''
									 sle_pid.setfocus()
									 RETURN 
								 END IF 
						
						END IF

						//====================================================
						//
						//====================================================
						
						LVDB_REECEIPT_SEQUENCE = F_GET_SEQUENCE('SEQ_MAGAZINE_RECEIPT_SEQUENCE') 
						st_status.text = "Step #8 : Inout Insert"	 
						INSERT INTO IP_PRODUCT_WORKSTAGE_IO  
							  ( IO_DATE,   
								IO_SEQUENCE,   
								RUN_NO,   
								ITEM_CODE,   
								SERIAL_NO,   
								LINE_CODE,   
								WORKSTAGE_CODE,   
								IO_DEFICIT,   
								IO_QTY,   
								ORGANIZATION_ID,   
								ENTER_DATE,   
								ENTER_BY,   
								LAST_MODIFY_DATE,   
								LAST_MODIFY_BY ,
								MODEL_NAME ,
								MODEL_SUFFIX,
								WORKSTAGE_TYPE )  
						VALUES (SYSDATE,   
							  :LVDB_REECEIPT_SEQUENCE,   
					           :LVS_RUN_NO , // F_GET_RUN_NO_BY_PID(  :LVS_PID) , //RUN_NO,   2D $$HEX36$$14bc54cfdcb42000c8b9a4c230d17cb920003cba00c82000a4b4c0c9e0ac2000c6c53cc774ba20006fb8b8d27cb7200010d3e8b274d51cc12000e4b970acc4c92000a4b4d0c92000$$ENDHEX$$
							  :LVS_ITEM_CODE,   
							  :LVS_PID,     //magazine label_no
							  :LVS_LINE_CODE,   
							  :LVS_WORKSTAGE_CODE,   
							  'I' , //IO_DEFICIT,   
							  :LVL_IO_QTY , //IO_QTY,   
							  :GVI_ORGANIZATION_ID,   
							  SYSDATE , //ENTER_DATE,   
							  :GVS_USER_ID , //ENTER_BY,   
							  SYSDATE,   
							  :GVS_USER_ID ,
							  :LVS_MODEL_NAME ,
							  :LVS_MODEL_SUFFIX,
							  :LVS_WORKSTAGE_TYPE
							 )  ;
						
						 IF F_SQL_CHECK() < 0 THEN 
							f_play_sound( "S1.wav")
							sle_pid.text = ''
							RETURN 
						END IF 
						//============================================
						// $$HEX10$$f5ac15c8b5d1fcac74c725b82000a8b040ae2000$$ENDHEX$$
						//============================================
						//string LVS_OUT
						//LVS_OUT = space(1000) ;
						//sqlca.p_interlock_set_check_data (   lvs_line_code ,lvs_workstage_code ,'*' ,lvs_item_code ,	LVS_PID ,'OK'  ,	'', '' , '' , '' ,'' ,LVS_OUT ) ;
						 

end if 
	
	
//===============================================
//
//===============================================

if cbx_cancel.checked  then 
	
else
	  st_status.text = "Step #9 :History Insert"	 
	  
	  
	  if dw_1.rowcount() > 20 then 
		
		dw_1.reset()
		
	  end if 
	  
	  
	  lvl_row = dw_1.insertrow(1)
		
	  dw_1.object.model_name[lvl_row] = lvs_model_name 
	  dw_1.object.model_suffix[lvl_row] = lvs_model_suffix
	  dw_1.object.line_code[lvl_row] = lvs_line_code
	  dw_1.object.workstage_code[lvl_row] = lvs_workstage_code
	  dw_1.object.item_code[lvl_row] = lvs_item_code
	  dw_1.object.serial_no[lvl_row] = lvs_pid
	  dw_1.object.io_date[lvl_row] = LVDT_DATE
	  dw_1.object.io_qty[lvl_row] =LVL_IO_QTY
	  dw_1.object.io_deficit[lvl_row] = 'I'
end if

//==================================================
//
//==================================================
//===========================
//$$HEX5$$15c8c1c0c1c0dcd02000$$ENDHEX$$
st_status.backcolor = rgb(0,0,0)
st_status.textcolor = rgb(0,255,0)
//=========================
//$$HEX5$$d0c5ecb7c1c0dcd02000$$ENDHEX$$
//st_status.backcolor = rgb(255,255,0)
// st_status.textcolor = rgb(255,0,0)
//===========================
st_status.text =f_msg_st1(107 , LVS_PID) // "$$HEX11$$15c8c1c0200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$" --107

COMMIT ;

if cbx_sound_on.checked = true then 
	f_play_sound( "OK.wav")
end if 

em_qty.text = string(long(em_qty.text) + 1 )
//$$HEX3$$94cd00ac2000$$ENDHEX$$2018.07.31
em_lotqty.text = string(long(em_lotqty.text) + 1) 

sle_pid.text = ''
sle_pid.setfocus( )


end event

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_inout_scan_master
integer x = 1371
integer y = 380
integer width = 695
integer height = 1912
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;//RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "IO_WORKSTAGE", RegString!,THIS.GETCODE())
// 
f_jsSetProfileString ("WORKENV.INI", "WORKSTAGE", "WORKSTAGE_IO", THIS.GETCODE() )
IVS_WORkstage_code = THIS.GETCODE()

SELECT WORKSTAGE_TYPE INTO :IVS_TYPE 
  FROM IP_PRODUCT_WORKSTAGE
 WHERE WORKSTAGE_CODE = :IVS_WORKstage_code 
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		
IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 
		
sle_workstage_type.text  = IVS_TYPE

sle_pid.setfocus()
f_retrieve()

end event

event constructor;call super::constructor;//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "IO_WORKSTAGE", RegString!,  IVS_WORKSTAGE_CODE)

IVS_WORKSTAGE_CODE = Profilestring("WORKENV.INI","WORKSTAGE","WORKSTAGE_IO","")
THIS.SELECtitem(IVS_WORKSTAGE_CODE )

//========================================
// $$HEX7$$f5ac15c858c7200020c715d62000$$ENDHEX$$
//========================================
SELECT WORKSTAGE_TYPE INTO :IVS_TYPE 
  FROM IP_PRODUCT_WORKSTAGE
 WHERE WORKSTAGE_CODE = :IVS_WORKstage_code 
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		
IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 
		
sle_workstage_type.text  = IVS_TYPE




end event

type st_2 from so_statictext within w_pln_product_inout_scan_master
integer x = 1381
integer y = 292
integer width = 695
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 134217734
long backcolor = 16777215
string text = "Workstage Code"
end type

type cbx_cancel from so_checkbox within w_pln_product_inout_scan_master
integer x = 4078
integer y = 580
integer width = 421
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "Cancel"
end type

event clicked;call super::clicked;sle_pid.setfocus()
end event

type rb_receipt_wait from so_radiobutton within w_pln_product_inout_scan_master
integer x = 41
integer y = 308
integer width = 530
boolean bringtotop = true
long backcolor = 16777215
string text = "Scan List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
uo_dateend.visible = false 
sle_pid.setfocus()
end event

type rb_history from so_radiobutton within w_pln_product_inout_scan_master
integer x = 41
integer y = 404
integer width = 530
boolean bringtotop = true
long backcolor = 16777215
string text = "Scan History"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
uo_dateend.visible = true
sle_pid.setfocus()
end event

type rb_inventory from so_radiobutton within w_pln_product_inout_scan_master
integer x = 41
integer y = 500
integer width = 530
boolean bringtotop = true
long backcolor = 16777215
string text = "Scan Daliy Summary"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
uo_dateend.visible = true
sle_pid.setfocus()
end event

type sle_model_name from so_singlelineedit within w_pln_product_inout_scan_master
integer x = 3205
integer y = 380
integer width = 590
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -12
end type

type st_mrm_no from so_statictext within w_pln_product_inout_scan_master
integer x = 3218
integer y = 292
integer width = 590
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 134217734
long backcolor = 16777215
string text = "Model Name"
end type

type em_qty from so_editmask within w_pln_product_inout_scan_master
integer x = 2766
integer y = 672
integer width = 498
integer height = 120
boolean bringtotop = true
integer textsize = -16
string text = "0"
alignment alignment = center!
boolean displayonly = true
string mask = "###,##0"
end type

type st_model_name from so_statictext within w_pln_product_inout_scan_master
integer x = 1920
integer y = 676
integer width = 841
integer height = 120
boolean bringtotop = true
integer textsize = -16
integer weight = 700
long textcolor = 16711680
long backcolor = 134217750
end type

type st_model_suffix from so_statictext within w_pln_product_inout_scan_master
boolean visible = false
integer x = 5312
integer y = 388
integer width = 151
integer height = 120
boolean bringtotop = true
integer textsize = -16
integer weight = 700
long textcolor = 16711680
long backcolor = 134217750
end type

type st_1 from so_statictext within w_pln_product_inout_scan_master
integer x = 1920
integer y = 588
integer width = 841
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 134217734
long backcolor = 16777215
string text = "Model Name / Suffix"
end type

type st_3 from so_statictext within w_pln_product_inout_scan_master
integer x = 2766
integer y = 584
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 134217734
long backcolor = 16777215
string text = "Scan Qty"
end type

type cbx_sound_on from so_checkbox within w_pln_product_inout_scan_master
integer x = 654
integer y = 624
integer width = 325
integer height = 72
boolean bringtotop = true
long textcolor = 0
long backcolor = 16777215
string text = "Sound On"
boolean checked = true
end type

event clicked;call super::clicked;sle_pid.setfocus()
end event

type gb_5 from so_groupbox within w_pln_product_inout_scan_master
integer y = 204
integer width = 594
integer height = 616
integer textsize = -10
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Category"
end type

type st_status from so_statictext within w_pln_product_inout_scan_master
integer width = 5499
integer height = 196
integer textsize = -22
long textcolor = 65280
long backcolor = 0
string text = "Message"
end type

type sle_model_suffix from so_singlelineedit within w_pln_product_inout_scan_master
integer x = 3803
integer y = 380
integer width = 421
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -12
end type

type st_4 from so_statictext within w_pln_product_inout_scan_master
integer x = 3794
integer y = 292
integer width = 421
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 134217734
long backcolor = 16777215
string text = "Suffix"
end type

type sle_workstage_type from so_singlelineedit within w_pln_product_inout_scan_master
integer x = 2075
integer y = 380
integer width = 256
integer height = 88
integer taborder = 20
boolean bringtotop = true
long backcolor = 134217750
boolean displayonly = true
end type

type st_5 from so_statictext within w_pln_product_inout_scan_master
integer x = 2066
integer y = 292
integer width = 256
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 134217734
long backcolor = 16777215
string text = "Type"
end type

type rb_workstae_sum from so_radiobutton within w_pln_product_inout_scan_master
integer x = 41
integer y = 596
integer width = 530
boolean bringtotop = true
long backcolor = 16777215
string text = "Scan Workstage Sum"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4
uo_dateend.visible = true
sle_pid.setfocus()
end event

type rb_today from so_radiobutton within w_pln_product_inout_scan_master
integer x = 41
integer y = 688
integer width = 530
boolean bringtotop = true
long backcolor = 16777215
string text = "Today Scan List"
end type

event clicked;call super::clicked;dw_5.bringtotop = true 
selected_data_window = dw_5
uo_dateend.visible = true
sle_pid.setfocus()
end event

type uo_dateset from uo_ymd_calendar within w_pln_product_inout_scan_master
event destroy ( )
integer x = 2345
integer y = 380
integer height = 88
integer taborder = 20
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_6 from so_statictext within w_pln_product_inout_scan_master
integer x = 2345
integer y = 292
integer width = 841
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 134217734
long backcolor = 16777215
string text = "Date"
end type

type ddlb_line_code from uo_line_code_dd within w_pln_product_inout_scan_master
integer x = 645
integer y = 380
integer width = 722
integer height = 1808
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;//RegistryGet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "IO_LINE", RegString!,  IVS_LINE_CODE)
// 2017.03.17

IVS_LINE_CODE = Profilestring("WORKENV.INI","LINE","WORKSTAGE_IO","")
THIS.SELECtitem(IVS_LINE_CODE )


end event

event selectionchanged;call super::selectionchanged;//RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\"+GVS_APPLICATION_NAME, "IO_LINE", RegString!,THIS.GETCODE())
f_jsSetProfileString ("WORKENV.INI", "LINE", "WORKSTAGE_IO", THIS.GETCODE() )

IVS_LINE_CODE = THIS.GETCODE()

//messagebox('a',ivs_line_Code) 
sle_pid.setfocus()


end event

type cbx_allow_mix_model from so_checkbox within w_pln_product_inout_scan_master
string tag = "$$HEX7$$a8ba78b33cd685c7c8d5a9c668d5$$ENDHEX$$"
integer x = 654
integer y = 704
integer width = 411
integer height = 72
boolean bringtotop = true
long textcolor = 0
long backcolor = 16777215
string text = "Allow Mix Model"
boolean checked = true
end type

event clicked;call super::clicked;sle_pid.setfocus()
end event

type cbx_rework from so_checkbox within w_pln_product_inout_scan_master
integer x = 4814
integer y = 580
integer width = 402
integer height = 92
boolean bringtotop = true
integer textsize = -10
long textcolor = 134217734
long backcolor = 16777215
string text = "Rework"
end type

event clicked;call super::clicked;sle_pid.setfocus()
end event

type gb_1 from so_groupbox within w_pln_product_inout_scan_master
integer x = 603
integer y = 524
integer width = 1285
integer height = 296
integer taborder = 10
integer textsize = -10
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Scan Option"
end type

type gb_2 from so_groupbox within w_pln_product_inout_scan_master
integer x = 603
integer y = 204
integer width = 4654
integer height = 312
integer textsize = -10
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Where Condition"
end type

type cbx_lot_user from so_checkbox within w_pln_product_inout_scan_master
integer x = 4453
integer y = 580
integer width = 338
integer height = 92
boolean bringtotop = true
integer textsize = -10
long textcolor = 134217734
long backcolor = 16777215
string text = "Lot Use"
end type

event clicked;call super::clicked;sle_pid.setfocus()
end event

type uo_dateend from uo_ymd_calendar within w_pln_product_inout_scan_master
boolean visible = false
integer x = 2779
integer y = 380
integer height = 88
integer taborder = 30
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type cbx_xout_auto_destroy from so_checkbox within w_pln_product_inout_scan_master
string tag = "$$HEX7$$a8ba78b33cd685c7c8d5a9c668d5$$ENDHEX$$"
integer x = 1216
integer y = 620
integer width = 635
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "X-OUT Auto Destroy"
boolean checked = true
end type

type dw_xout_list from so_datawindow within w_pln_product_inout_scan_master
integer x = 5541
integer y = 208
integer width = 1207
integer height = 460
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "X-OUT LIST"
string dataobject = "vd_serial_no"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type cb_paste from so_commandbutton within w_pln_product_inout_scan_master
integer x = 5554
integer y = 700
integer width = 393
integer height = 120
integer taborder = 20
boolean bringtotop = true
string text = "Paste"
end type

event clicked;call super::clicked;dw_xout_list.reset()
dw_xout_list.importclipboard()
end event

type cb_1 from so_commandbutton within w_pln_product_inout_scan_master
integer x = 5947
integer y = 700
integer width = 425
integer height = 120
integer taborder = 30
boolean bringtotop = true
string text = "Batch Scan"
end type

event clicked;call super::clicked;int i 



if dw_xout_list.getrow() < 1 then 
	return 
end if 

do
	i++
	
	yield()
	
	sle_pid.text = dw_xout_list.object.serial_no[i]
	sle_pid.triggerevent( modified! ) 
	
loop until i = dw_xout_list.rowcount()
end event

type cb_2 from so_commandbutton within w_pln_product_inout_scan_master
integer x = 6377
integer y = 700
integer width = 366
integer height = 120
integer taborder = 30
boolean bringtotop = true
string text = "Save"
end type

event clicked;call super::clicked;dw_xout_list.saveas()
end event

type sle_serial from so_singlelineedit within w_pln_product_inout_scan_master
integer x = 4229
integer y = 376
integer width = 960
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -12
long backcolor = 65535
end type

type st_7 from so_statictext within w_pln_product_inout_scan_master
integer x = 4233
integer y = 292
integer width = 960
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 134217734
long backcolor = 16777215
string text = "Barcode"
end type

type em_lotqty from so_editmask within w_pln_product_inout_scan_master
integer x = 3273
integer y = 672
integer width = 439
integer height = 120
integer taborder = 50
boolean bringtotop = true
integer textsize = -16
long textcolor = 255
string text = "0"
alignment alignment = center!
boolean displayonly = true
string mask = "###,##0"
end type

type cb_3 from commandbutton within w_pln_product_inout_scan_master
integer x = 3721
integer y = 672
integer width = 274
integer height = 120
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Reset"
end type

event clicked;//$$HEX3$$94cd00ac2000$$ENDHEX$$2018.07.31
em_lotqty.text = '0' 
sle_pid.setfocus()
end event

type st_8 from so_statictext within w_pln_product_inout_scan_master
integer x = 3259
integer y = 584
integer width = 457
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
long textcolor = 134217734
long backcolor = 16777215
string text = "Lot Scan Qty"
end type

type gb_3 from so_groupbox within w_pln_product_inout_scan_master
integer x = 1897
integer y = 524
integer width = 3607
integer height = 296
integer taborder = 40
integer textsize = -10
integer weight = 700
long textcolor = 255
long backcolor = 16777215
string text = "Scan Info."
end type


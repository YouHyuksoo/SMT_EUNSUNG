HA$PBExportHeader$w_qc_oqc_inspect_history_master.srw
$PBExportComments$$$HEX17$$b9c278c7d0c658c7a8ba78b3d0c5200000b35cd52000b9d231c144c7200000adacb9$$ENDHEX$$
forward
global type w_qc_oqc_inspect_history_master from w_main_root
end type
type sle_pid_scan from so_singlelineedit within w_qc_oqc_inspect_history_master
end type
type st_1 from so_statictext within w_qc_oqc_inspect_history_master
end type
type sle_model_name from so_singlelineedit within w_qc_oqc_inspect_history_master
end type
type st_mrm_no from so_statictext within w_qc_oqc_inspect_history_master
end type
type sle_inspector from so_singlelineedit within w_qc_oqc_inspect_history_master
end type
type st_2 from so_statictext within w_qc_oqc_inspect_history_master
end type
type sle_item_code from so_singlelineedit within w_qc_oqc_inspect_history_master
end type
type st_7 from so_statictext within w_qc_oqc_inspect_history_master
end type
type rb_manage from so_radiobutton within w_qc_oqc_inspect_history_master
end type
type rb_history from so_radiobutton within w_qc_oqc_inspect_history_master
end type
type st_4 from so_statictext within w_qc_oqc_inspect_history_master
end type
type uo_dateset from uo_ymd_calendar within w_qc_oqc_inspect_history_master
end type
type uo_dateend from uo_ymd_calendar within w_qc_oqc_inspect_history_master
end type
type rb_normal from so_radiobutton within w_qc_oqc_inspect_history_master
end type
type rb_cancel from so_radiobutton within w_qc_oqc_inspect_history_master
end type
type cbx_issue_pid_check from so_checkbox within w_qc_oqc_inspect_history_master
end type
type rb_1 from so_radiobutton within w_qc_oqc_inspect_history_master
end type
type rb_today from so_radiobutton within w_qc_oqc_inspect_history_master
end type
type gb_1 from so_groupbox within w_qc_oqc_inspect_history_master
end type
type gb_2 from so_groupbox within w_qc_oqc_inspect_history_master
end type
type gb_3 from so_groupbox within w_qc_oqc_inspect_history_master
end type
type gb_4 from so_groupbox within w_qc_oqc_inspect_history_master
end type
end forward

global type w_qc_oqc_inspect_history_master from w_main_root
integer width = 6085
integer height = 2880
string title = "OQC Inspect History Master(PID)"
string ivs_dw_2_selected_row_yn = "Y"
string ivs_dw_3_selected_row_yn = "Y"
sle_pid_scan sle_pid_scan
st_1 st_1
sle_model_name sle_model_name
st_mrm_no st_mrm_no
sle_inspector sle_inspector
st_2 st_2
sle_item_code sle_item_code
st_7 st_7
rb_manage rb_manage
rb_history rb_history
st_4 st_4
uo_dateset uo_dateset
uo_dateend uo_dateend
rb_normal rb_normal
rb_cancel rb_cancel
cbx_issue_pid_check cbx_issue_pid_check
rb_1 rb_1
rb_today rb_today
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_qc_oqc_inspect_history_master w_qc_oqc_inspect_history_master

type variables
long lvi_row
end variables

on w_qc_oqc_inspect_history_master.create
int iCurrent
call super::create
this.sle_pid_scan=create sle_pid_scan
this.st_1=create st_1
this.sle_model_name=create sle_model_name
this.st_mrm_no=create st_mrm_no
this.sle_inspector=create sle_inspector
this.st_2=create st_2
this.sle_item_code=create sle_item_code
this.st_7=create st_7
this.rb_manage=create rb_manage
this.rb_history=create rb_history
this.st_4=create st_4
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.rb_normal=create rb_normal
this.rb_cancel=create rb_cancel
this.cbx_issue_pid_check=create cbx_issue_pid_check
this.rb_1=create rb_1
this.rb_today=create rb_today
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_pid_scan
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_model_name
this.Control[iCurrent+4]=this.st_mrm_no
this.Control[iCurrent+5]=this.sle_inspector
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.sle_item_code
this.Control[iCurrent+8]=this.st_7
this.Control[iCurrent+9]=this.rb_manage
this.Control[iCurrent+10]=this.rb_history
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.uo_dateset
this.Control[iCurrent+13]=this.uo_dateend
this.Control[iCurrent+14]=this.rb_normal
this.Control[iCurrent+15]=this.rb_cancel
this.Control[iCurrent+16]=this.cbx_issue_pid_check
this.Control[iCurrent+17]=this.rb_1
this.Control[iCurrent+18]=this.rb_today
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_2
this.Control[iCurrent+21]=this.gb_3
this.Control[iCurrent+22]=this.gb_4
end on

on w_qc_oqc_inspect_history_master.destroy
call super::destroy
destroy(this.sle_pid_scan)
destroy(this.st_1)
destroy(this.sle_model_name)
destroy(this.st_mrm_no)
destroy(this.sle_inspector)
destroy(this.st_2)
destroy(this.sle_item_code)
destroy(this.st_7)
destroy(this.rb_manage)
destroy(this.rb_history)
destroy(this.st_4)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.rb_normal)
destroy(this.rb_cancel)
destroy(this.cbx_issue_pid_check)
destroy(this.rb_1)
destroy(this.rb_today)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
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

sle_pid_scan.setfocus( )

end event

event ue_data_control;call super::ue_data_control;choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
		
		if rb_manage.checked = true then 
		elseif rb_history.checked = true then 
			
			dw_2.retrieve( uo_dateset.text() , uo_dateend.text() , 'P'+'%' , gvi_organization_id ,  sle_model_name.text + '%', sle_item_code.text+'%', sle_pid_scan.text+'%' )
			
		elseif rb_today.checked = true then 
			
			dw_4.retrieve( uo_dateset.text() , '%' , gvi_organization_id ,  sle_model_name.text + '%', sle_item_code.text+'%', sle_pid_scan.text+'%' )
			
		end if 
	CASE 'INSERT'
	
			lvi_row = dw_1.insertrow(dw_1.getrow())
			dw_1.scrolltorow(lvi_row)
			f_set_security_row(dw_1 , lvi_row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
			
	CASE 'APPEND'
	
			lvi_row = dw_1.insertrow(0)
			dw_1.scrolltorow(lvi_row)
			f_set_security_row(dw_1 , lvi_row , 'ALL')
			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )	
			
	case 'DELETE'
		
		  	if dw_1.getrow() < 1 then return 
			  
			msg =f_msgbox(1003)
			if msg = 1 then
				gvl_row_deleted = dw_1.getrow()			
				dw_1.deleterow(gvl_row_deleted)		
				dw_1.setfocus()
				lvi_row = dw_1.getrow()
				dw_1.scrolltorow(lvi_row)
				dw_1.setcolumn(1)
			end if
			
	case 'UPDATE'
		
			if dw_1.update() < 0 OR  dw_2.update() < 0 then
				rollback;
			else
				commit;
				f_msg_mdi_help(f_msg_st(170))
			end if
			
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_qc_oqc_inspect_history_master
integer y = 372
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_qc_oqc_inspect_history_master
integer y = 372
integer width = 5010
integer height = 1768
integer taborder = 0
boolean titlebar = true
string dataobject = "d_iq_oqc_insepct_history_4_today_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_qc_oqc_inspect_history_master
integer y = 372
integer width = 5010
integer height = 1768
integer taborder = 0
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_qc_oqc_inspect_history_master
integer y = 372
integer width = 5010
integer height = 1768
integer taborder = 0
boolean titlebar = true
string dataobject = "d_iq_oqc_insepct_history_rpt"
end type

type dw_1 from w_main_root`dw_1 within w_qc_oqc_inspect_history_master
integer y = 372
integer width = 6002
integer height = 1768
integer taborder = 0
boolean titlebar = true
string title = "Manage"
string dataobject = "d_iq_oqc_insepct_history"
end type

event dw_1::clicked;call super::clicked;sle_pid_scan.setfocus( )
end event

event dw_1::doubleclicked;call super::doubleclicked;if row < 1 then return 
//openwithparm( w_qc_inspect_4_gmes_popup , string( this.object.product_id[row] ))
end event

type uo_tabpages from w_main_root`uo_tabpages within w_qc_oqc_inspect_history_master
integer taborder = 0
end type

type sle_pid_scan from so_singlelineedit within w_qc_oqc_inspect_history_master
integer x = 2638
integer y = 164
integer width = 832
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;string lvs_serial_no ,  lvs_line_code  , lvs_item_code , lvs_model_name , lvs_model_suffix , lvs_inspect_type, lvs_inspector , lvs_pid_status
long lvl_sequence  , lvi_count





if rb_normal.checked = true then 
	
			//===================================================
			//   $$HEX8$$b8d2acb970acd0c5200058c774d52000$$ENDHEX$$IP_PRODUCT_2D_BARCOE $$HEX2$$58c72000$$ENDHEX$$QC_SCAN_YN $$HEX11$$d0c520000cd598b7f8ad2000c5c570b374c7b8d22000$$ENDHEX$$
			//===================================================
			if rb_manage.checked = true then 
			
			else
				return 
			end if 
			
			lvs_inspect_type =  'P'
			lvs_inspector       = sle_inspector.text 
			lvs_serial_no       = this.text 
			
			if lvs_inspect_type = '' or isnull(lvs_inspect_type) then 
				f_play_sound("$$HEX5$$6cad84bdf8bb20c1ddd0$$ENDHEX$$.wav")
				sle_pid_scan.text = ''
				sle_pid_scan.setfocus( )
				Return 	
			end if
			
			//$$HEX12$$80acacc090c72000c6c544c74cb520000900090009000900$$ENDHEX$$
			if lvs_inspector = '' then 
				f_msg( "$$HEX11$$91c7c5c590c77cb9200085c725b8200058d538c194c6$$ENDHEX$$" , "P" )
				this.text = ''
				sle_inspector.setfocus( )
				sle_inspector.backcolor = 255
				Return 
			end if 
			
			//==============================================
			//$$HEX19$$30ae200080acacc0200074c725b874c7200074c8acc7200058d594b2c0c92000b4cc6cd02000$$ENDHEX$$
			//==============================================
			
					select count(*) 
						into :lvi_count
					  from IQ_OQC_INSPECT_HISTORY
					where product_id = :lvs_serial_no
						 and inspect_type = :lvs_inspect_type
						and organization_id = :gvi_organization_id ;
						
					if f_sql_check() < 0 then 
							return 
				  end if 
			
				 if lvi_count > 0 then 
				
					  f_msgbox1(813 , this.text) 
					  msg = f_msgbox(1150)
					  if msg = 1 then 
					  else
							sle_pid_scan.text = ''
							sle_pid_scan.setfocus( )
							return 
					  end if 
				end if 
			
			//==============================================
			// $$HEX18$$a4c294ce2000c8b9a4c230d15cb8200080bd45d1200015c8f4bc200000ac38c834c62000$$ENDHEX$$
			//==============================================
			
			select item_code, model_name, model_suffix  ,  nvl(barcode_status , 'N')
				 INTO  :lvs_item_code  , :LVS_MODEL_NAME , :lvs_model_suffix , :lvs_pid_status
				 from ip_product_2d_barcode 
				where serial_no  = :lvs_serial_no ; 
			
			
				IF F_SQL_CHECK() < 0 THEN 
					sle_pid_scan.text = ''
					sle_pid_scan.setfocus( )
					RETURN 
				END IF 
				
			IF lvs_item_code = '' OR ISNULL(lvs_item_code) THEN 
					sle_pid_scan.text = ''
					sle_pid_scan.setfocus( )
					f_play_sound("$$HEX6$$a8ba78b34cc518c2c6c54cc7$$ENDHEX$$.wav")	
					f_msg("Not Found PID Information",'P') 
					return 
			END IF 
			
			
			if lvs_pid_status = 'H' AND cbx_issue_pid_check.CHECKED = TRUE then 
					sle_pid_scan.text = ''
					sle_pid_scan.setfocus( )
					f_play_sound("NG.wav")	
					f_msg("PID Status is HOLDING",'P') 
					return 				
				
			end if
			
			sle_model_name.text = LVS_MODEL_NAME
			
			//=============================================
			//
			//============================================
			
			sle_item_code.text = lvs_item_code
			
			//=============================================
			//
			//=============================================
			f_insert()
			
			dw_1.object.inspect_type[lvi_row] = lvs_inspect_type
			dw_1.object.product_id[lvi_row] = lvs_serial_no
			dw_1.object.model_name[lvi_row] = lvs_model_name
			dw_1.object.model_suffix[lvi_row] = lvs_model_suffix
			dw_1.object.inspect_date[lvi_row] = f_sysdate()
			dw_1.object.inspector[lvi_row] = sle_inspector.text
			dw_1.object.item_code[lvi_row] = lvs_item_code
			dw_1.object.inspect_result[lvi_row] = 'R'
			dw_1.object.inspect_qty[lvi_row] = 1
			dw_1.object.defect_qty[lvi_row] = 1
			
			if dw_1.update() < 0 then 
				rollback ;
				f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") 
				dw_1.deleterow(lvi_row)
				sle_pid_scan.text = ''
				sle_model_name.text = ''
				sle_pid_scan.setfocus( )
			
				return
			else
				commit ;
				f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav") 
				sle_pid_scan.text = ''
				sle_model_name.text = ''
				sle_pid_scan.setfocus( )
			end if 
//===================================================
// $$HEX7$$e8cd8cc17cc72000bdacb0c62000$$ENDHEX$$
//===================================================
else
	
	
	msg = f_msg1(1160 , 'Cancel') 
	if msg = 1 then 
	else
		this.text = ''
		this.setfocus()
		return 
	end if 
	
	delete from IQ_OQC_INSPECT_HISTORY where product_id = :lvs_serial_no 
	 
	   and inspect_date = ( select max(inspect_date) from  IQ_PRODUCT_WQC where serial_no = :lvs_serial_no 
								     and organization_id = :gvi_organization_id ) 
	   and organization_id = :gvi_organization_id ;
		
	if f_sql_check() < 0 then 
		this.text = ''
		this.setfocus()
		return 
	end if 	 		
	
	COMMIT ;
	
	f_msg('$$HEX8$$5ccd8cc1200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$' , 'P' ) 	
	
end if 
end event

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

type st_1 from so_statictext within w_qc_oqc_inspect_history_master
integer x = 2638
integer y = 88
integer width = 832
integer height = 72
boolean bringtotop = true
long textcolor = 255
string text = "Serial No"
end type

type sle_model_name from so_singlelineedit within w_qc_oqc_inspect_history_master
integer x = 3470
integer y = 164
integer width = 576
boolean bringtotop = true
end type

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

type st_mrm_no from so_statictext within w_qc_oqc_inspect_history_master
integer x = 3470
integer y = 88
integer width = 576
integer height = 72
boolean bringtotop = true
string text = "Model Name"
end type

type sle_inspector from so_singlelineedit within w_qc_oqc_inspect_history_master
integer x = 2222
integer y = 164
integer width = 411
boolean bringtotop = true
end type

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

event modified;call super::modified;//sle_inspect_charger.setfocus( )
sle_inspector.backcolor = rgb( 255,255,255)
sle_pid_scan.setfocus()
end event

type st_2 from so_statictext within w_qc_oqc_inspect_history_master
integer x = 2222
integer y = 88
integer width = 411
integer height = 72
boolean bringtotop = true
long textcolor = 255
string text = "Inspector"
end type

type sle_item_code from so_singlelineedit within w_qc_oqc_inspect_history_master
integer x = 4050
integer y = 164
integer width = 571
integer taborder = 40
boolean bringtotop = true
end type

type st_7 from so_statictext within w_qc_oqc_inspect_history_master
integer x = 4055
integer y = 88
integer width = 558
integer height = 72
boolean bringtotop = true
string text = "Item Code"
end type

type rb_manage from so_radiobutton within w_qc_oqc_inspect_history_master
integer x = 69
integer y = 72
integer width = 457
boolean bringtotop = true
string text = "Manage"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type rb_history from so_radiobutton within w_qc_oqc_inspect_history_master
integer x = 69
integer y = 208
integer width = 457
boolean bringtotop = true
string text = "History"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type st_4 from so_statictext within w_qc_oqc_inspect_history_master
integer x = 4626
integer y = 88
integer width = 814
integer height = 72
boolean bringtotop = true
string text = "Scan Date"
end type

type uo_dateset from uo_ymd_calendar within w_qc_oqc_inspect_history_master
event destroy ( )
integer x = 4631
integer y = 164
integer height = 80
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_qc_oqc_inspect_history_master
event destroy ( )
integer x = 5047
integer y = 164
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type rb_normal from so_radiobutton within w_qc_oqc_inspect_history_master
integer x = 1687
integer y = 104
integer width = 443
boolean bringtotop = true
string text = "Normal"
boolean checked = true
end type

type rb_cancel from so_radiobutton within w_qc_oqc_inspect_history_master
integer x = 1687
integer y = 204
integer width = 443
boolean bringtotop = true
string text = "Cancel"
end type

type cbx_issue_pid_check from so_checkbox within w_qc_oqc_inspect_history_master
integer x = 1065
integer y = 144
boolean bringtotop = true
string text = "Issue PIB CHeck"
boolean checked = true
end type

type rb_1 from so_radiobutton within w_qc_oqc_inspect_history_master
integer x = 494
integer y = 72
integer width = 507
boolean bringtotop = true
string text = "Scan Daily Summary"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
end event

type rb_today from so_radiobutton within w_qc_oqc_inspect_history_master
integer x = 494
integer y = 204
integer width = 507
boolean bringtotop = true
string text = "Today Scan List"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4
end event

type gb_1 from so_groupbox within w_qc_oqc_inspect_history_master
integer x = 2181
integer width = 3328
integer height = 348
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_qc_oqc_inspect_history_master
integer width = 1015
integer height = 348
integer taborder = 10
string text = "Category"
end type

type gb_3 from so_groupbox within w_qc_oqc_inspect_history_master
integer x = 1618
integer width = 544
integer height = 348
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Option"
end type

type gb_4 from so_groupbox within w_qc_oqc_inspect_history_master
integer x = 1033
integer width = 581
integer height = 348
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Blocking"
end type


HA$PBExportHeader$w_qc_iqc_inspect_history_master.srw
$PBExportComments$$$HEX17$$b9c278c7d0c658c7a8ba78b3d0c5200000b35cd52000b9d231c144c7200000adacb9$$ENDHEX$$
forward
global type w_qc_iqc_inspect_history_master from w_main_root
end type
type sle_pid_scan from so_singlelineedit within w_qc_iqc_inspect_history_master
end type
type st_1 from so_statictext within w_qc_iqc_inspect_history_master
end type
type st_mrm_no from so_statictext within w_qc_iqc_inspect_history_master
end type
type st_2 from so_statictext within w_qc_iqc_inspect_history_master
end type
type ddlb_inspect_type from uo_basecode within w_qc_iqc_inspect_history_master
end type
type st_5 from so_statictext within w_qc_iqc_inspect_history_master
end type
type sle_item_code from so_singlelineedit within w_qc_iqc_inspect_history_master
end type
type st_7 from so_statictext within w_qc_iqc_inspect_history_master
end type
type rb_iqc_detail from so_radiobutton within w_qc_iqc_inspect_history_master
end type
type rb_detail_history from so_radiobutton within w_qc_iqc_inspect_history_master
end type
type cb_2 from so_commandbutton within w_qc_iqc_inspect_history_master
end type
type cbx_auto_retrieve from so_checkbox within w_qc_iqc_inspect_history_master
end type
type st_4 from so_statictext within w_qc_iqc_inspect_history_master
end type
type uo_dateset from uo_ymd_calendar within w_qc_iqc_inspect_history_master
end type
type uo_dateend from uo_ymd_calendar within w_qc_iqc_inspect_history_master
end type
type ddlb_inspector from uo_user_id_name_by_department within w_qc_iqc_inspect_history_master
end type
type rb_iqc_summary from so_radiobutton within w_qc_iqc_inspect_history_master
end type
type rb_summary_history from so_radiobutton within w_qc_iqc_inspect_history_master
end type
type st_3 from so_statictext within w_qc_iqc_inspect_history_master
end type
type ddlb_model_name from uo_model_name_ddlb within w_qc_iqc_inspect_history_master
end type
type ddlb_item_class from uo_product_class_code_name within w_qc_iqc_inspect_history_master
end type
type gb_1 from so_groupbox within w_qc_iqc_inspect_history_master
end type
type gb_2 from so_groupbox within w_qc_iqc_inspect_history_master
end type
type gb_3 from so_groupbox within w_qc_iqc_inspect_history_master
end type
end forward

global type w_qc_iqc_inspect_history_master from w_main_root
integer width = 6738
integer height = 2880
string title = "IQC Inspect History Master"
string ivs_dw_2_selected_row_yn = "Y"
string ivs_dw_3_selected_row_yn = "Y"
sle_pid_scan sle_pid_scan
st_1 st_1
st_mrm_no st_mrm_no
st_2 st_2
ddlb_inspect_type ddlb_inspect_type
st_5 st_5
sle_item_code sle_item_code
st_7 st_7
rb_iqc_detail rb_iqc_detail
rb_detail_history rb_detail_history
cb_2 cb_2
cbx_auto_retrieve cbx_auto_retrieve
st_4 st_4
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_inspector ddlb_inspector
rb_iqc_summary rb_iqc_summary
rb_summary_history rb_summary_history
st_3 st_3
ddlb_model_name ddlb_model_name
ddlb_item_class ddlb_item_class
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_qc_iqc_inspect_history_master w_qc_iqc_inspect_history_master

type variables
long lvi_row
end variables

on w_qc_iqc_inspect_history_master.create
int iCurrent
call super::create
this.sle_pid_scan=create sle_pid_scan
this.st_1=create st_1
this.st_mrm_no=create st_mrm_no
this.st_2=create st_2
this.ddlb_inspect_type=create ddlb_inspect_type
this.st_5=create st_5
this.sle_item_code=create sle_item_code
this.st_7=create st_7
this.rb_iqc_detail=create rb_iqc_detail
this.rb_detail_history=create rb_detail_history
this.cb_2=create cb_2
this.cbx_auto_retrieve=create cbx_auto_retrieve
this.st_4=create st_4
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_inspector=create ddlb_inspector
this.rb_iqc_summary=create rb_iqc_summary
this.rb_summary_history=create rb_summary_history
this.st_3=create st_3
this.ddlb_model_name=create ddlb_model_name
this.ddlb_item_class=create ddlb_item_class
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_pid_scan
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_mrm_no
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.ddlb_inspect_type
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.sle_item_code
this.Control[iCurrent+8]=this.st_7
this.Control[iCurrent+9]=this.rb_iqc_detail
this.Control[iCurrent+10]=this.rb_detail_history
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.cbx_auto_retrieve
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.uo_dateset
this.Control[iCurrent+15]=this.uo_dateend
this.Control[iCurrent+16]=this.ddlb_inspector
this.Control[iCurrent+17]=this.rb_iqc_summary
this.Control[iCurrent+18]=this.rb_summary_history
this.Control[iCurrent+19]=this.st_3
this.Control[iCurrent+20]=this.ddlb_model_name
this.Control[iCurrent+21]=this.ddlb_item_class
this.Control[iCurrent+22]=this.gb_1
this.Control[iCurrent+23]=this.gb_2
this.Control[iCurrent+24]=this.gb_3
end on

on w_qc_iqc_inspect_history_master.destroy
call super::destroy
destroy(this.sle_pid_scan)
destroy(this.st_1)
destroy(this.st_mrm_no)
destroy(this.st_2)
destroy(this.ddlb_inspect_type)
destroy(this.st_5)
destroy(this.sle_item_code)
destroy(this.st_7)
destroy(this.rb_iqc_detail)
destroy(this.rb_detail_history)
destroy(this.cb_2)
destroy(this.cbx_auto_retrieve)
destroy(this.st_4)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_inspector)
destroy(this.rb_iqc_summary)
destroy(this.rb_summary_history)
destroy(this.st_3)
destroy(this.ddlb_model_name)
destroy(this.ddlb_item_class)
destroy(this.gb_1)
destroy(this.gb_2)
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

sle_pid_scan.setfocus( )

end event

event ue_data_control;call super::ue_data_control;choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
		if rb_iqc_summary.checked = true then 
			
			dw_2.retrieve( uo_dateset.text() , uo_dateend.text() , ddlb_model_name.getcode() + '%',   ddlb_item_class.getcode() ,  '%' , '%' ,      Gvi_organization_id )
			
	    elseif rb_detail_history.checked = true then 
				dw_3.retrieve( uo_dateset.text() , uo_dateend.text() , ddlb_inspect_type.getcode() +'%' , gvi_organization_id ,  ddlb_model_name.getcode() + '%', sle_item_code.text+'%', sle_pid_scan.text+'%' )
		elseif rb_summary_history.checked = true then 
			
			dw_4.retrieve( uo_dateset.text() , uo_dateend.text() , ddlb_model_name.getcode()+ '%',   ddlb_item_class.getcode()+'%' ,  '%' , '%' ,     gvs_language ,  Gvi_organization_id )
			f_set_column_dddw(dw_4)	
			
		end if 
	CASE 'INSERT'
	
			if rb_iqc_detail.checked = true then 
					lvi_row = dw_1.insertrow(dw_1.getrow())
					dw_1.scrolltorow(lvi_row)
					f_set_security_row(dw_1 , lvi_row , 'ALL')
					F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
						
			else
					lvi_row = dw_2.insertrow(dw_2.getrow())
					dw_2.scrolltorow(lvi_row)
					f_set_security_row(dw_2 , lvi_row , 'ALL')
					F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
					
					dw_2.object.inspect_date[lvi_row] = f_sysdate()
					dw_2.object.item_code[lvi_row] = '*'
					dw_2.object.inspect_sequence[lvi_row] = F_GET_SEQUENCE( 'SEQ_IQC_INSPECT_HISTORY_SEQ') 
							
			end if 
	

	CASE 'APPEND'
	
				if rb_iqc_detail.checked = true then 
					lvi_row = dw_1.insertrow(dw_1.getrow())
					dw_1.scrolltorow(lvi_row)
					f_set_security_row(dw_1 , lvi_row , 'ALL')
					F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
			
			else
					lvi_row = dw_2.insertrow(dw_2.getrow())
					dw_2.scrolltorow(lvi_row)
					f_set_security_row(dw_2 , lvi_row , 'ALL')
					F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
					dw_2.object.inspect_date[lvi_row] = f_sysdate()
					dw_2.object.item_code[lvi_row] = '*'
					dw_2.object.inspect_sequence[lvi_row] = F_GET_SEQUENCE( 'SEQ_IQC_INSPECT_HISTORY_SEQ') 
							
			end if 
	
			
	case 'DELETE'
		
		
			if rb_iqc_detail.checked = true then 		
		
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
					
			elseif rb_iqc_summary.checked = true then 
					
				if dw_2.getrow() < 1 then return 
					  
					msg =f_msgbox(1003)
					if msg = 1 then
						gvl_row_deleted = dw_2.getrow()			
						dw_2.deleterow(gvl_row_deleted)		
						dw_2.setfocus()
						lvi_row = dw_2.getrow()
						dw_2.scrolltorow(lvi_row)
						dw_2.setcolumn(1)
					end if				
					
			end if 
			
	case 'UPDATE'
		
		
		if rb_iqc_detail.checked = true then 		
			if dw_1.update() < 0 then
				rollback;
			else
				commit;
				f_msg_mdi_help(f_msg_st(170))
			end if
		elseif rb_iqc_summary.checked = true then 
			if dw_2.update() < 0 then
				rollback;
			else
				commit;
				f_msg_mdi_help(f_msg_st(170))
			end if			
			
			
		end if 
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_qc_iqc_inspect_history_master
integer y = 328
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_qc_iqc_inspect_history_master
integer y = 328
integer width = 2299
integer height = 1048
integer taborder = 0
boolean titlebar = true
string title = "IQC Summary History"
string dataobject = "d_iq_iqc_insepct_summary_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_qc_iqc_inspect_history_master
integer y = 328
integer width = 2185
integer height = 1048
integer taborder = 0
boolean titlebar = true
string title = "IQC Detail History"
string dataobject = "d_iq_iqc_insepct_history_rpt"
end type

event dw_3::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
if cbx_auto_retrieve.checked = true then 
	dw_2.retrieve(  this.object.product_id[currentrow])
end if 
end event

event dw_3::doubleclicked;call super::doubleclicked;if row < 1 then return 
openwithparm( w_qc_inspect_4_gmes_popup , string( this.object.product_id[row] ))
end event

type dw_2 from w_main_root`dw_2 within w_qc_iqc_inspect_history_master
integer y = 328
integer width = 5970
integer height = 1048
integer taborder = 0
boolean titlebar = true
string title = "IQC Summary"
string dataobject = "d_iq_iqc_insepct_summary_history"
end type

type dw_1 from w_main_root`dw_1 within w_qc_iqc_inspect_history_master
integer y = 328
integer width = 5970
integer height = 1048
integer taborder = 0
boolean titlebar = true
string title = "IQC Detail"
string dataobject = "d_iq_iqc_insepct_history"
end type

event dw_1::clicked;call super::clicked;sle_pid_scan.setfocus( )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_qc_iqc_inspect_history_master
integer taborder = 0
end type

type sle_pid_scan from so_singlelineedit within w_qc_iqc_inspect_history_master
integer x = 2203
integer y = 168
integer width = 658
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;string lvs_serial_no ,  lvs_line_code  , lvs_item_code , lvs_model_name , lvs_model_suffix , lvs_inspect_type , lvs_set_item_code, lvs_inspector
long lvl_sequence  , lvi_count

//============================
//  
//============================
if rb_iqc_detail.checked = true then 

else
	return 
end if 

lvs_inspect_type =  ddlb_inspect_type.getcode( ) 
lvs_inspector       = ddlb_inspector.getcode() 
lvs_serial_no       = this.text 

if lvs_inspect_type = '' or isnull(lvs_inspect_type) then 
	f_play_sound("$$HEX5$$6cad84bdf8bb20c1ddd0$$ENDHEX$$.wav")
	sle_pid_scan.text = ''
	sle_pid_scan.setfocus( )
	Return 	
end if


//$$HEX12$$80acacc090c72000c6c544c74cb520000900090009000900$$ENDHEX$$
if lvs_inspector = '' then 
	f_play_sound("$$HEX7$$38c199cc80acacc0f4b2f9b290c7$$ENDHEX$$.wav")
	sle_pid_scan.text = ''
	sle_pid_scan.setfocus( )
	Return 
end if 

//==============================================
//$$HEX19$$30ae200080acacc0200074c725b874c7200074c8acc7200058d594b2c0c92000b4cc6cd02000$$ENDHEX$$
//==============================================

		select count(*) 
		   into :lvi_count
		  from IQ_IQC_INSPECT_HISTORY
	 	where LOT_NO = :lvs_serial_no
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

SELECT  DISTINCT ITEM_CODE    ,  FEEDING_MODEL  , '*'   
   INTO  :lvs_set_item_code  , :LVS_MODEL_NAME , :lvs_model_suffix
FROM IM_ITEM_RECEIPT_BARCODE
WHERE LOT_NO = :lvs_serial_no ;

	IF F_SQL_CHECK() < 0 THEN 
		sle_pid_scan.text = ''
		sle_pid_scan.setfocus( )
		RETURN 
	END IF 
	
IF lvs_set_item_code = '' OR ISNULL(lvs_set_item_code) THEN 
		sle_pid_scan.text = ''
		sle_pid_scan.setfocus( )
		f_play_sound("$$HEX6$$a8ba78b34cc518c2c6c54cc7$$ENDHEX$$.wav")	
		messagebox("Notify" , "Not Found Magazine Information")
		return 
END IF 

ddlb_model_name.text = LVS_MODEL_NAME

//=============================================
//
//============================================

sle_item_code.text = lvs_set_item_code

//=============================================
//
//=============================================
f_insert()

dw_1.object.inspect_type[lvi_row] = lvs_inspect_type
dw_1.object.lot_no[lvi_row] = lvs_serial_no
dw_1.object.model_name[lvi_row] = lvs_model_name
dw_1.object.model_suffix[lvi_row] = lvs_model_suffix
dw_1.object.inspect_date[lvi_row] = f_sysdate()
dw_1.object.inspector[lvi_row] = ddlb_inspector.getcode()
dw_1.object.item_code[lvi_row] = lvs_set_item_code
dw_1.object.inspect_result[lvi_row] = 'P'


if dw_1.update() < 0 then 
	rollback ;
	f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav") 
	dw_1.deleterow(lvi_row)
	sle_pid_scan.text = ''
	ddlb_model_name.text = ''
	sle_pid_scan.setfocus( )

	return
else
	commit ;
	f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav") 
	sle_pid_scan.text = ''
	ddlb_model_name.text = ''
	sle_pid_scan.setfocus( )
end if 
		
end event

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

type st_1 from so_statictext within w_qc_iqc_inspect_history_master
integer x = 2203
integer y = 92
integer width = 658
integer height = 72
boolean bringtotop = true
long textcolor = 255
string text = "Material MFS"
end type

type st_mrm_no from so_statictext within w_qc_iqc_inspect_history_master
integer x = 2871
integer y = 92
integer width = 581
integer height = 72
boolean bringtotop = true
string text = "Model Name"
end type

type st_2 from so_statictext within w_qc_iqc_inspect_history_master
integer x = 1719
integer y = 92
integer width = 485
integer height = 72
boolean bringtotop = true
string text = "Inspector"
end type

type ddlb_inspect_type from uo_basecode within w_qc_iqc_inspect_history_master
integer x = 1234
integer y = 168
integer width = 475
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;THIS.REdraw( 'IQC INSPECT TYPE')
end event

event selectionchanged;call super::selectionchanged;//if this.getcode( ) = 'C' then 
//			sle_clean_charger.enabled = true	
//			sle_clean_charger.setfocus( )
//			sle_clean_charger.text = ''
//			sle_inspect_charger.text = '' 	  
//else 
//	
//			sle_clean_charger.enabled = false	
//			
//			sle_clean_charger.text = ''
//			sle_inspect_charger.text = ''
//			sle_inspect_charger.SETfocus( )
//
//end if 
end event

type st_5 from so_statictext within w_qc_iqc_inspect_history_master
integer x = 1234
integer y = 92
integer width = 475
integer height = 72
boolean bringtotop = true
string text = "Inspect Type"
end type

type sle_item_code from so_singlelineedit within w_qc_iqc_inspect_history_master
integer x = 3461
integer y = 168
integer width = 544
integer taborder = 40
boolean bringtotop = true
end type

type st_7 from so_statictext within w_qc_iqc_inspect_history_master
integer x = 3461
integer y = 92
integer width = 544
integer height = 72
boolean bringtotop = true
string text = "Item Code"
end type

type rb_iqc_detail from so_radiobutton within w_qc_iqc_inspect_history_master
integer x = 64
integer y = 76
boolean bringtotop = true
string text = "IQC Detail"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type rb_detail_history from so_radiobutton within w_qc_iqc_inspect_history_master
integer x = 59
integer y = 180
boolean bringtotop = true
string text = "IQC Detail History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
end event

type cb_2 from so_commandbutton within w_qc_iqc_inspect_history_master
integer x = 5522
integer y = 180
integer height = 108
integer taborder = 40
boolean bringtotop = true
string text = "Reset"
end type

event clicked;call super::clicked;ddlb_inspector.text = ''
sle_item_code.text = ''
ddlb_model_name.text = ''
sle_pid_scan.text = ''
ddlb_inspect_type.text = ''	
ddlb_inspect_type.setfocus( )
dw_1.reset()
end event

type cbx_auto_retrieve from so_checkbox within w_qc_iqc_inspect_history_master
integer x = 5568
integer y = 76
boolean bringtotop = true
string text = "Auto Retrieve"
boolean checked = true
end type

type st_4 from so_statictext within w_qc_iqc_inspect_history_master
integer x = 4608
integer y = 92
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Inspect Date"
end type

type uo_dateset from uo_ymd_calendar within w_qc_iqc_inspect_history_master
event destroy ( )
integer x = 4603
integer y = 168
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_qc_iqc_inspect_history_master
event destroy ( )
integer x = 5019
integer y = 168
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_inspector from uo_user_id_name_by_department within w_qc_iqc_inspect_history_master
integer x = 1714
integer y = 168
integer width = 485
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;THIS.REDRAW( 'IQC')
end event

type rb_iqc_summary from so_radiobutton within w_qc_iqc_inspect_history_master
integer x = 603
integer y = 72
integer width = 539
boolean bringtotop = true
string text = "IQC Summary"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type rb_summary_history from so_radiobutton within w_qc_iqc_inspect_history_master
integer x = 603
integer y = 184
integer width = 539
boolean bringtotop = true
string text = "IQC Summary History"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4
end event

type st_3 from so_statictext within w_qc_iqc_inspect_history_master
integer x = 4009
integer y = 92
integer width = 590
integer height = 72
boolean bringtotop = true
string text = "Item Class"
end type

type ddlb_model_name from uo_model_name_ddlb within w_qc_iqc_inspect_history_master
integer x = 2871
integer y = 168
integer width = 581
integer height = 2616
integer taborder = 50
boolean bringtotop = true
end type

type ddlb_item_class from uo_product_class_code_name within w_qc_iqc_inspect_history_master
integer x = 4009
integer y = 168
integer width = 581
integer height = 1868
integer taborder = 20
boolean bringtotop = true
end type

type gb_1 from so_groupbox within w_qc_iqc_inspect_history_master
integer x = 1202
integer y = 4
integer width = 4265
integer height = 304
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_qc_iqc_inspect_history_master
integer width = 1170
integer height = 308
integer taborder = 10
string text = "Category"
end type

type gb_3 from so_groupbox within w_qc_iqc_inspect_history_master
integer x = 5481
integer width = 622
integer height = 304
integer taborder = 10
string text = "Process"
end type


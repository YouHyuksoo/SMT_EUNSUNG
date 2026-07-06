HA$PBExportHeader$w_pln_product_pid_issue_scan_master.srw
$PBExportComments$Line Master
forward
global type w_pln_product_pid_issue_scan_master from w_main_root
end type
type sle_pid_scan from so_singlelineedit within w_pln_product_pid_issue_scan_master
end type
type st_1 from so_statictext within w_pln_product_pid_issue_scan_master
end type
type sle_model_name from so_singlelineedit within w_pln_product_pid_issue_scan_master
end type
type st_mrm_no from so_statictext within w_pln_product_pid_issue_scan_master
end type
type sle_clean_charger from so_singlelineedit within w_pln_product_pid_issue_scan_master
end type
type st_2 from so_statictext within w_pln_product_pid_issue_scan_master
end type
type sle_inspect_charger from so_singlelineedit within w_pln_product_pid_issue_scan_master
end type
type st_3 from so_statictext within w_pln_product_pid_issue_scan_master
end type
type ddlb_pid_issue_type from uo_basecode within w_pln_product_pid_issue_scan_master
end type
type st_5 from so_statictext within w_pln_product_pid_issue_scan_master
end type
type sle_location_infor from so_singlelineedit within w_pln_product_pid_issue_scan_master
end type
type st_6 from so_statictext within w_pln_product_pid_issue_scan_master
end type
type sle_item_code from so_singlelineedit within w_pln_product_pid_issue_scan_master
end type
type st_7 from so_statictext within w_pln_product_pid_issue_scan_master
end type
type rb_manage from so_radiobutton within w_pln_product_pid_issue_scan_master
end type
type rb_2 from so_radiobutton within w_pln_product_pid_issue_scan_master
end type
type cb_2 from so_commandbutton within w_pln_product_pid_issue_scan_master
end type
type cbx_auto_retrieve from so_checkbox within w_pln_product_pid_issue_scan_master
end type
type st_4 from so_statictext within w_pln_product_pid_issue_scan_master
end type
type uo_dateset from uo_ymd_calendar within w_pln_product_pid_issue_scan_master
end type
type uo_dateend from uo_ymd_calendar within w_pln_product_pid_issue_scan_master
end type
type gb_1 from so_groupbox within w_pln_product_pid_issue_scan_master
end type
type gb_2 from so_groupbox within w_pln_product_pid_issue_scan_master
end type
type gb_3 from so_groupbox within w_pln_product_pid_issue_scan_master
end type
end forward

global type w_pln_product_pid_issue_scan_master from w_main_root
integer width = 5650
integer height = 2880
string title = "PCB Issue Scan Master"
string ivs_dw_2_selected_row_yn = "Y"
string ivs_dw_3_selected_row_yn = "Y"
sle_pid_scan sle_pid_scan
st_1 st_1
sle_model_name sle_model_name
st_mrm_no st_mrm_no
sle_clean_charger sle_clean_charger
st_2 st_2
sle_inspect_charger sle_inspect_charger
st_3 st_3
ddlb_pid_issue_type ddlb_pid_issue_type
st_5 st_5
sle_location_infor sle_location_infor
st_6 st_6
sle_item_code sle_item_code
st_7 st_7
rb_manage rb_manage
rb_2 rb_2
cb_2 cb_2
cbx_auto_retrieve cbx_auto_retrieve
st_4 st_4
uo_dateset uo_dateset
uo_dateend uo_dateend
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_pln_product_pid_issue_scan_master w_pln_product_pid_issue_scan_master

type variables
long lvi_row
end variables

on w_pln_product_pid_issue_scan_master.create
int iCurrent
call super::create
this.sle_pid_scan=create sle_pid_scan
this.st_1=create st_1
this.sle_model_name=create sle_model_name
this.st_mrm_no=create st_mrm_no
this.sle_clean_charger=create sle_clean_charger
this.st_2=create st_2
this.sle_inspect_charger=create sle_inspect_charger
this.st_3=create st_3
this.ddlb_pid_issue_type=create ddlb_pid_issue_type
this.st_5=create st_5
this.sle_location_infor=create sle_location_infor
this.st_6=create st_6
this.sle_item_code=create sle_item_code
this.st_7=create st_7
this.rb_manage=create rb_manage
this.rb_2=create rb_2
this.cb_2=create cb_2
this.cbx_auto_retrieve=create cbx_auto_retrieve
this.st_4=create st_4
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_pid_scan
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_model_name
this.Control[iCurrent+4]=this.st_mrm_no
this.Control[iCurrent+5]=this.sle_clean_charger
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.sle_inspect_charger
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.ddlb_pid_issue_type
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.sle_location_infor
this.Control[iCurrent+12]=this.st_6
this.Control[iCurrent+13]=this.sle_item_code
this.Control[iCurrent+14]=this.st_7
this.Control[iCurrent+15]=this.rb_manage
this.Control[iCurrent+16]=this.rb_2
this.Control[iCurrent+17]=this.cb_2
this.Control[iCurrent+18]=this.cbx_auto_retrieve
this.Control[iCurrent+19]=this.st_4
this.Control[iCurrent+20]=this.uo_dateset
this.Control[iCurrent+21]=this.uo_dateend
this.Control[iCurrent+22]=this.gb_1
this.Control[iCurrent+23]=this.gb_2
this.Control[iCurrent+24]=this.gb_3
end on

on w_pln_product_pid_issue_scan_master.destroy
call super::destroy
destroy(this.sle_pid_scan)
destroy(this.st_1)
destroy(this.sle_model_name)
destroy(this.st_mrm_no)
destroy(this.sle_clean_charger)
destroy(this.st_2)
destroy(this.sle_inspect_charger)
destroy(this.st_3)
destroy(this.ddlb_pid_issue_type)
destroy(this.st_5)
destroy(this.sle_location_infor)
destroy(this.st_6)
destroy(this.sle_item_code)
destroy(this.st_7)
destroy(this.rb_manage)
destroy(this.rb_2)
destroy(this.cb_2)
destroy(this.cbx_auto_retrieve)
destroy(this.st_4)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
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
		
		
		if rb_manage.checked = true then 
		else
			
			dw_3.retrieve( sle_pid_scan.text+'%' ,  sle_model_name.text + '%', sle_item_code.text+'%' ,  ddlb_pid_issue_type.getcode() +'%' , uo_dateset.text() , uo_dateend.text() ,  sle_location_infor.text+'%' ,  gvi_organization_id)
			dw_3.setfocus()
			
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
		
			if dw_1.update() < 0 then
				rollback;
			else
				commit;
				f_msg_mdi_help(f_msg_st(170))
			end if
			
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_pln_product_pid_issue_scan_master
integer y = 316
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_pid_issue_scan_master
integer y = 316
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_pid_issue_scan_master
integer y = 316
integer width = 3333
integer height = 1136
integer taborder = 0
boolean titlebar = true
string dataobject = "d_qc_pid_issue_scan_hist"
end type

event dw_3::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
if cbx_auto_retrieve.checked = true then 
	dw_2.retrieve(  this.object.serial_no[currentrow])
end if 
end event

event dw_3::doubleclicked;call super::doubleclicked;if row < 1 then return 
//openwithparm( w_qc_inspect_4_gmes_popup , string( this.object.serial_no[row] ))
end event

type dw_2 from w_main_root`dw_2 within w_pln_product_pid_issue_scan_master
integer y = 316
integer width = 3333
integer height = 1364
integer taborder = 0
boolean titlebar = true
string title = "History"
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_pid_issue_scan_master
integer y = 316
integer width = 5568
integer height = 1364
integer taborder = 0
boolean titlebar = true
string title = "Manage"
string dataobject = "d_qc_pid_issue_scan_lst"
end type

event dw_1::clicked;call super::clicked;sle_pid_scan.setfocus( )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_pid_issue_scan_master
integer taborder = 0
end type

type sle_pid_scan from so_singlelineedit within w_pln_product_pid_issue_scan_master
integer x = 2373
integer y = 164
integer width = 658
integer height = 84
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;string lvs_serial_no ,  lvs_line_code  , lvs_item_code , lvs_model_name , lvs_model_suffix , lvs_pid_issue_type , lvs_set_item_code , lvs_location_infor
long lvl_sequence  , lvi_count

//============================
//  
//============================
if rb_manage.checked = true then 

else
	return 
end if 

lvs_pid_issue_type =  ddlb_pid_issue_type.getcode( ) 
lvs_location_infor =  sle_location_infor.text 	
lvs_serial_no = this.text 


if lvs_location_infor = '' or isnull(lvs_location_infor) then 
	lvs_location_infor = '*'
end if 

if lvs_pid_issue_type = '' or isnull(lvs_pid_issue_type) then 
	f_play_sound("$$HEX5$$6cad84bdf8bb20c1ddd0$$ENDHEX$$.wav")
	f_msg( "$$HEX12$$6cad84bd54cfdcb47cb9200020c1ddd0200058d538c194c6$$ENDHEX$$" , 'P')
	sle_pid_scan.text = ''
	sle_pid_scan.setfocus( )
	Return 	
end if


if lvs_pid_issue_type = 'C' then 
				
		if sle_clean_charger.text = '' or sle_inspect_charger.text = '' then 
			f_play_sound("$$HEX7$$38c199cc80acacc0f4b2f9b290c7$$ENDHEX$$.wav")
			f_msg( "$$HEX14$$38c199cc2000f4b2f9b290c77cb9200085c725b8200058d538c194c6$$ENDHEX$$" , 'P')
			sle_pid_scan.text = ''
			sle_pid_scan.setfocus( )
			Return 
		end if 
end if 


//==============================================
//
//==============================================

		select count(*) into :lvi_count from IP_PRODUCT_ISSUE_PID_SCAN
		where serial_no = :lvs_serial_no
		and pid_issue_type = :lvs_pid_issue_type
		and location = :lvs_location_infor
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

//SELECT  DISTINCT ITEM_CODE    ,  model , buyer  
//   INTO  :lvs_set_item_code  , :LVS_MODEL_NAME , :lvs_model_suffix
//FROM TB_VIS_PID_ISSUE_HIST
//WHERE PRODUCT_ID = :lvs_serial_no ;

SELECT distinct item_code, model_name, model_suffix
    INTO  :lvs_set_item_code  , :LVS_MODEL_NAME , :lvs_model_suffix
    FROM IP_PRODUCT_2D_BARCODE 
  WHERE SERIAL_NO = :lvs_serial_no ; 

	IF F_SQL_CHECK() < 0 THEN 
		sle_pid_scan.text = ''
		sle_pid_scan.setfocus( )
		RETURN 
	END IF 
	
IF lvs_set_item_code = '' OR ISNULL(lvs_set_item_code) THEN 
		sle_pid_scan.text = ''
		sle_pid_scan.setfocus( )
		f_play_sound("$$HEX6$$a8ba78b34cc518c2c6c54cc7$$ENDHEX$$.wav")	
		//messagebox("Notify" , "Not Found PID Information")
		f_msg("Not Found PID Information","S")
		return 
END IF 

sle_model_name.text = LVS_MODEL_NAME

//=============================================
//
//=============================================

   select  child_item_code into :lvs_item_code 
	from ID_ENG_BOM_SMT
   where 	parent_item_code = :LVS_MODEL_NAME
	  and location_info like '%'||:lvs_location_infor||'%' ;
	  
	IF F_SQL_CHECK() < 0 THEN 
			sle_pid_scan.text = ''
			sle_pid_scan.setfocus( )
			RETURN 
	END IF     	
	
IF lvs_item_code = '' OR ISNULL(lvs_item_code) THEN 
	//	sle_pid_scan.text = ''
	//	sle_model_name.text = ''
//		sle_pid_scan.setfocus( )
		f_play_sound("$$HEX6$$a8ba78b34cc518c2c6c54cc7$$ENDHEX$$.wav")	
//		messagebox("Notify" , "Location Information Not Found")
		//return 
		lvs_item_code = '*'
		
END IF 	
	
sle_item_code.text = lvs_item_code

//=============================================
//
//=============================================
f_insert()

dw_1.object.pid_issue_type[lvi_row] = lvs_pid_issue_type
dw_1.object.serial_no[lvi_row] = lvs_serial_no
dw_1.object.model_name[lvi_row] = lvs_model_name
dw_1.object.model_suffix[lvi_row] = lvs_model_suffix
dw_1.object.scan_date[lvi_row] = f_sysdate()
dw_1.object.clean_charger[lvi_row] = sle_clean_charger.text
dw_1.object.inspect_charger[lvi_row] = sle_inspect_charger.text
dw_1.object.location[lvi_row] =lvs_location_infor
dw_1.object.item_code[lvi_row] = lvs_item_code



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
		
end event

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

type st_1 from so_statictext within w_pln_product_pid_issue_scan_master
integer x = 2373
integer y = 72
integer width = 658
integer height = 72
boolean bringtotop = true
long textcolor = 255
string text = "PID"
end type

type sle_model_name from so_singlelineedit within w_pln_product_pid_issue_scan_master
integer x = 3040
integer y = 160
integer width = 457
integer height = 84
boolean bringtotop = true
end type

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

type st_mrm_no from so_statictext within w_pln_product_pid_issue_scan_master
integer x = 3040
integer y = 68
integer width = 457
integer height = 72
boolean bringtotop = true
string text = "Model Name"
end type

type sle_clean_charger from so_singlelineedit within w_pln_product_pid_issue_scan_master
integer x = 1198
integer y = 168
integer width = 370
boolean bringtotop = true
end type

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

event modified;call super::modified;sle_inspect_charger.setfocus( )
end event

type st_2 from so_statictext within w_pln_product_pid_issue_scan_master
integer x = 1198
integer y = 80
integer width = 370
integer height = 72
boolean bringtotop = true
string text = "Clean Charger"
end type

type sle_inspect_charger from so_singlelineedit within w_pln_product_pid_issue_scan_master
integer x = 1573
integer y = 168
integer width = 416
boolean bringtotop = true
end type

event getfocus;call super::getfocus;f_play_sound('$$HEX5$$80acacc090c785c725b8$$ENDHEX$$.wav')
this.selecttext( 1,100)
end event

event modified;call super::modified;IF ddlb_pid_issue_type.getcode() = 'C' then
	sle_pid_scan.setfocus( )
else
	sle_location_infor.setfocus( )
end if 
end event

type st_3 from so_statictext within w_pln_product_pid_issue_scan_master
integer x = 1573
integer y = 80
integer width = 416
integer height = 72
boolean bringtotop = true
string text = "Inspect Charger"
end type

type ddlb_pid_issue_type from uo_basecode within w_pln_product_pid_issue_scan_master
integer x = 654
integer y = 168
integer width = 539
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;THIS.REdraw( 'PID ISSUE TYPE')
end event

event selectionchanged;call super::selectionchanged;if this.getcode( ) = 'C' then 
			sle_clean_charger.enabled = true	
			sle_clean_charger.setfocus( )
			sle_clean_charger.text = ''
			sle_inspect_charger.text = '' 	  
else 
	
			sle_clean_charger.enabled = false	
			
			sle_clean_charger.text = ''
			sle_inspect_charger.text = ''
			sle_inspect_charger.SETfocus( )

end if 
end event

type st_5 from so_statictext within w_pln_product_pid_issue_scan_master
integer x = 649
integer y = 84
integer width = 539
integer height = 72
boolean bringtotop = true
string text = "PID Issue Type"
end type

type sle_location_infor from so_singlelineedit within w_pln_product_pid_issue_scan_master
integer x = 1998
integer y = 164
integer width = 370
integer height = 84
integer taborder = 40
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;sle_pid_scan.setfocus()
end event

event getfocus;call super::getfocus;this.selecttext( 1,100)
end event

type st_6 from so_statictext within w_pln_product_pid_issue_scan_master
integer x = 1998
integer y = 72
integer width = 370
integer height = 72
boolean bringtotop = true
string text = "Location"
end type

type sle_item_code from so_singlelineedit within w_pln_product_pid_issue_scan_master
integer x = 3502
integer y = 160
integer width = 457
integer height = 84
integer taborder = 40
boolean bringtotop = true
end type

type st_7 from so_statictext within w_pln_product_pid_issue_scan_master
integer x = 3506
integer y = 68
integer width = 443
integer height = 72
boolean bringtotop = true
string text = "Item Code"
end type

type rb_manage from so_radiobutton within w_pln_product_pid_issue_scan_master
integer x = 78
integer y = 88
boolean bringtotop = true
string text = "Manage"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type rb_2 from so_radiobutton within w_pln_product_pid_issue_scan_master
integer x = 78
integer y = 188
boolean bringtotop = true
string text = "History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
end event

type cb_2 from so_commandbutton within w_pln_product_pid_issue_scan_master
integer x = 4937
integer y = 176
integer height = 108
integer taborder = 40
boolean bringtotop = true
string text = "Reset"
end type

event clicked;call super::clicked;sle_clean_charger.text = ''
sle_inspect_charger.text = ''
sle_item_code.text = ''
sle_location_infor.text = ''
sle_model_name.text = ''
sle_pid_scan.text = ''
ddlb_pid_issue_type.text = ''	
ddlb_pid_issue_type.setfocus( )
end event

type cbx_auto_retrieve from so_checkbox within w_pln_product_pid_issue_scan_master
integer x = 4983
integer y = 72
boolean bringtotop = true
string text = "Auto Retrieve"
boolean checked = true
end type

type st_4 from so_statictext within w_pln_product_pid_issue_scan_master
integer x = 3977
integer y = 80
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Scan Date"
end type

type uo_dateset from uo_ymd_calendar within w_pln_product_pid_issue_scan_master
event destroy ( )
integer x = 3973
integer y = 160
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_pln_product_pid_issue_scan_master
event destroy ( )
integer x = 4389
integer y = 160
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type gb_1 from so_groupbox within w_pln_product_pid_issue_scan_master
integer x = 635
integer y = 4
integer width = 4256
integer height = 304
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_pln_product_pid_issue_scan_master
integer width = 622
integer height = 304
integer taborder = 10
string text = "Category"
end type

type gb_3 from so_groupbox within w_pln_product_pid_issue_scan_master
integer x = 4896
integer width = 622
integer height = 304
integer taborder = 10
string text = "Process"
end type


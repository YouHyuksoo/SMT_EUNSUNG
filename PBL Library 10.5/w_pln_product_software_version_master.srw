HA$PBExportHeader$w_pln_product_software_version_master.srw
$PBExportComments$$$HEX6$$80bd88d42000c8b9a4c230d1$$ENDHEX$$
forward
global type w_pln_product_software_version_master from w_main_root
end type
type st_1 from statictext within w_pln_product_software_version_master
end type
type cb_excel from so_commandbutton within w_pln_product_software_version_master
end type
type sle_model_suffix from so_singlelineedit within w_pln_product_software_version_master
end type
type st_2 from statictext within w_pln_product_software_version_master
end type
type mle_issue from so_multilineedit within w_pln_product_software_version_master
end type
type st_3 from so_statictext within w_pln_product_software_version_master
end type
type mle_apply_comments from so_multilineedit within w_pln_product_software_version_master
end type
type st_4 from so_statictext within w_pln_product_software_version_master
end type
type em_last_check_date from so_editmask within w_pln_product_software_version_master
end type
type em_running from so_editmask within w_pln_product_software_version_master
end type
type em_new from so_editmask within w_pln_product_software_version_master
end type
type st_5 from statictext within w_pln_product_software_version_master
end type
type st_6 from statictext within w_pln_product_software_version_master
end type
type st_7 from statictext within w_pln_product_software_version_master
end type
type ddlb_model_name from uo_model_name_4_software within w_pln_product_software_version_master
end type
type sle_1 from so_singlelineedit within w_pln_product_software_version_master
end type
type st_8 from statictext within w_pln_product_software_version_master
end type
type uo_release_date from uo_ymd_calendar within w_pln_product_software_version_master
end type
type cbx_release_date from so_checkbox within w_pln_product_software_version_master
end type
type sle_2 from so_singlelineedit within w_pln_product_software_version_master
end type
type st_9 from statictext within w_pln_product_software_version_master
end type
type cb_1 from so_commandbutton within w_pln_product_software_version_master
end type
type cb_2 from so_commandbutton within w_pln_product_software_version_master
end type
type gb_2 from so_groupbox within w_pln_product_software_version_master
end type
type gb_1 from so_groupbox within w_pln_product_software_version_master
end type
type gb_3 from so_groupbox within w_pln_product_software_version_master
end type
type gb_4 from so_groupbox within w_pln_product_software_version_master
end type
end forward

global type w_pln_product_software_version_master from w_main_root
integer width = 5230
integer height = 2904
string title = "Software Verion Master"
windowstate windowstate = maximized!
string ivs_dw_2_selected_row_yn = "Y"
st_1 st_1
cb_excel cb_excel
sle_model_suffix sle_model_suffix
st_2 st_2
mle_issue mle_issue
st_3 st_3
mle_apply_comments mle_apply_comments
st_4 st_4
em_last_check_date em_last_check_date
em_running em_running
em_new em_new
st_5 st_5
st_6 st_6
st_7 st_7
ddlb_model_name ddlb_model_name
sle_1 sle_1
st_8 st_8
uo_release_date uo_release_date
cbx_release_date cbx_release_date
sle_2 sle_2
st_9 st_9
cb_1 cb_1
cb_2 cb_2
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
gb_4 gb_4
end type
global w_pln_product_software_version_master w_pln_product_software_version_master

on w_pln_product_software_version_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_excel=create cb_excel
this.sle_model_suffix=create sle_model_suffix
this.st_2=create st_2
this.mle_issue=create mle_issue
this.st_3=create st_3
this.mle_apply_comments=create mle_apply_comments
this.st_4=create st_4
this.em_last_check_date=create em_last_check_date
this.em_running=create em_running
this.em_new=create em_new
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
this.ddlb_model_name=create ddlb_model_name
this.sle_1=create sle_1
this.st_8=create st_8
this.uo_release_date=create uo_release_date
this.cbx_release_date=create cbx_release_date
this.sle_2=create sle_2
this.st_9=create st_9
this.cb_1=create cb_1
this.cb_2=create cb_2
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_excel
this.Control[iCurrent+3]=this.sle_model_suffix
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.mle_issue
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.mle_apply_comments
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.em_last_check_date
this.Control[iCurrent+10]=this.em_running
this.Control[iCurrent+11]=this.em_new
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.st_6
this.Control[iCurrent+14]=this.st_7
this.Control[iCurrent+15]=this.ddlb_model_name
this.Control[iCurrent+16]=this.sle_1
this.Control[iCurrent+17]=this.st_8
this.Control[iCurrent+18]=this.uo_release_date
this.Control[iCurrent+19]=this.cbx_release_date
this.Control[iCurrent+20]=this.sle_2
this.Control[iCurrent+21]=this.st_9
this.Control[iCurrent+22]=this.cb_1
this.Control[iCurrent+23]=this.cb_2
this.Control[iCurrent+24]=this.gb_2
this.Control[iCurrent+25]=this.gb_1
this.Control[iCurrent+26]=this.gb_3
this.Control[iCurrent+27]=this.gb_4
end on

on w_pln_product_software_version_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.cb_excel)
destroy(this.sle_model_suffix)
destroy(this.st_2)
destroy(this.mle_issue)
destroy(this.st_3)
destroy(this.mle_apply_comments)
destroy(this.st_4)
destroy(this.em_last_check_date)
destroy(this.em_running)
destroy(this.em_new)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.ddlb_model_name)
destroy(this.sle_1)
destroy(this.st_8)
destroy(this.uo_release_date)
destroy(this.cbx_release_date)
destroy(this.sle_2)
destroy(this.st_9)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event activate;call super::activate;/***************************************
* $$HEX17$$08c7c4b324c115c8d0c5200000ad5cd52000acc06dd544c720004bc105d35cd5e4b2$$ENDHEX$$
*
*
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data WIndow Property
******************************************/
Ivs_resize_type    = 'MASTER_DETAIL_12T_3B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property $$HEX6$$54ba74b2200078d5e4b4c1b9$$ENDHEX$$
*****************************************
* ADMIN     : ADMIN  ( $$HEX5$$04c8b4ccacc0a9c62000$$ENDHEX$$)
* $$HEX8$$00adacb9200020002000200020002000$$ENDHEX$$: MANAGE ( $$HEX8$$04c854ba74b2acc0a9c600aca5b22000$$ENDHEX$$)
* $$HEX7$$acc0a9c690c72000200020002000$$ENDHEX$$: GUEST  ( $$HEX11$$30ae08cd2000f1b45db8200070c88cd6200000aca5b2$$ENDHEX$$)
* $$HEX8$$70c88cd6200020002000200020002000$$ENDHEX$$: QUERY  ( $$HEX10$$15c8f4bc70c88cd6ccb9200000aca5b220002000$$ENDHEX$$)
* $$HEX5$$70b374c7c0d070c891c7$$ENDHEX$$: DATA_CONTROL  ( $$HEX12$$85c725b8200018c215c82000adc01cc8200024c115c82000$$ENDHEX$$)
* $$HEX7$$08b8ecd3b8d22000200020002000$$ENDHEX$$: REPORT ( $$HEX4$$08b8ecd3b8d22000$$ENDHEX$$, $$HEX5$$9ccd25b800adacb92000$$ENDHEX$$)
****************************************/

F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_SETYN , LVDT_DATESET

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		

			DW_1.RESET()
			DW_2.RESET()
			
			IF cbx_release_date.CHecked = TRUE then 
				
				LVDT_DATESET =  STRING( uo_release_date.text() , 'YYYY.MM.DD')
				
			ELSE
				
				LVDT_DATESET = STRING( f_v_sysdate(3600)  ,  'YYYY.MM.DD')
				
			END IF 
			DW_1.RETRIEVE( ddlb_model_name.getcode( )+'%'	, sle_model_suffix.text+'%'   , 'N'  , LVDT_DATESET, GVS_LANGUAGE, '1' )
			DW_3.RETRIEVE( 'Y' )
			
CASE  'INSERT' 	
			f_set_column_initial_value( dw_1, dw_1.getrow() , 'ALL' )
CASE  'DELETE' 
	
			if DW_1.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_1.GetRow()			
				DW_1.DELETEROW(Gvl_row_deleted)		
				DW_1.SetFocus()
				ROW = DW_1.GetRow()
				DW_1.ScrollToRow(row)
				DW_1.SetColumn(1)
			END IF
			
	CASE 'UPDATE'

	         IF DW_1.UPDATE() < 0 or DW_2.UPDATE() < 0  OR DW_3.UPDATE() < 0  THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
	               F_RETRIEVE()
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF

	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


end event

type dw_5 from w_main_root`dw_5 within w_pln_product_software_version_master
integer y = 636
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_software_version_master
integer y = 636
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_software_version_master
integer y = 1444
integer width = 3982
integer height = 1272
integer taborder = 50
boolean titlebar = true
string title = "New Softwere List"
string dataobject = "d_pln_product_software_version_4_new_lst"
end type

event dw_3::retrieveend;call super::retrieveend;em_new.text = string(rowcount )
end event

event dw_3::buttonclicked;call super::buttonclicked;string lvs_model_name , lvs_model_suffix 

if row < 1 then return 

if dwo.name = 'b_apply' then 
	
	lvs_model_name = this.object.model_name[row] 
	lvs_model_suffix = this.object.model_suffix[row] 
	
	update IP_PRODUCT_SOFTWARE_MASTER set is_new = 'H' 
	 where model_name = :lvs_model_name
	    and model_suffix =  :lvs_model_suffix
		and is_new = 'N'  ;
		
	if f_sql_check() < 0 then 
		return 
	end if 

	this.object.is_new[row] = 'N' 
	
elseif dwo.name = 'b_del' then 
		MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
		IF MSG = 1 THEN
			this.deleterow( row)
		END IF 
end if 

F_UPDATE()



IF dwo.name = 'b_show' then 
			
		if dw_3.getrow() < 1 then 
			return
		end if
		
		Long Lvl_return
		String  lvs_file_name
		if dw_3.getrow() < 1 then return
		
		Lvl_return = f_download_software_version_data ( dw_3.object.upload_date[row] , dw_3.object.last_updated_date[row] , dw_3.object.is_new[row] , dw_3.object.model_name[row] , dw_3.object.model_suffix[row] )
		
		if  Lvl_return > 0 then 

			lvs_file_name = Gvs_default_directory+"\Temp\"+ Gst_return.gvs_return[1]
			
			
			
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			END IF
			
			//messagebox('$$HEX2$$55d678c7$$ENDHEX$$',lvs_file_name + ' $$HEX23$$0cd37cc774c72000e4b2b4c65cb8dcb4200018b4c8c5b5c2c8b2e4b2200055d678c758d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?')
			F_MSGBOX(9023)
			f_shell_execute_by_extention ( Gst_return.gvs_return[1]   , '' ,Gvs_default_directory+'\Temp'  )
		else
			
		end if
		
		Changedirectory(Gvs_default_directory)
	
	
end if 
end event

event dw_3::rowfocuschanged;call super::rowfocuschanged;
long lvl_row

if currentrow < 1 then return 

lvl_row = dw_1.find( "model_name='"+this.object.model_name[currentrow]+"'  and model_suffix='"+this.object.model_suffix[currentrow]+"'" , 1, dw_1.rowcount())

if lvl_row < 1 then return  

dw_1.scrolltorow( lvl_row)
end event

type dw_2 from w_main_root`dw_2 within w_pln_product_software_version_master
integer x = 2807
integer y = 640
integer width = 1166
integer height = 796
integer taborder = 0
boolean titlebar = true
string title = "Excel"
string dataobject = "d_pln_product_software_version_4_hst"
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_software_version_master
integer y = 636
integer width = 2802
integer height = 800
integer taborder = 40
boolean titlebar = true
string title = "Running Software Version List"
string dataobject = "d_pln_product_software_version_lst"
end type

event dw_1::retrievestart;//OVER 
end event

event dw_1::retrieveend;call super::retrieveend;em_running.text = string(rowcount )



end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve( dw_1.object.model_name[currentrow] , dw_1.object.model_suffix[currentrow] , GVS_LANGUAGE, '1' )


em_last_check_date.text = string(dw_1.object.last_check_date[currentrow])

end event

event dw_1::buttonclicked;call super::buttonclicked;string lvs_model_name , lvs_model_suffix 

if row < 1 then return 

IF dwo.name = 'b_show' then 
			
		if dw_1.getrow() < 1 then 
			return
		end if
		
		Long Lvl_return
		String  lvs_file_name
		if dw_1.getrow() < 1 then return
		
		Lvl_return = f_download_software_version_data ( dw_1.object.upload_date[row] , dw_1.object.last_updated_date[row] , dw_1.object.is_new[row] , dw_1.object.model_name[row] , dw_1.object.model_suffix[row] )
		
		if  Lvl_return > 0 then 
			
			lvs_file_name = Gvs_default_directory+"\Temp\"+ Gst_return.gvs_return[1]
			
			
			
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			END IF
			
			//messagebox('$$HEX2$$55d678c7$$ENDHEX$$',lvs_file_name + ' $$HEX23$$0cd37cc774c72000e4b2b4c65cb8dcb4200018b4c8c5b5c2c8b2e4b2200055d678c758d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?')
			F_MSGBOX(9023)
			f_shell_execute_by_extention ( Gst_return.gvs_return[1]   , '' ,Gvs_default_directory+'\Temp'  )
		else
			
		end if
		
		Changedirectory(Gvs_default_directory)
	
	
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_software_version_master
end type

type st_1 from statictext within w_pln_product_software_version_master
integer x = 91
integer y = 96
integer width = 530
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_excel from so_commandbutton within w_pln_product_software_version_master
integer x = 2491
integer y = 104
integer width = 416
integer height = 148
integer taborder = 20
boolean bringtotop = true
string text = "Excel Paste"
end type

event clicked;call super::clicked;open(w_pln_softwere_excel_load_popup )

//
//dw_2.reset()
//dw_2.importclipboard( )
//
//DELETE FROM IP_PRODUCT_SOFTWARE_EXCEL ;
//IF F_SQL_CHECK() < 0 THEN 
//	RETURN 
//END IF 
//
//long i
//do
//	i++
//	
//	dw_2.object.upload_date[i] = f_sysdate()
//	
//	IF cbx_master.checked = true then 
//		dw_2.object.is_new[i] = 'N' 
//	ELSE
//		dw_2.object.is_new[i] = 'Y' 
//	END IF 
//	
//loop until i = dw_2.rowcount( )
//
//if f_msgbox1(1170 , this.text ) = 1 then 
//else
//	return 
//end if 
//
//
//
//if dw_2.update() < 0 then 
//	rollback ;
//	return 
//end if 
//
////===================================
////  $$HEX18$$5ccd85c82000c8b9a4c230d12000f1b45db840c7200034bb70c874ac200085c725b82000$$ENDHEX$$
////===================================
//IF cbx_master.checked = true then 
//	
//else
//
//	// $$HEX13$$c8b9a4c230d1d0c52000c6c594b283ac40c72000adc01cc82000$$ENDHEX$$
//	DELETE FROM IP_PRODUCT_SOFTWARE_EXCEL
//	 WHERE ( MODEL_NAME  , MODEL_SUFFIX ) 
//	 NOT IN ( SELECT MODEL_NAME  , MODEL_SUFFIX 
//						  FROM IP_PRODUCT_SOFTWARE_MASTER ) ;
//						  
//	IF F_SQL_CHECK() < 0 THEN 
//		RETURN 
//	END IF 
//	
//	
//	DELETE FROM IP_PRODUCT_SOFTWARE_EXCEL
//	WHERE ROWID IN ( 
//	
//							SELECT A.ROWID
//							  FROM IP_PRODUCT_SOFTWARE_EXCEL A , IP_PRODUCT_SOFTWARE_MASTER B
//							 WHERE A.MODEL_NAME   = B.MODEL_NAME
//								  AND A.MODEL_SUFFIX = B.MODEL_SUFFIX
//								AND A.STATUS = B.STATUS  
//								AND  A.RELEASE_DATE = B.RELEASE_DATE
//								AND  NVL(A.INPUT_SW_VERSION , '*')= NVL(B.INPUT_SW_VERSION  , '*') 
//								AND NVL(A.OUTPUT_SW_VERSION , '*')= NVL(B.OUTPUT_SW_VERSION  , '*') 
//						//		AND NVL(A.ISSUE , '*' ) = NVL(B.ISSUE , '*') 
//								) ;
//						  
//	IF F_SQL_CHECK() < 0 THEN 
//		RETURN 
//	END IF 	
//	
//	
//	UPDATE IP_PRODUCT_SOFTWARE_MASTER SET LAST_CHECK_DATE = SYSDATE 
//	 WHERE IS_NEW = 'N' ;
//	IF F_SQL_CHECK() < 0 THEN 
//		RETURN 
//	END IF 		
//
//end if 
//
//	COMMIT ;		
//	dw_2.retrieve( )
end event

type sle_model_suffix from so_singlelineedit within w_pln_product_software_version_master
integer x = 635
integer y = 184
integer width = 357
integer taborder = 50
boolean bringtotop = true
textcase textcase = upper!
end type

type st_2 from statictext within w_pln_product_software_version_master
integer x = 635
integer y = 100
integer width = 357
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Model Suffix"
alignment alignment = center!
boolean focusrectangle = false
end type

type mle_issue from so_multilineedit within w_pln_product_software_version_master
integer x = 608
integer y = 332
integer width = 4288
integer height = 144
integer taborder = 20
boolean bringtotop = true
string text = ""
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
end type

type st_3 from so_statictext within w_pln_product_software_version_master
integer x = 50
integer y = 352
integer width = 558
integer height = 60
boolean bringtotop = true
string text = "Issue Note"
alignment alignment = right!
end type

type mle_apply_comments from so_multilineedit within w_pln_product_software_version_master
integer x = 603
integer y = 488
integer width = 4288
integer height = 144
integer taborder = 20
boolean bringtotop = true
string text = ""
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
end type

type st_4 from so_statictext within w_pln_product_software_version_master
integer x = 50
integer y = 496
integer width = 558
integer height = 60
boolean bringtotop = true
string text = "Product Apply Comment"
alignment alignment = right!
end type

type em_last_check_date from so_editmask within w_pln_product_software_version_master
integer x = 3698
integer y = 184
integer width = 933
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string text = ""
alignment alignment = center!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy/mm/dd hh:mm:ss"
boolean spin = true
end type

type em_running from so_editmask within w_pln_product_software_version_master
integer x = 2976
integer y = 184
integer width = 352
integer taborder = 20
boolean bringtotop = true
integer weight = 400
string mask = "###,##0"
end type

type em_new from so_editmask within w_pln_product_software_version_master
integer x = 3337
integer y = 184
integer width = 352
integer taborder = 30
boolean bringtotop = true
integer weight = 400
string mask = "###,##0"
end type

type st_5 from statictext within w_pln_product_software_version_master
integer x = 2985
integer y = 100
integer width = 270
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Running"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_pln_product_software_version_master
integer x = 3342
integer y = 100
integer width = 270
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "New"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_7 from statictext within w_pln_product_software_version_master
integer x = 3698
integer y = 100
integer width = 933
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Last Check Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_model_name from uo_model_name_4_software within w_pln_product_software_version_master
integer x = 101
integer y = 180
integer width = 530
integer height = 2052
integer taborder = 60
boolean bringtotop = true
end type

type sle_1 from so_singlelineedit within w_pln_product_software_version_master
integer x = 1431
integer y = 184
integer width = 590
integer taborder = 60
boolean bringtotop = true
textcase textcase = upper!
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

DW_1.SETFILTER('')
DW_1.FILTER()

LVS_COLUMN = 'ISSUE'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    DW_1.SETFILTER('')
    DW_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_1.SETFILTER(  LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found" )
end event

type st_8 from statictext within w_pln_product_software_version_master
integer x = 1431
integer y = 100
integer width = 590
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Issue Note"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_release_date from uo_ymd_calendar within w_pln_product_software_version_master
integer x = 1006
integer y = 184
integer taborder = 60
boolean bringtotop = true
end type

on uo_release_date.destroy
call uo_ymd_calendar::destroy
end on

type cbx_release_date from so_checkbox within w_pln_product_software_version_master
integer x = 1001
integer y = 104
integer width = 416
integer height = 68
boolean bringtotop = true
string text = "Release Date"
end type

type sle_2 from so_singlelineedit within w_pln_product_software_version_master
integer x = 2030
integer y = 184
integer width = 402
integer taborder = 70
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

DW_1.SETFILTER('')
DW_1.FILTER()

LVS_COLUMN = 'INPUT_SW_VERSION'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    DW_1.SETFILTER('')
    DW_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE =  '%'+UPPER(this.text)+'%'
END IF

DW_1.SETFILTER(  'UPPER('+LVS_COLUMN  +")  LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found" )
end event

type st_9 from statictext within w_pln_product_software_version_master
integer x = 2030
integer y = 100
integer width = 402
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Input SW"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from so_commandbutton within w_pln_product_software_version_master
integer x = 4718
integer y = 52
integer width = 416
integer height = 128
integer taborder = 30
boolean bringtotop = true
string text = "File Upload"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return

int    li_filenum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   lib_file , b
//double lvdb_sequence
string is_filename, is_fullname  
datetime lvdt_action_date
string ls_new, ls_model, ls_suffix
		
		
		if  dw_1.getrow() < 1 then 
			 return
		end if
			
		lvdt_action_date  = dw_1.object.upload_date[dw_1.getrow()]
		ls_new= dw_1.object.is_new[dw_1.getrow()]
		ls_model= dw_1.object.model_name[dw_1.getrow()]
		ls_suffix= dw_1.object.model_suffix[dw_1.getrow()]
		

		
		if  isnull(lvdt_action_date) then 
			return
		end if		
		
		if getfileopenname("select file", is_fullname, is_filename, "ppt", &
			 + "ppt files (*.ppt),*.ppt," &	
			 + "xls files (*.xls),*.xls," &
			 + "doc files (*.doc),*.doc," &			 
			 + "all files (*.*), *.*") < 1 then return
		
		flen = filelength(is_fullname)
		
		if flen < 0 then 
			rollback;			
			f_msgbox1(9020 ,is_fullname )
			return 
		end if
		
		li_filenum = fileopen(is_fullname,  streammode!, read!, lockread!)
		
		if li_filenum <> -1 then
				
					setpointer(hourglass!)
					if flen > 32765 then
					
							  if mod(flen, 32765) = 0 then
									loops = flen/32765
							  else
									loops = (flen/32765) + 1
							  end if
					else
							  loops = 1
					end if
					
					new_pos = 1
					for i = 1 to loops
							  bytes_read = fileread(li_filenum, b)
							  bytes_read_sum = bytes_read_sum + bytes_read
							  lib_file = lib_file + b
							  f_msg_mdi_help( string(bytes_read_sum)+"/"+string(flen)+" bytes read" )
					next
					
					fileclose(li_filenum)
					
						
							update IP_PRODUCT_SOFTWARE_MASTER 
									set DOCUMENT_IMAGE_FILE_NAME = :is_filename 
									where UPLOAD_DATE       = :lvdt_action_date
									 	 and IS_NEW = :ls_new
										 and MODEL_NAME = :ls_model
										 and MODEL_SUFFIX = :ls_suffix;
										 
							if f_sql_check() < 0 then
								rollback;
								  messagebox("error1" , is_filename+ f_msg(" file upload to database failed ","S") +sqlca.sqlerrtext )
								return
							end if 

							updateblob IP_PRODUCT_SOFTWARE_MASTER 
							set DOCUMENT_IMAGE = :lib_file 
							where UPLOAD_DATE       = :lvdt_action_date
									 	 and IS_NEW = :ls_new
										 and MODEL_NAME = :ls_model
										 and MODEL_SUFFIX = :ls_suffix;
										 



				  if f_sql_check() < 0 then

					  rollback ;
					  messagebox("error2" , is_filename+ f_msg( " file upload to database failed ","S" ) + sqlca.sqlerrtext )
					  return
				  end if;

				  commit ;			
			     f_msgbox(9022)
					 
	end if
	changedirectory(gvs_default_directory)
	
	//$$HEX3$$acc770c88cd6$$ENDHEX$$
	Gvs_Ue_DATA_control = 'RETRIEVE'
	Parent.Triggerevent("UE_DATA_CONTROL")
end event

type cb_2 from so_commandbutton within w_pln_product_software_version_master
integer x = 4718
integer y = 180
integer width = 416
integer height = 128
integer taborder = 40
boolean bringtotop = true
string text = "File Delete"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return
string lvs_jig_code
blob lblob_null
datetime lvdt_action_date
double lvdb_sequence
string ls_new, ls_model, ls_suffix

setnull(lblob_null)

lblob_null = blob(' ')

int lvi_count

		if  dw_1.getrow() < 1 then 
			 return
		end if
			
		lvdt_action_date  = dw_1.object.upload_date[dw_1.getrow()]
		ls_new= dw_1.object.is_new[dw_1.getrow()]
		ls_model= dw_1.object.model_name[dw_1.getrow()]
		ls_suffix= dw_1.object.model_suffix[dw_1.getrow()]
			

					
					update IP_PRODUCT_SOFTWARE_MASTER
	               set DOCUMENT_IMAGE = EMPTY_BLOB()
					where UPLOAD_DATE = :lvdt_action_date
						 and IS_NEW = :ls_new
						 and MODEL_NAME = :ls_model
						 and MODEL_SUFFIX = :ls_suffix ;
						 
					update IP_PRODUCT_SOFTWARE_MASTER
					set DOCUMENT_IMAGE_FILE_NAME = ''
					where UPLOAD_DATE = :lvdt_action_date
						 and IS_NEW = :ls_new
						 and MODEL_NAME = :ls_model
						 and MODEL_SUFFIX = :ls_suffix ;

					if f_sql_check() < 0 then 
						return 
					else
						commit ;
						f_msgbox(164)
					end if 
					
					
changedirectory(gvs_default_directory)

//$$HEX3$$acc770c88cd6$$ENDHEX$$
Gvs_Ue_DATA_control = 'RETRIEVE'
Parent.Triggerevent("UE_DATA_CONTROL")

end event

type gb_2 from so_groupbox within w_pln_product_software_version_master
integer x = 2949
integer width = 1719
integer height = 316
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Info"
end type

type gb_1 from so_groupbox within w_pln_product_software_version_master
integer x = 23
integer width = 2437
integer height = 316
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_pln_product_software_version_master
integer x = 2459
integer y = 4
integer width = 471
integer height = 316
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_4 from so_groupbox within w_pln_product_software_version_master
integer x = 4667
integer width = 512
integer height = 316
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Upload"
end type


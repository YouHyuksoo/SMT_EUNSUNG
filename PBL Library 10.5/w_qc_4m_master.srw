HA$PBExportHeader$w_qc_4m_master.srw
$PBExportComments$Line Master
forward
global type w_qc_4m_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_qc_4m_master
end type
type st_4 from so_statictext within w_qc_4m_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_qc_4m_master
end type
type st_1 from so_statictext within w_qc_4m_master
end type
type cb_7 from so_commandbutton within w_qc_4m_master
end type
type cb_9 from so_commandbutton within w_qc_4m_master
end type
type sle_model_name from so_singlelineedit within w_qc_4m_master
end type
type st_mrm_no from so_statictext within w_qc_4m_master
end type
type sle_pcb_serial_no from so_singlelineedit within w_qc_4m_master
end type
type st_2 from statictext within w_qc_4m_master
end type
type sle_keyword from so_singlelineedit within w_qc_4m_master
end type
type st_14 from so_statictext within w_qc_4m_master
end type
type rb_list from so_radiobutton within w_qc_4m_master
end type
type rb_history from so_radiobutton within w_qc_4m_master
end type
type rb_our from so_radiobutton within w_qc_4m_master
end type
type rb_customer from so_radiobutton within w_qc_4m_master
end type
type rb_1 from so_radiobutton within w_qc_4m_master
end type
type cb_1 from so_commandbutton within w_qc_4m_master
end type
type gb_1 from so_groupbox within w_qc_4m_master
end type
type gb_2 from so_groupbox within w_qc_4m_master
end type
type gb_3 from so_groupbox within w_qc_4m_master
end type
end forward

global type w_qc_4m_master from w_main_root
integer width = 6194
integer height = 2904
string title = "4M History Master"
windowstate windowstate = maximized!
uo_dateset uo_dateset
st_4 st_4
ddlb_workstage_code ddlb_workstage_code
st_1 st_1
cb_7 cb_7
cb_9 cb_9
sle_model_name sle_model_name
st_mrm_no st_mrm_no
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
sle_keyword sle_keyword
st_14 st_14
rb_list rb_list
rb_history rb_history
rb_our rb_our
rb_customer rb_customer
rb_1 rb_1
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_qc_4m_master w_qc_4m_master

on w_qc_4m_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.st_4=create st_4
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_1=create st_1
this.cb_7=create cb_7
this.cb_9=create cb_9
this.sle_model_name=create sle_model_name
this.st_mrm_no=create st_mrm_no
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_2=create st_2
this.sle_keyword=create sle_keyword
this.st_14=create st_14
this.rb_list=create rb_list
this.rb_history=create rb_history
this.rb_our=create rb_our
this.rb_customer=create rb_customer
this.rb_1=create rb_1
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.ddlb_workstage_code
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cb_7
this.Control[iCurrent+6]=this.cb_9
this.Control[iCurrent+7]=this.sle_model_name
this.Control[iCurrent+8]=this.st_mrm_no
this.Control[iCurrent+9]=this.sle_pcb_serial_no
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.sle_keyword
this.Control[iCurrent+12]=this.st_14
this.Control[iCurrent+13]=this.rb_list
this.Control[iCurrent+14]=this.rb_history
this.Control[iCurrent+15]=this.rb_our
this.Control[iCurrent+16]=this.rb_customer
this.Control[iCurrent+17]=this.rb_1
this.Control[iCurrent+18]=this.cb_1
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_2
this.Control[iCurrent+21]=this.gb_3
end on

on w_qc_4m_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.st_4)
destroy(this.ddlb_workstage_code)
destroy(this.st_1)
destroy(this.cb_7)
destroy(this.cb_9)
destroy(this.sle_model_name)
destroy(this.st_mrm_no)
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.sle_keyword)
destroy(this.st_14)
destroy(this.rb_list)
destroy(this.rb_history)
destroy(this.rb_our)
destroy(this.rb_customer)
destroy(this.rb_1)
destroy(this.cb_1)
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
Ivs_resize_type                      = 'MASTER_DETAIL_12T_3B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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

//dw_3.sharedata( dw_1)
end event

event ue_data_control;call super::ue_data_control;long row
STRING ls_suffix

if ls_suffix = '' then
	ls_suffix = '%'
end if

choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			
			
			if rb_list.checked = true then 
				
				DW_1.reset()
				DW_1.retrieve(  sle_model_name.text+'%' , gvi_organization_id)
				DW_1.setfocus()
				
			elseif rb_history.checked = true then 
				
				DW_4.reset()
				DW_4.retrieve(  sle_model_name.text+'%' , ddlb_workstage_code.getcode( )+'%' ,  uo_dateset.text(),  '%'+sle_keyword.text+'%' ,   gvi_organization_id)
				DW_4.setfocus()			
			else
				
				DW_5.retrieve(  sle_model_name.text , gvi_organization_id, ls_suffix)
				
			end if ;
	case 'INSERT'		
			DW_3.ENABLED = TRUE
			ROW = DW_3.INSERTROW(DW_3.GETROW())
			DW_3.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_3 , ROW ,'ALL')				
			
			DW_3.setitem(ROW , 'eco_date' , f_sysdate())


	case 'APPEND'		
			DW_3.ENABLED = TRUE
			ROW = DW_3.INSERTROW(0)
			DW_3.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_3 , ROW ,'ALL')				
			
			DW_3.setitem(ROW , 'eco_date' , f_sysdate())
		
	case 'DELETE'
		
		  	if DW_3.getrow() < 1 then return 
			  
			msg =f_msgbox(1003)
			if msg = 1 then
				gvl_row_deleted = DW_3.getrow()			
				DW_3.deleterow(gvl_row_deleted)		
				DW_3.setfocus()
				row = DW_3.getrow()
				DW_3.scrolltorow(row)
				DW_3.setcolumn(1)
			end if
			
	case 'UPDATE'
		
			if DW_3.update() < 0 then
				rollback;
			else
				commit;
				f_msg_mdi_help(f_msg_st(170))
			end if
			
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_qc_4m_master
integer y = 316
integer width = 3131
integer height = 776
boolean titlebar = true
string title = "Report"
string dataobject = "d_qc_4m_history_rpt"
end type

type dw_4 from w_main_root`dw_4 within w_qc_4m_master
integer y = 316
integer width = 3131
integer height = 776
boolean titlebar = true
string title = "4M History"
string dataobject = "d_qc_4m_hist"
end type

event dw_4::buttonclicked;call super::buttonclicked;IF dwo.name = 'b_show' then 
			
		if this.getrow() < 1 then 
			return
		end if
		
		Long Lvl_return
		String  lvs_file_name , lvs_type
		if this.getrow() < 1 then return 
		
		if rb_our.checked = true then 
			lvs_type = "1" 
		else
			lvs_type = "2" 
		end if 
		
		Lvl_return = f_download_qc_4m_data ( this.object.eco_date[this.getrow()] , string(this.object.model_name[this.getrow()]) , lvs_type )
		
		if  Lvl_return > 0 then 
		
			lvs_file_name = Gvs_default_directory+"\Temp\"+ Gst_return.gvs_return[1]
			
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			END IF
			
			f_shell_execute_by_extention ( Gst_return.gvs_return[1]   , '' ,Gvs_default_directory+'\Temp'  )
		else
			
		end if
		
		Changedirectory(Gvs_default_directory)
	
	
end if 
end event

type dw_3 from w_main_root`dw_3 within w_qc_4m_master
integer y = 1096
integer width = 5390
integer height = 1116
string dataobject = "d_qc_4m_mst"
end type

event dw_3::rbuttondown;call super::rbuttondown;if dwo.name = 'model_name' then 
	
	openwithparm( w_des_set_item_popup , '') 
	
	if gst_return.gvb_return = true then 
	
		this.object.model_name[row]=Gst_return.Gvs_return[9] 
		this.OBJECT.FIRST_PRODUCT_DATE[ROW] = F_GET_PRODUCT_DATE_BY_MODEL(Gst_return.Gvs_return[9]  , 'FIRST') 
		this.OBJECT.LAST_PRODUCT_DATE[ROW] = F_GET_PRODUCT_DATE_BY_MODEL( Gst_return.Gvs_return[9] , 'LAST')    
		
	end if 
end if 
end event

event dw_3::itemchanged;call super::itemchanged;IF DWO.NAME = 'model_name' then 
	
	
	DW_3.OBJECT.FIRST_PRODUCT_DATE[ROW] = F_GET_PRODUCT_DATE_BY_MODEL(DATA , 'FIRST') 
	DW_3.OBJECT.LAST_PRODUCT_DATE[ROW] = F_GET_PRODUCT_DATE_BY_MODEL( DATA, 'LAST') 


end if 
end event

type dw_2 from w_main_root`dw_2 within w_qc_4m_master
integer x = 3136
integer y = 320
integer width = 2249
integer height = 776
boolean titlebar = true
string title = "PID Tracking"
boolean controlmenu = true
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_qc_4m_master
integer y = 316
integer width = 3131
integer height = 776
boolean titlebar = true
string title = "4M List"
string dataobject = "d_qc_4m_lst"
end type

event dw_1::buttonclicked;call super::buttonclicked;IF dwo.name = 'b_show' then 
			
		if dw_1.getrow() < 1 then 
			return
		end if
		
		Long Lvl_return
		String  lvs_file_name , lvs_type
		if dw_1.getrow() < 1 then return 
		
		if rb_our.checked = true then 
			lvs_type = "1" 
		else
			lvs_type = "2" 
		end if 
		
		Lvl_return = f_download_qc_4m_data ( dw_1.object.eco_date[dw_1.getrow()] , string(dw_1.object.model_name[dw_1.getrow()]) , lvs_type )
		
		if  Lvl_return > 0 then 
		
			lvs_file_name = Gvs_default_directory+"\Temp\"+ Gst_return.gvs_return[1]
			
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			END IF
			
			f_shell_execute_by_extention ( Gst_return.gvs_return[1]   , '' ,Gvs_default_directory+'\Temp'  )
		else
			
		end if
		
		Changedirectory(Gvs_default_directory)
	
	
end if 
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 

dw_3.retrieve(  this.object.rowid[currentrow])
end event

type uo_tabpages from w_main_root`uo_tabpages within w_qc_4m_master
end type

type uo_dateset from uo_ymd_calendar within w_qc_4m_master
event destroy ( )
integer x = 2839
integer y = 180
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_qc_4m_master
integer x = 2843
integer y = 92
integer width = 416
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "4M Date"
end type

type ddlb_workstage_code from uo_workstage_code_all within w_qc_4m_master
integer x = 1925
integer y = 180
integer width = 905
integer height = 1484
integer taborder = 40
boolean bringtotop = true
end type

type st_1 from so_statictext within w_qc_4m_master
integer x = 1925
integer y = 104
integer width = 905
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type cb_7 from so_commandbutton within w_qc_4m_master
integer x = 4814
integer y = 40
integer width = 535
integer height = 124
integer taborder = 30
boolean bringtotop = true
string text = "File Upload"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return

int    li_filenum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   lib_file , b
string lvs_model_name
string is_filename, is_fullname  
datetime lvdt_eco_date
		
		
		if  dw_1.getrow() < 1 then 
			 return
		end if
			
		lvdt_eco_date    = dw_1.object.eco_date[dw_1.getrow()]
		lvs_model_name= string(dw_1.object.model_name[dw_1.getrow()])
		 
		if  isnull(lvdt_eco_date) then 
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
					
					
					if rb_our.checked  = true then 
					
						update iq_4m_master 
						set eco_image_file_Name = :is_filename 
						where eco_date       = :lvdt_eco_date
						and model_name = :lvs_model_name
						and organization_id = :gvi_organization_id ;
										 
										 
					else
						update iq_4m_master 
						set eco_image_file_Name2 = :is_filename 
						where eco_date       = :lvdt_eco_date
						and model_name = :lvs_model_name
						and organization_id = :gvi_organization_id ;				
						
					end if 
				 
					if f_sql_check() < 0 then 
						return
					end if 
					
				if rb_our.checked  = true then 										  
						updateblob iq_4m_master set eco_image = :lib_file 
						where eco_date       = :lvdt_eco_date
						and model_name = :lvs_model_name
						and organization_id = :gvi_organization_id ;
				else
						updateblob iq_4m_master set eco_image2 = :lib_file 
						where eco_date       = :lvdt_eco_date
						and model_name = :lvs_model_name
						and organization_id = :gvi_organization_id ;
				end if 
				  if sqlca.sqlnrows > 0 then

				  else
					  rollback ;
					  messagebox("error" , is_filename+f_msg(" file upload to database failed ",'S')+sqlca.sqlerrtext )
					  return
				  end if;

				  commit ;
			       f_msgbox(9022)
					 
	end if
	changedirectory(gvs_default_directory)
end event

type cb_9 from so_commandbutton within w_qc_4m_master
integer x = 4814
integer y = 176
integer width = 535
integer height = 124
integer taborder = 40
boolean bringtotop = true
string text = "File Delete"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return

blob lblob_null
datetime lvdt_action_date
string lvs_model_name

setnull(lblob_null)

lblob_null = blob(' ')

int lvi_count
				if  dw_1.getrow() < 1 then 
					 return
				end if
			
					lvdt_action_date  = dw_1.object.eco_date[dw_1.getrow()]
	  				lvs_model_name= dw_1.object.model_name[dw_1.getrow()]
				
						if rb_our.checked = true then 
							
							updateblob iq_4m_master set eco_image = :lblob_null
							where eco_date       = :lvdt_action_date
							and model_name = :lvs_model_name
							and organization_id = :gvi_organization_id ;
						
						else
						
							updateblob iq_4m_master set eco_image2 = :lblob_null
							where eco_date       = :lvdt_action_date
							and model_name = :lvs_model_name
							and organization_id = :gvi_organization_id ;
						end if 

					if f_sql_check() < 0 then 
						return 
					else
						commit ;
						f_msgbox(9022)
					end if 
changedirectory(gvs_default_directory)

end event

type sle_model_name from so_singlelineedit within w_qc_4m_master
integer x = 1344
integer y = 180
integer width = 526
integer taborder = 70
boolean bringtotop = true
end type

type st_mrm_no from so_statictext within w_qc_4m_master
integer x = 1339
integer y = 84
integer width = 526
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Model Name"
end type

type sle_pcb_serial_no from so_singlelineedit within w_qc_4m_master
integer x = 663
integer y = 180
integer width = 681
integer taborder = 11
boolean bringtotop = true
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext( 1,30)
end event

event modified;call super::modified;string lvs_serial_no ,  lvs_line_code , lvs_bad_reason_code , lvs_workstage_code , lvs_item_code , lvs_model_name, lvs_suffix
long lvl_sequence , ll_row
		
lvs_serial_no = this.text 
//==============================================
// $$HEX18$$a4c294ce2000c8b9a4c230d15cb8200080bd45d1200015c8f4bc200000ac38c834c62000$$ENDHEX$$
//==============================================

//SELECT  DISTINCT MODEL , ITEM_CODE  , LOCATION  , buyer
//   INTO  :LVS_MODEL_NAME , :lvs_item_code ,   :lvs_workstage_code , :lvs_suffix
//FROM TB_VIS_PID_ISSUE_HIST
//WHERE PRODUCT_ID = :lvs_serial_no ;

SELECT MODEL_NAME, ITEM_CODE, WORKSTAGE_CODE, MODEL_SUFFIX
   INTO  :LVS_MODEL_NAME , :lvs_item_code ,   :lvs_workstage_code , :lvs_suffix
  FROM IP_PRODUCT_2D_BARCODE 
 WHERE SERIAL_NO = :lvs_serial_no ; 



	IF F_SQL_CHECK() < 0 THEN 
		RETURN 
	END IF 
IF LVS_MODEL_NAME = '' OR ISNULL(LVS_MODEL_NAME) THEN 
		//mess agebox("Notify" , "Not Found PID Information")
		f_msg( "Not Found PID Information",'P')
		return 
ELSE
//
//	SELECT MODEL_NAME
//	    INTO :LVS_MODEL_NAME 
//	   FROM ID_ITEM 
//	WHERE ITEM_CODE = :lvs_item_code
//	     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
//		  
//	IF F_SQL_CHECK() < 0 THEN 
//		RETURN 
//	END IF 
	
END IF 

sle_model_name.text = LVS_MODEL_NAME

dw_1.retrieve( LVS_MODEL_NAME , gvi_organization_id , lvs_suffix )
dw_2.retrieve( this.text )
		
end event

type st_2 from statictext within w_qc_4m_master
integer x = 663
integer y = 100
integer width = 681
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "PCB Serial No"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_keyword from so_singlelineedit within w_qc_4m_master
integer x = 3264
integer y = 180
integer width = 1024
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type st_14 from so_statictext within w_qc_4m_master
integer x = 3264
integer y = 92
integer width = 1024
integer height = 68
boolean bringtotop = true
long textcolor = 16711680
string text = "Key Word"
end type

type rb_list from so_radiobutton within w_qc_4m_master
integer x = 50
integer y = 64
boolean bringtotop = true
string text = "4M List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
dw_2.bringtotop = true 
dw_3.bringtotop = true 
selected_data_window = dw_1
end event

type rb_history from so_radiobutton within w_qc_4m_master
integer x = 50
integer y = 144
boolean bringtotop = true
string text = "4M History"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4
end event

type rb_our from so_radiobutton within w_qc_4m_master
integer x = 4370
integer y = 80
integer width = 434
boolean bringtotop = true
string text = "Our Document"
boolean checked = true
end type

type rb_customer from so_radiobutton within w_qc_4m_master
integer x = 4370
integer y = 180
integer width = 434
boolean bringtotop = true
string text = "Customer Doc"
end type

type rb_1 from so_radiobutton within w_qc_4m_master
integer x = 50
integer y = 212
boolean bringtotop = true
string text = "4M Change Report"
end type

event clicked;call super::clicked;dw_5.bringtotop = true 
selected_data_window = dw_5

STRING ls_suffix

if ls_suffix = '' then
	ls_suffix = '%'
end if



//if ls_model_name <> '' then
//	
//	dw_5.retrieve(  dw_1.object.model_name(dw_1.getrow()) , gvi_organization_id, ls_suffix )
//	
//end if

if isValid(selected_data_window) then 
	
	if selected_data_window.Describe("DataWindow.Print.Preview") = '!' or &
		selected_data_window.Describe("DataWindow.Print.Preview") = '?' then
	else
		selected_data_window.Modify("DataWindow.Print.Preview=yes")
		selected_data_window.Modify("DataWindow.Print.Preview.Rulers=yes")
	end if

end if
end event

type cb_1 from so_commandbutton within w_qc_4m_master
integer x = 5381
integer y = 44
integer width = 535
integer height = 124
integer taborder = 20
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;if dw_5.getrow() < 1 then return 
dw_5.print( false)
end event

type gb_1 from so_groupbox within w_qc_4m_master
integer x = 617
integer width = 3694
integer height = 304
integer taborder = 10
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_qc_4m_master
integer x = 4347
integer width = 1637
integer height = 308
integer taborder = 30
end type

type gb_3 from so_groupbox within w_qc_4m_master
integer width = 603
integer height = 304
integer taborder = 10
long textcolor = 16711680
string text = "Category"
end type


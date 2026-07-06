HA$PBExportHeader$w_product_label_master.srw
$PBExportComments$Line Master
forward
global type w_product_label_master from w_main_root
end type
type st_1 from statictext within w_product_label_master
end type
type gb_3 from so_groupbox within w_product_label_master
end type
type gb_1 from so_groupbox within w_product_label_master
end type
type sle_exe_path from so_singlelineedit within w_product_label_master
end type
type cb_1 from so_commandbutton within w_product_label_master
end type
type sle_model_name from so_singlelineedit within w_product_label_master
end type
type cb_2 from so_commandbutton within w_product_label_master
end type
type cb_3 from so_commandbutton within w_product_label_master
end type
type cb_4 from so_commandbutton within w_product_label_master
end type
type cb_5 from so_commandbutton within w_product_label_master
end type
type cb_6 from so_commandbutton within w_product_label_master
end type
type ddlb_new_model_name from uo_model_name_ddlb within w_product_label_master
end type
type cb_7 from so_commandbutton within w_product_label_master
end type
type cbx_show_image from so_checkbox within w_product_label_master
end type
type cbx_show_value from so_checkbox within w_product_label_master
end type
type st_2 from so_statictext within w_product_label_master
end type
type st_3 from so_statictext within w_product_label_master
end type
type gb_2 from so_groupbox within w_product_label_master
end type
type gb_4 from so_groupbox within w_product_label_master
end type
type gb_5 from so_groupbox within w_product_label_master
end type
end forward

global type w_product_label_master from w_main_root
string tag = "Label Master"
integer width = 6368
integer height = 2928
string title = "Product Label Master"
long backcolor = 16777215
string ivs_dw_1_selected_row_yn = "N"
st_1 st_1
gb_3 gb_3
gb_1 gb_1
sle_exe_path sle_exe_path
cb_1 cb_1
sle_model_name sle_model_name
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
cb_5 cb_5
cb_6 cb_6
ddlb_new_model_name ddlb_new_model_name
cb_7 cb_7
cbx_show_image cbx_show_image
cbx_show_value cbx_show_value
st_2 st_2
st_3 st_3
gb_2 gb_2
gb_4 gb_4
gb_5 gb_5
end type
global w_product_label_master w_product_label_master

on w_product_label_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.gb_3=create gb_3
this.gb_1=create gb_1
this.sle_exe_path=create sle_exe_path
this.cb_1=create cb_1
this.sle_model_name=create sle_model_name
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_5=create cb_5
this.cb_6=create cb_6
this.ddlb_new_model_name=create ddlb_new_model_name
this.cb_7=create cb_7
this.cbx_show_image=create cbx_show_image
this.cbx_show_value=create cbx_show_value
this.st_2=create st_2
this.st_3=create st_3
this.gb_2=create gb_2
this.gb_4=create gb_4
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.gb_3
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.sle_exe_path
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.sle_model_name
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.cb_4
this.Control[iCurrent+10]=this.cb_5
this.Control[iCurrent+11]=this.cb_6
this.Control[iCurrent+12]=this.ddlb_new_model_name
this.Control[iCurrent+13]=this.cb_7
this.Control[iCurrent+14]=this.cbx_show_image
this.Control[iCurrent+15]=this.cbx_show_value
this.Control[iCurrent+16]=this.st_2
this.Control[iCurrent+17]=this.st_3
this.Control[iCurrent+18]=this.gb_2
this.Control[iCurrent+19]=this.gb_4
this.Control[iCurrent+20]=this.gb_5
end on

on w_product_label_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.sle_exe_path)
destroy(this.cb_1)
destroy(this.sle_model_name)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.ddlb_new_model_name)
destroy(this.cb_7)
destroy(this.cbx_show_image)
destroy(this.cbx_show_value)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.gb_2)
destroy(this.gb_4)
destroy(this.gb_5)
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
Ivs_resize_type                      = 'MASTER_DETAIL_12T'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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


IF gvi_user_level >= 8 THEN                               // $$HEX3$$00adacb990c7$$ENDHEX$$, $$HEX4$$18c27cd320c700c8$$ENDHEX$$

    F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control
	 
ELSE
	
   F_MENU_CONTROL('DATA_CONTROL' , FALSE)  
	
END IF;

//=============================================




end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
		case 'RETRIEVE'
			    dw_1.retrieve(sle_model_name.text+'%' ,gvi_organization_id)
			
		case 'INSERT'		
				f_set_column_initial_value( dw_1, dw_1.getrow() , 'ALL' )
			
		case 'APPEND'		
				f_set_column_initial_value( dw_2, 0 , 'ALL' )
			
		case 'DELETE'
			
				if dw_1.getrow() < 1 then return 
				  
				msg =f_msgbox(1003)		
		
				if msg = 1 then
					dw_1.deleterow(dw_1.getrow())
				else
						return
				end if
		
		
		case 'UPDATE'
			
				if dw_1.update() < 0  or dw_2.update() < 0 then
					rollback;
				else
					commit;
					f_msg_mdi_help(f_msg_st(170))
				end if
		
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_product_label_master
integer y = 316
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_product_label_master
integer y = 316
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_product_label_master
integer y = 316
integer width = 2482
integer height = 1388
integer taborder = 0
end type

type dw_2 from w_main_root`dw_2 within w_product_label_master
integer x = 2802
integer y = 320
integer width = 2775
integer height = 1764
integer taborder = 0
boolean titlebar = true
string title = "Label Value Setup"
string dataobject = "d_pln_label_detail_mst2"
end type

type dw_1 from w_main_root`dw_1 within w_product_label_master
integer y = 316
integer width = 2779
integer height = 1768
integer taborder = 0
boolean titlebar = true
string title = "Label Form Master"
string dataobject = "d_com_label_form_lst"
end type

event dw_1::clicked;call super::clicked;if row < 1 then 
	return
end if

Long Lvl_return
String  lvs_file_name
int    li_FileNum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   LIB_FILE , b
string is_filename, is_fullname , LVS_MODEL_NAME
long  LVL_LABEL_FORM_NO

if dwo.name = 'b_upload' then 

					
					IF  ROW < 1 THEN 
						 RETURN
					END IF
					
					LVS_MODEL_NAME  = STRING(dw_1.object.model_name[row])
					LVL_LABEL_FORM_NO  =  LONG(dw_1.object.label_form_no[row])
					
					IF ISNULL(LVS_MODEL_NAME)  or isnull(LVL_LABEL_FORM_NO) THEN 
						RETURN
					END IF		
			
					IF DW_1.UPDATE() < 0 THEN 
						RETURN
					END IF
					
					if GetFileOpenName("Select File", is_fullname, is_filename, "BTW", &
						 + "BTW Files (*.btw),*.BTW," &
						 + "All Files (*.*), *.*") < 1 then return
					
					flen = FileLength(is_fullname)
					
					IF FLEN < 0 THEN 
						ROLLBACK;			
						F_MSGBOX1(9020 ,is_fullname )
						RETURN 
					END IF
					
					li_FileNum = FileOpen(is_fullname,  StreamMode!, Read!, LockRead!)
					
					IF li_FileNum <> -1 THEN
							
								SetPointer(HourGlass!)
								IF flen > 32765 THEN
								
										  IF Mod(flen, 32765) = 0 THEN
												loops = flen/32765
										  ELSE
												loops = (flen/32765) + 1
										  END IF
								ELSE
										  loops = 1
								END IF
								
								new_pos = 1
								FOR i = 1 to loops
										  bytes_read = FileRead(li_FileNum, b)
										  bytes_read_sum = bytes_read_sum + bytes_read
										  LIB_FILE = LIB_FILE + b
										  F_MSG_MDI_HELP( STRING(bytes_read_sum)+"/"+string(flen)+" Bytes Read" )
								NEXT
								
								FileClose(li_FileNum)
								
								
								select count(*) into :lvi_count
								  from ISYS_LABEL_FORM
								 WHERE MODEL_NAME   = :LVS_MODEL_NAME
									 AND LABEL_FORM_NO    = :LVL_LABEL_FORM_NO
									 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
									  
								IF F_SQL_CHECK() < 0 THEN 
									RETURN
								END IF				  
								
								if lvi_count = 0 then 
									ROLLBACK;									
									F_MSGBOX1( 9021 , is_filename ) 
									return
								end if
									  
					 	 UPDATEBLOB ISYS_LABEL_FORM SET LABEL_SYNTAX = :LIB_FILE 
							     WHERE MODEL_NAME   = :LVS_MODEL_NAME
									 AND LABEL_FORM_NO    = :LVL_LABEL_FORM_NO
									 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			
							  IF SQLCA.SQLNROWS > 0 THEN
			
							  ELSE
								  ROLLBACK ;
								  MESSAGEBOX("Error" , is_filename+" File Upload To Database Failed" )
								  RETURN
							  END IF;
							  
								UPDATE ISYS_LABEL_FORM SET LABEL_FORM_NAME = :is_filename 
								WHERE MODEL_NAME   = :LVS_MODEL_NAME
									 AND LABEL_FORM_NO    = :LVL_LABEL_FORM_NO
									 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;		  
					
							  IF F_SQL_CHECK() < 0 THEN 
								  RETURN
							  END IF		  
							  
							  COMMIT ;
							  F_MSGBOX(9022)
			
					END IF
elseif dwo.name = 'b_image_upload' then 

					
					IF  ROW < 1 THEN 
						 RETURN
					END IF
					
					LVS_MODEL_NAME  = STRING(dw_1.object.model_name[row])
					LVL_LABEL_FORM_NO  =  LONG(dw_1.object.label_form_no[row])
					
					IF ISNULL(LVS_MODEL_NAME)  or isnull(LVL_LABEL_FORM_NO) THEN 
						RETURN
					END IF		
			
					IF DW_1.UPDATE() < 0 THEN 
						RETURN
					END IF
					
					if GetFileOpenName("Select File", is_fullname, is_filename, "BMP", &
						 + "BMP Files (*.bmp),*.bmp," &
						 + "All Files (*.*), *.*") < 1 then return
					
					flen = FileLength(is_fullname)
					
					IF FLEN < 0 THEN 
						ROLLBACK;			
						F_MSGBOX1(9020 ,is_fullname )
						RETURN 
					END IF
					
					li_FileNum = FileOpen(is_fullname,  StreamMode!, Read!, LockRead!)
					
					IF li_FileNum <> -1 THEN
							
								SetPointer(HourGlass!)
								IF flen > 32765 THEN
								
										  IF Mod(flen, 32765) = 0 THEN
												loops = flen/32765
										  ELSE
												loops = (flen/32765) + 1
										  END IF
								ELSE
										  loops = 1
								END IF
								
								new_pos = 1
								FOR i = 1 to loops
										  bytes_read = FileRead(li_FileNum, b)
										  bytes_read_sum = bytes_read_sum + bytes_read
										  LIB_FILE = LIB_FILE + b
										  F_MSG_MDI_HELP( STRING(bytes_read_sum)+"/"+string(flen)+" Bytes Read" )
								NEXT
								
								FileClose(li_FileNum)
								
								
								select count(*) into :lvi_count
								  from ISYS_LABEL_FORM
								 WHERE MODEL_NAME   = :LVS_MODEL_NAME
									 AND LABEL_FORM_NO    = :LVL_LABEL_FORM_NO
									 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
									  
								IF F_SQL_CHECK() < 0 THEN 
									RETURN
								END IF				  
								
								if lvi_count = 0 then 
									ROLLBACK;									
									F_MSGBOX1( 9021 , is_filename ) 
									return
								end if
									  
					 	 UPDATEBLOB ISYS_LABEL_FORM SET LABEL_IMAGE = :LIB_FILE 
							     WHERE MODEL_NAME   = :LVS_MODEL_NAME
									 AND LABEL_FORM_NO    = :LVL_LABEL_FORM_NO
									 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			
							  IF SQLCA.SQLNROWS > 0 THEN
			
							  ELSE
								  ROLLBACK ;
								  MESSAGEBOX("Error" , is_filename+" File Upload To Database Failed" )
								  RETURN
							  END IF;
							  
//								UPDATE ISYS_LABEL_FORM SET LABEL_FORM_NAME = :is_filename 
//								WHERE MODEL_NAME   = :LVS_MODEL_NAME
//									 AND LABEL_FORM_NO    = :LVL_LABEL_FORM_NO
//									 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;		  
					
//							  IF F_SQL_CHECK() < 0 THEN 
//								  RETURN
//							  END IF		  
							  
							  COMMIT ;
							  F_MSGBOX(9022)
			
					END IF
	
					
elseif dwo.name = 'b_download' then 

		Lvl_return = f_download_label_form_data ( STRING(dw_1.object.model_name[row])  , LONG(dw_1.object.label_form_no[row] ) )
	
		if  Lvl_return > 0 then 
		
			lvs_file_name = Gvs_default_directory+"\Temp\"+dw_1.object.label_form_name[row] 
			
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			END IF
			
			f_shell_execute_by_extention ( Gst_return.gvs_return[1]   , '' ,Gvs_default_directory+'\Temp'  )
			
		else
			
		end if

end if 

Changedirectory(Gvs_default_directory)

end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 

if cbx_show_value.checked = true then 
	dw_2.retrieve( this.object.model_name[currentrow] , this.object.label_form_no[currentrow] , gvi_organization_id ) 
else
	dw_2.reset()
end if 

if cbx_show_image.checked = true then 
	f_download_label_form_image_data ( STRING(dw_1.object.model_name[currentrow])  , LONG(dw_1.object.label_form_no[currentrow] ) )
end if 
end event

event dw_1::rbuttondown;call super::rbuttondown;if dwo.name = 'model_name' then 
	
	open( w_des_model_master_popup )
	
	if Gst_return.gvb_return = true then 
		this.object.model_name[row] = message.stringparm
	
	end if
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_product_label_master
integer taborder = 0
end type

type st_1 from statictext within w_product_label_master
integer x = 1394
integer y = 96
integer width = 1385
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "EXE Path"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_3 from so_groupbox within w_product_label_master
integer x = 809
integer width = 571
integer height = 304
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Show Option"
end type

type gb_1 from so_groupbox within w_product_label_master
integer x = 2839
integer width = 1202
integer height = 304
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Copy"
end type

type sle_exe_path from so_singlelineedit within w_product_label_master
integer x = 1394
integer y = 172
integer width = 1385
integer taborder = 30
boolean bringtotop = true
boolean displayonly = true
end type

event constructor;call super::constructor;gvs_labeler_path = Profilestring( Gvs_default_directory + "\" + "WORKENV.INI","OTHER","LABELER","")

this.text = gvs_labeler_path

end event

type cb_1 from so_commandbutton within w_product_label_master
integer x = 2441
integer y = 60
integer width = 338
integer height = 104
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string text = "Open"
end type

event clicked;call super::clicked;string docpath, docname[]

integer i, li_cnt, li_rtn, li_filenum

li_rtn = GetFileOpenName("Select File",  docpath, docname[], "EXE", &
   + "Exe Files (*.exe),*.exe," &
   + "All Files (*.*), *.*",  "C:\Program Files\Seagull", 18)

sle_exe_path.text = ""

IF li_rtn < 1 THEN return

li_cnt = Upperbound(docname)



if li_cnt = 1 then

  sle_exe_path.text = string(docpath)
  RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\JSMES", "LABELER", RegString!,string(docpath))
  gvs_labeler_path = string(docpath)
// messagebox(Gvs_default_directory,gvs_labeler_path)
  f_jsSetProfileString (Gvs_default_directory + "\"  +"WORKENV.INI", "OTHER", "LABELER", gvs_labeler_path )
  
end if 


end event

type sle_model_name from so_singlelineedit within w_product_label_master
integer x = 73
integer y = 164
integer width = 677
integer height = 88
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

event rbuttondown;call super::rbuttondown;	open( w_des_model_master_popup )
	
	if Gst_return.gvb_return = true then 
		this.text = message.stringparm
	
	end if 	
end event

type cb_2 from so_commandbutton within w_product_label_master
integer x = 5088
integer y = 60
integer width = 430
integer height = 220
integer taborder = 50
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return

Gst_return.gvl_return[1] = Long(dw_1.object.label_form_no[dw_1.getrow()])
openwithparm( w_com_bartneder_form_popup , dw_1.object.model_name[dw_1.getrow()] )
end event

type cb_3 from so_commandbutton within w_product_label_master
integer x = 4105
integer y = 60
integer width = 439
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer weight = 400
string text = "Labael Upload"
end type

event clicked;call super::clicked;
//----------------------------------------------------------------------------------------
// $$HEX7$$acc0a9c68cad5cd5200055d678c7$$ENDHEX$$
//----------------------------------------------------------------------------------------
if gvi_user_level < 8 then
	
    f_msg("No have Authority, Check it Plz." , "P")
    return
	 
end if

//----------------------------------------------------------------------------------------


if dw_1.getrow() < 1 then 
	return
end if

Long Lvl_return , LVL_LABEL_FORM_NO
int    li_FileNum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   LIB_FILE , b
string is_filename, is_fullname , LVS_MODEL_NAME , lvs_file_name
					
	
					LVS_MODEL_NAME  = STRING(dw_1.object.model_name[dw_1.getrow()])
					LVL_LABEL_FORM_NO  =  LONG(dw_1.object.label_form_no[dw_1.getrow()])
					
					IF ISNULL(LVS_MODEL_NAME)  or isnull(LVL_LABEL_FORM_NO) THEN 
						RETURN
					END IF		
			
					IF DW_1.UPDATE() < 0 THEN 
						RETURN
					END IF
					
					if GetFileOpenName("Select File", is_fullname, is_filename, "BTW", &
						 + "BTW Files (*.btw),*.BTW," &
						 + "All Files (*.*), *.*") < 1 then return
					
					flen = FileLength(is_fullname)
					
					IF FLEN < 0 THEN 
						ROLLBACK;			
						F_MSGBOX1(9020 ,is_fullname )
						RETURN 
					END IF
					
					li_FileNum = FileOpen(is_fullname,  StreamMode!, Read!, LockRead!)
					
					IF li_FileNum <> -1 THEN
							
								SetPointer(HourGlass!)
								IF flen > 32765 THEN
								
										  IF Mod(flen, 32765) = 0 THEN
												loops = flen/32765
										  ELSE
												loops = (flen/32765) + 1
										  END IF
								ELSE
										  loops = 1
								END IF
								
								new_pos = 1
								FOR i = 1 to loops
										  bytes_read = FileRead(li_FileNum, b)
										  bytes_read_sum = bytes_read_sum + bytes_read
										  LIB_FILE = LIB_FILE + b
										  F_MSG_MDI_HELP( STRING(bytes_read_sum)+"/"+string(flen)+" Bytes Read" )
								NEXT
								
								FileClose(li_FileNum)
								
								
								select count(*) into :lvi_count
								  from ISYS_LABEL_FORM
								 WHERE MODEL_NAME   = :LVS_MODEL_NAME
									 AND LABEL_FORM_NO    = :LVL_LABEL_FORM_NO
									 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
									  
								IF F_SQL_CHECK() < 0 THEN 
									RETURN
								END IF				  
								
								if lvi_count = 0 then 
									ROLLBACK;									
									F_MSGBOX1( 9021 , is_filename ) 
									return
								end if
									  
					 	 UPDATEBLOB ISYS_LABEL_FORM SET LABEL_SYNTAX = :LIB_FILE 
							     WHERE MODEL_NAME   = :LVS_MODEL_NAME
									 AND LABEL_FORM_NO    = :LVL_LABEL_FORM_NO
									 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			
							  IF SQLCA.SQLNROWS > 0 THEN
			
							  ELSE
								  ROLLBACK ;
								  MESSAGEBOX("Error" , is_filename+" File Upload To Database Failed" )
								  RETURN
							  END IF;
							  
								UPDATE ISYS_LABEL_FORM SET LABEL_FORM_NAME = :is_filename 
								WHERE MODEL_NAME   = :LVS_MODEL_NAME
									 AND LABEL_FORM_NO    = :LVL_LABEL_FORM_NO
									 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;		  
					
							  IF F_SQL_CHECK() < 0 THEN 
								  RETURN
							  END IF		  
							  
							  COMMIT ;
							  F_MSGBOX(9022)
			
					END IF

Changedirectory(Gvs_default_directory)

end event

type cb_4 from so_commandbutton within w_product_label_master
integer x = 4105
integer y = 180
integer width = 439
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer weight = 400
string text = "Label Download"
end type

event clicked;call super::clicked;if dw_1.getrow()  < 1 then 
	return
end if

Long Lvl_return
String  lvs_file_name

		Lvl_return = f_download_label_form_data ( STRING(dw_1.object.model_name[dw_1.getrow()])  , LONG(dw_1.object.label_form_no[dw_1.getrow()] ) )
	
		if  Lvl_return > 0 then 
		
			lvs_file_name = Gvs_default_directory+"\Temp\"+dw_1.object.label_form_name[dw_1.getrow()] 
			
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			END IF
			
			f_shell_execute_by_extention ( Gst_return.gvs_return[1]   , '' ,Gvs_default_directory+'\Temp'  )
			
		else
			
		end if


Changedirectory(Gvs_default_directory)

end event

type cb_5 from so_commandbutton within w_product_label_master
integer x = 4631
integer y = 60
integer width = 439
integer height = 112
integer taborder = 80
boolean bringtotop = true
integer weight = 400
string text = "Image Upload"
end type

event clicked;call super::clicked;
//----------------------------------------------------------------------------------------
// $$HEX7$$acc0a9c68cad5cd5200055d678c7$$ENDHEX$$
//----------------------------------------------------------------------------------------
if gvi_user_level < 8 then
	
    f_msg("No have Authority, Check it Plz." , "P")
    return
	 
end if

//----------------------------------------------------------------------------------------


STRING LVS_MODEL_NAME  , is_fullname , is_filename
INT li_FileNum , new_pos , I , lvi_count
LONG flen , LVL_LABEL_FORM_NO , loops , bytes_read , bytes_read_sum
bLOB LIB_FILE , B

					
					LVS_MODEL_NAME  = STRING(dw_1.object.model_name[dw_1.getrow()])
					LVL_LABEL_FORM_NO  =  LONG(dw_1.object.label_form_no[dw_1.getrow()])
					
					IF ISNULL(LVS_MODEL_NAME)  or isnull(LVL_LABEL_FORM_NO) THEN 
						RETURN
					END IF		
			
					IF DW_1.UPDATE() < 0 THEN 
						RETURN
					END IF
					
					if GetFileOpenName("Select File", is_fullname, is_filename, "BMP", &
						 + "BMP Files (*.bmp),*.bmp," &
						 + "All Files (*.*), *.*") < 1 then return
					
					flen = FileLength(is_fullname)
					
					IF FLEN < 0 THEN 
						ROLLBACK;			
						F_MSGBOX1(9020 ,is_fullname )
						RETURN 
					END IF
					
					li_FileNum = FileOpen(is_fullname,  StreamMode!, Read!, LockRead!)
					
					IF li_FileNum <> -1 THEN
							
								SetPointer(HourGlass!)
								IF flen > 32765 THEN
								
										  IF Mod(flen, 32765) = 0 THEN
												loops = flen/32765
										  ELSE
												loops = (flen/32765) + 1
										  END IF
								ELSE
										  loops = 1
								END IF
								
								new_pos = 1
								FOR i = 1 to loops
										  bytes_read = FileRead(li_FileNum, b)
										  bytes_read_sum = bytes_read_sum + bytes_read
										  LIB_FILE = LIB_FILE + b
										  F_MSG_MDI_HELP( STRING(bytes_read_sum)+"/"+string(flen)+" Bytes Read" )
								NEXT
								
								FileClose(li_FileNum)
								
								
								select count(*) into :lvi_count
								  from ISYS_LABEL_FORM
								 WHERE MODEL_NAME   = :LVS_MODEL_NAME
									 AND LABEL_FORM_NO    = :LVL_LABEL_FORM_NO
									 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
									  
								IF F_SQL_CHECK() < 0 THEN 
									RETURN
								END IF				  
								
								if lvi_count = 0 then 
									ROLLBACK;									
									F_MSGBOX1( 9021 , is_filename ) 
									return
								end if
									  
					 	 UPDATEBLOB ISYS_LABEL_FORM SET LABEL_IMAGE = :LIB_FILE 
							     WHERE MODEL_NAME   = :LVS_MODEL_NAME
									 AND LABEL_FORM_NO    = :LVL_LABEL_FORM_NO
									 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
			
							  IF SQLCA.SQLNROWS > 0 THEN
			
							  ELSE
								  ROLLBACK ;
								  MESSAGEBOX("Error" , is_filename+" File Upload To Database Failed" )
								  RETURN
							  END IF;
							  
							  
							  COMMIT ;
							  F_MSGBOX(9022)
			
					END IF
	
end event

type cb_6 from so_commandbutton within w_product_label_master
integer x = 4631
integer y = 180
integer width = 439
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer weight = 400
string text = "Image Download"
end type

event clicked;call super::clicked;if dw_1.getrow()  < 1 then 
	return
end if

Long Lvl_return
String  lvs_file_name

		Lvl_return =f_download_label_form_image_data ( STRING(dw_1.object.model_name[dw_1.getrow()])  , LONG(dw_1.object.label_form_no[dw_1.getrow()] ) )
	
		if  Lvl_return > 0 then 
		
			lvs_file_name = Gvs_default_directory+"\Temp\"+dw_1.object.label_form_name[dw_1.getrow()] 
			
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			END IF
			
			f_shell_execute_by_extention ( Gst_return.gvs_return[1]   , '' ,Gvs_default_directory+'\Temp'  )
			
		else
			
		end if


Changedirectory(Gvs_default_directory)

end event

type ddlb_new_model_name from uo_model_name_ddlb within w_product_label_master
integer x = 2912
integer y = 172
integer width = 731
integer height = 2160
integer taborder = 30
boolean bringtotop = true
end type

type cb_7 from so_commandbutton within w_product_label_master
integer x = 3666
integer y = 52
integer width = 338
integer height = 216
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string text = "Copy"
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------
// $$HEX7$$acc0a9c68cad5cd5200055d678c7$$ENDHEX$$
//----------------------------------------------------------------------------------------
if gvi_user_level < 8 then
	
    f_msg("No have Authority, Check it Plz." , "P")
    return
	 
end if

//----------------------------------------------------------------------------------------

long i , lvl_label_form_no , LVB_FILE_LENGTH , lvi_count
string lvs_model_name , lvs_new_model_name
blob lvb_label_syntax , lvb_label_image 

lvs_new_model_name = ddlb_new_model_name.getcode() 

if lvs_new_model_name = '' or isnull(lvs_new_model_name) then 
	f_msg('$$HEX14$$f5bcacc020b42000a8ba78b344c7200020c1ddd0200058d538c194c6$$ENDHEX$$' ,'P')
	return 
end if 

if dw_1.getrow() < 0 then 
	f_msg('$$HEX17$$f5bcacc060d5200000b3c1c02000a8ba78b344c7200020c1ddd0200058d538c194c6$$ENDHEX$$' ,'P')
	return 
end if 


msg = f_msgbox1(1161 , this.text )
if msg = 1 then 
else
	return 
end if 
//================================================
//
//================================================
do
	
	i++

	if dw_1.object.check_yn[i] = 'Y' then 
		
		LVS_MODEL_NAME     = dw_1.object.model_name[i]
		LVL_LABEL_FORM_NO = dw_1.object.label_form_no[i]
		
	else
		continue
	end if 
	
		select   count(*) into :lvi_count
		FROM ISYS_LABEL_FORM
		WHERE MODEL_NAME = :LVS_MODEL_NAME
		AND LABEL_FORM_NO = :LVL_LABEL_FORM_NO
		AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	 
		if f_sql_check() < 0 then 
			return 
		end if 
	
	    if lvi_count = 0 then 	
		   f_msg("$$HEX15$$f5bcacc060d5200000b3c1c02000a8ba78b374c72000c6c5b5c2c8b2e4b2$$ENDHEX$$" , "P")
		   return
		end if 
	
	
	
	  INSERT INTO ISYS_LABEL_FORM  
         ( MODEL_NAME,   
           LABEL_FORM_NO,   
           LABEL_FORM_NAME,   
           LABEL_FORM_TYPE,   
           USE_FLAG,   
           ORGANIZATION_ID,   
           ENTER_DATE,   
           ENTER_BY,   
           LAST_MODIFY_DATE,   
           LAST_MODIFY_BY,              COMMENTS,              V1,              V2,              V3,              V4,              V5,              V6,              V7,              V8,              V9,   
           V10,              V11,              V12,              V13,              V14,              V15,              V16,              V17,              V18,              V19,              V20

	)  
select  :lvs_new_model_name , //  MODEL_NAME,   
           LABEL_FORM_NO,   
           LABEL_FORM_NAME,   
           LABEL_FORM_TYPE,   
           USE_FLAG,   
           ORGANIZATION_ID,   
           ENTER_DATE,   
           ENTER_BY,   
           LAST_MODIFY_DATE,   
           LAST_MODIFY_BY,   
           COMMENTS,              V1,              V2,              V3,              V4,              V5,              V6,              V7,              V8,             V9,              V10,   
           V11,              V12,              V13,             V14,              V15,             V16,              V17,              V18,              V19,              V20   	
  FROM ISYS_LABEL_FORM
WHERE MODEL_NAME = :LVS_MODEL_NAME
     AND LABEL_FORM_NO = :LVL_LABEL_FORM_NO
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	 
	if f_sql_check() < 0 then 
		return 
	end if 

		selectblob label_syntax into :lvb_label_syntax
		FROM ISYS_LABEL_FORM
		WHERE MODEL_NAME = :LVS_MODEL_NAME
		AND LABEL_FORM_NO = :LVL_LABEL_FORM_NO
		AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		
		if f_sql_check() < 0 then 
			return 
		end if 	  
		
		LVB_FILE_LENGTH = LEN(lvb_label_syntax)
		
		IF LVB_FILE_LENGTH = 0 OR ISNULL(LVB_FILE_LENGTH) THEN 
			F_MSGBOX( 117 )
			F_MSG_MDI_HELP( F_MSG_ST( 117 ))
			RETURN -1
		END IF		
		

		updateblob  ISYS_LABEL_FORM 
		set label_syntax      = :lvb_label_syntax
		WHERE MODEL_NAME = :lvs_new_model_name
		AND LABEL_FORM_NO = :LVL_LABEL_FORM_NO
		AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		
		if f_sql_check() < 0 then 
			return 
		end if 	  	
	
		selectblob label_image
		into :lvb_label_image
		FROM ISYS_LABEL_FORM
		WHERE MODEL_NAME = :LVS_MODEL_NAME
		AND LABEL_FORM_NO = :LVL_LABEL_FORM_NO
		AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

		if f_sql_check() < 0 then 
			return 
		end if 	  	  

	
		updateblob  ISYS_LABEL_FORM
		set label_image = :lvb_label_image
		WHERE MODEL_NAME = :lvs_new_model_name
		AND LABEL_FORM_NO = :LVL_LABEL_FORM_NO
		AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

		if f_sql_check() < 0 then 
			return 
		end if 	  		
	
loop until i = dw_1.rowcount( )
commit ; 

dw_1.reset()
f_retrieve()
f_msgbox1( 107 , THIS.TEXT )

end event

type cbx_show_image from so_checkbox within w_product_label_master
integer x = 846
integer y = 80
boolean bringtotop = true
long backcolor = 16777215
string text = "Show Image"
end type

type cbx_show_value from so_checkbox within w_product_label_master
integer x = 841
integer y = 196
boolean bringtotop = true
long backcolor = 16777215
string text = "Show Value"
boolean checked = true
end type

type st_2 from so_statictext within w_product_label_master
integer x = 2912
integer y = 76
integer width = 741
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "New Model Name"
end type

type st_3 from so_statictext within w_product_label_master
integer x = 73
integer y = 72
integer width = 677
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
string text = "Model Name"
end type

type gb_2 from so_groupbox within w_product_label_master
integer x = 1335
integer width = 1472
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Select Bartender Locaton"
end type

type gb_4 from so_groupbox within w_product_label_master
integer x = 4055
integer width = 1527
integer height = 304
integer taborder = 20
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Test Print"
end type

type gb_5 from so_groupbox within w_product_label_master
integer x = 5
integer y = 4
integer width = 791
integer height = 304
integer taborder = 20
integer weight = 700
long textcolor = 16711680
long backcolor = 16777215
string text = "Where Condition"
end type


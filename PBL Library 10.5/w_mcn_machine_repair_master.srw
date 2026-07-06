HA$PBExportHeader$w_mcn_machine_repair_master.srw
$PBExportComments$Customer Infromation Manage
forward
global type w_mcn_machine_repair_master from w_main_root
end type
type sle_machine_code from so_singlelineedit within w_mcn_machine_repair_master
end type
type st_1 from so_statictext within w_mcn_machine_repair_master
end type
type st_2 from so_statictext within w_mcn_machine_repair_master
end type
type sle_machine_name from so_singlelineedit within w_mcn_machine_repair_master
end type
type rb_machine_list from so_radiobutton within w_mcn_machine_repair_master
end type
type rb_machine_repair_history from so_radiobutton within w_mcn_machine_repair_master
end type
type cb_7 from so_commandbutton within w_mcn_machine_repair_master
end type
type cb_9 from so_commandbutton within w_mcn_machine_repair_master
end type
type st_6 from so_statictext within w_mcn_machine_repair_master
end type
type ddlb_machine_type from uo_basecode within w_mcn_machine_repair_master
end type
type uo_dateset from uo_ymd_calendar within w_mcn_machine_repair_master
end type
type uo_dateend from uo_ymd_calendar within w_mcn_machine_repair_master
end type
type st_4 from so_statictext within w_mcn_machine_repair_master
end type
type ddlb_machine_repair_status from uo_basecode within w_mcn_machine_repair_master
end type
type st_3 from so_statictext within w_mcn_machine_repair_master
end type
type gb_1 from groupbox within w_mcn_machine_repair_master
end type
type gb_2 from groupbox within w_mcn_machine_repair_master
end type
type gb_3 from groupbox within w_mcn_machine_repair_master
end type
end forward

global type w_mcn_machine_repair_master from w_main_root
integer y = 256
integer width = 5367
integer height = 3104
string title = "Machine Repair Master"
sle_machine_code sle_machine_code
st_1 st_1
st_2 st_2
sle_machine_name sle_machine_name
rb_machine_list rb_machine_list
rb_machine_repair_history rb_machine_repair_history
cb_7 cb_7
cb_9 cb_9
st_6 st_6
ddlb_machine_type ddlb_machine_type
uo_dateset uo_dateset
uo_dateend uo_dateend
st_4 st_4
ddlb_machine_repair_status ddlb_machine_repair_status
st_3 st_3
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mcn_machine_repair_master w_mcn_machine_repair_master

on w_mcn_machine_repair_master.create
int iCurrent
call super::create
this.sle_machine_code=create sle_machine_code
this.st_1=create st_1
this.st_2=create st_2
this.sle_machine_name=create sle_machine_name
this.rb_machine_list=create rb_machine_list
this.rb_machine_repair_history=create rb_machine_repair_history
this.cb_7=create cb_7
this.cb_9=create cb_9
this.st_6=create st_6
this.ddlb_machine_type=create ddlb_machine_type
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_4=create st_4
this.ddlb_machine_repair_status=create ddlb_machine_repair_status
this.st_3=create st_3
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_machine_code
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_machine_name
this.Control[iCurrent+5]=this.rb_machine_list
this.Control[iCurrent+6]=this.rb_machine_repair_history
this.Control[iCurrent+7]=this.cb_7
this.Control[iCurrent+8]=this.cb_9
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.ddlb_machine_type
this.Control[iCurrent+11]=this.uo_dateset
this.Control[iCurrent+12]=this.uo_dateend
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.ddlb_machine_repair_status
this.Control[iCurrent+15]=this.st_3
this.Control[iCurrent+16]=this.gb_1
this.Control[iCurrent+17]=this.gb_2
this.Control[iCurrent+18]=this.gb_3
end on

on w_mcn_machine_repair_master.destroy
call super::destroy
destroy(this.sle_machine_code)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_machine_name)
destroy(this.rb_machine_list)
destroy(this.rb_machine_repair_history)
destroy(this.cb_7)
destroy(this.cb_9)
destroy(this.st_6)
destroy(this.ddlb_machine_type)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_4)
destroy(this.ddlb_machine_repair_status)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
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
Ivs_resize_type    = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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
STRING LVS_RCV_ISS_TYPE
CHOOSE CASE Gvs_Ue_DATA_control
	CASE 'RETRIEVE'
		
		if rb_machine_list.checked = true then 
			DW_1.RESET( )
			DW_1.RETRIEVE(  sle_machine_code.text+'%' , ddlb_machine_repair_status.getcode( )+'%' , uo_dateset.text() , uo_dateend.text() ,  ddlb_machine_type.getcode( )+'%'  ,  gvi_organization_id )
		else
			DW_3.RESET( )
			DW_3.RETRIEVE(  sle_machine_code.text+'%' , ddlb_machine_type.getcode( )+'%' ,'%' ,  uo_dateset.text( ) , uo_dateend.text( ) ,   gvi_organization_id )
		end if 
			 
	CASE	'INSERT'
		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')				
			dw_2.object.repair_request_date[row] = f_t_sysdate()
			dw_2.object.repair_sequence[row] = f_get_sequence('SEQ_MACHINE_REPAIR_SEQUENCE')
			dw_2.object.repair_status[row] = 'R'
			
              if dw_1.getrow() < 1 then 
		    else
			  DW_2.SETITEM( ROW , 'MACHINE_CODE' , dw_1.object.machine_code[dw_1.getrow()] )
			end if			
			
	CASE	'APPEND'
		
			f_set_column_initial_value( dw_2 , 0 , 'ALL' )	  
			
			dw_2.object.repair_request_date[row] = f_t_sysdate()
			dw_2.object.repair_sequence[row] = f_get_sequence('SEQ_MACHINE_REPAIR_SEQUENCE')
			dw_2.object.repair_status[row] = 'R'
			
              if dw_1.getrow() < 1 then 
		    else
			  DW_2.SETITEM( ROW , 'MACHINE_CODE' , dw_1.object.machine_code[dw_1.getrow()] )
			end if			
			
	CASE	'DELETE'
			if DW_2.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_2.GetRow()			
				DW_2.DELETEROW(Gvl_row_deleted)		
				DW_2.SetFocus()
				ROW = DW_2.GetRow()
				DW_2.ScrollToRow(row)
				DW_2.SetColumn(1)
			END IF

	CASE 'UPDATE'
		
			if rb_machine_repair_history.checked = true then 
				
					IF DW_3.UPDATE() < 0 THEN
						 ROLLBACK;
					ELSE
						 COMMIT;
						 F_RETRIEVE()
						 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
					END IF
					
					
			else

					IF DW_2.UPDATE() < 0 THEN
						 ROLLBACK;
					ELSE
						 COMMIT;
								 F_RETRIEVE()
						 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
					END IF
			end if

 		
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
end event

type dw_5 from w_main_root`dw_5 within w_mcn_machine_repair_master
integer y = 284
end type

type dw_4 from w_main_root`dw_4 within w_mcn_machine_repair_master
integer y = 284
integer taborder = 80
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_mcn_machine_repair_master
integer y = 284
integer width = 4599
integer height = 1092
integer taborder = 70
boolean titlebar = true
string dataobject = "d_mcn_machine_repair_history"
end type

event dw_3::buttonclicked;call super::buttonclicked;if dwo.name = 'b_show' then 		

		Long Lvl_return
		String  lvs_file_name
		
		if this.getrow() < 1 then return 
		
		lvs_file_name = f_download_machine_repair_rtn_filename ( string(this.object.machine_code[this.getrow()] ), long(this.object.repair_sequence[this.getrow()])  )
		
			
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			else
			
				f_shell_execute_by_extention ( lvs_file_name   , '' ,Gvs_default_directory+'\Temp'  )

			end if
		
		Changedirectory(Gvs_default_directory)
	
	
end if 
end event

event dw_3::rowfocuschanged;call super::rowfocuschanged;IF DW_3.GETROW() < 1 THEN RETURN 
DW_2.RETRIEVE( DW_3.GETITEMSTRING( CURRENTROW, 'machine_code' ) , gvi_organization_id)
end event

type dw_2 from w_main_root`dw_2 within w_mcn_machine_repair_master
integer y = 1380
integer width = 4599
integer height = 896
integer taborder = 100
boolean titlebar = true
string title = "Machine Repair List"
string dataobject = "d_mcn_machine_repair_lst"
end type

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'repair_vendor_code' then 	
	open(w_com_supplier_popup)	
	if  gst_return.gvb_return  = true then
	   this.object.repair_vendor_code[row] = message.stringparm
	   gst_return.gvs_return[1]  = ''		
	end if
end if
end event

event dw_2::itemchanged;call super::itemchanged;string lvs_return

if dwo.name = 'repair_vendor_code' then 
	lvs_return = f_get_supplier_name(data , gvi_organization_id)
	if lvs_return = 'ERROR' then 
		return 1 
	end if  
	if lvs_return = 'NOTFOUND' then 
		return 1 
	end if
	
//	this.object.supplier_name[row] = lvs_return 
end if 
end event

event dw_2::uo_mousemove;call super::uo_mousemove;

//if row < 1 then return
//IF   GVS_SHOW_ITEM_IMAGE = 'Y' AND ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'MACHINE_CODE'  ) THEN
//
//	 IF ISVALID(W_MACHINE_REPAIR_IMAGE_FLAT) THEN
//		RETURN
//	ELSE
//			Gst_return.gvl_return[1] = Long(THIS.OBJECT.REPAIR_SEQUENCE[ROW])
//			OPENWITHPARM(W_MACHINE_REPAIR_IMAGE_FLAT , STRING(THIS.OBJECT.MACHINE_CODE[ROW]))
//	END IF 
//ELSE
//
//	IF isvalid(W_MACHINE_REPAIR_IMAGE_FLAT) then
//		close(W_MACHINE_REPAIR_IMAGE_FLAT)
//	end if 
//END IF
end event

event dw_2::clicked;call super::clicked;if dwo.name = 'b_edit' then 
	
	open(w_edit_window )
	if Gst_return.gvb_return  = true then 
		this.object.comments[row] = message.stringparm
	end if 
	
end if 
end event

type dw_1 from w_main_root`dw_1 within w_mcn_machine_repair_master
integer y = 284
integer width = 4599
integer height = 1092
boolean titlebar = true
string title = "Machine Request Wait List"
string dataobject = "d_mcn_machine_repair_change_request_lst"
end type

event dw_1::doubleclicked;call super::doubleclicked;

//IF	ROW < 1	THEN	RETURN
//DW_2.RETRIEVE( DW_1.GETITEMSTRING( ROW, 'MACHINE_CODE' ) , GVI_ORGANIZATION_ID)
//end event
//
//event dw_1::rowfocuschanged;call super::rowfocuschanged;IF	CURRENTROW < 1	THEN	RETURN
//DW_2.RETRIEVE( DW_1.GETITEMSTRING( CURRENTROW, 'machine_code' ) , gvi_organization_id)
//
//

end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF DW_1.GETROW() < 1 THEN RETURN 
DW_2.RETRIEVE( DW_1.GETITEMSTRING( CURRENTROW, 'machine_code' ) , gvi_organization_id)
end event

event dw_1::clicked;call super::clicked;if dwo.name = 'b_show' then 		

		Long Lvl_return
		String  lvs_file_name
		
		if this.getrow() < 1 then return 
		
		lvs_file_name = f_download_machine_repair_rtn_filename ( string(this.object.machine_code[this.getrow()] ), long(this.object.repair_sequence[this.getrow()])  )
		
			
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			else
			
				f_shell_execute_by_extention ( lvs_file_name   , '' ,Gvs_default_directory+'\Temp'  )

			end if
		
		Changedirectory(Gvs_default_directory)
	
	
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_machine_repair_master
end type

type sle_machine_code from so_singlelineedit within w_mcn_machine_repair_master
integer x = 846
integer y = 156
integer width = 494
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mcn_machine_repair_master
integer x = 846
integer y = 76
integer width = 494
boolean bringtotop = true
integer weight = 700
string text = "Machine Code"
end type

type st_2 from so_statictext within w_mcn_machine_repair_master
integer x = 1344
integer y = 76
integer width = 494
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Machine Name"
end type

type sle_machine_name from so_singlelineedit within w_mcn_machine_repair_master
integer x = 1344
integer y = 156
integer width = 494
integer taborder = 20
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'MACHINE_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    SELECTED_DATA_WINDOW.SETFILTER('')
    SELECTED_DATA_WINDOW.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

type rb_machine_list from so_radiobutton within w_mcn_machine_repair_master
integer x = 37
integer y = 68
integer width = 736
boolean bringtotop = true
integer weight = 700
string text = "Machine Request Wait List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1
end event

type rb_machine_repair_history from so_radiobutton within w_mcn_machine_repair_master
integer x = 37
integer y = 164
integer width = 699
boolean bringtotop = true
integer weight = 700
string text = "Machine Repair History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3
end event

type cb_7 from so_commandbutton within w_mcn_machine_repair_master
integer x = 3575
integer y = 52
integer height = 108
integer taborder = 20
boolean bringtotop = true
string text = "Image Upload"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return

int    li_filenum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   lib_file , b
double lvdb_version , lvdb_repair_sequence 
string is_filename, is_fullname , lvs_drawing_no , lvs_machine_code
		
		if  dw_2.getrow() < 1 then 
			 return
		end if
			
			lvs_machine_code  = dw_2.getitemstring( dw_2.getrow() , "machine_code" )
			lvdb_repair_sequence  = dw_2.getitemNumber( dw_2.getrow() , "repair_sequence" )	
	
		if lvs_machine_code ='' or isnull(lvs_machine_code) then 
			return
		end if		
		
		if getfileopenname("select file", is_fullname, is_filename, "jpg", &
			 + "jpg files (*.jpg),*.jpg," &	
			 + "gif files (*.gif),*.gif," &
			 + "bmp files (*.bmp),*.bmp," &			 
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
					
					select count(*) into :lvi_count
						from imcn_machine_repair_image
						where machine_code    = :lvs_machine_code
						and repair_sequence = :lvdb_repair_sequence
						and organization_id = :gvi_organization_id ;
						  
					if f_sql_check() < 0 then 
						return
					end if				  
					
					if lvi_count = 0 then 
						
						insert into imcn_machine_repair_image ( machine_code , repair_sequence , file_name ,  organization_id ) 
						   values ( :lvs_machine_code , :lvdb_repair_sequence , :is_filename , :gvi_organization_id ) ;
								  
						if f_sql_check() < 0 then 
							return
						end if				  
										
					end if
						  
					updateblob imcn_machine_repair_image set repair_image = :lib_file 
					where machine_code       = :lvs_machine_code
					  and repair_sequence = :lvdb_repair_sequence
					  and organization_id = :gvi_organization_id ;

				  if sqlca.sqlnrows > 0 then

				  else
					  rollback ;
					  messagebox("error" , is_filename+" file upload to database failed" )
					  return
				  end if;
			  
				  commit ;
			         f_msgbox(9022)

		end if
changedirectory(gvs_default_directory)

end event

type cb_9 from so_commandbutton within w_mcn_machine_repair_master
integer x = 3575
integer y = 152
integer height = 104
integer taborder = 60
boolean bringtotop = true
string text = "Image Delete"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return
string lvs_machine_code
double lvdb_repair_sequence
int lvi_count
				if  dw_2.getrow() < 1 then 
					 return
				end if
			
				lvs_machine_code  = dw_2.getitemstring( dw_2.getrow() , "machine_code" )
				lvdb_repair_sequence  = dw_2.getitemNumber( dw_2.getrow() , "repair_sequence" )	
				
				if lvs_machine_code ='' or isnull(lvs_machine_code) then 
					return
				end if		

							  
					delete  imcn_machine_repair_image 
					where machine_code  = :lvs_machine_code
					  and repair_sequence = :lvdb_repair_sequence
					  and organization_id   = :gvi_organization_id ;

					if f_sql_check() < 0 then 
						return 
					else
						commit ;
						f_msgbox(9022)
					end if 
changedirectory(gvs_default_directory)

end event

type st_6 from so_statictext within w_mcn_machine_repair_master
integer x = 1851
integer y = 80
integer width = 384
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "Machine Type"
end type

type ddlb_machine_type from uo_basecode within w_mcn_machine_repair_master
integer x = 1847
integer y = 156
integer width = 384
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MACHINE TYPE')
end event

type uo_dateset from uo_ymd_calendar within w_mcn_machine_repair_master
event destroy ( )
integer x = 2674
integer y = 152
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_machine_repair_master
event destroy ( )
integer x = 3090
integer y = 152
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_mcn_machine_repair_master
integer x = 2679
integer y = 76
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Repair Request Date"
end type

type ddlb_machine_repair_status from uo_basecode within w_mcn_machine_repair_master
integer x = 2235
integer y = 156
integer width = 430
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'REPAIR STATUS')
end event

type st_3 from so_statictext within w_mcn_machine_repair_master
integer x = 2240
integer y = 76
integer width = 425
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "Repair Status"
end type

type gb_1 from groupbox within w_mcn_machine_repair_master
integer x = 5
integer width = 786
integer height = 272
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Category"
end type

type gb_2 from groupbox within w_mcn_machine_repair_master
integer x = 3538
integer width = 590
integer height = 280
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Image"
end type

type gb_3 from groupbox within w_mcn_machine_repair_master
integer x = 800
integer width = 2729
integer height = 272
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Where Condition"
end type


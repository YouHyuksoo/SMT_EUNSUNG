HA$PBExportHeader$w_mcn_mold_repair_master.srw
$PBExportComments$Material Receipt Master
forward
global type w_mcn_mold_repair_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mcn_mold_repair_master
end type
type uo_dateend from uo_ymd_calendar within w_mcn_mold_repair_master
end type
type st_3 from so_statictext within w_mcn_mold_repair_master
end type
type st_4 from so_statictext within w_mcn_mold_repair_master
end type
type st_2 from so_statictext within w_mcn_mold_repair_master
end type
type sle_model_name from so_singlelineedit within w_mcn_mold_repair_master
end type
type cb_7 from so_commandbutton within w_mcn_mold_repair_master
end type
type cb_9 from so_commandbutton within w_mcn_mold_repair_master
end type
type rb_mold_list from so_radiobutton within w_mcn_mold_repair_master
end type
type rb_mold_request from so_radiobutton within w_mcn_mold_repair_master
end type
type cb_process from so_commandbutton within w_mcn_mold_repair_master
end type
type ddlb_mold_group from uo_basecode within w_mcn_mold_repair_master
end type
type st_5 from so_statictext within w_mcn_mold_repair_master
end type
type ddlb_mold_code from uo_mold_code within w_mcn_mold_repair_master
end type
type pb_cancel from so_commandbutton within w_mcn_mold_repair_master
end type
type ddlb_line_code from uo_line_code within w_mcn_mold_repair_master
end type
type st_7 from so_statictext within w_mcn_mold_repair_master
end type
type gb_2 from so_groupbox within w_mcn_mold_repair_master
end type
type gb_1 from groupbox within w_mcn_mold_repair_master
end type
type gb_3 from groupbox within w_mcn_mold_repair_master
end type
type gb_4 from groupbox within w_mcn_mold_repair_master
end type
end forward

global type w_mcn_mold_repair_master from w_main_root
integer width = 6213
integer height = 3028
string title = "Mold Repair Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_3 st_3
st_4 st_4
st_2 st_2
sle_model_name sle_model_name
cb_7 cb_7
cb_9 cb_9
rb_mold_list rb_mold_list
rb_mold_request rb_mold_request
cb_process cb_process
ddlb_mold_group ddlb_mold_group
st_5 st_5
ddlb_mold_code ddlb_mold_code
pb_cancel pb_cancel
ddlb_line_code ddlb_line_code
st_7 st_7
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
gb_4 gb_4
end type
global w_mcn_mold_repair_master w_mcn_mold_repair_master

on w_mcn_mold_repair_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_3=create st_3
this.st_4=create st_4
this.st_2=create st_2
this.sle_model_name=create sle_model_name
this.cb_7=create cb_7
this.cb_9=create cb_9
this.rb_mold_list=create rb_mold_list
this.rb_mold_request=create rb_mold_request
this.cb_process=create cb_process
this.ddlb_mold_group=create ddlb_mold_group
this.st_5=create st_5
this.ddlb_mold_code=create ddlb_mold_code
this.pb_cancel=create pb_cancel
this.ddlb_line_code=create ddlb_line_code
this.st_7=create st_7
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_model_name
this.Control[iCurrent+7]=this.cb_7
this.Control[iCurrent+8]=this.cb_9
this.Control[iCurrent+9]=this.rb_mold_list
this.Control[iCurrent+10]=this.rb_mold_request
this.Control[iCurrent+11]=this.cb_process
this.Control[iCurrent+12]=this.ddlb_mold_group
this.Control[iCurrent+13]=this.st_5
this.Control[iCurrent+14]=this.ddlb_mold_code
this.Control[iCurrent+15]=this.pb_cancel
this.Control[iCurrent+16]=this.ddlb_line_code
this.Control[iCurrent+17]=this.st_7
this.Control[iCurrent+18]=this.gb_2
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_3
this.Control[iCurrent+21]=this.gb_4
end on

on w_mcn_mold_repair_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.sle_model_name)
destroy(this.cb_7)
destroy(this.cb_9)
destroy(this.rb_mold_list)
destroy(this.rb_mold_request)
destroy(this.cb_process)
destroy(this.ddlb_mold_group)
destroy(this.st_5)
destroy(this.ddlb_mold_code)
destroy(this.pb_cancel)
destroy(this.ddlb_line_code)
destroy(this.st_7)
destroy(this.gb_2)
destroy(this.gb_1)
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
//Ivs_resize_type                      = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property 
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
uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')

end event

event ue_data_control;call super::ue_data_control;long row
string lvs_date
double LVDB_RCV_ISS_SEQ
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			dw_1.reset()
			dw_2.reset()
			dw_3.reset()
			
			if rb_mold_request.checked = true then 
				    dw_1.retrieve(ddlb_mold_code.text() + '%', 'R' , ddlb_line_code.getcode() +'%' ,  uo_dateset.text() , uo_dateend.text() ,   ddlb_mold_group.getcode( )+'%' , gvi_organization_id)
			elseif rb_mold_list.checked = true then 
				    dw_3.retrieve(ddlb_mold_code.text() + '%',  ddlb_line_code.getcode() +'%' ,  uo_dateset.text() , uo_dateend.text() ,   ddlb_mold_group.getcode( )+'%' , gvi_organization_id)				
			end if 

    case 'INSERT'
		
			ROW = DW_2.INSERTROW(0)
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
			dw_2.object.repair_request_date[row] = f_t_sysdate()
			dw_2.object.repair_sequence[row] = f_get_sequence('SEQ_MOLD_REPAIR_SEQUENCE')
			dw_2.object.repair_status[row] = 'P'
			dw_2.object.repair_reason_code[row] = 'R'			
			dw_2.object.repair_date[row] = f_t_sysdate()
			
              if dw_3.getrow() < 1 then 
		    else
			  DW_2.SETITEM( ROW , 'MOLD_CODE' , dw_3.object.mold_code[dw_3.getrow()] )
			  DW_2.SETITEM( ROW , 'MOLD_VERSION' , dw_3.object.MOLD_VERSION[dw_3.getrow()] )
			  DW_2.SETITEM( ROW , 'MOLD_SET_SERIAL' , dw_3.object.MOLD_SET_SERIAL[dw_3.getrow()] )			  
			end if

	case 'APPEND'		
			
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
			dw_2.object.repair_request_date[row] = f_t_sysdate()
			dw_2.object.repair_sequence[row] = f_get_sequence('SEQ_MOLD_REPAIR_SEQUENCE')
			dw_2.object.repair_status[row] = 'P'
			dw_2.object.repair_reason_code[row] = 'R'	
			dw_2.object.repair_date[row] = f_t_sysdate()			
			
              if dw_3.getrow() < 1 then 
		    else
			  DW_2.SETITEM( ROW , 'MOLD_CODE' , dw_3.object.mold_code[dw_3.getrow()] )
			  DW_2.SETITEM( ROW , 'MOLD_VERSION' , dw_3.object.MOLD_VERSION[dw_3.getrow()] )
			  DW_2.SETITEM( ROW , 'MOLD_SET_SERIAL' , dw_3.object.MOLD_SET_SERIAL[dw_3.getrow()] )				  
			end if

			
			
	case 'DELETE'
		
		  	if DW_2.AcceptText() = -1 then
				return
			end if
			
			IF DW_1.GETROW() < 1 OR DW_2.GETROW() < 1 THEN 
				RETURN 
			END IF 
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				
				DW_1.DELETEROW(DW_1.GETROW())		
				
				Gvl_row_deleted = DW_2.GetRow()			
				DW_2.DELETEROW(Gvl_row_deleted)		
				DW_2.SetFocus()
				ROW = DW_2.GetRow()
				DW_2.ScrollToRow(row)
				DW_2.SetColumn(1)
			END IF		 

			if dw_1.getrow() > 0 then 
				dw_2.retrieve( dw_1.object.rowid[dw_1.getrow()])
			end if 


   case 'UPDATE'
		
			IF DW_2.UPDATE() < 0  OR DW_4.UPDATE() < 0 THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"			 
			END IF

	case else
end choose
end event

event resize;call super::resize;dw_1.resize(newwidth - (dw_1.x + dw_2.width ), newheight -  dw_1.y)
dw_2.x = dw_1.x +dw_1.width
dw_2.y = dw_1.y
dw_2.resize(dw_2.width ,  newheight  -  ( dw_2.y+dw_4.height) )
dw_3.resize(newwidth  - dw_3.x , newheight -  dw_3.y )
dw_4.bringtotop = true
dw_4.y = dw_2.y+ dw_2.height
dw_4.x = dw_2.x
dw_4.resize(dw_2.width , dw_4.height )
dw_5.resize(newwidth  - dw_5.x , newheight - ( dw_5.y + dw_2.height ))	

end event

type dw_5 from w_main_root`dw_5 within w_mcn_mold_repair_master
integer y = 324
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_mcn_mold_repair_master
integer x = 3909
integer y = 1740
integer width = 2190
integer height = 640
integer taborder = 0
boolean titlebar = true
string title = "Repair Item List"
string dataobject = "d_mcn_mold_repair_item_lst"
end type

event dw_4::clicked;call super::clicked;int rows
if dw_2.object.repair_status[dw_2.getrow()] = 'C' THEN  return
if dwo.name = 'b_add' then 
	rows = dw_4.insertrow(0)
	F_SET_SECURITY_ROW(DW_4 , ROWs ,'ALL')	
	dw_4.object.mold_code[rows] = dw_2.object.mold_code[dw_2.getrow()]
	dw_4.object.repair_sequence[rows] = dw_2.object.repair_sequence[dw_2.getrow()]	
	
end if 
end event

type dw_3 from w_main_root`dw_3 within w_mcn_mold_repair_master
integer y = 316
integer width = 3890
integer height = 1348
integer taborder = 0
boolean titlebar = true
string title = "Mold List"
string dataobject = "d_mcn_mold_repair_repair_history_lst"
end type

type dw_2 from w_main_root`dw_2 within w_mcn_mold_repair_master
integer x = 3918
integer y = 316
integer width = 2190
integer height = 1416
integer taborder = 0
boolean titlebar = true
string title = "Mold Repair Change Request List"
string dataobject = "d_mcn_mold_repair_lst"
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'repair_vendor_code' then 	
	open(w_com_supplier_popup)	
	if  gst_return.gvb_return  = true then
	   this.object.repair_vendor_code[row] = message.stringparm
	   gst_return.gvs_return[1]  = ''		
	end if
end if
end event

event dw_2::uo_mousemove;call super::uo_mousemove;

//if row < 1 then return
//IF   GVS_SHOW_ITEM_IMAGE = 'Y' AND ( UPPER(DWO.TYPE) = 'COLUMN' AND  UPPER(DWO.NAME) = 'MOLD_CODE'  ) THEN
//
//	 IF ISVALID(W_MOLD_REPAIR_IMAGE_FLAT) THEN
//		RETURN
//	ELSE
//			Gst_return.gvl_return[1] = Long(THIS.OBJECT.REPAIR_SEQUENCE[ROW])
//			OPENWITHPARM(W_MOLD_REPAIR_IMAGE_FLAT , STRING(THIS.OBJECT.MOLD_CODE[ROW]))
//	END IF 
//ELSE
//
//	IF isvalid(W_MOLD_REPAIR_IMAGE_FLAT) then
//		close(W_MOLD_REPAIR_IMAGE_FLAT)
//	end if 
//END IF
end event

event dw_2::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then 
	
	if this.object.repair_status[currentrow] = 'R' then 
		this.object.repair_by[currentrow] = GVS_USER_NAME
		this.object.repair_date[currentrow] = f_sysdate()    //f_t_sysdate()
	end if 
	
end if 
end event

type dw_1 from w_main_root`dw_1 within w_mcn_mold_repair_master
integer y = 316
integer width = 3913
integer height = 1348
integer taborder = 0
boolean titlebar = true
string title = "Mold Repair Change Request List"
string dataobject = "d_mcn_mold_repair_change_request_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
dw_2.reset()
dw_2.retrieve( this.object.rowid[currentrow])
dw_4.reset()
dw_4.retrieve(this.object.mold_code[currentrow] , this.object.repair_sequence[currentrow] , this.object.organization_id[currentrow] )
if dw_1.object.repair_status[currentrow] = 'C' THEN  
	dw_4.enabled = false
else
	dw_4.enabled = true
end if
	
end event

event dw_1::clicked;call super::clicked;if row < 1 then return 

//dw_2.retrieve( this.object.rowid[row])

//if dwo.name = 'b_show' then 
//	
//	openwithparm( w_des_drawing_select_popup , string(this.object.mold_code[row]) )
//	
//end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_mold_repair_master
integer taborder = 0
end type

type uo_dateset from uo_ymd_calendar within w_mcn_mold_repair_master
event destroy ( )
integer x = 2464
integer y = 160
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_mold_repair_master
event destroy ( )
integer x = 2880
integer y = 160
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_3 from so_statictext within w_mcn_mold_repair_master
integer x = 1307
integer y = 80
integer width = 503
integer height = 68
boolean bringtotop = true
string text = "Mold Code"
end type

type st_4 from so_statictext within w_mcn_mold_repair_master
integer x = 2469
integer y = 80
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Repair Request Date"
end type

type st_2 from so_statictext within w_mcn_mold_repair_master
integer x = 1815
integer y = 80
integer width = 640
integer height = 68
boolean bringtotop = true
long textcolor = 16711680
string text = "Mold Name"
end type

type sle_model_name from so_singlelineedit within w_mcn_mold_repair_master
integer x = 1819
integer y = 160
integer width = 640
integer height = 84
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'MOLD_CODE'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+UPPER(this.text)+'%'
END IF

dw_1.SETFILTER( "UPPER("+LVS_COLUMN+")"  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type cb_7 from so_commandbutton within w_mcn_mold_repair_master
integer x = 4658
integer y = 64
integer width = 443
integer height = 108
boolean bringtotop = true
string text = "File Upload"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return

int    li_filenum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   lib_file , b
double lvdb_version , lvdb_repair_sequence 
string is_filename, is_fullname , lvs_drawing_no , lvs_mold_code
		
		if  dw_2.getrow() < 1 then 
			 return
		end if
			
			lvs_mold_code  = dw_2.getitemstring( dw_2.getrow() , "mold_code" )
			lvdb_repair_sequence  = dw_2.getitemNumber( dw_2.getrow() , "repair_sequence" )	
	
		if lvs_mold_code ='' or isnull(lvs_mold_code) then 
			return
		end if		
		
		if getfileopenname("select file", is_fullname, is_filename, "jpg", &
			 + "jpg files (*.jpg),*.jpg," &	
			 + "gif files (*.ppt),*.ppt," &
			 + "bmp files (*.xls),*.xls," &			 
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
						from imcn_mold_repair_image
						where mold_code    = :lvs_mold_code
						and repair_sequence = :lvdb_repair_sequence
						and organization_id = :gvi_organization_id ;
						  
					if f_sql_check() < 0 then 
						return
					end if				  
					
					if lvi_count = 0 then 
						
						insert into imcn_mold_repair_image ( mold_code , repair_sequence , organization_id,file_name  ) 
						   values ( :lvs_mold_code , :lvdb_repair_sequence ,  :gvi_organization_id, :is_filename) ;
								  
						if f_sql_check() < 0 then 
							return
						end if				  
					else
						update imcn_mold_repair_image 
							 set  file_name = :is_filename
						where mold_code       = :lvs_mold_code
						  and repair_sequence = :lvdb_repair_sequence
						  and organization_id = :gvi_organization_id ;
						if f_sql_check() < 0 then 
							return
						end if										
					end if
						  
					updateblob imcn_mold_repair_image 
					    set repair_image = :lib_file  , file_name = :is_filename
					where mold_code       = :lvs_mold_code
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

type cb_9 from so_commandbutton within w_mcn_mold_repair_master
integer x = 4658
integer y = 176
integer width = 443
integer height = 108
boolean bringtotop = true
string text = "File Delete"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return
string lvs_mold_code
double lvdb_repair_sequence
int lvi_count
				if  dw_2.getrow() < 1 then 
					 return
				end if
			
				lvs_mold_code  = dw_2.getitemstring( dw_2.getrow() , "mold_code" )
				lvdb_repair_sequence  = dw_2.getitemNumber( dw_2.getrow() , "repair_sequence" )	
				
				if lvs_mold_code ='' or isnull(lvs_mold_code) then 
					return
				end if		

							  
					delete  imcn_mold_repair_image 
					where mold_code  = :lvs_mold_code
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

type rb_mold_list from so_radiobutton within w_mcn_mold_repair_master
integer x = 46
integer y = 180
integer width = 667
boolean bringtotop = true
integer weight = 700
string text = "Mold Repair History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3

cb_process.enabled = false
pb_cancel.enabled = false
end event

type rb_mold_request from so_radiobutton within w_mcn_mold_repair_master
integer x = 46
integer y = 92
integer width = 667
boolean bringtotop = true
integer weight = 700
string text = "Mold Request Wait List"
boolean checked = true
end type

event clicked;call super::clicked;dw_3.bringtotop = false
dw_1.bringtotop = true
dw_4.bringtotop = true
selected_data_window = dw_1

cb_process.enabled = true 
pb_cancel.enabled = true
end event

type cb_process from so_commandbutton within w_mcn_mold_repair_master
integer x = 4133
integer y = 56
integer width = 443
integer height = 108
boolean bringtotop = true
string text = "Confirm"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return 

dw_2.object.repair_status[dw_2.getrow( )] = 'C' //$$HEX5$$b9c278c7e0c2adcc2000$$ENDHEX$$

msg = f_msgbox(1170)

if msg = 1 then 
	if dw_2.update( ) < 0 or dw_4.update() < 0 then 
		rollback ;
	else
		commit ;
	
	end if 
else
	f_retrieve()
end if 
end event

type ddlb_mold_group from uo_basecode within w_mcn_mold_repair_master
integer x = 3310
integer y = 160
integer width = 718
boolean bringtotop = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;this.redraw( 'MOLD GROUP')
end event

event selectionchanged;call super::selectionchanged;f_retrieve()
end event

type st_5 from so_statictext within w_mcn_mold_repair_master
integer x = 3310
integer y = 80
integer width = 645
integer height = 68
boolean bringtotop = true
string text = "Mold Group"
end type

type ddlb_mold_code from uo_mold_code within w_mcn_mold_repair_master
integer x = 1303
integer y = 160
integer width = 503
integer height = 760
integer taborder = 0
boolean bringtotop = true
end type

event modified;call super::modified;f_retrieve()
end event

type pb_cancel from so_commandbutton within w_mcn_mold_repair_master
integer x = 4133
integer y = 164
integer width = 443
integer height = 108
boolean bringtotop = true
string text = "Cancel"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return 

dw_2.object.repair_status[dw_2.getrow( )] = 'R'

msg = f_msgbox(1170)

if msg = 1 then 
	if dw_2.update( ) < 0 then 
		rollback ;
	else
		commit ;

	end if 
else
	f_retrieve()
end if 
end event

type ddlb_line_code from uo_line_code within w_mcn_mold_repair_master
integer x = 791
integer y = 160
integer width = 507
integer height = 1980
integer taborder = 50
boolean bringtotop = true
end type

type st_7 from so_statictext within w_mcn_mold_repair_master
integer x = 791
integer y = 96
integer width = 507
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type gb_2 from so_groupbox within w_mcn_mold_repair_master
integer x = 754
integer width = 3310
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from groupbox within w_mcn_mold_repair_master
integer x = 4082
integer width = 521
integer height = 300
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Process"
end type

type gb_3 from groupbox within w_mcn_mold_repair_master
integer width = 741
integer height = 300
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

type gb_4 from groupbox within w_mcn_mold_repair_master
integer x = 4617
integer width = 521
integer height = 300
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Repair Image"
end type


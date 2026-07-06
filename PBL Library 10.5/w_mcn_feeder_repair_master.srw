HA$PBExportHeader$w_mcn_feeder_repair_master.srw
$PBExportComments$Material Receipt Master
forward
global type w_mcn_feeder_repair_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mcn_feeder_repair_master
end type
type uo_dateend from uo_ymd_calendar within w_mcn_feeder_repair_master
end type
type st_4 from so_statictext within w_mcn_feeder_repair_master
end type
type cb_7 from so_commandbutton within w_mcn_feeder_repair_master
end type
type cb_9 from so_commandbutton within w_mcn_feeder_repair_master
end type
type rb_jig_list from so_radiobutton within w_mcn_feeder_repair_master
end type
type rb_jig_request from so_radiobutton within w_mcn_feeder_repair_master
end type
type ddlb_jig_repair_status from uo_basecode within w_mcn_feeder_repair_master
end type
type st_1 from so_statictext within w_mcn_feeder_repair_master
end type
type cb_process from so_commandbutton within w_mcn_feeder_repair_master
end type
type cb_complete from so_commandbutton within w_mcn_feeder_repair_master
end type
type sle_jig_lot_no from so_singlelineedit within w_mcn_feeder_repair_master
end type
type st_2 from so_statictext within w_mcn_feeder_repair_master
end type
type gb_2 from so_groupbox within w_mcn_feeder_repair_master
end type
type gb_1 from so_groupbox within w_mcn_feeder_repair_master
end type
type gb_3 from so_groupbox within w_mcn_feeder_repair_master
end type
type gb_4 from so_groupbox within w_mcn_feeder_repair_master
end type
end forward

global type w_mcn_feeder_repair_master from w_main_root
integer width = 4827
integer height = 3028
string title = "Feeder Repair Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_4 st_4
cb_7 cb_7
cb_9 cb_9
rb_jig_list rb_jig_list
rb_jig_request rb_jig_request
ddlb_jig_repair_status ddlb_jig_repair_status
st_1 st_1
cb_process cb_process
cb_complete cb_complete
sle_jig_lot_no sle_jig_lot_no
st_2 st_2
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
gb_4 gb_4
end type
global w_mcn_feeder_repair_master w_mcn_feeder_repair_master

on w_mcn_feeder_repair_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_4=create st_4
this.cb_7=create cb_7
this.cb_9=create cb_9
this.rb_jig_list=create rb_jig_list
this.rb_jig_request=create rb_jig_request
this.ddlb_jig_repair_status=create ddlb_jig_repair_status
this.st_1=create st_1
this.cb_process=create cb_process
this.cb_complete=create cb_complete
this.sle_jig_lot_no=create sle_jig_lot_no
this.st_2=create st_2
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.cb_7
this.Control[iCurrent+5]=this.cb_9
this.Control[iCurrent+6]=this.rb_jig_list
this.Control[iCurrent+7]=this.rb_jig_request
this.Control[iCurrent+8]=this.ddlb_jig_repair_status
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.cb_process
this.Control[iCurrent+11]=this.cb_complete
this.Control[iCurrent+12]=this.sle_jig_lot_no
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_3
this.Control[iCurrent+17]=this.gb_4
end on

on w_mcn_feeder_repair_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_4)
destroy(this.cb_7)
destroy(this.cb_9)
destroy(this.rb_jig_list)
destroy(this.rb_jig_request)
destroy(this.ddlb_jig_repair_status)
destroy(this.st_1)
destroy(this.cb_process)
destroy(this.cb_complete)
destroy(this.sle_jig_lot_no)
destroy(this.st_2)
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
Ivs_resize_type                      = 'MASTER_DETAIL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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
			
			if rb_jig_request.checked = true then 
				    dw_1.retrieve( '%', ddlb_jig_repair_status.getcode( )+'%' ,  'F' ,  sle_jig_lot_no.text+'%' ,  gvi_organization_id)
			elseif rb_jig_list.checked = true then 
				
				  dw_3.retrieve( 'F' , '%', uo_dateset.text() , uo_dateend.text() ,  gvi_organization_id)				
				  			
			end if 

    case 'INSERT'
		
			ROW = DW_2.INSERTROW(0)
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
			dw_2.object.repair_request_date[row] = f_t_sysdate()
			dw_2.object.repair_date[row] = f_t_sysdate()
			dw_2.object.repair_sequence[row] = f_get_sequence('SEQ_JIG_REPAIR_SEQUENCE')
			dw_2.object.repair_status[row] = 'R'
			dw_2.object.repair_reason_code[row] = 'R'			
			
              if dw_3.getrow() < 1 then 
		    else
			  DW_2.SETITEM( ROW , 'JIG_CODE' , dw_3.object.jig_code[dw_3.getrow()] )
			end if
			
	case 'APPEND'		
			
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
			dw_2.object.repair_request_date[row] = f_t_sysdate()
			dw_2.object.repair_date[row] = f_t_sysdate()			
			dw_2.object.repair_sequence[row] = f_get_sequence('SEQ_JIG_REPAIR_SEQUENCE')
			dw_2.object.repair_status[row] = 'R'
			dw_2.object.repair_reason_code[row] = 'R'	
			
              if dw_3.getrow() < 1 then 
		    else
			  DW_2.SETITEM( ROW , 'JIG_CODE' , dw_3.object.jig_code[dw_3.getrow()] )
			end if
			
	case 'DELETE'
		
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
			
   case 'UPDATE'
		
			IF DW_2.UPDATE() < 0  THEN
			  	 ROLLBACK;
				 RETURN
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"			 
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mcn_feeder_repair_master
integer y = 320
integer height = 160
end type

type dw_4 from w_main_root`dw_4 within w_mcn_feeder_repair_master
integer y = 320
integer height = 160
end type

type dw_3 from w_main_root`dw_3 within w_mcn_feeder_repair_master
integer y = 320
integer width = 4544
integer height = 1092
boolean titlebar = true
string title = "Jig Repair History"
string dataobject = "d_mcn_jig_repair_history"
end type

type dw_2 from w_main_root`dw_2 within w_mcn_feeder_repair_master
integer y = 1420
integer width = 4549
integer height = 824
boolean titlebar = true
string title = "Feeder Repair Change Request List"
string dataobject = "d_mcn_feeder_repair_lst"
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

if dwo.name = 'jig_code' then 
	open(w_mcn_jig_popup)	
	if  gst_return.gvb_return  = true then
	   this.object.jig_code[row] = message.stringparm
	   this.object.jig_lot_no[row] = gst_return.gvs_return[1] 	
	end if
end if 
end event

event dw_2::uo_mousemove;call super::uo_mousemove;if row < 1 then return

end event

type dw_1 from w_main_root`dw_1 within w_mcn_feeder_repair_master
integer y = 320
integer width = 4544
integer height = 1092
boolean titlebar = true
string title = "Feeder Repair Change Request List"
string dataobject = "d_mcn_feeder_repair_change_request_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

dw_2.retrieve( this.object.rowid[currentrow])
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_feeder_repair_master
end type

type uo_dateset from uo_ymd_calendar within w_mcn_feeder_repair_master
event destroy ( )
integer x = 1650
integer y = 160
integer width = 411
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mcn_feeder_repair_master
event destroy ( )
integer x = 2066
integer y = 160
integer width = 411
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_mcn_feeder_repair_master
integer x = 1655
integer y = 80
integer width = 809
integer height = 68
boolean bringtotop = true
string text = "Repair Request Date"
end type

type cb_7 from so_commandbutton within w_mcn_feeder_repair_master
boolean visible = false
integer x = 3986
integer y = 116
integer width = 443
integer height = 108
integer taborder = 30
boolean bringtotop = true
string text = "Image Upload"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return

int    li_filenum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   lib_file , b
double lvdb_version , lvdb_repair_sequence 
string is_filename, is_fullname , lvs_drawing_no , lvs_jig_code
		
		if  dw_2.getrow() < 1 then 
			 return
		end if
			
			lvs_jig_code  = dw_2.getitemstring( dw_2.getrow() , "jig_code" )
			lvdb_repair_sequence  = dw_2.getitemNumber( dw_2.getrow() , "repair_sequence" )	
	
		if lvs_jig_code ='' or isnull(lvs_jig_code) then 
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
						from imcn_jig_repair_image
						where jig_code    = :lvs_jig_code
						and repair_sequence = :lvdb_repair_sequence
						and organization_id = :gvi_organization_id ;
						  
					if f_sql_check() < 0 then 
						return
					end if				  
					
					if lvi_count = 0 then 
						
						insert into imcn_jig_repair_image ( jig_code , repair_sequence , organization_id ) 
						   values ( :lvs_jig_code , :lvdb_repair_sequence ,  :gvi_organization_id ) ;
								  
						if f_sql_check() < 0 then 
							return
						end if				  
										
					end if
						  
					updateblob imcn_jig_repair_image set repair_image = :lib_file 
					where jig_code       = :lvs_jig_code
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

type cb_9 from so_commandbutton within w_mcn_feeder_repair_master
boolean visible = false
integer x = 4430
integer y = 116
integer width = 443
integer height = 108
integer taborder = 40
boolean bringtotop = true
string text = "Image Delete"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return
string lvs_jig_code
double lvdb_repair_sequence
int lvi_count
				if  dw_2.getrow() < 1 then 
					 return
				end if
			
				lvs_jig_code  = dw_2.getitemstring( dw_2.getrow() , "jig_code" )
				lvdb_repair_sequence  = dw_2.getitemNumber( dw_2.getrow() , "repair_sequence" )	
				
				if lvs_jig_code ='' or isnull(lvs_jig_code) then 
					return
				end if		

							  
					delete  imcn_jig_repair_image 
					where jig_code  = :lvs_jig_code
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

type rb_jig_list from so_radiobutton within w_mcn_feeder_repair_master
integer x = 37
integer y = 172
integer width = 667
boolean bringtotop = true
integer weight = 700
string text = "Feeder Repair History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3

cb_process.enabled = false
cb_complete.enabled = false
end event

type rb_jig_request from so_radiobutton within w_mcn_feeder_repair_master
integer x = 37
integer y = 76
integer width = 727
boolean bringtotop = true
integer weight = 700
string text = "Feeder Request Wait List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1

cb_process.enabled = true 
cb_complete.enabled = true
end event

type ddlb_jig_repair_status from uo_basecode within w_mcn_feeder_repair_master
integer x = 2487
integer y = 160
integer width = 402
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'REPAIR STATUS')
end event

type st_1 from so_statictext within w_mcn_feeder_repair_master
integer x = 2491
integer y = 80
integer width = 398
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "Repair Status"
end type

type cb_process from so_commandbutton within w_mcn_feeder_repair_master
integer x = 3003
integer y = 116
integer width = 443
integer height = 108
integer taborder = 40
boolean bringtotop = true
string text = "Repair OK"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return 

dw_2.object.repair_status[dw_2.getrow( )] = 'P'

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

type cb_complete from so_commandbutton within w_mcn_feeder_repair_master
integer x = 3447
integer y = 116
integer width = 443
integer height = 108
integer taborder = 50
boolean bringtotop = true
string text = "Line Issue"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return 



dw_2.object.repair_status[dw_2.getrow( )] = 'C'

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

event constructor;call super::constructor;if Gvi_user_level < 8 then 
	
	this.enabled = false
else
	this.enabled = true
	
	
end if 
end event

type sle_jig_lot_no from so_singlelineedit within w_mcn_feeder_repair_master
integer x = 905
integer y = 160
integer width = 736
integer height = 84
integer taborder = 40
boolean bringtotop = true
end type

event modified;call super::modified;f_retrieve()
end event

type st_2 from so_statictext within w_mcn_feeder_repair_master
integer x = 905
integer y = 84
integer width = 736
integer height = 68
boolean bringtotop = true
string text = "Feeder Lot No"
end type

type gb_2 from so_groupbox within w_mcn_feeder_repair_master
integer x = 873
integer width = 2057
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_mcn_feeder_repair_master
integer x = 2944
integer y = 4
integer width = 987
integer height = 296
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Bad Feeder Manage"
end type

type gb_3 from so_groupbox within w_mcn_feeder_repair_master
integer width = 841
integer height = 300
integer taborder = 20
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

type gb_4 from so_groupbox within w_mcn_feeder_repair_master
boolean visible = false
integer x = 3945
integer y = 4
integer width = 946
integer height = 296
integer taborder = 30
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


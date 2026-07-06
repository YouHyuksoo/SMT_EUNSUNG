HA$PBExportHeader$w_qc_eco_notify_master.srw
$PBExportComments$$$HEX7$$acc7e0ac200040d629b500adacb9$$ENDHEX$$
forward
global type w_qc_eco_notify_master from w_main_root
end type
type rb_all from so_radiobutton within w_qc_eco_notify_master
end type
type rb_hold from so_radiobutton within w_qc_eco_notify_master
end type
type cb_1 from so_commandbutton within w_qc_eco_notify_master
end type
type cb_2 from so_commandbutton within w_qc_eco_notify_master
end type
type uo_item from uo_item_code within w_qc_eco_notify_master
end type
type st_5 from so_statictext within w_qc_eco_notify_master
end type
type rb_all_hold from so_radiobutton within w_qc_eco_notify_master
end type
type rb_lot_hold from so_radiobutton within w_qc_eco_notify_master
end type
type cb_7 from so_commandbutton within w_qc_eco_notify_master
end type
type cb_9 from so_commandbutton within w_qc_eco_notify_master
end type
type cb_3 from so_commandbutton within w_qc_eco_notify_master
end type
type cb_4 from so_commandbutton within w_qc_eco_notify_master
end type
type gb_1 from so_groupbox within w_qc_eco_notify_master
end type
type gb_2 from so_groupbox within w_qc_eco_notify_master
end type
type gb_3 from so_groupbox within w_qc_eco_notify_master
end type
type gb_4 from groupbox within w_qc_eco_notify_master
end type
end forward

global type w_qc_eco_notify_master from w_main_root
integer width = 5737
integer height = 2840
string title = "ECO Notify Master"
string ivs_dw_4_use_focusindicator = "Y"
rb_all rb_all
rb_hold rb_hold
cb_1 cb_1
cb_2 cb_2
uo_item uo_item
st_5 st_5
rb_all_hold rb_all_hold
rb_lot_hold rb_lot_hold
cb_7 cb_7
cb_9 cb_9
cb_3 cb_3
cb_4 cb_4
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_qc_eco_notify_master w_qc_eco_notify_master

type variables
string lvs_current_array_type
end variables

on w_qc_eco_notify_master.create
int iCurrent
call super::create
this.rb_all=create rb_all
this.rb_hold=create rb_hold
this.cb_1=create cb_1
this.cb_2=create cb_2
this.uo_item=create uo_item
this.st_5=create st_5
this.rb_all_hold=create rb_all_hold
this.rb_lot_hold=create rb_lot_hold
this.cb_7=create cb_7
this.cb_9=create cb_9
this.cb_3=create cb_3
this.cb_4=create cb_4
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_all
this.Control[iCurrent+2]=this.rb_hold
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.uo_item
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.rb_all_hold
this.Control[iCurrent+8]=this.rb_lot_hold
this.Control[iCurrent+9]=this.cb_7
this.Control[iCurrent+10]=this.cb_9
this.Control[iCurrent+11]=this.cb_3
this.Control[iCurrent+12]=this.cb_4
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.gb_3
this.Control[iCurrent+16]=this.gb_4
end on

on w_qc_eco_notify_master.destroy
call super::destroy
destroy(this.rb_all)
destroy(this.rb_hold)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.uo_item)
destroy(this.st_5)
destroy(this.rb_all_hold)
destroy(this.rb_lot_hold)
destroy(this.cb_7)
destroy(this.cb_9)
destroy(this.cb_3)
destroy(this.cb_4)
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
Gst_set.Report_window    = True  // Report Window  True / Flase

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
* Menu Property 
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('DATA_CONTROL' ,TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			if rb_all_hold.checked = true then 
				dw_1.reset()
				dw_1.retrieve( uo_item.text()+'%' ,  gvi_organization_id )	
			else
				dw_2.reset()
				dw_2.retrieve( uo_item.text()+'%' ,  gvi_organization_id )					
				
			end if 
	case 'UPDATE'
		
			if dw_1.update()	 < 0 OR DW_2.UPDATE() < 0  then 
				rollback;
			else
				commit ;
			end if 
			f_msg_st(170)
		
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_qc_eco_notify_master
integer y = 344
integer width = 4242
integer height = 1504
integer taborder = 0
boolean titlebar = true
string title = "Packing Summary"
boolean maxbox = false
end type

type dw_4 from w_main_root`dw_4 within w_qc_eco_notify_master
integer y = 344
integer width = 4242
integer height = 1504
integer taborder = 0
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_qc_eco_notify_master
integer y = 344
integer width = 4242
integer height = 1504
integer taborder = 0
boolean titlebar = true
boolean maxbox = false
boolean border = false
end type

type dw_2 from w_main_root`dw_2 within w_qc_eco_notify_master
integer y = 344
integer width = 4242
integer height = 1504
integer taborder = 0
boolean titlebar = true
string dataobject = "d_qc_eco_notify_hist"
end type

event dw_2::updateend;//override
end event

event dw_2::updatestart;//override
end event

type dw_1 from w_main_root`dw_1 within w_qc_eco_notify_master
integer y = 344
integer width = 4242
integer height = 1504
integer taborder = 0
boolean titlebar = true
string dataobject = "d_qc_eco_notify_lst"
end type

event dw_1::itemchanged;//override
end event

type uo_tabpages from w_main_root`uo_tabpages within w_qc_eco_notify_master
integer taborder = 0
end type

type rb_all from so_radiobutton within w_qc_eco_notify_master
integer x = 2235
integer y = 136
integer width = 334
integer height = 72
boolean bringtotop = true
long textcolor = 0
string text = "All"
boolean checked = true
end type

event clicked;dw_1.SETFILTER('')
dw_1.FILTER()

end event

type rb_hold from so_radiobutton within w_qc_eco_notify_master
integer x = 2578
integer y = 136
integer width = 357
integer height = 72
boolean bringtotop = true
long textcolor = 0
string text = "Check"
end type

event clicked;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================

dw_1.SETFILTER('')
dw_1.FILTER()

dw_1.SETFILTER( 'ECO_CHECK_YN  LIKE '+"'"+"Y%"+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found")
end event

type cb_1 from so_commandbutton within w_qc_eco_notify_master
integer x = 1600
integer y = 60
integer height = 112
integer taborder = 40
boolean bringtotop = true
string text = "Check"
end type

event clicked;call super::clicked;long i


if rb_all_hold.checked = true then 

		if dw_1.rowcount( ) < 1 then return 
		
		DO
			I++
			
			if dw_1.object.check_yn[i] = 'Y' then 
				
				dw_1.object.ECO_CHECK_YN[i] = 'Y' 
			//	dw_1.object.ECO_CHECK_COMMENTS[i] = 'QC Checked'
			else
				continue
			end if 
			
		LOOP UNTIL I = DW_1.ROWcount( )
		
		f_update()
		
else
		if dw_2.rowcount( ) < 1 then return 
		
		DO
			I++
			
			if dw_2.object.check_yn[i] = 'Y' then 
				
				dw_2.object.inventory_hold[i] = 'Y' 
			//	dw_2.object.ECO_CHECK_COMMENTS[i] = 'QC Checked'
			else
				continue
			end if 
			
		LOOP UNTIL I = dw_2.ROWcount( )
		
		f_update()	
	
end if 
end event

type cb_2 from so_commandbutton within w_qc_eco_notify_master
integer x = 1600
integer y = 168
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer weight = 400
string text = "Release"
end type

event clicked;call super::clicked;long i


if rb_all_hold.checked = true then 

	if dw_1.rowcount( ) < 1 then return 
	
	DO
		I++
		
		if dw_1.object.check_yn[i] = 'Y' then 
			
			dw_1.object.ECO_CHECK_YN[i] = 'N' 
		//	dw_1.object.ECO_CHECK_COMMENTS[i] = 'QC Release'
		else
			continue
		end if 
		
	LOOP UNTIL I = DW_1.ROWcount( )
	
	f_update()
//===============================================
//
//===============================================

else
	
	if dw_2.rowcount( ) < 1 then return 
	
	DO
		I++
		
		if dw_2.object.check_yn[i] = 'Y' then 
			
			dw_2.object.ECO_CHECK_YN[i] = 'W' 
//			dw_2.object.comments[i] = 'QC Release'
		else
			continue
		end if 
		
	LOOP UNTIL I = dw_2.ROWcount( )
	
	f_update()	
end if 
end event

type uo_item from uo_item_code within w_qc_eco_notify_master
integer x = 878
integer y = 176
integer width = 640
integer height = 1888
integer taborder = 40
boolean bringtotop = true
end type

type st_5 from so_statictext within w_qc_eco_notify_master
integer x = 878
integer y = 100
integer width = 640
integer height = 56
boolean bringtotop = true
boolean enabled = false
string text = "Item Code"
end type

type rb_all_hold from so_radiobutton within w_qc_eco_notify_master
integer x = 82
integer y = 76
integer width = 375
integer height = 72
boolean bringtotop = true
long textcolor = 0
string text = "Item List"
boolean checked = true
end type

event clicked;dw_1.bringtotop = true
selected_data_window = dw_1

end event

type rb_lot_hold from so_radiobutton within w_qc_eco_notify_master
integer x = 82
integer y = 184
integer width = 357
integer height = 72
boolean bringtotop = true
long textcolor = 0
string text = "Checked List"
end type

event clicked;dw_2.bringtotop = true
selected_data_window = dw_2

end event

type cb_7 from so_commandbutton within w_qc_eco_notify_master
integer x = 3026
integer y = 60
integer width = 443
integer height = 124
integer taborder = 50
boolean bringtotop = true
string text = "File Upload"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return

int    li_filenum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   lib_file , b
double lvdb_version , lvdb_repair_sequence 
string is_filename, is_fullname , lvs_drawing_no , lvs_item_code
		
		if  selected_data_window.getrow() < 1 then 
			 return
		end if
			
			lvs_item_code  = selected_data_window.getitemstring( selected_data_window.getrow() , "item_code" )

		if lvs_item_code ='' or isnull(lvs_item_code) then 
			return
		end if		
		
		if getfileopenname("select file", is_fullname, is_filename, "jpg", &
			 + "jpg files (*.jpg),*.jpg," &	
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
				 	  from id_item_image
					where item_code    = :lvs_item_code
						and organization_id = :gvi_organization_id ;
						  
					if f_sql_check() < 0 then 
						return
					end if				  
					
					if lvi_count = 0 then 
						
						insert into id_item_image ( item_code , organization_id  ) 
						   values ( :lvs_item_code ,  :gvi_organization_id) ;
								  
						if f_sql_check() < 0 then 
							return
						end if				  
					end if
						  
					updateblob id_item_image 
					    set eco_check_image = :lib_file 
					where item_code       = :lvs_item_code
					  and organization_id = :gvi_organization_id ;

				  if sqlca.sqlnrows > 0 then

				  else
					  rollback ;
					  messagebox("error" , is_filename+f_msg(" file upload to database failed",'S') )
					  return
				  end if;
			  
				  commit ;
			         f_msgbox(9022)

		end if
changedirectory(gvs_default_directory)

end event

type cb_9 from so_commandbutton within w_qc_eco_notify_master
integer x = 3026
integer y = 180
integer width = 443
integer height = 132
integer taborder = 60
boolean bringtotop = true
string text = "File Delete"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return
string lvs_item_code
blob lvb_null

setnull(lvb_null)

      int lvi_count
				if  selected_data_window.getrow() < 1 then 
					 return
				end if
			
				lvs_item_code  = selected_data_window.getitemstring( selected_data_window.getrow() , "item_code" )
				
				if lvs_item_code ='' or isnull(lvs_item_code) then 
					return
				end if		

						  
				    update  id_item_image  set eco_check_image = :lvb_null
					where item_code  = :lvs_item_code
					  and organization_id   = :gvi_organization_id ;

					if f_sql_check() < 0 then 
						return 
					else
						commit ;
						f_msgbox(9022)
					end if 
changedirectory(gvs_default_directory)

end event

type cb_3 from so_commandbutton within w_qc_eco_notify_master
integer x = 3479
integer y = 60
integer width = 443
integer height = 124
integer taborder = 70
boolean bringtotop = true
string text = "File View"
end type

event clicked;call super::clicked;		Long Lvl_return
		String  lvs_file_name
		
		if selected_data_window.getrow() < 1 then return 
		
		lvs_file_name = f_download_eco_rtn_filename ( string(selected_data_window.object.item_code[selected_data_window.getrow()] )  )
		
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			else
			
				f_shell_execute_by_extention ( lvs_file_name   , '' ,Gvs_default_directory+'\Temp'  )

			end if
		
		Changedirectory(Gvs_default_directory)

end event

type cb_4 from so_commandbutton within w_qc_eco_notify_master
integer x = 3479
integer y = 180
integer width = 443
integer height = 132
integer taborder = 80
boolean bringtotop = true
string text = "Preview"
end type

event clicked;call super::clicked;string lvs_item_code ,  lvs_eco_check_comments 

if selected_data_window.getrow() < 1 then return 

lvs_eco_check_comments = selected_data_window.object.eco_check_comments[selected_data_window.getrow()]

lvs_item_code = selected_data_window.object.item_code[selected_data_window.getrow()]

Gst_return.gvs_return[1] = lvs_eco_check_comments
openwithparm(w_item_eco_notify_image_popup , lvs_item_code ) 

end event

type gb_1 from so_groupbox within w_qc_eco_notify_master
integer x = 837
integer width = 704
integer height = 328
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_qc_eco_notify_master
integer x = 14
integer width = 823
integer height = 324
integer taborder = 30
end type

type gb_3 from so_groupbox within w_qc_eco_notify_master
integer x = 2153
integer width = 823
integer height = 324
integer taborder = 10
end type

type gb_4 from groupbox within w_qc_eco_notify_master
integer x = 2985
integer y = 4
integer width = 987
integer height = 324
integer taborder = 50
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


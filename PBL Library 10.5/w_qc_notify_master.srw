HA$PBExportHeader$w_qc_notify_master.srw
$PBExportComments$Line Master
forward
global type w_qc_notify_master from w_main_root
end type
type st_line_code from statictext within w_qc_notify_master
end type
type ddlb_line_code from uo_line_code within w_qc_notify_master
end type
type uo_dateset from uo_ymd_calendar within w_qc_notify_master
end type
type st_4 from so_statictext within w_qc_notify_master
end type
type uo_dateend from uo_ymd_calendar within w_qc_notify_master
end type
type ddlb_item_code from uo_item_code within w_qc_notify_master
end type
type st_3 from so_statictext within w_qc_notify_master
end type
type ddlb_workstage_code from uo_workstage_code_all within w_qc_notify_master
end type
type st_1 from so_statictext within w_qc_notify_master
end type
type sle_material_maker from so_singlelineedit within w_qc_notify_master
end type
type st_5 from so_statictext within w_qc_notify_master
end type
type ddlb_machine_code from uo_machine_code within w_qc_notify_master
end type
type st_2 from so_statictext within w_qc_notify_master
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_qc_notify_master
end type
type st_6 from so_statictext within w_qc_notify_master
end type
type sle_key_word from so_singlelineedit within w_qc_notify_master
end type
type st_7 from so_statictext within w_qc_notify_master
end type
type rb_doc1 from radiobutton within w_qc_notify_master
end type
type rb_doc2 from radiobutton within w_qc_notify_master
end type
type gb_1 from so_groupbox within w_qc_notify_master
end type
type gb_2 from so_groupbox within w_qc_notify_master
end type
type cb_7 from so_commandbutton within w_qc_notify_master
end type
type cb_9 from so_commandbutton within w_qc_notify_master
end type
type rb_list from so_radiobutton within w_qc_notify_master
end type
type cb_preview from so_commandbutton within w_qc_notify_master
end type
type cb_print from so_commandbutton within w_qc_notify_master
end type
type rb_doc3 from radiobutton within w_qc_notify_master
end type
type gb_3 from so_groupbox within w_qc_notify_master
end type
type gb_4 from so_groupbox within w_qc_notify_master
end type
end forward

global type w_qc_notify_master from w_main_root
integer width = 5966
integer height = 2904
string title = "QC Notify Master"
windowstate windowstate = maximized!
st_line_code st_line_code
ddlb_line_code ddlb_line_code
uo_dateset uo_dateset
st_4 st_4
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
ddlb_workstage_code ddlb_workstage_code
st_1 st_1
sle_material_maker sle_material_maker
st_5 st_5
ddlb_machine_code ddlb_machine_code
st_2 st_2
ddlb_model_name ddlb_model_name
st_6 st_6
sle_key_word sle_key_word
st_7 st_7
rb_doc1 rb_doc1
rb_doc2 rb_doc2
gb_1 gb_1
gb_2 gb_2
cb_7 cb_7
cb_9 cb_9
rb_list rb_list
cb_preview cb_preview
cb_print cb_print
rb_doc3 rb_doc3
gb_3 gb_3
gb_4 gb_4
end type
global w_qc_notify_master w_qc_notify_master

type variables
string ivs_preview_yn
end variables

on w_qc_notify_master.create
int iCurrent
call super::create
this.st_line_code=create st_line_code
this.ddlb_line_code=create ddlb_line_code
this.uo_dateset=create uo_dateset
this.st_4=create st_4
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_1=create st_1
this.sle_material_maker=create sle_material_maker
this.st_5=create st_5
this.ddlb_machine_code=create ddlb_machine_code
this.st_2=create st_2
this.ddlb_model_name=create ddlb_model_name
this.st_6=create st_6
this.sle_key_word=create sle_key_word
this.st_7=create st_7
this.rb_doc1=create rb_doc1
this.rb_doc2=create rb_doc2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.cb_7=create cb_7
this.cb_9=create cb_9
this.rb_list=create rb_list
this.cb_preview=create cb_preview
this.cb_print=create cb_print
this.rb_doc3=create rb_doc3
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_line_code
this.Control[iCurrent+2]=this.ddlb_line_code
this.Control[iCurrent+3]=this.uo_dateset
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.uo_dateend
this.Control[iCurrent+6]=this.ddlb_item_code
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.ddlb_workstage_code
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.sle_material_maker
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.ddlb_machine_code
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.ddlb_model_name
this.Control[iCurrent+15]=this.st_6
this.Control[iCurrent+16]=this.sle_key_word
this.Control[iCurrent+17]=this.st_7
this.Control[iCurrent+18]=this.rb_doc1
this.Control[iCurrent+19]=this.rb_doc2
this.Control[iCurrent+20]=this.gb_1
this.Control[iCurrent+21]=this.gb_2
this.Control[iCurrent+22]=this.cb_7
this.Control[iCurrent+23]=this.cb_9
this.Control[iCurrent+24]=this.rb_list
this.Control[iCurrent+25]=this.cb_preview
this.Control[iCurrent+26]=this.cb_print
this.Control[iCurrent+27]=this.rb_doc3
this.Control[iCurrent+28]=this.gb_3
this.Control[iCurrent+29]=this.gb_4
end on

on w_qc_notify_master.destroy
call super::destroy
destroy(this.st_line_code)
destroy(this.ddlb_line_code)
destroy(this.uo_dateset)
destroy(this.st_4)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.ddlb_workstage_code)
destroy(this.st_1)
destroy(this.sle_material_maker)
destroy(this.st_5)
destroy(this.ddlb_machine_code)
destroy(this.st_2)
destroy(this.ddlb_model_name)
destroy(this.st_6)
destroy(this.sle_key_word)
destroy(this.st_7)
destroy(this.rb_doc1)
destroy(this.rb_doc2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.cb_7)
destroy(this.cb_9)
destroy(this.rb_list)
destroy(this.cb_preview)
destroy(this.cb_print)
destroy(this.rb_doc3)
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

dw_2.sharedata( dw_1)
end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			
			
			if rb_list.checked = true then 
			
					DW_1.reset()
					DW_2.reset()
					DW_1.retrieve( ddlb_model_name.getcode()+'%' ,   ddlb_line_code.getcode() + '%', ddlb_workstage_code.getcode( )+'%' , ddlb_item_code.text+'%' ,  uo_dateset.text() , uo_dateend.text() , sle_material_maker.text+'%' ,  ddlb_machine_code.getcode()+'%' ,   '%'+sle_key_word.text+'%' , gvi_organization_id)
					DW_1.setfocus()
			else
					
					
					
			end if 
	case 'INSERT'		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')				
			
			DW_2.setitem(ROW , 'action_date' , f_sysdate())
			DW_2.object.notify_sequence[row]  = f_get_sequence('SEQ_QC_NOTIFY_SEQUENCE')
			DW_2.object.inspect_bad_qty[row]  = 0
			DW_2.object.inspect_qty[row]  = 0
	         DW_2.object.material_maker[row]  = '*'
			DW_2.object.machine_code[row]  = '*'	
			DW_2.object.item_code[row]  = '*'	
			DW_2.object.location_info[row]  = '*'	
			DW_2.object.run_no[row]  = '*'	
			DW_2.object.bad_reason_code[row]  = '*'	
			DW_2.object.detect_location[row]  = '*'	
			
				
	case 'APPEND'		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(0)
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')				
			
					DW_2.setitem(ROW , 'action_date' , f_sysdate())
			DW_2.object.notify_sequence[row]  = f_get_sequence('SEQ_QC_NOTIFY_SEQUENCE')
			DW_2.object.inspect_bad_qty[row]  = 0
			DW_2.object.inspect_qty[row]  = 0
	         DW_2.object.material_maker[row]  = '*'
			DW_2.object.machine_code[row]  = '*'	
			DW_2.object.item_code[row]  = '*'	
			DW_2.object.location_info[row]  = '*'	
			DW_2.object.run_no[row]  = '*'	
			DW_2.object.bad_reason_code[row]  = '*'	
			DW_2.object.detect_location[row]  = '*'	
			
	case 'DELETE'
		
		  	if DW_2.getrow() < 1 then return 
			  
			msg =f_msgbox(1003)
			if msg = 1 then
				gvl_row_deleted = DW_2.getrow()			
				DW_2.deleterow(gvl_row_deleted)		
				DW_2.setfocus()
				row = DW_2.getrow()
				DW_2.scrolltorow(row)
				DW_2.setcolumn(1)
			end if
			
	case 'UPDATE'
		
			if   DW_1.update() < 0  or DW_2.update() < 0 then
				rollback;
			else
				commit;
				f_msg_mdi_help(f_msg_st(170))
			end if
			
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_qc_notify_master
integer y = 536
end type

type dw_4 from w_main_root`dw_4 within w_qc_notify_master
integer y = 536
end type

type dw_3 from w_main_root`dw_3 within w_qc_notify_master
integer y = 536
integer width = 5074
integer height = 992
boolean titlebar = true
string dataobject = "d_qc_notify_rpt"
end type

event dw_3::rowfocuschanged;call super::rowfocuschanged;string lvs_filename , lvs_filename1 , lvs_filename2 , lvs_filename3

if currentrow < 1 then return

lvs_filename1 = f_download_QC_NOTIFY_rtn_multi_filename( this.object.action_date[this.getrow()]  , long(this.object.notify_sequence[this.getrow()] ) , 1 )
lvs_filename2 = f_download_QC_NOTIFY_rtn_multi_filename(this.object.action_date[this.getrow()] , long(this.object.notify_sequence[this.getrow()] )  ,2  )
lvs_filename3 = f_download_QC_NOTIFY_rtn_multi_filename(this.object.action_date[this.getrow()] , long(this.object.notify_sequence[this.getrow()] ) , 3 )

this.object.p_image1.filename = lvs_filename1
this.object.p_image2.filename = lvs_filename2
this.object.p_image3.filename = lvs_filename3
end event

type dw_2 from w_main_root`dw_2 within w_qc_notify_master
integer y = 1528
integer width = 5074
integer height = 1256
boolean titlebar = true
string dataobject = "d_qc_notify_mst"
boolean controlmenu = true
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_qc_notify_master
integer y = 536
integer width = 5070
integer height = 984
boolean titlebar = true
string title = "Notify Master"
string dataobject = "d_qc_notify_lst"
end type

event dw_1::rbuttondown;call super::rbuttondown;if dwo.name = 'item_code' then 
	open(w_des_set_item_popup)
	if 	GST_RETURN.GVB_RETURN = TRUE then 
		this.object.item_code[row] = message.stringparm
	else
	end if 
end if 
end event

event dw_1::buttonclicked;call super::buttonclicked;IF dwo.name = 'b_show' then 
			
		if dw_1.getrow() < 1 then 
			return
		end if
		
		Long Lvl_return
		String  lvs_file_name
		
		
		if rb_doc1.checked = true then 
		
			Lvl_return = f_download_qc_ng_image_data ( dw_1.object.action_date[dw_1.getrow()] , long(dw_1.object.notify_sequence[dw_1.getrow()] ) )
		elseif rb_doc2.checked = true then 
		
			Lvl_return = f_download_qc_inspect_data ( dw_1.object.action_date[dw_1.getrow()] , long(dw_1.object.notify_sequence[dw_1.getrow()] ) )
		elseif rb_doc3.checked = true then 
			
			Lvl_return = f_download_qc_document_data ( dw_1.object.action_date[dw_1.getrow()] , long(dw_1.object.notify_sequence[dw_1.getrow()] ) )
			
		end if 
		
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

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow <  1 then return 
dw_2.retrieve( this.object.rowid[currentrow])
dw_2.accepttext()
end event

type uo_tabpages from w_main_root`uo_tabpages within w_qc_notify_master
end type

type st_line_code from statictext within w_qc_notify_master
integer x = 704
integer y = 100
integer width = 466
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_line_code from uo_line_code within w_qc_notify_master
integer x = 704
integer y = 180
integer width = 466
integer taborder = 20
boolean bringtotop = true
end type

type uo_dateset from uo_ymd_calendar within w_qc_notify_master
event destroy ( )
integer x = 3310
integer y = 172
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_qc_notify_master
integer x = 3314
integer y = 92
integer width = 827
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Action Date"
end type

type uo_dateend from uo_ymd_calendar within w_qc_notify_master
event destroy ( )
integer x = 3726
integer y = 172
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_qc_notify_master
integer x = 1783
integer y = 176
integer width = 526
integer taborder = 30
boolean bringtotop = true
end type

type st_3 from so_statictext within w_qc_notify_master
integer x = 1783
integer y = 96
integer width = 526
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_workstage_code from uo_workstage_code_all within w_qc_notify_master
integer x = 2318
integer y = 176
integer width = 521
integer height = 1484
integer taborder = 40
boolean bringtotop = true
end type

type st_1 from so_statictext within w_qc_notify_master
integer x = 2318
integer y = 100
integer width = 521
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type sle_material_maker from so_singlelineedit within w_qc_notify_master
integer x = 4151
integer y = 172
integer width = 393
integer height = 84
integer taborder = 150
boolean bringtotop = true
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN
DATAWINDOW ivs_dw

ivs_dw = dw_1
ivs_dw.SETFILTER('')
ivs_dw.FILTER()

LVS_COLUMN = 'SERIAL_NO'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    ivs_dw.SETFILTER('')
    ivs_dw.FILTER()	
    RETURN
ELSE
	
	LVS_VALUE = '%'+f_replace_string(this.text , '%' , '')+'%'
END IF

ivs_dw.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
ivs_dw.FILTER()
F_MSG_MDI_HELP( STRING( ivs_dw.ROWCOUNT() ) + " Found" )
end event

type st_5 from so_statictext within w_qc_notify_master
integer x = 4151
integer y = 100
integer width = 393
integer height = 60
boolean bringtotop = true
string text = "Material Maker"
end type

type ddlb_machine_code from uo_machine_code within w_qc_notify_master
integer x = 2848
integer y = 176
integer width = 453
integer height = 2036
integer taborder = 50
boolean bringtotop = true
end type

type st_2 from so_statictext within w_qc_notify_master
integer x = 2853
integer y = 100
integer width = 434
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Machine Code"
end type

type ddlb_model_name from uo_set_model_name_ddlb within w_qc_notify_master
integer x = 1175
integer y = 176
integer width = 599
integer height = 2252
integer taborder = 150
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
boolean hscrollbar = false
end type

type st_6 from so_statictext within w_qc_notify_master
integer x = 1179
integer y = 88
integer width = 599
integer height = 72
boolean bringtotop = true
string text = "Model Name"
end type

type sle_key_word from so_singlelineedit within w_qc_notify_master
integer x = 4553
integer y = 172
integer width = 402
integer height = 84
integer taborder = 70
boolean bringtotop = true
end type

type st_7 from so_statictext within w_qc_notify_master
integer x = 4558
integer y = 96
integer width = 389
integer height = 60
boolean bringtotop = true
long textcolor = 16711680
string text = "Key Word"
end type

type rb_doc1 from radiobutton within w_qc_notify_master
integer x = 78
integer y = 404
integer width = 224
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "1"
boolean checked = true
end type

type rb_doc2 from radiobutton within w_qc_notify_master
integer x = 329
integer y = 404
integer width = 224
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "2"
end type

type gb_1 from so_groupbox within w_qc_notify_master
integer x = 645
integer width = 4352
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_qc_notify_master
integer y = 4
integer width = 635
integer height = 292
integer taborder = 30
string text = "Category"
end type

type cb_7 from so_commandbutton within w_qc_notify_master
integer x = 1193
integer y = 384
integer width = 453
integer height = 108
integer taborder = 30
boolean bringtotop = true
string text = "Image Upload"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return

int    li_filenum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   lib_file , b
double lvdb_sequence
string is_filename, is_fullname  
datetime lvdt_action_date

if  dw_1.getrow() < 1 then 
	return
end if

lvdt_action_date  = dw_1.object.action_date[dw_1.getrow()]
lvdb_sequence= dw_1.object.notify_sequence[dw_1.getrow()]

if  isnull(lvdt_action_date) then 
return
end if		

if getfileopenname("select file", is_fullname, is_filename, "ppt", &
+ "ppt files (*.ppt),*.ppt," &	
+ "xls files (*.xls),*.xls," &
+ "doc files (*.doc),*.doc," &			 
+ "bmp files (*.bmp),*.bmp," &			
+ "jpg files (*.bmp),*.jpg," &	
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

if rb_doc1.checked  = true then

		update IQ_DAILY_NOTIFY 
		set ng_image_file_name = :is_filename 
		where action_date       = :lvdt_action_date
		and notify_sequence = :lvdb_sequence
		and organization_id = :gvi_organization_id ;
		
		if f_sql_check() < 0 then 
			return
		end if 
		
		updateblob IQ_DAILY_NOTIFY set ng_image = :lib_file 
		where action_date       = :lvdt_action_date
		and notify_sequence    = :lvdb_sequence
		and organization_id = :gvi_organization_id ;
		if f_sql_check() < 0 then 
			return
		end if 		
		
elseif rb_doc2.checked  = true then

		update IQ_DAILY_NOTIFY 
		set inspect_IMAGE_file_name = :is_filename 
		where action_date       = :lvdt_action_date
		and notify_sequence = :lvdb_sequence
		and organization_id = :gvi_organization_id ;
		
		if f_sql_check() < 0 then 
			return
		end if 
		
		updateblob IQ_DAILY_NOTIFY set inspect_image = :lib_file 
		where action_date       = :lvdt_action_date
		and notify_sequence = :lvdb_sequence
		and organization_id = :gvi_organization_id ;
		if f_sql_check() < 0 then 
			return
		end if 
elseif rb_doc3.checked  = true then

		update IQ_DAILY_NOTIFY 
		set DOCUMENT_IMAGE_file_name = :is_filename 
		where action_date       = :lvdt_action_date
		and notify_sequence = :lvdb_sequence
		and organization_id = :gvi_organization_id ;
		
		if f_sql_check() < 0 then 
			return
		end if 
		
		updateblob IQ_DAILY_NOTIFY set document_image = :lib_file 
		where action_date       = :lvdt_action_date
		and notify_sequence = :lvdb_sequence
		and organization_id = :gvi_organization_id ;	
		if f_sql_check() < 0 then 
			return
		end if 
end if

//	if sqlca.sqlnrows > 0 then
//	
//	else
//		rollback ;
//		messagebox("error" , is_filename+" file upload to database failed "+sqlca.sqlerrtext )
//		return
//	end if;

	commit ;
	f_msgbox(9022)

end if
changedirectory(gvs_default_directory)
end event

type cb_9 from so_commandbutton within w_qc_notify_master
integer x = 1650
integer y = 384
integer width = 453
integer height = 108
integer taborder = 40
boolean bringtotop = true
string text = "Image Delete"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return
string lvs_jig_code
blob lblob_null
datetime lvdt_action_date
double lvdb_sequence

setnull(lblob_null)

lblob_null = blob(' ')

int lvi_count
				if  dw_1.getrow() < 1 then 
					 return
				end if
			
					lvdt_action_date  = dw_1.object.action_date[dw_1.getrow()]
	  				lvdb_sequence= dw_1.object.notify_sequence[dw_1.getrow()]
				
				if rb_doc2.checked = true then
					
					updateblob IQ_DAILY_NOTIFY 
					           set inspect_image = :lblob_null
				           where action_date       = :lvdt_action_date
							 and notify_sequence = :lvdb_sequence
					          and organization_id = :gvi_organization_id ;
								 
				elseif rb_doc3.checked = true then
					updateblob IQ_DAILY_NOTIFY set DOCUMENT_IMAGE = :lblob_null
				           where action_date       = :lvdt_action_date
							 and notify_sequence = :lvdb_sequence
					          and organization_id = :gvi_organization_id ;
				end if

					if f_sql_check() < 0 then 
						return 
					else
						commit ;
						f_msgbox(164)
					end if 
changedirectory(gvs_default_directory)

end event

type rb_list from so_radiobutton within w_qc_notify_master
integer x = 69
integer y = 132
boolean bringtotop = true
string text = "QC Notify List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type cb_preview from so_commandbutton within w_qc_notify_master
integer x = 2203
integer y = 388
integer width = 471
integer height = 108
integer taborder = 110
boolean bringtotop = true
string text = "Preview"
end type

event clicked;call super::clicked;if dw_1.getrow( ) < 1 then return 
//===================================
//
//===================================
	
	if  ivs_preview_yn = 'Y' THEN 
		ivs_preview_yn = 'N' 	
		if rb_list.checked = true then 
			dw_1.bringtotop = TRUE
		else
			dw_3.bringtotop = TRUE			
		end if 
	else
			ivs_preview_yn = 'Y' 	
			dw_3.bringtotop = TRUE	
			
			dw_3.retrieve( dw_1.object.rowid[dw_1.getrow()])
			
			if dw_3.getrow( ) <  1 then 
			else
			
				if dw_3.Describe("DataWindow.Print.Preview") = '!' or dw_3.Describe("DataWindow.Print.Preview") = '?' then
				else
					dw_3.Modify("DataWindow.Print.Preview=yes")
					dw_3.Modify("DataWindow.Print.Preview.Rulers=yes")
				end if		
				
			end if 
	end if

end event

type cb_print from so_commandbutton within w_qc_notify_master
integer x = 2674
integer y = 388
integer width = 471
integer height = 108
integer taborder = 120
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;Int		i, lvi_cnt , rows

if dw_3.getrow( ) < 1 then
   cb_preview.triggerevent( clicked!)
else
end if 

if dw_3.getrow( ) < 1 then return
   dw_3.print(false, False)						

end event

type rb_doc3 from radiobutton within w_qc_notify_master
integer x = 599
integer y = 404
integer width = 224
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "3"
end type

type gb_3 from so_groupbox within w_qc_notify_master
integer x = 2144
integer y = 300
integer width = 1074
integer height = 224
integer taborder = 40
end type

type gb_4 from so_groupbox within w_qc_notify_master
integer x = 5
integer y = 304
integer width = 2130
integer height = 224
integer taborder = 50
end type


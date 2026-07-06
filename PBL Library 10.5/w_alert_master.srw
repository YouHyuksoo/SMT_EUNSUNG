HA$PBExportHeader$w_alert_master.srw
$PBExportComments$Help Video Master
forward
global type w_alert_master from w_main_root
end type
type sle_alert_text from so_singlelineedit within w_alert_master
end type
type st_2 from so_statictext within w_alert_master
end type
type cb_1 from so_commandbutton within w_alert_master
end type
type cb_2 from so_commandbutton within w_alert_master
end type
type cb_view_help from so_commandbutton within w_alert_master
end type
type st_1 from so_statictext within w_alert_master
end type
type uo_dateset from uo_ymd_calendar within w_alert_master
end type
type gb_1 from so_groupbox within w_alert_master
end type
type gb_2 from so_groupbox within w_alert_master
end type
end forward

global type w_alert_master from w_main_root
integer width = 5440
integer height = 3352
string title = "Alert Master"
sle_alert_text sle_alert_text
st_2 st_2
cb_1 cb_1
cb_2 cb_2
cb_view_help cb_view_help
st_1 st_1
uo_dateset uo_dateset
gb_1 gb_1
gb_2 gb_2
end type
global w_alert_master w_alert_master

type variables
datawindow ivd_data_window
end variables

on w_alert_master.create
int iCurrent
call super::create
this.sle_alert_text=create sle_alert_text
this.st_2=create st_2
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_view_help=create cb_view_help
this.st_1=create st_1
this.uo_dateset=create uo_dateset
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_alert_text
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cb_view_help
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.uo_dateset
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_alert_master.destroy
call super::destroy
destroy(this.sle_alert_text)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_view_help)
destroy(this.st_1)
destroy(this.uo_dateset)
destroy(this.gb_1)
destroy(this.gb_2)
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

event ue_data_control;call super::ue_data_control;Long ROW , LVL_HELP_ID
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
               dw_1.RETRIEVE(uo_dateset.text() , sle_alert_text.text+'%' , GVI_ORGANIZATION_ID)
               dw_1.SETFOCUS()
			
	CASE 'INSERT'
		
			ROW = dw_2.INSERTROW(dw_2.GETROW())
			dw_2.SCROLLTOROW(ROW)
			
			dw_2.OBJECT.DATESET[ROW] = F_T_SYSDATE()
			dw_2.OBJECT.DATEEND[ROW] = F_T_SYSDATE()			
			dw_2.OBJECT.ALERT_BY[ROW] = GVS_USER_ID
			
			F_SET_SECURITY_ROW(dw_2 , ROW , 'ALL')
			
	CASE 'APPEND'
			ROW = dw_2.INSERTROW(0)
			dw_2.SCROLLTOROW(ROW)
		
			dw_2.OBJECT.DATESET[ROW] = F_T_SYSDATE()
			dw_2.OBJECT.DATEEND[ROW] = F_T_SYSDATE()			
			dw_2.OBJECT.ALERT_BY[ROW] = GVS_USER_ID
			
			F_SET_SECURITY_ROW(dw_2 , ROW , 'ALL')	
	CASE 'DELETE'
			if dw_2.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = dw_2.GetRow()			
				dw_2.DELETEROW(Gvl_row_deleted)		
				dw_2.SetFocus()
				ROW = dw_2.GetRow()
				dw_2.ScrollToRow(row)
				dw_2.SetColumn(1)
			END IF
						
	CASE 'UPDATE'
		
          	IF dw_2.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				 COMMIT;
 				 f_msg_mdi_help( f_msg_st( 170) ) //$$HEX7$$00c8a5c718b4c8c5b5c2c8b2e4b2$$ENDHEX$$

			END IF
			
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_alert_master
boolean visible = false
integer y = 352
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_alert_master
boolean visible = false
integer y = 352
integer taborder = 50
end type

type dw_3 from w_main_root`dw_3 within w_alert_master
boolean visible = false
integer y = 352
integer taborder = 60
end type

type dw_2 from w_main_root`dw_2 within w_alert_master
integer x = 5
integer y = 1560
integer width = 4498
integer height = 1052
integer taborder = 70
boolean titlebar = true
string title = "Alert Detail"
string dataobject = "d_alert_mst"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_alert_master
integer y = 308
integer width = 4507
integer height = 1248
integer taborder = 0
boolean titlebar = true
string title = "Alert List"
string dataobject = "d_alert_list"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF CURRENTROW <  1 THEN RETURN
DW_2.RETRIEVE( STRING( THIS.OBJECT.ROWID[CURRENTROW] ))
DW_1.SETFOCUS()
end event

event dw_1::doubleclicked;call super::doubleclicked;IF ROW <  1 THEN RETURN
DW_2.RETRIEVE( STRING( THIS.OBJECT.ROWID[ROW] ))
DW_1.SETFOCUS()
end event

type sle_alert_text from so_singlelineedit within w_alert_master
integer x = 453
integer y = 164
integer width = 1138
integer height = 84
integer taborder = 20
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "HELP_KEYWORD"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	DW_1.SETFILTER('')
	DW_1.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found")
end event

type st_2 from so_statictext within w_alert_master
integer x = 448
integer y = 76
integer width = 1138
boolean bringtotop = true
integer weight = 700
string text = "Alert Text"
end type

type cb_1 from so_commandbutton within w_alert_master
integer x = 1696
integer y = 120
integer height = 96
integer taborder = 30
boolean bringtotop = true
string text = "Upload File"
end type

event clicked;call super::clicked;IF f_object_role_check() = FALSE THEN  RETURN
		INT    li_filenum , loops, i , lvi_count
		LONG   flen, bytes_read , bytes_read_sum , new_pos , lvl_help_id
		BLOB   lib_file , b
		string is_filename, is_fullname , lvs_item_code
		
		IF  dw_1.getrow() < 1 THEN 
			 RETURN
		END IF
		
		lvl_help_id = dw_1.getitemnumber (dw_1.getrow() , "help_id" )

		IF  isnull(lvl_help_id) THEN 
			RETURN
		END IF
		
		IF getfileopenname("Select File", &
			 is_fullname, is_filename, "avi", &
			 + "avi files (*.avi),*.avi," &
			 + "mpeg files (*.mpeg),*.mpeg," &
			 + "all files (*.*), *.*") < 1 THEN RETURN
		
		flen = filelength(is_fullname)
		
		IF flen < 0 THEN 
			f_msgbox1(9020 ,is_fullname ) 	//("error" , is_fullname+" file length unknown")
			RETURN 
		END IF
		
		li_filenum = fileopen(is_fullname,  streammode!, READ!, lockread!)
		
IF li_filenum <> -1 THEN
				
					bytes_read = filereadex(li_filenum, lib_file , flen )
					f_msg_mdi_help( string(bytes_read_sum)+"/"+string(flen)+" bytes read" )
					fileclose(li_filenum)
					
					
					SELECT count(*) INTO :lvi_count
					  FROM isys_help_video
					 WHERE help_id   = :lvl_help_id 
					   AND organization_id = :gvi_organization_id ;
						  
					IF f_sql_check() < 0 THEN 	RETURN
					
					IF lvi_count = 0 THEN 
						f_msgbox1( 9021 , is_filename ) 	//("error", is_filename+" file name not found !" )
						RETURN
					END IF
						  
				UPDATEBLOB  isys_help_video 
				SET help_video = :lib_file 
				WHERE help_id      = :lvl_help_id
				AND organization_id = :gvi_organization_id ;
					 
				IF f_sql_check() < 0 THEN 
					RETURN
				END IF
				
				UPDATE  isys_help_video 
				SET  help_file_name = :is_filename ,
				        help_video_exists_yn = 'Y'
				WHERE help_id      = :lvl_help_id
				AND organization_id = :gvi_organization_id ;
					 
				IF f_sql_check() < 0 THEN 
					RETURN
				END IF				
				
				IF sqlca.sqlnrows > 0 THEN
					f_msg_mdi_help( f_msg_st(9022) ) 
				ELSE
					f_msgbox1( 157 , is_filename )   //("error" , is_filename+"file upload to database failed" )
				END IF;				
				  
			     COMMIT ;
				  
F_RETRIEVE()
END IF
end event

type cb_2 from so_commandbutton within w_alert_master
integer x = 2240
integer y = 120
integer height = 92
integer taborder = 40
boolean bringtotop = true
string text = "Clear File"
end type

event clicked;call super::clicked;BLOB LVB_NULL
LONG LVL_HELP_ID 

if dw_1.getrow( ) < 1  then 
	return
end if

LVL_HELP_ID = dw_1.object.help_id[dw_1.getrow()]

UPDATEBLOB ISYS_HELP_VIDEO SET HELP_VIDEO =  :LVB_NULL
WHERE HELP_ID      = :LVL_HELP_ID
  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
 
IF F_SQL_CHECK() < 0 THEN 
  RETURN
END IF

COMMIT ;
end event

type cb_view_help from so_commandbutton within w_alert_master
integer x = 2779
integer y = 120
integer height = 92
integer taborder = 50
boolean bringtotop = true
string text = "Run File"
end type

event clicked;call super::clicked;Long Lvl_return
String  lvs_file_name
if dw_1.getrow() < 1 then return 

Lvl_return =  f_download_helpvideo ( Long(dw_1.object.help_id[dw_1.getrow()]) )
if  Lvl_return > 0 then 
	
	dw_1.bringtotop = false
	
	lvs_file_name = getcurrentdirectory()+"\"+dw_1.object.help_file_name[dw_1.getrow()] 
	
	IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
		RETURN
	END IF
	
	f_shell_execute_by_extention ( dw_1.object.help_file_name[dw_1.getrow()]  , '' , getcurrentdirectory()  )
	
else
	
end if


end event

type st_1 from so_statictext within w_alert_master
integer x = 37
integer y = 76
integer width = 407
boolean bringtotop = true
integer weight = 700
string text = "Date"
end type

type uo_dateset from uo_ymd_calendar within w_alert_master
event destroy ( )
integer x = 37
integer y = 164
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type gb_1 from so_groupbox within w_alert_master
integer width = 1614
integer height = 288
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_alert_master
integer x = 1627
integer width = 1742
integer height = 288
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


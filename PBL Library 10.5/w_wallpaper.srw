HA$PBExportHeader$w_wallpaper.srw
forward
global type w_wallpaper from window
end type
type uo_dateend from uo_ymd_calendar within w_wallpaper
end type
type uo_dateset from uo_ymd_calendar within w_wallpaper
end type
type ddlb_dept_code from uo_department_code_all within w_wallpaper
end type
type sle_2 from so_singlelineedit within w_wallpaper
end type
type st_4 from so_statictext within w_wallpaper
end type
type cbx_1 from so_checkbox within w_wallpaper
end type
type pb_7 from so_picturebutton within w_wallpaper
end type
type st_3 from so_statictext within w_wallpaper
end type
type sle_1 from so_singlelineedit within w_wallpaper
end type
type st_1 from so_statictext within w_wallpaper
end type
type st_2 from so_statictext within w_wallpaper
end type
type pb_show from so_picturebutton within w_wallpaper
end type
type pb_refresh from so_picturebutton within w_wallpaper
end type
type pb_save from so_picturebutton within w_wallpaper
end type
type pb_delete from so_picturebutton within w_wallpaper
end type
type pb_modify from so_picturebutton within w_wallpaper
end type
type pb_new from so_picturebutton within w_wallpaper
end type
type pb_replay from so_picturebutton within w_wallpaper
end type
type pb_view from so_picturebutton within w_wallpaper
end type
type dw_favorites from so_datawindow within w_wallpaper
end type
type dw_monitor from so_datawindow within w_wallpaper
end type
type dw_board from so_datawindow within w_wallpaper
end type
type dw_work_board_content from so_datawindow within w_wallpaper
end type
type dw_report from so_datawindow within w_wallpaper
end type
end forward

global type w_wallpaper from window
integer width = 4928
integer height = 3284
boolean border = false
windowtype windowtype = popup!
windowstate windowstate = maximized!
long backcolor = 67108864
string icon = "AppIcon!"
boolean clientedge = true
event ue_post_open ( )
event ue_data_control ( )
uo_dateend uo_dateend
uo_dateset uo_dateset
ddlb_dept_code ddlb_dept_code
sle_2 sle_2
st_4 st_4
cbx_1 cbx_1
pb_7 pb_7
st_3 st_3
sle_1 sle_1
st_1 st_1
st_2 st_2
pb_show pb_show
pb_refresh pb_refresh
pb_save pb_save
pb_delete pb_delete
pb_modify pb_modify
pb_new pb_new
pb_replay pb_replay
pb_view pb_view
dw_favorites dw_favorites
dw_monitor dw_monitor
dw_board dw_board
dw_work_board_content dw_work_board_content
dw_report dw_report
end type
global w_wallpaper w_wallpaper

type variables
STRING IVS_ETC , ivs_prev_xml
long ivs_go,ivs_go_f, ivs_go_b 
int ivi_mousemove_flag = 0 , ivi_graph4_term = 1
so_multilineedit_tooltip uo_mtle
end variables

forward prototypes
public function integer wf_call_monitor ()
end prototypes

event ue_post_open();


dw_board.width = width
dw_board.height = height - ( dw_monitor.height + dw_board.y )

dw_work_board_content.width= dw_board.width
dw_work_board_content.height= dw_board.height

dw_report.width= dw_board.width
dw_report.height= dw_board.height

dw_monitor.y = dw_board.y  + dw_board.height 
dw_monitor.width = width / 2 // dw_board.width

dw_favorites.y = dw_monitor.y 
dw_favorites.x = dw_monitor.x + dw_monitor.width
dw_favorites.width = dw_board.width  - dw_monitor.width
dw_favorites.height = dw_monitor.height 

f_set_column_dddw(dw_board) 

F_CHILD_DW3(dw_favorites, 'window_type_1', gvs_language, string(gvi_organization_id) , 'WINDOW TYPE')
F_CHILD_DW3(dw_favorites, 'window_type', gvs_language, string(gvi_organization_id) , 'WINDOW TYPE')
F_CHILD_DW3(dw_favorites, 'monitor_item', gvs_language, string(gvi_organization_id) , 'MONITOR ITEM')

uo_dateset.settext (string(RelativeDate( Date(uo_dateset.text()) , -7 )))
pb_refresh.triggerevent( clicked!)

//=====================================
// $$HEX7$$a8bac8b230d1200070c88cd62000$$ENDHEX$$
//=====================================
f_set_column_dddw(dw_monitor) 
dw_monitor.retrieve( Gvs_language , Gvi_organization_id )

//=====================================
//$$HEX7$$f8ad98b704d5200070c88cd62000$$ENDHEX$$
//=====================================
dw_favorites.retrieve( Gvs_app_name , Gvs_user_id , Gvs_language , Gvi_organization_id )

end event

event ue_data_control();String null_str
window activesheet


IF ISVALID( SELECTED_DATA_WINDOW) THEN 
ELSE
	 RETURN
END IF

CHOOSE CASE Gvs_ue_data_control
		
	CASE 'RETRIEVE'

		pb_refresh.triggerevent( clicked!)
 
	CASE 'FIRSTROW'			
			selected_data_window.SCROLLTOROW(1)
	CASE 'NEXTPAGE'					
			selected_data_window.SCROLLNEXTPAGE()
	CASE 'PREVPAGE'					
			selected_data_window.SCROLLPRIORPAGE()						
	CASE 'LASTROW'					
			selected_data_window.SCROLLTOROW(selected_data_window.ROWCOUNT())		
			
	CASE 'SORT'
			f_sort()
	CASE 'FILTER'		
		
			SetNull(null_str)
               gst_return.gvs_return[1] = selected_data_window.classname()
			openwithparm(w_set_filter , selected_data_window)
			
	CASE 'EXPANDALL'
			 SELECTED_DATA_WINDOW.EXpandall( )
		CASE 'COLLAPSEALL' 
			 SELECTED_DATA_WINDOW.Collapseall( )			
	CASE ELSE
END CHOOSE
end event

public function integer wf_call_monitor ();int lvi_return
lvi_return = sqlca.F_SET_DATA_MONITOR( gvi_organization_id)
commit ;	
dw_monitor.retrieve( gvs_language , gvi_organization_id )

return lvi_return
end function

on w_wallpaper.create
this.uo_dateend=create uo_dateend
this.uo_dateset=create uo_dateset
this.ddlb_dept_code=create ddlb_dept_code
this.sle_2=create sle_2
this.st_4=create st_4
this.cbx_1=create cbx_1
this.pb_7=create pb_7
this.st_3=create st_3
this.sle_1=create sle_1
this.st_1=create st_1
this.st_2=create st_2
this.pb_show=create pb_show
this.pb_refresh=create pb_refresh
this.pb_save=create pb_save
this.pb_delete=create pb_delete
this.pb_modify=create pb_modify
this.pb_new=create pb_new
this.pb_replay=create pb_replay
this.pb_view=create pb_view
this.dw_favorites=create dw_favorites
this.dw_monitor=create dw_monitor
this.dw_board=create dw_board
this.dw_work_board_content=create dw_work_board_content
this.dw_report=create dw_report
this.Control[]={this.uo_dateend,&
this.uo_dateset,&
this.ddlb_dept_code,&
this.sle_2,&
this.st_4,&
this.cbx_1,&
this.pb_7,&
this.st_3,&
this.sle_1,&
this.st_1,&
this.st_2,&
this.pb_show,&
this.pb_refresh,&
this.pb_save,&
this.pb_delete,&
this.pb_modify,&
this.pb_new,&
this.pb_replay,&
this.pb_view,&
this.dw_favorites,&
this.dw_monitor,&
this.dw_board,&
this.dw_work_board_content,&
this.dw_report}
end on

on w_wallpaper.destroy
destroy(this.uo_dateend)
destroy(this.uo_dateset)
destroy(this.ddlb_dept_code)
destroy(this.sle_2)
destroy(this.st_4)
destroy(this.cbx_1)
destroy(this.pb_7)
destroy(this.st_3)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.pb_show)
destroy(this.pb_refresh)
destroy(this.pb_save)
destroy(this.pb_delete)
destroy(this.pb_modify)
destroy(this.pb_new)
destroy(this.pb_replay)
destroy(this.pb_view)
destroy(this.dw_favorites)
destroy(this.dw_monitor)
destroy(this.dw_board)
destroy(this.dw_work_board_content)
destroy(this.dw_report)
end on

event resize;
dw_board.width = newwidth
dw_board.height = newheight - ( dw_monitor.height + dw_board.y )

dw_work_board_content.width= dw_board.width
dw_work_board_content.height= dw_board.height

dw_report.width= dw_board.width

dw_monitor.y = dw_board.y  + dw_board.height 
dw_monitor.width = newwidth / 2 // dw_board.width

dw_favorites.y = dw_monitor.y 
dw_favorites.x = dw_monitor.x + dw_monitor.width
dw_favorites.width = dw_board.width  - dw_monitor.width
dw_favorites.height = dw_monitor.height 




end event

event open;/*********************************************************
* $$HEX19$$e4b26dadb4c5200098ccacb97cb9200004c75cd5200090c7ccb8200088bdecb724c630ae2000$$ENDHEX$$: w_genapp_frame$$HEX5$$d0c51cc1200020c1b8c5$$ENDHEX$$
* $$HEX16$$74c7f3acd0c51cc194b22000c0bc58d6200091c7c5c5ccb9200018c289d568d5$$ENDHEX$$
* BY KIM, YONG-CHUL
**********************************************************/
if	Gvs_language =	'C' or Gvs_language = 'K' then

	if gds_dual.rowcount() < 1 then 
	     f_msgbox(136) //There is not a possibility of knowing multi national language information		
//		("Error" , "Language Info Not Found ")
		return
	else
		F_MSG_MDI_HELP( "Dual Source "+string(gds_dual.rowcount())+" Rows Found" )
	end if
  
	w_main_frame.SetMicroHelp("Language Change...")
	
     f_dual_lang_change_text(this)
	  
	w_main_frame.SetMicroHelp("Language Change Done.")
	  	
end if

dw_board.settransobject( sqlca)
dw_work_board_content.settransobject( sqlca)
dw_monitor.settransobject( sqlca)
dw_favorites.settransobject( sqlca)
dw_report.settransobject( sqlca)

PostEvent('ue_post_open')
end event

event timer;f_msg_mdi_help( string( now() ))
end event

event activate;/***************************************
* $$HEX17$$08c7c4b324c115c8d0c5200000ad5cd52000acc06dd544c720004bc105d35cd5e4b2$$ENDHEX$$
*
*
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

F_MENU_CONTROL('DATA_CONTROL' , FALSE)  // All Data Control

/****************************************
* 
****************************************/

end event

type uo_dateend from uo_ymd_calendar within w_wallpaper
event destroy ( )
integer x = 2738
integer y = 184
integer taborder = 40
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateset from uo_ymd_calendar within w_wallpaper
event destroy ( )
integer x = 2738
integer y = 96
integer taborder = 30
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_dept_code from uo_department_code_all within w_wallpaper
integer x = 3506
integer y = 180
integer height = 1196
integer taborder = 70
end type

event constructor;call super::constructor;this.redraw( string(gvi_organization_id) )
end event

event rbuttondown;// override
end event

type sle_2 from so_singlelineedit within w_wallpaper
integer x = 3506
integer y = 92
integer width = 325
integer taborder = 80
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_board.SETFILTER('')
dw_board.FILTER()

LVS_COLUMN = 'USER_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_board.SETFILTER('')
    dw_board.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_board.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_board.FILTER()
F_MSG_MDI_HELP( STRING( dw_board.ROWCOUNT() ) + " Found" )
end event

type st_4 from so_statictext within w_wallpaper
integer x = 3168
integer y = 176
integer width = 325
long backcolor = 134217750
string text = "Dept Code"
end type

type cbx_1 from so_checkbox within w_wallpaper
integer x = 3858
integer y = 8
integer height = 68
long backcolor = 134217750
string text = "Preview"
end type

event clicked;call super::clicked;if this.checked  = true then 
	dw_report.visible = true
	dw_report.bringtotop = true
else
	dw_report.bringtotop = false
end if 
end event

type pb_7 from so_picturebutton within w_wallpaper
integer x = 2423
integer width = 302
integer height = 264
integer taborder = 80
integer textsize = -8
string text = "Print"
boolean originalsize = false
string picturename = "machine.bmp"
string disabledname = "pb_background1.bmp"
alignment htextalign = center!
end type

event clicked;call super::clicked;if dw_board.getrow( ) < 1 then return
dw_report.reset()
f_set_column_dddw( dw_report)
dw_report.retrieve( dw_board.object.rowid[dw_board.getrow()] , gvs_user_name )

dw_report.print( false , true)
end event

type st_3 from so_statictext within w_wallpaper
integer x = 3168
integer y = 88
integer width = 325
long backcolor = 134217750
string text = "User Name"
end type

type sle_1 from so_singlelineedit within w_wallpaper
integer x = 3506
integer y = 4
integer width = 325
integer taborder = 70
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_board.SETFILTER('')
dw_board.FILTER()

LVS_COLUMN = 'TITLE'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_board.SETFILTER('')
    dw_board.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_board.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_board.FILTER()
F_MSG_MDI_HELP( STRING( dw_board.ROWCOUNT() ) + " Found" )
end event

type st_1 from so_statictext within w_wallpaper
integer x = 3168
integer y = 4
integer width = 325
long textcolor = 16711935
long backcolor = 134217750
string text = "Search Title"
end type

type st_2 from so_statictext within w_wallpaper
integer x = 2743
integer y = 12
integer width = 411
long backcolor = 134217750
string text = "Reg Date"
end type

type pb_show from so_picturebutton within w_wallpaper
integer x = 2117
integer width = 302
integer height = 264
integer taborder = 80
integer textsize = -8
string text = "Show Doc"
boolean originalsize = false
string picturename = "board_add.jpg"
string disabledname = "pb_background1.bmp"
alignment htextalign = center!
end type

event clicked;call super::clicked;//IF dwo.name = 'b_show' then 
			
		if dw_board.getrow() < 1 then 
			return
		end if
		
		Long Lvl_return
		String  lvs_file_name
		if dw_board.getrow() < 1 then return 
		
		Lvl_return = f_download_work_board_attach_data ( dw_board.object.reg_date[dw_board.getrow()] , dw_board.object.seq_no[dw_board.getrow()]  )
		
		if  Lvl_return > 0 then 
		
			lvs_file_name = Gvs_default_directory+"\Temp\"+dw_board.object.file_name[dw_board.getrow()] 
			
			IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
				RETURN
			END IF
			
			f_shell_execute_by_extention ( Gst_return.gvs_return[1]   , '' ,Gvs_default_directory+'\Temp'  )
//			f_shell_execute_by_extention ( dw_board.object.file_name[dw_board.getrow()]  , '' ,Gvs_default_directory+'\Temp'  )			
		else
			
		end if
		
		Changedirectory(Gvs_default_directory)
	
	
//end if 
end event

type pb_refresh from so_picturebutton within w_wallpaper
integer x = 1810
integer width = 302
integer height = 264
integer taborder = 70
integer textsize = -8
string text = "Refresh"
boolean originalsize = false
string picturename = "board_list.jpg"
string disabledname = "pb_background1.bmp"
alignment htextalign = center!
string powertiptext = "Refresh F1"
end type

event clicked;call super::clicked;Int lvi_file_count
int li_FileNum , lvi_write_byte_sum 
long lvl_first , lvl_last 
String  lvs_urgency_level , lvs_message_recipients , lvs_xml , lvs_title , lvs_order_qty , lvs_actual_qty

dw_board.RESET()
dw_board.BRINGTOTOP = TRUE
//=================================================
// $$HEX3$$70c88cd62000$$ENDHEX$$
//=================================================
dw_board.RETRIEVE(uo_dateset.text() ,  uo_dateend.text() ,  ddlb_dept_code.getcode()+'%'  , gvi_user_level , Gvi_organization_id)

end event

type pb_save from so_picturebutton within w_wallpaper
integer x = 1504
integer width = 302
integer height = 264
integer taborder = 60
integer textsize = -8
string text = "Save"
boolean originalsize = false
string picturename = "board_save.jpg"
string disabledname = "pb_background1.bmp"
alignment htextalign = center!
end type

event clicked;call super::clicked;IF dw_work_board_content.UPDATE() < 0 THEN 
	ROLLBACK ;
ELSE
	
	 COMMIT;
	 dw_board.Bringtotop = TRUE
	 pb_refresh.triggerevent( clicked!)
END IF
end event

type pb_delete from so_picturebutton within w_wallpaper
integer x = 1207
integer width = 302
integer height = 264
integer taborder = 50
integer textsize = -8
string text = "Delete"
boolean originalsize = false
string picturename = "board_delete.jpg"
string disabledname = "pb_background1.bmp"
alignment htextalign = center!
end type

event clicked;call super::clicked;STRING LVS_USER_ID
IF dw_board.GETROW() < 1 THEN 
	RETURN 
END IF 

IF GVI_USER_LEVEL = 9 THEN 
	
			dw_board.DELETEROW( dw_board.GETROW())
			
			MSG = f_msgbox(1170) //save?
			
			IF MSG = 1 THEN
				IF dw_board.UPDATE() < 0 THEN 
					ROLLBACK;
				ELSE
					COMMIT;			
					pb_refresh.triggerevent( clicked!)
				END IF
			ELSE
				dw_board.RowsMove( 1, 1, delete!, dw_board, dw_board.GETROW(), primary!)	
				ROLLBACK;
			END IF	
	
ELSE
		
		LVS_USER_ID = dw_board.GETITEMSTRING( dw_board.GETROW() , 'user_id' )
		
		IF (GVS_USER_ID = LVS_USER_ID)  THEN 
			
			dw_board.DELETEROW( dw_board.GETROW())
			
			MSG = f_msgbox(1170) //save?
			
			IF MSG = 1 THEN
				IF dw_board.UPDATE() < 0 THEN 
					ROLLBACK;
				ELSE
					COMMIT;			
					pb_refresh.triggerevent( clicked!)
				END IF
			ELSE
				dw_board.RowsMove( 1, 1, delete!, dw_board, dw_board.GETROW(), primary!)	
				ROLLBACK;
			END IF
			
		ELSE
			f_msgbox(181 )	
		//	("Warning" , "You Can Not Delete Data You Are Not Owner.")
			RETURN
		END IF
		
END IF
end event

type pb_modify from so_picturebutton within w_wallpaper
integer x = 905
integer width = 302
integer height = 264
integer taborder = 40
integer textsize = -8
string text = "Edit"
boolean originalsize = false
string picturename = "board_modify.jpg"
string disabledname = "pb_background1.bmp"
alignment htextalign = center!
end type

event clicked;call super::clicked;STRING LVS_USER_ID
LONG LVL_SEQ
IF dw_board.GETROW() < 1 THEN 
	RETURN 
END IF 

LVS_USER_ID = dw_board.GETITEMSTRING( dw_board.GETROW() , 'user_id' )

IF GVI_USER_LEVEL = 9 THEN 
	
				LVL_SEQ = dw_board.GETITEMNUMBER( dw_board.GETROW() , 'seq_no' ) 
				dw_work_board_content.BRINGTOTOP  = TRUE
				dw_work_board_content.RETRIEVE(LVL_SEQ)	
ELSE

		IF GVS_USER_ID = LVS_USER_ID THEN 			
				LVL_SEQ = dw_board.GETITEMNUMBER( dw_board.GETROW() , 'seq_no' ) 
				dw_work_board_content.BRINGTOTOP  = TRUE
				dw_work_board_content.RETRIEVE(LVL_SEQ)
		ELSE
			f_msgbox(181 )
			//("Warning" , "You Can Not Edit Data You Are Not Owner.")
			RETURN
		END IF
END IF 




end event

type pb_new from so_picturebutton within w_wallpaper
integer x = 603
integer width = 302
integer height = 264
integer taborder = 30
integer textsize = -8
string text = "New"
boolean originalsize = false
string picturename = "board_new.jpg"
string disabledname = "pb_background1.bmp"
alignment htextalign = center!
end type

event clicked;call super::clicked;LONG LVL_ROW , LVL_SEQ

dw_work_board_content.VISIBLE  = TRUE
dw_work_board_content.BRINGTOTOP  = TRUE
dw_work_board_content.RESET()
LVL_ROW = dw_work_board_content.INSERTROW(0)
F_SET_SECURITY_ROW( dw_work_board_content ,LVL_ROW , 'ALL' )
dw_work_board_content.SETITEM(LVL_ROW , 'user_id' , GVS_USER_ID) 
dw_work_board_content.SETITEM(LVL_ROW , 'user_name' , GVS_USER_NAME) 
dw_work_board_content.SETITEM(LVL_ROW , 'email_address' , GVS_EMAIL_ADDRESS) 
dw_work_board_content.SETITEM(LVL_ROW , 'reg_date' , F_SYSDATE()) 
dw_work_board_content.SETITEM(LVL_ROW , 'application_name' , Gvs_app_name) 
LVL_SEQ = f_get_sequence( 'SEQ_PUB_BOARD' ) 
dw_work_board_content.SETITEM(LVL_ROW , 'seq_no' , LVL_SEQ) 
dw_work_board_content.SETITEM(LVL_ROW , 'parent_seq_no' , LVL_SEQ) 
dw_work_board_content.SETITEM(LVL_ROW , 'reply_sequence' , 0) 

dw_work_board_content.SETITEM(LVL_ROW , 'urgency_level' , 'C') 

dw_work_board_content.SETFOCUS()
end event

type pb_replay from so_picturebutton within w_wallpaper
integer x = 302
integer width = 302
integer height = 264
integer taborder = 20
integer textsize = -8
string text = "Reply"
boolean originalsize = false
string picturename = "board_reply.jpg"
string disabledname = "pb_background1.bmp"
alignment htextalign = center!
end type

event clicked;call super::clicked;LONG LVL_PARENT_SEQ_NO , LVL_ROW , LVL_SEQ , LVL_REPLY_SEQ
STRING LVS_CONTENT , LVS_RE_TITLE
dw_work_board_content.reset()
IF dw_board.GETROW() < 1 THEN 
	RETURN 
END IF 

dw_work_board_content.BRINGTOTOP  = TRUE

LVL_PARENT_SEQ_NO = dw_board.GETITEMNUMBER( dw_board.GETROW() ,'parent_seq_no')
LVS_CONTENT            = dw_board.GETITEMSTRING( dw_board.GETROW() , 'content')
LVS_RE_TITLE            = "Re: "+dw_board.GETITEMSTRING( dw_board.GETROW() ,'title')

LVL_REPLY_SEQ  = dw_board.GETITEMNUMBER( dw_board.GETROW() ,'reply_sequence') + 1

LVL_ROW = dw_work_board_content.INSERTROW(0)
F_SET_SECURITY_ROW( dw_work_board_content ,LVL_ROW, 'ALL' )
dw_work_board_content.SETITEM(LVL_ROW , 'user_id' , GVS_USER_ID) 
dw_work_board_content.SETITEM(LVL_ROW , 'user_name' , GVS_USER_NAME) 
dw_work_board_content.SETITEM(LVL_ROW , 'email_address' , GVS_EMAIL_ADDRESS) 
dw_work_board_content.SETITEM(LVL_ROW , 'reg_date' , F_SYSDATE()) 
dw_work_board_content.SETITEM(LVL_ROW , 'application_name' , Gvs_app_name) 

SELECT SEQ_PUB_BOARD.NEXTVAL INTO :LVL_SEQ
  FROM DUAL ;
  IF F_SQL_CHECK() < 0 THEN
	  RETURN
  END IF
 
dw_work_board_content.SETITEM(LVL_ROW , 'seq_no' , LVL_SEQ) 
dw_work_board_content.SETITEM(LVL_ROW , 'title',   '$$HEX1$$1425$$ENDHEX$$>'+' '+LVS_RE_TITLE) 
dw_work_board_content.SETITEM(LVL_ROW , 'content', '~r~n~r~n'+"===================================================="+'~r~n'+LVS_CONTENT+'~r~n'+"===================================================="+'~r~n')
dw_work_board_content.SETITEM(LVL_ROW , 'reply_sequence' , LVL_REPLY_SEQ) 
dw_work_board_content.SETITEM(LVL_ROW , 'parent_seq_no' , LVL_PARENT_SEQ_NO) 
end event

type pb_view from so_picturebutton within w_wallpaper
integer width = 302
integer height = 264
integer taborder = 10
integer textsize = -8
string text = "View"
boolean originalsize = false
string picturename = "board_view.bmp"
string disabledname = "pb_background1.bmp"
alignment htextalign = center!
end type

event clicked;call super::clicked;long  ll_count,ll_seq
string ls_user

if dw_board.getrow() < 1 then return
ll_count  = dw_board.getitemnumber(dw_board.getrow(),'hit_count')
ls_user = dw_board.getitemstring(dw_board.getrow(),'user_id')
ll_seq  = dw_board.getitemnumber(dw_board.getrow(),'seq_no')


update ISYS_pub_board
   set hit_count = nvl(hit_count,0) + 1 
 where user_id   = :ls_user
   and seq_no    = :ll_seq ;
if f_sql_check() < 0 then 
	return
end if 

commit ;

if isnull(ll_count) then 
	ll_count = 0
end if 
ll_count ++

dw_board.setitem(dw_board.getrow(),'hit_count',ll_count)
dw_board.accepttext()

openwithParm(w_edit_window  , dw_board.getitemstring( dw_board.getrow() , 'content') )


end event

type dw_favorites from so_datawindow within w_wallpaper
event ue_mousemove pbm_mousemove
event uo_mousemove pbm_dwnmousemove
integer x = 1586
integer y = 1572
integer width = 2816
integer height = 1072
integer taborder = 60
boolean titlebar = true
string title = "My Menu"
string dataobject = "d_my_menu_tree"
boolean maxbox = true
string icon = "CreateLibrary5!"
end type

event doubleclicked;call super::doubleclicked;IF ROW < 1 THEN RETURN

window child
OpenSheet(child, this.getitemstring( this.getrow() , 'window_name' ) , w_main_frame,  Gvi_opensheet_position, Layered!)
end event

type dw_monitor from so_datawindow within w_wallpaper
integer y = 1564
integer width = 1582
integer height = 1080
integer taborder = 50
boolean titlebar = true
string title = "Data Monitor"
string dataobject = "d_data_monitor"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
string icon = "Query5!"
boolean hsplitscroll = true
end type

event clicked;call super::clicked;if dwo.name = 'b_call' then 

	wf_call_monitor()

end if
end event

event doubleclicked;call super::doubleclicked;if row < 1 then return

if dwo.name = 'monitor_item' then 
	
    choose case this.object.monitor_item[row]
	case 'S001'
		/*statementblock*/
	case else
		/*statementblock*/
end choose

	
	
end if 
end event

type dw_board from so_datawindow within w_wallpaper
event ue_mousemove pbm_mousemove
integer y = 272
integer width = 4393
integer height = 1292
integer taborder = 10
boolean titlebar = true
string title = "Work Board"
string dataobject = "d_work_board_title"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
string icon = "DataWindow5!"
boolean hsplitscroll = true
end type

event ue_mousemove;//String lvs_tooltip
//
//if dwo.name = 'title' then 
// 
//		if ivi_mousemove_flag = 1 then 
//			
//		else
//				if isvalid( uo_mtle ) then 
//
//				else
//				     ivi_mousemove_flag = 1
//					  
//					 if isnull(dw_favorites.getitemstring( row , 'title')) then 
//					 else
//						 lvs_tooltip = dw_favorites.getitemstring( row , 'title')+'~r~n'
//					end if
//					
//					if isnull(dw_favorites.Getitemstring( row , 'content' )) then 
//					else
//						 lvs_tooltip = lvs_tooltip + dw_favorites.Getitemstring( row , 'content' )
//					end if
//
//					OpenUserObjectWithParm ( uo_mtle , lvs_tooltip , parent.pointerx() +100, parent.pointery() )
//					uo_mtle.width = LEN(string(dw_favorites.object.title[row])+'~r~n'+string(dw_favorites.object.content[row])) * 32
//					uo_mtle.height = 200
//					uo_mtle.bringtotop = true
//		
//				end if
//				
//		end if
//		
//else
//		 parent.closeuserobject( uo_mtle )		
//	      ivi_mousemove_flag = 0
//end if
//
//this.setredraw(true)
//if row < 1 then return 
//this.selectrow( 0, false)
//this.selectrow( row, true)

end event

event doubleclicked;call super::doubleclicked;pb_view.triggerevent('clicked')

if this.update( ) < 0 then
	rollback ;
else
	commit ;
end if 
end event

event rowfocuschanged;call super::rowfocuschanged;ivi_mousemove_flag = 0

if dw_board.getrow( ) < 1 then return 
//mle_text.text =  dw_board.getitemstring( dw_board.getrow() , 'content')
end event

event clicked;call super::clicked;if dw_board.getrow( ) < 1 then return 
if dwo.name = 'b_show' then
	
	pb_show.triggerevent( clicked! ) 
	
end if 
end event

type dw_work_board_content from so_datawindow within w_wallpaper
integer y = 272
integer width = 4393
integer height = 1292
integer taborder = 10
boolean titlebar = true
string title = "Work Board"
string dataobject = "d_work_board_content"
boolean maxbox = true
boolean vscrollbar = true
boolean resizable = true
string icon = "DataWindow5!"
boolean hsplitscroll = true
end type

event clicked;if dwo.name = 'b_recipients' then
	
	open(w_user_popup)
	
	if gst_return.gvb_return = true  then 
		if this.object.message_recipients[row] = '' or isnull(this.object.message_recipients[row]) then 
			this.object.message_recipients[row] =Gst_return.Gvs_return[1]
		else
			this.object.message_recipients[row] =this.object.message_recipients[row]  + ';'+Gst_return.Gvs_return[1]
		end if 
	end if 
	
elseif dwo.name = 'b_attach' then 
			
				int    li_FileNum , loops, i , lvi_count
				long   flen, bytes_read , bytes_read_sum , new_pos
				blob   LIB_FILE , b
				string is_filename, is_fullname
				double LVS_SEQ_NO
				datetime LVS_REG_DATE
						
						IF  ROW < 1 THEN 
							 RETURN
						END IF
						
						LVS_SEQ_NO = dw_work_board_content.OBJECT.SEQ_NO[ROW]
						LVS_REG_DATE  = dw_work_board_content.OBJECT.REG_DATE[ROW]
						IF ISNULL(LVS_SEQ_NO) THEN 
							RETURN
						END IF		
				
						IF dw_work_board_content.UPDATE() < 0 THEN 
							RETURN
						END IF
						
						if GetFileOpenName("Select File", is_fullname, is_filename, "DWG", &
							 + "PPT Files (*.ppt),*.PPT," &
							 + "DWG Files (*.dwg),*.DWG," &
							 + "GIF Files (*.gif),*.GIF," &
							 + "BMP Files (*.bmp),*.BMP," &			 
							 + "JPG Files (*.jpg),*.JPG," &			 
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
									  from ISYS_PUB_WORK_BOARD
									 WHERE SEQ_NO   = :LVS_SEQ_NO 
										 AND REG_DATE    = :LVS_REG_DATE
										 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
										  
									IF F_SQL_CHECK() < 0 THEN 
										RETURN
									END IF				  
									
									if lvi_count = 0 then 
										ROLLBACK;									
										F_MSGBOX1( 9021 , is_filename ) 
										return
									end if
										  
									UPDATEBLOB ISYS_PUB_WORK_BOARD SET ATTACH_DATA = :LIB_FILE 
									        WHERE SEQ_NO      = :LVS_SEQ_NO
									             AND REG_DATE       = :LVS_REG_DATE
									             AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
				
								  IF SQLCA.SQLNROWS > 0 THEN
				
								  ELSE
									  ROLLBACK ;
									  MESSAGEBOX("Error" , is_filename+" File Upload To Database Failed" )
									  RETURN
									  
								  END IF;
								  
									UPDATE ISYS_PUB_WORK_BOARD SET FILE_NAME = :is_filename 
									WHERE SEQ_NO      = :LVS_SEQ_NO
									AND REG_DATE       = :LVS_REG_DATE
									AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;				  
						
								  IF F_SQL_CHECK() < 0 THEN 
									  RETURN
								  END IF		  
								  
								  COMMIT ;
								  F_MSGBOX(9022)
				
						END IF
				Changedirectory(Gvs_default_directory)

end if

end event

type dw_report from so_datawindow within w_wallpaper
integer y = 272
integer width = 4393
integer height = 1292
integer taborder = 20
boolean titlebar = true
string title = "Work Board"
string dataobject = "d_sys_pub_work_board_rpt"
boolean maxbox = true
boolean vscrollbar = true
boolean resizable = true
string icon = "DataWindow5!"
boolean hsplitscroll = true
end type

event clicked;if dwo.name = 'b_recipients' then
	
	open(w_user_popup)
	
	if gst_return.gvb_return = true  then 
		if this.object.message_recipients[row] = '' or isnull(this.object.message_recipients[row]) then 
			this.object.message_recipients[row] =Gst_return.Gvs_return[1]
		else
			this.object.message_recipients[row] =this.object.message_recipients[row]  + ';'+Gst_return.Gvs_return[1]
		end if 
	end if 
	
elseif dwo.name = 'b_attach' then 
			
				int    li_FileNum , loops, i , lvi_count
				long   flen, bytes_read , bytes_read_sum , new_pos
				blob   LIB_FILE , b
				string is_filename, is_fullname
				double LVS_SEQ_NO
				datetime LVS_REG_DATE
						
						IF  ROW < 1 THEN 
							 RETURN
						END IF
						
						LVS_SEQ_NO = dw_work_board_content.OBJECT.SEQ_NO[ROW]
						LVS_REG_DATE  = dw_work_board_content.OBJECT.REG_DATE[ROW]
						IF ISNULL(LVS_SEQ_NO) THEN 
							RETURN
						END IF		
				
						IF dw_work_board_content.UPDATE() < 0 THEN 
							RETURN
						END IF
						
						if GetFileOpenName("Select File", is_fullname, is_filename, "DWG", &
							 + "PPT Files (*.ppt),*.PPT," &
							 + "DWG Files (*.dwg),*.DWG," &
							 + "GIF Files (*.gif),*.GIF," &
							 + "BMP Files (*.bmp),*.BMP," &			 
							 + "JPG Files (*.jpg),*.JPG," &			 
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
									  from ISYS_PUB_WORK_BOARD
									 WHERE SEQ_NO   = :LVS_SEQ_NO 
										 AND REG_DATE    = :LVS_REG_DATE
										 AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
										  
									IF F_SQL_CHECK() < 0 THEN 
										RETURN
									END IF				  
									
									if lvi_count = 0 then 
										ROLLBACK;									
										F_MSGBOX1( 9021 , is_filename ) 
										return
									end if
										  
									UPDATEBLOB ISYS_PUB_WORK_BOARD SET ATTACH_DATA = :LIB_FILE 
									        WHERE SEQ_NO      = :LVS_SEQ_NO
									             AND REG_DATE       = :LVS_REG_DATE
									             AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
				
								  IF SQLCA.SQLNROWS > 0 THEN
				
								  ELSE
									  ROLLBACK ;
									  MESSAGEBOX("Error" , is_filename+" File Upload To Database Failed" )
									  RETURN
									  
								  END IF;
								  
									UPDATE ISYS_PUB_WORK_BOARD SET FILE_NAME = :is_filename 
									WHERE SEQ_NO      = :LVS_SEQ_NO
									AND REG_DATE       = :LVS_REG_DATE
									AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;				  
						
								  IF F_SQL_CHECK() < 0 THEN 
									  RETURN
								  END IF		  
								  
								  COMMIT ;
								  F_MSGBOX(9022)
				
						END IF
				Changedirectory(Gvs_default_directory)

end if

end event


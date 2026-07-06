HA$PBExportHeader$w_error_log_trace.srw
$PBExportComments$Dual Language Information Manage
forward
global type w_error_log_trace from w_main_root
end type
type sle_window_name from so_singlelineedit within w_error_log_trace
end type
type st_1 from so_statictext within w_error_log_trace
end type
type cb_1 from commandbutton within w_error_log_trace
end type
type gb_1 from so_groupbox within w_error_log_trace
end type
type gb_2 from so_groupbox within w_error_log_trace
end type
end forward

global type w_error_log_trace from w_main_root
integer width = 4553
integer height = 2516
string title = "System Error Log Trace Master"
sle_window_name sle_window_name
st_1 st_1
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
end type
global w_error_log_trace w_error_log_trace

type variables
datawindow ivd_data_window
end variables

on w_error_log_trace.create
int iCurrent
call super::create
this.sle_window_name=create sle_window_name
this.st_1=create st_1
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_window_name
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.gb_2
end on

on w_error_log_trace.destroy
call super::destroy
destroy(this.sle_window_name)
destroy(this.st_1)
destroy(this.cb_1)
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
ivs_modify_security = 'N' 
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

F_MENU_CONTROL('DATA_CONTROL_MODIFY' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long ROW
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
			DW_1.RESET()
			DW_2.RESET()
			DW_1.RETRIEVE( sle_window_name.text+'%' , gvi_organization_id )
			DW_1.SETFOCUS()

	CASE 'DELETE'
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
		
          	IF DW_1.UPDATE() < 0 THEN
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

type dw_5 from w_main_root`dw_5 within w_error_log_trace
integer y = 268
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_error_log_trace
integer y = 268
integer taborder = 50
end type

type dw_3 from w_main_root`dw_3 within w_error_log_trace
integer y = 268
integer taborder = 60
end type

type dw_2 from w_main_root`dw_2 within w_error_log_trace
integer y = 1260
integer width = 4507
integer height = 1144
integer taborder = 70
string dataobject = "d_error_log_trace_mst"
end type

type dw_1 from w_main_root`dw_1 within w_error_log_trace
integer y = 268
integer width = 4507
integer height = 984
integer taborder = 0
boolean titlebar = true
string title = "System Error Log Trace List"
string dataobject = "d_error_log_trace"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
dw_2.retrieve( dw_1.object.rowid[currentrow])
end event

type sle_window_name from so_singlelineedit within w_error_log_trace
integer x = 87
integer y = 148
integer width = 782
integer taborder = 10
boolean bringtotop = true
end type

type st_1 from so_statictext within w_error_log_trace
integer x = 87
integer y = 72
integer width = 782
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Window Name"
end type

type cb_1 from commandbutton within w_error_log_trace
integer x = 987
integer y = 108
integer width = 613
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Quick Delete ( All)"
end type

event clicked;MSG = F_MSGBOX( 1003 )
IF MSG = 1 THEN
	
	DELETE FROM "ISYS_ERROR_TRACE"   WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	IF F_SQL_CHECK() < 0 THEN 
		ROLLBACK ;
	ELSE
		COMMIT ;
		F_MSG_MDI_HELP( F_MSG_ST(170 ))
		F_RETRIEVE()
	END IF

ELSE
	
END IF
end event

type gb_1 from so_groupbox within w_error_log_trace
integer x = 9
integer width = 933
integer height = 260
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_error_log_trace
integer x = 946
integer width = 695
integer height = 260
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


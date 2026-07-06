HA$PBExportHeader$w_mcn_machine_daily_operation.srw
$PBExportComments$Customer Infromation Manage
forward
global type w_mcn_machine_daily_operation from w_main_root
end type
type st_1 from so_statictext within w_mcn_machine_daily_operation
end type
type sle_machine_code from so_singlelineedit within w_mcn_machine_daily_operation
end type
type ddlb_machine_type from uo_basecode within w_mcn_machine_daily_operation
end type
type st_2 from so_statictext within w_mcn_machine_daily_operation
end type
type st_line_code from statictext within w_mcn_machine_daily_operation
end type
type ddlb_line_code from uo_line_code within w_mcn_machine_daily_operation
end type
type ddlb_acquisition_type from uo_basecode within w_mcn_machine_daily_operation
end type
type st_4 from statictext within w_mcn_machine_daily_operation
end type
type st_7 from so_statictext within w_mcn_machine_daily_operation
end type
type uo_dateset from uo_ymdh_calendar within w_mcn_machine_daily_operation
end type
type uo_dateend from uo_ymdh_calendar within w_mcn_machine_daily_operation
end type
type gb_2 from groupbox within w_mcn_machine_daily_operation
end type
end forward

global type w_mcn_machine_daily_operation from w_main_root
integer y = 256
integer width = 5367
integer height = 3104
string title = "Machine Daily Operation Master"
st_1 st_1
sle_machine_code sle_machine_code
ddlb_machine_type ddlb_machine_type
st_2 st_2
st_line_code st_line_code
ddlb_line_code ddlb_line_code
ddlb_acquisition_type ddlb_acquisition_type
st_4 st_4
st_7 st_7
uo_dateset uo_dateset
uo_dateend uo_dateend
gb_2 gb_2
end type
global w_mcn_machine_daily_operation w_mcn_machine_daily_operation

on w_mcn_machine_daily_operation.create
int iCurrent
call super::create
this.st_1=create st_1
this.sle_machine_code=create sle_machine_code
this.ddlb_machine_type=create ddlb_machine_type
this.st_2=create st_2
this.st_line_code=create st_line_code
this.ddlb_line_code=create ddlb_line_code
this.ddlb_acquisition_type=create ddlb_acquisition_type
this.st_4=create st_4
this.st_7=create st_7
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_machine_code
this.Control[iCurrent+3]=this.ddlb_machine_type
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_line_code
this.Control[iCurrent+6]=this.ddlb_line_code
this.Control[iCurrent+7]=this.ddlb_acquisition_type
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.st_7
this.Control[iCurrent+10]=this.uo_dateset
this.Control[iCurrent+11]=this.uo_dateend
this.Control[iCurrent+12]=this.gb_2
end on

on w_mcn_machine_daily_operation.destroy
call super::destroy
destroy(this.st_1)
destroy(this.sle_machine_code)
destroy(this.ddlb_machine_type)
destroy(this.st_2)
destroy(this.st_line_code)
destroy(this.ddlb_line_code)
destroy(this.ddlb_acquisition_type)
destroy(this.st_4)
destroy(this.st_7)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
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

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_RCV_ISS_TYPE

CHOOSE CASE Gvs_Ue_DATA_control
	CASE 'RETRIEVE'
		
			DW_1.RESET( )
			DW_2.RESET( )					
		

			DW_1.RETRIEVE(  sle_machine_code.text+'%' , ddlb_machine_type.getcode( )+'%' , ddlb_line_code.getcode( )+'%'  , ddlb_Acquisition_Type.getcode( )+'%' ,  gvi_organization_id )
			 
			 
	CASE	'INSERT'
		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')				
			DW_2.OBJECT.PLAN_DATE[ROW] = f_t_sysdate()
			DW_2.OBJECT.start_time[ROW]   = f_t_sysdate()
			DW_2.OBJECT.end_time[ROW]    = DATE('9999-12-31')
			
			dw_2.object.machine_operation_sequence[row] = f_get_sequence( 'SEQ_MCN_OPERATION_SEQUENCE' )
			
			if dw_1.getrow() < 1 then 
			else
				dw_2.object.machine_code[row] = dw_1.object.machine_code[dw_1.getrow()]
				dw_2.object.line_code[row] = dw_1.object.line_code[dw_1.getrow()]
				dw_2.object.workstage_code[row] = dw_1.object.workstage_code[dw_1.getrow()]				
			end if
			
			dw_2.object.machine_running_sequence[row] = f_get_sequence('seq_machine_running')
	CASE 'APPEND'
		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(0)
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')				
			DW_2.OBJECT.PLAN_DATE[ROW] = f_t_sysdate()
			DW_2.OBJECT.start_time[ROW] = f_t_sysdate()
			DW_2.OBJECT.end_time[ROW] = f_t_sysdate()			
			
			dw_2.object.machine_operation_sequence[row] = f_get_sequence( 'SEQ_MCN_OPERATION_SEQUENCE' )
			
			if dw_1.getrow() < 1 then 
			else
				dw_2.object.machine_code[row] = dw_1.object.machine_code[dw_1.getrow()]
				dw_2.object.line_code[row] = dw_1.object.line_code[dw_1.getrow()]
				dw_2.object.workstage_code[row] = dw_1.object.workstage_code[dw_1.getrow()]				
			end if
			
			dw_2.object.machine_running_sequence[row] = f_get_sequence('seq_machine_running')
		
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

	         IF DW_2.UPDATE() < 0 THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF

 		
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

/****************************************
* $$HEX19$$dcb46db8e4b2b4c6200070b374c7c0d0200008c7c4b3b0c620007cc704ad20005cb8dcb42000$$ENDHEX$$
*****************************************/
WF_SET_COLUMN_DDDW()
end event

type dw_5 from w_main_root`dw_5 within w_mcn_machine_daily_operation
integer y = 356
end type

type dw_4 from w_main_root`dw_4 within w_mcn_machine_daily_operation
integer y = 356
integer taborder = 80
end type

type dw_3 from w_main_root`dw_3 within w_mcn_machine_daily_operation
integer y = 356
integer taborder = 70
end type

type dw_2 from w_main_root`dw_2 within w_mcn_machine_daily_operation
string tag = "Machine Daily Operation List"
integer x = 5
integer y = 1012
integer width = 4599
integer height = 944
integer taborder = 100
boolean titlebar = true
string title = "Machine Daily Operation List"
string dataobject = "d_mcn_machine_daily_operation_mlst"
end type

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'mold_code' then 
	open(w_mcn_mold_popup)	
	if  gst_return.gvb_return  = true then
	   this.object.mold_code[row] = message.stringparm
	   this.trigger event itemchanged( row , this.object.mold_code , this.object.mold_code[row] )
		
		
	end if	
	
end if
end event

event dw_2::itemchanged;call super::itemchanged;int lvi_day , lvi_start_minsum ,lvi_end_minsum ,  lvi_start_hour , lvi_start_min ,  lvi_end_hour , lvi_end_min
time lvdt_start_time , lvdt_end_time

this.accepttext()

if dwo.name = 'start_time' or dwo.name = 'end_time' then
	
	
	lvi_day = DaysAfter( Date(this.object.start_time[row]) , date(this.object.end_time[row]))
	
	if lvi_day < 0 then 
		//Mes sagebox("Notify" , "Start Date Invalid")		
		f_msg( "Start Date Invalid",'P') 
		return 2
	end if
		
	if lvi_day > 1  then 
		//Mes sagebox("Notify" , "Date Term Invalid")
		f_msg( "Date Term Invalid",'P')
		return 2
	end if
	
	
	if lvi_day = 0 then 
	
	
			lvdt_start_time = Time( string( this.object.start_time[row] , 'hh:mm:ss') )
			
			lvi_start_hour  =Integer( Hour(lvdt_start_time))
			
			if lvi_start_hour = 0 then 
				lvi_start_hour = 24
			end if
			
			lvi_end_min   = Integer(minute(lvdt_start_time))
			
			
			lvdt_end_time = Time( string( this.object.end_time[row] , 'hh:mm:ss') )
			
			
			lvi_end_hour  =Integer( Hour(lvdt_end_time))
			if lvi_end_hour = 0 then 
				lvi_end_hour = 0
			end if
			
			lvi_end_min  =Integer(minute(lvdt_end_time))
			
			
			lvi_start_minsum = lvi_start_hour * 60 + lvi_start_min
			lvi_end_minsum = lvi_end_hour * 60 + lvi_end_min
			
			
			this.object.total_operation_time[row] = INTEGER( lvi_end_minsum - lvi_start_minsum )
			
		else
			
			lvdt_start_time = Time( string( this.object.start_time[row] , 'hh:mm:ss') )
			
			lvi_start_hour  =Integer( Hour(lvdt_start_time))
			
			if lvi_start_hour = 0 then 
				lvi_start_hour = 24
			end if
			
			lvi_end_min   = Integer(minute(lvdt_start_time))
			
			
			lvdt_end_time = Time( string( this.object.end_time[row] , 'hh:mm:ss') )
			
			
			lvi_end_hour  =Integer( Hour(lvdt_end_time))
			if lvi_end_hour = 0 then 
				lvi_end_hour = 24
			else
				lvi_end_hour = lvi_end_hour + 24
			end if
			
			lvi_end_min  =Integer(minute(lvdt_end_time))
			
			
			lvi_start_minsum = lvi_start_hour * 60 + lvi_start_min
			lvi_end_minsum = lvi_end_hour * 60 + lvi_end_min
			
			
			this.object.total_operation_time[row] = INTEGER( lvi_end_minsum - lvi_start_minsum )			
			
		end if
	
end if
end event

type dw_1 from w_main_root`dw_1 within w_mcn_machine_daily_operation
integer y = 284
integer width = 4599
integer height = 728
boolean titlebar = true
string title = "Machine List"
string dataobject = "d_mcn_machine_lst"
end type

event dw_1::doubleclicked;call super::doubleclicked;string lvs_start, lvs_end 
	
IF	ROW < 1	THEN	RETURN

lvs_start = string(uo_dateset.text(),'YYYYMMDDHH') 
lvs_end  = string(uo_dateend.text(),'YYYYMMDDHH')
			
			
DW_2.RETRIEVE( this.object.machine_code[row] , lvs_start,  lvs_end , gvi_organization_id  )
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;string lvs_start, lvs_end 

IF	CURRENTROW < 1	THEN	RETURN


lvs_start = string(uo_dateset.text(),'YYYYMMDDHH') 
lvs_end  = string(uo_dateend.text(),'YYYYMMDDHH')
			
			
DW_2.RETRIEVE( this.object.machine_code[CURRENTROW] , lvs_start,  lvs_end , gvi_organization_id  )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_machine_daily_operation
end type

type st_1 from so_statictext within w_mcn_machine_daily_operation
integer x = 55
integer y = 80
integer width = 471
integer height = 68
boolean bringtotop = true
string text = "Machine Code"
end type

type sle_machine_code from so_singlelineedit within w_mcn_machine_daily_operation
integer x = 55
integer y = 156
integer width = 471
integer taborder = 30
boolean bringtotop = true
end type

type ddlb_machine_type from uo_basecode within w_mcn_machine_daily_operation
integer x = 535
integer y = 152
integer width = 745
integer height = 1988
integer taborder = 40
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;this.redraw( 'MACHINE TYPE')
end event

type st_2 from so_statictext within w_mcn_machine_daily_operation
integer x = 535
integer y = 76
integer width = 745
integer height = 68
boolean bringtotop = true
long textcolor = 0
string text = "Machine Type"
end type

type st_line_code from statictext within w_mcn_machine_daily_operation
integer x = 1298
integer y = 72
integer width = 494
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_line_code from uo_line_code within w_mcn_machine_daily_operation
integer x = 1294
integer y = 148
integer width = 494
integer height = 1876
integer taborder = 80
boolean bringtotop = true
end type

type ddlb_acquisition_type from uo_basecode within w_mcn_machine_daily_operation
integer x = 1797
integer y = 148
integer width = 448
integer height = 1552
integer taborder = 90
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'ACQUISITION TYPE')
end event

type st_4 from statictext within w_mcn_machine_daily_operation
integer x = 1797
integer y = 76
integer width = 448
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Acquisition Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_7 from so_statictext within w_mcn_machine_daily_operation
integer x = 2258
integer y = 52
integer width = 1317
boolean bringtotop = true
string text = "Date"
end type

type uo_dateset from uo_ymdh_calendar within w_mcn_machine_daily_operation
integer x = 2254
integer y = 144
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymdh_calendar::destroy
end on

type uo_dateend from uo_ymdh_calendar within w_mcn_machine_daily_operation
integer x = 2926
integer y = 144
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymdh_calendar::destroy
end on

type gb_2 from groupbox within w_mcn_machine_daily_operation
integer x = 9
integer width = 3611
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


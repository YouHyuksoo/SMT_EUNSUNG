HA$PBExportHeader$w_pln_line_capacity_master.srw
$PBExportComments$Line Capacity Master
forward
global type w_pln_line_capacity_master from w_main_root
end type
type st_line_code from statictext within w_pln_line_capacity_master
end type
type ddlb_line_code from uo_line_code within w_pln_line_capacity_master
end type
type rb_shift1 from so_radiobutton within w_pln_line_capacity_master
end type
type rb_shift2 from so_radiobutton within w_pln_line_capacity_master
end type
type rb_shift3 from so_radiobutton within w_pln_line_capacity_master
end type
type cb_1 from so_commandbutton within w_pln_line_capacity_master
end type
type cb_2 from so_commandbutton within w_pln_line_capacity_master
end type
type cb_3 from so_commandbutton within w_pln_line_capacity_master
end type
type st_4 from so_statictext within w_pln_line_capacity_master
end type
type uo_dateset from uo_ymd_calendar within w_pln_line_capacity_master
end type
type uo_dateend from uo_ymd_calendar within w_pln_line_capacity_master
end type
type em_att_direct_qty from so_editmask within w_pln_line_capacity_master
end type
type em_att_indirect_qty from so_editmask within w_pln_line_capacity_master
end type
type st_3 from so_statictext within w_pln_line_capacity_master
end type
type st_5 from so_statictext within w_pln_line_capacity_master
end type
type gb_1 from so_groupbox within w_pln_line_capacity_master
end type
type gb_2 from so_groupbox within w_pln_line_capacity_master
end type
type gb_3 from so_groupbox within w_pln_line_capacity_master
end type
end forward

global type w_pln_line_capacity_master from w_main_root
integer width = 4608
integer height = 2852
string title = ""
st_line_code st_line_code
ddlb_line_code ddlb_line_code
rb_shift1 rb_shift1
rb_shift2 rb_shift2
rb_shift3 rb_shift3
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
st_4 st_4
uo_dateset uo_dateset
uo_dateend uo_dateend
em_att_direct_qty em_att_direct_qty
em_att_indirect_qty em_att_indirect_qty
st_3 st_3
st_5 st_5
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_pln_line_capacity_master w_pln_line_capacity_master

on w_pln_line_capacity_master.create
int iCurrent
call super::create
this.st_line_code=create st_line_code
this.ddlb_line_code=create ddlb_line_code
this.rb_shift1=create rb_shift1
this.rb_shift2=create rb_shift2
this.rb_shift3=create rb_shift3
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.st_4=create st_4
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.em_att_direct_qty=create em_att_direct_qty
this.em_att_indirect_qty=create em_att_indirect_qty
this.st_3=create st_3
this.st_5=create st_5
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_line_code
this.Control[iCurrent+2]=this.ddlb_line_code
this.Control[iCurrent+3]=this.rb_shift1
this.Control[iCurrent+4]=this.rb_shift2
this.Control[iCurrent+5]=this.rb_shift3
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.uo_dateset
this.Control[iCurrent+11]=this.uo_dateend
this.Control[iCurrent+12]=this.em_att_direct_qty
this.Control[iCurrent+13]=this.em_att_indirect_qty
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.st_5
this.Control[iCurrent+16]=this.gb_1
this.Control[iCurrent+17]=this.gb_2
this.Control[iCurrent+18]=this.gb_3
end on

on w_pln_line_capacity_master.destroy
call super::destroy
destroy(this.st_line_code)
destroy(this.ddlb_line_code)
destroy(this.rb_shift1)
destroy(this.rb_shift2)
destroy(this.rb_shift3)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.st_4)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.em_att_direct_qty)
destroy(this.em_att_indirect_qty)
destroy(this.st_3)
destroy(this.st_5)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
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
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control




end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		     dw_1.reset( )
			dw_2.reset( )  
			dw_1.retrieve( ddlb_line_code.getcode() + '%', gvi_organization_id)
			dw_1.setfocus()
			
	case 'INSERT'		
			row = dw_2.insertrow(dw_2.getrow())
			dw_2.scrolltorow(row)		
			f_set_security_row(dw_2 , row , 'ALL')
			f_msg_mdi_help(f_msg_st(152))
			
	case 'APPEND'		
			row = dw_2.insertrow(0)
			dw_2.scrolltorow(row)			
			f_set_security_row(dw_2 , row , 'ALL')	
			f_msg_mdi_help(f_msg_st(152))		
			
	case 'DELETE'
		
		  	if dw_2.getrow() < 1 then return 
			  
			msg =f_msgbox(1003)
			if msg = 1 then
				gvl_row_deleted = dw_2.getrow()			
				dw_2.deleterow(gvl_row_deleted)		
				dw_2.setfocus()
				row = dw_2.getrow()
				dw_2.scrolltorow(row)
				dw_2.setcolumn(1)
			end if
			
	case 'UPDATE'
		
			if dw_2.update() < 0 then
				rollback;
			else
				commit;
				f_msg_mdi_help(f_msg_st(170))
			end if
			
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_pln_line_capacity_master
integer y = 568
end type

type dw_4 from w_main_root`dw_4 within w_pln_line_capacity_master
integer y = 568
end type

type dw_3 from w_main_root`dw_3 within w_pln_line_capacity_master
integer y = 568
end type

type dw_2 from w_main_root`dw_2 within w_pln_line_capacity_master
integer x = 2043
integer y = 576
integer width = 2496
integer height = 1520
boolean titlebar = true
string title = "Daily Line Capacity List"
string dataobject = "d_pln_line_daily_capacity_lst"
end type

event dw_2::itemchanged;call super::itemchanged;DECIMAL LVF_CAPACITY
DECIMAL LVF_WORK_TIME , LVF_TOTAL_WORK_TIME , LVF_TOTAL_IDLE_TIME , LVF_WORK_CAPACITY , LVF_ATTENDACE_TOTAL

//THIS.ACCEPTTEXT()
//LVF_CAPACITY= F_GET_MACHINE_CAPACITY(  THIS.OBJECT.DEPT_CODE[ROW], &
//												  +THIS.OBJECT.LINE_CODE[ROW], &
//												  +THIS.OBJECT.WORKSTAGE_CODE[ROW], &
//												  +THIS.OBJECT.MACHINE_CODE[ROW], &
//												  +THIS.OBJECT.MOLD_CODE[ROW]  )
//IF LVF_CAPACITY < 0 THEN
//	THIS.SETITEM( ROW , 'capacity' , 	0 )
//	THIS.SETITEM( ROW , 'work_capacity' , 	0 )	
//ELSE


	LVF_TOTAL_WORK_TIME = THIS.OBJECT.TOTAL_WORK_TIME[ROW]
	LVF_TOTAL_IDLE_TIME    = THIS.OBJECT.TOTAL_IDLE_TIME[ROW]
//	LVF_CAPACITY             = LVF_TOTAL_WORK_TIME - LVF_TOTAL_IDLE_TIME
	LVF_ATTENDACE_TOTAL  = THIS.OBJECT.ATTENDANCE_TOTAL[ROW]	

//	THIS.SETITEM( ROW , 'capacity' , 	LVF_CAPACITY  )
	THIS.SETITEM( ROW , 'work_capacity' , LVF_CAPACITY * 	LVF_TOTAL_WORK_TIME * LVF_ATTENDACE_TOTAL)	
//END IF


							
end event

type dw_1 from w_main_root`dw_1 within w_pln_line_capacity_master
integer y = 576
integer width = 2043
integer height = 1520
boolean titlebar = true
string title = "Line Capacity Master"
string dataobject = "d_pln_line_capacity_lst"
end type

event dw_1::itemchanged;call super::itemchanged;string lvs_return
if dwo.name = 'line_code' then 
	
//	lvs_return = f_get_line_name( data )
	if lvs_return = 'ERROR' then 
	   return 1
	elseif lvs_return = 'NOTFOUND' then 
	  return 1
     end if
	  
	this.object.line_name[row] = lvs_return  
end if 
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return

	dw_2.retrieve( dw_1.object.line_code[currentrow] , uo_dateset.text() , uo_dateend.text()  , gvi_organization_id )
	
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_line_capacity_master
end type

type st_line_code from statictext within w_pln_line_capacity_master
integer x = 41
integer y = 104
integer width = 942
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

type ddlb_line_code from uo_line_code within w_pln_line_capacity_master
integer x = 41
integer y = 172
integer width = 942
integer taborder = 20
boolean bringtotop = true
end type

type rb_shift1 from so_radiobutton within w_pln_line_capacity_master
integer x = 2039
integer y = 120
boolean bringtotop = true
integer weight = 700
string text = "1 Shift(8Hour)"
boolean checked = true
end type

type rb_shift2 from so_radiobutton within w_pln_line_capacity_master
integer x = 2039
integer y = 252
boolean bringtotop = true
integer weight = 700
string text = "2 Shift(16Hour)"
end type

type rb_shift3 from so_radiobutton within w_pln_line_capacity_master
integer x = 2043
integer y = 388
boolean bringtotop = true
integer weight = 700
string text = "3 Shift(24Hour)"
end type

type cb_1 from so_commandbutton within w_pln_line_capacity_master
integer x = 41
integer y = 396
integer width = 608
integer height = 112
integer taborder = 20
boolean bringtotop = true
string text = "Crear"
end type

event clicked;call super::clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
STRING    LVS_LINE_CODE 
DATETIME LVD_START , LVD_END

MSG = F_MSGBOX(9062) //$$HEX19$$74c704c8d0c52000ddc031c11cb42000f4bc20c7f5ac18c27cb92000adc01cc860d54cae94c6$$ENDHEX$$?
IF MSG = 1 THEN 
	
ELSE
	RETURN
END IF

LVD_START = UO_DATESET.TEXT()
LVD_END   = UO_DATEEND.TEXT()
LVS_LINE_CODE     = DDLB_LINE_CODE.TEXT+'%'

  DELETE FROM IP_PRODUCT_DAILY_LINE_CAPACITY
   WHERE "IP_PRODUCT_DAILY_LINE_CAPACITY"."PLAN_DATE"      >= :LVD_START
	  AND "IP_PRODUCT_DAILY_LINE_CAPACITY"."PLAN_DATE"      <= :LVD_END
  	  AND "IP_PRODUCT_DAILY_LINE_CAPACITY"."ORGANIZATION_ID" = :GVI_ORGANIZATION_ID 
	  AND "IP_PRODUCT_DAILY_LINE_CAPACITY"."LINE_CODE"      LIKE :LVS_LINE_CODE ;
	  
IF F_SQL_CHECK() < 0 THEN 
  RETURN
END IF
  
IF SQLCA.SQLNROWS < 1 THEN 
  F_MSGBOX(9026) //$$HEX12$$c0bcbdac1cb4200090c7ccb800ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$
  ROLLBACK ;
  RETURN
ELSE
  COMMIT; 
  F_MSG_MDI_HELP( F_MSG_ST(170 ) ) // $$HEX23$$74d5f9b2200090c7ccb800ac200031c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b220002000$$ENDHEX$$
END IF  
end event

type cb_2 from so_commandbutton within w_pln_line_capacity_master
integer x = 649
integer y = 396
integer width = 608
integer height = 112
integer taborder = 30
boolean bringtotop = true
string text = "Generate"
end type

event clicked;call super::clicked;STRING   LVS_LINE_CODE  , LVS_SHIFT
DATETIME LVD_START , LVD_END
LONG        LVL_COUNT , LVL_ATTENDANCE

LVD_START = uo_dateset.TEXT()
LVD_END     = uo_dateend.TEXT()
LVS_LINE_CODE     = DDLB_LINE_CODE.GETCODE()+'%'

LVL_ATTENDANCE = LONG(em_att_direct_qty.TEXT) + LONG(em_att_indirect_qty.text) 

//MSG = F_MSGBOX1(1161 , LVS_LINE_CODE+ +STRING(LVD_START, 'YYYY-MM-DD')+'-'+STRING(LVD_END, 'YYYY-MM-DD')+ +THIS.TEXT)
//IF MSG = 1 THEN 
//	
//ELSE
//	RETURN
//END IF
//==================================================
//
//==================================================

//LONG I , J
//DOUBLE  LVDB_SHIFT ,LVDB_IDLE_TIME , LVDB_OVER_TIME
IF RB_SHIFT1.CHECKED = TRUE THEN 
   LVS_SHIFT ='1'
ELSEIF RB_SHIFT2.CHECKED = TRUE THEN 
  LVS_SHIFT ='2'
ELSEIF RB_SHIFT3.CHECKED = TRUE THEN 
	 LVS_SHIFT ='2'
ELSE
	F_MSGBOX(9061) //$$HEX16$$50ad00b370c8200020c1ddd074c7200018b4c0c920004ac558c5b5c2c8b2e4b2$$ENDHEX$$
	RETURN	
END IF
//
//LVDB_IDLE_TIME = DEC(EM_IDLE_TIME.TEXT)
//IF ISNULL(LVDB_IDLE_TIME) THEN 
//	LVDB_IDLE_TIME = 0 
//END IF
//IF LVDB_IDLE_TIME = 0 THEN 
//	MSG = F_MSGBOX(9064) //$$HEX6$$34d7ddc2dcc204ac74c72000$$ENDHEX$$0 $$HEX10$$85c7c8b2e4b22000c4ac8dc160d54cae94c62000$$ENDHEX$$?
//	IF MSG = 1 THEN 
//	ELSE
//		RETURN
//	END IF
//END IF
//
//LVDB_OVER_TIME = DEC(EM_OVER_TIME.TEXT)
//IF ISNULL(LVDB_OVER_TIME) THEN 
//	LVDB_OVER_TIME = 0 
//END IF
//
//IF LVDB_OVER_TIME = 0 THEN 
//	MSG = F_MSGBOX(9063) //$$HEX6$$94c7c5c5dcc204ac74c72000$$ENDHEX$$0 $$HEX10$$85c7c8b2e4b22000c4ac8dc160d54cae94c62000$$ENDHEX$$?
//	IF MSG = 1 THEN 
//	ELSE
//		RETURN
//	END IF
//END IF

//IF DW_2.GETROW() < 1 THEN 
//   RETURN
//END IF 

//==================================================================

MSG = F_MSGBOX1( 1161 , THIS.TEXT ) //@ $$HEX7$$7cb9200098ccacb960d54cae94c6$$ENDHEX$$?
IF MSG = 1 THEN 
ELSE
	RETURN
END IF

//==================================================================
//open(w_progress_popup)
//w_progress_popup.f_SET_RANGE( 0 , DW_2.ROWCOUNT() )
//w_progress_popup.f_SETSTEP(1)
//DO
//	I++
//	w_progress_popup.f_STEPIT()
//	IF DW_2.OBJECT.CHECK_YN[I] = 'Y' THEN 
//	   J++	
//	ELSE
//		CONTINUE
//	END IF
	
//	IF DW_2.OBJECT.HOLIDAY_YN[I] = 'Y' THEN
//		DW_2.SETITEM( I , 'total_work_time' , 0)
//		DW_2.SETITEM( I , 'total_idle_time' , 0)
//		DW_2.TRIGGER EVENT ITEMCHANGED( I , DW_2.OBJECT.total_work_time , STRING(DW_2.OBJECT.total_work_time[I]) )
//		DW_2.OBJECT.CHECK_YN[I] = 'N'		
//    ELSE
//		DW_2.SETITEM( I , 'total_work_time' , LVDB_SHIFT + LVDB_OVER_TIME )
//		DW_2.SETITEM( I , 'total_idle_time' , LVDB_IDLE_TIME)
//		DW_2.TRIGGER EVENT ITEMCHANGED( I , DW_2.OBJECT.total_work_time , STRING(DW_2.OBJECT.total_work_time[I]) )
//		DW_2.OBJECT.CHECK_YN[I] = 'N'
//   END IF
	
//f_msg_mdi_help(STRING(J)+'/'+STRING(DW_2.ROWCOUNT()))
//LOOP UNTIL I = DW_2.ROWCOUNT()

//close(w_progress_popup)
//IF J = 0 THEN 
	
//  F_MSGBOX1( 102 , 'Data') // $$HEX9$$90c7ccb800ac2000c6c5b5c2c8b2e4b22000$$ENDHEX$$
//ELSE
//	  MSG = F_MSGBOX(1170)
//	  IF MSG = 1 THEN 
//		  IF DW_2.UPDATE() < 0 THEN 
//			ROLLBACK;
//		ELSE
//			COMMIT ;
//		END IF
//	  END IF
	
//END IF



//==================================================
//$$HEX10$$d4c625b874c8acc7200020c734bb2000b4cc6cd0$$ENDHEX$$
//==================================================
SELECT COUNT(*) INTO :LVL_COUNT
    FROM IP_PRODUCT_LINE_CALENDAR,   IP_PRODUCT_LINE  
   WHERE IP_PRODUCT_LINE_CALENDAR.PLAN_DATE      >= :LVD_START
	  AND IP_PRODUCT_LINE_CALENDAR.PLAN_DATE      <= :LVD_END
  	  AND IP_PRODUCT_LINE_CALENDAR.ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
	  AND IP_PRODUCT_LINE_CALENDAR.LINE_CODE  LIKE :LVS_LINE_CODE
	  AND IP_PRODUCT_LINE_CALENDAR.LINE_CODE = IP_PRODUCT_LINE.LINE_CODE
	  AND IP_PRODUCT_LINE_CALENDAR.ORGANIZATION_ID = IP_PRODUCT_LINE.ORGANIZATION_ID ;	
	
  IF F_SQL_CHECK() < 0 THEN 
	 RETURN
  END IF 
  
  IF LVL_COUNT = 0 THEN 
	
	F_MSGBOX(9065) //$$HEX10$$d4c625b815c8f4bc00ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$.
	 RETURN
END IF

   DELETE FROM IP_PRODUCT_DAILY_LINE_CAPACITY
   WHERE IP_PRODUCT_DAILY_LINE_CAPACITY.PLAN_DATE      >= :LVD_START
	  AND IP_PRODUCT_DAILY_LINE_CAPACITY.PLAN_DATE      <= :LVD_END
  	  AND IP_PRODUCT_DAILY_LINE_CAPACITY.ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
	  AND IP_PRODUCT_DAILY_LINE_CAPACITY.LINE_CODE    LIKE :LVS_LINE_CODE ;
	  
	IF F_SQL_CHECK() < 0 THEN 
	  RETURN
	END IF
	


 INSERT INTO IP_PRODUCT_DAILY_LINE_CAPACITY  
                ( PLAN_DATE,   
			LINE_CODE,   
			ORGANIZATION_ID,  
			
			TOTAL_WORK_TIME,   
			TOTAL_IDLE_TIME,   
			
			CAPACITY,   
			WORK_CAPACITY, 
			RESERVED_CAPACITY ,
			HOLIDAY_YN,
			ENTER_BY,   
			ENTER_DATE,   
			LAST_MODIFY_BY,   
			LAST_MODIFY_DATE , 
			ATTENDANCE_TOTAL )  

      SELECT IP_PRODUCT_LINE_CALENDAR.PLAN_DATE,   
			IP_PRODUCT_LINE.LINE_CODE,   
			IP_PRODUCT_LINE.ORGANIZATION_ID,     
			
			NVL(F_GET_DAILY_TIME(  IP_PRODUCT_LINE_CALENDAR.PLAN_DATE, 'W' , :LVS_SHIFT ,  IP_PRODUCT_LINE.ORGANIZATION_ID ),0) + NVL( F_GET_DAILY_TIME(  IP_PRODUCT_LINE_CALENDAR.PLAN_DATE, 'O'  , :LVS_SHIFT ,IP_PRODUCT_LINE.ORGANIZATION_ID ),0)  ,
			NVL(F_GET_DAILY_TIME(  IP_PRODUCT_LINE_CALENDAR.PLAN_DATE, 'R' , :LVS_SHIFT , IP_PRODUCT_LINE.ORGANIZATION_ID ) ,0) , //$$HEX5$$34d7ddc22000dcc204ac$$ENDHEX$$
			NVL(IP_PRODUCT_LINE.CAPACITY ,1) ,
			( NVL(IP_PRODUCT_LINE.CAPACITY ,1)  * NVL(F_GET_DAILY_TIME(  IP_PRODUCT_LINE_CALENDAR.PLAN_DATE, 'W' , :LVS_SHIFT , IP_PRODUCT_LINE.ORGANIZATION_ID ),0) + NVL(F_GET_DAILY_TIME(  IP_PRODUCT_LINE_CALENDAR.PLAN_DATE, 'O' ,:LVS_SHIFT , IP_PRODUCT_LINE.ORGANIZATION_ID ),0) ), //* :LVL_ATTENDANCE , //IP_PRODUCT_LINE.CAPACITY,   
			0,
			IP_PRODUCT_LINE_CALENDAR.HOLIDAY_YN,
			:GVS_USER_ID,   
			SYSDATE,   
			:GVS_USER_ID,   
			SYSDATE ,
			:LVL_ATTENDANCE
 
    FROM IP_PRODUCT_LINE_CALENDAR,   IP_PRODUCT_LINE  
   WHERE IP_PRODUCT_LINE_CALENDAR.PLAN_DATE      >= :LVD_START
	  AND IP_PRODUCT_LINE_CALENDAR.PLAN_DATE      <= :LVD_END
  	  AND IP_PRODUCT_LINE_CALENDAR.ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
	  AND IP_PRODUCT_LINE_CALENDAR.LINE_CODE  LIKE :LVS_LINE_CODE
	  AND IP_PRODUCT_LINE_CALENDAR.LINE_CODE = IP_PRODUCT_LINE.LINE_CODE
	  AND IP_PRODUCT_LINE_CALENDAR.ORGANIZATION_ID = IP_PRODUCT_LINE.ORGANIZATION_ID ;
	  
  IF F_SQL_CHECK() < 0 THEN 
	  RETURN
  END IF
  
//  IF SQLCA.SQLNROWS < 1 THEN 
//	  F_MSGBOX(9026) //$$HEX12$$c0bcbdac1cb4200090c7ccb800ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$
//	  ROLLBACK ;
//	  RETURN
//  ELSE
	  COMMIT; 
	  F_MSGBOX(170)
	  F_MSG_MDI_HELP(F_MSG_ST(170) ) // $$HEX23$$74d5f9b2200090c7ccb800ac200031c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b220002000$$ENDHEX$$
//  END IF
end event

type cb_3 from so_commandbutton within w_pln_line_capacity_master
integer x = 1262
integer y = 396
integer width = 608
integer height = 112
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string text = "Reserved Capa Setup"
end type

type st_4 from so_statictext within w_pln_line_capacity_master
integer x = 1015
integer y = 92
integer width = 814
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Date"
end type

type uo_dateset from uo_ymd_calendar within w_pln_line_capacity_master
event destroy ( )
integer x = 1010
integer y = 172
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_pln_line_capacity_master
event destroy ( )
integer x = 1426
integer y = 172
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type em_att_direct_qty from so_editmask within w_pln_line_capacity_master
integer x = 2706
integer y = 172
integer taborder = 30
boolean bringtotop = true
string text = "0"
end type

type em_att_indirect_qty from so_editmask within w_pln_line_capacity_master
integer x = 3118
integer y = 172
integer taborder = 40
boolean bringtotop = true
string text = "0"
end type

type st_3 from so_statictext within w_pln_line_capacity_master
integer x = 2711
integer y = 80
integer width = 402
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Att Direct Qty"
end type

type st_5 from so_statictext within w_pln_line_capacity_master
integer x = 3127
integer y = 80
integer width = 402
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Att Indiret Qty"
end type

type gb_1 from so_groupbox within w_pln_line_capacity_master
integer y = 308
integer width = 1902
integer height = 244
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_pln_line_capacity_master
integer x = 9
integer width = 1883
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_pln_line_capacity_master
integer x = 1979
integer width = 1650
integer height = 548
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Worktime Setup"
end type


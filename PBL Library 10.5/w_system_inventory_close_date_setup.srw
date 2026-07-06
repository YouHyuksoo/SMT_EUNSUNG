HA$PBExportHeader$w_system_inventory_close_date_setup.srw
$PBExportComments$Dual Language Information Manage
forward
global type w_system_inventory_close_date_setup from w_main_root
end type
type cb_1 from so_commandbutton within w_system_inventory_close_date_setup
end type
type st_1 from so_statictext within w_system_inventory_close_date_setup
end type
type em_yyyy from uo_year within w_system_inventory_close_date_setup
end type
type cbx_beginning from so_checkbox within w_system_inventory_close_date_setup
end type
type sle_start_date from so_singlelineedit within w_system_inventory_close_date_setup
end type
type gb_1 from so_groupbox within w_system_inventory_close_date_setup
end type
type gb_2 from so_groupbox within w_system_inventory_close_date_setup
end type
end forward

global type w_system_inventory_close_date_setup from w_main_root
string title = "System Environment"
cb_1 cb_1
st_1 st_1
em_yyyy em_yyyy
cbx_beginning cbx_beginning
sle_start_date sle_start_date
gb_1 gb_1
gb_2 gb_2
end type
global w_system_inventory_close_date_setup w_system_inventory_close_date_setup

type variables
datawindow ivd_data_window
end variables

on w_system_inventory_close_date_setup.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.st_1=create st_1
this.em_yyyy=create em_yyyy
this.cbx_beginning=create cbx_beginning
this.sle_start_date=create sle_start_date
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_yyyy
this.Control[iCurrent+4]=this.cbx_beginning
this.Control[iCurrent+5]=this.sle_start_date
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.gb_2
end on

on w_system_inventory_close_date_setup.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.em_yyyy)
destroy(this.cbx_beginning)
destroy(this.sle_start_date)
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
Ivs_resize_type    = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
			DW_1.RETRIEVE(em_yyyy.text+'01' , em_yyyy.text+'12' ,Gvi_organization_id )
			DW_1.GRoupcalc( )
			DW_1.SETFOCUS()
			
	CASE 'INSERT'
			ROW = DW_1.INSERTROW(DW_1.GETROW())
			DW_1.SCROLLTOROW(ROW)
			DW_1.GRoupcalc( )
			F_SET_SECURITY_ROW(DW_1 , ROW , 'ALL')
	CASE 'APPEND'
			ROW = DW_1.INSERTROW(0)
			DW_1.SCROLLTOROW(ROW)
			DW_1.GRoupcalc( )			
			F_SET_SECURITY_ROW(DW_1 , ROW , 'ALL')	
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
				 F_MSG_MDI_HELP( "Update Complete" ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
			
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

type dw_5 from w_main_root`dw_5 within w_system_inventory_close_date_setup
integer y = 296
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_system_inventory_close_date_setup
integer y = 296
integer taborder = 50
end type

type dw_3 from w_main_root`dw_3 within w_system_inventory_close_date_setup
integer y = 300
integer taborder = 60
end type

type dw_2 from w_main_root`dw_2 within w_system_inventory_close_date_setup
integer y = 300
integer taborder = 70
end type

type dw_1 from w_main_root`dw_1 within w_system_inventory_close_date_setup
integer y = 300
integer width = 4507
integer height = 1948
integer taborder = 0
boolean titlebar = true
string title = "Inventory Close Date"
string dataobject = "d_system_inventory_close_date_setup"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_system_inventory_close_date_setup
end type

type cb_1 from so_commandbutton within w_system_inventory_close_date_setup
integer x = 1824
integer y = 72
integer width = 443
integer height = 168
integer taborder = 20
boolean bringtotop = true
string text = "Generate"
end type

event clicked;call super::clicked;msg = f_msgbox1(1161 , this.text)
if msg = 1 then 
else
	return
end if

STRING LVS_YYYY ,LVS_YYYY_LAST
INT I , LVi_START_DATE
LVS_YYYY = em_yyyy.text


delete from ISYS_INVENTORY_CLOSE_DATE where CLOSE_YYYYMM LIKE :LVS_YYYY||'%' 
AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

IF F_SQL_CHECK() < 0 THEN 
	RETURN
END IF


if cbx_beginning.checked = true then

			DO
				I++

			  INSERT INTO ISYS_INVENTORY_CLOSE_DATE
					 ( "CLOSE_YYYYMM",   
					   "ORGANIZATION_ID",   
					   "START_DATE",   
					   "END_DATE",   
					   "ENTER_DATE",   
					   "ENTER_BY",   
					   "LAST_MODIFY_DATE",   
					   "LAST_MODIFY_BY" )  
					   
					   
				  VALUES ( :LVS_YYYY||TRIM(TO_CHAR( :I , '00'))	 ,
							:GVI_ORGANIZATION_ID ,
							TO_DATE(:LVS_YYYY||TRIM(TO_CHAR( :I , '00')||'01') , 'YYYYMMDD') ,
							LAST_DAY(TO_DATE(:LVS_YYYY||TRIM(TO_CHAR(:I , '00')||'01'), 'YYYYMMDD')) ,	  
							SYSDATE ,
							:GVS_USER_ID , 
							SYSDATE ,
							:GVS_USER_ID )	 ;
							
			IF F_SQL_CHECK() < 0 THEN 
				RETURN
			END IF
			
			LOOP UNTIL I = 12

else
	LVI_START_DATE = INTEGER(sle_start_date.text)
	
			DO
				I++
			 if I = 1 then 
				LVS_YYYY_LAST = string(integer(LVS_YYYY) - 1)	
			  INSERT INTO ISYS_INVENTORY_CLOSE_DATE
					 ( "CLOSE_YYYYMM",   
					   "ORGANIZATION_ID",   
					   "START_DATE",   
					   "END_DATE",   
					   "ENTER_DATE",   
					   "ENTER_BY",   
					   "LAST_MODIFY_DATE",   
					   "LAST_MODIFY_BY" )  
					   
					   
				  VALUES ( :LVS_YYYY||TRIM(TO_CHAR( :I , '00'))	 ,
							:GVI_ORGANIZATION_ID ,
							TO_DATE(:LVS_YYYY_LAST||TRIM(TO_CHAR('12' , '00')||   TRIM(TO_CHAR(:LVI_START_DATE ,'00'))  ), 'YYYYMMDD') ,
							ADD_MONTHS(TO_DATE(:LVS_YYYY_LAST||TRIM(TO_CHAR('12' , '00')||   TRIM(TO_CHAR(:LVI_START_DATE ,'00'))  ), 'YYYYMMDD')- 1 , 1),	  
							SYSDATE ,
							:GVS_USER_ID , 
							SYSDATE ,
							:GVS_USER_ID )	 ;
							
				else
				INSERT INTO ISYS_INVENTORY_CLOSE_DATE
					 ( "CLOSE_YYYYMM",   
					   "ORGANIZATION_ID",   
					   "START_DATE",   
					   "END_DATE",   
					   "ENTER_DATE",   
					   "ENTER_BY",   
					   "LAST_MODIFY_DATE",   
					   "LAST_MODIFY_BY" )  
					   
					   
				  VALUES ( :LVS_YYYY||TRIM(TO_CHAR( :I , '00'))	 ,
							:GVI_ORGANIZATION_ID ,
							TO_DATE(:LVS_YYYY||TRIM(TO_CHAR(:I - 1 , '00')||   TRIM(TO_CHAR(:LVI_START_DATE ,'00'))  ), 'YYYYMMDD') ,
							ADD_MONTHS(TO_DATE(:LVS_YYYY||TRIM(TO_CHAR(:I - 1, '00')||   TRIM(TO_CHAR(:LVI_START_DATE ,'00'))  ), 'YYYYMMDD')- 1 , 1),	  
							SYSDATE ,
							:GVS_USER_ID , 
							SYSDATE ,
							:GVS_USER_ID )	 ;
							
				  end if
			IF F_SQL_CHECK() < 0 THEN 
				RETURN
			END IF
			
			LOOP UNTIL I = 12
	
	
end if 


//==========================================
//
//==========================================

MSG = F_MSGBOX(1170)
IF MSG = 1 THEN 
	COMMIT; 
ELSE
	ROLLBACK;
END IF 

F_RETRIEVE()


end event

type st_1 from so_statictext within w_system_inventory_close_date_setup
integer x = 128
integer y = 80
integer width = 457
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Close YYYY"
end type

type em_yyyy from uo_year within w_system_inventory_close_date_setup
integer x = 128
integer y = 156
integer width = 457
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

type cbx_beginning from so_checkbox within w_system_inventory_close_date_setup
integer x = 777
integer y = 144
integer width = 773
integer height = 80
boolean bringtotop = true
integer weight = 700
string text = "Start beginning of a month"
boolean checked = true
end type

type sle_start_date from so_singlelineedit within w_system_inventory_close_date_setup
integer x = 1618
integer y = 152
integer width = 128
integer height = 72
integer taborder = 70
boolean bringtotop = true
string text = "01"
end type

type gb_1 from so_groupbox within w_system_inventory_close_date_setup
integer width = 713
integer height = 284
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_system_inventory_close_date_setup
integer x = 722
integer width = 1573
integer height = 284
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


HA$PBExportHeader$w_smt_plan_feeder_monitoring_master.srw
$PBExportComments$$$HEX4$$ddc0b0c0c4ac8dd6$$ENDHEX$$
forward
global type w_smt_plan_feeder_monitoring_master from w_main_root
end type
type cb_1 from so_commandbutton within w_smt_plan_feeder_monitoring_master
end type
type em_interval from so_editmask within w_smt_plan_feeder_monitoring_master
end type
type st_2 from so_statictext within w_smt_plan_feeder_monitoring_master
end type
type lb_line from so_listbox within w_smt_plan_feeder_monitoring_master
end type
type cb_2 from so_commandbutton within w_smt_plan_feeder_monitoring_master
end type
type cb_3 from so_commandbutton within w_smt_plan_feeder_monitoring_master
end type
type cb_4 from so_commandbutton within w_smt_plan_feeder_monitoring_master
end type
type cb_5 from so_commandbutton within w_smt_plan_feeder_monitoring_master
end type
type cb_6 from so_commandbutton within w_smt_plan_feeder_monitoring_master
end type
type cb_7 from so_commandbutton within w_smt_plan_feeder_monitoring_master
end type
type cb_8 from so_commandbutton within w_smt_plan_feeder_monitoring_master
end type
type cb_9 from so_commandbutton within w_smt_plan_feeder_monitoring_master
end type
type cb_10 from so_commandbutton within w_smt_plan_feeder_monitoring_master
end type
type sle_item_code from so_singlelineedit within w_smt_plan_feeder_monitoring_master
end type
type st_3 from so_statictext within w_smt_plan_feeder_monitoring_master
end type
type cb_11 from so_commandbutton within w_smt_plan_feeder_monitoring_master
end type
type sle_1 from so_singlelineedit within w_smt_plan_feeder_monitoring_master
end type
type st_1 from so_statictext within w_smt_plan_feeder_monitoring_master
end type
type sle_2 from so_singlelineedit within w_smt_plan_feeder_monitoring_master
end type
type st_4 from so_statictext within w_smt_plan_feeder_monitoring_master
end type
type gb_1 from so_groupbox within w_smt_plan_feeder_monitoring_master
end type
type gb_3 from so_groupbox within w_smt_plan_feeder_monitoring_master
end type
type gb_2 from so_groupbox within w_smt_plan_feeder_monitoring_master
end type
type gb_5 from so_groupbox within w_smt_plan_feeder_monitoring_master
end type
type gb_6 from so_groupbox within w_smt_plan_feeder_monitoring_master
end type
type gb_7 from so_groupbox within w_smt_plan_feeder_monitoring_master
end type
end forward

global type w_smt_plan_feeder_monitoring_master from w_main_root
integer width = 5138
integer height = 2804
string title = "SMT Feeder Monitoring"
windowstate windowstate = maximized!
cb_1 cb_1
em_interval em_interval
st_2 st_2
lb_line lb_line
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
cb_5 cb_5
cb_6 cb_6
cb_7 cb_7
cb_8 cb_8
cb_9 cb_9
cb_10 cb_10
sle_item_code sle_item_code
st_3 st_3
cb_11 cb_11
sle_1 sle_1
st_1 st_1
sle_2 sle_2
st_4 st_4
gb_1 gb_1
gb_3 gb_3
gb_2 gb_2
gb_5 gb_5
gb_6 gb_6
gb_7 gb_7
end type
global w_smt_plan_feeder_monitoring_master w_smt_plan_feeder_monitoring_master

type variables
string lvs_apply_yn = 'N'
end variables

on w_smt_plan_feeder_monitoring_master.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.em_interval=create em_interval
this.st_2=create st_2
this.lb_line=create lb_line
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_5=create cb_5
this.cb_6=create cb_6
this.cb_7=create cb_7
this.cb_8=create cb_8
this.cb_9=create cb_9
this.cb_10=create cb_10
this.sle_item_code=create sle_item_code
this.st_3=create st_3
this.cb_11=create cb_11
this.sle_1=create sle_1
this.st_1=create st_1
this.sle_2=create sle_2
this.st_4=create st_4
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_2=create gb_2
this.gb_5=create gb_5
this.gb_6=create gb_6
this.gb_7=create gb_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_interval
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.lb_line
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.cb_4
this.Control[iCurrent+8]=this.cb_5
this.Control[iCurrent+9]=this.cb_6
this.Control[iCurrent+10]=this.cb_7
this.Control[iCurrent+11]=this.cb_8
this.Control[iCurrent+12]=this.cb_9
this.Control[iCurrent+13]=this.cb_10
this.Control[iCurrent+14]=this.sle_item_code
this.Control[iCurrent+15]=this.st_3
this.Control[iCurrent+16]=this.cb_11
this.Control[iCurrent+17]=this.sle_1
this.Control[iCurrent+18]=this.st_1
this.Control[iCurrent+19]=this.sle_2
this.Control[iCurrent+20]=this.st_4
this.Control[iCurrent+21]=this.gb_1
this.Control[iCurrent+22]=this.gb_3
this.Control[iCurrent+23]=this.gb_2
this.Control[iCurrent+24]=this.gb_5
this.Control[iCurrent+25]=this.gb_6
this.Control[iCurrent+26]=this.gb_7
end on

on w_smt_plan_feeder_monitoring_master.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.em_interval)
destroy(this.st_2)
destroy(this.lb_line)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.cb_7)
destroy(this.cb_8)
destroy(this.cb_9)
destroy(this.cb_10)
destroy(this.sle_item_code)
destroy(this.st_3)
destroy(this.cb_11)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.sle_2)
destroy(this.st_4)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_2)
destroy(this.gb_5)
destroy(this.gb_6)
destroy(this.gb_7)
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
Ivs_resize_type    = 'MASTER_DETAIL_1L2R4B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

ivs_dw_1_retrice_cancel_popup_open = 'Y'
ivs_dw_2_retrice_cancel_popup_open = 'N'
ivs_dw_3_retrice_cancel_popup_open = 'N'
ivs_dw_4_retrice_cancel_popup_open = 'N'
ivs_dw_5_retrice_cancel_popup_open = 'N'

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
if lvs_apply_yn = 'Y' then 
	timer( long(em_interval.text))
end if 
end event

event ue_data_control;call super::ue_data_control;Long ROW , i
Double lvdb_seq
String lvs_active , lvst_linecode[]

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
	
//=============================================
//
//=============================================
				
			     if  lb_line.state(1) =1 then 
					
					    do
							i++
							lvst_linecode[i] =   TRIM(MID( lb_line.text(i) ,  POS( lb_line.text(i) , ':' ) +1 , 100  ))	
						loop until i = lb_line.totalitems( )
					
				else

						do
							i++
							
							if lb_line.state(i) =1 then 
								lvst_linecode[i] =  TRIM(MID( lb_line.text(i) ,  POS( lb_line.text(i) , ':' ) +1 , 100  ))	
							end if
		
						loop until i = lb_line.totalitems( )
				
				end if 
				
				if upperbound(lvst_linecode) <= 0 then 
					return 
				end if 
				
				
				dw_1.reset()
				dw_1.retrieve( lvst_linecode[] , '%' ,  '%' , 99999,  'Y' ,  99999 , 99999 ,   gvi_organization_id )				 	
			 
	CASE 'INSERT'		//$$HEX5$$c4ac8dd694cd00ac2000$$ENDHEX$$
	
				
	CASE 'APPEND' 

	CASE 'DELETE' 
		

	CASE 'UPDATE'
				if dw_1.update( ) < 0 or dw_2.update( ) < 0 then 
					rollback;
				else
					commit ;
				end if 
			 
	CASE ELSE
END CHOOSE
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
//f_retrieve()
end event

event timer;call super::timer;f_retrieve()
end event

event deactivate;call super::deactivate;timer(0)
end event

type dw_5 from w_main_root`dw_5 within w_smt_plan_feeder_monitoring_master
integer y = 604
end type

type dw_4 from w_main_root`dw_4 within w_smt_plan_feeder_monitoring_master
integer x = 3086
integer y = 1236
integer width = 1719
integer height = 1456
boolean titlebar = true
string dataobject = "d_smt_checkhist_4_feeding_monitor_lst"
end type

event dw_4::doubleclicked;call super::doubleclicked;OPENwithparm( w_mat_item_barcode_checkhist_4_feeder_popup , string(this.object.lot_no[row]))
end event

type dw_3 from w_main_root`dw_3 within w_smt_plan_feeder_monitoring_master
boolean visible = false
integer y = 604
integer width = 2798
integer height = 1220
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_smt_plan_feeder_monitoring_master
integer x = 3086
integer y = 604
integer width = 1719
integer height = 620
boolean titlebar = true
string title = "Sensor Actual"
string dataobject = "d_pln_product_sensor_actual_4_feeder"
end type

type dw_1 from w_main_root`dw_1 within w_smt_plan_feeder_monitoring_master
event ue_lbuttondown pbm_lbuttondown
integer y = 604
integer width = 3095
integer height = 2096
boolean titlebar = true
string title = "Feeder Status"
string dataobject = "d_smt_plan_master_lst"
end type

event dw_1::doubleclicked;call super::doubleclicked;if row < 1 then return 

if dwo.name = 'inventory_qty' then 
	
	openwithparm( w_mat_item_inventory_popup , string(this.object.item_code[getrow()]) )
	
elseif dwo.name = 'remain_qty' then 
	
	Gst_return.gvs_return[1] = string(this.object.line_code[getrow()]) 
	Gst_return.gvs_return[2] = string(this.object.location_code[getrow()])
	openwithparm( w_mat_item_workstage_inventory_4_feeder_popup , string(this.object.item_code[getrow()]) )
	
elseif dwo.name = 'nsnp_status' then 
	openwithparm( w_pln_nsnp_history_popup , string(this.object.line_code[getrow()]) )
	
elseif dwo.name = 'item_code' then 
	
	Gst_return.gvs_return[1] = string(this.object.lot_no[getrow()])
	openwithparm(  w_mat_item_barcode_inventory_4_feeder_popup , string(this.object.item_code[getrow()]) )
	
end if 
end event

event dw_1::itemchanged;//
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if dw_1.getrow() < 1 then return 
dw_2.retrieve(  dw_1.object.line_code[currentrow] +'%' )
dw_4.retrieve(  dw_1.object.line_code[currentrow], dw_1.object.model_name[currentrow],dw_1.object.location_code[currentrow],dw_1.object.item_code[currentrow] )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_smt_plan_feeder_monitoring_master
end type

type cb_1 from so_commandbutton within w_smt_plan_feeder_monitoring_master
integer x = 1687
integer y = 68
integer width = 402
integer height = 100
integer taborder = 50
boolean bringtotop = true
string text = "Apply"
end type

event clicked;call super::clicked;lvs_apply_yn = 'Y'
timer( long(em_interval.text)) 
end event

type em_interval from so_editmask within w_smt_plan_feeder_monitoring_master
integer x = 2098
integer y = 172
integer width = 389
integer taborder = 120
boolean bringtotop = true
string text = "60"
string mask = "##0"
boolean spin = true
double increment = 1
end type

type st_2 from so_statictext within w_smt_plan_feeder_monitoring_master
integer x = 1723
integer y = 188
integer width = 297
integer height = 56
boolean bringtotop = true
string text = "Interval"
end type

type lb_line from so_listbox within w_smt_plan_feeder_monitoring_master
integer x = 91
integer y = 64
integer width = 603
integer height = 516
integer taborder = 130
boolean bringtotop = true
integer weight = 400
boolean hscrollbar = true
boolean vscrollbar = true
boolean multiselect = true
end type

event constructor;call super::constructor;LONG I
STRING LVS_LINE_CODE , LVS_LINE_NAME , LVS_LINE_CODE_CONDITION

DECLARE CUR_01 CURSOR FOR 
	SELECT LINE_CODE , LINE_NAME 
  	  FROM  IP_PRODUCT_LINE
	 WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
	      AND LINE_CODE <> '*' 
	      AND MES_DISPLAY_YN = 'Y';
	 
OPEN CUR_01 ;

THIS.RESET()
THIS.ADDITEM('%')

IF F_SQL_CHECK_WITH_MSG('OPEN FROM IP_PRODUCT_LINE') < 0 THEN 
	CLOSE CUR_01 ;
	RETURN
END IF	

DO 
	FETCH CUR_01 INTO :LVS_LINE_CODE , :LVS_LINE_NAME ;
	
	IF F_SQL_CHECK_WITH_MSG('SELECT FROM IP_PRODUCT_LINE') < 0 THEN 
		CLOSE CUR_01 ;
		RETURN
	END IF	
	
	IF SQLCA.SQLCODE = 100 THEN 
		CLOSE CUR_01 ;		
		EXIT
	END IF 
	
	LVS_LINE_CODE = LVS_LINE_NAME +"                                                  : "+ LVS_LINE_CODE
	THIS.ADDITEM(LVS_LINE_CODE)
I++
F_MSG_MDI_HELP('UO_LINE_CODE : Construnctor-> '+STRING(I)+"Rows")  			
LOOP UNTIL 1 = 2
 THIS.Selectitem( 1)





end event

type cb_2 from so_commandbutton within w_smt_plan_feeder_monitoring_master
integer x = 2094
integer y = 68
integer width = 402
integer height = 100
integer taborder = 60
boolean bringtotop = true
string text = "Stop"
end type

event clicked;call super::clicked;lvs_apply_yn = 'N'
timer(0)	
end event

type cb_3 from so_commandbutton within w_smt_plan_feeder_monitoring_master
integer x = 2606
integer y = 76
integer height = 112
integer taborder = 70
boolean bringtotop = true
string text = "Use NSNP"
end type

event clicked;call super::clicked;string lvs_line_code

if dw_1.getrow() < 1 then 
	//Mess agebox("Notify" , "$$HEX10$$7cb778c744c7200020c1ddd0200058d538c194c6$$ENDHEX$$")
	f_msg("$$HEX10$$7cb778c744c7200020c1ddd0200058d538c194c6$$ENDHEX$$", 'P')
	return
end if 

lvs_line_code = dw_1.object.line_code[dw_1.getrow()]

update imcn_machine set use_status = 'U'
where line_code = :lvs_line_code
    and machine_type = 'NSNP' ;

	if f_sql_check() < 0 then 
		return 
	end if 

commit ;
f_retrieve()
end event

type cb_4 from so_commandbutton within w_smt_plan_feeder_monitoring_master
integer x = 2606
integer y = 180
integer height = 112
integer taborder = 80
boolean bringtotop = true
string text = "No Use NSNP"
end type

event clicked;call super::clicked;string lvs_line_code

if dw_1.getrow() < 1 then
	//Mess agebox("Notify" , "$$HEX10$$7cb778c744c7200020c1ddd0200058d538c194c6$$ENDHEX$$")
	f_msg("$$HEX10$$7cb778c744c7200020c1ddd0200058d538c194c6$$ENDHEX$$", 'P')
	return
end if 

lvs_line_code = dw_1.object.line_code[dw_1.getrow()]

sqlca.P_INTERLOCK_SET_NSNP_TIME_MSG( lvs_line_code , '0' , 0 ,  '*', '*', 'UNLOCK', gvs_computer_name+'=>FORCE UNLOCK '+gvs_user_name )

update imcn_machine set use_status = 'S'
where line_code = :lvs_line_code
    and machine_type = 'NSNP' ;

	if f_sql_check() < 0 then 
		return 
	end if 

commit ;
f_retrieve()
end event

type cb_5 from so_commandbutton within w_smt_plan_feeder_monitoring_master
integer x = 3232
integer y = 68
integer height = 112
integer taborder = 40
boolean bringtotop = true
string text = "NSNP UnLock"
end type

event clicked;call super::clicked;string lvs_line_code 

if dw_1.getrow() < 1 then return 

lvs_line_code = dw_1.object.line_code[dw_1.getrow()]
sqlca.P_INTERLOCK_SET_NSNP_TIME_MSG( lvs_line_code , '0' , 0 ,  '*', '*', 'UNLOCK', gvs_computer_name+'=>FORCE UNLOCK '+gvs_user_name )

if f_sql_check() < 0 then 
	return 
end if 

f_msgbox1(107 , this.text ) 

end event

type cb_6 from so_commandbutton within w_smt_plan_feeder_monitoring_master
integer x = 3232
integer y = 176
integer height = 112
integer taborder = 50
boolean bringtotop = true
string text = "NSNP Lock"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 

string lvs_line_code 
lvs_line_code = dw_1.object.line_code[dw_1.getrow()]
sqlca.P_INTERLOCK_SET_NSNP_TIME_MSG( lvs_line_code , '1' , 1, '*', '*', 'LOCK', '$$HEX24$$e4b24cc72000acc0a9c690c760c5200058c774d5200015ac1cc85cb82000d9b391c7200018b4c8c5b5c2c8b2e4b22000$$ENDHEX$$=>'+gvs_user_name )

if f_sql_check() < 0 then 
	return 
end if 

f_msgbox1(107 , this.text ) 

end event

type cb_7 from so_commandbutton within w_smt_plan_feeder_monitoring_master
integer x = 1408
integer y = 400
integer height = 140
integer taborder = 90
boolean bringtotop = true
string text = "Show No Use Lot"
end type

event clicked;call super::clicked;if dw_1.getrow( ) < 1 then return 
Gst_return.gvs_return[1] = string(dw_1.object.line_code[dw_1.getrow()]) 
Gst_return.gvs_return[2] = string(dw_1.object.location_code[dw_1.getrow()]) 
openwithparm( w_mat_item_workstage_inventory_4_feeder_popup , string(dw_1.object.item_code[dw_1.getrow()]) )
end event

type cb_8 from so_commandbutton within w_smt_plan_feeder_monitoring_master
integer x = 1947
integer y = 400
integer width = 535
integer height = 140
integer taborder = 100
boolean bringtotop = true
string text = "Show NSNP History"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then 
	return 
end if 

openwithparm( w_pln_nsnp_history_popup , string(dw_1.object.line_code[dw_1.getrow()]) )
end event

type cb_9 from so_commandbutton within w_smt_plan_feeder_monitoring_master
integer x = 2487
integer y = 400
integer width = 549
integer height = 140
integer taborder = 110
boolean bringtotop = true
string text = "Show Issue History"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 
Gst_return.gvs_return[1] = string(dw_1.object.lot_no[dw_1.getrow()])
openwithparm(  w_mat_item_barcode_inventory_4_feeder_popup , string(dw_1.object.item_code[dw_1.getrow()]) )

end event

type cb_10 from so_commandbutton within w_smt_plan_feeder_monitoring_master
integer x = 3045
integer y = 400
integer height = 140
integer taborder = 60
boolean bringtotop = true
string text = "Set Feeding Qty"
end type

event clicked;call super::clicked;long i  , LVL_SCAN_QTY
string LVS_LOT_NO , ARG_LINE_CODE , ARG_MODEL_NAME , arg_location_code , arg_item_code

if f_msgbox1( 1161 , this.text ) = 1   then 
else
	return 
end if 

do
	i++

	ARG_LINE_CODE      =  mid( dw_1.object.line_code[i] , 1,2 )
	ARG_MODEL_NAME  = dw_1.object.model_name[i] 
	arg_location_code   = dw_1.object.location_code[i] 
	arg_item_code	      =  dw_1.object.item_code[i] 

			SELECT 
			
				  	SUM (  ( SELECT DECODE( NVL(NEW_SCAN_QTY ,0) , 0 ,  SCAN_QTY , NVL(NEW_SCAN_QTY ,0)  ) 
						           FROM IM_ITEM_RECEIPT_BARCODE A 
						         WHERE A.ITEM_CODE = IB_SMT_CHECKHIST.ITEM_CODE 
						  	         AND A.LOT_NO = IB_SMT_CHECKHIST.LOT_NO
						    )  	)		
			    INTO :LVL_SCAN_QTY				
			  FROM "IB_SMT_CHECKHIST"
			 WHERE      "IB_SMT_CHECKHIST"."LINE_CODE" = :ARG_LINE_CODE
					 AND "IB_SMT_CHECKHIST"."LOT_NAME" = :ARG_MODEL_NAME
					 AND "IB_SMT_CHECKHIST"."LOCATION_CODE" = :arg_location_code
					 AND "IB_SMT_CHECKHIST"."CHECK_TYPE" IN ( '1' , '2' ) 
					 AND CHECK_STATUS = 'P'
					 AND "IB_SMT_CHECKHIST"."PARTNAME" = :arg_item_code
			
					 AND "IB_SMT_CHECKHIST"."CHECK_DATE" >=
						 (     SELECT MAX ("IB_SMT_CHECKHIST"."CHECK_DATE")
									FROM "IB_SMT_CHECKHIST"
								  WHERE "IB_SMT_CHECKHIST"."LINE_CODE" = :ARG_LINE_CODE
										  AND "IB_SMT_CHECKHIST"."LOT_NAME" = :ARG_MODEL_NAME
										  AND "IB_SMT_CHECKHIST"."LOCATION_CODE" = :arg_location_code
										  AND "IB_SMT_CHECKHIST"."PARTNAME" = :arg_item_code
										   AND CHECK_STATUS = 'P'
									        AND CHECK_TYPE = 1  ) ;

	IF F_SQL_CHECK() < 0 THEN 
		RETURN 
	END IF 

	IF LVL_SCAN_QTY > 0 THEN 
	
		 UPDATE IB_PRODUCT_PLANDATA 
		      SET FEEDING_QTY =  DECODE( NVL( :LVL_SCAN_QTY,0) , 0 , FEEDING_QTY  ,  :LVL_SCAN_QTY ) 
		 WHERE LINE_CODE = :ARG_LINE_CODE
			 AND MODEL_NAME = :ARG_MODEL_NAME
			 AND LOCATION_CODE = :ARG_LOCATION_CODE 
			 AND ITEM_CODE = :arg_item_code
			 AND ACTIVE_YN = 'Y' ;
	
			IF F_SQL_CHECK() < 0 THEN 
				RETURN 
			END IF 	
	
	END IF 

	F_MSG_MDI_HELP( STRING(I) )

loop until i = dw_1.rowcount( )

COMMIT ;
end event

type sle_item_code from so_singlelineedit within w_smt_plan_feeder_monitoring_master
integer x = 1152
integer y = 48
integer width = 439
integer taborder = 130
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_CODE'
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

type st_3 from so_statictext within w_smt_plan_feeder_monitoring_master
integer x = 814
integer y = 52
integer width = 320
integer height = 72
boolean bringtotop = true
string text = "Item Code"
alignment alignment = right!
end type

type cb_11 from so_commandbutton within w_smt_plan_feeder_monitoring_master
integer x = 805
integer y = 400
integer width = 599
integer height = 140
integer taborder = 100
boolean bringtotop = true
string text = "Show Change History"
end type

event clicked;call super::clicked;if dw_1.getrow() <  0 then return 
dw_4.retrieve(  dw_1.object.line_code[dw_1.getrow()]  , dw_1.object.model_name[dw_1.getrow()] , dw_1.object.location_code[dw_1.getrow()]  ,   dw_1.object.item_code[dw_1.getrow()] )
end event

type sle_1 from so_singlelineedit within w_smt_plan_feeder_monitoring_master
integer x = 1152
integer y = 148
integer width = 439
integer taborder = 60
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'LOCATION_CODE'
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

type st_1 from so_statictext within w_smt_plan_feeder_monitoring_master
integer x = 814
integer y = 152
integer width = 320
integer height = 72
boolean bringtotop = true
string text = "Location"
alignment alignment = right!
end type

type sle_2 from so_singlelineedit within w_smt_plan_feeder_monitoring_master
integer x = 1152
integer y = 244
integer width = 439
integer taborder = 70
boolean bringtotop = true
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'REMAIN_QTY'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = UPPER(this.text)
END IF

dw_1.SETFILTER( " REMAIN_QTY <= "+ STRING(LVS_VALUE))
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )


end event

type st_4 from so_statictext within w_smt_plan_feeder_monitoring_master
integer x = 814
integer y = 244
integer width = 320
integer height = 72
boolean bringtotop = true
string text = "Remain Qty"
alignment alignment = right!
end type

type gb_1 from so_groupbox within w_smt_plan_feeder_monitoring_master
integer x = 5
integer y = 4
integer width = 763
integer height = 588
integer taborder = 30
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_smt_plan_feeder_monitoring_master
integer x = 1627
integer y = 8
integer width = 919
integer height = 312
integer taborder = 40
long textcolor = 16711680
string text = "Auto Retrieve"
end type

type gb_2 from so_groupbox within w_smt_plan_feeder_monitoring_master
integer x = 3191
integer y = 8
integer width = 613
integer height = 312
integer taborder = 50
long textcolor = 16711680
string text = "NSNP Lock / Unlock"
end type

type gb_5 from so_groupbox within w_smt_plan_feeder_monitoring_master
integer x = 773
integer y = 328
integer width = 3031
integer height = 268
integer taborder = 60
long textcolor = 16711680
string text = "Show No Use Lot"
end type

type gb_6 from so_groupbox within w_smt_plan_feeder_monitoring_master
integer x = 777
integer y = 8
integer width = 832
integer height = 320
integer taborder = 50
long textcolor = 16711680
string text = "Filter"
end type

type gb_7 from so_groupbox within w_smt_plan_feeder_monitoring_master
integer x = 2560
integer y = 8
integer width = 617
integer height = 312
integer taborder = 10
long textcolor = 16711680
string text = "NSNP Use / No Use"
end type


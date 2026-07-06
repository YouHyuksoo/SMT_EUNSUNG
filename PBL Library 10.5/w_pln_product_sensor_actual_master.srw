HA$PBExportHeader$w_pln_product_sensor_actual_master.srw
$PBExportComments$$$HEX6$$80bd88d42000c8b9a4c230d1$$ENDHEX$$
forward
global type w_pln_product_sensor_actual_master from w_main_root
end type
type st_2 from so_statictext within w_pln_product_sensor_actual_master
end type
type sle_line_code from so_singlelineedit within w_pln_product_sensor_actual_master
end type
type em_interval from so_editmask within w_pln_product_sensor_actual_master
end type
type st_3 from so_statictext within w_pln_product_sensor_actual_master
end type
type cb_1 from so_commandbutton within w_pln_product_sensor_actual_master
end type
type cb_2 from so_commandbutton within w_pln_product_sensor_actual_master
end type
type cb_3 from so_commandbutton within w_pln_product_sensor_actual_master
end type
type em_count from so_editmask within w_pln_product_sensor_actual_master
end type
type rb_current from so_radiobutton within w_pln_product_sensor_actual_master
end type
type rb_history from so_radiobutton within w_pln_product_sensor_actual_master
end type
type rb_time from so_radiobutton within w_pln_product_sensor_actual_master
end type
type uo_dateset from uo_ymd_calendar within w_pln_product_sensor_actual_master
end type
type st_5 from so_statictext within w_pln_product_sensor_actual_master
end type
type sle_model_name from so_singlelineedit within w_pln_product_sensor_actual_master
end type
type st_mrm_no from statictext within w_pln_product_sensor_actual_master
end type
type rb_2 from so_radiobutton within w_pln_product_sensor_actual_master
end type
type gb_where_condition from so_groupbox within w_pln_product_sensor_actual_master
end type
type gb_2 from so_groupbox within w_pln_product_sensor_actual_master
end type
type gb_1 from so_groupbox within w_pln_product_sensor_actual_master
end type
end forward

global type w_pln_product_sensor_actual_master from w_main_root
integer width = 4736
integer height = 2904
string title = "SMT Product Sensor Actual Query"
windowstate windowstate = maximized!
st_2 st_2
sle_line_code sle_line_code
em_interval em_interval
st_3 st_3
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
em_count em_count
rb_current rb_current
rb_history rb_history
rb_time rb_time
uo_dateset uo_dateset
st_5 st_5
sle_model_name sle_model_name
st_mrm_no st_mrm_no
rb_2 rb_2
gb_where_condition gb_where_condition
gb_2 gb_2
gb_1 gb_1
end type
global w_pln_product_sensor_actual_master w_pln_product_sensor_actual_master

on w_pln_product_sensor_actual_master.create
int iCurrent
call super::create
this.st_2=create st_2
this.sle_line_code=create sle_line_code
this.em_interval=create em_interval
this.st_3=create st_3
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.em_count=create em_count
this.rb_current=create rb_current
this.rb_history=create rb_history
this.rb_time=create rb_time
this.uo_dateset=create uo_dateset
this.st_5=create st_5
this.sle_model_name=create sle_model_name
this.st_mrm_no=create st_mrm_no
this.rb_2=create rb_2
this.gb_where_condition=create gb_where_condition
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_line_code
this.Control[iCurrent+3]=this.em_interval
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_3
this.Control[iCurrent+8]=this.em_count
this.Control[iCurrent+9]=this.rb_current
this.Control[iCurrent+10]=this.rb_history
this.Control[iCurrent+11]=this.rb_time
this.Control[iCurrent+12]=this.uo_dateset
this.Control[iCurrent+13]=this.st_5
this.Control[iCurrent+14]=this.sle_model_name
this.Control[iCurrent+15]=this.st_mrm_no
this.Control[iCurrent+16]=this.rb_2
this.Control[iCurrent+17]=this.gb_where_condition
this.Control[iCurrent+18]=this.gb_2
this.Control[iCurrent+19]=this.gb_1
end on

on w_pln_product_sensor_actual_master.destroy
call super::destroy
destroy(this.st_2)
destroy(this.sle_line_code)
destroy(this.em_interval)
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.em_count)
destroy(this.rb_current)
destroy(this.rb_history)
destroy(this.rb_time)
destroy(this.uo_dateset)
destroy(this.st_5)
destroy(this.sle_model_name)
destroy(this.st_mrm_no)
destroy(this.rb_2)
destroy(this.gb_where_condition)
destroy(this.gb_2)
destroy(this.gb_1)
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

timer( dec(em_interval.text))
end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_SETYN

CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		
			if rb_current.checked = true then 
				DW_1.RETRIEVE(  sle_line_code.text+'%'  )
				DW_1.SETFOCUS()
			elseif rb_history.checked = true then 
				DW_2.RETRIEVE(  sle_line_code.text+'%'  )
				DW_2.SETFOCUS()		
				
			elseif rb_time.checked = true then 
				DW_3.RETRIEVE(  sle_line_code.text+'%' ,sle_model_name.text+ '%' , uo_dateset.text() , gvi_organization_id  )
				DW_3.SETFOCUS()			
				
			else
				DW_4.RETRIEVE(  sle_line_code.text+'%' ,sle_model_name.text+ '%' , uo_dateset.text() , gvi_organization_id  )
				DW_3.SETFOCUS()					
				
			end if 
CASE  'DELETE' 
	
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
	                F_RETRIEVE()
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF

	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


end event

event timer;call super::timer;f_retrieve()
end event

event close;call super::close;timer(0)
end event

event deactivate;call super::deactivate;timer(0)
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_sensor_actual_master
integer y = 424
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_sensor_actual_master
integer y = 424
integer width = 4224
integer height = 1260
boolean titlebar = true
string dataobject = "d_pln_product_sensor_actual_1hour_hst"
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_sensor_actual_master
integer y = 424
integer width = 4677
integer height = 1644
integer taborder = 50
boolean titlebar = true
string dataobject = "d_pln_product_sensor_actual_time_hst"
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_sensor_actual_master
integer y = 424
integer width = 3849
integer height = 1644
integer taborder = 0
boolean titlebar = true
string title = "History"
string dataobject = "d_pln_product_sensor_actual_hst"
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_sensor_actual_master
integer y = 424
integer width = 4672
integer height = 1644
integer taborder = 40
boolean titlebar = true
string title = "Material Request List"
string dataobject = "d_pln_product_sensor_actual_lst"
end type

event dw_1::retrievestart;//OVER 
end event

event dw_1::retrieverow;//OVER
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_sensor_actual_master
end type

type st_2 from so_statictext within w_pln_product_sensor_actual_master
integer x = 795
integer y = 128
integer width = 590
integer height = 56
boolean bringtotop = true
string text = "Line Code"
end type

type sle_line_code from so_singlelineedit within w_pln_product_sensor_actual_master
event ue_editchange pbm_enchange
integer x = 795
integer y = 204
integer width = 590
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type em_interval from so_editmask within w_pln_product_sensor_actual_master
integer x = 2706
integer y = 172
integer taborder = 40
boolean bringtotop = true
string text = "20"
string mask = "##0.00"
boolean spin = true
string minmax = "10~~"
end type

event modified;call super::modified;timer(dec(this.text))
end event

type st_3 from so_statictext within w_pln_product_sensor_actual_master
integer x = 2706
integer y = 84
integer width = 402
boolean bringtotop = true
string text = "Interval"
end type

type cb_1 from so_commandbutton within w_pln_product_sensor_actual_master
integer x = 3259
integer y = 64
integer width = 521
integer height = 108
integer taborder = 30
boolean bringtotop = true
string text = "Start"
end type

event clicked;call super::clicked;timer( dec(em_interval.text))
end event

type cb_2 from so_commandbutton within w_pln_product_sensor_actual_master
integer x = 3259
integer y = 164
integer width = 521
integer height = 108
integer taborder = 50
boolean bringtotop = true
string text = "Stop"
end type

event clicked;call super::clicked;timer(0)	
end event

type cb_3 from so_commandbutton within w_pln_product_sensor_actual_master
integer x = 3259
integer y = 272
integer width = 521
integer height = 108
integer taborder = 60
boolean bringtotop = true
string text = "Actual Adjust"
end type

event clicked;call super::clicked;long i 
string P_LINE_CODE , P_WORKSTAGE_CODE , P_MACHINE_CODE ,  P_OUT


msg = f_msgbox1(1161 , this.text ) 
if msg = 1 then 
else
	return
end if 

i  = dw_1.object.product_actual_qty[dw_1.getrow()]

P_LINE_CODE  = dw_1.object.line_code[dw_1.getrow()]
P_WORKSTAGE_CODE = 'W050'
P_MACHINE_CODE = '*' 

if long( em_count.text) = 0 then

 //  ---------------------------------------------------------------------------
 //  -- FEEDER ACTUAL QTY
 //  ----------------------------------------------------------------------------

   UPDATE ib_product_plandata
      SET product_actual_qty =    :i * (NVL (item_unit_qty, 0) *  F_GET_CARRIER_SIZE (model_name, organization_id ) )
    WHERE line_code = :p_line_code
        AND active_yn = 'Y';

   COMMIT;
	
else

		do
			i++
			
			SQLCA.P_INTERLOCK_SENSOR_ACTUAL_MAN(P_LINE_CODE,P_WORKSTAGE_CODE,P_MACHINE_CODE, 1, i) 
			
			IF F_SQL_CHECK() < 0 THEN 
				RETURN 
			END IF 
			COMMIT ; 
			
			f_msg_mdi_help( string(i))
			
		loop until i = long( em_count.text)
end if 
end event

type em_count from so_editmask within w_pln_product_sensor_actual_master
integer x = 2706
integer y = 276
integer taborder = 60
boolean bringtotop = true
string text = "0"
string mask = "###,##0"
boolean spin = true
string minmax = "10~~"
end type

event modified;call super::modified;timer(dec(this.text))
end event

type rb_current from so_radiobutton within w_pln_product_sensor_actual_master
integer x = 91
integer y = 72
boolean bringtotop = true
string text = "Current Actual"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 

end event

type rb_history from so_radiobutton within w_pln_product_sensor_actual_master
integer x = 91
integer y = 144
boolean bringtotop = true
string text = "Actual History"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
end event

type rb_time from so_radiobutton within w_pln_product_sensor_actual_master
integer x = 91
integer y = 216
boolean bringtotop = true
string text = "Time Actual"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
end event

type uo_dateset from uo_ymd_calendar within w_pln_product_sensor_actual_master
event destroy ( )
integer x = 1399
integer y = 204
integer taborder = 70
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_5 from so_statictext within w_pln_product_sensor_actual_master
integer x = 1399
integer y = 128
integer width = 416
integer height = 68
boolean bringtotop = true
string text = "Dateset"
end type

type sle_model_name from so_singlelineedit within w_pln_product_sensor_actual_master
integer x = 1833
integer y = 208
integer width = 603
integer taborder = 40
boolean bringtotop = true
end type

type st_mrm_no from statictext within w_pln_product_sensor_actual_master
integer x = 1833
integer y = 116
integer width = 603
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_2 from so_radiobutton within w_pln_product_sensor_actual_master
integer x = 91
integer y = 300
boolean bringtotop = true
string text = "1 Hour Actual"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4
end event

type gb_where_condition from so_groupbox within w_pln_product_sensor_actual_master
integer x = 2555
integer y = 12
integer width = 1285
integer height = 392
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_pln_product_sensor_actual_master
integer width = 731
integer height = 392
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_1 from so_groupbox within w_pln_product_sensor_actual_master
integer x = 731
integer width = 1801
integer height = 392
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


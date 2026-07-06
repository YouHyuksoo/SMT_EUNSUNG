HA$PBExportHeader$w_smt_plan_feeder_monitoring_line_master.srw
$PBExportComments$$$HEX4$$ddc0b0c0c4ac8dd6$$ENDHEX$$
forward
global type w_smt_plan_feeder_monitoring_line_master from w_main_root
end type
type st_item_code from so_statictext within w_smt_plan_feeder_monitoring_line_master
end type
type rb_all from so_radiobutton within w_smt_plan_feeder_monitoring_line_master
end type
type rb_active from so_radiobutton within w_smt_plan_feeder_monitoring_line_master
end type
type cb_1 from so_commandbutton within w_smt_plan_feeder_monitoring_line_master
end type
type em_interval from so_editmask within w_smt_plan_feeder_monitoring_line_master
end type
type st_2 from so_statictext within w_smt_plan_feeder_monitoring_line_master
end type
type cb_2 from so_commandbutton within w_smt_plan_feeder_monitoring_line_master
end type
type em_limit_qty from so_editmask within w_smt_plan_feeder_monitoring_line_master
end type
type st_4 from so_statictext within w_smt_plan_feeder_monitoring_line_master
end type
type dw_6 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
end type
type dw_7 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
end type
type dw_8 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
end type
type dw_9 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
end type
type dw_10 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
end type
type dw_11 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
end type
type dw_12 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
end type
type dw_13 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
end type
type dw_14 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
end type
type dw_15 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
end type
type dw_16 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
end type
type dw_17 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
end type
type dw_18 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
end type
type dw_19 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
end type
type dw_20 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
end type
type cb_3 from so_commandbutton within w_smt_plan_feeder_monitoring_line_master
end type
type ddlb_line_code from uo_line_code_smt within w_smt_plan_feeder_monitoring_line_master
end type
type gb_1 from so_groupbox within w_smt_plan_feeder_monitoring_line_master
end type
type gb_3 from so_groupbox within w_smt_plan_feeder_monitoring_line_master
end type
type gb_4 from so_groupbox within w_smt_plan_feeder_monitoring_line_master
end type
type gb_2 from so_groupbox within w_smt_plan_feeder_monitoring_line_master
end type
type dw_21 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
end type
type ddlb_model_name from uo_model_name_ddlb within w_smt_plan_feeder_monitoring_line_master
end type
end forward

global type w_smt_plan_feeder_monitoring_line_master from w_main_root
integer width = 9038
integer height = 2868
string title = "SMT Feeder Monitoring Line Master"
boolean maxbox = false
boolean hscrollbar = true
boolean vscrollbar = true
windowstate windowstate = maximized!
string ivs_dw_1_use_focusindicator = "N"
string ivs_dw_1_selected_row_yn = "N"
st_item_code st_item_code
rb_all rb_all
rb_active rb_active
cb_1 cb_1
em_interval em_interval
st_2 st_2
cb_2 cb_2
em_limit_qty em_limit_qty
st_4 st_4
dw_6 dw_6
dw_7 dw_7
dw_8 dw_8
dw_9 dw_9
dw_10 dw_10
dw_11 dw_11
dw_12 dw_12
dw_13 dw_13
dw_14 dw_14
dw_15 dw_15
dw_16 dw_16
dw_17 dw_17
dw_18 dw_18
dw_19 dw_19
dw_20 dw_20
cb_3 cb_3
ddlb_line_code ddlb_line_code
gb_1 gb_1
gb_3 gb_3
gb_4 gb_4
gb_2 gb_2
dw_21 dw_21
ddlb_model_name ddlb_model_name
end type
global w_smt_plan_feeder_monitoring_line_master w_smt_plan_feeder_monitoring_line_master

type variables
string lvs_apply_yn = 'N'


STRING ivs_dw_6_use_focusindicator ='N'
STRING ivs_dw_7_use_focusindicator ='N'
STRING ivs_dw_8_use_focusindicator ='N'
STRING ivs_dw_9_use_focusindicator ='N'
STRING ivs_dw_10_use_focusindicator ='N'
STRING ivs_dw_11_use_focusindicator ='N'
STRING ivs_dw_12_use_focusindicator ='N'
STRING ivs_dw_13_use_focusindicator ='N'
STRING ivs_dw_14_use_focusindicator ='N'
STRING ivs_dw_15_use_focusindicator ='N'
STRING ivs_dw_16_use_focusindicator ='N'
STRING ivs_dw_17_use_focusindicator ='N'
STRING ivs_dw_18_use_focusindicator ='N'
STRING ivs_dw_19_use_focusindicator ='N'
STRING ivs_dw_20_use_focusindicator ='N'

STRING ivs_dw_6_selected_row_yn = 'N' 
STRING ivs_dw_7_selected_row_yn = 'N'
STRING ivs_dw_8_selected_row_yn = 'N'
STRING ivs_dw_9_selected_row_yn = 'N'
STRING ivs_dw_10_selected_row_yn = 'N'
STRING ivs_dw_11_selected_row_yn = 'N'
STRING ivs_dw_12_selected_row_yn = 'N'
STRING ivs_dw_13_selected_row_yn = 'N'
STRING ivs_dw_14_selected_row_yn = 'N'
STRING ivs_dw_15_selected_row_yn = 'N'
STRING ivs_dw_16_selected_row_yn = 'N'
STRING ivs_dw_17_selected_row_yn = 'N'
STRING ivs_dw_18_selected_row_yn = 'N'
STRING ivs_dw_19_selected_row_yn = 'N'
STRING ivs_dw_20_selected_row_yn = 'N'

STRING ivs_dw_6_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_7_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_8_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_9_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_10_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_11_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_12_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_13_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_14_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_15_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_16_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_17_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_18_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_19_retrice_cancel_popup_open = 'Y'
STRING ivs_dw_20_retrice_cancel_popup_open = 'Y'


STRING ivs_dw_6_deleteselected_yn = 'Y' 
STRING ivs_dw_7_deleteselected_yn = 'Y' 
STRING ivs_dw_8_deleteselected_yn = 'Y' 
STRING ivs_dw_9_deleteselected_yn = 'Y' 
STRING ivs_dw_10_deleteselected_yn = 'Y' 
STRING ivs_dw_11_deleteselected_yn = 'Y' 
STRING ivs_dw_12_deleteselected_yn = 'Y' 
STRING ivs_dw_13_deleteselected_yn = 'Y' 
STRING ivs_dw_14_deleteselected_yn = 'Y' 
STRING ivs_dw_15_deleteselected_yn = 'Y' 
STRING ivs_dw_16_deleteselected_yn = 'Y' 
STRING ivs_dw_17_deleteselected_yn = 'Y' 
STRING ivs_dw_18_deleteselected_yn = 'Y' 
STRING ivs_dw_19_deleteselected_yn = 'Y' 
STRING ivs_dw_20_deleteselected_yn = 'Y' 


STRING ivs_set_column_dddw6 = 'N'
STRING ivs_set_column_dddw7 = 'N'
STRING ivs_set_column_dddw8 = 'N'
STRING ivs_set_column_dddw9 = 'N'
STRING ivs_set_column_dddw10 = 'N'
STRING ivs_set_column_dddw11 = 'N'
STRING ivs_set_column_dddw12 = 'N'
STRING ivs_set_column_dddw13 = 'N'
STRING ivs_set_column_dddw14 = 'N'
STRING ivs_set_column_dddw15 = 'N'
STRING ivs_set_column_dddw16 = 'N'
STRING ivs_set_column_dddw17 = 'N'
STRING ivs_set_column_dddw18 = 'N'
STRING ivs_set_column_dddw19 = 'N'
STRING ivs_set_column_dddw20 = 'N'

end variables

forward prototypes
public function string wf_model_name (string arg_line_code)
public function string wf_pcb_item (string arg_pcb)
public function string wf_actual_qty (string arg_line_code)
public function string wf_carrier_qty (string arg_model, string arg_line_code)
end prototypes

public function string wf_model_name (string arg_line_code);String lvs_model_name

SELECT Trim(MODEL_NAME)
   INTO :lvs_model_name
  FROM IP_PRODUCT_LINE 
 WHERE LINE_CODE         = :arg_line_code
   AND ORGANIZATION_ID = 1 ;

IF F_SQL_CHECK() < 0 THEN 
	RETURN '' 
END IF 

RETURN lvs_model_name
	
end function

public function string wf_pcb_item (string arg_pcb);string lvs_pcb_item

select trim(pcb_item)
into :lvs_pcb_item
from ip_product_line
where line_code = :arg_pcb and
		organization_id = 1;
		
if f_sql_check() < 0 then
	return ''
end if

return lvs_pcb_item
end function

public function string wf_actual_qty (string arg_line_code);string lvs_actual_qty

select to_char(product_actual_qty)
into :lvs_actual_qty
from ip_product_sensor_actual
where line_code = :arg_line_code and
		receipt_sequence = (select max(receipt_sequence) from ip_product_sensor_actual where line_code = :arg_line_code)
;

IF F_SQL_CHECK() < 0 THEN 
	RETURN '' 
END IF 

return lvs_actual_qty

end function

public function string wf_carrier_qty (string arg_model, string arg_line_code);String lvs_adjust_yn, lvs_feeder_shaft
int lvi_adjust_qty

select distinct feeder_shaft
into :lvs_feeder_shaft
from ib_product_plandata
where active_yn = 'Y' and
		model_name = :arg_model and
		line_code = :arg_line_code
;

select nvl(carrier_size_adjust_yn,'N'), nvl(carrier_size_adjust_qty,0)
into :lvs_adjust_yn, :lvi_adjust_qty
from ib_smt_Feeder_shaft
where line_code = :arg_line_code and
      model_name = :arg_model and
      feeder_shaft = :lvs_feeder_shaft
;


if lvs_adjust_yn = 'Y' then
	
	return string(lvi_adjust_qty)
	
elseif lvs_adjust_yn = 'N' then
	
	select to_number(nvl(CARRIER_SIZE,'0'))
	into :lvi_adjust_qty
	from IP_PRODUCT_MODEL_MASTER
	where model_name = :arg_model
	;
	
end if
return 'Array ' + string(lvi_adjust_qty)
end function

on w_smt_plan_feeder_monitoring_line_master.create
int iCurrent
call super::create
this.st_item_code=create st_item_code
this.rb_all=create rb_all
this.rb_active=create rb_active
this.cb_1=create cb_1
this.em_interval=create em_interval
this.st_2=create st_2
this.cb_2=create cb_2
this.em_limit_qty=create em_limit_qty
this.st_4=create st_4
this.dw_6=create dw_6
this.dw_7=create dw_7
this.dw_8=create dw_8
this.dw_9=create dw_9
this.dw_10=create dw_10
this.dw_11=create dw_11
this.dw_12=create dw_12
this.dw_13=create dw_13
this.dw_14=create dw_14
this.dw_15=create dw_15
this.dw_16=create dw_16
this.dw_17=create dw_17
this.dw_18=create dw_18
this.dw_19=create dw_19
this.dw_20=create dw_20
this.cb_3=create cb_3
this.ddlb_line_code=create ddlb_line_code
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_2=create gb_2
this.dw_21=create dw_21
this.ddlb_model_name=create ddlb_model_name
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_item_code
this.Control[iCurrent+2]=this.rb_all
this.Control[iCurrent+3]=this.rb_active
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.em_interval
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.em_limit_qty
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.dw_6
this.Control[iCurrent+11]=this.dw_7
this.Control[iCurrent+12]=this.dw_8
this.Control[iCurrent+13]=this.dw_9
this.Control[iCurrent+14]=this.dw_10
this.Control[iCurrent+15]=this.dw_11
this.Control[iCurrent+16]=this.dw_12
this.Control[iCurrent+17]=this.dw_13
this.Control[iCurrent+18]=this.dw_14
this.Control[iCurrent+19]=this.dw_15
this.Control[iCurrent+20]=this.dw_16
this.Control[iCurrent+21]=this.dw_17
this.Control[iCurrent+22]=this.dw_18
this.Control[iCurrent+23]=this.dw_19
this.Control[iCurrent+24]=this.dw_20
this.Control[iCurrent+25]=this.cb_3
this.Control[iCurrent+26]=this.ddlb_line_code
this.Control[iCurrent+27]=this.gb_1
this.Control[iCurrent+28]=this.gb_3
this.Control[iCurrent+29]=this.gb_4
this.Control[iCurrent+30]=this.gb_2
this.Control[iCurrent+31]=this.dw_21
this.Control[iCurrent+32]=this.ddlb_model_name
end on

on w_smt_plan_feeder_monitoring_line_master.destroy
call super::destroy
destroy(this.st_item_code)
destroy(this.rb_all)
destroy(this.rb_active)
destroy(this.cb_1)
destroy(this.em_interval)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.em_limit_qty)
destroy(this.st_4)
destroy(this.dw_6)
destroy(this.dw_7)
destroy(this.dw_8)
destroy(this.dw_9)
destroy(this.dw_10)
destroy(this.dw_11)
destroy(this.dw_12)
destroy(this.dw_13)
destroy(this.dw_14)
destroy(this.dw_15)
destroy(this.dw_16)
destroy(this.dw_17)
destroy(this.dw_18)
destroy(this.dw_19)
destroy(this.dw_20)
destroy(this.cb_3)
destroy(this.ddlb_line_code)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_2)
destroy(this.dw_21)
destroy(this.ddlb_model_name)
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
//Ivs_resize_type    = 'MASTER_DETAIL_1L2R4B'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'N' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

ivs_dw_1_retrice_cancel_popup_open = 'N'
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

//F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control

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
		
				if rb_all.checked = true then 
					lvs_active = '%' 
				else
					lvs_active = 'Y' 
				end if 
				
				//DW Reset()
				dw_1.reset()
				dw_2.reset()
				dw_3.reset()
				dw_4.reset()
				dw_5.reset()
				dw_6.reset()
				dw_7.reset()
				dw_8.reset()
				dw_9.reset()
				dw_10.reset()
				dw_11.reset()
				dw_12.reset()
				dw_13.reset()
				dw_14.reset()
				dw_15.reset()
				dw_16.reset()
				dw_17.reset()
				dw_18.reset()
				dw_19.reset()
				dw_20.reset()
				
				//$$HEX16$$7cb778c7c4bc200088d4a9bac4bc2000ddc0b0c000aca5b218c2200070c88cd6$$ENDHEX$$
				dw_1.retrieve( '01' , ddlb_model_name.getcode( ) ,  lvs_active ,  long(em_limit_qty.text) ,   gvi_organization_id )
				dw_2.retrieve( '02' , ddlb_model_name.getcode( ) ,  lvs_active ,  long(em_limit_qty.text) ,   gvi_organization_id )
				dw_3.retrieve( '03' , ddlb_model_name.getcode( ) ,  lvs_active ,  long(em_limit_qty.text) ,   gvi_organization_id )
				dw_4.retrieve( '04' , ddlb_model_name.getcode( ) ,  lvs_active ,  long(em_limit_qty.text) ,   gvi_organization_id )
				dw_5.retrieve( '05' , ddlb_model_name.getcode( ) ,  lvs_active ,  long(em_limit_qty.text) ,   gvi_organization_id )
				dw_6.retrieve( '06' , ddlb_model_name.getcode( ) ,  lvs_active ,  long(em_limit_qty.text) ,   gvi_organization_id )
				dw_7.retrieve( '07' , ddlb_model_name.getcode( ) ,  lvs_active ,  long(em_limit_qty.text) ,   gvi_organization_id )
				dw_8.retrieve( '08' , ddlb_model_name.getcode( ) ,  lvs_active ,  long(em_limit_qty.text) ,   gvi_organization_id )
				dw_9.retrieve( '09' , ddlb_model_name.getcode( ) ,  lvs_active ,  long(em_limit_qty.text) ,   gvi_organization_id )
				dw_10.retrieve( '10' , ddlb_model_name.getcode( ) ,  lvs_active , long(em_limit_qty.text) ,   gvi_organization_id )

                  
				//$$HEX13$$7cb778c7c4bc200034ae09ae90c7acc794c6adcc200070c88cd6$$ENDHEX$$
				dw_11.retrieve( '01' ,  gvi_organization_id )
				dw_12.retrieve( '02' ,  gvi_organization_id )
				dw_13.retrieve( '03' ,  gvi_organization_id )
				dw_14.retrieve( '04' ,  gvi_organization_id )
				dw_15.retrieve( '05' ,  gvi_organization_id )
				dw_16.retrieve( '06' ,  gvi_organization_id )
				dw_17.retrieve( '07' ,  gvi_organization_id )
				dw_18.retrieve( '08' ,  gvi_organization_id )
				dw_19.retrieve( '09' ,  gvi_organization_id )
				dw_20.retrieve( '10' ,  gvi_organization_id )
				
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

event resize;Double ld_width, ld_height

ld_width  = newwidth / 10

//dw_1.resize( ld_width - dw_1.x, newheight )	
//dw_2.resize( ld_width - dw_1.x, newheight )		
//dw_3.resize( ld_width - dw_1.x, newheight )
//dw_4.resize( ld_width - dw_1.x, newheight )
//dw_5.resize( ld_width - dw_1.x, newheight )


end event

event open;call super::open;dw_6.settransobject(sqlca)
dw_7.settransobject(sqlca)
dw_8.settransobject(sqlca)
dw_9.settransobject(sqlca)
dw_10.settransobject(sqlca)
dw_11.settransobject(sqlca)
dw_12.settransobject(sqlca)
dw_13.settransobject(sqlca)
dw_14.settransobject(sqlca)
dw_15.settransobject(sqlca)
dw_16.settransobject(sqlca)
dw_17.settransobject(sqlca)
dw_18.settransobject(sqlca)
dw_19.settransobject(sqlca)
dw_20.settransobject(sqlca)
dw_21.settransobject(sqlca)
end event

type dw_5 from w_main_root`dw_5 within w_smt_plan_feeder_monitoring_line_master
integer x = 3529
integer y = 340
integer width = 882
integer height = 1660
boolean titlebar = true
string title = "line Status"
string dataobject = "d_smt_master_line_lst"
boolean maxbox = false
end type

event dw_5::retrieveend;call super::retrieveend;String lvs_model_name

lvs_model_name = wf_model_name('05')
This.Object.model_name_t.Text = lvs_model_name
This.Object.line_namet_t.Text = 'SMT 5 LINE'


String lvs_pcb_item

lvs_pcb_item = wf_pcb_item('05')
This.Object.t_pcb_item.Text = lvs_pcb_item


string lvs_actuql_qty

lvs_actuql_qty = wf_actual_qty('05')
this.object.t_actual.text = lvs_actuql_qty

string lvs_carrier_qty

lvs_carrier_qty = wf_carrier_qty(lvs_model_name, '05')
this.object.t_carrier_qty.text = lvs_carrier_qty
end event

event dw_5::doubleclicked;call super::doubleclicked;String lvs_active, lvs_model_name

If This.RowCount() <= 0 Then Return

if rb_all.checked = true then 
   lvs_active = '%' 
else
   lvs_active = 'Y' 
end if 
lvs_model_name = wf_model_name('05')				

Gst_return.gvs_return[1] =  '05'
Gst_return.gvs_return[2] = lvs_model_name
Gst_return.gvs_return[3] = lvs_active
Gst_return.gvl_return[4]  =long(em_limit_qty.text)

openwithparm(w_smt_plan_feeder_monitoring_popup , This ) 

end event

type dw_4 from w_main_root`dw_4 within w_smt_plan_feeder_monitoring_line_master
integer x = 2647
integer y = 340
integer width = 882
integer height = 1660
boolean titlebar = true
string title = "line Status"
string dataobject = "d_smt_master_line_lst"
boolean maxbox = false
end type

event dw_4::retrieveend;call super::retrieveend;String lvs_model_name

lvs_model_name = wf_model_name('04')
This.Object.model_name_t.Text = lvs_model_name
This.Object.line_namet_t.Text = 'SMT 4 LINE'


String lvs_pcb_item

lvs_pcb_item = wf_pcb_item('04')
This.Object.t_pcb_item.Text = lvs_pcb_item


string lvs_actuql_qty

lvs_actuql_qty = wf_actual_qty('04')
this.object.t_actual.text = lvs_actuql_qty

string lvs_carrier_qty

lvs_carrier_qty = wf_carrier_qty(lvs_model_name, '04')
this.object.t_carrier_qty.text = lvs_carrier_qty
end event

event dw_4::doubleclicked;call super::doubleclicked;String lvs_active, lvs_model_name

If This.RowCount() <= 0 Then Return

if rb_all.checked = true then 
   lvs_active = '%' 
else
   lvs_active = 'Y' 
end if 
lvs_model_name = wf_model_name('04')				

Gst_return.gvs_return[1] =  '04'
Gst_return.gvs_return[2] = lvs_model_name
Gst_return.gvs_return[3] = lvs_active
Gst_return.gvl_return[4]  =long(em_limit_qty.text)

openwithparm(w_smt_plan_feeder_monitoring_popup , This ) 

end event

type dw_3 from w_main_root`dw_3 within w_smt_plan_feeder_monitoring_line_master
integer x = 1765
integer y = 340
integer width = 882
integer height = 1660
boolean titlebar = true
string title = "line Status"
string dataobject = "d_smt_master_line_lst"
boolean maxbox = false
end type

event dw_3::retrieveend;call super::retrieveend;String lvs_model_name

lvs_model_name = wf_model_name('03')
This.Object.model_name_t.Text = lvs_model_name
This.Object.line_namet_t.Text = 'SMT 3 LINE'


String lvs_pcb_item

lvs_pcb_item = wf_pcb_item('03')
This.Object.t_pcb_item.Text = lvs_pcb_item


string lvs_actuql_qty

lvs_actuql_qty = wf_actual_qty('03')
this.object.t_actual.text = lvs_actuql_qty

string lvs_carrier_qty

lvs_carrier_qty = wf_carrier_qty(lvs_model_name, '03')
this.object.t_carrier_qty.text = lvs_carrier_qty
end event

event dw_3::doubleclicked;call super::doubleclicked;String lvs_active, lvs_model_name

If This.RowCount() <= 0 Then Return

if rb_all.checked = true then 
   lvs_active = '%' 
else
   lvs_active = 'Y' 
end if 
lvs_model_name = wf_model_name('03')				

Gst_return.gvs_return[1] =  '03'
Gst_return.gvs_return[2] = lvs_model_name
Gst_return.gvs_return[3] = lvs_active
Gst_return.gvl_return[4]  =long(em_limit_qty.text)

openwithparm(w_smt_plan_feeder_monitoring_popup , This ) 
end event

type dw_2 from w_main_root`dw_2 within w_smt_plan_feeder_monitoring_line_master
integer x = 882
integer y = 340
integer width = 882
integer height = 1660
boolean titlebar = true
string title = "line Status"
string dataobject = "d_smt_master_line_lst"
boolean maxbox = false
end type

event dw_2::retrieveend;call super::retrieveend;String lvs_model_name

lvs_model_name = wf_model_name('02')
This.Object.model_name_t.Text = lvs_model_name
This.Object.line_namet_t.Text = 'SMT 2 LINE'


String lvs_pcb_item

lvs_pcb_item = wf_pcb_item('02')
This.Object.t_pcb_item.Text = lvs_pcb_item

string lvs_actuql_qty

lvs_actuql_qty = wf_actual_qty('02')
this.object.t_actual.text = lvs_actuql_qty

string lvs_carrier_qty

lvs_carrier_qty = wf_carrier_qty(lvs_model_name, '02')
this.object.t_carrier_qty.text = lvs_carrier_qty
end event

event dw_2::doubleclicked;call super::doubleclicked;String lvs_active, lvs_model_name

If This.RowCount() <= 0 Then Return

if rb_all.checked = true then 
   lvs_active = '%' 
else
   lvs_active = 'Y' 
end if 
lvs_model_name = wf_model_name('02')				

Gst_return.gvs_return[1] =  '02'
Gst_return.gvs_return[2] = lvs_model_name
Gst_return.gvs_return[3] = lvs_active
Gst_return.gvl_return[4]  =long(em_limit_qty.text)


openwithparm(w_smt_plan_feeder_monitoring_popup , This ) 
end event

type dw_1 from w_main_root`dw_1 within w_smt_plan_feeder_monitoring_line_master
event ue_lbuttondown pbm_lbuttondown
integer y = 344
integer width = 882
integer height = 1660
boolean titlebar = true
string title = "line Status"
string dataobject = "d_smt_master_line_lst"
boolean maxbox = false
end type

event dw_1::retrieveend;call super::retrieveend;String lvs_model_name

lvs_model_name = wf_model_name('01')
This.Object.model_name_t.Text = lvs_model_name
This.Object.line_namet_t.Text = 'SMT 1 LINE'


String lvs_pcb_item

lvs_pcb_item = wf_pcb_item('01')
This.Object.t_pcb_item.Text = lvs_pcb_item


string lvs_actuql_qty

lvs_actuql_qty = wf_actual_qty('01')
this.object.t_actual.text = lvs_actuql_qty

string lvs_carrier_qty

lvs_carrier_qty = wf_carrier_qty(lvs_model_name, '01')
this.object.t_carrier_qty.text = lvs_carrier_qty
end event

event dw_1::doubleclicked;call super::doubleclicked;String lvs_active, lvs_model_name

If This.RowCount() <= 0 Then Return

if rb_all.checked = true then 
   lvs_active = '%' 
else
   lvs_active = 'Y' 
end if 
lvs_model_name = wf_model_name('01')				

Gst_return.gvs_return[1] =  '01'
Gst_return.gvs_return[2] = lvs_model_name
Gst_return.gvs_return[3] = lvs_active
Gst_return.gvl_return[4]  =long(em_limit_qty.text)


openwithparm(w_smt_plan_feeder_monitoring_popup , This ) 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_smt_plan_feeder_monitoring_line_master
end type

type st_item_code from so_statictext within w_smt_plan_feeder_monitoring_line_master
integer x = 123
integer y = 72
integer width = 667
integer height = 56
boolean bringtotop = true
string text = "Model Name"
end type

type rb_all from so_radiobutton within w_smt_plan_feeder_monitoring_line_master
integer x = 818
integer y = 76
integer width = 288
boolean bringtotop = true
string text = "All"
end type

type rb_active from so_radiobutton within w_smt_plan_feeder_monitoring_line_master
integer x = 818
integer y = 180
integer width = 293
boolean bringtotop = true
string text = "Active"
boolean checked = true
end type

type cb_1 from so_commandbutton within w_smt_plan_feeder_monitoring_line_master
integer x = 2075
integer y = 60
integer width = 402
integer height = 100
integer taborder = 50
boolean bringtotop = true
string text = "Apply"
end type

event clicked;call super::clicked;lvs_apply_yn = 'Y'
timer( long(em_interval.text)) 
end event

type em_interval from so_editmask within w_smt_plan_feeder_monitoring_line_master
integer x = 2487
integer y = 164
integer width = 389
integer taborder = 120
boolean bringtotop = true
string text = "60"
string mask = "##0"
boolean spin = true
double increment = 1
end type

type st_2 from so_statictext within w_smt_plan_feeder_monitoring_line_master
integer x = 2112
integer y = 180
integer width = 297
integer height = 56
boolean bringtotop = true
string text = "Interval"
end type

type cb_2 from so_commandbutton within w_smt_plan_feeder_monitoring_line_master
integer x = 2482
integer y = 60
integer width = 402
integer height = 100
integer taborder = 60
boolean bringtotop = true
string text = "Stop"
end type

event clicked;call super::clicked;lvs_apply_yn = 'N'
timer(0)	
end event

type em_limit_qty from so_editmask within w_smt_plan_feeder_monitoring_line_master
integer x = 1559
integer y = 144
integer taborder = 120
boolean bringtotop = true
string text = "2000"
string mask = "###,##0"
boolean spin = true
double increment = 1
end type

type st_4 from so_statictext within w_smt_plan_feeder_monitoring_line_master
integer x = 1243
integer y = 156
integer width = 315
integer height = 56
boolean bringtotop = true
string text = "Limit Qty"
end type

type dw_6 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
integer x = 4411
integer y = 340
integer width = 882
integer height = 1660
integer taborder = 130
boolean bringtotop = true
boolean titlebar = true
string title = "line Status"
string dataobject = "d_smt_master_line_lst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event retrieveend;call super::retrieveend;String lvs_model_name

lvs_model_name = wf_model_name('06')
This.Object.model_name_t.Text = lvs_model_name
This.Object.line_namet_t.Text = 'SMT 6 LINE'


String lvs_pcb_item

lvs_pcb_item = wf_pcb_item('06')
This.Object.t_pcb_item.Text = lvs_pcb_item


string lvs_actuql_qty

lvs_actuql_qty = wf_actual_qty('06')
this.object.t_actual.text = lvs_actuql_qty

string lvs_carrier_qty

lvs_carrier_qty = wf_carrier_qty(lvs_model_name, '06')
this.object.t_carrier_qty.text = lvs_carrier_qty
end event

event doubleclicked;call super::doubleclicked;String lvs_active, lvs_model_name

If This.RowCount() <= 0 Then Return

if rb_all.checked = true then 
   lvs_active = '%' 
else
   lvs_active = 'Y' 
end if 
lvs_model_name = wf_model_name('06')				

Gst_return.gvs_return[1] =  '06'
Gst_return.gvs_return[2] = lvs_model_name
Gst_return.gvs_return[3] = lvs_active
Gst_return.gvl_return[4]  =long(em_limit_qty.text)


openwithparm(w_smt_plan_feeder_monitoring_popup , This ) 
end event

type dw_7 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
integer x = 5294
integer y = 340
integer width = 882
integer height = 1660
integer taborder = 140
boolean bringtotop = true
boolean titlebar = true
string title = "line Status"
string dataobject = "d_smt_master_line_lst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event retrieveend;call super::retrieveend;String lvs_model_name

lvs_model_name = wf_model_name('07')
This.Object.model_name_t.Text = lvs_model_name
This.Object.line_namet_t.Text = 'SMT 7 LINE'


String lvs_pcb_item

lvs_pcb_item = wf_pcb_item('07')
This.Object.t_pcb_item.Text = lvs_pcb_item



string lvs_actuql_qty

lvs_actuql_qty = wf_actual_qty('07')
this.object.t_actual.text = lvs_actuql_qty

string lvs_carrier_qty

lvs_carrier_qty = wf_carrier_qty(lvs_model_name, '07')
this.object.t_carrier_qty.text = lvs_carrier_qty
end event

event doubleclicked;call super::doubleclicked;String lvs_active, lvs_model_name

If This.RowCount() <= 0 Then Return

if rb_all.checked = true then 
   lvs_active = '%' 
else
   lvs_active = 'Y' 
end if 
lvs_model_name = wf_model_name('07')				

Gst_return.gvs_return[1] =  '07'
Gst_return.gvs_return[2] = lvs_model_name
Gst_return.gvs_return[3] = lvs_active
Gst_return.gvl_return[4]  =long(em_limit_qty.text)


openwithparm(w_smt_plan_feeder_monitoring_popup , This ) 
end event

type dw_8 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
integer x = 6176
integer y = 340
integer width = 882
integer height = 1660
integer taborder = 150
boolean bringtotop = true
boolean titlebar = true
string title = "line Status"
string dataobject = "d_smt_master_line_lst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event retrieveend;call super::retrieveend;String lvs_model_name

lvs_model_name = wf_model_name('08')
This.Object.model_name_t.Text = lvs_model_name
This.Object.line_namet_t.Text = 'SMT 8 LINE'


String lvs_pcb_item

lvs_pcb_item = wf_pcb_item('08')
This.Object.t_pcb_item.Text = lvs_pcb_item


string lvs_actuql_qty

lvs_actuql_qty = wf_actual_qty('08')
this.object.t_actual.text = lvs_actuql_qty
end event

event doubleclicked;call super::doubleclicked;String lvs_active, lvs_model_name

If This.RowCount() <= 0 Then Return

if rb_all.checked = true then 
   lvs_active = '%' 
else
   lvs_active = 'Y' 
end if 
lvs_model_name = wf_model_name('08')				

Gst_return.gvs_return[1] =  '08'
Gst_return.gvs_return[2] = lvs_model_name
Gst_return.gvs_return[3] = lvs_active
Gst_return.gvl_return[4]  =long(em_limit_qty.text)


openwithparm(w_smt_plan_feeder_monitoring_popup , This ) 

string lvs_carrier_qty

lvs_carrier_qty = wf_carrier_qty(lvs_model_name, '08')
this.object.t_carrier_qty.text = lvs_carrier_qty
end event

type dw_9 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
integer x = 7058
integer y = 340
integer width = 882
integer height = 1660
integer taborder = 160
boolean bringtotop = true
boolean titlebar = true
string title = "line Status"
string dataobject = "d_smt_master_line_lst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event retrieveend;call super::retrieveend;String lvs_model_name

lvs_model_name = wf_model_name('09')
This.Object.model_name_t.Text = lvs_model_name
This.Object.line_namet_t.Text = 'SMT 9 LINE'


String lvs_pcb_item

lvs_pcb_item = wf_pcb_item('09')
This.Object.t_pcb_item.Text = lvs_pcb_item



string lvs_actuql_qty

lvs_actuql_qty = wf_actual_qty('09')
this.object.t_actual.text = lvs_actuql_qty

string lvs_carrier_qty

lvs_carrier_qty = wf_carrier_qty(lvs_model_name, '09')
this.object.t_carrier_qty.text = lvs_carrier_qty
end event

event doubleclicked;call super::doubleclicked;String lvs_active, lvs_model_name

If This.RowCount() <= 0 Then Return

if rb_all.checked = true then 
   lvs_active = '%' 
else
   lvs_active = 'Y' 
end if 
lvs_model_name = wf_model_name('09')				

Gst_return.gvs_return[1] =  '09'
Gst_return.gvs_return[2] = lvs_model_name
Gst_return.gvs_return[3] = lvs_active
Gst_return.gvl_return[4]  =long(em_limit_qty.text)


openwithparm(w_smt_plan_feeder_monitoring_popup , This ) 
end event

type dw_10 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
integer x = 7941
integer y = 340
integer width = 882
integer height = 1660
integer taborder = 160
boolean bringtotop = true
boolean titlebar = true
string title = "line Status"
string dataobject = "d_smt_master_line_lst"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event retrieveend;call super::retrieveend;String lvs_model_name

lvs_model_name = wf_model_name('10')
This.Object.model_name_t.Text = lvs_model_name
This.Object.line_namet_t.Text = 'SMT 10 LINE'


String lvs_pcb_item

lvs_pcb_item = wf_pcb_item('10')
This.Object.t_pcb_item.Text = lvs_pcb_item


string lvs_actuql_qty

lvs_actuql_qty = wf_actual_qty('10')
this.object.t_actual.text = lvs_actuql_qty

string lvs_carrier_qty

lvs_carrier_qty = wf_carrier_qty(lvs_model_name, '10')
this.object.t_carrier_qty.text = lvs_carrier_qty
end event

event doubleclicked;call super::doubleclicked;String lvs_active, lvs_model_name

If This.RowCount() <= 0 Then Return

if rb_all.checked = true then 
   lvs_active = '%' 
else
   lvs_active = 'Y' 
end if 
lvs_model_name = wf_model_name('10')				

Gst_return.gvs_return[1] =  '10'
Gst_return.gvs_return[2] = lvs_model_name
Gst_return.gvs_return[3] = lvs_active
Gst_return.gvl_return[4]  =long(em_limit_qty.text)


openwithparm(w_smt_plan_feeder_monitoring_popup , This ) 

string lvs_carrier_qty

lvs_carrier_qty = wf_carrier_qty(lvs_model_name, '10')
this.object.t_carrier_qty.text = lvs_carrier_qty
end event

type dw_11 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
integer y = 2008
integer width = 882
integer height = 676
integer taborder = 20
boolean bringtotop = true
string title = ""
string dataobject = "d_smt_master_item_request_lst"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_12 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
integer x = 882
integer y = 2008
integer width = 882
integer height = 676
integer taborder = 30
boolean bringtotop = true
string title = ""
string dataobject = "d_smt_master_item_request_lst"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_13 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
integer x = 1765
integer y = 2008
integer width = 882
integer height = 676
integer taborder = 40
boolean bringtotop = true
string title = ""
string dataobject = "d_smt_master_item_request_lst"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_14 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
integer x = 2647
integer y = 2008
integer width = 882
integer height = 676
integer taborder = 50
boolean bringtotop = true
string title = ""
string dataobject = "d_smt_master_item_request_lst"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_15 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
integer x = 3529
integer y = 2008
integer width = 882
integer height = 676
integer taborder = 30
boolean bringtotop = true
string title = ""
string dataobject = "d_smt_master_item_request_lst"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_16 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
integer x = 4411
integer y = 2008
integer width = 882
integer height = 676
integer taborder = 40
boolean bringtotop = true
string title = ""
string dataobject = "d_smt_master_item_request_lst"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_17 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
integer x = 5294
integer y = 2008
integer width = 882
integer height = 676
integer taborder = 40
boolean bringtotop = true
string title = ""
string dataobject = "d_smt_master_item_request_lst"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_18 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
integer x = 6176
integer y = 2008
integer width = 882
integer height = 676
integer taborder = 50
boolean bringtotop = true
string title = ""
string dataobject = "d_smt_master_item_request_lst"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_19 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
integer x = 7058
integer y = 2008
integer width = 882
integer height = 676
integer taborder = 60
boolean bringtotop = true
string title = ""
string dataobject = "d_smt_master_item_request_lst"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_20 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
integer x = 7941
integer y = 2008
integer width = 882
integer height = 676
integer taborder = 60
boolean bringtotop = true
string title = ""
string dataobject = "d_smt_master_item_request_lst"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_3 from so_commandbutton within w_smt_plan_feeder_monitoring_line_master
integer x = 3077
integer y = 160
integer width = 631
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;String lvs_active , lvs_line_code , lvs_model_name

If rb_all.checked = True Then 
	lvs_active = '%' 
Else
	lvs_active = 'Y' 
End If 

dw_21.Reset()

lvs_line_code = ddlb_line_code.getcode( ) 
lvs_model_name = ddlb_model_name.getcode( )+'%'
dw_21.Retrieve(lvs_line_code , lvs_model_name ,  lvs_active , long(em_limit_qty.text) ,   gvi_organization_id )

//dw_21.bringtotop = true
If dw_21.RowCount() < 1 Then 
	//mess agebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX12$$9ccd25b860d5200090c7ccb800ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$")
	f_msg("$$HEX12$$9ccd25b860d5200090c7ccb800ac2000c6c5b5c2c8b2e4b2$$ENDHEX$$",'P')
	Return
ELSE
    dw_21.print()
END IF 
//openwithparm( w_zetprint ,  dw_21)
end event

type ddlb_line_code from uo_line_code_smt within w_smt_plan_feeder_monitoring_line_master
integer x = 3081
integer y = 68
integer taborder = 70
boolean bringtotop = true
end type

type gb_1 from so_groupbox within w_smt_plan_feeder_monitoring_line_master
integer x = 5
integer y = 4
integer width = 1115
integer height = 316
integer taborder = 30
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_smt_plan_feeder_monitoring_line_master
integer x = 2016
integer y = 4
integer width = 919
integer height = 316
integer taborder = 40
long textcolor = 16711680
string text = "Auto Retrieve"
end type

type gb_4 from so_groupbox within w_smt_plan_feeder_monitoring_line_master
integer x = 2958
integer y = 4
integer width = 832
integer height = 316
integer taborder = 50
long textcolor = 16711680
string text = "Print"
end type

type gb_2 from so_groupbox within w_smt_plan_feeder_monitoring_line_master
integer x = 1166
integer y = 4
integer width = 832
integer height = 316
integer taborder = 60
long textcolor = 16711680
string text = "Limit Qty"
end type

type dw_21 from so_datawindow within w_smt_plan_feeder_monitoring_line_master
integer y = 352
integer width = 2405
integer height = 1540
integer taborder = 130
boolean titlebar = true
string title = ""
string dataobject = "d_smt_master_line_rpt"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

type ddlb_model_name from uo_model_name_ddlb within w_smt_plan_feeder_monitoring_line_master
integer x = 119
integer y = 148
integer width = 667
integer height = 2092
integer taborder = 130
boolean bringtotop = true
end type


HA$PBExportHeader$w_smt_pickup_rate_last_data_query.srw
$PBExportComments$$$HEX6$$80bd88d42000c8b9a4c230d1$$ENDHEX$$
forward
global type w_smt_pickup_rate_last_data_query from w_main_root
end type
type cb_run from so_commandbutton within w_smt_pickup_rate_last_data_query
end type
type em_interval from so_editmask within w_smt_pickup_rate_last_data_query
end type
type st_3 from so_statictext within w_smt_pickup_rate_last_data_query
end type
type rb_monitoring from so_radiobutton within w_smt_pickup_rate_last_data_query
end type
type rb_2 from so_radiobutton within w_smt_pickup_rate_last_data_query
end type
type gb_where_condition from so_groupbox within w_smt_pickup_rate_last_data_query
end type
type gb_2 from so_groupbox within w_smt_pickup_rate_last_data_query
end type
type gb_1 from so_groupbox within w_smt_pickup_rate_last_data_query
end type
end forward

global type w_smt_pickup_rate_last_data_query from w_main_root
integer width = 5646
integer height = 2904
string title = "SMT Pickup Last Data Query"
windowstate windowstate = maximized!
cb_run cb_run
em_interval em_interval
st_3 st_3
rb_monitoring rb_monitoring
rb_2 rb_2
gb_where_condition gb_where_condition
gb_2 gb_2
gb_1 gb_1
end type
global w_smt_pickup_rate_last_data_query w_smt_pickup_rate_last_data_query

on w_smt_pickup_rate_last_data_query.create
int iCurrent
call super::create
this.cb_run=create cb_run
this.em_interval=create em_interval
this.st_3=create st_3
this.rb_monitoring=create rb_monitoring
this.rb_2=create rb_2
this.gb_where_condition=create gb_where_condition
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_run
this.Control[iCurrent+2]=this.em_interval
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.rb_monitoring
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.gb_where_condition
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.gb_1
end on

on w_smt_pickup_rate_last_data_query.destroy
call super::destroy
destroy(this.cb_run)
destroy(this.em_interval)
destroy(this.st_3)
destroy(this.rb_monitoring)
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
	
		     DW_1.RETRIEVE()
			DW_1.SETFOCUS()
		
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

timer( dec(em_interval.text))
end event

event timer;call super::timer;f_retrieve()
end event

event close;call super::close;timer(0)
end event

event deactivate;call super::deactivate;timer(0)
end event

type dw_5 from w_main_root`dw_5 within w_smt_pickup_rate_last_data_query
integer y = 392
string dataobject = "d_mat_item_msl_check_returny_lst"
end type

type dw_4 from w_main_root`dw_4 within w_smt_pickup_rate_last_data_query
integer y = 404
string dataobject = "d_mat_item_msl_check_inventory_lst"
end type

type dw_3 from w_main_root`dw_3 within w_smt_pickup_rate_last_data_query
integer y = 392
integer width = 4681
integer height = 1096
integer taborder = 50
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_smt_pickup_rate_last_data_query
integer y = 392
integer width = 4681
integer height = 660
integer taborder = 0
boolean titlebar = true
end type

event dw_2::getfocus;call super::getfocus;timer(0)
end event

type dw_1 from w_main_root`dw_1 within w_smt_pickup_rate_last_data_query
integer y = 392
integer width = 4681
integer height = 1096
integer taborder = 40
boolean titlebar = true
string title = "Last gatering time"
string dataobject = "d_smt_pickup_rate_last_date_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_smt_pickup_rate_last_data_query
end type

type cb_run from so_commandbutton within w_smt_pickup_rate_last_data_query
integer x = 1970
integer y = 124
integer width = 361
integer height = 156
integer taborder = 30
boolean bringtotop = true
string text = "Run"
end type

event clicked;call super::clicked;timer(dec(em_interval.text))
end event

type em_interval from so_editmask within w_smt_pickup_rate_last_data_query
integer x = 1545
integer y = 188
integer height = 84
integer taborder = 40
boolean bringtotop = true
string text = "00"
string mask = "##0.00"
boolean spin = true
string minmax = "10~~"
end type

event modified;call super::modified;timer(dec(this.text))
end event

type st_3 from so_statictext within w_smt_pickup_rate_last_data_query
integer x = 1545
integer y = 104
integer width = 402
integer height = 60
boolean bringtotop = true
string text = "Interval"
end type

type rb_monitoring from so_radiobutton within w_smt_pickup_rate_last_data_query
integer x = 101
integer y = 160
boolean bringtotop = true
string text = "Pickup Rate data"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
dw_2.bringtotop = true 
selected_data_window = dw_1
end event

type rb_2 from so_radiobutton within w_smt_pickup_rate_last_data_query
boolean visible = false
integer x = 101
integer y = 268
boolean bringtotop = true
string text = "Check History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3
end event

type gb_where_condition from so_groupbox within w_smt_pickup_rate_last_data_query
integer x = 1486
integer y = 4
integer width = 919
integer height = 360
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_smt_pickup_rate_last_data_query
integer x = 14
integer width = 677
integer height = 360
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_1 from so_groupbox within w_smt_pickup_rate_last_data_query
integer x = 709
integer width = 759
integer height = 360
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


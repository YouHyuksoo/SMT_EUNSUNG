HA$PBExportHeader$w_mat_material_request_master.srw
$PBExportComments$$$HEX6$$80bd88d42000c8b9a4c230d1$$ENDHEX$$
forward
global type w_mat_material_request_master from w_main_root
end type
type st_2 from so_statictext within w_mat_material_request_master
end type
type st_1 from so_statictext within w_mat_material_request_master
end type
type cb_1 from so_commandbutton within w_mat_material_request_master
end type
type uo_item from uo_item_code within w_mat_material_request_master
end type
type st_5 from so_statictext within w_mat_material_request_master
end type
type em_interval from so_editmask within w_mat_material_request_master
end type
type st_3 from so_statictext within w_mat_material_request_master
end type
type rb_request_list from so_radiobutton within w_mat_material_request_master
end type
type rb_request_history from so_radiobutton within w_mat_material_request_master
end type
type uo_dateset from uo_ymd_calendar within w_mat_material_request_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_material_request_master
end type
type st_4 from so_statictext within w_mat_material_request_master
end type
type ddlb_line_code from uo_line_code within w_mat_material_request_master
end type
type sle_machine_code from singlelineedit within w_mat_material_request_master
end type
type gb_where_condition from so_groupbox within w_mat_material_request_master
end type
type gb_1 from so_groupbox within w_mat_material_request_master
end type
type gb_2 from so_groupbox within w_mat_material_request_master
end type
end forward

global type w_mat_material_request_master from w_main_root
integer width = 5056
integer height = 2904
string title = "Material Request Query"
windowstate windowstate = maximized!
st_2 st_2
st_1 st_1
cb_1 cb_1
uo_item uo_item
st_5 st_5
em_interval em_interval
st_3 st_3
rb_request_list rb_request_list
rb_request_history rb_request_history
uo_dateset uo_dateset
uo_dateend uo_dateend
st_4 st_4
ddlb_line_code ddlb_line_code
sle_machine_code sle_machine_code
gb_where_condition gb_where_condition
gb_1 gb_1
gb_2 gb_2
end type
global w_mat_material_request_master w_mat_material_request_master

on w_mat_material_request_master.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_1=create st_1
this.cb_1=create cb_1
this.uo_item=create uo_item
this.st_5=create st_5
this.em_interval=create em_interval
this.st_3=create st_3
this.rb_request_list=create rb_request_list
this.rb_request_history=create rb_request_history
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_4=create st_4
this.ddlb_line_code=create ddlb_line_code
this.sle_machine_code=create sle_machine_code
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.uo_item
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.em_interval
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.rb_request_list
this.Control[iCurrent+9]=this.rb_request_history
this.Control[iCurrent+10]=this.uo_dateset
this.Control[iCurrent+11]=this.uo_dateend
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.ddlb_line_code
this.Control[iCurrent+14]=this.sle_machine_code
this.Control[iCurrent+15]=this.gb_where_condition
this.Control[iCurrent+16]=this.gb_1
this.Control[iCurrent+17]=this.gb_2
end on

on w_mat_material_request_master.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.uo_item)
destroy(this.st_5)
destroy(this.em_interval)
destroy(this.st_3)
destroy(this.rb_request_list)
destroy(this.rb_request_history)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_4)
destroy(this.ddlb_line_code)
destroy(this.sle_machine_code)
destroy(this.gb_where_condition)
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

timer( dec(em_interval.text))
end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_SETYN

CHOOSE CASE Gvs_Ue_data_control
		
	CASE 'RETRIEVE'
		   if rb_request_list.checked = true then 
			DW_1.RETRIEVE(  ddlb_line_code.getcode( )+'%' ,sle_machine_code.text+'%' , uo_item.text+'%' ,  GVI_ORGANIZATION_ID )
			DW_1.SETFOCUS()
		else
			DW_2.RETRIEVE(  ddlb_line_code.getcode( )+'%' , sle_machine_code.text+'%' , uo_item.text+'%' ,uo_dateset.TEXT() , uo_dateend.text() ,  GVI_ORGANIZATION_ID )
			DW_2.SETFOCUS()			
		end if 
	
	CASE ELSE
		
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

type dw_5 from w_main_root`dw_5 within w_mat_material_request_master
integer y = 320
end type

type dw_4 from w_main_root`dw_4 within w_mat_material_request_master
integer y = 320
end type

type dw_3 from w_main_root`dw_3 within w_mat_material_request_master
integer y = 320
integer taborder = 50
end type

type dw_2 from w_main_root`dw_2 within w_mat_material_request_master
integer y = 320
integer width = 4507
integer height = 1208
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_request_hist"
end type

type dw_1 from w_main_root`dw_1 within w_mat_material_request_master
integer y = 320
integer width = 4507
integer height = 1208
integer taborder = 40
boolean titlebar = true
string title = "Material Request List"
string dataobject = "d_mat_request_lst"
end type

event dw_1::retrieveend;call super::retrieveend;if rowcount > 0 then 
	
	f_play_sound("apply.wav")
	
end if 
end event

event dw_1::retrievestart;//OVER 
end event

event dw_1::retrieverow;//OVER
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_material_request_master
end type

type st_2 from so_statictext within w_mat_material_request_master
integer x = 754
integer y = 88
integer width = 590
integer height = 56
boolean bringtotop = true
string text = "Line Code"
end type

type st_1 from so_statictext within w_mat_material_request_master
integer x = 1431
integer y = 88
integer width = 590
integer height = 56
boolean bringtotop = true
string text = "Machine Code"
end type

type cb_1 from so_commandbutton within w_mat_material_request_master
integer x = 4251
integer y = 88
integer height = 156
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string text = "Delete History"
end type

event clicked;call super::clicked;msg = f_msgbox1(1161 , this.text )
if msg = 1 then 

	
	delete from im_item_request where request_status = 'C' 
	 and organization_id = :gvi_organization_id ;
	 
	 if f_sql_check() < 0 then 
		return 
	end if 
	
	commit ;


end if 
end event

type uo_item from uo_item_code within w_mat_material_request_master
integer x = 2085
integer y = 164
integer width = 581
integer height = 1364
integer taborder = 40
boolean bringtotop = true
end type

type st_5 from so_statictext within w_mat_material_request_master
integer x = 2085
integer y = 88
integer width = 581
integer height = 56
boolean bringtotop = true
boolean enabled = false
string text = "Item Code"
end type

type em_interval from so_editmask within w_mat_material_request_master
integer x = 3735
integer y = 164
integer taborder = 40
boolean bringtotop = true
string text = "0"
string mask = "##0.00"
boolean spin = true
string minmax = "10~~"
end type

event modified;call super::modified;timer(dec(this.text))
end event

type st_3 from so_statictext within w_mat_material_request_master
integer x = 3735
integer y = 88
integer width = 402
boolean bringtotop = true
string text = "Interval"
end type

type rb_request_list from so_radiobutton within w_mat_material_request_master
integer x = 59
integer y = 80
boolean bringtotop = true
string text = "Request List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1

timer( dec(em_interval.text))
end event

type rb_request_history from so_radiobutton within w_mat_material_request_master
integer x = 59
integer y = 176
boolean bringtotop = true
string text = "Request History"
end type

event clicked;call super::clicked;dw_2.bringtotop = true
selected_data_window = dw_2
TIMER(0)
end event

type uo_dateset from uo_ymd_calendar within w_mat_material_request_master
event destroy ( )
integer x = 2743
integer y = 164
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_material_request_master
event destroy ( )
integer x = 3182
integer y = 164
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_mat_material_request_master
integer x = 2770
integer y = 88
integer width = 814
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Request Date"
end type

type ddlb_line_code from uo_line_code within w_mat_material_request_master
integer x = 736
integer y = 164
integer height = 1364
integer taborder = 40
boolean bringtotop = true
boolean allowedit = true
end type

type sle_machine_code from singlelineedit within w_mat_material_request_master
integer x = 1390
integer y = 164
integer width = 667
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type gb_where_condition from so_groupbox within w_mat_material_request_master
integer x = 3675
integer y = 4
integer width = 1170
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_mat_material_request_master
integer width = 672
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_material_request_master
integer x = 686
integer width = 2967
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


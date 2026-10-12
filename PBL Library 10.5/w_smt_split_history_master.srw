HA$PBExportHeader$w_smt_split_history_master.srw
$PBExportComments$$$HEX6$$80bd88d42000c8b9a4c230d1$$ENDHEX$$
forward
global type w_smt_split_history_master from w_main_root
end type
type st_line_code from so_statictext within w_smt_split_history_master
end type
type sle_machine_code from so_singlelineedit within w_smt_split_history_master
end type
type st_machine_code from so_statictext within w_smt_split_history_master
end type
type ddlb_line_code from uo_line_code within w_smt_split_history_master
end type
type uo_dateset from uo_ymd_calendar within w_smt_split_history_master
end type
type uo_dateend from uo_ymd_calendar within w_smt_split_history_master
end type
type st_1 from so_statictext within w_smt_split_history_master
end type
type ddlb_pcb_item from uo_basecode within w_smt_split_history_master
end type
type st_2 from so_statictext within w_smt_split_history_master
end type
type ddlb_model_name from uo_model_name_ddlb within w_smt_split_history_master
end type
type st_3 from so_statictext within w_smt_split_history_master
end type
type sle_run_no from so_singlelineedit within w_smt_split_history_master
end type
type st_run_no from so_statictext within w_smt_split_history_master
end type
type gb_2 from so_groupbox within w_smt_split_history_master
end type
end forward

global type w_smt_split_history_master from w_main_root
integer width = 4736
integer height = 2904
string title = "SMT Split Location History"
st_line_code st_line_code
sle_machine_code sle_machine_code
st_machine_code st_machine_code
ddlb_line_code ddlb_line_code
uo_dateset uo_dateset
uo_dateend uo_dateend
st_1 st_1
ddlb_pcb_item ddlb_pcb_item
st_2 st_2
ddlb_model_name ddlb_model_name
st_3 st_3
sle_run_no sle_run_no
st_run_no st_run_no
gb_2 gb_2
end type
global w_smt_split_history_master w_smt_split_history_master

on w_smt_split_history_master.create
int iCurrent
call super::create
this.st_line_code=create st_line_code
this.sle_machine_code=create sle_machine_code
this.st_machine_code=create st_machine_code
this.ddlb_line_code=create ddlb_line_code
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_1=create st_1
this.ddlb_pcb_item=create ddlb_pcb_item
this.st_2=create st_2
this.ddlb_model_name=create ddlb_model_name
this.st_3=create st_3
this.sle_run_no=create sle_run_no
this.st_run_no=create st_run_no
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_line_code
this.Control[iCurrent+2]=this.sle_machine_code
this.Control[iCurrent+3]=this.st_machine_code
this.Control[iCurrent+4]=this.ddlb_line_code
this.Control[iCurrent+5]=this.uo_dateset
this.Control[iCurrent+6]=this.uo_dateend
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.ddlb_pcb_item
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.ddlb_model_name
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.sle_run_no
this.Control[iCurrent+13]=this.st_run_no
this.Control[iCurrent+14]=this.gb_2
end on

on w_smt_split_history_master.destroy
call super::destroy
destroy(this.st_line_code)
destroy(this.sle_machine_code)
destroy(this.st_machine_code)
destroy(this.ddlb_line_code)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_1)
destroy(this.ddlb_pcb_item)
destroy(this.st_2)
destroy(this.ddlb_model_name)
destroy(this.st_3)
destroy(this.sle_run_no)
destroy(this.st_run_no)
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
Ivs_resize_type    = 'MASTER_DETAIL_145_23M'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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
STRING LVS_SETYN
CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		     
			DW_1.RETRIEVE(  uo_dateset.text() , uo_Dateend.text() , ddlb_line_code.getcode( )+'%' , sle_machine_code.text+'%' ,ddlb_model_name.getcode()+'%' ,  ddlb_pcb_item.getcode() +'%' , sle_run_no.text+'%' ,   GVI_ORGANIZATION_ID )
			DW_1.SETFOCUS()		
			
		CASE 'UPDATE'
			
			 IF GVI_USER_LEVEL < 8 THEN 
				F_MSG("$$HEX11$$00c8a5c720008cad5cd574c72000c6c5b5c2c8b2e4b2$$ENDHEX$$" , 'P') 
				RETURN 
			ELSE
			
				 IF DW_2.UPDATE() < 0 THEN 
							 ROLLBACK;
				 ELSE
					 COMMIT ;
				END IF 
			END IF 
			
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
//f_retrieve()
end event

type dw_5 from w_main_root`dw_5 within w_smt_split_history_master
integer y = 320
end type

type dw_4 from w_main_root`dw_4 within w_smt_split_history_master
integer x = 5
integer y = 320
end type

type dw_3 from w_main_root`dw_3 within w_smt_split_history_master
integer x = 2290
integer y = 1548
integer width = 2277
integer height = 1020
integer taborder = 50
boolean titlebar = true
string dataobject = "d_smt_checklist_4_split_check_lst"
end type

type dw_2 from w_main_root`dw_2 within w_smt_split_history_master
integer y = 1548
integer width = 2277
integer height = 1020
integer taborder = 0
boolean titlebar = true
string title = "Plan Dat List"
string dataobject = "d_smt_plandata_simple_4_split_lst"
end type

type dw_1 from w_main_root`dw_1 within w_smt_split_history_master
integer y = 316
integer width = 4549
integer height = 1208
integer taborder = 40
boolean titlebar = true
string title = "Event List"
string dataobject = "d_smt_split_history_lst"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;// ACTIVE YN = 'Y' $$HEX4$$78c774acccb92000$$ENDHEX$$
if currentrow < 1 then return 

dw_2.retrieve( this.object.line_code[currentrow] , this.object.model_name[currentrow],  gvi_organization_id )
dw_3.retrieve( this.object.line_code[currentrow] , this.object.location_code[currentrow]  ,  this.object.model_name[currentrow],  gvi_organization_id )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_smt_split_history_master
end type

type st_line_code from so_statictext within w_smt_split_history_master
integer x = 928
integer y = 68
integer width = 590
integer height = 56
boolean bringtotop = true
string text = "Line Code"
end type

type sle_machine_code from so_singlelineedit within w_smt_split_history_master
integer x = 1522
integer y = 144
integer width = 590
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type st_machine_code from so_statictext within w_smt_split_history_master
integer x = 1522
integer y = 76
integer width = 590
integer height = 56
boolean bringtotop = true
string text = "Machine"
end type

type ddlb_line_code from uo_line_code within w_smt_split_history_master
integer x = 901
integer y = 144
integer width = 617
integer height = 1964
integer taborder = 20
boolean bringtotop = true
boolean allowedit = true
end type

event selectionchanged;call super::selectionchanged;F_RETRIEVE()
end event

type uo_dateset from uo_ymd_calendar within w_smt_split_history_master
event destroy ( )
integer x = 55
integer y = 144
integer taborder = 80
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_smt_split_history_master
event destroy ( )
integer x = 475
integer y = 144
integer taborder = 90
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_1 from so_statictext within w_smt_split_history_master
integer x = 87
integer y = 68
integer width = 795
integer height = 56
boolean bringtotop = true
string text = "Split Date"
end type

type ddlb_pcb_item from uo_basecode within w_smt_split_history_master
integer x = 2921
integer y = 140
integer width = 544
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;THIS.REDRAW( 'PCB ITEM')
end event

type st_2 from so_statictext within w_smt_split_history_master
integer x = 2926
integer y = 72
integer width = 544
integer height = 56
boolean bringtotop = true
string text = "PCB Item"
end type

type ddlb_model_name from uo_model_name_ddlb within w_smt_split_history_master
integer x = 2130
integer y = 136
integer width = 777
integer taborder = 40
boolean bringtotop = true
end type

type st_3 from so_statictext within w_smt_split_history_master
integer x = 2217
integer y = 80
integer width = 590
integer height = 52
boolean bringtotop = true
string text = "Model Name"
end type

type sle_run_no from so_singlelineedit within w_smt_split_history_master
integer x = 3474
integer y = 140
integer width = 590
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type st_run_no from so_statictext within w_smt_split_history_master
integer x = 3474
integer y = 72
integer width = 590
integer height = 56
boolean bringtotop = true
string text = "Run No"
end type

type gb_2 from so_groupbox within w_smt_split_history_master
integer x = 14
integer width = 4087
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


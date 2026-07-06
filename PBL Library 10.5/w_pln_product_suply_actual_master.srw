HA$PBExportHeader$w_pln_product_suply_actual_master.srw
$PBExportComments$$$HEX8$$80bd88d42000c8b9a4c230d10d000a00$$ENDHEX$$forward
global type w_pln_product_suply_actual_master from w_main_root
end type
type st_2 from so_statictext within w_pln_product_suply_actual_master
end type
type ddlb_line_code from uo_line_code_suply within w_pln_product_suply_actual_master
end type
type ddlb_model_name from uo_smt_model_name_ddlb within w_pln_product_suply_actual_master
end type
type st_1 from so_statictext within w_pln_product_suply_actual_master
end type
type cb_1 from so_commandbutton within w_pln_product_suply_actual_master
end type
type cb_cancel from so_commandbutton within w_pln_product_suply_actual_master
end type
type rb_plan_list from so_radiobutton within w_pln_product_suply_actual_master
end type
type rb_actual_list from so_radiobutton within w_pln_product_suply_actual_master
end type
type uo_dateset from uo_ymd_calendar within w_pln_product_suply_actual_master
end type
type uo_dateend from uo_ymd_calendar within w_pln_product_suply_actual_master
end type
type st_5 from so_statictext within w_pln_product_suply_actual_master
end type
type gb_1 from so_groupbox within w_pln_product_suply_actual_master
end type
type gb_2 from so_groupbox within w_pln_product_suply_actual_master
end type
type gb_3 from so_groupbox within w_pln_product_suply_actual_master
end type
end forward

global type w_pln_product_suply_actual_master from w_main_root
integer width = 4992
integer height = 2904
string title = "Material Request Master"
windowstate windowstate = maximized!
st_2 st_2
ddlb_line_code ddlb_line_code
ddlb_model_name ddlb_model_name
st_1 st_1
cb_1 cb_1
cb_cancel cb_cancel
rb_plan_list rb_plan_list
rb_actual_list rb_actual_list
uo_dateset uo_dateset
uo_dateend uo_dateend
st_5 st_5
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_pln_product_suply_actual_master w_pln_product_suply_actual_master

on w_pln_product_suply_actual_master.create
int iCurrent
call super::create
this.st_2=create st_2
this.ddlb_line_code=create ddlb_line_code
this.ddlb_model_name=create ddlb_model_name
this.st_1=create st_1
this.cb_1=create cb_1
this.cb_cancel=create cb_cancel
this.rb_plan_list=create rb_plan_list
this.rb_actual_list=create rb_actual_list
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_5=create st_5
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.ddlb_line_code
this.Control[iCurrent+3]=this.ddlb_model_name
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.rb_plan_list
this.Control[iCurrent+8]=this.rb_actual_list
this.Control[iCurrent+9]=this.uo_dateset
this.Control[iCurrent+10]=this.uo_dateend
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.gb_3
end on

on w_pln_product_suply_actual_master.destroy
call super::destroy
destroy(this.st_2)
destroy(this.ddlb_line_code)
destroy(this.ddlb_model_name)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.cb_cancel)
destroy(this.rb_plan_list)
destroy(this.rb_actual_list)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_5)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event activate;call super::activate;/***************************************
* $$HEX19$$08c7c4b324c115c8d0c5200000ad5cd52000acc06dd544c720004bc105d35cd5e4b20d000a00$$ENDHEX$$*
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
* Menu Property $$HEX8$$54ba74b2200078d5e4b4c1b90d000a00$$ENDHEX$$*****************************************
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
		IF RB_PLAN_LIST.CHecked = TRUE THEN 
			DW_1.RETRIEVE( ddlb_line_code.getcode()+ '%'  , ddlb_model_name.getcode()+'%' , uo_dateset.text() , uo_dateend.text() , gvi_organization_id  )
			DW_1.SETFOCUS()
		ELSE
			DW_4.RETRIEVE( ddlb_line_code.getcode()+ '%'  , ddlb_model_name.getcode()+'%' , uo_dateset.text() , uo_dateend.text() , gvi_organization_id )
			DW_4.SETFOCUS()			
			
		END IF 
CASE  'INSERT' 
	
			DW_1.ENABLED = TRUE
			ROW =DW_1.INSERTROW(DW_1.GETROW())
			DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_1 , ROW ,'ALL')				
			DW_1.OBject.LINE_CODE[ROW] = DDLB_line_code.GETCODE()
			DW_1.OBject.PLAN_DATE[ROW] =F_SYSDATE()		
			DW_1.OBject.PLAN_SEQUENCE[ROW] =F_GET_SEQUENCE('SEQ_PLAN_DATE_SEQUECE')

CASE  'APPEND' 

			DW_2.ENABLED = TRUE
			ROW =DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
			
			if dw_1.getrow() < 1 then 
			
				DW_2.OBject.LINE_CODE[ROW] = DDLB_line_code.GETCODE()
				DW_2.OBject.RECEIPT_DATE[ROW] =F_SYSDATE()
				DW_2.OBject.RECEIPT_SEQUENCE[ROW] = F_GET_SEQUENCE('SEQ_PRODUCT_SENSOR')
			else
				DW_2.OBject.LINE_CODE[ROW] = DW_1.OBject.LINE_CODE[DW_1.GETROW()] 
				DW_2.OBject.RECEIPT_DATE[ROW] =F_SYSDATE()
				DW_2.OBject.RECEIPT_SEQUENCE[ROW] = F_GET_SEQUENCE('SEQ_PRODUCT_SENSOR')
				DW_2.OBject.MODEL_NAME[ROW] = DW_1.OBject.MODEL_NAME[DW_1.GETROW()] 
				DW_2.OBject.PCB_ITEM[ROW] = DW_1.OBject.PCB_ITEM[DW_1.GETROW()] 
				DW_2.OBject.REVISION[ROW] = DW_1.OBject.REVISION[DW_1.GETROW()] 
				DW_2.OBject.MFS[ROW] = DW_1.OBject.MFS[DW_1.GETROW()] 
		   end if 
	
CASE  'DELETE' 
	
			if DW_1.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted =DW_1.GetRow()			
				DW_1.DELETEROW(Gvl_row_deleted)		
				DW_1.SetFocus()
				ROW =DW_1.GetRow()
				DW_1.ScrollToRow(row)
				DW_1.SetColumn(1)
			END IF

	CASE 'UPDATE'

	         IF DW_1.UPDATE() < 0 or DW_2.UPDATE() < 0  THEN
			  	 ROLLBACK;
			ELSE
				  COMMIT;
	              //  F_RETRIEVE()
				   F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF

	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX17$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c80d000a00$$ENDHEX$$*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


end event

event timer;call super::timer;f_retrieve()
end event

event close;call super::close;timer(0)
end event

event deactivate;call super::deactivate;timer(0)
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_suply_actual_master
integer y = 320
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_suply_actual_master
integer y = 320
integer width = 4471
integer height = 1208
boolean titlebar = true
string title = "Actual History"
string dataobject = "d_pln_product_suply_actual_hst"
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_suply_actual_master
integer x = 2578
integer y = 1532
integer width = 2213
integer height = 1208
integer taborder = 50
boolean titlebar = true
string title = "Inventory List"
string dataobject = "d_mat_workstage_inventory_4_suply_lst"
end type

type dw_2 from w_main_root`dw_2 within w_pln_product_suply_actual_master
integer y = 1528
integer width = 2565
integer height = 1208
integer taborder = 0
boolean titlebar = true
string title = "Product Actual List"
string dataobject = "d_pln_product_suply_actual_lst"
end type

event dw_2::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 

dw_3.retrieve( this.object.line_code[currentrow]  , gvi_organization_id    )
end event

type dw_1 from w_main_root`dw_1 within w_pln_product_suply_actual_master
integer y = 320
integer width = 4782
integer height = 1208
integer taborder = 40
boolean titlebar = true
string title = "Suply Plan List"
string dataobject = "d_pln_product_suply_plan_lst"
end type

event dw_1::retrievestart;//OVER 
end event

event dw_1::retrieverow;//OVER
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve(  this.object.line_code[currentrow] ,    this.object.mfs[currentrow] , this.object.model_name[currentrow] , this.object.pcb_item[currentrow] ,  this.object.revision[currentrow] , gvi_organization_id )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_suply_actual_master
end type

type st_2 from so_statictext within w_pln_product_suply_actual_master
integer x = 855
integer y = 88
integer width = 466
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type ddlb_line_code from uo_line_code_suply within w_pln_product_suply_actual_master
integer x = 855
integer y = 176
integer width = 466
integer taborder = 20
boolean bringtotop = true
end type

type ddlb_model_name from uo_smt_model_name_ddlb within w_pln_product_suply_actual_master
integer x = 1330
integer y = 180
integer width = 727
integer height = 1640
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( )
end event

type st_1 from so_statictext within w_pln_product_suply_actual_master
integer x = 1339
integer y = 92
integer width = 713
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Model Name"
end type

type cb_1 from so_commandbutton within w_pln_product_suply_actual_master
integer x = 3058
integer y = 108
integer height = 132
integer taborder = 30
boolean bringtotop = true
string text = "Receipt Actual"
end type

event clicked;call super::clicked;f_append()
end event

type cb_cancel from so_commandbutton within w_pln_product_suply_actual_master
integer x = 3598
integer y = 108
integer height = 132
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string text = "Actual Cancel"
end type

event clicked;call super::clicked;if dw_2.getrow() < 1 then return 
dw_2.deleterow( dw_2.getrow())
end event

type rb_plan_list from so_radiobutton within w_pln_product_suply_actual_master
integer x = 165
integer y = 88
boolean bringtotop = true
string text = "Plan List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

cb_cancel.enabled = false
end event

type rb_actual_list from so_radiobutton within w_pln_product_suply_actual_master
integer x = 165
integer y = 188
boolean bringtotop = true
string text = "Acutual List"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4

cb_cancel.enabled = true
end event

type uo_dateset from uo_ymd_calendar within w_pln_product_suply_actual_master
event destroy ( )
integer x = 2066
integer y = 176
integer taborder = 40
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_pln_product_suply_actual_master
event destroy ( )
integer x = 2487
integer y = 176
integer taborder = 50
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_5 from so_statictext within w_pln_product_suply_actual_master
integer x = 2075
integer y = 96
integer width = 827
integer height = 68
boolean bringtotop = true
string text = "Plan Date"
end type

type gb_1 from so_groupbox within w_pln_product_suply_actual_master
integer x = 18
integer width = 754
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_pln_product_suply_actual_master
integer x = 2985
integer width = 1198
integer height = 304
integer taborder = 20
integer weight = 700
string text = "Process"
end type

type gb_3 from so_groupbox within w_pln_product_suply_actual_master
integer x = 786
integer width = 2181
integer height = 300
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


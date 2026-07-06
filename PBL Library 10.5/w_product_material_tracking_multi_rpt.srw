HA$PBExportHeader$w_product_material_tracking_multi_rpt.srw
$PBExportComments$new a led project
forward
global type w_product_material_tracking_multi_rpt from w_main_root
end type
type sle_serial_no from so_singlelineedit within w_product_material_tracking_multi_rpt
end type
type st_1 from statictext within w_product_material_tracking_multi_rpt
end type
type st_5 from so_statictext within w_product_material_tracking_multi_rpt
end type
type st_2 from statictext within w_product_material_tracking_multi_rpt
end type
type st_6 from statictext within w_product_material_tracking_multi_rpt
end type
type ddlb_workstage_code from uo_workstage_code_all within w_product_material_tracking_multi_rpt
end type
type ddlb_line_code from uo_line_code within w_product_material_tracking_multi_rpt
end type
type ddlb_model_name from uo_model_name_ddlb within w_product_material_tracking_multi_rpt
end type
type st_3 from statictext within w_product_material_tracking_multi_rpt
end type
type em_1 from so_editmask within w_product_material_tracking_multi_rpt
end type
type em_2 from so_editmask within w_product_material_tracking_multi_rpt
end type
type st_4 from statictext within w_product_material_tracking_multi_rpt
end type
type gb_2 from so_groupbox within w_product_material_tracking_multi_rpt
end type
end forward

global type w_product_material_tracking_multi_rpt from w_main_root
string title = "Material Tracking Multi Query(Dynamic)"
sle_serial_no sle_serial_no
st_1 st_1
st_5 st_5
st_2 st_2
st_6 st_6
ddlb_workstage_code ddlb_workstage_code
ddlb_line_code ddlb_line_code
ddlb_model_name ddlb_model_name
st_3 st_3
em_1 em_1
em_2 em_2
st_4 st_4
gb_2 gb_2
end type
global w_product_material_tracking_multi_rpt w_product_material_tracking_multi_rpt

type variables

end variables

on w_product_material_tracking_multi_rpt.create
int iCurrent
call super::create
this.sle_serial_no=create sle_serial_no
this.st_1=create st_1
this.st_5=create st_5
this.st_2=create st_2
this.st_6=create st_6
this.ddlb_workstage_code=create ddlb_workstage_code
this.ddlb_line_code=create ddlb_line_code
this.ddlb_model_name=create ddlb_model_name
this.st_3=create st_3
this.em_1=create em_1
this.em_2=create em_2
this.st_4=create st_4
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_serial_no
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_6
this.Control[iCurrent+6]=this.ddlb_workstage_code
this.Control[iCurrent+7]=this.ddlb_line_code
this.Control[iCurrent+8]=this.ddlb_model_name
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.em_1
this.Control[iCurrent+11]=this.em_2
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.gb_2
end on

on w_product_material_tracking_multi_rpt.destroy
call super::destroy
destroy(this.sle_serial_no)
destroy(this.st_1)
destroy(this.st_5)
destroy(this.st_2)
destroy(this.st_6)
destroy(this.ddlb_workstage_code)
destroy(this.ddlb_line_code)
destroy(this.ddlb_model_name)
destroy(this.st_3)
destroy(this.em_1)
destroy(this.em_2)
destroy(this.st_4)
destroy(this.gb_2)
end on

event activate;call super::activate;/***************************************
* Window Default Property 
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = True  // Report Window  True / Flase

/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'MASTER_DETAIL_1L2R'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property 
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('REPORT' , TRUE)  // All Data Control
end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


end event

event ue_data_control;call super::ue_data_control;
CHOOSE CASE Gvs_Ue_DATA_control
		
	CASE 'RETRIEVE'
		
//			if sle_serial_no.text = '' then 
//				Messagebox("$$HEX2$$55d678c7$$ENDHEX$$" , "$$HEX14$$dcc2acb9bcc5200088bc38d67cb9200085c725b8200058d538c194c6$$ENDHEX$$")
//			return 
//			end if 
			DW_1.RESET()
			DW_2.RESET()
			DW_1.RETRIEVE( em_1.text , em_2.text ,  sle_serial_no.text+'%' , ddlb_line_code.getcode()+'%' , ddlb_workstage_code.getcode()+'%' , ddlb_model_name.GETCODE()+'%' ,  gvi_organization_id) 
			
		
	CASE ELSE
END CHOOSE
end event

type dw_5 from w_main_root`dw_5 within w_product_material_tracking_multi_rpt
integer y = 392
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_product_material_tracking_multi_rpt
integer y = 392
integer taborder = 0
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_product_material_tracking_multi_rpt
integer y = 392
integer taborder = 0
boolean titlebar = true
boolean controlmenu = true
boolean minbox = true
end type

type dw_2 from w_main_root`dw_2 within w_product_material_tracking_multi_rpt
integer x = 2491
integer y = 376
integer width = 2094
integer height = 784
integer taborder = 0
boolean titlebar = true
string title = "Item"
string dataobject = "d_ip_product_material_tracking_rpt"
boolean controlmenu = true
boolean minbox = true
end type

type dw_1 from w_main_root`dw_1 within w_product_material_tracking_multi_rpt
integer y = 376
integer width = 2478
integer height = 788
integer taborder = 0
boolean titlebar = true
string title = "List"
string dataobject = "iq_interlock_check_result_4_mat_tracking_lst"
boolean controlmenu = true
boolean minbox = true
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
DW_2.RESET( )
DW_2.RETRIEVE( this.object.model_name[currentrow] ,this.object.line_code[currentrow] , this.object.workstage_code[currentrow] , this.object.serial_no[currentrow] , gvi_organization_id )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_product_material_tracking_multi_rpt
integer taborder = 0
end type

type sle_serial_no from so_singlelineedit within w_product_material_tracking_multi_rpt
integer x = 2437
integer y = 180
integer width = 507
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

type st_1 from statictext within w_product_material_tracking_multi_rpt
integer x = 2437
integer y = 112
integer width = 507
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Product PID"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from so_statictext within w_product_material_tracking_multi_rpt
integer x = 50
integer y = 272
integer width = 4023
integer height = 84
boolean bringtotop = true
integer textsize = -10
long textcolor = 255
string text = "Reflow (W50) $$HEX41$$f5ac15c844c72000b5d1fcac5cd52000dcc204ac44c7200030ae00c93cc75cb8200074d5f9b22000dcc204ac00b3d0c520003cd554b3d0c5200078ac24b888c794b2200090c7acc720007cb9200070c88cd6$$ENDHEX$$"
alignment alignment = left!
end type

type st_2 from statictext within w_product_material_tracking_multi_rpt
integer x = 46
integer y = 112
integer width = 539
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

type st_6 from statictext within w_product_material_tracking_multi_rpt
integer x = 599
integer y = 112
integer width = 745
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Workstage Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_workstage_code from uo_workstage_code_all within w_product_material_tracking_multi_rpt
integer x = 599
integer y = 184
integer width = 745
integer height = 2028
integer taborder = 20
boolean bringtotop = true
end type

type ddlb_line_code from uo_line_code within w_product_material_tracking_multi_rpt
integer x = 46
integer y = 184
integer width = 539
integer height = 1628
integer taborder = 10
boolean bringtotop = true
long backcolor = 16777215
end type

type ddlb_model_name from uo_model_name_ddlb within w_product_material_tracking_multi_rpt
integer x = 1353
integer y = 180
integer width = 1074
integer height = 1628
integer taborder = 80
boolean bringtotop = true
end type

type st_3 from statictext within w_product_material_tracking_multi_rpt
integer x = 1349
integer y = 112
integer width = 1074
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_1 from so_editmask within w_product_material_tracking_multi_rpt
integer x = 2944
integer y = 184
integer width = 791
integer taborder = 30
boolean bringtotop = true
string text = ""
alignment alignment = left!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy/mm/dd hh:mm:ss"
boolean dropdowncalendar = true
end type

event constructor;call super::constructor;this.text =string( f_sysdate())
end event

type em_2 from so_editmask within w_product_material_tracking_multi_rpt
integer x = 3739
integer y = 184
integer width = 791
integer taborder = 40
boolean bringtotop = true
string text = ""
alignment alignment = left!
maskdatatype maskdatatype = datetimemask!
string mask = "yyyy/mm/dd hh:mm:ss"
boolean dropdowncalendar = true
end type

event constructor;call super::constructor;this.text =string( f_sysdate())
end event

type st_4 from statictext within w_product_material_tracking_multi_rpt
integer x = 2953
integer y = 108
integer width = 1563
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_2 from so_groupbox within w_product_material_tracking_multi_rpt
integer width = 4576
integer height = 364
string text = "Where Condition"
end type


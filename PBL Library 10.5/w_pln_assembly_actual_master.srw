HA$PBExportHeader$w_pln_assembly_actual_master.srw
$PBExportComments$Planning Master Plan  Master
forward
global type w_pln_assembly_actual_master from w_main_root
end type
type st_1 from so_statictext within w_pln_assembly_actual_master
end type
type ddlb_line_code from uo_line_code within w_pln_assembly_actual_master
end type
type cb_8 from so_commandbutton within w_pln_assembly_actual_master
end type
type st_yyyymm from so_statictext within w_pln_assembly_actual_master
end type
type cb_9 from so_commandbutton within w_pln_assembly_actual_master
end type
type uo_dateend from uo_ymd_calendar within w_pln_assembly_actual_master
end type
type uo_dateset from uo_ymd_calendar within w_pln_assembly_actual_master
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_pln_assembly_actual_master
end type
type st_4 from so_statictext within w_pln_assembly_actual_master
end type
type st_label from statictext within w_pln_assembly_actual_master
end type
type mle_note from multilineedit within w_pln_assembly_actual_master
end type
type gb_1 from so_groupbox within w_pln_assembly_actual_master
end type
end forward

global type w_pln_assembly_actual_master from w_main_root
integer width = 6546
integer height = 3784
string title = "Assembly Actual Master"
st_1 st_1
ddlb_line_code ddlb_line_code
cb_8 cb_8
st_yyyymm st_yyyymm
cb_9 cb_9
uo_dateend uo_dateend
uo_dateset uo_dateset
ddlb_model_name ddlb_model_name
st_4 st_4
st_label st_label
mle_note mle_note
gb_1 gb_1
end type
global w_pln_assembly_actual_master w_pln_assembly_actual_master

type variables
long lvl_default_width , lvl_default_height , lvl_x , lvl_y

String lvs_last_gr,  ivs_hide = '1' ,   lvs_model_list[] , lvs_nullarray[]
long  lvl_gr_width , lvl_gr_height , lvl_gr_x , lvl_gr_y
end variables

on w_pln_assembly_actual_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_line_code=create ddlb_line_code
this.cb_8=create cb_8
this.st_yyyymm=create st_yyyymm
this.cb_9=create cb_9
this.uo_dateend=create uo_dateend
this.uo_dateset=create uo_dateset
this.ddlb_model_name=create ddlb_model_name
this.st_4=create st_4
this.st_label=create st_label
this.mle_note=create mle_note
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_line_code
this.Control[iCurrent+3]=this.cb_8
this.Control[iCurrent+4]=this.st_yyyymm
this.Control[iCurrent+5]=this.cb_9
this.Control[iCurrent+6]=this.uo_dateend
this.Control[iCurrent+7]=this.uo_dateset
this.Control[iCurrent+8]=this.ddlb_model_name
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.st_label
this.Control[iCurrent+11]=this.mle_note
this.Control[iCurrent+12]=this.gb_1
end on

on w_pln_assembly_actual_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_line_code)
destroy(this.cb_8)
destroy(this.st_yyyymm)
destroy(this.cb_9)
destroy(this.uo_dateend)
destroy(this.uo_dateset)
destroy(this.ddlb_model_name)
destroy(this.st_4)
destroy(this.st_label)
destroy(this.mle_note)
destroy(this.gb_1)
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
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

 ivs_dw_1_deleteselected_yn = 'N' 
 
ivs_dw_1_retrice_cancel_popup_open = 'Y'
ivs_dw_2_retrice_cancel_popup_open = 'N'
ivs_dw_3_retrice_cancel_popup_open = 'N'
ivs_dw_4_retrice_cancel_popup_open = 'N'
ivs_dw_5_retrice_cancel_popup_open = 'N'

ivs_dw_1_selected_row_yn = 'N'

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
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event ue_data_control;call super::ue_data_control;long row , lvdb_seq
String  lvs_mfs , lvs_topbot

choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
	
				dw_1.retrieve( uo_dateset.text() , uo_dateend.text() , ddlb_line_code.getcode( )+'%' , ddlb_model_name.getcode() +'%',  gvi_organization_id)
	
	case 'INSERT'	
		
		
	
						
						dw_1.ENABLED = TRUE
						ROW = dw_1.INSERTROW(dw_1.GETROW())
						dw_1.SCROLLTOROW(ROW)
						F_SET_SECURITY_ROW(dw_1 , ROW ,'ALL')			
						lvdb_seq = double(f_get_sequence( 'SEQ_PRODUCT_SENSOR'))
						dw_1.object.receipt_sequence[row] = 	lvdb_seq
						

		
	case 'APPEND'		
				 
				 
				 open(w_pln_smd_plan_append_popup)
 			
	case 'DELETE'
		
	
						
						if dw_1.AcceptText() = -1 then
							return
						end if
						
						if dw_1.getrow() < 1 then return
						
						MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
						IF MSG = 1 THEN
							Gvl_row_deleted = dw_1.GetRow()			
							dw_1.DELETEROW(Gvl_row_deleted)		
							dw_1.SetFocus()
							ROW = dw_1.GetRow()
							dw_1.ScrollToRow(row)
							dw_1.SetColumn(1)
						END IF							
	
	case 'ROWCOPY'
		
	
				
						dw_1.SELECTROW(0 , FALSE)
						lvdb_seq = double(f_get_sequence( 'SEQ_PRODUCT_SENSOR'))
						dw_1.object.receipt_sequence[dw_1.getrow()] = 	lvdb_seq
						dw_1.object.product_actual_qty[dw_1.getrow()] = 0
						dw_1.SCROLLTOROW(dw_1.getrow())										
						dw_1.SELECTROW(dw_1.getrow() , TRUE)				

			
	case 'UPDATE'
		
			IF dw_1.UPDATE() < 0   THEN
			  	 ROLLBACK;
				 RETURN 
			ELSE
				 COMMIT;
	               F_RETRIEVE()
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				 
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_pln_assembly_actual_master
integer y = 356
end type

type dw_4 from w_main_root`dw_4 within w_pln_assembly_actual_master
integer y = 356
integer width = 2304
integer height = 1396
boolean titlebar = true
boolean hscrollbar = false
end type

type dw_3 from w_main_root`dw_3 within w_pln_assembly_actual_master
integer y = 356
integer width = 2304
integer height = 1396
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_pln_assembly_actual_master
integer y = 356
integer width = 2304
integer height = 1396
boolean titlebar = true
end type

type dw_1 from w_main_root`dw_1 within w_pln_assembly_actual_master
integer y = 332
integer width = 6487
integer height = 2372
boolean titlebar = true
string title = "Assembly Actual List"
string dataobject = "d_pln_product_sensor_actual_time_modify"
end type

event dw_1::rbuttondown;//===========================================================
//
//===========================================================

if row < 1 then return 

if dwo.name = 'model_name' then 
	open( w_des_model_master_popup )
	
	if Gst_return.gvb_return = true then 
		this.object.model_name[row] = message.stringparm
		this.object.model_suffix[row] = Gst_return.Gvs_return[3] 
	end if 
end if 


if  upper( trim(mid( dwo.name , 3 , 20)))  = 'time_actual' then 
	
	
	Gst_return.gvdt_return[1] =this.object.plan_date[row]
	Gst_return.gvl_return[1] = this.object.plan_sequence[row]
	Gst_return.gvs_return[1] = mid( dwo.name , 1,1 )
	
     open( w_notify_flat) 
	  
end if 

end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_assembly_actual_master
end type

type st_1 from so_statictext within w_pln_assembly_actual_master
integer x = 1595
integer y = 80
integer width = 539
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type ddlb_line_code from uo_line_code within w_pln_assembly_actual_master
integer x = 1595
integer y = 160
integer width = 535
integer height = 1936
integer taborder = 40
boolean bringtotop = true
end type

type cb_8 from so_commandbutton within w_pln_assembly_actual_master
integer x = 37
integer y = 84
integer width = 87
integer height = 72
integer taborder = 40
boolean bringtotop = true
string text = "<"
end type

event clicked;call super::clicked;uo_dateset.settext (string(RelativeDate( Date(uo_dateset.text()) , -1 )))
uo_dateend.settext( string(RelativeDate( Date(uo_dateend.text()) , -1 )))
end event

type st_yyyymm from so_statictext within w_pln_assembly_actual_master
integer x = 142
integer y = 88
integer width = 603
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Plan Date"
end type

type cb_9 from so_commandbutton within w_pln_assembly_actual_master
integer x = 759
integer y = 84
integer width = 87
integer height = 72
integer taborder = 50
boolean bringtotop = true
string text = ">"
end type

event clicked;call super::clicked;uo_dateset.settext (string(RelativeDate( Date(uo_dateset.text()) , 1 )))
uo_dateend.settext( string(RelativeDate( Date(uo_dateend.text()) , 1 )))
end event

type uo_dateend from uo_ymd_calendar within w_pln_assembly_actual_master
integer x = 443
integer y = 160
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateset from uo_ymd_calendar within w_pln_assembly_actual_master
integer x = 37
integer y = 160
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_model_name from uo_set_model_name_ddlb within w_pln_assembly_actual_master
integer x = 873
integer y = 160
integer width = 713
integer height = 1936
integer taborder = 50
boolean bringtotop = true
end type

type st_4 from so_statictext within w_pln_assembly_actual_master
integer x = 878
integer y = 88
integer width = 713
integer height = 68
boolean bringtotop = true
string text = "Model Name"
end type

type st_label from statictext within w_pln_assembly_actual_master
boolean visible = false
integer x = 101
integer y = 1596
integer width = 1467
integer height = 124
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 65535
long backcolor = 32768
boolean focusrectangle = false
end type

type mle_note from multilineedit within w_pln_assembly_actual_master
boolean visible = false
integer x = 814
integer y = 1240
integer width = 3424
integer height = 1020
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 65280
long backcolor = 0
borderstyle borderstyle = stylelowered!
end type

type gb_1 from so_groupbox within w_pln_assembly_actual_master
integer x = 9
integer width = 2167
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


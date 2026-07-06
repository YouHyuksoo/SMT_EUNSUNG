HA$PBExportHeader$w_qc_interlock_reflow_status_master.srw
$PBExportComments$Line Master
forward
global type w_qc_interlock_reflow_status_master from w_main_root
end type
type st_line_code from statictext within w_qc_interlock_reflow_status_master
end type
type ddlb_line_code from uo_line_code within w_qc_interlock_reflow_status_master
end type
type rb_rwflow_status from so_radiobutton within w_qc_interlock_reflow_status_master
end type
type rb_reflow_data from so_radiobutton within w_qc_interlock_reflow_status_master
end type
type uo_dateset from uo_ymd_calendar within w_qc_interlock_reflow_status_master
end type
type uo_dateend from uo_ymd_calendar within w_qc_interlock_reflow_status_master
end type
type st_3 from so_statictext within w_qc_interlock_reflow_status_master
end type
type gb_1 from so_groupbox within w_qc_interlock_reflow_status_master
end type
type gb_2 from so_groupbox within w_qc_interlock_reflow_status_master
end type
end forward

global type w_qc_interlock_reflow_status_master from w_main_root
integer width = 4571
integer height = 2748
string title = "Reflow Status Query"
st_line_code st_line_code
ddlb_line_code ddlb_line_code
rb_rwflow_status rb_rwflow_status
rb_reflow_data rb_reflow_data
uo_dateset uo_dateset
uo_dateend uo_dateend
st_3 st_3
gb_1 gb_1
gb_2 gb_2
end type
global w_qc_interlock_reflow_status_master w_qc_interlock_reflow_status_master

on w_qc_interlock_reflow_status_master.create
int iCurrent
call super::create
this.st_line_code=create st_line_code
this.ddlb_line_code=create ddlb_line_code
this.rb_rwflow_status=create rb_rwflow_status
this.rb_reflow_data=create rb_reflow_data
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_3=create st_3
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_line_code
this.Control[iCurrent+2]=this.ddlb_line_code
this.Control[iCurrent+3]=this.rb_rwflow_status
this.Control[iCurrent+4]=this.rb_reflow_data
this.Control[iCurrent+5]=this.uo_dateset
this.Control[iCurrent+6]=this.uo_dateend
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_qc_interlock_reflow_status_master.destroy
call super::destroy
destroy(this.st_line_code)
destroy(this.ddlb_line_code)
destroy(this.rb_rwflow_status)
destroy(this.rb_reflow_data)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.gb_2)
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

/****************************************
*  Menu Property
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

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			if rb_rwflow_status.checked = true then 
					dw_1.retrieve( ddlb_line_code.getcode() + '%', gvi_organization_id)
					dw_1.setfocus()
			else
					dw_2.retrieve( ddlb_line_code.getcode() + '%', STRING(uo_dateset.text(),'YYYY-MM-DD') , STRING(uo_dateend.text(),'YYYY-MM-DD')  ,  gvi_organization_id)
					dw_2.setfocus()					
			end if 
					
end choose


end event

type dw_5 from w_main_root`dw_5 within w_qc_interlock_reflow_status_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_qc_interlock_reflow_status_master
integer y = 316
end type

type dw_3 from w_main_root`dw_3 within w_qc_interlock_reflow_status_master
integer y = 316
integer width = 4544
integer height = 1388
end type

type dw_2 from w_main_root`dw_2 within w_qc_interlock_reflow_status_master
integer y = 316
integer width = 4544
integer height = 1388
boolean titlebar = true
string title = "History"
string dataobject = "d_qc_product_reflow_data_all_lst"
end type

type dw_1 from w_main_root`dw_1 within w_qc_interlock_reflow_status_master
integer y = 316
integer width = 4544
integer height = 1388
boolean titlebar = true
string title = "Status"
string dataobject = "d_qc_interlock_reflow_status_lst"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_qc_interlock_reflow_status_master
end type

type st_line_code from statictext within w_qc_interlock_reflow_status_master
integer x = 864
integer y = 104
integer width = 631
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_line_code from uo_line_code within w_qc_interlock_reflow_status_master
integer x = 887
integer y = 184
integer taborder = 20
boolean bringtotop = true
end type

type rb_rwflow_status from so_radiobutton within w_qc_interlock_reflow_status_master
integer x = 87
integer y = 76
integer width = 635
boolean bringtotop = true
string text = "Reflow Status"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
end event

type rb_reflow_data from so_radiobutton within w_qc_interlock_reflow_status_master
integer x = 87
integer y = 176
integer width = 635
boolean bringtotop = true
string text = "Reflow Data"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
end event

type uo_dateset from uo_ymd_calendar within w_qc_interlock_reflow_status_master
integer x = 1545
integer y = 184
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_qc_interlock_reflow_status_master
integer x = 1957
integer y = 188
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_3 from so_statictext within w_qc_interlock_reflow_status_master
integer x = 1554
integer y = 100
integer width = 809
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Check Date"
end type

type gb_1 from so_groupbox within w_qc_interlock_reflow_status_master
integer width = 786
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_qc_interlock_reflow_status_master
integer x = 809
integer width = 1632
integer height = 304
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


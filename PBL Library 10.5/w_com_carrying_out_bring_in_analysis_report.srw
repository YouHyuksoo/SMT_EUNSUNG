HA$PBExportHeader$w_com_carrying_out_bring_in_analysis_report.srw
$PBExportComments$Material Receipt Sum Report
forward
global type w_com_carrying_out_bring_in_analysis_report from w_main_root
end type
type st_3 from so_statictext within w_com_carrying_out_bring_in_analysis_report
end type
type ddlb_item_code from uo_item_code within w_com_carrying_out_bring_in_analysis_report
end type
type st_1 from so_statictext within w_com_carrying_out_bring_in_analysis_report
end type
type ddlb_supplier_code from uo_supplier_code within w_com_carrying_out_bring_in_analysis_report
end type
type rb_receipt_matrix from so_radiobutton within w_com_carrying_out_bring_in_analysis_report
end type
type em_yyyymm from uo_ym within w_com_carrying_out_bring_in_analysis_report
end type
type st_receipt_date from so_statictext within w_com_carrying_out_bring_in_analysis_report
end type
type rb_daily_carrying_out from so_radiobutton within w_com_carrying_out_bring_in_analysis_report
end type
type st_14 from so_statictext within w_com_carrying_out_bring_in_analysis_report
end type
type sle_item_name from so_singlelineedit within w_com_carrying_out_bring_in_analysis_report
end type
type sle_1 from so_singlelineedit within w_com_carrying_out_bring_in_analysis_report
end type
type st_2 from so_statictext within w_com_carrying_out_bring_in_analysis_report
end type
type rb_bring_in from so_radiobutton within w_com_carrying_out_bring_in_analysis_report
end type
type rb_carring_out_by_dept from so_radiobutton within w_com_carrying_out_bring_in_analysis_report
end type
type ddlb_dept_code from uo_department_code within w_com_carrying_out_bring_in_analysis_report
end type
type st_4 from so_statictext within w_com_carrying_out_bring_in_analysis_report
end type
type gb_where_condition from so_groupbox within w_com_carrying_out_bring_in_analysis_report
end type
type gb_1 from so_groupbox within w_com_carrying_out_bring_in_analysis_report
end type
end forward

global type w_com_carrying_out_bring_in_analysis_report from w_main_root
integer width = 4631
integer height = 2736
string title = "Material Receipt Analysis Report"
st_3 st_3
ddlb_item_code ddlb_item_code
st_1 st_1
ddlb_supplier_code ddlb_supplier_code
rb_receipt_matrix rb_receipt_matrix
em_yyyymm em_yyyymm
st_receipt_date st_receipt_date
rb_daily_carrying_out rb_daily_carrying_out
st_14 st_14
sle_item_name sle_item_name
sle_1 sle_1
st_2 st_2
rb_bring_in rb_bring_in
rb_carring_out_by_dept rb_carring_out_by_dept
ddlb_dept_code ddlb_dept_code
st_4 st_4
gb_where_condition gb_where_condition
gb_1 gb_1
end type
global w_com_carrying_out_bring_in_analysis_report w_com_carrying_out_bring_in_analysis_report

on w_com_carrying_out_bring_in_analysis_report.create
int iCurrent
call super::create
this.st_3=create st_3
this.ddlb_item_code=create ddlb_item_code
this.st_1=create st_1
this.ddlb_supplier_code=create ddlb_supplier_code
this.rb_receipt_matrix=create rb_receipt_matrix
this.em_yyyymm=create em_yyyymm
this.st_receipt_date=create st_receipt_date
this.rb_daily_carrying_out=create rb_daily_carrying_out
this.st_14=create st_14
this.sle_item_name=create sle_item_name
this.sle_1=create sle_1
this.st_2=create st_2
this.rb_bring_in=create rb_bring_in
this.rb_carring_out_by_dept=create rb_carring_out_by_dept
this.ddlb_dept_code=create ddlb_dept_code
this.st_4=create st_4
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.ddlb_supplier_code
this.Control[iCurrent+5]=this.rb_receipt_matrix
this.Control[iCurrent+6]=this.em_yyyymm
this.Control[iCurrent+7]=this.st_receipt_date
this.Control[iCurrent+8]=this.rb_daily_carrying_out
this.Control[iCurrent+9]=this.st_14
this.Control[iCurrent+10]=this.sle_item_name
this.Control[iCurrent+11]=this.sle_1
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.rb_bring_in
this.Control[iCurrent+14]=this.rb_carring_out_by_dept
this.Control[iCurrent+15]=this.ddlb_dept_code
this.Control[iCurrent+16]=this.st_4
this.Control[iCurrent+17]=this.gb_where_condition
this.Control[iCurrent+18]=this.gb_1
end on

on w_com_carrying_out_bring_in_analysis_report.destroy
call super::destroy
destroy(this.st_3)
destroy(this.ddlb_item_code)
destroy(this.st_1)
destroy(this.ddlb_supplier_code)
destroy(this.rb_receipt_matrix)
destroy(this.em_yyyymm)
destroy(this.st_receipt_date)
destroy(this.rb_daily_carrying_out)
destroy(this.st_14)
destroy(this.sle_item_name)
destroy(this.sle_1)
destroy(this.st_2)
destroy(this.rb_bring_in)
destroy(this.rb_carring_out_by_dept)
destroy(this.ddlb_dept_code)
destroy(this.st_4)
destroy(this.gb_where_condition)
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
/*****************************************
* Data Window Property
******************************************/
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


/*****************************************
* Data Window Property
******************************************/
ivs_dw_1_use_focusindicator = 'N' //Focus Indicator Show / Hide Property
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
F_MENU_CONTROL('REPORT' , True)  // All Data Control






end event

event ue_post_open;call super::ue_post_open;
/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())



end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
		if rb_receipt_matrix.checked = true then 
		
			dw_1.retrieve(  f_get_first_day_by_month( em_yyyymm.text) ,  f_get_last_day_by_month( em_yyyymm.text) , ddlb_supplier_code.text + '%' , ddlb_item_code.text+ '%' , gvs_language ,  gvi_organization_id)
			dw_1.setfocus()
			
		elseif rb_daily_carrying_out.checked = true then 
			
			dw_2.retrieve(  f_get_first_day_by_month( em_yyyymm.text) ,  f_get_last_day_by_month( em_yyyymm.text) , ddlb_supplier_code.text + '%' , ddlb_item_code.text+ '%' , gvs_language ,  gvi_organization_id)

			dw_2.setfocus()			

		elseif rb_bring_in.checked = true then 
			
			dw_3.retrieve(  f_get_first_day_by_month( em_yyyymm.text) ,  f_get_last_day_by_month( em_yyyymm.text) , ddlb_supplier_code.text + '%' , ddlb_item_code.text+ '%' , gvs_language ,  gvi_organization_id)
			f_set_column_dddw(dw_3)		
			dw_3.setfocus()			
		else			
			dw_4.retrieve(  f_get_first_day_by_month( em_yyyymm.text) ,  f_get_last_day_by_month( em_yyyymm.text) , ddlb_supplier_code.text + '%' , ddlb_item_code.text+ '%' , ddlb_dept_code.getcode( )+'%' ,  gvs_language ,  gvi_organization_id)
			f_set_column_dddw(dw_4)
			dw_4.setfocus()						
			
		end if
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_com_carrying_out_bring_in_analysis_report
integer y = 364
integer width = 4544
integer height = 2184
boolean titlebar = true
end type

type dw_4 from w_main_root`dw_4 within w_com_carrying_out_bring_in_analysis_report
integer y = 364
integer width = 4544
integer height = 2184
integer taborder = 20
boolean titlebar = true
string dataobject = "d_com_carrying_out_analysys_byt_dept_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_com_carrying_out_bring_in_analysis_report
integer y = 364
integer width = 4544
integer height = 2184
integer taborder = 30
boolean titlebar = true
string title = "Daily Carrying OUT Analysis Matrix"
string dataobject = "d_com_carrying_out_bring_in_analysys_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_com_carrying_out_bring_in_analysis_report
integer y = 364
integer width = 4544
integer height = 2184
integer taborder = 40
boolean titlebar = true
string title = "Material Receipt Analysis List"
string dataobject = "d_com_daily_carrying_out_analysys_rpt"
end type

type dw_1 from w_main_root`dw_1 within w_com_carrying_out_bring_in_analysis_report
integer y = 364
integer width = 4544
integer height = 2184
integer taborder = 50
boolean titlebar = true
string title = "Carrying OUT Analysis List"
string dataobject = "d_com_carrying_out_analysys_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_com_carrying_out_bring_in_analysis_report
end type

type st_3 from so_statictext within w_com_carrying_out_bring_in_analysis_report
integer x = 2510
integer y = 112
integer width = 535
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_com_carrying_out_bring_in_analysis_report
integer x = 2510
integer y = 184
integer width = 535
integer taborder = 30
boolean bringtotop = true
end type

type st_1 from so_statictext within w_com_carrying_out_bring_in_analysis_report
integer x = 2007
integer y = 112
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type ddlb_supplier_code from uo_supplier_code within w_com_carrying_out_bring_in_analysis_report
integer x = 2007
integer y = 184
integer width = 498
integer taborder = 20
boolean bringtotop = true
end type

type rb_receipt_matrix from so_radiobutton within w_com_carrying_out_bring_in_analysis_report
integer x = 73
integer y = 88
integer width = 754
boolean bringtotop = true
integer weight = 700
string text = "Carring OUT Matrix"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1
end event

type em_yyyymm from uo_ym within w_com_carrying_out_bring_in_analysis_report
integer x = 1673
integer y = 180
integer taborder = 40
boolean bringtotop = true
end type

type st_receipt_date from so_statictext within w_com_carrying_out_bring_in_analysis_report
integer x = 1673
integer y = 112
integer width = 325
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "YYYYMM"
end type

type rb_daily_carrying_out from so_radiobutton within w_com_carrying_out_bring_in_analysis_report
integer x = 73
integer y = 172
integer width = 754
boolean bringtotop = true
integer weight = 700
string text = "Daily Carrying OUT Matrix"
end type

event clicked;call super::clicked;dw_2.bringtotop = true
selected_data_window = dw_2
end event

type st_14 from so_statictext within w_com_carrying_out_bring_in_analysis_report
integer x = 3049
integer y = 112
integer width = 448
integer height = 52
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Name"
end type

type sle_item_name from so_singlelineedit within w_com_carrying_out_bring_in_analysis_report
integer x = 3049
integer y = 184
integer width = 448
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type sle_1 from so_singlelineedit within w_com_carrying_out_bring_in_analysis_report
integer x = 3506
integer y = 184
integer width = 453
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_SPEC'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type st_2 from so_statictext within w_com_carrying_out_bring_in_analysis_report
integer x = 3506
integer y = 112
integer width = 453
integer height = 52
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Spec"
end type

type rb_bring_in from so_radiobutton within w_com_carrying_out_bring_in_analysis_report
integer x = 933
integer y = 80
integer width = 667
boolean bringtotop = true
integer weight = 700
string text = "Bring IN Matrix"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window = dw_3
end event

type rb_carring_out_by_dept from so_radiobutton within w_com_carrying_out_bring_in_analysis_report
integer x = 933
integer y = 172
integer width = 667
integer height = 76
boolean bringtotop = true
integer weight = 700
string text = "Carring OUT By Dept"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
selected_data_window = dw_4
end event

type ddlb_dept_code from uo_department_code within w_com_carrying_out_bring_in_analysis_report
integer x = 3968
integer y = 184
integer width = 530
integer taborder = 50
boolean bringtotop = true
end type

type st_4 from so_statictext within w_com_carrying_out_bring_in_analysis_report
integer x = 3968
integer y = 112
integer width = 530
integer height = 52
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Department Code"
end type

type gb_where_condition from so_groupbox within w_com_carrying_out_bring_in_analysis_report
integer x = 1632
integer width = 2907
integer height = 356
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_com_carrying_out_bring_in_analysis_report
integer width = 1618
integer height = 356
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type


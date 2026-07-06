HA$PBExportHeader$w_com_carrying_out_bring_in_report.srw
$PBExportComments$Material Receipt Sum Report
forward
global type w_com_carrying_out_bring_in_report from w_main_root
end type
type st_3 from so_statictext within w_com_carrying_out_bring_in_report
end type
type ddlb_item_code from uo_item_code within w_com_carrying_out_bring_in_report
end type
type st_1 from so_statictext within w_com_carrying_out_bring_in_report
end type
type ddlb_supplier_code from uo_supplier_code within w_com_carrying_out_bring_in_report
end type
type st_14 from so_statictext within w_com_carrying_out_bring_in_report
end type
type sle_item_name from so_singlelineedit within w_com_carrying_out_bring_in_report
end type
type sle_1 from so_singlelineedit within w_com_carrying_out_bring_in_report
end type
type st_2 from so_statictext within w_com_carrying_out_bring_in_report
end type
type ddlb_dept_code from uo_department_code within w_com_carrying_out_bring_in_report
end type
type st_4 from so_statictext within w_com_carrying_out_bring_in_report
end type
type st_5 from so_statictext within w_com_carrying_out_bring_in_report
end type
type uo_dateset from uo_ymd_calendar within w_com_carrying_out_bring_in_report
end type
type uo_dateend from uo_ymd_calendar within w_com_carrying_out_bring_in_report
end type
type st_6 from so_statictext within w_com_carrying_out_bring_in_report
end type
type sle_gen_new_group from so_singlelineedit within w_com_carrying_out_bring_in_report
end type
type gb_where_condition from so_groupbox within w_com_carrying_out_bring_in_report
end type
end forward

global type w_com_carrying_out_bring_in_report from w_main_root
integer width = 4608
integer height = 2736
string title = "Out Card Report"
st_3 st_3
ddlb_item_code ddlb_item_code
st_1 st_1
ddlb_supplier_code ddlb_supplier_code
st_14 st_14
sle_item_name sle_item_name
sle_1 sle_1
st_2 st_2
ddlb_dept_code ddlb_dept_code
st_4 st_4
st_5 st_5
uo_dateset uo_dateset
uo_dateend uo_dateend
st_6 st_6
sle_gen_new_group sle_gen_new_group
gb_where_condition gb_where_condition
end type
global w_com_carrying_out_bring_in_report w_com_carrying_out_bring_in_report

on w_com_carrying_out_bring_in_report.create
int iCurrent
call super::create
this.st_3=create st_3
this.ddlb_item_code=create ddlb_item_code
this.st_1=create st_1
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_14=create st_14
this.sle_item_name=create sle_item_name
this.sle_1=create sle_1
this.st_2=create st_2
this.ddlb_dept_code=create ddlb_dept_code
this.st_4=create st_4
this.st_5=create st_5
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_6=create st_6
this.sle_gen_new_group=create sle_gen_new_group
this.gb_where_condition=create gb_where_condition
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.ddlb_supplier_code
this.Control[iCurrent+5]=this.st_14
this.Control[iCurrent+6]=this.sle_item_name
this.Control[iCurrent+7]=this.sle_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.ddlb_dept_code
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.uo_dateset
this.Control[iCurrent+13]=this.uo_dateend
this.Control[iCurrent+14]=this.st_6
this.Control[iCurrent+15]=this.sle_gen_new_group
this.Control[iCurrent+16]=this.gb_where_condition
end on

on w_com_carrying_out_bring_in_report.destroy
call super::destroy
destroy(this.st_3)
destroy(this.ddlb_item_code)
destroy(this.st_1)
destroy(this.ddlb_supplier_code)
destroy(this.st_14)
destroy(this.sle_item_name)
destroy(this.sle_1)
destroy(this.st_2)
destroy(this.ddlb_dept_code)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_6)
destroy(this.sle_gen_new_group)
destroy(this.gb_where_condition)
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

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')


end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
		
			dw_1.retrieve(uo_dateset.text () , uo_dateend.text() , ddlb_supplier_code.text + '%' , ddlb_item_code.text+ '%' , ddlb_dept_code.getcode( )+'%' , sle_gen_new_group.text +'%' ,  gvi_organization_id )
			f_set_column_dddw(dw_1)
			dw_1.setfocus()
		
end choose


end event

type dw_5 from w_main_root`dw_5 within w_com_carrying_out_bring_in_report
integer x = 23
integer y = 360
integer width = 4544
integer height = 2128
boolean titlebar = true
end type

type dw_4 from w_main_root`dw_4 within w_com_carrying_out_bring_in_report
integer x = 23
integer y = 360
integer width = 4544
integer height = 2184
integer taborder = 20
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_com_carrying_out_bring_in_report
integer x = 23
integer y = 360
integer width = 4544
integer height = 2184
integer taborder = 30
boolean titlebar = true
string title = "Daily Carrying OUT Analysis Matrix"
end type

type dw_2 from w_main_root`dw_2 within w_com_carrying_out_bring_in_report
integer x = 23
integer y = 360
integer width = 4544
integer height = 2184
integer taborder = 40
boolean titlebar = true
string title = "Material Receipt Analysis List"
end type

type dw_1 from w_main_root`dw_1 within w_com_carrying_out_bring_in_report
integer x = 14
integer y = 360
integer width = 4544
integer height = 2184
integer taborder = 50
boolean titlebar = true
string title = "Carrying OUT Bring In Report"
string dataobject = "d_com_carrying_out_bring_in_report"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_com_carrying_out_bring_in_report
end type

type st_3 from so_statictext within w_com_carrying_out_bring_in_report
integer x = 1381
integer y = 112
integer width = 535
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_com_carrying_out_bring_in_report
integer x = 1381
integer y = 184
integer width = 535
integer taborder = 30
boolean bringtotop = true
end type

type st_1 from so_statictext within w_com_carrying_out_bring_in_report
integer x = 878
integer y = 112
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type ddlb_supplier_code from uo_supplier_code within w_com_carrying_out_bring_in_report
integer x = 878
integer y = 184
integer width = 498
integer taborder = 20
boolean bringtotop = true
end type

type st_14 from so_statictext within w_com_carrying_out_bring_in_report
integer x = 1920
integer y = 112
integer width = 448
integer height = 52
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Name"
end type

type sle_item_name from so_singlelineedit within w_com_carrying_out_bring_in_report
integer x = 1920
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

type sle_1 from so_singlelineedit within w_com_carrying_out_bring_in_report
integer x = 2377
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

type st_2 from so_statictext within w_com_carrying_out_bring_in_report
integer x = 2377
integer y = 112
integer width = 453
integer height = 52
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Spec"
end type

type ddlb_dept_code from uo_department_code within w_com_carrying_out_bring_in_report
integer x = 2839
integer y = 184
integer width = 530
integer taborder = 50
boolean bringtotop = true
end type

type st_4 from so_statictext within w_com_carrying_out_bring_in_report
integer x = 2839
integer y = 112
integer width = 530
integer height = 52
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Department Code"
end type

type st_5 from so_statictext within w_com_carrying_out_bring_in_report
integer x = 197
integer y = 116
integer height = 52
boolean bringtotop = true
integer weight = 700
string text = "Carrying Out Date"
end type

type uo_dateset from uo_ymd_calendar within w_com_carrying_out_bring_in_report
event destroy ( )
integer x = 46
integer y = 180
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_com_carrying_out_bring_in_report
event destroy ( )
integer x = 462
integer y = 180
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_6 from so_statictext within w_com_carrying_out_bring_in_report
integer x = 3374
integer y = 108
integer width = 453
integer height = 52
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Gen New Group"
end type

type sle_gen_new_group from so_singlelineedit within w_com_carrying_out_bring_in_report
integer x = 3378
integer y = 184
integer width = 453
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type gb_where_condition from so_groupbox within w_com_carrying_out_bring_in_report
integer x = 23
integer width = 3867
integer height = 356
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


HA$PBExportHeader$w_mat_issue_sum_report.srw
$PBExportComments$Material Issue Sum Report
forward
global type w_mat_issue_sum_report from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_issue_sum_report
end type
type uo_dateend from uo_ymd_calendar within w_mat_issue_sum_report
end type
type st_receipt_date from so_statictext within w_mat_issue_sum_report
end type
type st_3 from so_statictext within w_mat_issue_sum_report
end type
type ddlb_item_code from uo_item_code within w_mat_issue_sum_report
end type
type st_2 from so_statictext within w_mat_issue_sum_report
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_issue_sum_report
end type
type rb_item_sum from so_radiobutton within w_mat_issue_sum_report
end type
type rb_account_sum from so_radiobutton within w_mat_issue_sum_report
end type
type ddlb_issue_account from uo_basecode within w_mat_issue_sum_report
end type
type st_1 from so_statictext within w_mat_issue_sum_report
end type
type gb_where_condition from so_groupbox within w_mat_issue_sum_report
end type
type gb_1 from so_groupbox within w_mat_issue_sum_report
end type
end forward

global type w_mat_issue_sum_report from w_main_root
integer width = 4704
integer height = 2944
string title = "Material Issue Sum Report"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_receipt_date st_receipt_date
st_3 st_3
ddlb_item_code ddlb_item_code
st_2 st_2
ddlb_supplier_code ddlb_supplier_code
rb_item_sum rb_item_sum
rb_account_sum rb_account_sum
ddlb_issue_account ddlb_issue_account
st_1 st_1
gb_where_condition gb_where_condition
gb_1 gb_1
end type
global w_mat_issue_sum_report w_mat_issue_sum_report

on w_mat_issue_sum_report.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_receipt_date=create st_receipt_date
this.st_3=create st_3
this.ddlb_item_code=create ddlb_item_code
this.st_2=create st_2
this.ddlb_supplier_code=create ddlb_supplier_code
this.rb_item_sum=create rb_item_sum
this.rb_account_sum=create rb_account_sum
this.ddlb_issue_account=create ddlb_issue_account
this.st_1=create st_1
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_receipt_date
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.ddlb_item_code
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.ddlb_supplier_code
this.Control[iCurrent+8]=this.rb_item_sum
this.Control[iCurrent+9]=this.rb_account_sum
this.Control[iCurrent+10]=this.ddlb_issue_account
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.gb_where_condition
this.Control[iCurrent+13]=this.gb_1
end on

on w_mat_issue_sum_report.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_receipt_date)
destroy(this.st_3)
destroy(this.ddlb_item_code)
destroy(this.st_2)
destroy(this.ddlb_supplier_code)
destroy(this.rb_item_sum)
destroy(this.rb_account_sum)
destroy(this.ddlb_issue_account)
destroy(this.st_1)
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
		if rb_item_sum.checked = true then
	
			dw_1.retrieve(  uo_dateset.text() , uo_dateend.text() , ddlb_supplier_code.text + '%' , ddlb_item_code.text()+ '%' ,gvi_organization_id)
			dw_1.setfocus()
			
		else
			
			dw_2.retrieve(  uo_dateset.text() , uo_dateend.text() ,  ddlb_item_code.text()+ '%' , ddlb_issue_account.getcode()+'%'  , gvi_organization_id)
			dw_2.setfocus()
			
		end if		

	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_mat_issue_sum_report
integer y = 336
end type

type dw_4 from w_main_root`dw_4 within w_mat_issue_sum_report
integer y = 332
integer width = 4544
integer height = 2184
integer taborder = 20
end type

type dw_3 from w_main_root`dw_3 within w_mat_issue_sum_report
integer y = 332
integer width = 4544
integer height = 2184
integer taborder = 30
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_mat_issue_sum_report
integer y = 332
integer width = 4544
integer height = 2184
integer taborder = 40
boolean titlebar = true
string title = "Material Issue Account Summary Report"
string dataobject = "d_mat_issue_account_sum_rpt"
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_issue_sum_report
integer y = 332
integer width = 4544
integer height = 2184
integer taborder = 50
boolean titlebar = true
string title = "Material Issue Summary Report"
string dataobject = "d_mat_issue_sum_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_issue_sum_report
end type

type uo_dateset from uo_ymd_calendar within w_mat_issue_sum_report
integer x = 1019
integer y = 184
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_issue_sum_report
integer x = 1431
integer y = 184
integer taborder = 70
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_receipt_date from so_statictext within w_mat_issue_sum_report
integer x = 1024
integer y = 92
integer width = 814
boolean bringtotop = true
integer weight = 700
string text = "Issue Date"
end type

type st_3 from so_statictext within w_mat_issue_sum_report
integer x = 2299
integer y = 92
integer width = 425
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_issue_sum_report
integer x = 2299
integer y = 184
integer width = 425
integer taborder = 30
boolean bringtotop = true
end type

type st_2 from so_statictext within w_mat_issue_sum_report
integer x = 1851
integer y = 92
integer width = 439
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type ddlb_supplier_code from uo_supplier_code within w_mat_issue_sum_report
integer x = 1851
integer y = 184
integer width = 439
integer taborder = 30
boolean bringtotop = true
end type

type rb_item_sum from so_radiobutton within w_mat_issue_sum_report
integer x = 101
integer y = 88
integer width = 722
boolean bringtotop = true
integer weight = 700
string text = "Summary By Item"
boolean checked = true
end type

event clicked;call super::clicked;selected_data_window = dw_1
dw_1.bringtotop = true
end event

type rb_account_sum from so_radiobutton within w_mat_issue_sum_report
integer x = 101
integer y = 188
integer width = 722
boolean bringtotop = true
integer weight = 700
string text = "Summary By Account"
end type

event clicked;call super::clicked;selected_data_window = dw_2
dw_2.bringtotop = true
end event

type ddlb_issue_account from uo_basecode within w_mat_issue_sum_report
integer x = 2725
integer y = 184
integer width = 622
integer height = 692
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'ISSUE ACCOUNT')
end event

type st_1 from so_statictext within w_mat_issue_sum_report
integer x = 2725
integer y = 88
integer width = 622
boolean bringtotop = true
integer weight = 700
string text = "Issue Account"
end type

type gb_where_condition from so_groupbox within w_mat_issue_sum_report
integer width = 969
integer height = 320
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_1 from so_groupbox within w_mat_issue_sum_report
integer x = 983
integer width = 2391
integer height = 320
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


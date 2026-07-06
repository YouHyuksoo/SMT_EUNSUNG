HA$PBExportHeader$w_mat_receipt_sum_report.srw
$PBExportComments$Material Receipt Sum Report
forward
global type w_mat_receipt_sum_report from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_receipt_sum_report
end type
type uo_dateend from uo_ymd_calendar within w_mat_receipt_sum_report
end type
type st_receipt_date from so_statictext within w_mat_receipt_sum_report
end type
type rb_all from so_radiobutton within w_mat_receipt_sum_report
end type
type rb_n from so_radiobutton within w_mat_receipt_sum_report
end type
type st_3 from so_statictext within w_mat_receipt_sum_report
end type
type ddlb_item_code from uo_item_code within w_mat_receipt_sum_report
end type
type st_2 from so_statictext within w_mat_receipt_sum_report
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_receipt_sum_report
end type
type rb_a from so_radiobutton within w_mat_receipt_sum_report
end type
type rb_item from so_radiobutton within w_mat_receipt_sum_report
end type
type rb_supplier from so_radiobutton within w_mat_receipt_sum_report
end type
type rb_item_sum_supplier from so_radiobutton within w_mat_receipt_sum_report
end type
type rb_location from so_radiobutton within w_mat_receipt_sum_report
end type
type rb_rcv_iss_sum from so_radiobutton within w_mat_receipt_sum_report
end type
type st_invoice_no from so_statictext within w_mat_receipt_sum_report
end type
type sle_invoice_no from so_singlelineedit within w_mat_receipt_sum_report
end type
type gb_where_condition from so_groupbox within w_mat_receipt_sum_report
end type
type gb_1 from so_groupbox within w_mat_receipt_sum_report
end type
type gb_2 from so_groupbox within w_mat_receipt_sum_report
end type
type gb_3 from so_groupbox within w_mat_receipt_sum_report
end type
end forward

global type w_mat_receipt_sum_report from w_main_root
integer width = 4997
integer height = 2944
string title = "Material Receipt Sum Report"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_receipt_date st_receipt_date
rb_all rb_all
rb_n rb_n
st_3 st_3
ddlb_item_code ddlb_item_code
st_2 st_2
ddlb_supplier_code ddlb_supplier_code
rb_a rb_a
rb_item rb_item
rb_supplier rb_supplier
rb_item_sum_supplier rb_item_sum_supplier
rb_location rb_location
rb_rcv_iss_sum rb_rcv_iss_sum
st_invoice_no st_invoice_no
sle_invoice_no sle_invoice_no
gb_where_condition gb_where_condition
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_receipt_sum_report w_mat_receipt_sum_report

on w_mat_receipt_sum_report.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_receipt_date=create st_receipt_date
this.rb_all=create rb_all
this.rb_n=create rb_n
this.st_3=create st_3
this.ddlb_item_code=create ddlb_item_code
this.st_2=create st_2
this.ddlb_supplier_code=create ddlb_supplier_code
this.rb_a=create rb_a
this.rb_item=create rb_item
this.rb_supplier=create rb_supplier
this.rb_item_sum_supplier=create rb_item_sum_supplier
this.rb_location=create rb_location
this.rb_rcv_iss_sum=create rb_rcv_iss_sum
this.st_invoice_no=create st_invoice_no
this.sle_invoice_no=create sle_invoice_no
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_receipt_date
this.Control[iCurrent+4]=this.rb_all
this.Control[iCurrent+5]=this.rb_n
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.ddlb_item_code
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.ddlb_supplier_code
this.Control[iCurrent+10]=this.rb_a
this.Control[iCurrent+11]=this.rb_item
this.Control[iCurrent+12]=this.rb_supplier
this.Control[iCurrent+13]=this.rb_item_sum_supplier
this.Control[iCurrent+14]=this.rb_location
this.Control[iCurrent+15]=this.rb_rcv_iss_sum
this.Control[iCurrent+16]=this.st_invoice_no
this.Control[iCurrent+17]=this.sle_invoice_no
this.Control[iCurrent+18]=this.gb_where_condition
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_2
this.Control[iCurrent+21]=this.gb_3
end on

on w_mat_receipt_sum_report.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_receipt_date)
destroy(this.rb_all)
destroy(this.rb_n)
destroy(this.st_3)
destroy(this.ddlb_item_code)
destroy(this.st_2)
destroy(this.ddlb_supplier_code)
destroy(this.rb_a)
destroy(this.rb_item)
destroy(this.rb_supplier)
destroy(this.rb_item_sum_supplier)
destroy(this.rb_location)
destroy(this.rb_rcv_iss_sum)
destroy(this.st_invoice_no)
destroy(this.sle_invoice_no)
destroy(this.gb_where_condition)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
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
		if rb_item.checked = true then 
			dw_1.retrieve(  uo_dateset.text() , uo_dateend.text() , ddlb_supplier_code.text + '%' , ddlb_item_code.text+ '%' , sle_invoice_no.text +'%' , gvi_organization_id)
			dw_1.setfocus()
		elseif rb_supplier.checked = true then 
			dw_2.retrieve(  uo_dateset.text() , uo_dateend.text() , ddlb_supplier_code.text + '%' ,  sle_invoice_no.text +'%' , gvi_organization_id)
			dw_2.setfocus()			
		elseif rb_item_sum_supplier.checked = true then 
			dw_3.retrieve(  uo_dateset.text() , uo_dateend.text() , ddlb_supplier_code.text + '%' , ddlb_item_code.text+ '%' , sle_invoice_no.text +'%' ,gvi_organization_id)
			dw_3.setfocus()
		elseif rb_location.checked = true then 
			dw_4.retrieve(  uo_dateset.text() , uo_dateend.text() ,  '%' ,gvi_organization_id)
			dw_4.setfocus()			
			
		else
			dw_5.retrieve(  ddlb_supplier_code.text + '%' , ddlb_item_code.text+ '%'  , uo_dateset.text() , uo_dateend.text() , gvs_language   ,gvi_organization_id)
			dw_5.setfocus()						
		end if
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_mat_receipt_sum_report
integer y = 328
integer width = 4544
integer height = 2160
boolean titlebar = true
string dataobject = "d_mat_receipt_issue_return_matrix_rpt"
end type

type dw_4 from w_main_root`dw_4 within w_mat_receipt_sum_report
integer y = 328
integer width = 4544
integer height = 2160
integer taborder = 20
boolean titlebar = true
string dataobject = "d_mat_receipt_sum_by_warehouse_rpt"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_3 from w_main_root`dw_3 within w_mat_receipt_sum_report
integer y = 328
integer width = 4544
integer height = 2160
integer taborder = 30
boolean titlebar = true
string dataobject = "d_mat_receipt_sum_4_supplier_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_mat_receipt_sum_report
integer y = 328
integer width = 4544
integer height = 2160
integer taborder = 40
boolean titlebar = true
string dataobject = "d_mat_receipt_sum_by_supplier_rpt"
end type

type dw_1 from w_main_root`dw_1 within w_mat_receipt_sum_report
integer y = 328
integer width = 4544
integer height = 2160
integer taborder = 50
boolean titlebar = true
string title = "Material Receipt Sum Report"
string dataobject = "d_mat_receipt_sum_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_receipt_sum_report
end type

type uo_dateset from uo_ymd_calendar within w_mat_receipt_sum_report
integer x = 1577
integer y = 184
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_receipt_sum_report
integer x = 1989
integer y = 184
integer taborder = 70
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_receipt_date from so_statictext within w_mat_receipt_sum_report
integer x = 1582
integer y = 92
integer width = 814
boolean bringtotop = true
integer weight = 700
string text = "Receipt Date"
end type

type rb_all from so_radiobutton within w_mat_receipt_sum_report
integer x = 4037
integer y = 96
integer width = 256
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter('')
dw_1.filter()

end event

type rb_n from so_radiobutton within w_mat_receipt_sum_report
integer x = 4037
integer y = 212
integer width = 265
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Normal"
end type

event clicked;call super::clicked;dw_1.setfilter("receipt_type = 'N'")
dw_1.filter()
end event

type st_3 from so_statictext within w_mat_receipt_sum_report
integer x = 2848
integer y = 92
integer width = 512
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_receipt_sum_report
integer x = 2848
integer y = 184
integer width = 512
integer taborder = 30
boolean bringtotop = true
end type

type st_2 from so_statictext within w_mat_receipt_sum_report
integer x = 2400
integer y = 92
integer width = 439
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type ddlb_supplier_code from uo_supplier_code within w_mat_receipt_sum_report
integer x = 2400
integer y = 184
integer width = 439
integer taborder = 30
boolean bringtotop = true
end type

type rb_a from so_radiobutton within w_mat_receipt_sum_report
integer x = 4389
integer y = 96
integer width = 334
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Abnormal"
end type

event clicked;call super::clicked;dw_1.setfilter("receipt_type = 'E'")
dw_1.filter()
end event

type rb_item from so_radiobutton within w_mat_receipt_sum_report
integer x = 59
integer y = 76
integer width = 603
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Item Summary"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window =dw_1
end event

type rb_supplier from so_radiobutton within w_mat_receipt_sum_report
integer x = 59
integer y = 152
integer width = 603
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Supplier Summary"
end type

event clicked;call super::clicked;dw_2.bringtotop = true
selected_data_window =dw_2
end event

type rb_item_sum_supplier from so_radiobutton within w_mat_receipt_sum_report
integer x = 59
integer y = 216
integer width = 745
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Item Summary (Supplier)"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window =dw_3
end event

type rb_location from so_radiobutton within w_mat_receipt_sum_report
integer x = 850
integer y = 76
integer width = 608
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Summary"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
selected_data_window =dw_4
end event

type rb_rcv_iss_sum from so_radiobutton within w_mat_receipt_sum_report
integer x = 850
integer y = 156
integer width = 608
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Rceipt Issue Summary"
end type

event clicked;call super::clicked;dw_5.bringtotop = true
selected_data_window =dw_5
end event

type st_invoice_no from so_statictext within w_mat_receipt_sum_report
integer x = 3365
integer y = 92
integer width = 448
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Invoice No"
end type

type sle_invoice_no from so_singlelineedit within w_mat_receipt_sum_report
integer x = 3365
integer y = 184
integer width = 448
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

type gb_where_condition from so_groupbox within w_mat_receipt_sum_report
integer width = 1477
integer height = 320
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_1 from so_groupbox within w_mat_receipt_sum_report
integer x = 3963
integer width = 846
integer height = 320
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Receipt Type"
end type

type gb_2 from so_groupbox within w_mat_receipt_sum_report
integer x = 3963
integer width = 846
integer height = 320
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Receipt Type"
end type

type gb_3 from so_groupbox within w_mat_receipt_sum_report
integer x = 1545
integer width = 2409
integer height = 320
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


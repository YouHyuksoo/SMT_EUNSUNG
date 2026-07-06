HA$PBExportHeader$w_mat_current_inventory_report.srw
$PBExportComments$Material Current Material Report
forward
global type w_mat_current_inventory_report from w_main_root
end type
type st_3 from so_statictext within w_mat_current_inventory_report
end type
type ddlb_item_code from uo_item_code within w_mat_current_inventory_report
end type
type st_14 from so_statictext within w_mat_current_inventory_report
end type
type sle_item_name from so_singlelineedit within w_mat_current_inventory_report
end type
type sle_1 from so_singlelineedit within w_mat_current_inventory_report
end type
type st_1 from so_statictext within w_mat_current_inventory_report
end type
type rb_current_inventory from so_radiobutton within w_mat_current_inventory_report
end type
type rb_disused from so_radiobutton within w_mat_current_inventory_report
end type
type em_month_term from so_editmask within w_mat_current_inventory_report
end type
type st_2 from so_statictext within w_mat_current_inventory_report
end type
type em_issue_rate from so_editmask within w_mat_current_inventory_report
end type
type st_4 from so_statictext within w_mat_current_inventory_report
end type
type rb_summary from so_radiobutton within w_mat_current_inventory_report
end type
type st_5 from so_statictext within w_mat_current_inventory_report
end type
type ddlb_location_code from uo_basecode within w_mat_current_inventory_report
end type
type rb_all from so_radiobutton within w_mat_current_inventory_report
end type
type rb_gt from so_radiobutton within w_mat_current_inventory_report
end type
type ddlb_product_class from uo_product_class_code within w_mat_current_inventory_report
end type
type st_6 from so_statictext within w_mat_current_inventory_report
end type
type rb_1 from so_radiobutton within w_mat_current_inventory_report
end type
type uo_dateset from uo_ymd_calendar within w_mat_current_inventory_report
end type
type st_receipt_date from so_statictext within w_mat_current_inventory_report
end type
type gb_where_condition from so_groupbox within w_mat_current_inventory_report
end type
type gb_1 from so_groupbox within w_mat_current_inventory_report
end type
type gb_2 from so_groupbox within w_mat_current_inventory_report
end type
type gb_5 from so_groupbox within w_mat_current_inventory_report
end type
end forward

global type w_mat_current_inventory_report from w_main_root
integer width = 4667
integer height = 2840
string title = "Material Inventory Report"
st_3 st_3
ddlb_item_code ddlb_item_code
st_14 st_14
sle_item_name sle_item_name
sle_1 sle_1
st_1 st_1
rb_current_inventory rb_current_inventory
rb_disused rb_disused
em_month_term em_month_term
st_2 st_2
em_issue_rate em_issue_rate
st_4 st_4
rb_summary rb_summary
st_5 st_5
ddlb_location_code ddlb_location_code
rb_all rb_all
rb_gt rb_gt
ddlb_product_class ddlb_product_class
st_6 st_6
rb_1 rb_1
uo_dateset uo_dateset
st_receipt_date st_receipt_date
gb_where_condition gb_where_condition
gb_1 gb_1
gb_2 gb_2
gb_5 gb_5
end type
global w_mat_current_inventory_report w_mat_current_inventory_report

on w_mat_current_inventory_report.create
int iCurrent
call super::create
this.st_3=create st_3
this.ddlb_item_code=create ddlb_item_code
this.st_14=create st_14
this.sle_item_name=create sle_item_name
this.sle_1=create sle_1
this.st_1=create st_1
this.rb_current_inventory=create rb_current_inventory
this.rb_disused=create rb_disused
this.em_month_term=create em_month_term
this.st_2=create st_2
this.em_issue_rate=create em_issue_rate
this.st_4=create st_4
this.rb_summary=create rb_summary
this.st_5=create st_5
this.ddlb_location_code=create ddlb_location_code
this.rb_all=create rb_all
this.rb_gt=create rb_gt
this.ddlb_product_class=create ddlb_product_class
this.st_6=create st_6
this.rb_1=create rb_1
this.uo_dateset=create uo_dateset
this.st_receipt_date=create st_receipt_date
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.st_14
this.Control[iCurrent+4]=this.sle_item_name
this.Control[iCurrent+5]=this.sle_1
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.rb_current_inventory
this.Control[iCurrent+8]=this.rb_disused
this.Control[iCurrent+9]=this.em_month_term
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.em_issue_rate
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.rb_summary
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.ddlb_location_code
this.Control[iCurrent+16]=this.rb_all
this.Control[iCurrent+17]=this.rb_gt
this.Control[iCurrent+18]=this.ddlb_product_class
this.Control[iCurrent+19]=this.st_6
this.Control[iCurrent+20]=this.rb_1
this.Control[iCurrent+21]=this.uo_dateset
this.Control[iCurrent+22]=this.st_receipt_date
this.Control[iCurrent+23]=this.gb_where_condition
this.Control[iCurrent+24]=this.gb_1
this.Control[iCurrent+25]=this.gb_2
this.Control[iCurrent+26]=this.gb_5
end on

on w_mat_current_inventory_report.destroy
call super::destroy
destroy(this.st_3)
destroy(this.ddlb_item_code)
destroy(this.st_14)
destroy(this.sle_item_name)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.rb_current_inventory)
destroy(this.rb_disused)
destroy(this.em_month_term)
destroy(this.st_2)
destroy(this.em_issue_rate)
destroy(this.st_4)
destroy(this.rb_summary)
destroy(this.st_5)
destroy(this.ddlb_location_code)
destroy(this.rb_all)
destroy(this.rb_gt)
destroy(this.ddlb_product_class)
destroy(this.st_6)
destroy(this.rb_1)
destroy(this.uo_dateset)
destroy(this.st_receipt_date)
destroy(this.gb_where_condition)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_5)
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

event ue_data_control;call super::ue_data_control;long row , lvl_month_term , lvi_sign
Decimal lvf_rate
choose case gvs_ue_data_control
		
	case 'RETRIEVE'

			    if rb_all.checked = true then 
				lvi_sign = -2
			    elseif rb_gt.checked = true then 
					lvi_sign = 1
			    end if		
		
		if rb_summary.checked = true then 
			
			dw_1.retrieve(   ddlb_item_code.text+'%' ,ddlb_location_code.getcode()+'%' ,lvi_sign , ddlb_product_class.text+'%' , gvi_organization_id)
			dw_1.setfocus()			
		
		elseif rb_current_inventory.checked = true then 
			dw_2.retrieve(   ddlb_item_code.text+'%' ,ddlb_location_code.getcode()+'%' , lvi_sign , gvi_organization_id)
			dw_2.setfocus()
		elseif rb_disused.checked = true then 
			
			
			lvl_month_term = Long(em_month_term.text)
			lvf_rate =  Dec(em_issue_rate.text )
			
			if isnull(lvf_rate) then 
				lvf_rate = 0 
			end if
			
			dw_3.retrieve(   ddlb_item_code.text+'%' ,  lvl_month_term , lvf_rate ,  gvi_organization_id)
			dw_3.setfocus()			
		else
			dw_4.retrieve(   ddlb_item_code.text+'%' ,ddlb_location_code.getcode()+'%' ,lvi_sign , ddlb_product_class.text+'%' , uo_dateset.text() , gvi_organization_id)
			dw_4.setfocus()			
		end if


	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_mat_current_inventory_report
integer y = 520
end type

type dw_4 from w_main_root`dw_4 within w_mat_current_inventory_report
integer y = 520
integer width = 4544
integer height = 1860
integer taborder = 20
boolean titlebar = true
string dataobject = "d_mat_current_inventory_daily_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_mat_current_inventory_report
integer y = 520
integer width = 4544
integer height = 1860
integer taborder = 30
boolean titlebar = true
string title = "Material Disused Inventory List"
string dataobject = "d_mat_disused_inventory_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_mat_current_inventory_report
integer y = 520
integer width = 4544
integer height = 1860
integer taborder = 40
boolean titlebar = true
string title = "Material Inventory List"
string dataobject = "d_mat_current_inventory_rpt"
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_current_inventory_report
integer y = 520
integer width = 4544
integer height = 1860
integer taborder = 50
boolean titlebar = true
string title = "Material Inventory Summary List"
string dataobject = "d_mat_current_inventory_summary_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_current_inventory_report
end type

type st_3 from so_statictext within w_mat_current_inventory_report
integer x = 1417
integer y = 92
integer width = 526
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_current_inventory_report
integer x = 1417
integer y = 184
integer width = 526
integer taborder = 30
boolean bringtotop = true
end type

type st_14 from so_statictext within w_mat_current_inventory_report
integer x = 1947
integer y = 116
integer width = 398
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Name"
end type

type sle_item_name from so_singlelineedit within w_mat_current_inventory_report
integer x = 1947
integer y = 184
integer width = 398
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

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'ITEM_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    SELECTED_DATA_WINDOW.SETFILTER('')
    SELECTED_DATA_WINDOW.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

type sle_1 from so_singlelineedit within w_mat_current_inventory_report
integer x = 2350
integer y = 184
integer width = 398
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

SELECTED_DATA_WINDOW.SETFILTER('')
SELECTED_DATA_WINDOW.FILTER()

LVS_COLUMN = 'ITEM_SPEC'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    SELECTED_DATA_WINDOW.SETFILTER('')
    SELECTED_DATA_WINDOW.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
SELECTED_DATA_WINDOW.FILTER()
F_MSG_MDI_HELP( STRING( SELECTED_DATA_WINDOW.ROWCOUNT() ) + " Found" )
end event

type st_1 from so_statictext within w_mat_current_inventory_report
integer x = 2350
integer y = 116
integer width = 398
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Spec"
end type

type rb_current_inventory from so_radiobutton within w_mat_current_inventory_report
integer x = 37
integer y = 184
integer width = 617
boolean bringtotop = true
integer weight = 700
string text = "Current Inventory Detail"
end type

event clicked;call super::clicked;selected_data_window = dw_2
dw_2.bringtotop = true
end event

type rb_disused from so_radiobutton within w_mat_current_inventory_report
integer x = 704
integer y = 80
integer width = 617
boolean bringtotop = true
integer weight = 700
string text = "Long time disused  Inventory"
end type

event clicked;call super::clicked;selected_data_window = dw_3
dw_3.bringtotop = true
end event

type em_month_term from so_editmask within w_mat_current_inventory_report
integer x = 1984
integer y = 388
integer taborder = 20
boolean bringtotop = true
string text = "90"
string mask = "###,##0"
boolean spin = true
string minmax = "1~~"
end type

type st_2 from so_statictext within w_mat_current_inventory_report
integer x = 1463
integer y = 400
integer width = 512
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Disused Term(Day)"
end type

type em_issue_rate from so_editmask within w_mat_current_inventory_report
integer x = 3022
integer y = 388
integer taborder = 20
boolean bringtotop = true
string mask = "###,##0.00"
boolean spin = true
string minmax = "1~~"
end type

type st_4 from so_statictext within w_mat_current_inventory_report
integer x = 2478
integer y = 400
integer width = 526
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Minimun Issue Rate"
end type

type rb_summary from so_radiobutton within w_mat_current_inventory_report
integer x = 37
integer y = 80
integer width = 617
boolean bringtotop = true
integer weight = 700
string text = "Current Inventory Summary"
boolean checked = true
end type

event clicked;call super::clicked;selected_data_window = dw_1
dw_1.bringtotop = true
end event

type st_5 from so_statictext within w_mat_current_inventory_report
integer x = 2752
integer y = 104
integer width = 558
integer height = 76
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Code"
end type

type ddlb_location_code from uo_basecode within w_mat_current_inventory_report
integer x = 2752
integer y = 184
integer width = 558
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type rb_all from so_radiobutton within w_mat_current_inventory_report
integer x = 55
integer y = 388
integer width = 581
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter( '')
dw_1.filter( )
end event

type rb_gt from so_radiobutton within w_mat_current_inventory_report
integer x = 722
integer y = 388
integer width = 581
boolean bringtotop = true
integer weight = 700
string text = "Inventory Qty > 0"
end type

event clicked;call super::clicked;dw_1.setfilter('inventory_qty > 0 ')
dw_1.filter( )
end event

type ddlb_product_class from uo_product_class_code within w_mat_current_inventory_report
integer x = 3314
integer y = 184
integer width = 466
integer taborder = 20
boolean bringtotop = true
end type

type st_6 from so_statictext within w_mat_current_inventory_report
integer x = 3310
integer y = 96
integer width = 466
integer height = 76
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Item Class"
end type

type rb_1 from so_radiobutton within w_mat_current_inventory_report
integer x = 704
integer y = 184
integer width = 617
boolean bringtotop = true
integer weight = 700
string text = "Daily Inventory"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4
end event

type uo_dateset from uo_ymd_calendar within w_mat_current_inventory_report
integer x = 3785
integer y = 184
integer taborder = 70
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_receipt_date from so_statictext within w_mat_current_inventory_report
integer x = 3785
integer y = 92
integer width = 407
boolean bringtotop = true
integer weight = 700
string text = "Dateset"
end type

type gb_where_condition from so_groupbox within w_mat_current_inventory_report
integer width = 1385
integer height = 320
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_1 from so_groupbox within w_mat_current_inventory_report
integer x = 1399
integer y = 320
integer width = 2039
integer height = 188
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Disused Where Condition"
end type

type gb_2 from so_groupbox within w_mat_current_inventory_report
integer x = 1394
integer width = 2834
integer height = 320
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_5 from so_groupbox within w_mat_current_inventory_report
integer y = 320
integer width = 1385
integer height = 188
integer taborder = 60
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type


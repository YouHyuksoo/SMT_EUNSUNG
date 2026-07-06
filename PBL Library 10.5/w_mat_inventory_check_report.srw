HA$PBExportHeader$w_mat_inventory_check_report.srw
$PBExportComments$Material Current Material Report
forward
global type w_mat_inventory_check_report from w_main_root
end type
type st_3 from so_statictext within w_mat_inventory_check_report
end type
type ddlb_item_code from uo_item_code within w_mat_inventory_check_report
end type
type st_14 from so_statictext within w_mat_inventory_check_report
end type
type sle_item_name from so_singlelineedit within w_mat_inventory_check_report
end type
type sle_1 from so_singlelineedit within w_mat_inventory_check_report
end type
type st_1 from so_statictext within w_mat_inventory_check_report
end type
type rb_current_inventory from so_radiobutton within w_mat_inventory_check_report
end type
type rb_2 from so_radiobutton within w_mat_inventory_check_report
end type
type em_yyyymm from uo_ym within w_mat_inventory_check_report
end type
type st_2 from so_statictext within w_mat_inventory_check_report
end type
type ddlb_location_code from uo_basecode within w_mat_inventory_check_report
end type
type st_5 from so_statictext within w_mat_inventory_check_report
end type
type gb_where_condition from so_groupbox within w_mat_inventory_check_report
end type
type gb_2 from so_groupbox within w_mat_inventory_check_report
end type
end forward

global type w_mat_inventory_check_report from w_main_root
integer width = 4667
integer height = 2840
string title = "Material Current Inventory Report"
st_3 st_3
ddlb_item_code ddlb_item_code
st_14 st_14
sle_item_name sle_item_name
sle_1 sle_1
st_1 st_1
rb_current_inventory rb_current_inventory
rb_2 rb_2
em_yyyymm em_yyyymm
st_2 st_2
ddlb_location_code ddlb_location_code
st_5 st_5
gb_where_condition gb_where_condition
gb_2 gb_2
end type
global w_mat_inventory_check_report w_mat_inventory_check_report

on w_mat_inventory_check_report.create
int iCurrent
call super::create
this.st_3=create st_3
this.ddlb_item_code=create ddlb_item_code
this.st_14=create st_14
this.sle_item_name=create sle_item_name
this.sle_1=create sle_1
this.st_1=create st_1
this.rb_current_inventory=create rb_current_inventory
this.rb_2=create rb_2
this.em_yyyymm=create em_yyyymm
this.st_2=create st_2
this.ddlb_location_code=create ddlb_location_code
this.st_5=create st_5
this.gb_where_condition=create gb_where_condition
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.st_14
this.Control[iCurrent+4]=this.sle_item_name
this.Control[iCurrent+5]=this.sle_1
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.rb_current_inventory
this.Control[iCurrent+8]=this.rb_2
this.Control[iCurrent+9]=this.em_yyyymm
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.ddlb_location_code
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.gb_where_condition
this.Control[iCurrent+14]=this.gb_2
end on

on w_mat_inventory_check_report.destroy
call super::destroy
destroy(this.st_3)
destroy(this.ddlb_item_code)
destroy(this.st_14)
destroy(this.sle_item_name)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.rb_current_inventory)
destroy(this.rb_2)
destroy(this.em_yyyymm)
destroy(this.st_2)
destroy(this.ddlb_location_code)
destroy(this.st_5)
destroy(this.gb_where_condition)
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

event ue_data_control;call super::ue_data_control;long row , lvl_month_term
Decimal lvf_rate
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		if rb_current_inventory.checked = true then 
			dw_1.retrieve(  em_yyyymm.text ,  ddlb_item_code.text+'%' , ddlb_location_code.getcode( )+'%' , gvi_organization_id)
			dw_1.setfocus()
		else
			dw_2.retrieve(   em_yyyymm.text , ddlb_item_code.text+'%' , ddlb_location_code.getcode( )+'%' , gvi_organization_id)
			f_set_column_dddw(dw_2)
			dw_2.setfocus()			
			
		end if


	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_mat_inventory_check_report
integer y = 520
end type

type dw_4 from w_main_root`dw_4 within w_mat_inventory_check_report
integer y = 520
integer taborder = 20
end type

type dw_3 from w_main_root`dw_3 within w_mat_inventory_check_report
integer y = 520
integer taborder = 30
end type

type dw_2 from w_main_root`dw_2 within w_mat_inventory_check_report
integer y = 328
integer width = 4544
integer height = 1860
integer taborder = 40
boolean titlebar = true
string dataobject = "d_mat_inventory_check_label_rpt"
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_inventory_check_report
integer y = 328
integer width = 4544
integer height = 1860
integer taborder = 50
boolean titlebar = true
string title = "Material Inventory List"
string dataobject = "d_mat_inventory_check_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_inventory_check_report
end type

type st_3 from so_statictext within w_mat_inventory_check_report
integer x = 1285
integer y = 96
integer width = 526
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_inventory_check_report
integer x = 1285
integer y = 168
integer width = 526
integer taborder = 30
boolean bringtotop = true
end type

type st_14 from so_statictext within w_mat_inventory_check_report
integer x = 1815
integer y = 96
integer width = 448
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Name"
end type

type sle_item_name from so_singlelineedit within w_mat_inventory_check_report
integer x = 1815
integer y = 168
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

type sle_1 from so_singlelineedit within w_mat_inventory_check_report
integer x = 2272
integer y = 168
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

type st_1 from so_statictext within w_mat_inventory_check_report
integer x = 2272
integer y = 96
integer width = 453
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Spec"
end type

type rb_current_inventory from so_radiobutton within w_mat_inventory_check_report
integer x = 37
integer y = 96
integer width = 841
boolean bringtotop = true
integer weight = 700
string text = "Inventory Check List"
boolean checked = true
end type

event clicked;call super::clicked;selected_data_window = dw_1
dw_1.bringtotop = true
end event

type rb_2 from so_radiobutton within w_mat_inventory_check_report
integer x = 37
integer y = 192
integer width = 841
boolean bringtotop = true
integer weight = 700
string text = "Inventory Check Sheet"
end type

event clicked;call super::clicked;selected_data_window = dw_2
dw_2.bringtotop = true
end event

type em_yyyymm from uo_ym within w_mat_inventory_check_report
integer x = 955
integer y = 168
integer taborder = 30
boolean bringtotop = true
end type

type st_2 from so_statictext within w_mat_inventory_check_report
integer x = 955
integer y = 96
integer width = 325
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "YYYYMM"
end type

type ddlb_location_code from uo_basecode within w_mat_inventory_check_report
integer x = 2734
integer y = 168
integer width = 558
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type st_5 from so_statictext within w_mat_inventory_check_report
integer x = 2734
integer y = 88
integer width = 558
integer height = 76
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Code"
end type

type gb_where_condition from so_groupbox within w_mat_inventory_check_report
integer width = 919
integer height = 320
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_inventory_check_report
integer x = 923
integer width = 2391
integer height = 320
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


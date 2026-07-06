HA$PBExportHeader$w_mat_receipt_report.srw
$PBExportComments$Material Purchase Order Report
forward
global type w_mat_receipt_report from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_receipt_report
end type
type uo_dateend from uo_ymd_calendar within w_mat_receipt_report
end type
type st_receipt_date from so_statictext within w_mat_receipt_report
end type
type rb_date from so_radiobutton within w_mat_receipt_report
end type
type rb_item from so_radiobutton within w_mat_receipt_report
end type
type st_3 from so_statictext within w_mat_receipt_report
end type
type ddlb_item_code from uo_item_code within w_mat_receipt_report
end type
type st_2 from so_statictext within w_mat_receipt_report
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_receipt_report
end type
type rb_supplier from so_radiobutton within w_mat_receipt_report
end type
type rb_matrix from so_radiobutton within w_mat_receipt_report
end type
type rb_all from so_radiobutton within w_mat_receipt_report
end type
type rb_2 from so_radiobutton within w_mat_receipt_report
end type
type rb_3 from so_radiobutton within w_mat_receipt_report
end type
type rb_price_error from so_radiobutton within w_mat_receipt_report
end type
type material_mfs_t from so_statictext within w_mat_receipt_report
end type
type sle_material_mfs from so_singlelineedit within w_mat_receipt_report
end type
type st_1 from so_statictext within w_mat_receipt_report
end type
type ddlb_product_class from uo_product_class_code within w_mat_receipt_report
end type
type sle_supplier_lot_no from so_singlelineedit within w_mat_receipt_report
end type
type st_4 from so_statictext within w_mat_receipt_report
end type
type ddlb_location_code from uo_basecode within w_mat_receipt_report
end type
type st_5 from so_statictext within w_mat_receipt_report
end type
type rb_return from so_radiobutton within w_mat_receipt_report
end type
type ddlb_order_type from uo_basecode within w_mat_receipt_report
end type
type st_6 from so_statictext within w_mat_receipt_report
end type
type ddlb_receipt_type from uo_basecode within w_mat_receipt_report
end type
type st_7 from so_statictext within w_mat_receipt_report
end type
type st_11 from so_statictext within w_mat_receipt_report
end type
type sle_our_barcode from so_singlelineedit within w_mat_receipt_report
end type
type sle_origin_mfs from so_singlelineedit within w_mat_receipt_report
end type
type st_8 from so_statictext within w_mat_receipt_report
end type
type gb_where_condition from so_groupbox within w_mat_receipt_report
end type
type gb_1 from so_groupbox within w_mat_receipt_report
end type
type gb_3 from so_groupbox within w_mat_receipt_report
end type
type gb_2 from so_groupbox within w_mat_receipt_report
end type
end forward

global type w_mat_receipt_report from w_main_root
integer width = 5504
integer height = 2736
string title = "Material Receipt Report"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_receipt_date st_receipt_date
rb_date rb_date
rb_item rb_item
st_3 st_3
ddlb_item_code ddlb_item_code
st_2 st_2
ddlb_supplier_code ddlb_supplier_code
rb_supplier rb_supplier
rb_matrix rb_matrix
rb_all rb_all
rb_2 rb_2
rb_3 rb_3
rb_price_error rb_price_error
material_mfs_t material_mfs_t
sle_material_mfs sle_material_mfs
st_1 st_1
ddlb_product_class ddlb_product_class
sle_supplier_lot_no sle_supplier_lot_no
st_4 st_4
ddlb_location_code ddlb_location_code
st_5 st_5
rb_return rb_return
ddlb_order_type ddlb_order_type
st_6 st_6
ddlb_receipt_type ddlb_receipt_type
st_7 st_7
st_11 st_11
sle_our_barcode sle_our_barcode
sle_origin_mfs sle_origin_mfs
st_8 st_8
gb_where_condition gb_where_condition
gb_1 gb_1
gb_3 gb_3
gb_2 gb_2
end type
global w_mat_receipt_report w_mat_receipt_report

on w_mat_receipt_report.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_receipt_date=create st_receipt_date
this.rb_date=create rb_date
this.rb_item=create rb_item
this.st_3=create st_3
this.ddlb_item_code=create ddlb_item_code
this.st_2=create st_2
this.ddlb_supplier_code=create ddlb_supplier_code
this.rb_supplier=create rb_supplier
this.rb_matrix=create rb_matrix
this.rb_all=create rb_all
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_price_error=create rb_price_error
this.material_mfs_t=create material_mfs_t
this.sle_material_mfs=create sle_material_mfs
this.st_1=create st_1
this.ddlb_product_class=create ddlb_product_class
this.sle_supplier_lot_no=create sle_supplier_lot_no
this.st_4=create st_4
this.ddlb_location_code=create ddlb_location_code
this.st_5=create st_5
this.rb_return=create rb_return
this.ddlb_order_type=create ddlb_order_type
this.st_6=create st_6
this.ddlb_receipt_type=create ddlb_receipt_type
this.st_7=create st_7
this.st_11=create st_11
this.sle_our_barcode=create sle_our_barcode
this.sle_origin_mfs=create sle_origin_mfs
this.st_8=create st_8
this.gb_where_condition=create gb_where_condition
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_receipt_date
this.Control[iCurrent+4]=this.rb_date
this.Control[iCurrent+5]=this.rb_item
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.ddlb_item_code
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.ddlb_supplier_code
this.Control[iCurrent+10]=this.rb_supplier
this.Control[iCurrent+11]=this.rb_matrix
this.Control[iCurrent+12]=this.rb_all
this.Control[iCurrent+13]=this.rb_2
this.Control[iCurrent+14]=this.rb_3
this.Control[iCurrent+15]=this.rb_price_error
this.Control[iCurrent+16]=this.material_mfs_t
this.Control[iCurrent+17]=this.sle_material_mfs
this.Control[iCurrent+18]=this.st_1
this.Control[iCurrent+19]=this.ddlb_product_class
this.Control[iCurrent+20]=this.sle_supplier_lot_no
this.Control[iCurrent+21]=this.st_4
this.Control[iCurrent+22]=this.ddlb_location_code
this.Control[iCurrent+23]=this.st_5
this.Control[iCurrent+24]=this.rb_return
this.Control[iCurrent+25]=this.ddlb_order_type
this.Control[iCurrent+26]=this.st_6
this.Control[iCurrent+27]=this.ddlb_receipt_type
this.Control[iCurrent+28]=this.st_7
this.Control[iCurrent+29]=this.st_11
this.Control[iCurrent+30]=this.sle_our_barcode
this.Control[iCurrent+31]=this.sle_origin_mfs
this.Control[iCurrent+32]=this.st_8
this.Control[iCurrent+33]=this.gb_where_condition
this.Control[iCurrent+34]=this.gb_1
this.Control[iCurrent+35]=this.gb_3
this.Control[iCurrent+36]=this.gb_2
end on

on w_mat_receipt_report.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_receipt_date)
destroy(this.rb_date)
destroy(this.rb_item)
destroy(this.st_3)
destroy(this.ddlb_item_code)
destroy(this.st_2)
destroy(this.ddlb_supplier_code)
destroy(this.rb_supplier)
destroy(this.rb_matrix)
destroy(this.rb_all)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_price_error)
destroy(this.material_mfs_t)
destroy(this.sle_material_mfs)
destroy(this.st_1)
destroy(this.ddlb_product_class)
destroy(this.sle_supplier_lot_no)
destroy(this.st_4)
destroy(this.ddlb_location_code)
destroy(this.st_5)
destroy(this.rb_return)
destroy(this.ddlb_order_type)
destroy(this.st_6)
destroy(this.ddlb_receipt_type)
destroy(this.st_7)
destroy(this.st_11)
destroy(this.sle_our_barcode)
destroy(this.sle_origin_mfs)
destroy(this.st_8)
destroy(this.gb_where_condition)
destroy(this.gb_1)
destroy(this.gb_3)
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
		if rb_date.checked = true then 
			dw_1.retrieve(  uo_dateset.text() , uo_dateend.text() , ddlb_supplier_code.text + '%' , ddlb_item_code.text+ '%' ,ddlb_product_class.text+'%' , ddlb_location_code.getcode()+'%'  ,ddlb_RECEIPT_TYPE.GETCODE()+'%' ,  gvi_organization_id)
			dw_1.setfocus()
		elseif rb_item.checked = true then 
			dw_2.retrieve(  uo_dateset.text() , uo_dateend.text() , ddlb_supplier_code.text + '%' , ddlb_item_code.text+ '%' ,gvi_organization_id)
			dw_2.setfocus()
		elseif rb_supplier.checked = true then 
			dw_3.retrieve(  uo_dateset.text() , uo_dateend.text() , ddlb_supplier_code.text + '%' , ddlb_item_code.text+ '%' ,gvi_organization_id , ddlb_order_type.getcode()+'%' )
			dw_3.setfocus()
		elseif rb_matrix.checked = true then 
			dw_4.retrieve(  uo_dateset.text() , uo_dateend.text() , ddlb_item_code.text+ '%' ,gvi_organization_id)
			dw_4.setfocus()
		elseif  rb_return.checked = true then 
			dw_5.retrieve(  uo_dateset.text() , uo_dateend.text() , ddlb_supplier_code.text + '%' , ddlb_item_code.text+ '%' ,gvi_organization_id)
			dw_5.setfocus()			
		end if 

	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_mat_receipt_report
integer y = 568
integer width = 4544
integer height = 1920
boolean titlebar = true
string title = "Material Receipt Return Report"
string dataobject = "d_mat_receipt_return_by_supplier_rpt"
end type

type dw_4 from w_main_root`dw_4 within w_mat_receipt_report
integer y = 568
integer width = 4544
integer height = 1920
integer taborder = 20
boolean titlebar = true
string title = "Material Receipt Matrix Report"
string dataobject = "d_mat_receipt_by_matrix_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_mat_receipt_report
integer y = 568
integer width = 4544
integer height = 1920
integer taborder = 30
boolean titlebar = true
string title = "Material Receipt Report"
string dataobject = "d_mat_receipt_by_supplier_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_mat_receipt_report
integer y = 568
integer width = 4544
integer height = 1920
integer taborder = 40
boolean titlebar = true
string title = "Material Receipt Report"
string dataobject = "d_mat_receipt_by_item_rpt"
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_receipt_report
integer y = 568
integer width = 4544
integer height = 1920
integer taborder = 50
boolean titlebar = true
string title = "Material Receipt Report"
string dataobject = "d_mat_receipt_by_date_grid_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_receipt_report
end type

type uo_dateset from uo_ymd_calendar within w_mat_receipt_report
integer x = 626
integer y = 184
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_receipt_report
integer x = 1038
integer y = 184
integer taborder = 70
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_receipt_date from so_statictext within w_mat_receipt_report
integer x = 631
integer y = 92
integer width = 814
boolean bringtotop = true
integer weight = 700
string text = "Receipt Date"
end type

type rb_date from so_radiobutton within w_mat_receipt_report
integer x = 46
integer y = 100
integer width = 489
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Date"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1
rb_price_error.enabled = true
end event

type rb_item from so_radiobutton within w_mat_receipt_report
integer x = 46
integer y = 180
integer width = 489
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2
rb_price_error.enabled = false
end event

type st_3 from so_statictext within w_mat_receipt_report
integer x = 1906
integer y = 92
integer width = 526
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_receipt_report
integer x = 1906
integer y = 184
integer width = 526
integer taborder = 30
boolean bringtotop = true
end type

type st_2 from so_statictext within w_mat_receipt_report
integer x = 1458
integer y = 92
integer width = 439
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type ddlb_supplier_code from uo_supplier_code within w_mat_receipt_report
integer x = 1458
integer y = 184
integer width = 439
integer taborder = 30
boolean bringtotop = true
end type

type rb_supplier from so_radiobutton within w_mat_receipt_report
integer x = 46
integer y = 256
integer width = 489
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Supplier"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3
rb_price_error.enabled = false
end event

type rb_matrix from so_radiobutton within w_mat_receipt_report
integer x = 46
integer y = 344
integer width = 489
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Matrix"
end type

event clicked;call super::clicked;dw_4.bringtotop = true 
selected_data_window = dw_4
rb_price_error.enabled = false
end event

type rb_all from so_radiobutton within w_mat_receipt_report
integer x = 1742
integer y = 408
integer width = 471
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;selected_data_window.setfilter( '')
selected_data_window.filter( )
end event

type rb_2 from so_radiobutton within w_mat_receipt_report
integer x = 2226
integer y = 408
integer width = 558
boolean bringtotop = true
integer weight = 700
string text = "Normal Receipt"
end type

event clicked;call super::clicked;selected_data_window.setfilter("receipt_type ='"+'N'+"'")
selected_data_window.filter( )
end event

type rb_3 from so_radiobutton within w_mat_receipt_report
integer x = 2843
integer y = 408
integer width = 471
boolean bringtotop = true
integer weight = 700
string text = "Extra Receipt"
end type

event clicked;call super::clicked;selected_data_window.setfilter("receipt_type <> '"+'N'+"'")
selected_data_window.filter( )
end event

type rb_price_error from so_radiobutton within w_mat_receipt_report
integer x = 3397
integer y = 408
integer width = 530
boolean bringtotop = true
integer weight = 700
string text = "Price Error"
end type

event clicked;call super::clicked;dw_1.setfilter("unit_price <> check_unit_price")
dw_1.filter( )
end event

type material_mfs_t from so_statictext within w_mat_receipt_report
integer x = 2944
integer y = 92
integer width = 384
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Material MFS"
end type

type sle_material_mfs from so_singlelineedit within w_mat_receipt_report
integer x = 2949
integer y = 184
integer width = 384
integer height = 84
integer taborder = 90
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

LVS_COLUMN = 'MATERIAL_MFS'
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

type st_1 from so_statictext within w_mat_receipt_report
integer x = 2437
integer y = 92
integer width = 512
boolean bringtotop = true
integer weight = 700
string text = "Item Class"
end type

type ddlb_product_class from uo_product_class_code within w_mat_receipt_report
integer x = 2437
integer y = 184
integer width = 507
integer taborder = 20
boolean bringtotop = true
boolean allowedit = true
end type

type sle_supplier_lot_no from so_singlelineedit within w_mat_receipt_report
integer x = 3337
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

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

DW_1.SETFILTER('')
DW_1.FILTER()

LVS_COLUMN = 'MFS'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    DW_1.SETFILTER('')
    DW_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found" )
end event

type st_4 from so_statictext within w_mat_receipt_report
integer x = 3337
integer y = 92
integer width = 448
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "MFS"
end type

type ddlb_location_code from uo_basecode within w_mat_receipt_report
integer x = 4247
integer y = 184
integer width = 393
integer height = 1504
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type st_5 from so_statictext within w_mat_receipt_report
integer x = 4247
integer y = 92
integer width = 393
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Code"
end type

type rb_return from so_radiobutton within w_mat_receipt_report
integer x = 46
integer y = 424
integer width = 489
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Receipt Return"
end type

event clicked;call super::clicked;dw_5.bringtotop = true 
selected_data_window = dw_5
rb_price_error.enabled = false
end event

type ddlb_order_type from uo_basecode within w_mat_receipt_report
integer x = 4649
integer y = 184
integer width = 357
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw('ORDER TYPE')
end event

type st_6 from so_statictext within w_mat_receipt_report
integer x = 4649
integer y = 92
integer width = 352
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Order Type"
end type

type ddlb_receipt_type from uo_basecode within w_mat_receipt_report
integer x = 5019
integer y = 184
integer width = 357
integer taborder = 70
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw('RECEIPT TYPE')
end event

type st_7 from so_statictext within w_mat_receipt_report
integer x = 5033
integer y = 92
integer width = 352
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Receit Type"
end type

type st_11 from so_statictext within w_mat_receipt_report
integer x = 635
integer y = 372
integer width = 1006
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 255
string text = "Barcode"
end type

type sle_our_barcode from so_singlelineedit within w_mat_receipt_report
integer x = 635
integer y = 436
integer width = 1006
integer height = 84
integer taborder = 60
boolean bringtotop = true
end type

event modified;call super::modified;int lvi_pos1 , lvi_pos2
string lvs_our_barcode  , lvs_item_code , lvs_lot_no 
lvs_our_barcode = this.text 

//===================================================
//
//===================================================
//lvi_pos1 =  pos(lvs_our_barcode , '-' , 7 ) 
//
//if  lvi_pos1 <= 0 then 
//	
//	f_msgbox1(1175 ,lvs_our_barcode )
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1 
//	
//end if 
//
////=================================================
////
////=================================================
//
//lvs_item_code = trim( mid( lvs_our_barcode , 1 ,  lvi_pos1 -1 ))

SELECT  f_get_item_code_from_barcode (:lvs_our_barcode) 
	INTO :lvs_item_code
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 
	
	if  lvs_item_code = '' then 
		
		f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")
		f_msgbox1(1175 ,lvs_our_barcode )
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)
		return 
	end if 
	

if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
	f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")	
	f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$

	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()
	return -1
end if 

//==================================================
// $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
//==================================================
//lvi_pos2 =  pos(lvs_our_barcode , '-' , lvi_pos1+1 ) 
//
//if  lvi_pos2 <= 0 then 
//
//	lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,  100 ))	
//else
//	lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,   lvi_pos2 - lvi_pos1 -1 ))
//end if 
//
//if lvs_lot_no = ''  then 
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1
//end if 
SELECT  F_GET_LOT_NO_FROM_BARCODE (:lvs_our_barcode ) 
	INTO :lvs_lot_no
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 

	if lvs_lot_no = ''  then 
		f_msg( "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'P')
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)	
		return
	end if 

ddlb_item_code.text = lvs_item_code
sle_material_mfs.text = lvs_lot_no
this.selecttext( 1,100)
f_retrieve()

end event

type sle_origin_mfs from so_singlelineedit within w_mat_receipt_report
integer x = 3794
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

DW_1.SETFILTER('')
DW_1.FILTER()

LVS_COLUMN = 'ORIGIN_MFS'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    DW_1.SETFILTER('')
    DW_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found" )
end event

type st_8 from so_statictext within w_mat_receipt_report
integer x = 3790
integer y = 92
integer width = 448
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "ORIGIN MFS"
end type

type gb_where_condition from so_groupbox within w_mat_receipt_report
integer x = 594
integer width = 4823
integer height = 320
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_1 from so_groupbox within w_mat_receipt_report
integer width = 585
integer height = 556
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_3 from so_groupbox within w_mat_receipt_report
integer x = 1701
integer y = 316
integer width = 2245
integer height = 240
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

type gb_2 from so_groupbox within w_mat_receipt_report
integer x = 594
integer y = 320
integer width = 1093
integer height = 240
integer taborder = 70
end type


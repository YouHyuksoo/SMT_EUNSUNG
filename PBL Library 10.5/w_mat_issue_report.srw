HA$PBExportHeader$w_mat_issue_report.srw
$PBExportComments$Material Issue Report
forward
global type w_mat_issue_report from w_main_root
end type
type st_receipt_date from so_statictext within w_mat_issue_report
end type
type st_3 from so_statictext within w_mat_issue_report
end type
type ddlb_item_code from uo_item_code within w_mat_issue_report
end type
type ddlb_line_code from uo_line_code within w_mat_issue_report
end type
type st_5 from so_statictext within w_mat_issue_report
end type
type sle_material_mfs from so_singlelineedit within w_mat_issue_report
end type
type st_7 from so_statictext within w_mat_issue_report
end type
type sle_our_barcode from so_singlelineedit within w_mat_issue_report
end type
type st_11 from so_statictext within w_mat_issue_report
end type
type rb_issue_list from so_radiobutton within w_mat_issue_report
end type
type rb_2 from so_radiobutton within w_mat_issue_report
end type
type em_unit_price from so_editmask within w_mat_issue_report
end type
type st_8 from so_statictext within w_mat_issue_report
end type
type sle_mfs from so_singlelineedit within w_mat_issue_report
end type
type st_1 from so_statictext within w_mat_issue_report
end type
type uo_dateset from uo_ymdh_calendar within w_mat_issue_report
end type
type ddlb_abc_grade from uo_basecode within w_mat_issue_report
end type
type st_2 from so_statictext within w_mat_issue_report
end type
type uo_dateend from uo_ymdh_now_calendar within w_mat_issue_report
end type
type ddlb_location_code from uo_basecode within w_mat_issue_report
end type
type st_4 from so_statictext within w_mat_issue_report
end type
type gb_where_condition from so_groupbox within w_mat_issue_report
end type
type gb_2 from so_groupbox within w_mat_issue_report
end type
type gb_1 from so_groupbox within w_mat_issue_report
end type
end forward

global type w_mat_issue_report from w_main_root
integer width = 5998
integer height = 3296
string title = "Material Issue Report"
st_receipt_date st_receipt_date
st_3 st_3
ddlb_item_code ddlb_item_code
ddlb_line_code ddlb_line_code
st_5 st_5
sle_material_mfs sle_material_mfs
st_7 st_7
sle_our_barcode sle_our_barcode
st_11 st_11
rb_issue_list rb_issue_list
rb_2 rb_2
em_unit_price em_unit_price
st_8 st_8
sle_mfs sle_mfs
st_1 st_1
uo_dateset uo_dateset
ddlb_abc_grade ddlb_abc_grade
st_2 st_2
uo_dateend uo_dateend
ddlb_location_code ddlb_location_code
st_4 st_4
gb_where_condition gb_where_condition
gb_2 gb_2
gb_1 gb_1
end type
global w_mat_issue_report w_mat_issue_report

on w_mat_issue_report.create
int iCurrent
call super::create
this.st_receipt_date=create st_receipt_date
this.st_3=create st_3
this.ddlb_item_code=create ddlb_item_code
this.ddlb_line_code=create ddlb_line_code
this.st_5=create st_5
this.sle_material_mfs=create sle_material_mfs
this.st_7=create st_7
this.sle_our_barcode=create sle_our_barcode
this.st_11=create st_11
this.rb_issue_list=create rb_issue_list
this.rb_2=create rb_2
this.em_unit_price=create em_unit_price
this.st_8=create st_8
this.sle_mfs=create sle_mfs
this.st_1=create st_1
this.uo_dateset=create uo_dateset
this.ddlb_abc_grade=create ddlb_abc_grade
this.st_2=create st_2
this.uo_dateend=create uo_dateend
this.ddlb_location_code=create ddlb_location_code
this.st_4=create st_4
this.gb_where_condition=create gb_where_condition
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_receipt_date
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.ddlb_line_code
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.sle_material_mfs
this.Control[iCurrent+7]=this.st_7
this.Control[iCurrent+8]=this.sle_our_barcode
this.Control[iCurrent+9]=this.st_11
this.Control[iCurrent+10]=this.rb_issue_list
this.Control[iCurrent+11]=this.rb_2
this.Control[iCurrent+12]=this.em_unit_price
this.Control[iCurrent+13]=this.st_8
this.Control[iCurrent+14]=this.sle_mfs
this.Control[iCurrent+15]=this.st_1
this.Control[iCurrent+16]=this.uo_dateset
this.Control[iCurrent+17]=this.ddlb_abc_grade
this.Control[iCurrent+18]=this.st_2
this.Control[iCurrent+19]=this.uo_dateend
this.Control[iCurrent+20]=this.ddlb_location_code
this.Control[iCurrent+21]=this.st_4
this.Control[iCurrent+22]=this.gb_where_condition
this.Control[iCurrent+23]=this.gb_2
this.Control[iCurrent+24]=this.gb_1
end on

on w_mat_issue_report.destroy
call super::destroy
destroy(this.st_receipt_date)
destroy(this.st_3)
destroy(this.ddlb_item_code)
destroy(this.ddlb_line_code)
destroy(this.st_5)
destroy(this.sle_material_mfs)
destroy(this.st_7)
destroy(this.sle_our_barcode)
destroy(this.st_11)
destroy(this.rb_issue_list)
destroy(this.rb_2)
destroy(this.em_unit_price)
destroy(this.st_8)
destroy(this.sle_mfs)
destroy(this.st_1)
destroy(this.uo_dateset)
destroy(this.ddlb_abc_grade)
destroy(this.st_2)
destroy(this.uo_dateend)
destroy(this.ddlb_location_code)
destroy(this.st_4)
destroy(this.gb_where_condition)
destroy(this.gb_2)
destroy(this.gb_1)
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
Ivs_resize_type                      = 'MASTER_DETAIL_1LF2R'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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
		
			if rb_issue_list.checked = true then 
	
				dw_1.retrieve(  uo_dateset.text() , uo_dateend.text() ,  ddlb_item_code.text+ '%' ,  ddlb_line_code.getcode()+'%' ,  sle_material_mfs.text+'%' , sle_mfs.text+'%' , ddlb_abc_grade.getcode( )+'%' , ddlb_location_code.getcode()+'%',   gvi_organization_id)
				dw_1.setfocus()
	
			else
				dw_3.retrieve(  uo_dateset.text() , uo_dateend.text() ,  ddlb_item_code.text+ '%'  ,  ddlb_line_code.getcode()+'%' , sle_material_mfs.text+'%' , Dec(em_unit_price.text) , sle_mfs.text+'%' ,  ddlb_abc_grade.getcode( )+'%', ddlb_location_code.getcode()+'%' ,  gvi_organization_id)
				dw_3.setfocus()				
				
			end if
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_mat_issue_report
integer y = 600
integer width = 3845
integer height = 2184
boolean titlebar = true
string title = "Material Issued  Remain List"
string dataobject = "d_mat_issue_by_not_issued_rpt"
end type

type dw_4 from w_main_root`dw_4 within w_mat_issue_report
integer y = 600
integer width = 3845
integer height = 2184
integer taborder = 20
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_mat_issue_report
integer y = 600
integer width = 3845
integer height = 2184
integer taborder = 30
boolean titlebar = true
string dataobject = "d_mat_issue_by_date_simple_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_mat_issue_report
integer x = 3845
integer y = 600
integer width = 2103
integer height = 2184
integer taborder = 40
boolean titlebar = true
string dataobject = "d_smt_checkhist_4_issue_rpt"
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_issue_report
integer y = 600
integer width = 3845
integer height = 2184
integer taborder = 50
boolean titlebar = true
string title = "Material Issue By Date List"
string dataobject = "d_mat_issue_by_date_rpt"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve( this.object.item_code[currentrow]+"-"+this.object.material_mfs[currentrow]+'%')
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_issue_report
end type

type st_receipt_date from so_statictext within w_mat_issue_report
integer x = 741
integer y = 104
integer width = 1083
integer height = 76
boolean bringtotop = true
integer weight = 700
string text = "Issue Date"
end type

type st_3 from so_statictext within w_mat_issue_report
integer x = 1847
integer y = 104
integer width = 512
integer height = 76
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_issue_report
integer x = 1847
integer y = 180
integer width = 512
integer height = 676
integer taborder = 30
boolean bringtotop = true
end type

type ddlb_line_code from uo_line_code within w_mat_issue_report
integer x = 2373
integer y = 180
integer width = 475
integer height = 1836
integer taborder = 30
boolean bringtotop = true
end type

type st_5 from so_statictext within w_mat_issue_report
integer x = 2373
integer y = 104
integer width = 475
integer height = 76
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Line Code"
end type

type sle_material_mfs from so_singlelineedit within w_mat_issue_report
integer x = 2857
integer y = 180
integer width = 480
integer height = 84
integer taborder = 50
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

type st_7 from so_statictext within w_mat_issue_report
integer x = 2857
integer y = 104
integer width = 480
integer height = 76
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Material MFS"
end type

type sle_our_barcode from so_singlelineedit within w_mat_issue_report
integer x = 64
integer y = 460
integer width = 1006
integer height = 84
integer taborder = 50
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

type st_11 from so_statictext within w_mat_issue_report
integer x = 64
integer y = 396
integer width = 1006
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 255
string text = "Barcode"
end type

type rb_issue_list from so_radiobutton within w_mat_issue_report
integer x = 87
integer y = 96
boolean bringtotop = true
string text = "Issue List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
dw_2.bringtotop = true 
selected_data_window = dw_1
end event

type rb_2 from so_radiobutton within w_mat_issue_report
integer x = 87
integer y = 192
boolean bringtotop = true
string text = "Issue List Simple"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 

selected_data_window = dw_3
end event

type em_unit_price from so_editmask within w_mat_issue_report
integer x = 3831
integer y = 180
integer width = 288
integer taborder = 80
boolean bringtotop = true
string text = "0"
string mask = "###,##0"
string minmax = "0~~"
end type

type st_8 from so_statictext within w_mat_issue_report
integer x = 3831
integer y = 104
integer width = 288
integer height = 76
boolean bringtotop = true
integer weight = 700
string text = "Unit Price"
end type

type sle_mfs from so_singlelineedit within w_mat_issue_report
integer x = 3342
integer y = 180
integer width = 480
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type st_1 from so_statictext within w_mat_issue_report
integer x = 3342
integer y = 104
integer width = 480
integer height = 76
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "MFS"
end type

type uo_dateset from uo_ymdh_calendar within w_mat_issue_report
event destroy ( )
integer x = 741
integer y = 180
integer width = 549
integer taborder = 80
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymdh_calendar::destroy
end on

type ddlb_abc_grade from uo_basecode within w_mat_issue_report
integer x = 4128
integer y = 180
integer width = 338
integer taborder = 70
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'ABC GRADE')
end event

type st_2 from so_statictext within w_mat_issue_report
integer x = 4133
integer y = 104
integer width = 325
integer height = 76
boolean bringtotop = true
string text = "ABC GRADE"
end type

type uo_dateend from uo_ymdh_now_calendar within w_mat_issue_report
event destroy ( )
integer x = 1298
integer y = 180
integer width = 549
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymdh_now_calendar::destroy
end on

type ddlb_location_code from uo_basecode within w_mat_issue_report
integer x = 4475
integer y = 180
integer width = 590
integer height = 1504
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type st_4 from so_statictext within w_mat_issue_report
integer x = 4471
integer y = 104
integer width = 590
integer height = 76
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Code"
end type

type gb_where_condition from so_groupbox within w_mat_issue_report
integer x = 709
integer width = 4398
integer height = 320
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_mat_issue_report
integer width = 695
integer height = 324
integer taborder = 60
string text = "Category"
end type

type gb_1 from so_groupbox within w_mat_issue_report
integer x = 23
integer y = 344
integer width = 1093
integer height = 240
integer taborder = 70
end type


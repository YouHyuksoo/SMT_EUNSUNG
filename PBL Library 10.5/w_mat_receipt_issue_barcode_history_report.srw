HA$PBExportHeader$w_mat_receipt_issue_barcode_history_report.srw
$PBExportComments$Material Purchase Order Report
forward
global type w_mat_receipt_issue_barcode_history_report from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_receipt_issue_barcode_history_report
end type
type uo_dateend from uo_ymd_calendar within w_mat_receipt_issue_barcode_history_report
end type
type st_date from so_statictext within w_mat_receipt_issue_barcode_history_report
end type
type sle_material_mfs from so_singlelineedit within w_mat_receipt_issue_barcode_history_report
end type
type st_4 from so_statictext within w_mat_receipt_issue_barcode_history_report
end type
type ddlb_item_code from uo_item_code within w_mat_receipt_issue_barcode_history_report
end type
type st_item_code from so_statictext within w_mat_receipt_issue_barcode_history_report
end type
type sle_receipt_slip_no from so_singlelineedit within w_mat_receipt_issue_barcode_history_report
end type
type st_9 from so_statictext within w_mat_receipt_issue_barcode_history_report
end type
type ddlb_receipt_type from uo_basecode within w_mat_receipt_issue_barcode_history_report
end type
type st_11 from so_statictext within w_mat_receipt_issue_barcode_history_report
end type
type sle_our_barcode from so_singlelineedit within w_mat_receipt_issue_barcode_history_report
end type
type st_1 from so_statictext within w_mat_receipt_issue_barcode_history_report
end type
type gb_where_condition from so_groupbox within w_mat_receipt_issue_barcode_history_report
end type
type gb_2 from so_groupbox within w_mat_receipt_issue_barcode_history_report
end type
end forward

global type w_mat_receipt_issue_barcode_history_report from w_main_root
integer width = 5330
integer height = 2736
string title = "Material  Slip Barcode  Report"
uo_dateset uo_dateset
uo_dateend uo_dateend
st_date st_date
sle_material_mfs sle_material_mfs
st_4 st_4
ddlb_item_code ddlb_item_code
st_item_code st_item_code
sle_receipt_slip_no sle_receipt_slip_no
st_9 st_9
ddlb_receipt_type ddlb_receipt_type
st_11 st_11
sle_our_barcode sle_our_barcode
st_1 st_1
gb_where_condition gb_where_condition
gb_2 gb_2
end type
global w_mat_receipt_issue_barcode_history_report w_mat_receipt_issue_barcode_history_report

on w_mat_receipt_issue_barcode_history_report.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_date=create st_date
this.sle_material_mfs=create sle_material_mfs
this.st_4=create st_4
this.ddlb_item_code=create ddlb_item_code
this.st_item_code=create st_item_code
this.sle_receipt_slip_no=create sle_receipt_slip_no
this.st_9=create st_9
this.ddlb_receipt_type=create ddlb_receipt_type
this.st_11=create st_11
this.sle_our_barcode=create sle_our_barcode
this.st_1=create st_1
this.gb_where_condition=create gb_where_condition
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.st_date
this.Control[iCurrent+4]=this.sle_material_mfs
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.ddlb_item_code
this.Control[iCurrent+7]=this.st_item_code
this.Control[iCurrent+8]=this.sle_receipt_slip_no
this.Control[iCurrent+9]=this.st_9
this.Control[iCurrent+10]=this.ddlb_receipt_type
this.Control[iCurrent+11]=this.st_11
this.Control[iCurrent+12]=this.sle_our_barcode
this.Control[iCurrent+13]=this.st_1
this.Control[iCurrent+14]=this.gb_where_condition
this.Control[iCurrent+15]=this.gb_2
end on

on w_mat_receipt_issue_barcode_history_report.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_date)
destroy(this.sle_material_mfs)
destroy(this.st_4)
destroy(this.ddlb_item_code)
destroy(this.st_item_code)
destroy(this.sle_receipt_slip_no)
destroy(this.st_9)
destroy(this.ddlb_receipt_type)
destroy(this.st_11)
destroy(this.sle_our_barcode)
destroy(this.st_1)
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
uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')
end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'

			dw_1.retrieve(  uo_dateset.text() , uo_dateend.text() , ddlb_item_code.text()+'%' , '%'+sle_material_mfs.text+'%'  , sle_receipt_slip_no.text+'%' ,  gvi_organization_id)
	
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_mat_receipt_issue_barcode_history_report
integer y = 336
integer width = 2377
integer height = 1396
boolean titlebar = true
string title = "LG Slip List"
end type

type dw_4 from w_main_root`dw_4 within w_mat_receipt_issue_barcode_history_report
integer y = 336
integer width = 2377
integer height = 1396
integer taborder = 20
boolean titlebar = true
end type

event dw_4::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_5.retrieve( uo_dateset.text() , this.object.item_code[currentrow])
end event

type dw_3 from w_main_root`dw_3 within w_mat_receipt_issue_barcode_history_report
integer y = 336
integer width = 2377
integer height = 1396
integer taborder = 30
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_mat_receipt_issue_barcode_history_report
integer y = 336
integer width = 2377
integer height = 1396
integer taborder = 40
boolean titlebar = true
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_receipt_issue_barcode_history_report
integer y = 336
integer width = 2377
integer height = 1396
integer taborder = 50
boolean titlebar = true
string title = "Material Receipt Barcode Report"
string dataobject = "d_mat_rcviss_barcode_rpt"
end type

type uo_tabpages from w_main_root`uo_tabpages within w_mat_receipt_issue_barcode_history_report
end type

type uo_dateset from uo_ymd_calendar within w_mat_receipt_issue_barcode_history_report
integer x = 32
integer y = 184
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_receipt_issue_barcode_history_report
integer x = 443
integer y = 184
integer taborder = 70
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_date from so_statictext within w_mat_receipt_issue_barcode_history_report
integer x = 37
integer y = 92
integer width = 814
boolean bringtotop = true
integer weight = 700
string text = "Date"
end type

type sle_material_mfs from so_singlelineedit within w_mat_receipt_issue_barcode_history_report
integer x = 1440
integer y = 180
integer width = 777
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

type st_4 from so_statictext within w_mat_receipt_issue_barcode_history_report
integer x = 1440
integer y = 96
integer width = 777
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Material MFS"
end type

type ddlb_item_code from uo_item_code within w_mat_receipt_issue_barcode_history_report
integer x = 859
integer y = 180
integer width = 558
integer taborder = 50
boolean bringtotop = true
end type

type st_item_code from so_statictext within w_mat_receipt_issue_barcode_history_report
integer x = 855
integer y = 96
integer width = 558
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type sle_receipt_slip_no from so_singlelineedit within w_mat_receipt_issue_barcode_history_report
integer x = 2226
integer y = 180
integer width = 608
integer height = 84
integer taborder = 80
boolean bringtotop = true
end type

type st_9 from so_statictext within w_mat_receipt_issue_barcode_history_report
integer x = 2226
integer y = 96
integer width = 608
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Slip No"
end type

type ddlb_receipt_type from uo_basecode within w_mat_receipt_issue_barcode_history_report
integer x = 2843
integer y = 180
integer width = 640
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw('RECEIPT TYPE')
end event

type st_11 from so_statictext within w_mat_receipt_issue_barcode_history_report
integer x = 2857
integer y = 96
integer width = 608
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Receipt Type"
end type

type sle_our_barcode from so_singlelineedit within w_mat_receipt_issue_barcode_history_report
integer x = 3570
integer y = 176
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
//=================================================
//
//=================================================

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

type st_1 from so_statictext within w_mat_receipt_issue_barcode_history_report
integer x = 3570
integer y = 108
integer width = 1006
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 255
string text = "Barcode"
end type

type gb_where_condition from so_groupbox within w_mat_receipt_issue_barcode_history_report
integer width = 3515
integer height = 320
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_mat_receipt_issue_barcode_history_report
integer x = 3529
integer width = 1093
integer height = 320
integer taborder = 70
end type


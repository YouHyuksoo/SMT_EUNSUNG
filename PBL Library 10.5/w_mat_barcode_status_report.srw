HA$PBExportHeader$w_mat_barcode_status_report.srw
$PBExportComments$Material Purchase Order Report
forward
global type w_mat_barcode_status_report from w_main_root
end type
type sle_material_mfs from so_singlelineedit within w_mat_barcode_status_report
end type
type st_4 from so_statictext within w_mat_barcode_status_report
end type
type ddlb_item_code from uo_item_code within w_mat_barcode_status_report
end type
type st_item_code from so_statictext within w_mat_barcode_status_report
end type
type sle_our_barcode from so_singlelineedit within w_mat_barcode_status_report
end type
type st_1 from so_statictext within w_mat_barcode_status_report
end type
type gb_where_condition from so_groupbox within w_mat_barcode_status_report
end type
end forward

global type w_mat_barcode_status_report from w_main_root
integer width = 5330
integer height = 2736
string title = "Material Barcode Status Query"
windowstate windowstate = maximized!
sle_material_mfs sle_material_mfs
st_4 st_4
ddlb_item_code ddlb_item_code
st_item_code st_item_code
sle_our_barcode sle_our_barcode
st_1 st_1
gb_where_condition gb_where_condition
end type
global w_mat_barcode_status_report w_mat_barcode_status_report

on w_mat_barcode_status_report.create
int iCurrent
call super::create
this.sle_material_mfs=create sle_material_mfs
this.st_4=create st_4
this.ddlb_item_code=create ddlb_item_code
this.st_item_code=create st_item_code
this.sle_our_barcode=create sle_our_barcode
this.st_1=create st_1
this.gb_where_condition=create gb_where_condition
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_material_mfs
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_item_code
this.Control[iCurrent+5]=this.sle_our_barcode
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.gb_where_condition
end on

on w_mat_barcode_status_report.destroy
call super::destroy
destroy(this.sle_material_mfs)
destroy(this.st_4)
destroy(this.ddlb_item_code)
destroy(this.st_item_code)
destroy(this.sle_our_barcode)
destroy(this.st_1)
destroy(this.gb_where_condition)
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
sle_our_barcode.setfocus( )
end event

event ue_data_control;call super::ue_data_control;long row
choose case gvs_ue_data_control
		
	case 'RETRIEVE'

			dw_1.retrieve(  ddlb_item_code.text()+'%' , '%'+sle_material_mfs.text+'%'  , gvi_organization_id)
	
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_mat_barcode_status_report
integer y = 340
integer width = 2377
integer height = 1396
boolean titlebar = true
end type

type dw_4 from w_main_root`dw_4 within w_mat_barcode_status_report
integer y = 340
integer width = 2377
integer height = 1396
integer taborder = 20
boolean titlebar = true
end type

event dw_4::doubleclicked;call super::doubleclicked;if row >= 1 then 
	
	openwithparm(w_mat_item_barcode_inventory_popup , string(this.object.item_code[this.getrow()]))
	
end if 	
end event

type dw_3 from w_main_root`dw_3 within w_mat_barcode_status_report
integer y = 340
integer width = 2377
integer height = 1396
integer taborder = 30
boolean titlebar = true
end type

type dw_2 from w_main_root`dw_2 within w_mat_barcode_status_report
integer y = 340
integer width = 2377
integer height = 1396
integer taborder = 40
boolean titlebar = true
string title = "Material Receipt Slip Report"
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_mat_barcode_status_report
integer y = 340
integer width = 3840
integer height = 1396
integer taborder = 50
boolean titlebar = true
string title = "Material Barcode Status"
string dataobject = "d_mat_rcviss_barcode_4_check_rpt"
end type

event dw_1::clicked;call super::clicked;sle_our_barcode.setfocus( )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_barcode_status_report
end type

type sle_material_mfs from so_singlelineedit within w_mat_barcode_status_report
integer x = 1650
integer y = 176
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

type st_4 from so_statictext within w_mat_barcode_status_report
integer x = 1650
integer y = 92
integer width = 777
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Material MFS"
end type

type ddlb_item_code from uo_item_code within w_mat_barcode_status_report
integer x = 1070
integer y = 176
integer width = 558
integer taborder = 50
boolean bringtotop = true
end type

type st_item_code from so_statictext within w_mat_barcode_status_report
integer x = 1065
integer y = 92
integer width = 558
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type sle_our_barcode from so_singlelineedit within w_mat_barcode_status_report
integer x = 46
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
		//st_msg.text =f_msg( "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'S')
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)	
		return
	end if 
ddlb_item_code.text = lvs_item_code
sle_material_mfs.text = lvs_lot_no
this.selecttext( 1,100)
f_retrieve()

end event

type st_1 from so_statictext within w_mat_barcode_status_report
integer x = 46
integer y = 104
integer width = 1006
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 255
string text = "Barcode"
end type

type gb_where_condition from so_groupbox within w_mat_barcode_status_report
integer x = 5
integer width = 2464
integer height = 320
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


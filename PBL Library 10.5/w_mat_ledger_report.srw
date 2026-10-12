HA$PBExportHeader$w_mat_ledger_report.srw
$PBExportComments$Material Ledger Report
forward
global type w_mat_ledger_report from w_main_root
end type
type st_3 from so_statictext within w_mat_ledger_report
end type
type ddlb_item_code from uo_item_code within w_mat_ledger_report
end type
type rb_master from so_radiobutton within w_mat_ledger_report
end type
type uo_dateset from uo_ymd_calendar within w_mat_ledger_report
end type
type st_2 from so_statictext within w_mat_ledger_report
end type
type uo_dateend from uo_ymd_calendar within w_mat_ledger_report
end type
type rb_barcode from so_radiobutton within w_mat_ledger_report
end type
type sle_material_mfs from so_singlelineedit within w_mat_ledger_report
end type
type ddlb_deficit from uo_basecode within w_mat_ledger_report
end type
type st_4 from so_statictext within w_mat_ledger_report
end type
type ddlb_line_code from uo_line_code within w_mat_ledger_report
end type
type st_5 from so_statictext within w_mat_ledger_report
end type
type st_6 from so_statictext within w_mat_ledger_report
end type
type ddlb_workstage_code from uo_workstage_code_all within w_mat_ledger_report
end type
type st_7 from so_statictext within w_mat_ledger_report
end type
type sle_receipt_slip_no from so_singlelineedit within w_mat_ledger_report
end type
type st_1 from so_statictext within w_mat_ledger_report
end type
type ddlb_lot_divide from uo_basecode within w_mat_ledger_report
end type
type st_8 from so_statictext within w_mat_ledger_report
end type
type ddlb_from_supplier_code from uo_supplier_code within w_mat_ledger_report
end type
type st_9 from so_statictext within w_mat_ledger_report
end type
type rb_line_inventory from so_radiobutton within w_mat_ledger_report
end type
type sle_model_name from so_singlelineedit within w_mat_ledger_report
end type
type st_10 from so_statictext within w_mat_ledger_report
end type
type sle_our_barcode from so_singlelineedit within w_mat_ledger_report
end type
type st_11 from so_statictext within w_mat_ledger_report
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_ledger_report
end type
type st_12 from so_statictext within w_mat_ledger_report
end type
type st_13 from so_statictext within w_mat_ledger_report
end type
type ddlb_location_code from uo_basecode within w_mat_ledger_report
end type
type ddlb_supplier_issue from uo_supplier_code within w_mat_ledger_report
end type
type st_14 from so_statictext within w_mat_ledger_report
end type
type st_15 from so_statictext within w_mat_ledger_report
end type
type ddlb_issue_deficit from uo_issue_deficit within w_mat_ledger_report
end type
type cbx_etc_line from so_checkbox within w_mat_ledger_report
end type
type rb_issue_loss from so_radiobutton within w_mat_ledger_report
end type
type st_16 from so_statictext within w_mat_ledger_report
end type
type ddlb_keyitem from dropdownlistbox within w_mat_ledger_report
end type
type st_17 from so_statictext within w_mat_ledger_report
end type
type ddlb_inventory_type from uo_basecode within w_mat_ledger_report
end type
type rb_1 from so_radiobutton within w_mat_ledger_report
end type
type cbx_w00 from checkbox within w_mat_ledger_report
end type
type gb_1 from so_groupbox within w_mat_ledger_report
end type
type gb_where_condition from so_groupbox within w_mat_ledger_report
end type
type gb_2 from so_groupbox within w_mat_ledger_report
end type
type gb_3 from so_groupbox within w_mat_ledger_report
end type
type gb_4 from so_groupbox within w_mat_ledger_report
end type
type gb_5 from so_groupbox within w_mat_ledger_report
end type
end forward

global type w_mat_ledger_report from w_main_root
integer width = 5810
integer height = 2736
string title = "Material Receipt Issue Ledger Report"
st_3 st_3
ddlb_item_code ddlb_item_code
rb_master rb_master
uo_dateset uo_dateset
st_2 st_2
uo_dateend uo_dateend
rb_barcode rb_barcode
sle_material_mfs sle_material_mfs
ddlb_deficit ddlb_deficit
st_4 st_4
ddlb_line_code ddlb_line_code
st_5 st_5
st_6 st_6
ddlb_workstage_code ddlb_workstage_code
st_7 st_7
sle_receipt_slip_no sle_receipt_slip_no
st_1 st_1
ddlb_lot_divide ddlb_lot_divide
st_8 st_8
ddlb_from_supplier_code ddlb_from_supplier_code
st_9 st_9
rb_line_inventory rb_line_inventory
sle_model_name sle_model_name
st_10 st_10
sle_our_barcode sle_our_barcode
st_11 st_11
ddlb_supplier_code ddlb_supplier_code
st_12 st_12
st_13 st_13
ddlb_location_code ddlb_location_code
ddlb_supplier_issue ddlb_supplier_issue
st_14 st_14
st_15 st_15
ddlb_issue_deficit ddlb_issue_deficit
cbx_etc_line cbx_etc_line
rb_issue_loss rb_issue_loss
st_16 st_16
ddlb_keyitem ddlb_keyitem
st_17 st_17
ddlb_inventory_type ddlb_inventory_type
rb_1 rb_1
cbx_w00 cbx_w00
gb_1 gb_1
gb_where_condition gb_where_condition
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
end type
global w_mat_ledger_report w_mat_ledger_report

type variables
string ivs_line_code[]
end variables

on w_mat_ledger_report.create
int iCurrent
call super::create
this.st_3=create st_3
this.ddlb_item_code=create ddlb_item_code
this.rb_master=create rb_master
this.uo_dateset=create uo_dateset
this.st_2=create st_2
this.uo_dateend=create uo_dateend
this.rb_barcode=create rb_barcode
this.sle_material_mfs=create sle_material_mfs
this.ddlb_deficit=create ddlb_deficit
this.st_4=create st_4
this.ddlb_line_code=create ddlb_line_code
this.st_5=create st_5
this.st_6=create st_6
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_7=create st_7
this.sle_receipt_slip_no=create sle_receipt_slip_no
this.st_1=create st_1
this.ddlb_lot_divide=create ddlb_lot_divide
this.st_8=create st_8
this.ddlb_from_supplier_code=create ddlb_from_supplier_code
this.st_9=create st_9
this.rb_line_inventory=create rb_line_inventory
this.sle_model_name=create sle_model_name
this.st_10=create st_10
this.sle_our_barcode=create sle_our_barcode
this.st_11=create st_11
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_12=create st_12
this.st_13=create st_13
this.ddlb_location_code=create ddlb_location_code
this.ddlb_supplier_issue=create ddlb_supplier_issue
this.st_14=create st_14
this.st_15=create st_15
this.ddlb_issue_deficit=create ddlb_issue_deficit
this.cbx_etc_line=create cbx_etc_line
this.rb_issue_loss=create rb_issue_loss
this.st_16=create st_16
this.ddlb_keyitem=create ddlb_keyitem
this.st_17=create st_17
this.ddlb_inventory_type=create ddlb_inventory_type
this.rb_1=create rb_1
this.cbx_w00=create cbx_w00
this.gb_1=create gb_1
this.gb_where_condition=create gb_where_condition
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.rb_master
this.Control[iCurrent+4]=this.uo_dateset
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.uo_dateend
this.Control[iCurrent+7]=this.rb_barcode
this.Control[iCurrent+8]=this.sle_material_mfs
this.Control[iCurrent+9]=this.ddlb_deficit
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.ddlb_line_code
this.Control[iCurrent+12]=this.st_5
this.Control[iCurrent+13]=this.st_6
this.Control[iCurrent+14]=this.ddlb_workstage_code
this.Control[iCurrent+15]=this.st_7
this.Control[iCurrent+16]=this.sle_receipt_slip_no
this.Control[iCurrent+17]=this.st_1
this.Control[iCurrent+18]=this.ddlb_lot_divide
this.Control[iCurrent+19]=this.st_8
this.Control[iCurrent+20]=this.ddlb_from_supplier_code
this.Control[iCurrent+21]=this.st_9
this.Control[iCurrent+22]=this.rb_line_inventory
this.Control[iCurrent+23]=this.sle_model_name
this.Control[iCurrent+24]=this.st_10
this.Control[iCurrent+25]=this.sle_our_barcode
this.Control[iCurrent+26]=this.st_11
this.Control[iCurrent+27]=this.ddlb_supplier_code
this.Control[iCurrent+28]=this.st_12
this.Control[iCurrent+29]=this.st_13
this.Control[iCurrent+30]=this.ddlb_location_code
this.Control[iCurrent+31]=this.ddlb_supplier_issue
this.Control[iCurrent+32]=this.st_14
this.Control[iCurrent+33]=this.st_15
this.Control[iCurrent+34]=this.ddlb_issue_deficit
this.Control[iCurrent+35]=this.cbx_etc_line
this.Control[iCurrent+36]=this.rb_issue_loss
this.Control[iCurrent+37]=this.st_16
this.Control[iCurrent+38]=this.ddlb_keyitem
this.Control[iCurrent+39]=this.st_17
this.Control[iCurrent+40]=this.ddlb_inventory_type
this.Control[iCurrent+41]=this.rb_1
this.Control[iCurrent+42]=this.cbx_w00
this.Control[iCurrent+43]=this.gb_1
this.Control[iCurrent+44]=this.gb_where_condition
this.Control[iCurrent+45]=this.gb_2
this.Control[iCurrent+46]=this.gb_3
this.Control[iCurrent+47]=this.gb_4
this.Control[iCurrent+48]=this.gb_5
end on

on w_mat_ledger_report.destroy
call super::destroy
destroy(this.st_3)
destroy(this.ddlb_item_code)
destroy(this.rb_master)
destroy(this.uo_dateset)
destroy(this.st_2)
destroy(this.uo_dateend)
destroy(this.rb_barcode)
destroy(this.sle_material_mfs)
destroy(this.ddlb_deficit)
destroy(this.st_4)
destroy(this.ddlb_line_code)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.ddlb_workstage_code)
destroy(this.st_7)
destroy(this.sle_receipt_slip_no)
destroy(this.st_1)
destroy(this.ddlb_lot_divide)
destroy(this.st_8)
destroy(this.ddlb_from_supplier_code)
destroy(this.st_9)
destroy(this.rb_line_inventory)
destroy(this.sle_model_name)
destroy(this.st_10)
destroy(this.sle_our_barcode)
destroy(this.st_11)
destroy(this.ddlb_supplier_code)
destroy(this.st_12)
destroy(this.st_13)
destroy(this.ddlb_location_code)
destroy(this.ddlb_supplier_issue)
destroy(this.st_14)
destroy(this.st_15)
destroy(this.ddlb_issue_deficit)
destroy(this.cbx_etc_line)
destroy(this.rb_issue_loss)
destroy(this.st_16)
destroy(this.ddlb_keyitem)
destroy(this.st_17)
destroy(this.ddlb_inventory_type)
destroy(this.rb_1)
destroy(this.cbx_w00)
destroy(this.gb_1)
destroy(this.gb_where_condition)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
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
ivs_line_code[1] = '%'


end event

event ue_data_control;call super::ue_data_control;
long   row
string lvs_item_code, lvs_w00_yn

lvs_item_code =  ddlb_item_code.text

if (  lvs_item_code = '' ) then
      lvs_item_code = '%'
end if

choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			if rb_master.checked = true then 
				
				if ( cbx_w00.checked = true ) then
					 lvs_w00_yn = 'Y'
				else
				     lvs_w00_yn = 'N'
				end if
				
				dw_1.retrieve( uo_dateset.text() , uo_dateend.text() , lvs_item_code,  sle_material_mfs.text+'%' , ddlb_line_code.getcode()+'%' , ddlb_workstage_code.getcode()+'%' , ddlb_deficit.getcode()+'%' ,ddlb_supplier_code.text+'%' ,  ddlb_from_supplier_code.text+'%' ,  ddlb_location_code.getcode()+'%'  ,  ddlb_supplier_issue.text+'%',  ddlb_issue_deficit.getcode()+'%' ,  ivs_line_code,  gvi_organization_id ,ddlb_keyitem.text+'%' ,ddlb_inventory_type.getcode()+'%' , lvs_w00_yn)
				
			elseif rb_barcode.checked = true then 

				dw_2.retrieve(  uo_dateset.text() , uo_dateend.text() , lvs_item_code, '%'+sle_material_mfs.text+'%'  , sle_receipt_slip_no.text+'%' ,  ddlb_lot_divide.getcode() + '%' , ddlb_supplier_code.text+'%' , gvi_organization_id, ddlb_keyitem.text )
			
		    elseif 	rb_line_inventory.checked = true then 
				
				dw_3.retrieve(lvs_item_code , sle_model_name.text+'%' ,ddlb_keyitem.text) 
				
			elseif rb_issue_loss.checked = true  then 
				
				dw_4.retrieve(  uo_dateset.text() , uo_dateend.text() ,ddlb_line_code.getcode()+'%' ,   '%' , lvs_item_code,  sle_material_mfs.text+'%' , gvi_organization_id, ddlb_keyitem.text)
				
			else
				
				dw_5.retrieve( uo_dateset.text() , uo_dateend.text() ,lvs_item_code ,  sle_material_mfs.text+'%' , ddlb_line_code.getcode()+'%' , ddlb_workstage_code.getcode()+'%' , ddlb_deficit.getcode()+'%' ,ddlb_supplier_code.text+'%' ,  ddlb_from_supplier_code.text+'%' ,  ddlb_location_code.getcode()+'%'  ,  ddlb_supplier_issue.text+'%',  ddlb_issue_deficit.getcode()+'%' ,  ivs_line_code,  gvi_organization_id ,ddlb_keyitem.text+'%' ,ddlb_inventory_type.getcode()+'%' )				
				
			end if 
			
	case else
end choose


end event

type dw_5 from w_main_root`dw_5 within w_mat_ledger_report
integer y = 772
integer width = 4137
integer height = 1508
boolean titlebar = true
string title = "WS Material Ledger Report"
string dataobject = "d_mat_ws_receipt_issue_rpt"
end type

type dw_4 from w_main_root`dw_4 within w_mat_ledger_report
integer y = 772
integer width = 3712
integer height = 1508
integer taborder = 30
boolean titlebar = true
string dataobject = "d_mat_item_issue_loss_lst"
end type

type dw_3 from w_main_root`dw_3 within w_mat_ledger_report
integer y = 772
integer width = 3712
integer height = 1508
integer taborder = 110
boolean titlebar = true
string dataobject = "d_mat_item_feeder_layout_detail_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_mat_ledger_report
integer y = 772
integer width = 3712
integer height = 1508
integer taborder = 190
boolean titlebar = true
string dataobject = "d_mat_receipt_barcode_rpt"
end type

type dw_1 from w_main_root`dw_1 within w_mat_ledger_report
integer y = 772
integer width = 4137
integer height = 1508
integer taborder = 230
boolean titlebar = true
string title = "Material Ledger Report"
string dataobject = "d_mat_daily_receipt_issue_rpt"
end type

event dw_1::doubleclicked;call super::doubleclicked;if row >= 1 then 
	if this.object.rcv_iss_code[this.getrow()] = 'I' then
		openwithparm(w_mat_smt_checkhist_popup , string(this.object.material_mfs[this.getrow()]))
	end if
	
end if 	
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_ledger_report
integer taborder = 40
end type

type st_3 from so_statictext within w_mat_ledger_report
integer x = 2382
integer y = 68
integer width = 576
integer height = 56
boolean bringtotop = true
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_ledger_report
integer x = 2382
integer y = 148
integer width = 576
integer taborder = 120
boolean bringtotop = true
end type

type rb_master from so_radiobutton within w_mat_ledger_report
integer x = 59
integer y = 72
integer width = 558
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Master"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window =dw_1

ddlb_location_code.enabled = True
end event

type uo_dateset from uo_ymd_calendar within w_mat_ledger_report
integer x = 731
integer y = 148
integer taborder = 250
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_2 from so_statictext within w_mat_ledger_report
integer x = 731
integer y = 76
integer width = 818
integer height = 56
boolean bringtotop = true
string text = "Date"
end type

type uo_dateend from uo_ymd_calendar within w_mat_ledger_report
integer x = 1161
integer y = 148
integer taborder = 260
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type rb_barcode from so_radiobutton within w_mat_ledger_report
integer x = 59
integer y = 140
integer width = 558
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Receipt Barcode"
end type

event clicked;call super::clicked;dw_2.bringtotop = true
selected_data_window =dw_2

ddlb_location_code.text = '%'
ddlb_location_code.enabled = False
end event

type sle_material_mfs from so_singlelineedit within w_mat_ledger_report
integer x = 2967
integer y = 152
integer height = 84
integer taborder = 130
boolean bringtotop = true
end type

type ddlb_deficit from uo_basecode within w_mat_ledger_report
integer x = 3474
integer y = 148
integer width = 411
integer height = 724
integer taborder = 270
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'RCV ISS CODE')
end event

type st_4 from so_statictext within w_mat_ledger_report
integer x = 2967
integer y = 68
integer height = 56
boolean bringtotop = true
string text = "Lot No"
end type

type ddlb_line_code from uo_line_code within w_mat_ledger_report
integer x = 558
integer y = 612
integer width = 434
integer height = 724
integer taborder = 280
boolean bringtotop = true
end type

type st_5 from so_statictext within w_mat_ledger_report
integer x = 3474
integer y = 68
integer width = 411
integer height = 56
boolean bringtotop = true
string text = "Rcv  Iss Code"
end type

type st_6 from so_statictext within w_mat_ledger_report
integer x = 553
integer y = 540
integer width = 434
integer height = 56
boolean bringtotop = true
string text = "Line Code"
end type

type ddlb_workstage_code from uo_workstage_code_all within w_mat_ledger_report
integer x = 1001
integer y = 612
integer width = 462
integer height = 724
integer taborder = 50
boolean bringtotop = true
end type

type st_7 from so_statictext within w_mat_ledger_report
integer x = 1001
integer y = 540
integer width = 462
integer height = 56
boolean bringtotop = true
string text = "Workstage Code"
end type

type sle_receipt_slip_no from so_singlelineedit within w_mat_ledger_report
integer x = 3374
integer y = 604
integer height = 84
integer taborder = 200
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mat_ledger_report
integer x = 3374
integer y = 528
integer height = 56
boolean bringtotop = true
string text = "Receipt Slip No"
end type

type ddlb_lot_divide from uo_basecode within w_mat_ledger_report
integer x = 3881
integer y = 600
integer width = 320
integer taborder = 60
boolean bringtotop = true
boolean allowedit = true
end type

type st_8 from so_statictext within w_mat_ledger_report
integer x = 3881
integer y = 524
integer width = 320
integer height = 56
boolean bringtotop = true
string text = "Lot Divide"
end type

type ddlb_from_supplier_code from uo_supplier_code within w_mat_ledger_report
integer x = 2834
integer y = 600
integer height = 1344
integer taborder = 70
boolean bringtotop = true
end type

type st_9 from so_statictext within w_mat_ledger_report
integer x = 2834
integer y = 528
integer width = 462
integer height = 56
boolean bringtotop = true
string text = "From SUpplier Code"
end type

type rb_line_inventory from so_radiobutton within w_mat_ledger_report
integer x = 59
integer y = 208
integer width = 558
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Line Inventory"
end type

event clicked;call super::clicked;dw_3.bringtotop = true
selected_data_window =dw_3

ddlb_location_code.text = '%'
ddlb_location_code.enabled = False
end event

type sle_model_name from so_singlelineedit within w_mat_ledger_report
integer x = 4265
integer y = 604
integer height = 84
integer taborder = 210
boolean bringtotop = true
end type

type st_10 from so_statictext within w_mat_ledger_report
integer x = 4265
integer y = 516
integer height = 56
boolean bringtotop = true
string text = "Model Name"
end type

type sle_our_barcode from so_singlelineedit within w_mat_ledger_report
integer x = 1591
integer y = 152
integer width = 777
integer height = 84
integer taborder = 220
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

end event

type st_11 from so_statictext within w_mat_ledger_report
integer x = 1591
integer y = 80
integer width = 777
integer height = 56
boolean bringtotop = true
long textcolor = 255
string text = "Barcode"
end type

type ddlb_supplier_code from uo_supplier_code within w_mat_ledger_report
integer x = 2363
integer y = 600
integer height = 1344
integer taborder = 140
boolean bringtotop = true
end type

type st_12 from so_statictext within w_mat_ledger_report
integer x = 2363
integer y = 528
integer width = 462
integer height = 56
boolean bringtotop = true
string text = "Supplier Code"
end type

type st_13 from so_statictext within w_mat_ledger_report
integer x = 3890
integer y = 68
integer width = 567
integer height = 76
boolean bringtotop = true
long textcolor = 0
string text = "Location Code"
end type

type ddlb_location_code from uo_basecode within w_mat_ledger_report
integer x = 3895
integer y = 148
integer width = 567
integer height = 1504
integer taborder = 240
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type ddlb_supplier_issue from uo_supplier_code within w_mat_ledger_report
integer x = 91
integer y = 612
integer height = 1344
integer taborder = 150
boolean bringtotop = true
integer weight = 400
boolean allowedit = false
end type

type st_14 from so_statictext within w_mat_ledger_report
integer x = 91
integer y = 540
integer width = 462
integer height = 56
boolean bringtotop = true
string text = "Supplier Code"
end type

type st_15 from so_statictext within w_mat_ledger_report
integer x = 1463
integer y = 540
integer width = 343
integer height = 56
boolean bringtotop = true
string text = "Issue Deficit"
end type

type ddlb_issue_deficit from uo_issue_deficit within w_mat_ledger_report
integer x = 1472
integer y = 612
integer width = 315
integer taborder = 160
boolean bringtotop = true
integer weight = 400
end type

type cbx_etc_line from so_checkbox within w_mat_ledger_report
integer x = 1847
integer y = 604
integer width = 430
integer height = 84
boolean bringtotop = true
integer textsize = -10
long textcolor = 255
string text = "Etc Line YN"
end type

event clicked;call super::clicked;string lvs_null[]
int      lvi_i, lvi_cnt

ivs_line_code[] =  lvs_null[]

if this.checked = true then
	
	 SELECT count(*)
	     INTO :lvi_cnt
		 FROM ip_product_line
	  WHERE  line_division = 'ETC' ;
	  
	declare cur_1 cursor for
	  
	  SELECT line_code
		 FROM ip_product_line
	  WHERE  line_division = 'ETC' ;
	 
	 open cur_1;
	 do while lvi_i <> lvi_cnt
	  lvi_i++	
	 fetch cur_1 into :ivs_line_code[lvi_i] ;
	  
	 loop
	 
	 close cur_1;
else
	ivs_line_code[1] = '%'
end if	 

end event

type rb_issue_loss from so_radiobutton within w_mat_ledger_report
integer x = 59
integer y = 276
integer width = 558
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Loss List"
end type

event clicked;call super::clicked;dw_4.bringtotop = true
selected_data_window =dw_4

ddlb_location_code.text = '%'
ddlb_location_code.enabled = False
end event

type st_16 from so_statictext within w_mat_ledger_report
integer x = 4485
integer y = 68
integer width = 251
integer height = 76
boolean bringtotop = true
long textcolor = 0
string text = "KeyItem"
end type

type ddlb_keyitem from dropdownlistbox within w_mat_ledger_report
integer x = 4475
integer y = 148
integer width = 274
integer height = 324
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string item[] = {"%","Y","N"}
borderstyle borderstyle = stylelowered!
end type

event constructor; THIS.Selectitem( 1)
end event

type st_17 from so_statictext within w_mat_ledger_report
integer x = 4768
integer y = 64
integer width = 471
integer height = 56
boolean bringtotop = true
long textcolor = 0
string text = "Inventory Type"
end type

type ddlb_inventory_type from uo_basecode within w_mat_ledger_report
integer x = 4768
integer y = 148
integer width = 471
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;THIS.REDRAW('INVENTORY TYPE')
end event

type rb_1 from so_radiobutton within w_mat_ledger_report
integer x = 59
integer y = 352
integer width = 558
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Workstage Ledger"
end type

event clicked;call super::clicked;dw_5.bringtotop = true
selected_data_window =dw_5

ddlb_location_code.text = '%'
ddlb_location_code.enabled = False
end event

type cbx_w00 from checkbox within w_mat_ledger_report
integer x = 5266
integer y = 156
integer width = 357
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 12632256
string text = "W00 $$HEX2$$ecd368d5$$ENDHEX$$"
boolean checked = true
end type

type gb_1 from so_groupbox within w_mat_ledger_report
integer x = 4242
integer y = 448
integer width = 553
integer height = 304
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Line Inventory"
end type

type gb_where_condition from so_groupbox within w_mat_ledger_report
integer x = 5
integer width = 645
integer height = 440
integer taborder = 170
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_ledger_report
integer x = 658
integer width = 5010
integer height = 440
integer taborder = 180
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_ledger_report
integer x = 5
integer y = 448
integer width = 2299
integer height = 304
integer taborder = 80
integer weight = 700
long textcolor = 16711680
string text = "Issue Condition"
end type

type gb_4 from so_groupbox within w_mat_ledger_report
integer x = 2313
integer y = 448
integer width = 1006
integer height = 308
integer taborder = 90
integer weight = 700
long textcolor = 16711680
string text = "Receipt Condition"
end type

type gb_5 from so_groupbox within w_mat_ledger_report
integer x = 3342
integer y = 448
integer width = 887
integer height = 304
integer taborder = 100
integer weight = 700
long textcolor = 16711680
string text = "Barcode Condition"
end type


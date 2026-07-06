HA$PBExportHeader$w_pln_product_defect.srw
$PBExportComments$$$HEX10$$88bdc9b7200018c2acb9e4c22000f1b45db82000$$ENDHEX$$/ $$HEX2$$85c7e0ac$$ENDHEX$$
forward
global type w_pln_product_defect from w_main_root
end type
type sle_pcb_serial_no from so_singlelineedit within w_pln_product_defect
end type
type st_2 from so_statictext within w_pln_product_defect
end type
type ddlb_line_code from uo_line_code within w_pln_product_defect
end type
type st_3 from so_statictext within w_pln_product_defect
end type
type uo_dateset from uo_ymd_calendar within w_pln_product_defect
end type
type st_5 from so_statictext within w_pln_product_defect
end type
type uo_dateend from uo_ymd_calendar within w_pln_product_defect
end type
type gb_2 from so_groupbox within w_pln_product_defect
end type
type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_defect
end type
type st_1 from so_statictext within w_pln_product_defect
end type
type ddlb_receipt_deficit from uo_basecode within w_pln_product_defect
end type
type st_7 from so_statictext within w_pln_product_defect
end type
type rb_magazine from so_radiobutton within w_pln_product_defect
end type
type ddlb_repair_result_code from uo_basecode within w_pln_product_defect
end type
type st_8 from so_statictext within w_pln_product_defect
end type
type ddlb_model_name from uo_set_model_name_ddlb within w_pln_product_defect
end type
type st_4 from so_statictext within w_pln_product_defect
end type
type ddlb_1 from uo_line_code within w_pln_product_defect
end type
type ddlb_2 from uo_workstage_code_all within w_pln_product_defect
end type
type sle_workstage_type from so_singlelineedit within w_pln_product_defect
end type
type st_9 from so_statictext within w_pln_product_defect
end type
type st_10 from so_statictext within w_pln_product_defect
end type
type st_11 from so_statictext within w_pln_product_defect
end type
type sle_runno from so_singlelineedit within w_pln_product_defect
end type
type st_6 from so_statictext within w_pln_product_defect
end type
type sle_model from so_singlelineedit within w_pln_product_defect
end type
type st_12 from so_statictext within w_pln_product_defect
end type
type sle_itemcode from so_singlelineedit within w_pln_product_defect
end type
type st_13 from so_statictext within w_pln_product_defect
end type
type sle_lot_qty from so_singlelineedit within w_pln_product_defect
end type
type st_14 from so_statictext within w_pln_product_defect
end type
type ddlb_defect_type from uo_basecode within w_pln_product_defect
end type
type st_15 from so_statictext within w_pln_product_defect
end type
type sle_pcb_week from so_singlelineedit within w_pln_product_defect
end type
type sle_product_week from so_singlelineedit within w_pln_product_defect
end type
type st_16 from so_statictext within w_pln_product_defect
end type
type st_17 from so_statictext within w_pln_product_defect
end type
type cb_1 from so_commandbutton within w_pln_product_defect
end type
type ddlb_bad_reason from uo_code_master within w_pln_product_defect
end type
type ddlb_fr_line from uo_line_code within w_pln_product_defect
end type
type ddlb_fr_workstage from uo_workstage_code_all within w_pln_product_defect
end type
type st_18 from so_statictext within w_pln_product_defect
end type
type st_19 from so_statictext within w_pln_product_defect
end type
type cb_receipt from commandbutton within w_pln_product_defect
end type
type sle_charger from so_singlelineedit within w_pln_product_defect
end type
type st_20 from so_statictext within w_pln_product_defect
end type
type mle_comment from so_multilineedit within w_pln_product_defect
end type
type st_message from so_statictext within w_pln_product_defect
end type
type gb_4 from so_groupbox within w_pln_product_defect
end type
type gb_6 from so_groupbox within w_pln_product_defect
end type
type gb_1 from so_groupbox within w_pln_product_defect
end type
type ln_1 from line within w_pln_product_defect
end type
end forward

global type w_pln_product_defect from w_main_root
integer width = 6569
integer height = 3720
string title = "WQC Magazine Defect Registry"
sle_pcb_serial_no sle_pcb_serial_no
st_2 st_2
ddlb_line_code ddlb_line_code
st_3 st_3
uo_dateset uo_dateset
st_5 st_5
uo_dateend uo_dateend
gb_2 gb_2
ddlb_workstage_code ddlb_workstage_code
st_1 st_1
ddlb_receipt_deficit ddlb_receipt_deficit
st_7 st_7
rb_magazine rb_magazine
ddlb_repair_result_code ddlb_repair_result_code
st_8 st_8
ddlb_model_name ddlb_model_name
st_4 st_4
ddlb_1 ddlb_1
ddlb_2 ddlb_2
sle_workstage_type sle_workstage_type
st_9 st_9
st_10 st_10
st_11 st_11
sle_runno sle_runno
st_6 st_6
sle_model sle_model
st_12 st_12
sle_itemcode sle_itemcode
st_13 st_13
sle_lot_qty sle_lot_qty
st_14 st_14
ddlb_defect_type ddlb_defect_type
st_15 st_15
sle_pcb_week sle_pcb_week
sle_product_week sle_product_week
st_16 st_16
st_17 st_17
cb_1 cb_1
ddlb_bad_reason ddlb_bad_reason
ddlb_fr_line ddlb_fr_line
ddlb_fr_workstage ddlb_fr_workstage
st_18 st_18
st_19 st_19
cb_receipt cb_receipt
sle_charger sle_charger
st_20 st_20
mle_comment mle_comment
st_message st_message
gb_4 gb_4
gb_6 gb_6
gb_1 gb_1
ln_1 ln_1
end type
global w_pln_product_defect w_pln_product_defect

type variables
Long Lvl_row
string ivs_line_code
string ivs_workstage_code
string ivs_type
string ivs_ws_io_flag
end variables

forward prototypes
public subroutine f_init_object ()
end prototypes

public subroutine f_init_object ();ddlb_fr_line.selectitem('' )
ddlb_fr_workstage.selectitem('')

sle_runno.text = ''
sle_model.text = ''
sle_itemcode.text = '' 
sle_lot_qty.text = '0'
end subroutine

on w_pln_product_defect.create
int iCurrent
call super::create
this.sle_pcb_serial_no=create sle_pcb_serial_no
this.st_2=create st_2
this.ddlb_line_code=create ddlb_line_code
this.st_3=create st_3
this.uo_dateset=create uo_dateset
this.st_5=create st_5
this.uo_dateend=create uo_dateend
this.gb_2=create gb_2
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_1=create st_1
this.ddlb_receipt_deficit=create ddlb_receipt_deficit
this.st_7=create st_7
this.rb_magazine=create rb_magazine
this.ddlb_repair_result_code=create ddlb_repair_result_code
this.st_8=create st_8
this.ddlb_model_name=create ddlb_model_name
this.st_4=create st_4
this.ddlb_1=create ddlb_1
this.ddlb_2=create ddlb_2
this.sle_workstage_type=create sle_workstage_type
this.st_9=create st_9
this.st_10=create st_10
this.st_11=create st_11
this.sle_runno=create sle_runno
this.st_6=create st_6
this.sle_model=create sle_model
this.st_12=create st_12
this.sle_itemcode=create sle_itemcode
this.st_13=create st_13
this.sle_lot_qty=create sle_lot_qty
this.st_14=create st_14
this.ddlb_defect_type=create ddlb_defect_type
this.st_15=create st_15
this.sle_pcb_week=create sle_pcb_week
this.sle_product_week=create sle_product_week
this.st_16=create st_16
this.st_17=create st_17
this.cb_1=create cb_1
this.ddlb_bad_reason=create ddlb_bad_reason
this.ddlb_fr_line=create ddlb_fr_line
this.ddlb_fr_workstage=create ddlb_fr_workstage
this.st_18=create st_18
this.st_19=create st_19
this.cb_receipt=create cb_receipt
this.sle_charger=create sle_charger
this.st_20=create st_20
this.mle_comment=create mle_comment
this.st_message=create st_message
this.gb_4=create gb_4
this.gb_6=create gb_6
this.gb_1=create gb_1
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_pcb_serial_no
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.ddlb_line_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.uo_dateset
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.uo_dateend
this.Control[iCurrent+8]=this.gb_2
this.Control[iCurrent+9]=this.ddlb_workstage_code
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.ddlb_receipt_deficit
this.Control[iCurrent+12]=this.st_7
this.Control[iCurrent+13]=this.rb_magazine
this.Control[iCurrent+14]=this.ddlb_repair_result_code
this.Control[iCurrent+15]=this.st_8
this.Control[iCurrent+16]=this.ddlb_model_name
this.Control[iCurrent+17]=this.st_4
this.Control[iCurrent+18]=this.ddlb_1
this.Control[iCurrent+19]=this.ddlb_2
this.Control[iCurrent+20]=this.sle_workstage_type
this.Control[iCurrent+21]=this.st_9
this.Control[iCurrent+22]=this.st_10
this.Control[iCurrent+23]=this.st_11
this.Control[iCurrent+24]=this.sle_runno
this.Control[iCurrent+25]=this.st_6
this.Control[iCurrent+26]=this.sle_model
this.Control[iCurrent+27]=this.st_12
this.Control[iCurrent+28]=this.sle_itemcode
this.Control[iCurrent+29]=this.st_13
this.Control[iCurrent+30]=this.sle_lot_qty
this.Control[iCurrent+31]=this.st_14
this.Control[iCurrent+32]=this.ddlb_defect_type
this.Control[iCurrent+33]=this.st_15
this.Control[iCurrent+34]=this.sle_pcb_week
this.Control[iCurrent+35]=this.sle_product_week
this.Control[iCurrent+36]=this.st_16
this.Control[iCurrent+37]=this.st_17
this.Control[iCurrent+38]=this.cb_1
this.Control[iCurrent+39]=this.ddlb_bad_reason
this.Control[iCurrent+40]=this.ddlb_fr_line
this.Control[iCurrent+41]=this.ddlb_fr_workstage
this.Control[iCurrent+42]=this.st_18
this.Control[iCurrent+43]=this.st_19
this.Control[iCurrent+44]=this.cb_receipt
this.Control[iCurrent+45]=this.sle_charger
this.Control[iCurrent+46]=this.st_20
this.Control[iCurrent+47]=this.mle_comment
this.Control[iCurrent+48]=this.st_message
this.Control[iCurrent+49]=this.gb_4
this.Control[iCurrent+50]=this.gb_6
this.Control[iCurrent+51]=this.gb_1
this.Control[iCurrent+52]=this.ln_1
end on

on w_pln_product_defect.destroy
call super::destroy
destroy(this.sle_pcb_serial_no)
destroy(this.st_2)
destroy(this.ddlb_line_code)
destroy(this.st_3)
destroy(this.uo_dateset)
destroy(this.st_5)
destroy(this.uo_dateend)
destroy(this.gb_2)
destroy(this.ddlb_workstage_code)
destroy(this.st_1)
destroy(this.ddlb_receipt_deficit)
destroy(this.st_7)
destroy(this.rb_magazine)
destroy(this.ddlb_repair_result_code)
destroy(this.st_8)
destroy(this.ddlb_model_name)
destroy(this.st_4)
destroy(this.ddlb_1)
destroy(this.ddlb_2)
destroy(this.sle_workstage_type)
destroy(this.st_9)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.sle_runno)
destroy(this.st_6)
destroy(this.sle_model)
destroy(this.st_12)
destroy(this.sle_itemcode)
destroy(this.st_13)
destroy(this.sle_lot_qty)
destroy(this.st_14)
destroy(this.ddlb_defect_type)
destroy(this.st_15)
destroy(this.sle_pcb_week)
destroy(this.sle_product_week)
destroy(this.st_16)
destroy(this.st_17)
destroy(this.cb_1)
destroy(this.ddlb_bad_reason)
destroy(this.ddlb_fr_line)
destroy(this.ddlb_fr_workstage)
destroy(this.st_18)
destroy(this.st_19)
destroy(this.cb_receipt)
destroy(this.sle_charger)
destroy(this.st_20)
destroy(this.mle_comment)
destroy(this.st_message)
destroy(this.gb_4)
destroy(this.gb_6)
destroy(this.gb_1)
destroy(this.ln_1)
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
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
*  Menu Property
*****************************************
* ADMIN  ( All Control )
* MANAGE ( Manager )
* GUEST  ( Only Query )
* QUERY  ( Only Query  )
* DATA_CONTROL  ( Insert Delete Update )
* REPORT ( Report )
****************************************/
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control




end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

sle_pcb_serial_no.setfocus()

end event

event ue_data_control;call super::ue_data_control;CHOOSE CASE Gvs_Ue_data_control
	CASE 'RETRIEVE'
		   
			//dw_3.reset()
		     dw_1.retrieve( sle_pcb_serial_no.text , gvi_organization_id )
		     //dw_2.retrieve( sle_pcb_serial_no.text , gvi_organization_id )
			//dw_3.RETRIEVE( ddlb_model_Name.getcode()+'%' ,  sle_pcb_serial_no.TEXT +'%' ,uo_dateset.text() , uo_dateend.text() , ddlb_receipt_deficit.getcode( )+'%' , '%' ,   ddlb_repair_result_code.getcode( )+'%' , GVI_ORGANIZATION_ID )

			sle_pcb_serial_no.setfocus()
				
//	CASE 'INSERT'
//		
//			if sle_pcb_serial_no.text = '' or isnull(sle_pcb_serial_no.text) or sle_pcb_serial_no.text = '%' then 
//				return 
//			end if 
//			Lvl_row = dw_1.insertrow(0)
//			dw_1.scrolltorow(Lvl_row)
//			f_set_security_row(dw_1 , Lvl_row , 'ALL')
//			F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
//			
//	CASE 'DELETE'
//		
//		  	if dw_1.getrow() < 1 then return 
//			  
//			msg =f_msgbox(1003)
//			if msg = 1 then
//				gvl_row_deleted = dw_1.getrow()			
//				dw_1.deleterow(gvl_row_deleted)		
//				dw_1.setfocus()
//				Lvl_row = dw_1.getrow()
//				dw_1.scrolltorow(Lvl_row)
//				dw_1.setcolumn(1)
//			end if
//
//			IF DW_1.UPDATE() < 0 THEN
//				ROLLBACK;	
//				sle_pcb_serial_no.setfocus()
//			ELSE
//				 COMMIT;
//					 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
//				sle_pcb_serial_no.setfocus()
//			END IF			
//			
//			sle_pcb_serial_no.setfocus()
//			dw_6.reset()
//	CASE 'UPDATE'
//		
//		 DW_1.ACCEPTTEXT()
// 
//	      IF DW_1.UPDATE() < 0 THEN
//				ROLLBACK;	
//				sle_pcb_serial_no.setfocus()
//		ELSE
//				 COMMIT;
//       			 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
//				sle_pcb_serial_no.setfocus()
//		END IF
//         
//		dw_6.reset()
	CASE ELSE
END CHOOSE
//
//
end event

event open;call super::open;//dw_6.settransobject(sqlca)
//f_set_column_dddw( dw_6 )
//
//dw_7.settransobject(sqlca)
//f_set_column_dddw( dw_7 )
end event

event resize;call super::resize;st_message.width = dw_1.width 
end event

type dw_5 from w_main_root`dw_5 within w_pln_product_defect
integer x = 1458
integer y = 884
integer width = 562
integer height = 908
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_pln_product_defect
integer x = 1458
integer y = 884
integer width = 562
integer height = 228
integer taborder = 0
end type

type dw_3 from w_main_root`dw_3 within w_pln_product_defect
integer x = 1458
integer y = 884
integer width = 562
integer height = 740
integer taborder = 0
boolean titlebar = true
string title = "Repair History"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_3::doubleclicked;call super::doubleclicked;//if row < 1 then return
//sle_pcb_serial_no.text = this.object.serial_no[row]
//sle_pcb_serial_no.selecttext( 1, 30) 
//f_retrieve()
end event

type dw_2 from w_main_root`dw_2 within w_pln_product_defect
integer x = 1458
integer y = 896
integer width = 562
integer height = 720
integer taborder = 0
boolean titlebar = true
string title = "Issue List"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean hsplitscroll = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

type dw_1 from w_main_root`dw_1 within w_pln_product_defect
integer x = 1234
integer y = 572
integer width = 4334
integer height = 1228
integer taborder = 0
boolean titlebar = true
string title = "Receipt List"
string dataobject = "d_temp_defect"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;lvl_row = currentrow
end event

type uo_tabpages from w_main_root`uo_tabpages within w_pln_product_defect
integer taborder = 0
end type

type sle_pcb_serial_no from so_singlelineedit within w_pln_product_defect
integer x = 407
integer y = 596
integer width = 768
integer taborder = 1
boolean bringtotop = true
integer textsize = -10
string text = "  "
textcase textcase = upper!
end type

event modified;call super::modified;string lvs_runno, lvs_itemcode, lvs_modelname, lvs_src_linecode, lvs_src_wscode, lvs_barcode, lvs_label_type, lvs_setbarcode
long lvl_lot_qty

/********************
* ws io $$HEX14$$7cb920001cbcddc0200060d5200083ac78c7c0c9200055d678c72000$$ENDHEX$$
*********************/
ivs_ws_io_flag = 'Y'


if this.text = '' then 
	f_msg('$$HEX10$$14bc54cfdcb47cb9200085c725b858d538c194c6$$ENDHEX$$', 'P')
	f_init_object()
	return 
end if 

lvs_barcode = this.text 
/*Magazine $$HEX25$$44c720007dc7b4c5200088bdc9b73cc75cb82000f1b45db81cb42000e4b970acc4c978c7c0c9200055d678c720005cd5e4b2$$ENDHEX$$.*/
 select RUN_NO, 
          ITEM_CODE, 
          MODEL_NAME, 
          //LINE_CODE, 
          //WORKSTAGE_CODE, 
          LAST_LINE_CODE, 
          LAST_WORKSTAGE_CODE, 
          LOT_QTY, 
          MAGAZINE_LABEL_TYPE, 
          MAGAZINE_SET_NO
    into :lvs_runno, 
	     :lvs_itemcode, 
		 :lvs_modelname, 
		 :lvs_src_linecode, :lvs_src_wscode , 
		 :lvl_lot_qty, 
		 :lvs_label_type, 
		 :lvs_setbarcode 
  from ip_product_run_card_io 
where  ORGANIZATION_ID = :gvi_organization_id 
	and MAGAZINE_LABEL_NO = :lvs_barcode ;   

if f_sql_check() < 0 then 
	return 
end if

if sqlca.sqlcode = 100 then 
	f_msg('$$HEX11$$14bc54cfdcb47cb9200055d678c7200058d538c194c6$$ENDHEX$$','P')
	this.text = '' 
	this.setfocus()
	f_init_object()
	return 
end if 


if lvs_label_type <> 'B' then 
	f_msg('$$HEX11$$88bdc9b720007cb7a8bc74c7200044c5d9b2c8b2e4b2$$ENDHEX$$. $$HEX18$$88bdc9b720007cb7a8bcccb9200018c2acb985c7e0ac200000aca5b2200069d5c8b2e4b2$$ENDHEX$$.' , 'P' ) 
	this.text = '' 
	this.setfocus()
	f_init_object()
	return 
end if 

/***************************************************
* Work Stage IO $$HEX24$$7cb9200055d678c7200058d5e0ac2000c8b9c0c9c9b92000f5ac15c8d0c51cc120009ccde0ac7cb92000dcc2a4d0e0ac$$ENDHEX$$
* $$HEX7$$18c2acb9e4c22000acc7e0ac2000$$ENDHEX$$( Model $$HEX20$$30ae00c93cc75cb82000ddc031c1200058d530ae200004c75cd5200000c944be7cb920005cd5e4b2$$ENDHEX$$. ) 
***************************************************/
select line_code, workstage_code 
into :lvs_src_linecode, :lvs_src_wscode 
from ip_product_workstage_io 
where organization_id = :gvi_organization_id 
and serial_no = :lvs_barcode
and io_deficit = 'I' ; 

//messagebox(lvs_src_linecode, lvs_src_wscode) 

if sqlca.sqlcode = 100 then 
	ivs_ws_io_flag= 'N' 
end if 

if f_sql_check() < 0 then 
	f_init_object()
	return 
end if 



ddlb_fr_line.selectitem(lvs_src_linecode )
ddlb_fr_workstage.selectitem(lvs_src_wscode)

sle_runno.text = lvs_runno
sle_model.text = lvs_modelname
sle_itemcode.text = lvs_itemcode 
sle_lot_qty.text = string(lvl_lot_qty)

end event

event getfocus;call super::getfocus;this.selecttext( 1,30)
end event

type st_2 from so_statictext within w_pln_product_defect
integer x = 18
integer y = 596
integer width = 375
boolean bringtotop = true
integer weight = 700
long textcolor = 65535
string text = "Barcode"
alignment alignment = right!
end type

type ddlb_line_code from uo_line_code within w_pln_product_defect
integer x = 2363
integer y = 188
integer width = 521
integer height = 1936
boolean bringtotop = true
long backcolor = 16777215
end type

type st_3 from so_statictext within w_pln_product_defect
integer x = 2363
integer y = 92
integer width = 512
boolean bringtotop = true
string text = "Line Code"
end type

type uo_dateset from uo_ymd_calendar within w_pln_product_defect
event destroy ( )
integer x = 3479
integer y = 184
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_5 from so_statictext within w_pln_product_defect
integer x = 3488
integer y = 92
integer width = 823
boolean bringtotop = true
string text = "Defect Date"
end type

type uo_dateend from uo_ymd_calendar within w_pln_product_defect
event destroy ( )
integer x = 3899
integer y = 184
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type gb_2 from so_groupbox within w_pln_product_defect
integer x = 1504
integer width = 3890
integer height = 396
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type ddlb_workstage_code from uo_workstage_code_all within w_pln_product_defect
integer x = 2889
integer y = 188
integer width = 585
integer height = 1936
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;SLE_PCB_SERIAL_NO.SETFOCUS( )    
end event

type st_1 from so_statictext within w_pln_product_defect
integer x = 2889
integer y = 92
integer width = 585
boolean bringtotop = true
long textcolor = 0
string text = "Workstage Code"
end type

type ddlb_receipt_deficit from uo_basecode within w_pln_product_defect
integer x = 4325
integer y = 188
integer width = 457
integer height = 508
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw("RECEIPT DEFICIT")
end event

type st_7 from so_statictext within w_pln_product_defect
integer x = 4325
integer y = 92
integer width = 457
boolean bringtotop = true
string text = "Receipt Deficit"
end type

type rb_magazine from so_radiobutton within w_pln_product_defect
integer x = 41
integer y = 84
integer width = 347
boolean bringtotop = true
string text = "Magazine"
boolean checked = true
end type

type ddlb_repair_result_code from uo_basecode within w_pln_product_defect
integer x = 4786
integer y = 184
integer width = 558
integer height = 1936
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'REPAIR RESULT CODE')
end event

type st_8 from so_statictext within w_pln_product_defect
integer x = 4786
integer y = 92
integer width = 558
boolean bringtotop = true
string text = "Repair Result Code"
end type

type ddlb_model_name from uo_set_model_name_ddlb within w_pln_product_defect
integer x = 1550
integer y = 188
integer height = 1936
boolean bringtotop = true
end type

type st_4 from so_statictext within w_pln_product_defect
integer x = 1554
integer y = 92
integer width = 809
boolean bringtotop = true
string text = "Model Name"
end type

type ddlb_1 from uo_line_code within w_pln_product_defect
integer x = 846
integer y = 96
integer width = 590
integer height = 1916
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;IVS_LINE_CODE = Profilestring("WORKENV.INI","LINE","WORKSTAGE_IO","")
THIS.SELECtitem(IVS_LINE_CODE )

end event

event selectionchanged;call super::selectionchanged;f_jsSetProfileString ("WORKENV.INI", "LINE", "WORKSTAGE_IO", THIS.GETCODE() )

IVS_LINE_CODE = THIS.GETCODE()
sle_pcb_serial_no.setfocus()

end event

type ddlb_2 from uo_workstage_code_all within w_pln_product_defect
integer x = 846
integer y = 188
integer width = 590
integer height = 1764
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;IVS_WORKSTAGE_CODE = Profilestring("WORKENV.INI","WORKSTAGE","WORKSTAGE_IO","")
THIS.SELECtitem(IVS_WORKSTAGE_CODE )

SELECT WORKSTAGE_TYPE INTO :IVS_TYPE 
  FROM IP_PRODUCT_WORKSTAGE
 WHERE WORKSTAGE_CODE = :IVS_WORKstage_code 
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		
IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 
		
sle_workstage_type.text  = IVS_TYPE
end event

event selectionchanged;call super::selectionchanged;//RegistrySet( "HKEY_LOCAL_MACHINE\Software\Infinity21\" +  GVS_APPLICATION_NAME, "IO_WORKSTAGE", RegString!,THIS.GETCODE())
//IVS_WORkstage_code = THIS.GETCODE()
//
//SELECT WORKSTAGE_TYPE INTO :IVS_TYPE 
//  FROM IP_PRODUCT_WORKSTAGE
// WHERE WORKSTAGE_CODE = :IVS_WORKstage_code 
//      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
//		
//IF F_SQL_CHECK() < 0 THEN 
//	RETURN 
//END IF 
//		
//sle_workstage_type.text  = IVS_TYPE
//
//sle_pcb_serial_no.setfocus()


f_jsSetProfileString ("WORKENV.INI", "WORKSTAGE", "WORKSTAGE_IO", THIS.GETCODE() )
IVS_WORkstage_code = THIS.GETCODE()

SELECT WORKSTAGE_TYPE INTO :IVS_TYPE 
  FROM IP_PRODUCT_WORKSTAGE
 WHERE WORKSTAGE_CODE = :IVS_WORKstage_code 
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		
IF F_SQL_CHECK() < 0 THEN 
	RETURN 
END IF 
		
sle_workstage_type.text  = IVS_TYPE

sle_pcb_serial_no.setfocus()


end event

type sle_workstage_type from so_singlelineedit within w_pln_product_defect
integer x = 846
integer y = 276
integer width = 256
integer height = 88
integer taborder = 30
boolean bringtotop = true
long backcolor = 134217750
boolean displayonly = true
end type

type st_9 from so_statictext within w_pln_product_defect
integer x = 530
integer y = 96
integer width = 293
boolean bringtotop = true
string text = "Line code"
alignment alignment = right!
end type

type st_10 from so_statictext within w_pln_product_defect
integer x = 530
integer y = 288
integer width = 302
boolean bringtotop = true
string text = "WS Type"
alignment alignment = right!
end type

type st_11 from so_statictext within w_pln_product_defect
integer x = 530
integer y = 188
integer width = 302
boolean bringtotop = true
string text = "WorkStage"
alignment alignment = right!
end type

type sle_runno from so_singlelineedit within w_pln_product_defect
integer x = 407
integer y = 900
integer width = 768
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
boolean enabled = false
end type

type st_6 from so_statictext within w_pln_product_defect
integer x = 18
integer y = 900
integer width = 375
boolean bringtotop = true
integer weight = 700
long textcolor = 8388608
string text = "Run No"
alignment alignment = right!
end type

type sle_model from so_singlelineedit within w_pln_product_defect
integer x = 407
integer y = 1000
integer width = 768
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
boolean enabled = false
end type

type st_12 from so_statictext within w_pln_product_defect
integer x = 18
integer y = 1000
integer width = 375
boolean bringtotop = true
integer weight = 700
long textcolor = 8388608
string text = "Model"
alignment alignment = right!
end type

type sle_itemcode from so_singlelineedit within w_pln_product_defect
integer x = 407
integer y = 1100
integer width = 768
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
boolean enabled = false
end type

type st_13 from so_statictext within w_pln_product_defect
integer x = 18
integer y = 1100
integer width = 375
boolean bringtotop = true
integer weight = 700
long textcolor = 8388608
string text = "Item Code"
alignment alignment = right!
end type

type sle_lot_qty from so_singlelineedit within w_pln_product_defect
integer x = 407
integer y = 1200
integer width = 768
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
boolean enabled = false
end type

type st_14 from so_statictext within w_pln_product_defect
integer x = 18
integer y = 1200
integer width = 375
boolean bringtotop = true
integer weight = 700
long textcolor = 8388608
string text = "Defect Qty"
alignment alignment = right!
end type

type ddlb_defect_type from uo_basecode within w_pln_product_defect
integer x = 407
integer y = 1300
integer width = 768
integer taborder = 60
boolean bringtotop = true
integer weight = 400
end type

event constructor;call super::constructor;redraw('DEFECT TYPE')
end event

type st_15 from so_statictext within w_pln_product_defect
integer x = 23
integer y = 1300
integer width = 375
boolean bringtotop = true
integer weight = 700
long textcolor = 8388608
string text = "Defect Type"
alignment alignment = right!
end type

type sle_pcb_week from so_singlelineedit within w_pln_product_defect
integer x = 407
integer y = 1404
integer width = 768
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
end type

type sle_product_week from so_singlelineedit within w_pln_product_defect
integer x = 407
integer y = 1508
integer width = 768
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
end type

type st_16 from so_statictext within w_pln_product_defect
integer x = 23
integer y = 1404
integer width = 375
boolean bringtotop = true
integer weight = 700
long textcolor = 65535
string text = "PCB Week"
alignment alignment = right!
end type

type st_17 from so_statictext within w_pln_product_defect
integer x = 23
integer y = 1504
integer width = 375
boolean bringtotop = true
integer weight = 700
long textcolor = 65535
string text = "Product Week"
alignment alignment = right!
end type

type cb_1 from so_commandbutton within w_pln_product_defect
integer x = 41
integer y = 1628
integer width = 361
integer height = 144
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string text = "Bad Reason Code"
end type

event clicked;call super::clicked;open(w_bad_reason_select_popup)

ddlb_bad_reason.text = Gst_return.gvs_return[1]

//if dw_1.getrow( ) < 1 then 
//	return 
//end if 
//
//if Gst_return.gvb_return = true then 
//
//	dw_1.object.bad_reason_code[Lvl_row]  = Gst_return.gvs_return[1]
//	dw_1.object.bad_qty[Lvl_row]  = Gst_return.gvl_return[1]
//	dw_1.object.defect_qty[Lvl_row]  = Gst_return.gvl_return[2]
//
//end if 

//sle_pcb_serial_no.text = ''
//sle_pcb_serial_no.setfocus()
end event

type ddlb_bad_reason from uo_code_master within w_pln_product_defect
integer x = 425
integer y = 1660
integer width = 741
integer taborder = 70
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw('WQC BAD REASON CODE')
end event

type ddlb_fr_line from uo_line_code within w_pln_product_defect
integer x = 407
integer y = 696
integer width = 768
integer height = 1916
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
end type

type ddlb_fr_workstage from uo_workstage_code_all within w_pln_product_defect
integer x = 407
integer y = 788
integer width = 768
integer height = 1764
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
end type

type st_18 from so_statictext within w_pln_product_defect
integer x = 18
integer y = 696
integer width = 375
boolean bringtotop = true
integer weight = 700
long textcolor = 8388608
string text = "From Line"
alignment alignment = right!
end type

type st_19 from so_statictext within w_pln_product_defect
integer x = 18
integer y = 784
integer width = 375
boolean bringtotop = true
integer weight = 700
long textcolor = 8388608
string text = "From W/S"
alignment alignment = right!
end type

type cb_receipt from commandbutton within w_pln_product_defect
integer x = 41
integer y = 2096
integer width = 1134
integer height = 168
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Receipt"
boolean default = true
end type

event clicked;/**********************************
* 1. $$HEX13$$e4b970acc4c920007cb7a8bc44c72000adc01cc820005cd5e4b2$$ENDHEX$$. 
* 2. $$HEX12$$e4b970acc4c920007cb7a8bc58c7200018c2c9b744c72000$$ENDHEX$$0 $$HEX5$$3cc75cb820005cd5e4b2$$ENDHEX$$.  ? 
* 3. $$HEX33$$7cc7e8b22000e4b970acc4c920007cb7a8bc40c7200090c144c7200000b3c0c920004ac594b2e4b220005ccd85c82000f5ac15c8ccb9200018c215c820005cd5e4b2$$ENDHEX$$. ? 
*
*     $$HEX31$$88bdc9b7ccb97cd0200094cd00ac5cb82000e4b970acc4c920001cbc89d574c7200044d594c6200058d574ba2000b4c5bbb58cac200058d5c0c994c62000$$ENDHEX$$? 
* 
* 1. $$HEX5$$f5ac15c874c7d9b32000$$ENDHEX$$( Workstage IO $$HEX2$$94b22000$$ENDHEX$$) $$HEX7$$5ccd85c82000f5ac15c8d0c52000$$ENDHEX$$IO_DEFICIT $$HEX2$$7cb92000$$ENDHEX$$'O' $$HEX5$$5cb8200058d5e0ac2000$$ENDHEX$$
*     DEST W/S $$HEX8$$7cb9200018c2acb95cb820005cd5e4b2$$ENDHEX$$. 
*     $$HEX42$$74d5f9b22000e4b970acc4c920007cb7a8bc40c7200018c2acb95cb82000e4b4b4c524c674ba200074c7c4d6d0c594b22000acc0a9c644c7200060d5200018c2200000ac2000c6c594b22000c1c0dcd074c7e4b2$$ENDHEX$$.
*     $$HEX24$$18c2acb9d0c51cc194b22000a8ba78b32000e8b204c75cb8200018c2c9b7ccb9200000adacb900ac20001cb4e4b22000$$ENDHEX$$
*     $$HEX8$$e8b22000ddc0b0c02000fcc828cc2000$$ENDHEX$$PCB $$HEX8$$fcc828cc2000c4bc200000adacb92000$$ENDHEX$$? $$HEX29$$44c5c8b274ba2000f8ade5b0200018c291c7c5c5200000adacb9200021c748c5200055d678c7200016bcd4c5200018b4c0c920004ac54cc72000$$ENDHEX$$
**********************************/
string lvs_charger, lvs_magazine_no, lvs_fr_line, lvs_fr_workstage, lvs_runno, lvs_model, lvs_itemcode, lvs_defect_type, lvs_pcb_week, lvs_product_week, lvs_bad_reason, lvs_comment
long lvl_lot_qty
long lvl_count   //check 

lvs_charger 			= sle_charger.text                  		//$$HEX4$$f4b2f9b290c72000$$ENDHEX$$
lvs_magazine_no 	= sle_pcb_serial_no.text         		//$$HEX7$$e4b970acc4c920007cb7a8bc2000$$ENDHEX$$
lvs_fr_line             = ddlb_fr_line.getcode()         		//$$HEX5$$5ccd85c87cb778c72000$$ENDHEX$$
lvs_fr_workstage   =ddlb_fr_workstage.getcode()     //$$HEX5$$5ccd85c8f5ac15c82000$$ENDHEX$$

lvs_runno 			= sle_runno.text                     //$$HEX4$$f0b788bc38d62000$$ENDHEX$$
lvs_model 			= sle_model.text                    //$$HEX3$$a8ba78b32000$$ENDHEX$$
lvs_itemcode 		= sle_itemcode.text                //$$HEX4$$44c574c75cd12000$$ENDHEX$$

lvl_lot_qty             = long(sle_lot_qty.text)           //$$HEX7$$e4b970acc4c9200018c2c9b72000$$ENDHEX$$
lvs_defect_type     = ddlb_defect_type.getcode()  //$$HEX3$$88bdc9b72000$$ENDHEX$$TYPE $$HEX6$$d0c6acc7ccb888bdc9b72000$$ENDHEX$$/ $$HEX5$$91c7c5c588bdc9b72000$$ENDHEX$$
lvs_pcb_week		= sle_pcb_week.text              //PCB $$HEX3$$fcc828cc2000$$ENDHEX$$
lvs_product_week	= sle_product_week.text        //$$HEX5$$ddc0b0c0fcc828cc2000$$ENDHEX$$

lvs_bad_reason		= ddlb_bad_reason.getcode() //$$HEX8$$88bdc9b72000d0c678c754cfdcb42000$$ENDHEX$$
lvs_comment		= mle_comment.text              //$$HEX4$$54cf58bab8d22000$$ENDHEX$$

/*******************************************************
* 1. $$HEX7$$44d518c212ac2000b4cc6cd02000$$ENDHEX$$
********************************************************/
if lvs_charger = '' then 
	f_msg('$$HEX11$$f4b2f9b290c77cb9200085c725b8200058d538c194c6$$ENDHEX$$','P') 
	st_message.text = f_msg('$$HEX10$$f9b2f9b290c77cb9200085c725b858d538c194c6$$ENDHEX$$','S')
	sle_charger.setfocus()
	return 
end if 

if lvs_magazine_no = '' then 
	f_msg('$$HEX11$$14bc54cfdcb47cb9200085c725b8200058d538c194c6$$ENDHEX$$','P')
	st_message.text = f_msg('$$HEX11$$14bc54cfdcb47cb9200085c725b8200058d538c194c6$$ENDHEX$$','S')
	sle_pcb_serial_no.setfocus()
	return
end if
/*******************************************************
* 2. $$HEX18$$74c7f8bb200085c7e0ac1cb42000e4b970acc4c9200078c7c0c9200055d678c720002000$$ENDHEX$$
********************************************************/
select count(*)
into :lvl_count 
from ip_product_defect 
where barcode_no		= :lvs_magazine_no
and organization_id = :gvi_organization_id 
; 
if f_sql_check() < 0 then
	sle_pcb_serial_no.text = '' 
	sle_pcb_serial_no.setfocus()
	return 
end if 

if lvl_count > 0 then
	f_msg('$$HEX17$$74c7f8bb200018c2acb9200085c7e0ac1cb42000e4b970acc4c9200085c7c8b2e4b2$$ENDHEX$$.','P') 
	st_message.text = f_msg('$$HEX17$$74c7f8bb200018c2acb9200085c7e0ac1cb42000e4b970acc4c9200085c7c8b2e4b2$$ENDHEX$$','S')
	sle_pcb_serial_no.text = '' 
	sle_pcb_serial_no.setfocus()
	return 
end if

/*******************************************************
* 3. $$HEX9$$18c2acb9e4c2200085c7e0ac20005cd5e4b2$$ENDHEX$$.
********************************************************/
INSERT INTO IP_PRODUCT_DEFECT ( 
	defect_no,                                            //$$HEX19$$e4b970acc4c9200088bc38d67cb9200088bdc9b7200088bc38d65cb82000acc0a9c668d52000$$ENDHEX$$
	defect_date,                          
	defect_type,
	line_code, 
	workstage_code, 
	source_line_code, 
	source_workstage_code, 
	barcode_no, 
	run_no, 
	run_date, 
	model_name, 
	item_code, 
	defect_qty, 
	repair_qty, 
	remain_qty, 

	defect_code, 
	receipt_charger, 
	product_week, 
	pcb_product_week, 
	status_flag, 
	//complain_no, 
	comments, 
	organization_id, 
	enter_date, 
	enter_by, 
	last_modify_date, 
	last_modify_by

)  values ( 
	:lvs_magazine_no         			//defect_no,   
	,trunc(sysdate)             		 	//defect_date, 
	,:lvs_defect_type		   			//defect_type, 
    ,:ivs_line_code                 	     //line_code,           $$HEX15$$04d6acc7200018c2acb9f5ac15c820007cb778c7200054cfdcb420002000$$ENDHEX$$
    ,:ivs_workstage_code            	//workstage_code, $$HEX10$$04d6acc7200018c2acb9f5ac15c8200054cfdcb4$$ENDHEX$$
    ,:lvs_fr_line			      			//source_line_code, $$HEX16$$74d5f9b22000e4b970acc4c974c72000c8b9c0c9c9b920007cb778c720002000$$ENDHEX$$
	,:lvs_fr_workstage			 		//source_workstage_code,  $$HEX15$$74d5f9b22000e4b970acc4c958c72000c8b9c0c9c9b92000f5ac15c82000$$ENDHEX$$
    
	,:lvs_magazine_no			         //barcode_no, $$HEX8$$e4b970acc4c9200088bc38d620002000$$ENDHEX$$
	,:lvs_runno		         	         //run_no, 
	,TRUNC(F_GET_RUN_DATE_BY_RUN_NO(:lvs_runno))       //run_date, 
	,:lvs_model       		   			//model_name, 
	,:lvs_itemcode		                  //item_code, 
	,:lvl_lot_qty    						//defect_qty, 
     ,0                                          //repair_qty, 
	,:lvl_lot_qty  		 					//remain_qty, 

	,:lvs_bad_reason					 //defect_code, 
    ,:lvs_charger	                      //receipt_charger, 
    ,:lvs_product_week	             //product_week, 
    ,:lvs_pcb_week                       //pcb_product_week, 
	, 'I'                                          //status_flag,   'I' $$HEX7$$85c7e0ac2000c1c0dcd020002000$$ENDHEX$$
//complain_no, 
	,:lvs_comment		                  	//comments, 
	,:gvi_organization_id                 //organization_id, 
	,sysdate                                   //enter_date, 
    , :lvs_charger		                   //enter_by, 
    , sysdate                                 //last_modify_date, 
	,:lvs_charger                   		//last_modify_by
) ; 


/*******************************************************
* 4. WorkStage IO $$HEX2$$15c8acb9$$ENDHEX$$
*     WS IO $$HEX21$$58c720005ccd85c82000f5ac15c844c720009ccde0ac2000c1c0dcd05cb82000c0bcbdac20005cd5e4b2$$ENDHEX$$. 
*     $$HEX3$$74d5f9b22000$$ENDHEX$$DEST $$HEX18$$f5ac15c844c7200004d6acc7200018c2acb92000f5ac15c83cc75cb8200014bcbcafe4b2$$ENDHEX$$.
********************************************************/	
if ivs_ws_io_flag = 'Y' then
	/*Work Stage IO $$HEX13$$d0c5200015c8acb960d5200015c8f4bc00ac200088c73cc774ba$$ENDHEX$$*/
	UPDATE IP_PRODUCT_WORKSTAGE_IO 
	SET io_deficit = 'O' 
			,dest_line_code = :ivs_line_code  
			,dest_workstage_code = :ivs_workstage_code 
			,out_date  = sysdate 
	WHERE organization_id = :gvi_organization_id 
	AND serial_no = :lvs_magazine_no
	AND IO_DEFICIT = 'I' 
	AND line_code = :lvs_fr_line
	AND workstage_code = :lvs_fr_workstage
	; 
	
	if f_sql_check() < 0 then
		sle_pcb_serial_no.text = '' 
		sle_pcb_serial_no.setfocus()
		return 
	end if 
end if 
/*******************************************************
* 4. RUNCARD IO ( $$HEX4$$e4b970acc4c92000$$ENDHEX$$master ) $$HEX5$$7cb9200015c8acb92000$$ENDHEX$$
*     $$HEX15$$e4b970acc4c92000adc01cc87cb9200074d57cc5200058d598b094c62000$$ENDHEX$$? 
*     $$HEX15$$e4b970acc4c940c72000b4c024b820006cb47cc5200058d598b094c62000$$ENDHEX$$? 
*     $$HEX9$$7cc7e8b220005ccd85c82000f5ac15c82000$$ENDHEX$$/ $$HEX14$$5ccd85c820007cb778c744c7200018c2acb9e4c25cb82000ccb9ecb4$$ENDHEX$$.
********************************************************/	
update ip_product_run_card_io 
set last_workstage_code = :ivs_workstage_code 
    ,last_line_code = :ivs_line_code 
where magazine_label_no = :lvs_magazine_no
and organization_id = :gvi_organization_id 
and run_no = :lvs_runno 
; 

if f_sql_check() < 0 then
	sle_pcb_serial_no.text = '' 
	sle_pcb_serial_no.setfocus()
	return 
end if 	 


commit ; 

st_message.text = f_msg('$$HEX10$$18c2acb93dcce0ac200085c7e0ac200044c6ccb8$$ENDHEX$$','S')
f_init_object()
end event

type sle_charger from so_singlelineedit within w_pln_product_defect
integer x = 407
integer y = 484
integer width = 768
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
end type

type st_20 from so_statictext within w_pln_product_defect
integer x = 18
integer y = 488
integer width = 375
boolean bringtotop = true
integer weight = 700
long textcolor = 255
string text = "Charger"
alignment alignment = right!
end type

type mle_comment from so_multilineedit within w_pln_product_defect
integer x = 46
integer y = 1780
integer width = 1129
integer height = 312
integer taborder = 80
boolean bringtotop = true
string text = "Comment"
boolean vscrollbar = true
integer limit = 200
end type

type st_message from so_statictext within w_pln_product_defect
integer x = 1234
integer y = 436
integer width = 4334
integer height = 116
boolean bringtotop = true
integer textsize = -14
long textcolor = 16777215
long backcolor = 0
string text = "Message"
end type

type gb_4 from so_groupbox within w_pln_product_defect
integer x = 5
integer width = 457
integer height = 388
integer weight = 700
string text = "Category"
end type

type gb_6 from so_groupbox within w_pln_product_defect
integer x = 475
integer width = 1015
integer height = 388
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Repair WorkStage"
end type

type gb_1 from so_groupbox within w_pln_product_defect
integer x = 9
integer y = 408
integer width = 1211
integer height = 1916
integer taborder = 10
integer weight = 700
string text = "Defect Reciept"
end type

type ln_1 from line within w_pln_product_defect
long linecolor = 33554432
integer linethickness = 4
integer beginx = 567
integer beginy = 92
integer endx = 896
integer endy = 268
end type


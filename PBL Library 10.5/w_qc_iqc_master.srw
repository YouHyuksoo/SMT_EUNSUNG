HA$PBExportHeader$w_qc_iqc_master.srw
$PBExportComments$$$HEX10$$5ccd85c87cb7a8bca4c294ce74c725b870c88cd6$$ENDHEX$$
forward
global type w_qc_iqc_master from w_main_root
end type
type sle_slip_no from so_singlelineedit within w_qc_iqc_master
end type
type st_2 from so_statictext within w_qc_iqc_master
end type
type rb_normal from so_radiobutton within w_qc_iqc_master
end type
type rb_cancel from so_radiobutton within w_qc_iqc_master
end type
type ddlb_item_code from uo_item_code within w_qc_iqc_master
end type
type st_9 from so_statictext within w_qc_iqc_master
end type
type uo_dateset from uo_ymd_calendar within w_qc_iqc_master
end type
type st_4 from so_statictext within w_qc_iqc_master
end type
type rb_1 from so_radiobutton within w_qc_iqc_master
end type
type uo_dateend from uo_ymd_calendar within w_qc_iqc_master
end type
type sle_lot_no from so_singlelineedit within w_qc_iqc_master
end type
type st_1 from so_statictext within w_qc_iqc_master
end type
type sle_item_name from so_singlelineedit within w_qc_iqc_master
end type
type st_3 from so_statictext within w_qc_iqc_master
end type
type sle_item_barcode from so_singlelineedit within w_qc_iqc_master
end type
type st_5 from so_statictext within w_qc_iqc_master
end type
type gb_3 from so_groupbox within w_qc_iqc_master
end type
type gb_1 from so_groupbox within w_qc_iqc_master
end type
end forward

global type w_qc_iqc_master from w_main_root
integer width = 5728
integer height = 3228
string title = "Material Receipt Barcode Master"
sle_slip_no sle_slip_no
st_2 st_2
rb_normal rb_normal
rb_cancel rb_cancel
ddlb_item_code ddlb_item_code
st_9 st_9
uo_dateset uo_dateset
st_4 st_4
rb_1 rb_1
uo_dateend uo_dateend
sle_lot_no sle_lot_no
st_1 st_1
sle_item_name sle_item_name
st_3 st_3
sle_item_barcode sle_item_barcode
st_5 st_5
gb_3 gb_3
gb_1 gb_1
end type
global w_qc_iqc_master w_qc_iqc_master

type variables

end variables

forward prototypes
public subroutine wf_receipt_barcode ()
end prototypes

public subroutine wf_receipt_barcode ();
end subroutine

on w_qc_iqc_master.create
int iCurrent
call super::create
this.sle_slip_no=create sle_slip_no
this.st_2=create st_2
this.rb_normal=create rb_normal
this.rb_cancel=create rb_cancel
this.ddlb_item_code=create ddlb_item_code
this.st_9=create st_9
this.uo_dateset=create uo_dateset
this.st_4=create st_4
this.rb_1=create rb_1
this.uo_dateend=create uo_dateend
this.sle_lot_no=create sle_lot_no
this.st_1=create st_1
this.sle_item_name=create sle_item_name
this.st_3=create st_3
this.sle_item_barcode=create sle_item_barcode
this.st_5=create st_5
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_slip_no
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.rb_normal
this.Control[iCurrent+4]=this.rb_cancel
this.Control[iCurrent+5]=this.ddlb_item_code
this.Control[iCurrent+6]=this.st_9
this.Control[iCurrent+7]=this.uo_dateset
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.rb_1
this.Control[iCurrent+10]=this.uo_dateend
this.Control[iCurrent+11]=this.sle_lot_no
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.sle_item_name
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.sle_item_barcode
this.Control[iCurrent+16]=this.st_5
this.Control[iCurrent+17]=this.gb_3
this.Control[iCurrent+18]=this.gb_1
end on

on w_qc_iqc_master.destroy
call super::destroy
destroy(this.sle_slip_no)
destroy(this.st_2)
destroy(this.rb_normal)
destroy(this.rb_cancel)
destroy(this.ddlb_item_code)
destroy(this.st_9)
destroy(this.uo_dateset)
destroy(this.st_4)
destroy(this.rb_1)
destroy(this.uo_dateend)
destroy(this.sle_lot_no)
destroy(this.st_1)
destroy(this.sle_item_name)
destroy(this.st_3)
destroy(this.sle_item_barcode)
destroy(this.st_5)
destroy(this.gb_3)
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
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default


 ivs_dw_2_retrice_cancel_popup_open = 'N'
 ivs_dw_3_retrice_cancel_popup_open = 'N'
 ivs_dw_4_retrice_cancel_popup_open = 'N'
 ivs_dw_5_retrice_cancel_popup_open = 'N'
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
F_MENU_CONTROL('DATA_CONTROL_MODIFY' , TRUE)  // All Data Control







end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
sle_slip_no.setfocus()
end event

event ue_data_control;call super::ue_data_control;choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		if rb_normal.checked = true then 
			dw_1.reset()
			dw_1.retrieve( uo_dateset.text() , uo_dateend.text() , ddlb_item_code.text()+'%' , sle_slip_no.text+'%' ,   'Y' ,  '%'+sle_item_name.text+'%' ,sle_item_barcode.text+'%' ,  gvi_organization_id)
			sle_slip_no.setfocus()
		elseif  rb_cancel.checked = true then 
			dw_2.reset()
			dw_2.retrieve(  uo_dateset.text() ,uo_dateend.text() , ddlb_item_code.text()+'%' ,  sle_slip_no.text+'%',  '%' , gvi_organization_id)
			sle_slip_no.setfocus()		
			
		else
			dw_3.reset()
			dw_3.retrieve(  uo_dateset.text() , uo_dateend.text() ,  ddlb_item_code.text()+'%' ,  sle_slip_no.text+'%',  gvi_organization_id)
			sle_slip_no.setfocus()					
		end if 
		
	case 'UPDATE'	
		
//----------------------------------------------------------------------------------------
// $$HEX7$$acc0a9c68cad5cd5200055d678c7$$ENDHEX$$
//----------------------------------------------------------------------------------------
             if gvi_user_level < 9 then
	
                f_msg("No have Authority, Check it Plz." , "P")
               return
	 
             end if				
		
			if dw_3.update( ) < 0 then 
				rollback;
			else
				commit ;
				f_msgbox(170)
			end if 
		
	case else
end choose

end event

event open;call super::open;sle_slip_no.setfocus()
end event

event clicked;call super::clicked;sle_slip_no.setfocus()
end event

type dw_5 from w_main_root`dw_5 within w_qc_iqc_master
integer y = 352
integer width = 2267
integer height = 752
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_qc_iqc_master
integer y = 352
integer width = 2267
integer height = 752
integer taborder = 0
boolean titlebar = true
end type

type dw_3 from w_main_root`dw_3 within w_qc_iqc_master
integer y = 352
integer width = 2267
integer height = 752
integer taborder = 0
boolean titlebar = true
string title = "IQC History"
string dataobject = "d_qc_iqc_lst"
end type

type dw_2 from w_main_root`dw_2 within w_qc_iqc_master
integer y = 352
integer width = 2267
integer height = 952
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_rceipt_barcode_4_iqc_cancel_lst"
borderstyle borderstyle = styleraised!
end type

event dw_2::buttonclicked;call super::buttonclicked;IF ROW < 1 THEN RETURN 

STRING LVS_RECEIPT_LOT_NO , LVS_INSPECT_RESULT , LVS_BAD_REASON_CODE


msg = f_msgbox1( 1161 , dwo.text ) 

if msg = 1 then 
else
	return 
end if 


IF dwo.name= 'b_cancel' then 
	
    LVS_RECEIPT_LOT_NO = THIS.OBJECT.RECEIPT_SLIP_NO[ROW]
	LVS_INSPECT_RESULT = 'W' //$$HEX3$$69d5a9ac2000$$ENDHEX$$
	LVS_BAD_REASON_CODE = 'WAIT'


//// $$HEX15$$88bd69d5a9ac200074c725b874c7200088c7e4b274ba2000adc01cc82000$$ENDHEX$$
// DELETE FROM IQ_ITEM_IQC WHERE IQC_INSPECT_NO = :LVS_RECEIPT_LOT_NO  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
//  IF F_SQL_CHECK() < 0 THEN 
//	 RETURN 
// END IF 
 

//===================================================
//  $$HEX12$$69d5a9ac40c7200030ae5db8200048c52000a8b040ae2000$$ENDHEX$$
//===================================================

		UPDATE  IM_ITEM_RECEIPT_BARCODE
				SET INSPECT_RESULT = :LVS_INSPECT_RESULT
		 WHERE RECEIPT_SLIP_NO = :LVS_RECEIPT_LOT_NO
				AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID 
			  AND INSPECT_RESULT IN ( 'P' , 'R')
			  AND RECEIPT_COMPARE_YN = 'N';
		  
		 IF F_SQL_CHECK() < 0 THEN 
			 RETURN 
		END IF 


		UPDATE  IM_ITEM_RECEIPT_SLIP
				SET INSPECT_RESULT = :LVS_INSPECT_RESULT
		 WHERE RECEIPT_SLIP_NO = :LVS_RECEIPT_LOT_NO
				AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
				
		 IF F_SQL_CHECK() < 0 THEN 
			 RETURN 
		END IF 

end if 

COMMIT ;

F_RETRIEVE()
sle_slip_no.setfocus()
end event

type dw_1 from w_main_root`dw_1 within w_qc_iqc_master
integer y = 352
integer width = 2267
integer height = 952
integer taborder = 0
boolean titlebar = true
string title = "Receipt Wait List"
string dataobject = "d_mat_rceipt_barcode_4_iqc_wait_lst"
end type

event dw_1::buttonclicked;call super::buttonclicked;IF ROW < 1 THEN RETURN 

STRING LVS_RECEIPT_LOT_NO , LVS_INSPECT_RESULT , LVS_BAD_REASON_CODE , LVS_SUPPLIER_CODE , LVS_ITEM_CODE


msg = f_msgbox1(1161 , dwo.text ) 

if msg = 1 then 
else
	return 
end if 

LVS_RECEIPT_LOT_NO = THIS.OBJECT.RECEIPT_SLIP_NO[ROW]
	
if dwo.name = 'b_esd_check' then 
	
	 LVS_SUPPLIER_CODE  = dw_1.object.supplier_code[dw_1.getrow()]
	 LVS_ITEM_CODE= dw_1.object.item_code[dw_1.getrow()]
	 
	     // $$HEX14$$58d6bdac200080acacc0200088d54cc73cc75cb820005cd4dcc22000$$ENDHEX$$
		dw_1.object.esd_check_cycle_value[dw_1.getrow()] = 0 
		dw_1.accepttext()
		
		update im_item_master set esd_check_cycle_value = 0 
		where supplier_code = :lvs_supplier_code
		and item_code = :lvs_item_code
		and organization_id  = :gvi_organization_id ;
		
		IF F_SQL_CHECK() < 0 THEN 
			RETURN 
		END IF 		
end if 
	
IF dwo.name= 'b_ok' then 
	
	//=========================================
	// $$HEX6$$58d6bdac200080acacc02000$$ENDHEX$$10 $$HEX15$$6fb8b8d2c8b9e4b2200048c558d574ba200000c8a5c7200088bd00ac2000$$ENDHEX$$
	//=========================================
	if dw_1.object.esd_check_cycle_value[dw_1.getrow()]  = 10 then 
		f_msg("$$HEX12$$58d6bdac200080acacc0200000b3c1c0200085c7c8b2e4b2$$ENDHEX$$" , "P")
		return 
	end if 
	
	LVS_INSPECT_RESULT = 'P' //$$HEX3$$69d5a9ac2000$$ENDHEX$$
	LVS_BAD_REASON_CODE = 'GOOD'
	
else
	
	open( w_bad_reason_select_4_iqc_popup)
	
	if Gst_return.gvb_return = true then 
		
		LVS_BAD_REASON_CODE =  Gst_return.gvs_return[1]
		LVS_INSPECT_RESULT = 'R'  //$$HEX4$$88bd69d5a9ac2000$$ENDHEX$$
	else
		return 
	end if 
	

			  INSERT INTO IQ_ITEM_IQC  
						( INSPECT_DATE,   
						  INSPECT_SEQUENCE,   
						  ORGANIZATION_ID,   
						  IQC_INSPECT_NO,   
						  DESTROY_QTY,   
						  SUPPLIER_CODE,   
						  MFS,   
						  ARRIVAL_QTY,   
						  INSPECT_LOT_QTY,   
						  INSPECT_BAD_LOT_QTY,   
						  INSPECT_QTY,   
						  INSPECT_BAD_QTY,   
						  INSPECT_RESULT,   
						  PRODUCT_DATE,   
						  DEPARTURE_DATE,   
						  ARRIVAL_DATE,   
						  INSPECT_BY,   
						  IQC_IMPROVE_NO,   
						  ARRIVAL_SEQ_NO,   
						  ENTER_DATE,   
						  DESTROY_REASON_CODE,   
						  ENTER_BY,   
						  LAST_MODIFY_DATE,   
						  LAST_MODIFY_BY,   
						  ITEM_CODE,   
						  COMMENTS,   
						  INSPECT_METHOD ,
					  BAD_REASON_CODE)
			
			SELECT SYSDATE  , //INSPECT_DATE,   
					SEQ_QC_IQC_INSPECT.NEXTVAL , //INSPECT_SEQUENCE,   
					ORGANIZATION_ID,   
					RECEIPT_SLIP_NO , //IQC_INSPECT_NO,   
					0 ,// DESTROY_QTY,   
					SUPPLIER_CODE,   
					ORIGIN_LOT_NO , //MFS,   
					SCAN_QTY , //ARRIVAL_QTY,   
					SCAN_QTY , //INSPECT_LOT_QTY,   
					0 , //INSPECT_BAD_LOT_QTY,   
					0 , //INSPECT_QTY,   
					0 , //INSPECT_BAD_QTY,   
					:LVS_INSPECT_RESULT , // INSPECT_RESULT,   
					NULL , //PRODUCT_DATE,   
					SYSDATE  , //DEPARTURE_DATE,   
					SYSDATE ,//ARRIVAL_DATE,   
					:gvs_user_id , //INSPECT_BY,   
					NULL , //IQC_IMPROVE_NO,   
					NULL , //ARRIVAL_SEQ_NO,   
					SYSDATE , //ENTER_DATE,   
					'*' , //DESTROY_REASON_CODE,   
					:GVS_USER_ID , //ENTER_BY,   
					SYSDATE , // LAST_MODIFY_DATE,   
					:GVS_USER_ID , //LAST_MODIFY_BY,   
					ITEM_CODE,   
					COMMENTS,   
					NULL, //INSPECT_METHOD
					:LVS_BAD_REASON_CODE
			 FROM IM_ITEM_RECEIPT_BARCODE
			 WHERE RECEIPT_SLIP_NO = :LVS_RECEIPT_LOT_NO
			  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
						  
			 IF F_SQL_CHECK() < 0 THEN 
				 RETURN 
			END IF 	

end if 
//===================================================
//  $$HEX12$$69d5a9ac40c7200030ae5db8200048c52000a8b040ae2000$$ENDHEX$$
//===================================================

UPDATE  IM_ITEM_RECEIPT_BARCODE
      SET INSPECT_RESULT  = :LVS_INSPECT_RESULT
 WHERE RECEIPT_SLIP_NO = :LVS_RECEIPT_LOT_NO
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
  
 IF F_SQL_CHECK() < 0 THEN 
	 RETURN 
END IF 

UPDATE  IM_ITEM_RECEIPT_SLIP
      SET INSPECT_RESULT  = :LVS_INSPECT_RESULT
 WHERE RECEIPT_SLIP_NO = :LVS_RECEIPT_LOT_NO
      AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
  
 IF F_SQL_CHECK() < 0 THEN 
	 RETURN 
END IF 

COMMIT ;

DW_1.RESET()
F_RETRIEVE()
sle_item_barcode.setfocus()
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF CURRENTROW < 1 THEN RETURN 

end event

type uo_tabpages from w_main_root`uo_tabpages within w_qc_iqc_master
integer taborder = 0
end type

type sle_slip_no from so_singlelineedit within w_qc_iqc_master
integer x = 2949
integer y = 164
integer width = 695
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
textcase textcase = upper!
end type

event modified;call super::modified;f_retrieve()
end event

event getfocus;call super::getfocus;this.selecttext(1,200)
end event

type st_2 from so_statictext within w_qc_iqc_master
integer x = 2953
integer y = 84
integer width = 695
integer height = 64
boolean bringtotop = true
long textcolor = 16711680
string text = "Receipt Slip No"
end type

type rb_normal from so_radiobutton within w_qc_iqc_master
integer x = 73
integer y = 100
boolean bringtotop = true
string text = "Normal"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
selected_data_window = dw_1

F_RETRIEVE()
end event

type rb_cancel from so_radiobutton within w_qc_iqc_master
integer x = 453
integer y = 100
integer width = 338
boolean bringtotop = true
string text = "Cancel"
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2

F_RETRIEVE()
end event

type ddlb_item_code from uo_item_code within w_qc_iqc_master
integer x = 1893
integer y = 168
integer width = 590
integer taborder = 30
boolean bringtotop = true
end type

type st_9 from so_statictext within w_qc_iqc_master
integer x = 1893
integer y = 84
integer width = 590
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type uo_dateset from uo_ymd_calendar within w_qc_iqc_master
event destroy ( )
integer x = 3653
integer y = 168
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_qc_iqc_master
integer x = 3657
integer y = 88
integer width = 841
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Date"
end type

type rb_1 from so_radiobutton within w_qc_iqc_master
integer x = 78
integer y = 216
boolean bringtotop = true
string text = "IQC History"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3

end event

type uo_dateend from uo_ymd_calendar within w_qc_iqc_master
event destroy ( )
integer x = 4082
integer y = 172
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type sle_lot_no from so_singlelineedit within w_qc_iqc_master
integer x = 2496
integer y = 164
integer width = 448
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
textcase textcase = upper!
end type

event modified;call super::modified;string lvs_lot_no


 select receipt_slip_no 
    into :lvs_lot_no 
   from im_item_receipt_barcode 
where lot_no = :lvs_lot_no
    and organization_id = :gvi_organization_id ;
	 

if f_sql_check() < 0 then 
	return 
end if


sle_slip_no.text = lvs_lot_no 


end event

type st_1 from so_statictext within w_qc_iqc_master
integer x = 2496
integer y = 84
integer width = 448
integer height = 64
boolean bringtotop = true
long textcolor = 0
string text = "Lot No"
end type

type sle_item_name from so_singlelineedit within w_qc_iqc_master
integer x = 4507
integer y = 164
integer width = 544
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
textcase textcase = upper!
end type

type st_3 from so_statictext within w_qc_iqc_master
integer x = 4512
integer y = 88
integer width = 544
integer height = 64
boolean bringtotop = true
long textcolor = 0
string text = "Item Name"
end type

type sle_item_barcode from so_singlelineedit within w_qc_iqc_master
integer x = 937
integer y = 168
integer width = 933
integer height = 92
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;f_retrieve()

this.setfocus()
this.selecttext(1 , 100)
end event

type st_5 from so_statictext within w_qc_iqc_master
integer x = 937
integer y = 84
integer width = 933
integer height = 64
boolean bringtotop = true
integer weight = 700
boolean italic = true
long textcolor = 16711680
string text = "Item Barcode"
end type

type gb_3 from so_groupbox within w_qc_iqc_master
integer x = 14
integer width = 841
integer height = 336
integer taborder = 50
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_1 from so_groupbox within w_qc_iqc_master
integer x = 873
integer width = 4219
integer height = 336
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Scan Receipt"
end type


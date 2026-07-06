HA$PBExportHeader$w_mat_barcode_check_master.srw
$PBExportComments$Material Mass Issue Return Master
forward
global type w_mat_barcode_check_master from w_main_root
end type
type st_status from so_statictext within w_mat_barcode_check_master
end type
type sle_our_barcode from so_singlelineedit within w_mat_barcode_check_master
end type
type st_2 from so_statictext within w_mat_barcode_check_master
end type
type em_yyyymm from uo_ym within w_mat_barcode_check_master
end type
type st_1 from so_statictext within w_mat_barcode_check_master
end type
type sle_our_barcode_cond from so_singlelineedit within w_mat_barcode_check_master
end type
type st_10 from so_statictext within w_mat_barcode_check_master
end type
type em_qty from editmask within w_mat_barcode_check_master
end type
type cbx_cancel from so_checkbox within w_mat_barcode_check_master
end type
type cbx_barcode_qty from so_checkbox within w_mat_barcode_check_master
end type
type pb_1 from so_commandbutton within w_mat_barcode_check_master
end type
type pb_2 from so_commandbutton within w_mat_barcode_check_master
end type
type pb_3 from so_commandbutton within w_mat_barcode_check_master
end type
type rb_list from so_radiobutton within w_mat_barcode_check_master
end type
type rb_2 from so_radiobutton within w_mat_barcode_check_master
end type
type pb_4 from so_commandbutton within w_mat_barcode_check_master
end type
type mle_1 from so_multilineedit within w_mat_barcode_check_master
end type
type gb_4 from so_groupbox within w_mat_barcode_check_master
end type
type gb_1 from so_groupbox within w_mat_barcode_check_master
end type
type gb_2 from so_groupbox within w_mat_barcode_check_master
end type
end forward

global type w_mat_barcode_check_master from w_main_root
integer width = 5518
integer height = 3228
string title = "Material Barcode Scan Check"
st_status st_status
sle_our_barcode sle_our_barcode
st_2 st_2
em_yyyymm em_yyyymm
st_1 st_1
sle_our_barcode_cond sle_our_barcode_cond
st_10 st_10
em_qty em_qty
cbx_cancel cbx_cancel
cbx_barcode_qty cbx_barcode_qty
pb_1 pb_1
pb_2 pb_2
pb_3 pb_3
rb_list rb_list
rb_2 rb_2
pb_4 pb_4
mle_1 mle_1
gb_4 gb_4
gb_1 gb_1
gb_2 gb_2
end type
global w_mat_barcode_check_master w_mat_barcode_check_master

type variables
LONG lvi_count ,  lvl_row , lvi_pos1 , lvi_pos2 , lvl_barcode_qty , lvl_inventory_qty  , lvl_receipt_sequence , lvl_receipt_qty
STRING lvs_item_barcode , lvs_yyyymm , lvs_item_code , lvs_lot_no , lvs_label_type , lvs_location_code
double  lvdb_receipt_lot_no
end variables

forward prototypes
public function integer wf_insert_barcode (string arg_type)
end prototypes

public function integer wf_insert_barcode (string arg_type);//===========================================
//
//===========================================
if arg_type = 'E' then 
	
         lvl_receipt_qty = Long(em_qty.text) 

		LVL_ROW = DW_2.INSERTROW(1)
		DW_2.SCROLLTOROW(LVL_ROW)
		F_SET_SECURITY_ROW(DW_2 , LVL_ROW ,'ALL')
		
		lvdb_receipt_lot_no = F_GET_SEQUENCE('SEQ_MATERIAL_BARCODE')
		
		dw_2.object.scan_date[LVL_ROW]            =  f_sysdate()
		dw_2.object.item_code[LVL_ROW]            = lvs_item_code //$$HEX5$$fcd3a9ba54cfdcb42000$$ENDHEX$$
		dw_2.object.lot_no[LVL_ROW]                  = lvs_lot_no  //$$HEX5$$6fb8b8d288bc38d62000$$ENDHEX$$
		
		dw_2.object.origin_lot_no[LVL_ROW]          = lvs_lot_no  //$$HEX5$$6fb8b8d288bc38d62000$$ENDHEX$$

		dw_2.object.receipt_slip_no[LVL_ROW]     =lvs_lot_no //$$HEX6$$acc2bdb9200088bc38d62000$$ENDHEX$$
		dw_2.object.receipt_compare_yn[lvl_row] = 'N' //$$HEX5$$44be50ad44c6ccb82000$$ENDHEX$$
		dw_2.object.barcode_status[lvl_row] = 'N' //$$HEX7$$44be50ad44c6ccb8200009000900$$ENDHEX$$
		dw_2.object.holding_yn[lvl_row] = 'N' //$$HEX7$$40d629b544c6ccb8200009000900$$ENDHEX$$
		
		dw_2.object.scan_qty[LVL_ROW]              = long(em_qty.text)
		dw_2.object.item_barcode[LVL_ROW]       =lvs_item_barcode// $$HEX9$$5ccd85c814bc54cfdcb42000090009000900$$ENDHEX$$
		
	     dw_2.object.receipt_type[lvl_row]           = 'N'  //$$HEX5$$85c7e0ac20c715d62000$$ENDHEX$$
	     dw_2.object.supplier_code[LVL_ROW]     = 'LGE'
		 dw_2.object.label_type[lvl_row]           = 'N'  //
	
//========================================================
//
//========================================================

		lvl_receipt_sequence = F_GET_SEQUENCE('SEQ_MAT_RECEIPT')
			
			INSERT INTO IM_ITEM_RECEIPT  
							( RECEIPT_SEQUENCE,   
							  RECEIPT_DATE,   
							  ORGANIZATION_ID,   
							  LOCATION_CODE,   
							  DELIVERY,   
							  RECEIPT_DEFICIT,   
							  LINE_TYPE,   
							  RECEIPT_QTY,   
							  MATERIAL_COST,   
							  UNIT_PRICE,   
							  MATERIAL_COST_AMT,   
							  ENTER_DATE,   
							  INVOICE_NO,   
							  RECEIPT_AMT,   
							  ENTER_BY,   
							  EXCHANGE_RATE,   
							  FOREIGN_RECEIPT_AMT,   
							  SUPPLIER_CODE,   
							  LAST_MODIFY_DATE,   
							  LAST_MODIFY_BY,   
							  CONFIRM_YN,   
							  CONFIRM_DATE,   
							  RECEIPT_TYPE,   
							  MFS,   
							  ARRIVAL_DATE,   
							  ARRIVAL_SEQ_NO,   
							  VIRTUAL_RECEIPT_YN,   
							  COMMENTS,   
							  WORK_ORDER_NO,   
							  CURRENCY,   
							  BARCODE,   
							  RECEIPT_STATUS,   
							  ITEM_CODE,   
							  MATERIAL_MFS,   
							  INTERFACE_YN,   
							  INTERFACE_DATE,   
							  RECEIPT_LOT_NO,   
							  RECEIPT_EXPENSE_COST,   
							  INCIDENTAL_EXPENSE_CODE,   
							  INTERFACE_WORK_NO,   
							  TARIFF_RATE,   
							  TARIFF_AMT,   
							  ORDER_NO,   
							  ORIGIN_MFS,   
							  ORIGIN_SUPPLIER_CODE,   
							  ORDER_TYPE,   
							  CONFIRM_BY,   
							  SUBCONTRACT_INVOICE_NO,   
							  INVOICE_OPEN_YN,   
							  INVOICE_OPEN_SEQUENCE,   
							  CLOSE_YN,   
							  CLOSE_DATE, FROM_SUPPLIER_CODE )  
							  
					 VALUES( :lvl_receipt_sequence ,      //RECEIPT_SEQUENCE,   
							  TRUNC(SYSDATE),      //RECEIPT_DATE,   
							  1,      //ORGANIZATION_ID,   
							   'M01',      //LOCATION_CODE,   
							  1,      //DELIVERY,   
							  1,      //RECEIPT_DEFICIT,   
							  F_GET_LINE_TYPE_FROM_ITEM( :lvs_item_code  , :gvi_organization_id ) ,      //LINE_TYPE,   
							  :lvl_receipt_qty ,      //RECEIPT_QTY,   
							  0,      //MATERIAL_COST,   
							  0 ,      //UNIT_PRICE,   
							  0,      //MATERIAL_COST_AMT,   
							  sysdate,      //ENTER_DATE,   
							  :lvs_lot_no ,      //INVOICE_NO,   
							  0 ,      //RECEIPT_AMT,   
							  :GVS_USER_ID ,      //ENTER_BY,   
							  1,      //EXCHANGE_RATE,   
							  0,      //FOREIGN_RECEIPT_AMT,   
							  'LGE'  ,      //SUPPLIER_CODE,   
							  SYSDATE,      //LAST_MODIFY_DATE,   
							  :GVS_USER_ID ,      //LAST_MODIFY_BY,   
							  'N',      //CONFIRM_YN,   
							  TRUNC(SYSDATE),      //CONFIRM_DATE,   
							  'N',      //RECEIPT_TYPE,   
							  'M01',      //MFS,   
							  NULL,      //ARRIVAL_DATE,   
							  0,      //ARRIVAL_SEQ_NO,   
							  'N',      //VIRTUAL_RECEIPT_YN,   
							  '*',      //COMMENTS,   
							  NULL,      //WORK_ORDER_NO,   
							  'WON',      //CURRENCY,   
							  :lvs_item_barcode,      //BARCODE,   
							  'N',      //RECEIPT_STATUS,   
							  :LVS_ITEM_CODE ,      //ITEM_CODE,   
							 :lvs_lot_no,      //MATERIAL_MFS,   
							  'N',      //INTERFACE_YN,   
							  NULL,      //INTERFACE_DATE,   
							  :lvl_receipt_sequence ,      //RECEIPT_LOT_NO,   
							  0,      //RECEIPT_EXPENSE_COST,   
							  '*',      //INCIDENTAL_EXPENSE_CODE,   
							  NULL,      //INTERFACE_WORK_NO,   
							  0,      //TARIFF_RATE,   
							  0,      //TARIFF_AMT,   
							  0,      //ORDER_NO,   
							  '*',      //ORIGIN_MFS,   
							  '*',      //ORIGIN_SUPPLIER_CODE,   
							  'M',      //ORDER_TYPE,   
							  :gvs_user_id,      //CONFIRM_BY,   
							  NULL,      //SUBCONTRACT_INVOICE_NO,   
							  'N',      //INVOICE_OPEN_YN,   
							  0,      //INVOICE_OPEN_SEQUENCE,   
							  'Y',      //CLOSE_YN,   
							  NULL,
							  'LGE')      //CLOSE_DATE
						  ;
						 
			 if  f_sql_check() < 0 then
				f_play_sound("scanfailed.wav")
				st_status.text = '$$HEX18$$85c7e0ac98ccacb9200011c9200024c658b900ac20001cbcddc0200088d5b5c2c8b2e4b2$$ENDHEX$$'
				return -1
			end if
else

end if 
//=============================================
//
//=============================================
            select inventory_qty , location_code
			 into :lvl_inventory_qty , :lvs_location_code
			from im_item_inventory
		  where item_code = :lvs_item_code
			  and material_mfs  = :lvs_lot_no
			  and location_code not in ( 'M02' , 'M04'  )
			  and inventory_qty > 0  ;
	//		  and location_code =  decode( :lvs_label_type , 'N' , 'M01' , 'R' , 'M06' , 'B' , 'M05' ); 
		
		if f_sql_check() < 0 then 
				f_play_sound("scanfailed.wav")
				st_status.text = '$$HEX20$$acc7e0ac200070c88cd6200011c92000200024c658b900ac20001cbcddc0200088d5b5c2c8b2e4b2$$ENDHEX$$'
				sle_our_barcode.text = ''
				sle_our_barcode.setfocus()
				return  -1
		end if 
	
		//==========================================
		//
		//==========================================
		
		 select count(*) into :lvi_count 
		  from IM_ITEM_INVENTORY_CHECK_BCD
		where check_yyyymm = :lvs_yyyymm
			 and item_code = :lvs_item_code
			  and lot_no      = :lvs_lot_no ; 
		
		if f_sql_check() < 0 then 
				f_play_sound("scanfailed.wav")
				st_status.text = '$$HEX21$$acc7e0ac80acacc0200098ccacb9200011c9200024c658b900ac20001cbcddc0200088d5b5c2c8b2e4b2$$ENDHEX$$'
				sle_our_barcode.text = ''
				sle_our_barcode.setfocus()
				return -1
		end if 
			
		if lvi_count > 0 then 
			f_play_sound("Eixst.wav")
			st_status.text = '$$HEX11$$74c7f8bb200098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$'
			sle_our_barcode.text = ''
			sle_our_barcode.setfocus()	
			rollback; 
			return -1
		else
			
					//===========================================
					//
					//===========================================
					
					f_insert()
					
					dw_1.object.item_barcode[lvl_row] = lvs_item_barcode
					dw_1.object.check_yyyymm[lvl_row] =lvs_yyyymm
					dw_1.object.barcode_qty[lvl_row] =lvl_barcode_qty
					dw_1.object.inventory_qty[lvl_row] =lvl_inventory_qty
					dw_1.object.location_code[lvl_row] =lvs_location_code
					
					if dw_1.update( ) < 0 or dw_2.update()  < 0 then 
						
							rollback;
							sle_our_barcode.text = ''
							sle_our_barcode.setfocus()	
							f_play_sound("scanfailed.wav")
							st_status.text = '$$HEX21$$acc7e0ac80acacc0200098ccacb9200011c9200024c658b900ac20001cbcddc0200088d5b5c2c8b2e4b2$$ENDHEX$$'
					else
							commit ;
							f_play_sound("kittingok.wav")
							st_status.text = '$$HEX10$$15c8c1c098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$'
							sle_our_barcode.text = ''
							sle_our_barcode.setfocus()
					end if 
		end if 
		

end function

on w_mat_barcode_check_master.create
int iCurrent
call super::create
this.st_status=create st_status
this.sle_our_barcode=create sle_our_barcode
this.st_2=create st_2
this.em_yyyymm=create em_yyyymm
this.st_1=create st_1
this.sle_our_barcode_cond=create sle_our_barcode_cond
this.st_10=create st_10
this.em_qty=create em_qty
this.cbx_cancel=create cbx_cancel
this.cbx_barcode_qty=create cbx_barcode_qty
this.pb_1=create pb_1
this.pb_2=create pb_2
this.pb_3=create pb_3
this.rb_list=create rb_list
this.rb_2=create rb_2
this.pb_4=create pb_4
this.mle_1=create mle_1
this.gb_4=create gb_4
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_status
this.Control[iCurrent+2]=this.sle_our_barcode
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_yyyymm
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.sle_our_barcode_cond
this.Control[iCurrent+7]=this.st_10
this.Control[iCurrent+8]=this.em_qty
this.Control[iCurrent+9]=this.cbx_cancel
this.Control[iCurrent+10]=this.cbx_barcode_qty
this.Control[iCurrent+11]=this.pb_1
this.Control[iCurrent+12]=this.pb_2
this.Control[iCurrent+13]=this.pb_3
this.Control[iCurrent+14]=this.rb_list
this.Control[iCurrent+15]=this.rb_2
this.Control[iCurrent+16]=this.pb_4
this.Control[iCurrent+17]=this.mle_1
this.Control[iCurrent+18]=this.gb_4
this.Control[iCurrent+19]=this.gb_1
this.Control[iCurrent+20]=this.gb_2
end on

on w_mat_barcode_check_master.destroy
call super::destroy
destroy(this.st_status)
destroy(this.sle_our_barcode)
destroy(this.st_2)
destroy(this.em_yyyymm)
destroy(this.st_1)
destroy(this.sle_our_barcode_cond)
destroy(this.st_10)
destroy(this.em_qty)
destroy(this.cbx_cancel)
destroy(this.cbx_barcode_qty)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.pb_3)
destroy(this.rb_list)
destroy(this.rb_2)
destroy(this.pb_4)
destroy(this.mle_1)
destroy(this.gb_4)
destroy(this.gb_1)
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
Ivs_resize_type                      = 'MASTER_DETAIL_145_23M'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control






end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
st_status.width = dw_1.width 
sle_our_barcode.setfocus()
end event

event ue_data_control;call super::ue_data_control;INT lvi_check_qty
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			if cbx_barcode_qty.checked = true then 
				
				lvi_check_qty = 0
			else
				lvi_check_qty = 1
			end if 
		
		if rb_list.checked = true then 
			dw_1.retrieve(  em_yyyymm.text , sle_our_barcode_cond.text+'%' , lvi_check_qty ,  gvi_organization_id)
			sle_our_barcode.setfocus()
		else
			dw_4.retrieve(  em_yyyymm.text , sle_our_barcode_cond.text+'%'  ,  gvi_organization_id)
			sle_our_barcode.setfocus()
		end if 
			
			
			
		case 'INSERT' 
			
			 lvl_row= DW_1.INSERTROW(1)
			DW_1.SCROLLTOROW(lvl_row)
			F_SET_SECURITY_ROW(DW_1 , lvl_row ,'ALL')
			
	case 'DELETE'
		
		  	if dw_1.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = dw_1.GetRow()			
				dw_1.DELETEROW(Gvl_row_deleted)		
				dw_1.SetFocus()
				lvl_row = dw_1.GetRow()
				dw_1.ScrollToRow(lvl_row)
				dw_1.SetColumn(1)
				
			END IF

	case 'UPDATE'
		
			IF dw_1.UPDATE() < 0  or dw_2.update() < 0 THEN
				 dw_1.RESET()
				 ROLLBACK;
				 RETURN				
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				// F_RETRIEVE()				 
			END IF

	case else
end choose

end event

event open;call super::open;sle_our_barcode.setfocus()
end event

event clicked;call super::clicked;sle_our_barcode.setfocus()
end event

event resize;call super::resize;st_status.width = dw_1.width
end event

type dw_5 from w_main_root`dw_5 within w_mat_barcode_check_master
integer y = 632
integer width = 2267
integer height = 752
integer taborder = 0
end type

type dw_4 from w_main_root`dw_4 within w_mat_barcode_check_master
integer y = 632
integer width = 4567
integer height = 752
integer taborder = 0
boolean titlebar = true
string title = "Summary"
string dataobject = "d_mat_inventory_barcode_check_sum_lst"
end type

type dw_3 from w_main_root`dw_3 within w_mat_barcode_check_master
integer x = 2546
integer y = 1392
integer width = 2267
integer height = 716
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_receipt_issue_4_check_barcode_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_mat_barcode_check_master
integer y = 1392
integer width = 2533
integer height = 716
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_rceipt_barcode_4_check_barcode_lst"
borderstyle borderstyle = styleraised!
end type

event dw_2::clicked;call super::clicked;sle_our_barcode.setfocus()
end event

type dw_1 from w_main_root`dw_1 within w_mat_barcode_check_master
integer y = 632
integer width = 4809
integer height = 752
integer taborder = 0
boolean titlebar = true
string title = "Receipt Wait List"
string dataobject = "d_mat_inventory_barcode_check_lst"
end type

event dw_1::clicked;call super::clicked;sle_our_barcode.setfocus()
end event

event dw_1::updatestart;//
end event

event dw_1::updateend;//
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return 
dw_2.retrieve( this.object.item_code[currentrow] , this.object.lot_no[currentrow] , gvi_organization_id )
dw_3.retrieve( this.object.item_code[currentrow] , this.object.lot_no[currentrow] , gvi_organization_id )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_barcode_check_master
integer taborder = 0
end type

type st_status from so_statictext within w_mat_barcode_check_master
integer width = 5440
integer height = 152
boolean bringtotop = true
integer textsize = -22
integer weight = 700
long textcolor = 65535
long backcolor = 16711680
string text = "Message"
end type

type sle_our_barcode from so_singlelineedit within w_mat_barcode_check_master
integer x = 2103
integer y = 332
integer width = 1426
integer height = 120
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext(1,200)
end event

event modified;call super::modified;lvs_item_barcode =  TRIM(this.text)
lvs_yyyymm = em_yyyymm.text
 st_status.text = ''
//==================================================
//
//==================================================

if len(lvs_item_barcode) < 10 then 
    f_play_sound("kittingfailed.wav")
    st_status.text = "$$HEX16$$fcd3a9ba88bc38d600ac20007cc758ce200058d5c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"
	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()
   return 
end if 

if cbx_cancel.checked = true then 
	
	delete from IM_ITEM_INVENTORY_CHECK_BCD 
	where item_barcode  = :lvs_item_barcode
	   and check_yyyymm = :lvs_yyyymm ;
	
	if f_sql_check() < 0 then 
			f_play_sound("")
			st_status.text = 'Cancel Error'
			sle_our_barcode.text = ''
			sle_our_barcode.setfocus()
			return 
	end if 
	
	commit ;
	f_play_sound("Kittingok.wav")
	st_status.text = 'Cacenl OK'
	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()	
	return 
	
end if 

//==================================================
//  $$HEX6$$88d4a9ba200054cfdcb42000$$ENDHEX$$
//  - $$HEX15$$6cad84bd90c700ac2000c6c53cc774ba200024c658b9200098ccacb92000$$ENDHEX$$
//==================================================
//lvi_pos1 =  pos(lvs_item_barcode , '-' , 7 ) 
//
//if  lvi_pos1 <= 0 then 
//	f_msgbox1(1175 ,lvs_item_barcode )
//	sle_our_barcode.text = ''
//	sle_our_barcode.setfocus()
//	return -1 
//end if 
SELECT  f_get_item_code_from_barcode (:lvs_item_barcode) 
	INTO :lvs_item_code
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 
	
	if  lvs_item_code = '' then 
		
		f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")
		f_msgbox1(1175 ,lvs_item_barcode )
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)
		return 
	end if 
//=================================================
//
//=================================================

//lvs_item_code = trim( mid( lvs_item_barcode , 1 ,  lvi_pos1 -1 ))

if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
	f_play_sound("barcodeno.wav")	
	f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$
	st_status.text =f_msg_st(9041)
	sle_our_barcode.text = ''
	sle_our_barcode.setfocus()
	return -1
end if 

//==================================================
// $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
//==================================================
//lvi_pos2 =  pos(lvs_item_barcode , '-' , lvi_pos1+1 )
//
//if  lvi_pos2 <= 0 then 
//	lvs_lot_no = trim( mid( lvs_item_barcode , lvi_pos1+1 ,  100 ))
//else
//	lvs_lot_no = trim( mid( lvs_item_barcode , lvi_pos1+1 ,   lvi_pos2 - lvi_pos1 -1 ))
//end if 
//
//if lvs_lot_no = ''  then 
//	st_status.text = "LOT NO INVALID"
//		sle_our_barcode.text = ''
//		sle_our_barcode.setfocus()	
//	return -1
//end if 
SELECT  F_GET_LOT_NO_FROM_BARCODE (:lvs_item_barcode ) 
	INTO :lvs_lot_no
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 

	if lvs_lot_no = ''  then 
		st_status.text =f_msg( "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'S')
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)	
		return
	end if 

//==========================================
//
//==========================================
lvi_count = 0 

 select count(*)  , sum(scan_qty)  ,max( nvl(label_type, 'N') )
   into :lvi_count  , :lvl_barcode_qty  , :lvs_label_type 
  from IM_ITEM_RECEIPT_BARCODE
where item_code = :lvs_item_code
    and lot_no = :lvs_lot_no ; 

if f_sql_check() < 0 then 
		f_play_sound("barcodeno.wav")
		st_status.text = '$$HEX26$$14bc54cfdcb42000ddc031c174c725b8200070c88cd6200011c92000200024c658b900ac20001cbcddc0200088d5b5c2c8b2e4b2$$ENDHEX$$'
		sle_our_barcode.text = ''
		sle_our_barcode.setfocus()
		return 
end if 
//==========================================
//
//==========================================
if lvi_count =  0 then 
	
	f_play_sound("barcodeno.wav")	
	st_status.text = '$$HEX24$$14bc54cfdcb42000ddc031c1200074c725b874c72000c6c54cc7200018c2c9b744c7200085c725b858d538c194c62000$$ENDHEX$$'	
	em_qty.setfocus()
	return 
else
	wf_insert_barcode('N')
end if

//===========================================
//
//===========================================

end event

type st_2 from so_statictext within w_mat_barcode_check_master
integer x = 645
integer y = 248
integer width = 343
integer height = 76
boolean bringtotop = true
long textcolor = 16711680
string text = "Check YYYYMM"
end type

type em_yyyymm from uo_ym within w_mat_barcode_check_master
integer x = 645
integer y = 328
integer width = 343
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
end type

type st_1 from so_statictext within w_mat_barcode_check_master
integer x = 2103
integer y = 224
integer width = 1426
integer height = 96
boolean bringtotop = true
integer textsize = -14
long textcolor = 16711680
string text = "Our Barcode"
end type

type sle_our_barcode_cond from so_singlelineedit within w_mat_barcode_check_master
integer x = 992
integer y = 328
integer width = 791
integer height = 88
integer taborder = 30
boolean bringtotop = true
end type

type st_10 from so_statictext within w_mat_barcode_check_master
integer x = 992
integer y = 244
integer width = 553
integer height = 72
boolean bringtotop = true
string text = "Our Barcode"
end type

type em_qty from editmask within w_mat_barcode_check_master
integer x = 3538
integer y = 332
integer width = 325
integer height = 120
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,###"
end type

event modified;wf_insert_barcode('E')
end event

type cbx_cancel from so_checkbox within w_mat_barcode_check_master
integer x = 2121
integer y = 244
integer height = 80
boolean bringtotop = true
string text = "Cancel"
end type

type cbx_barcode_qty from so_checkbox within w_mat_barcode_check_master
integer x = 1582
integer y = 232
integer height = 80
boolean bringtotop = true
string text = "Barcode Qty=0"
end type

type pb_1 from so_commandbutton within w_mat_barcode_check_master
integer x = 622
integer y = 492
integer height = 116
integer taborder = 10
boolean bringtotop = true
boolean enabled = false
string text = "Barcode Repair"
end type

event clicked;call super::clicked;long i 

do
	i++
	
	
	st_status.text = string(i) +'/'+string( dw_1.rowcount( ))
	if  long(dw_1.object.scan_qty[i]) = 0 or isnull( dw_1.object.scan_qty[i] ) then 
	else
		continue
	end if 
	
	lvs_item_barcode =  dw_1.object.item_barcode[i]
	lvs_item_code = dw_1.object.item_code[i]
	lvs_lot_no = dw_1.object.lot_no[i] 
	
	select count(*) into :lvi_count 
	 from im_item_receipt_barcode 
    where item_code = :lvs_item_code
	  and lot_no   = :lvs_lot_no ;	

	if 	lvi_count > 0 then 
		
		update im_item_receipt_barcode 
		      set item_barcode = :lvs_item_barcode , lot_no = :lvs_lot_no 
          where item_code = :lvs_item_code
	         and lot_no   = :lvs_lot_no ;	
		
	end if 

loop until i = dw_1.rowcount()
commit ;
end event

type pb_2 from so_commandbutton within w_mat_barcode_check_master
integer x = 1646
integer y = 492
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string text = "Barcode Create"
end type

event clicked;call super::clicked;long i 

do
	i++
		st_status.text = string(i) +'/'+string( dw_1.rowcount( ))
		if  long(dw_1.object.scan_qty[i]) = 0 or isnull( dw_1.object.scan_qty[i] ) then 
		else
			continue
		end if 
		
		if  long(dw_1.object.barcode_qty[i]) = 0 or isnull( long(dw_1.object.barcode_qty[i])) then 
			continue
		end if 

		lvs_item_barcode = dw_1.object.item_barcode[i]
		lvs_item_code = dw_1.object.item_code[i]
		lvs_lot_no = dw_1.object.lot_no[i]
		lvl_receipt_qty = long(dw_1.object.barcode_qty[i])
		
        //===================================================
	   //
	   //===================================================
		lvl_row = DW_2.INSERTROW(1)
		DW_2.SCROLLTOROW(lvl_row)
		F_SET_SECURITY_ROW(DW_2 , lvl_row ,'ALL')
		
		lvdb_receipt_lot_no = F_GET_SEQUENCE('SEQ_MATERIAL_BARCODE')
		
		dw_2.object.scan_date[lvl_row]            =  f_sysdate()
		dw_2.object.item_code[lvl_row]            = lvs_item_code //$$HEX5$$fcd3a9ba54cfdcb42000$$ENDHEX$$
		dw_2.object.lot_no[lvl_row]                  = lvs_lot_no  //$$HEX5$$6fb8b8d288bc38d62000$$ENDHEX$$
		
		dw_2.object.origin_lot_no[lvl_row]          = lvs_lot_no  //$$HEX5$$6fb8b8d288bc38d62000$$ENDHEX$$
		dw_2.object.receipt_slip_no[lvl_row]     =lvs_lot_no //$$HEX6$$acc2bdb9200088bc38d62000$$ENDHEX$$
		dw_2.object.receipt_compare_yn[lvl_row] = 'Y' //$$HEX5$$44be50ad44c6ccb82000$$ENDHEX$$
		dw_2.object.barcode_status[lvl_row]     = 'N' //$$HEX7$$44be50ad44c6ccb8200009000900$$ENDHEX$$
		dw_2.object.holding_yn[lvl_row]           = 'N' //$$HEX7$$40d629b544c6ccb8200009000900$$ENDHEX$$
		
		dw_2.object.scan_qty[lvl_row]              = lvl_receipt_qty
		dw_2.object.item_barcode[lvl_row]       =lvs_item_barcode// $$HEX9$$5ccd85c814bc54cfdcb42000090009000900$$ENDHEX$$
		
	     dw_2.object.receipt_type[lvl_row]       = 'N'  //$$HEX5$$85c7e0ac20c715d62000$$ENDHEX$$
	     dw_2.object.supplier_code[lvl_row]     = 'LGE'
		  
		dw_2.object.issue_compare_yn[lvl_row] = 'Y' //$$HEX8$$44be50ad44c6ccb82000090020002000$$ENDHEX$$
	
loop until i = dw_1.rowcount( )

msg = f_msgbox1(1161 , "save")

if msg = 1 then 
	
	if dw_2.update( ) < 0 then 
		rollback; 
	else
		commit ;
	end if 
end if 
end event

type pb_3 from so_commandbutton within w_mat_barcode_check_master
integer x = 1129
integer y = 492
integer height = 116
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string text = "Issue Repair"
end type

event clicked;call super::clicked;long i 

do
	i++
	
	
	st_status.text = string(i) +'/'+string( dw_1.rowcount( ))
//	if  long(dw_1.object.scan_qty[i]) = 0 or isnull( dw_1.object.scan_qty[i] ) then 
//	else
//		continue
//	end if 
	
	lvs_item_barcode =  dw_1.object.item_barcode[i]
	lvs_item_code = dw_1.object.item_code[i]
	lvs_lot_no = dw_1.object.lot_no[i] 
	
	select count(*) into :lvi_count 
	 from im_item_issue
    where item_code = :lvs_item_code
	  and  '00'||material_mfs   = :lvs_lot_no ;	
	  
	   if f_sql_check() < 0 then 
			continue 
		end if 
		
	if 	lvi_count > 0 then 
		
		update im_item_issue 
		      set  material_mfs = :lvs_lot_no 
          where item_code = :lvs_item_code
	         and '00'||material_mfs   = :lvs_lot_no ;	
				
	   if f_sql_check() < 0 then 
			continue 
		end if 
		
	end if 
commit ;
loop until i = dw_1.rowcount()

end event

type rb_list from so_radiobutton within w_mat_barcode_check_master
integer x = 64
integer y = 268
boolean bringtotop = true
string text = "Check List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop  = true
selected_data_window = dw_1
end event

type rb_2 from so_radiobutton within w_mat_barcode_check_master
integer x = 64
integer y = 356
boolean bringtotop = true
string text = "Check Summary"
end type

event clicked;call super::clicked;dw_4.bringtotop  = true
selected_data_window = dw_4
end event

type pb_4 from so_commandbutton within w_mat_barcode_check_master
integer x = 2158
integer y = 492
integer height = 116
integer taborder = 60
boolean bringtotop = true
string text = "Paste"
end type

event clicked;call super::clicked;dw_1.importclipboard( )
end event

type mle_1 from so_multilineedit within w_mat_barcode_check_master
integer x = 3918
integer y = 192
integer width = 1422
integer height = 280
integer taborder = 30
boolean bringtotop = true
string text = "1.$$HEX3$$88bdc9b72000$$ENDHEX$$/ $$HEX20$$acb9fcbc00aca5b200b330ae200094b22000e4c2acc0200000b3c1c074c7200044c5d9b2c8b2e4b2$$ENDHEX$$."
end type

type gb_4 from so_groupbox within w_mat_barcode_check_master
integer x = 2075
integer y = 172
integer width = 1824
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Scan Receipt"
end type

type gb_1 from so_groupbox within w_mat_barcode_check_master
integer x = 613
integer y = 172
integer width = 1458
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_mat_barcode_check_master
integer y = 184
integer width = 594
integer height = 280
integer taborder = 20
string text = "Category"
end type


HA$PBExportHeader$w_mat_receipt_barcode_reprint_master.srw
$PBExportComments$Material Mass Issue Return Master
forward
global type w_mat_receipt_barcode_reprint_master from w_main_root
end type
type ddlb_item_code from uo_item_code within w_mat_receipt_barcode_reprint_master
end type
type st_3 from so_statictext within w_mat_receipt_barcode_reprint_master
end type
type st_1 from so_statictext within w_mat_receipt_barcode_reprint_master
end type
type st_status from so_statictext within w_mat_receipt_barcode_reprint_master
end type
type sle_supplier_barcode from so_singlelineedit within w_mat_receipt_barcode_reprint_master
end type
type sle_slip_no_condition from so_singlelineedit within w_mat_receipt_barcode_reprint_master
end type
type st_9 from so_statictext within w_mat_receipt_barcode_reprint_master
end type
type rb_tray from so_radiobutton within w_mat_receipt_barcode_reprint_master
end type
type rb_reel from so_radiobutton within w_mat_receipt_barcode_reprint_master
end type
type ddlb_receipt_type from uo_basecode within w_mat_receipt_barcode_reprint_master
end type
type st_2 from so_statictext within w_mat_receipt_barcode_reprint_master
end type
type rb_reel_count from so_radiobutton within w_mat_receipt_barcode_reprint_master
end type
type em_count from so_editmask within w_mat_receipt_barcode_reprint_master
end type
type st_4 from so_statictext within w_mat_receipt_barcode_reprint_master
end type
type sle_our_barcode from so_singlelineedit within w_mat_receipt_barcode_reprint_master
end type
type st_6 from so_statictext within w_mat_receipt_barcode_reprint_master
end type
type sle_lot_no from so_singlelineedit within w_mat_receipt_barcode_reprint_master
end type
type st_7 from so_statictext within w_mat_receipt_barcode_reprint_master
end type
type rb_rebuild_reball from so_radiobutton within w_mat_receipt_barcode_reprint_master
end type
type rb_rebuild_bulk from so_radiobutton within w_mat_receipt_barcode_reprint_master
end type
type pb_2 from so_commandbutton within w_mat_receipt_barcode_reprint_master
end type
type cbx_auto_print from so_checkbox within w_mat_receipt_barcode_reprint_master
end type
type cbx_msl from so_checkbox within w_mat_receipt_barcode_reprint_master
end type
type gb_3 from so_groupbox within w_mat_receipt_barcode_reprint_master
end type
type gb_4 from so_groupbox within w_mat_receipt_barcode_reprint_master
end type
type gb_2 from so_groupbox within w_mat_receipt_barcode_reprint_master
end type
type gb_5 from so_groupbox within w_mat_receipt_barcode_reprint_master
end type
type gb_6 from so_groupbox within w_mat_receipt_barcode_reprint_master
end type
end forward

global type w_mat_receipt_barcode_reprint_master from w_main_root
integer width = 5303
integer height = 3100
string title = "Material Barcode Reprint"
string ivs_dw_2_retrice_cancel_popup_open = "N"
string ivs_dw_3_retrice_cancel_popup_open = "N"
string ivs_dw_4_retrice_cancel_popup_open = "N"
string ivs_dw_5_retrice_cancel_popup_open = "N"
ddlb_item_code ddlb_item_code
st_3 st_3
st_1 st_1
st_status st_status
sle_supplier_barcode sle_supplier_barcode
sle_slip_no_condition sle_slip_no_condition
st_9 st_9
rb_tray rb_tray
rb_reel rb_reel
ddlb_receipt_type ddlb_receipt_type
st_2 st_2
rb_reel_count rb_reel_count
em_count em_count
st_4 st_4
sle_our_barcode sle_our_barcode
st_6 st_6
sle_lot_no sle_lot_no
st_7 st_7
rb_rebuild_reball rb_rebuild_reball
rb_rebuild_bulk rb_rebuild_bulk
pb_2 pb_2
cbx_auto_print cbx_auto_print
cbx_msl cbx_msl
gb_3 gb_3
gb_4 gb_4
gb_2 gb_2
gb_5 gb_5
gb_6 gb_6
end type
global w_mat_receipt_barcode_reprint_master w_mat_receipt_barcode_reprint_master

type variables
long lvl_qty , lvl_receipt_qty , lvl_issue_qty , LVL_ROW
string lvs_mfs ,   lvs_lot_no , lvs_supplier_barcode , lvs_our_barcode , lvs_item_code , lvs_location_code , lvs_slip_no , lvs_label_type , lvs_item_barcode , lvs_line_code
int     lvi_pos1 , lvi_pos2  , lvi_pos_check
datetime lvdt_issue_date
double lvdb_issue_sequence

end variables

forward prototypes
public function integer wf_issue_return ()
end prototypes

public function integer wf_issue_return ();if long(em_count.text) = 0 or isnull(em_count.text) then
   return -1 -1 
else
	lvl_qty = long(em_count.text)
end if 
//==============================================
//
//==============================================

lvs_our_barcode = sle_our_barcode.text

//==================================================
//  $$HEX6$$88d4a9ba200054cfdcb42000$$ENDHEX$$
//==================================================
//lvi_pos1 =  pos(lvs_our_barcode , '-' , 7 ) 
//
//if  lvi_pos1 <= 0 then 
//	f_msgbox1(1175 ,lvs_our_barcode )
//	sle_our_barcode.setfocus()
//	sle_our_barcode.selecttext( 1,100)
//	return -1 -1 
//end if 
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
		return -1
	end if 
	
if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
	f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")	
	f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$
	sle_our_barcode.setfocus()
	sle_our_barcode.selecttext( 1,100)	
end if 

//==================================================
// $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
//==================================================
//lvi_pos2 =  pos(lvs_our_barcode , '-' , lvi_pos1+1 ) 
//
//if  lvi_pos2 <= 0 then 
//	f_msgbox1(1175 ,lvs_our_barcode )
//	sle_our_barcode.setfocus()
//	sle_our_barcode.selecttext( 1,100)
//	return -1 -1 
//end if 

//==================================================
//
//==================================================
//lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,   lvi_pos2 - lvi_pos1 -1 ))
//if lvs_lot_no = ''  then 
//	st_status.text = "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"
//	sle_our_barcode.setfocus()
//	sle_our_barcode.selecttext( 1,100)	
//	return -1 -1
//end if 
SELECT  F_GET_LOT_NO_FROM_BARCODE (:lvs_our_barcode ) 
	INTO :lvs_lot_no
	FROM DUAL ; 
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 

	if lvs_lot_no = ''  then 
		st_status.text =f_msg( "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$",'S')
		sle_our_barcode.setfocus()
		sle_our_barcode.selecttext( 1,100)	
		return -1
	end if 
	
//=========================================================
//  $$HEX11$$9ccde0ac200098ccacb9200004d55cb838c1a4c22000$$ENDHEX$$
//=========================================================
			
      int lvi_count

	 select count(*) into :lvi_count 
	  from im_item_receipt_barcode
	where item_barcode          = :lvs_our_barcode
		and receipt_compare_yn = 'Y'
		and organization_id        = :gvi_organization_id ;
		
	if f_sql_check() < 0 then
		em_count.text = ''
		sle_our_barcode.setfocus()
		st_status.text = "$$HEX23$$14bc54cff1b4200085c7e0ac200074c725b874c72000c6c5b5c2c8b2e4b2200018bc88d498ccacb92000e4c228d3$$ENDHEX$$"
		return -1 
	end if 

//=============================
// $$HEX14$$85c7e0ac1cb4200074c725b874c7200074c8acc7200058d574ba2000$$ENDHEX$$
//=============================
if lvi_count > 0 then 
	

	
			//=================================================
			// $$HEX7$$18bc88d4ecc580bd10d3e8b22000$$ENDHEX$$
			//=================================================
			int ll_exists = 0
			
			ll_exists	=	dw_2.find("child_item_code = '" + lvs_item_code + "'", 1, dw_2.rowcount())
			
			if  ll_exists > 0   then 
				
				f_play_sound("$$HEX7$$f5aca9c690c7acc785c7c8b2e4b2$$ENDHEX$$.wav")	
				st_status.text = lvs_item_code+" $$HEX8$$f5aca9c690c7acc7200085c7c8b2e4b2$$ENDHEX$$"
				em_count.text = ''
				sle_our_barcode.text = ''
				sle_our_barcode.setfocus()
				
				
			else
				
				
					 select mfs , issue_date , issue_sequence , location_code
						 into :lvs_mfs , :lvdt_issue_date , :lvdb_issue_sequence  , :lvs_location_code 
					  from im_item_issue 
					 where item_code = :lvs_item_code 
						  and material_mfs = :lvs_lot_no
						 and issue_status <> 'C' 
						 and organization_id  = :gvi_organization_id  ;
						 
					 if f_sql_check() < 0 then 
						em_count.text = ''
						sle_our_barcode.setfocus()
						st_status.text = "$$HEX19$$9ccde0ac200074c725b874c72000c6c5b5c2c8b2e4b2200018bc88d498ccacb92000e4c228d3$$ENDHEX$$"
						return -1 
					 end if 		
					 
					update im_item_receipt_barcode set scan_qty = :lvl_qty
					 where item_barcode = :lvs_our_barcode 
						  and organization_id = :gvi_organization_id ; 
					
					if f_sql_check() < 0 then 
							  rollback;
							em_count.text = ''
							sle_our_barcode.text = ''
							sle_our_barcode.setfocus()
							st_status.text = "$$HEX12$$14bc54cfdcb4200018c2c9b72000c0bcbdac200024c658b9$$ENDHEX$$"		
							 return -1
					end if 		 
					
					//=========================================================
					// $$HEX10$$18c2d9b3200085c725b81cb4200018c2c9b72000$$ENDHEX$$
					//=========================================================
					
					lvl_issue_qty = long(em_count.text)
				
					//===================================================
					// $$HEX4$$9ccde0ac18bc88d4$$ENDHEX$$
					//===================================================
						if f_mat_issue_return( lvs_mfs  ,   lvdt_issue_date , lvdb_issue_sequence ,  lvl_issue_qty  , lvs_location_code  , f_t_sysdate() ) < 0 then 
							rollback;
							em_count.text = ''
							sle_our_barcode.text = ''
							sle_our_barcode.setfocus()
							st_status.text = "$$HEX19$$9ccde0ac200074c725b874c72000c6c5b5c2c8b2e4b2200018bc88d498ccacb92000e4c228d3$$ENDHEX$$"		
							 return -1
						else
							st_status.text ="$$HEX10$$15c8c1c098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
							commit ;
						end if
			end if 
			
			em_count.text = ''
			sle_our_barcode.text = ''
			sle_our_barcode.setfocus()
              return 0
			
//==============================================
//
//==============================================
else 

		st_status.text = "NG"
		f_msgbox(117 )
		em_count.text = ''
		sle_our_barcode.setfocus()
		return -1 

end if 
end function

on w_mat_receipt_barcode_reprint_master.create
int iCurrent
call super::create
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_1=create st_1
this.st_status=create st_status
this.sle_supplier_barcode=create sle_supplier_barcode
this.sle_slip_no_condition=create sle_slip_no_condition
this.st_9=create st_9
this.rb_tray=create rb_tray
this.rb_reel=create rb_reel
this.ddlb_receipt_type=create ddlb_receipt_type
this.st_2=create st_2
this.rb_reel_count=create rb_reel_count
this.em_count=create em_count
this.st_4=create st_4
this.sle_our_barcode=create sle_our_barcode
this.st_6=create st_6
this.sle_lot_no=create sle_lot_no
this.st_7=create st_7
this.rb_rebuild_reball=create rb_rebuild_reball
this.rb_rebuild_bulk=create rb_rebuild_bulk
this.pb_2=create pb_2
this.cbx_auto_print=create cbx_auto_print
this.cbx_msl=create cbx_msl
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_2=create gb_2
this.gb_5=create gb_5
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_item_code
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_status
this.Control[iCurrent+5]=this.sle_supplier_barcode
this.Control[iCurrent+6]=this.sle_slip_no_condition
this.Control[iCurrent+7]=this.st_9
this.Control[iCurrent+8]=this.rb_tray
this.Control[iCurrent+9]=this.rb_reel
this.Control[iCurrent+10]=this.ddlb_receipt_type
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.rb_reel_count
this.Control[iCurrent+13]=this.em_count
this.Control[iCurrent+14]=this.st_4
this.Control[iCurrent+15]=this.sle_our_barcode
this.Control[iCurrent+16]=this.st_6
this.Control[iCurrent+17]=this.sle_lot_no
this.Control[iCurrent+18]=this.st_7
this.Control[iCurrent+19]=this.rb_rebuild_reball
this.Control[iCurrent+20]=this.rb_rebuild_bulk
this.Control[iCurrent+21]=this.pb_2
this.Control[iCurrent+22]=this.cbx_auto_print
this.Control[iCurrent+23]=this.cbx_msl
this.Control[iCurrent+24]=this.gb_3
this.Control[iCurrent+25]=this.gb_4
this.Control[iCurrent+26]=this.gb_2
this.Control[iCurrent+27]=this.gb_5
this.Control[iCurrent+28]=this.gb_6
end on

on w_mat_receipt_barcode_reprint_master.destroy
call super::destroy
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.st_status)
destroy(this.sle_supplier_barcode)
destroy(this.sle_slip_no_condition)
destroy(this.st_9)
destroy(this.rb_tray)
destroy(this.rb_reel)
destroy(this.ddlb_receipt_type)
destroy(this.st_2)
destroy(this.rb_reel_count)
destroy(this.em_count)
destroy(this.st_4)
destroy(this.sle_our_barcode)
destroy(this.st_6)
destroy(this.sle_lot_no)
destroy(this.st_7)
destroy(this.rb_rebuild_reball)
destroy(this.rb_rebuild_bulk)
destroy(this.pb_2)
destroy(this.cbx_auto_print)
destroy(this.cbx_msl)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_2)
destroy(this.gb_5)
destroy(this.gb_6)
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
st_status.text = 'Ready.'
st_status.width = dw_1.width + dw_2.width
sle_supplier_barcode.setfocus()

//====================================
// $$HEX22$$acb9ecd3b8d2200000adacb9d0c52000f1b45db818b4b4c5200088c73cc774ba200014bcd4af00c9e4b22000$$ENDHEX$$
//====================================

STRING ls_syntax

ls_syntax = ''
ls_syntax	=	f_get_dataobject('REPORT', upper(THIS.CLASSNAME()) ,  string( dw_3.dataobject )	)

if	ls_syntax = '' or isnull(ls_syntax) then
	f_msg_mdi_help("Report Not Changed")
else
	
	dw_3.create(ls_syntax)
	dw_3.settransobject(sqlca)
	f_set_column_dddw(dw_3)
	f_dual_lang_change_dwtext(dw_3)
	
	f_msg_mdi_help("Report Changed")
	
end if	

//====================================
// $$HEX22$$acb9ecd3b8d2200000adacb9d0c52000f1b45db818b4b4c5200088c73cc774ba200014bcd4af00c9e4b22000$$ENDHEX$$
//====================================

ls_syntax = ''
ls_syntax	=	f_get_dataobject('REPORT', upper(THIS.CLASSNAME()) ,  string( dw_5.dataobject )	)

if	ls_syntax = '' or isnull(ls_syntax) then
	
	f_msg_mdi_help("Report Not Changed")
	
else
	
	dw_5.create(ls_syntax)
	dw_5.settransobject(sqlca)
	f_set_column_dddw(dw_5)
	f_dual_lang_change_dwtext(dw_5)
	
end if	


//$$HEX10$$68d5b5c27cb7a8bc20001cbc89d52000ecc580bd$$ENDHEX$$
if Gvs_msl_label_print = 'Y' then
   cbx_msl.checked = true
else	
   cbx_msl.checked = false
end if

end event

event ue_data_control;call super::ue_data_control;
choose case gvs_ue_data_control
		
	case 'RETRIEVE'
		
			dw_1.reset()
			dw_1.retrieve(   ddlb_item_code.text() + '%',  sle_slip_no_condition.text+'%' ,  sle_supplier_barcode.text+'%' ,sle_our_barcode.text+'%' , sle_lot_no.text+'%' ,  gvi_organization_id)
			
			sle_supplier_barcode.text = ''
			sle_supplier_barcode.setfocus()
			st_status.text = 'Waitting'
	 
     case 'INSERT'
		
					LVL_ROW = DW_1.INSERTROW(1)
					DW_1.SCROLLTOROW(LVL_ROW)
					F_SET_SECURITY_ROW(DW_1 , LVL_ROW ,'ALL')
	
	case 'UPDATE'
		
			IF dw_1.UPDATE() < 0   THEN
				ROLLBACK;
				RETURN					
			ELSE
				COMMIT;
				F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
				sle_supplier_barcode.setfocus()		 
			END IF

	case else
end choose

end event

event clicked;call super::clicked;sle_supplier_barcode.setfocus()
end event

event resize;call super::resize;st_status.width = dw_1.width + dw_2.width
end event

type dw_5 from w_main_root`dw_5 within w_mat_receipt_barcode_reprint_master
integer y = 932
integer width = 2267
integer height = 752
integer taborder = 0
string dataobject = "d_mat_receipt_lot_barcode_msl_rpt"
end type

type dw_4 from w_main_root`dw_4 within w_mat_receipt_barcode_reprint_master
integer y = 932
integer width = 2267
integer height = 752
integer taborder = 0
boolean titlebar = true
string title = "Tray"
string dataobject = "d_mat_receipt_lot_tray_divide_barcode_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_mat_receipt_barcode_reprint_master
integer y = 932
integer width = 2267
integer height = 752
integer taborder = 0
boolean titlebar = true
string title = "Reel"
string dataobject = "d_mat_receipt_lot_barcode_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_mat_receipt_barcode_reprint_master
integer y = 932
integer width = 2267
integer height = 752
integer taborder = 0
boolean titlebar = true
borderstyle borderstyle = styleraised!
end type

type dw_1 from w_main_root`dw_1 within w_mat_receipt_barcode_reprint_master
integer y = 932
integer width = 2267
integer height = 752
integer taborder = 0
boolean titlebar = true
string title = "Receipt Barcode List"
string dataobject = "d_mat_rceipt_barcode_4_reprint_lst"
end type

event dw_1::clicked;call super::clicked;
string lvs_itemcode, lvs_msl_level

if dwo.name = 'b_print' then 
	
	if rb_reel.checked = true  or rb_reel_count.checked = true  then 
		
//			//=====================================
//			// $$HEX9$$10b140c7200029bcddc220009ccd25b82000$$ENDHEX$$
//			//=====================================
//			if (cbx_label_size.checked) then 
//				dw_3.dataobject = 'd_mat_receipt_lot_barcode_w_rpt' 
//				dw_3.settransobject(sqlca) 
//			else 
//				dw_3.dataobject = 'd_mat_receipt_lot_barcode_rpt' 
//				dw_3.settransobject(sqlca) 
//			end if		
		
			dw_3.retrieve( this.object.item_code[row] , this.object.receipt_slip_no[row] ,  this.object.lot_no[row] , gvi_organization_id )
			
			if dw_3.rowcount() > 0 then 	
				
				dw_3.print( )
				
				
				
//===========================================   
//$$HEX7$$68d5b5c27cb7a8bc20009ccd25b8$$ENDHEX$$
// MSL$$HEX6$$90c7acc7ecc580bdb4cc6cd0$$ENDHEX$$
//===========================================
If cbx_msl.checked = true Then          

		lvs_itemcode = dw_3.object.item_code[dw_3.getrow()]

		SELECT NVL(msl_level, '0')
		INTO :lvs_msl_level
		FROM  id_item
		WHERE item_code = :lvs_itemcode
		AND organization_id = :gvi_organization_id  ;
		
		IF F_SQL_CHECK() < 0 THEN 
			RETURN 
		END IF 

		IF  lvs_msl_level > '2'  THEN
			
			dw_5.retrieve( dw_1.object.item_code[dw_3.getrow()] ,  dw_1.object.receipt_slip_no[dw_3.getrow()]  ,  '%' , gvi_organization_id )
			
			if dw_5.rowcount() > 0 then
				
                dw_5.Object.DataWindow.Print.Page.Range= 1
		       dw_5.print( false)
		
			else
				f_msgbox(117)
				return
			end if			
			
		End if   
End if    

				
				
				
				
			else
			
				f_msgbox(117)
			end if 
//====================================================================================
//
//====================================================================================
	elseif rb_tray.checked = true then 
		
		LVS_ITEM_CODE =  STRING(this.object.item_code[row])
		LVS_SLIP_NO = STRING( this.object.receipt_slip_no[row] )
		LVS_LOT_NO =STRING(this.object.lot_no[row] )
		
		
			dw_4.retrieve( LVS_ITEM_CODE  ,LVS_SLIP_NO, LVS_LOT_NO,  gvi_organization_id )
			if dw_4.rowcount() > 0 then 	
				dw_4.print( )
			else
				MESSAGEBOX("1" ,LVS_ITEM_CODE +" "+LVS_SLIP_NO +" "+LVS_LOT_NO)
				f_msgbox(117)
			end if 		
	else
		MESSAGEBOX("$$HEX2$$55d678c7$$ENDHEX$$" ,"$$HEX17$$b4b9200010b694b22000b8d208b874c720007cb9200020c1ddd0200058d538c194c6$$ENDHEX$$")
		RETURN 
	end if 

end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_receipt_barcode_reprint_master
integer taborder = 0
end type

type ddlb_item_code from uo_item_code within w_mat_receipt_barcode_reprint_master
integer x = 887
integer y = 204
integer width = 530
integer height = 676
integer taborder = 0
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;sle_supplier_barcode.setfocus()
end event

type st_3 from so_statictext within w_mat_receipt_barcode_reprint_master
integer x = 887
integer y = 116
integer width = 530
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_1 from so_statictext within w_mat_receipt_barcode_reprint_master
integer x = 896
integer y = 456
integer width = 1339
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Supplier Barcode"
end type

event clicked;call super::clicked;sle_supplier_barcode.setfocus()
end event

type st_status from so_statictext within w_mat_receipt_barcode_reprint_master
integer x = 5
integer y = 752
integer width = 4526
integer height = 168
boolean bringtotop = true
integer textsize = -24
integer weight = 700
long textcolor = 33327873
long backcolor = 24510463
string text = "Message"
end type

event clicked;call super::clicked;sle_supplier_barcode.setfocus()
end event

type sle_supplier_barcode from so_singlelineedit within w_mat_receipt_barcode_reprint_master
integer x = 896
integer y = 552
integer width = 1339
integer height = 84
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;f_retrieve()
end event

type sle_slip_no_condition from so_singlelineedit within w_mat_receipt_barcode_reprint_master
integer x = 1426
integer y = 204
integer width = 608
integer height = 84
boolean bringtotop = true
end type

type st_9 from so_statictext within w_mat_receipt_barcode_reprint_master
integer x = 1426
integer y = 116
integer width = 608
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Slip No"
end type

type rb_tray from so_radiobutton within w_mat_receipt_barcode_reprint_master
integer x = 73
integer y = 240
integer width = 731
integer height = 84
boolean bringtotop = true
integer textsize = -10
string text = "Tray"
end type

event clicked;call super::clicked;sle_our_barcode.enabled = TRUE
em_count.enabled = false 
sle_supplier_barcode.enabled = FALSE
sle_our_barcode.setfocus()
end event

type rb_reel from so_radiobutton within w_mat_receipt_barcode_reprint_master
integer x = 73
integer y = 128
integer width = 731
integer height = 84
boolean bringtotop = true
integer textsize = -10
string text = "Reel"
boolean checked = true
end type

event clicked;call super::clicked;sle_our_barcode.enabled = false
em_count.enabled = false 
sle_supplier_barcode.enabled = true
sle_supplier_barcode.setfocus()
end event

type ddlb_receipt_type from uo_basecode within w_mat_receipt_barcode_reprint_master
integer x = 2043
integer y = 204
integer width = 485
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw('RECEIPT TYPE')
end event

type st_2 from so_statictext within w_mat_receipt_barcode_reprint_master
integer x = 2053
integer y = 116
integer width = 453
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Receipt Type"
end type

type rb_reel_count from so_radiobutton within w_mat_receipt_barcode_reprint_master
integer x = 73
integer y = 348
integer width = 731
integer height = 84
boolean bringtotop = true
integer textsize = -10
string text = "Reel Count"
end type

event clicked;call super::clicked;sle_our_barcode.enabled = true
sle_supplier_barcode.enabled = false
em_count.enabled = true 
sle_our_barcode.setfocus()
end event

type em_count from so_editmask within w_mat_receipt_barcode_reprint_master
integer x = 3547
integer y = 548
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer weight = 400
string text = "0"
string mask = "###,###"
double increment = 1
end type

event modified;call super::modified;if sle_our_barcode.text = '' then return 

if rb_rebuild_reball.checked = true or  rb_rebuild_bulk.checked = true  then 

		lvs_our_barcode = sle_our_barcode.text
		
		if rb_rebuild_reball.checked = true then 
			 lvs_label_type = 'R'
			 lvs_line_code  = '27' //$$HEX6$$acb9fcbc7cb778c720000900$$ENDHEX$$
		elseif  rb_rebuild_bulk.checked = true then 
			lvs_label_type = 'B'
			lvs_line_code  = '25' //$$HEX9$$8cbc6cd07cb778c720000900090009000900$$ENDHEX$$
		end if 
		
			//==================================================
			//  $$HEX6$$88d4a9ba200054cfdcb42000$$ENDHEX$$
			//  - $$HEX15$$6cad84bd90c700ac2000c6c53cc774ba200024c658b9200098ccacb92000$$ENDHEX$$
			//==================================================
			
//			lvi_pos1 =  pos(lvs_our_barcode , '-' , 7 ) 
//			
//			if  lvi_pos1 <= 0 then 
//				
//				f_msgbox1(1175 ,lvs_our_barcode )
//				this.text = ''
//				sle_our_barcode.text = ''
//				sle_our_barcode.setfocus()
//				return -1 
//				
//			end if 
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
			//=================================================
			//
			//=================================================
			
//			lvs_item_code = trim( mid( lvs_our_barcode , 1 ,  lvi_pos1 -1 ))
			
			if f_check_item_exists( lvs_item_code , f_t_sysdate())  <= 0 then 
				f_play_sound("$$HEX5$$88d4a9baf8bbf1b45db8$$ENDHEX$$.wav")	
				f_msgbox(9041) //$$HEX10$$fcd3a9bac8b9a4c230d12000f8bbf1b45db82000$$ENDHEX$$
				st_status.text =f_msg_st(9041)
				this.text = ''
				sle_our_barcode.text = ''
				sle_our_barcode.setfocus()
				return -1
			end if 
			
			//==================================================
			// $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
			//==================================================
//			lvi_pos2 =  pos(lvs_our_barcode , '-' , lvi_pos1+1 ) 
//			
//			if  lvi_pos2 <= 0 then 
//				lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,  100 ))
//			else
//				
//				lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,   lvi_pos2 - lvi_pos1 -1 ))
//				if lvs_lot_no = ''  then 
//					f_msgbox1(1175 ,lvs_our_barcode )
//					st_status.text = "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"
//					this.text = ''
//					sle_our_barcode.text = ''
//					sle_our_barcode.setfocus()
//					return -1
//				end if 
//
//			end if 
			SELECT  F_GET_LOT_NO_FROM_BARCODE (:lvs_our_barcode ) 
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
			//==================================================
			//  $$HEX7$$ddc031c12000200018c2c9b72000$$ENDHEX$$
			//==================================================
			
//			if lvi_pos2 > 0 then 
//				lvl_issue_qty = long( trim( mid( lvs_our_barcode , lvi_pos2+1 ,  10  )) )
//			else
//				lvl_issue_qty = long(this.text)
//			end if 	
			
//			if lvl_issue_qty <= 0 then 	
//				f_play_sound("$$HEX4$$18c2c9b724c658b9$$ENDHEX$$.wav")		
//				st_status.text = "$$HEX13$$18c2c9b774c720002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"	
//				this.text = ''
//				this.setfocus()
//				return -1
//			end if 
//
	SELECT  TO_NUMBER( F_GET_LOT_QTY_FROM_BARCODE (:lvs_our_barcode ) )
	INTO :lvl_receipt_qty
	FROM DUAL ; 
	
	
	IF F_SQL_CHECK() < 0 THEN 
		sle_our_barcode.selecttext( 1,100)	
	END IF 	 


if lvl_receipt_qty <=0 then 
	
	f_play_sound("$$HEX4$$18c2c9b724c658b9$$ENDHEX$$.wav")	
	st_status.text = F_MSG( "$$HEX15$$85c7e0ac18c2c9b774c720002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"	 , 'S')
	sle_our_barcode.setfocus()
	sle_our_barcode.selecttext( 1,100)	
	f_msgbox(173)
	return -1
end if 
		INT LVI_COUNT
		SELECT count(*)
		   INTO :LVI_COUNT
		  FROM IM_ITEM_RECEIPT_BARCODE
		WHERE ITEM_CODE      = :LVS_ITEM_CODE
		    AND  LOT_NO           = :LVS_LOT_NO
		    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

		IF F_SQL_CHECK() < 0 THEN 
			st_status.text = "$$HEX13$$14bc54cfdcb4200074c725b8200070c88cd611c9200024c658b9$$ENDHEX$$"
			this.text = ''
			sle_our_barcode.setfocus( )
			sle_our_barcode.selecttext( 1,100)
			RETURN 
		END IF 
		
		IF LVI_COUNT > 0  THEN
			sle_our_barcode.setfocus( )
			sle_our_barcode.selecttext( 1,100)	
			st_status.text = "$$HEX21$$74c7f8bb200014bc54cfdcb4200015c8f4bc00ac2000ddc031c1200018b4b4c5200088c7b5c2c8b2e4b2$$ENDHEX$$"
			RETURN 				
		END IF 		

			//==================================================
			//
			//==================================================
				lvl_row = 0 
				f_insert()
			
				lvs_slip_no          = lvs_lot_no
				lvs_item_barcode = lvs_our_barcode
				//=============================================
				//
				//=============================================
			
				dw_1.object.scan_date[LVL_ROW]            = f_t_sysdate()
				dw_1.object.item_code[LVL_ROW]            = lvs_item_code //$$HEX5$$fcd3a9ba54cfdcb42000$$ENDHEX$$
				dw_1.object.lot_no[LVL_ROW]                  = lvs_lot_no  //$$HEX5$$6fb8b8d288bc38d62000$$ENDHEX$$
				
				dw_1.object.receipt_slip_no[LVL_ROW]     = lvs_slip_no //$$HEX6$$85c7e0ac200020c715d62000$$ENDHEX$$+ $$HEX3$$6fb8b8d22000$$ENDHEX$$
				dw_1.object.receipt_compare_yn[lvl_row]  = 'Y' //$$HEX4$$44be50ad44c6ccb8$$ENDHEX$$
				dw_1.object.receipt_compare_date[lvl_row]  = f_sysdate()
				dw_1.object.barcode_status[lvl_row]         = 'N'	
				
				dw_1.object.issue_compare_yn[lvl_row]  = 'N' //$$HEX5$$44be50ad20c734bb2000$$ENDHEX$$
				dw_1.object.issue_return_yn[lvl_row]      = 'Y' 
				dw_1.object.issue_return_date[lvl_row]      = f_sysdate()
				
				dw_1.object.scan_qty[LVL_ROW]              = lvl_issue_qty
				dw_1.object.item_barcode[LVL_ROW]       = lvs_item_code+"-"+lvs_lot_no+"-"+string(lvl_issue_qty)// $$HEX9$$5ccd85c814bc54cfdcb42000090009000900$$ENDHEX$$
				
				dw_1.object.receipt_type[lvl_row]             = 'R' //$$HEX14$$18bc88d4d0c5200058c7d0c52000ddc034ae200070b374c730d12000$$ENDHEX$$
				dw_1.object.supplier_code[LVL_ROW]       = lvs_line_code
				dw_1.object.label_type[lvl_row]                = lvs_label_type
				dw_1.object.supplier_barcode[lvl_row]      = lvs_item_barcode
				dw_1.object.supplier_item_code[lvl_row]   = lvs_item_code
				
				dw_1.object.line_code[lvl_row]                  =lvs_line_code
				dw_1.object.workstage_code[lvl_row]        = '*'
				
				//===========================================
				//
				//===========================================
				
				if dw_1.update()  < 0 then 
					rollback ;
					this.text = ''
					sle_our_barcode.text = ''
					sle_our_barcode.setfocus()
					st_status.text = '$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$'
					f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
					return 
				else
					
					this.text = ''
					sle_our_barcode.text = ''
					sle_our_barcode.setfocus()
	
					f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")
					st_status.text = '$$HEX10$$15c8c1c098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$'
	                  commit ;

				end if 
//=======================================================
//
//=======================================================
elseif rb_reel_count.checked = true then 
	
			lvs_our_barcode = sle_our_barcode.text 
			
			//==================================================
			//  $$HEX6$$88d4a9ba200054cfdcb42000$$ENDHEX$$
			//  - $$HEX15$$6cad84bd90c700ac2000c6c53cc774ba200024c658b9200098ccacb92000$$ENDHEX$$
			//==================================================
			
//			lvi_pos1 =  pos(lvs_our_barcode , '-' , 7 ) 
//			
//			if  lvi_pos1 <= 0 then 
//				
//				f_msgbox1(1175 ,lvs_our_barcode )
//				this.text = ''
//				sle_our_barcode.text = ''
//				sle_our_barcode.setfocus()
//				return -1 
//				
//			end if 	
			//=================================================
			//
			//=================================================
			
//			lvs_item_code = trim( mid( lvs_our_barcode , 1 ,  lvi_pos1 -1 ))
			
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
				st_status.text =f_msg_st(9041)
				this.text = ''
				sle_our_barcode.text = ''
				sle_our_barcode.setfocus()
				return -1
			end if 
			
			//==================================================
			// $$HEX6$$6fb8b8d2200088bc38d62000$$ENDHEX$$
			//==================================================
//			lvi_pos2 =  pos(lvs_our_barcode , '-' , lvi_pos1+1 ) 
//			
//			if  lvi_pos2 <= 0 then 
//				lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,  100 ))
//			else
//				
//				lvs_lot_no = trim( mid( lvs_our_barcode , lvi_pos1+1 ,   lvi_pos2 - lvi_pos1 -1 ))
//				if lvs_lot_no = ''  then 
//					f_msgbox1(1175 ,lvs_our_barcode )
//					st_status.text = "$$HEX15$$6fb8b8d288bc38d600ac20002cc614bc74b9c0c920004ac5b5c2c8b2e4b2$$ENDHEX$$"
//					this.text = ''
//					sle_our_barcode.text = ''
//					sle_our_barcode.setfocus()
//					return -1
//				end if 
//
//			end if 
			
			SELECT  F_GET_LOT_NO_FROM_BARCODE (:lvs_our_barcode ) 
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
	
	          lvl_issue_qty = long(this.text) 
				 
			UPDATE IM_ITEM_RECEIPT_BARCODE
				SET   ISSUE_COMPARE_YN = 'N' ,
						ISSUE_COMPARE_DATE = NULL  , 
						ISSUE_COMPARE_BY = NULL , 
						SUPPLIER_BARCODE = '*'  ,
						ISSUE_RETURN_YN = 'Y' ,
						ISSUE_RETURN_DATE = SYSDATE ,
						SCAN_QTY = :lvl_issue_qty ,
						LAST_SCAN_QTY = SCAN_QTY ,
						LAST_ISSUE_COMPARE_DATE = ISSUE_COMPARE_DATE ,
						LAST_ISSUE_COMPARE_BY = ISSUE_COMPARE_BY ,
						ITEM_BARCODE = :LVS_ITEM_CODE||'-'||:LVS_LOT_NO||'-'||:lvl_issue_qty
			  WHERE LOT_NO = :lvs_lot_no
			      AND ORGANIZATION_ID = :GVI_ORganization_id ;
	
				if f_sql_check() < 0 then 
					rollback ;
					this.text = ''
					sle_our_barcode.text = ''
					sle_our_barcode.setfocus()
					st_status.text = '$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$'
					f_play_sound("$$HEX4$$00c8a5c7e4c228d3$$ENDHEX$$.wav")
					return  
				end if 
	    		    commit ;
			
			dw_1.retrieve(   LVS_ITEM_CODE + '%',  '%' ,  '%' , '%' , LVS_LOT_NO+'%' ,  gvi_organization_id)
			
			if cbx_auto_print.checked = true then 
//							//=====================================
//							// $$HEX9$$10b140c7200029bcddc220009ccd25b82000$$ENDHEX$$
//							//=====================================
//							if (cbx_label_size.checked) then 
//								dw_3.dataobject = 'd_mat_receipt_lot_barcode_w_rpt' 
//								dw_3.settransobject(sqlca) 
//							else 
//								dw_3.dataobject = 'd_mat_receipt_lot_barcode_rpt' 
//								dw_3.settransobject(sqlca) 
//							end if		
						
							if dw_1.getrow() < 1 then 
								f_msgbox(117)
							else
								dw_3.retrieve( dw_1.object.item_code[1] , dw_1.object.receipt_slip_no[1] ,  dw_1.object.lot_no[1] , gvi_organization_id )
							
								if dw_3.rowcount() > 0 then 	
									dw_3.print( )
								else
									f_msgbox(117)
								end if 	    
								
							end if ;
				end if 
				
				this.text = ''
				sle_our_barcode.text = ''
				sle_our_barcode.setfocus()

				f_play_sound("$$HEX4$$00c8a5c731c1f5ac$$ENDHEX$$.wav")
				st_status.text = '$$HEX10$$15c8c1c098ccacb9200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$'
end if 

end event

type st_4 from so_statictext within w_mat_receipt_barcode_reprint_master
integer x = 3543
integer y = 452
integer width = 393
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Qty"
end type

type sle_our_barcode from so_singlelineedit within w_mat_receipt_barcode_reprint_master
integer x = 2318
integer y = 548
integer width = 1216
integer height = 84
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;//f_retrieve()
em_count.setfocus()
st_status.text = "$$HEX9$$18c2c9b744c7200085c725b858d538c194c6$$ENDHEX$$"
end event

type st_6 from so_statictext within w_mat_receipt_barcode_reprint_master
integer x = 2318
integer y = 456
integer width = 1216
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Our Barcode"
end type

event clicked;call super::clicked;sle_supplier_barcode.setfocus()
end event

type sle_lot_no from so_singlelineedit within w_mat_receipt_barcode_reprint_master
integer x = 2542
integer y = 204
integer width = 608
integer height = 84
integer taborder = 50
boolean bringtotop = true
end type

type st_7 from so_statictext within w_mat_receipt_barcode_reprint_master
integer x = 2542
integer y = 116
integer width = 608
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Lot No"
end type

type rb_rebuild_reball from so_radiobutton within w_mat_receipt_barcode_reprint_master
integer x = 73
integer y = 452
integer width = 731
integer height = 84
boolean bringtotop = true
integer textsize = -10
string text = "Rebuild  Reball Label"
end type

event clicked;call super::clicked;sle_our_barcode.enabled = true
sle_supplier_barcode.enabled = false
em_count.enabled = true 
sle_our_barcode.setfocus()

st_status.text = "$$HEX29$$90c7acc0200014bc54cfdcb47cb92000a4c294ce200058d570ac98b0200085c725b858d538c194c6200088d4a9bafcac20006fb8b8d294b22000$$ENDHEX$$- $$HEX7$$5cb820006cad84bd58d538c194c6$$ENDHEX$$"
end event

type rb_rebuild_bulk from so_radiobutton within w_mat_receipt_barcode_reprint_master
integer x = 73
integer y = 568
integer width = 731
integer height = 84
boolean bringtotop = true
integer textsize = -10
string text = "Rebuild  Bulk Label"
end type

event clicked;call super::clicked;sle_our_barcode.enabled = true
sle_supplier_barcode.enabled = false
em_count.enabled = true 
sle_our_barcode.setfocus()
st_status.text = "$$HEX29$$90c7acc0200014bc54cfdcb47cb92000a4c294ce200058d570ac98b0200085c725b858d538c194c6200088d4a9bafcac20006fb8b8d294b22000$$ENDHEX$$- $$HEX7$$5cb820006cad84bd58d538c194c6$$ENDHEX$$"
end event

type pb_2 from so_commandbutton within w_mat_receipt_barcode_reprint_master
integer x = 3387
integer y = 208
integer width = 443
integer height = 108
integer taborder = 20
boolean bringtotop = true
string text = "Print ALL"
end type

event clicked;call super::clicked;INT I

IF DW_1.rowcount() < 1 THEN RETURN 

DO
	
	i++
	
		if rb_reel_count.checked = true then 
			
//					//=====================================
//					// $$HEX10$$1cc80cbe7cb7200029bcddc220009ccd25b82000$$ENDHEX$$
//					//=====================================
//					if (cbx_label_size.checked) then 
//						dw_3.dataobject = 'd_mat_receipt_lot_barcode_w_rpt' 
//						dw_3.settransobject(sqlca) 
//					else 
//						dw_3.dataobject = 'd_mat_receipt_lot_barcode_rpt' 
//						dw_3.settransobject(sqlca) 
//					end if
			
			
					dw_3.retrieve( dw_1.object.item_code[i] , dw_1.object.receipt_slip_no[i] ,  dw_1.object.lot_no[i] , gvi_organization_id )
					if dw_3.rowcount() > 0 then 	
						dw_3.print( )
					else
					
						f_msgbox(117)
					end if 
					
	
		elseif rb_reel.checked = true then 
			
//					//=====================================
//					// $$HEX10$$1cc80cbe7cb7200029bcddc220009ccd25b82000$$ENDHEX$$
//					//=====================================
//					if (cbx_label_size.checked) then 
//						dw_3.dataobject = 'd_mat_receipt_lot_barcode_w_rpt' 
//						dw_3.settransobject(sqlca) 
//					else 
//						dw_3.dataobject = 'd_mat_receipt_lot_barcode_rpt' 
//						dw_3.settransobject(sqlca) 
//					end if
			
			
					dw_3.retrieve( dw_1.object.item_code[i] , dw_1.object.receipt_slip_no[i] ,  dw_1.object.lot_no[i] , gvi_organization_id )
					if dw_3.rowcount() > 0 then 	
						dw_3.print( )
					else
					
						f_msgbox(117)
					end if 
			//====================================================================================
			//
			//====================================================================================
			elseif rb_tray.checked = true then 
			
					LVS_ITEM_CODE =  STRING(dw_1.object.item_code[i])
					LVS_SLIP_NO = STRING( dw_1.object.receipt_slip_no[i] )
					LVS_LOT_NO =STRING(dw_1.object.lot_no[i] )
					
					
						dw_4.retrieve( LVS_ITEM_CODE  ,LVS_SLIP_NO, LVS_LOT_NO,  gvi_organization_id )
						if dw_4.rowcount() > 0 then 	
							dw_4.print( )
						else
							MESSAGEBOX("1" ,LVS_ITEM_CODE +" "+LVS_SLIP_NO +" "+LVS_LOT_NO)
							f_msgbox(117)
						end if 		
			else
				MESSAGEBOX("$$HEX2$$55d678c7$$ENDHEX$$" ,"$$HEX17$$b4b9200010b694b22000b8d208b874c720007cb9200020c1ddd0200058d538c194c6$$ENDHEX$$")
				RETURN 
			end if 

LOOP until I = DW_1.rowcount()
end event

type cbx_auto_print from so_checkbox within w_mat_receipt_barcode_reprint_master
integer x = 3387
integer y = 92
integer width = 443
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
string text = "Auto Print"
boolean checked = true
end type

type cbx_msl from so_checkbox within w_mat_receipt_barcode_reprint_master
integer x = 3904
integer y = 92
integer width = 549
integer height = 76
boolean bringtotop = true
integer textsize = -10
long textcolor = 0
string text = "Msl Label Print"
end type

type gb_3 from so_groupbox within w_mat_receipt_barcode_reprint_master
integer x = 2286
integer y = 384
integer width = 1696
integer height = 336
integer weight = 700
long textcolor = 16711680
string text = "Our Barcode"
end type

type gb_4 from so_groupbox within w_mat_receipt_barcode_reprint_master
integer x = 3218
integer width = 1312
integer height = 372
integer weight = 700
long textcolor = 16711680
string text = "Print"
end type

type gb_2 from so_groupbox within w_mat_receipt_barcode_reprint_master
integer x = 864
integer y = 384
integer width = 1413
integer height = 336
integer taborder = 50
integer weight = 700
long textcolor = 16711680
string text = "Supplier Barcode"
end type

type gb_5 from so_groupbox within w_mat_receipt_barcode_reprint_master
integer x = 864
integer y = 4
integer width = 2336
integer height = 372
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_6 from so_groupbox within w_mat_receipt_barcode_reprint_master
integer y = 8
integer width = 841
integer height = 708
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Scan Receipt"
end type


HA$PBExportHeader$w_mat_other_receipt_master.srw
$PBExportComments$Material Receipt Master
forward
global type w_mat_other_receipt_master from w_main_root
end type
type uo_dateset from uo_ymd_calendar within w_mat_other_receipt_master
end type
type uo_dateend from uo_ymd_calendar within w_mat_other_receipt_master
end type
type ddlb_item_code from uo_item_code within w_mat_other_receipt_master
end type
type st_3 from so_statictext within w_mat_other_receipt_master
end type
type st_4 from so_statictext within w_mat_other_receipt_master
end type
type rb_arrival from so_radiobutton within w_mat_other_receipt_master
end type
type rb_receipt from so_radiobutton within w_mat_other_receipt_master
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_other_receipt_master
end type
type st_1 from so_statictext within w_mat_other_receipt_master
end type
type cbx_recycle_item from so_checkbox within w_mat_other_receipt_master
end type
type cbx_use_material_mfs from so_checkbox within w_mat_other_receipt_master
end type
type rb_all from so_radiobutton within w_mat_other_receipt_master
end type
type rb_gt from so_radiobutton within w_mat_other_receipt_master
end type
type sle_material_mfs from so_singlelineedit within w_mat_other_receipt_master
end type
type material_mfs_t from so_statictext within w_mat_other_receipt_master
end type
type tab_1 from tab within w_mat_other_receipt_master
end type
type tabpage_1 from userobject within tab_1
end type
type cbx_2 from so_checkbox within tabpage_1
end type
type cb_2 from commandbutton within tabpage_1
end type
type ddlb_workstage_code from uo_workstage_code_all within tabpage_1
end type
type st_7 from so_statictext within tabpage_1
end type
type st_6 from so_statictext within tabpage_1
end type
type ddlb_line_code from uo_line_code within tabpage_1
end type
type cbx_1 from so_checkbox within tabpage_1
end type
type tabpage_1 from userobject within tab_1
cbx_2 cbx_2
cb_2 cb_2
ddlb_workstage_code ddlb_workstage_code
st_7 st_7
st_6 st_6
ddlb_line_code ddlb_line_code
cbx_1 cbx_1
end type
type tabpage_2 from userobject within tab_1
end type
type st_2 from so_statictext within tabpage_2
end type
type em_copy from so_editmask within tabpage_2
end type
type cb_preview from so_commandbutton within tabpage_2
end type
type cb_print from so_commandbutton within tabpage_2
end type
type cbx_dialog from so_checkbox within tabpage_2
end type
type tabpage_2 from userobject within tab_1
st_2 st_2
em_copy em_copy
cb_preview cb_preview
cb_print cb_print
cbx_dialog cbx_dialog
end type
type tab_1 from tab within w_mat_other_receipt_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type cbx_auto_invoice from so_checkbox within w_mat_other_receipt_master
end type
type ddlb_location_code from uo_basecode within w_mat_other_receipt_master
end type
type st_5 from so_statictext within w_mat_other_receipt_master
end type
type pb_1 from so_commandbutton within w_mat_other_receipt_master
end type
type pb_2 from so_commandbutton within w_mat_other_receipt_master
end type
type sle_invoice_no from so_singlelineedit within w_mat_other_receipt_master
end type
type st_invoice_no from so_statictext within w_mat_other_receipt_master
end type
type gb_2 from so_groupbox within w_mat_other_receipt_master
end type
type gb_3 from so_groupbox within w_mat_other_receipt_master
end type
type gb_5 from so_groupbox within w_mat_other_receipt_master
end type
type gb_4 from so_groupbox within w_mat_other_receipt_master
end type
end forward

global type w_mat_other_receipt_master from w_main_root
integer width = 4869
integer height = 2716
string title = "Material Othe Receipt Master"
uo_dateset uo_dateset
uo_dateend uo_dateend
ddlb_item_code ddlb_item_code
st_3 st_3
st_4 st_4
rb_arrival rb_arrival
rb_receipt rb_receipt
ddlb_supplier_code ddlb_supplier_code
st_1 st_1
cbx_recycle_item cbx_recycle_item
cbx_use_material_mfs cbx_use_material_mfs
rb_all rb_all
rb_gt rb_gt
sle_material_mfs sle_material_mfs
material_mfs_t material_mfs_t
tab_1 tab_1
cbx_auto_invoice cbx_auto_invoice
ddlb_location_code ddlb_location_code
st_5 st_5
pb_1 pb_1
pb_2 pb_2
sle_invoice_no sle_invoice_no
st_invoice_no st_invoice_no
gb_2 gb_2
gb_3 gb_3
gb_5 gb_5
gb_4 gb_4
end type
global w_mat_other_receipt_master w_mat_other_receipt_master

type variables
string ivs_preview_yn
end variables

on w_mat_other_receipt_master.create
int iCurrent
call super::create
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_4=create st_4
this.rb_arrival=create rb_arrival
this.rb_receipt=create rb_receipt
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_1=create st_1
this.cbx_recycle_item=create cbx_recycle_item
this.cbx_use_material_mfs=create cbx_use_material_mfs
this.rb_all=create rb_all
this.rb_gt=create rb_gt
this.sle_material_mfs=create sle_material_mfs
this.material_mfs_t=create material_mfs_t
this.tab_1=create tab_1
this.cbx_auto_invoice=create cbx_auto_invoice
this.ddlb_location_code=create ddlb_location_code
this.st_5=create st_5
this.pb_1=create pb_1
this.pb_2=create pb_2
this.sle_invoice_no=create sle_invoice_no
this.st_invoice_no=create st_invoice_no
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_5=create gb_5
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_dateset
this.Control[iCurrent+2]=this.uo_dateend
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rb_arrival
this.Control[iCurrent+7]=this.rb_receipt
this.Control[iCurrent+8]=this.ddlb_supplier_code
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.cbx_recycle_item
this.Control[iCurrent+11]=this.cbx_use_material_mfs
this.Control[iCurrent+12]=this.rb_all
this.Control[iCurrent+13]=this.rb_gt
this.Control[iCurrent+14]=this.sle_material_mfs
this.Control[iCurrent+15]=this.material_mfs_t
this.Control[iCurrent+16]=this.tab_1
this.Control[iCurrent+17]=this.cbx_auto_invoice
this.Control[iCurrent+18]=this.ddlb_location_code
this.Control[iCurrent+19]=this.st_5
this.Control[iCurrent+20]=this.pb_1
this.Control[iCurrent+21]=this.pb_2
this.Control[iCurrent+22]=this.sle_invoice_no
this.Control[iCurrent+23]=this.st_invoice_no
this.Control[iCurrent+24]=this.gb_2
this.Control[iCurrent+25]=this.gb_3
this.Control[iCurrent+26]=this.gb_5
this.Control[iCurrent+27]=this.gb_4
end on

on w_mat_other_receipt_master.destroy
call super::destroy
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_arrival)
destroy(this.rb_receipt)
destroy(this.ddlb_supplier_code)
destroy(this.st_1)
destroy(this.cbx_recycle_item)
destroy(this.cbx_use_material_mfs)
destroy(this.rb_all)
destroy(this.rb_gt)
destroy(this.sle_material_mfs)
destroy(this.material_mfs_t)
destroy(this.tab_1)
destroy(this.cbx_auto_invoice)
destroy(this.ddlb_location_code)
destroy(this.st_5)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.sle_invoice_no)
destroy(this.st_invoice_no)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_5)
destroy(this.gb_4)
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
Ivs_resize_type                      = 'MASTER_DETAIL_1L2FR'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
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
F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control





end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
uo_dateset.settext(string(f_t_sysdate(), 'yyyy/mm')+'/01')
end event

event ue_data_control;call super::ue_data_control;long row , lvi_sign
string lvs_date , lvs_receipt_lot_no
double LVDB_RCV_ISS_SEQ , LVDB_RECEIPT_LOT_NO

int i , j , lvi_return

choose case gvs_ue_data_control
		
	case 'RETRIEVE'
			dw_1.reset()
			dw_2.reset()
			dw_3.reset()
			
			    if rb_all.checked = true then 
				lvi_sign = -2
			    elseif rb_gt.checked = true then 
				lvi_sign = 1
			    end if
			
			if rb_arrival.checked = true  then 
			    dw_1.retrieve(ddlb_item_code.text() + '%',  sle_material_mfs.TEXT+'%' , lvi_sign ,ddlb_location_code.getcode( )+'%' ,  gvi_organization_id)
			else
				dw_3.retrieve(ddlb_item_code.text() + '%', sle_material_mfs.TEXT+'%'  , ddlb_supplier_code.text +'%',  uo_dateset.text() , uo_dateend.text() , ddlb_location_code.getcode( )+'%' ,  sle_invoice_no.text +'%' , gvi_organization_id)
			end if 
	
    case 'INSERT'
		
			DW_2.RESET()
			ROW = DW_2.INSERTROW(0)
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
              
			LVDB_RCV_ISS_SEQ  = F_GET_SEQUENCE('SEQ_MAT_RECEIPT')
			lvs_receipt_lot_no= f_get_any_no( 'RECEIPT_LOT_NO')
			
			IF dw_1.getrow() > 0 then 
				
				//$$HEX34$$acc75cd6a9c6200085c7e0ac00ac200044c5c8b274ba1cc1200011d625b8acc0200054cfdcb400ac2000c6c594b2bdacb0c694b22000bdace0ac200054badcc2c0c92000$$ENDHEX$$
//				if dw_1.object.supplier_code[dw_1.getrow()] = '*' AND cbx_recycle_item.checked = FALSE then
//					f_msgbox1(111 ,  f_get_dual_lang_text( Gvs_language , "SUPPLIER CODE"))
//				end if 
				
				DW_2.OBJECT.SUPPLIER_CODE[ROW] = DW_1.OBject.SUPPLIER_CODE[DW_1.GETROw( )]
				DW_2.OBJECT.ITEM_CODE[ROW] = DW_1.OBject.ITEM_CODE[DW_1.GETROw( )]
				DW_2.TRIGGER EVENT ITEMCHANGED( ROW , DW_2.OBJECT.item_code , DW_2.OBJECT.item_code[ROW])						
				DW_2.OBJECT.LINE_TYPE[ROW] = DW_1.OBject.LINE_TYPE[DW_1.GETROw( )]
				DW_2.TRIGGER EVENT ITEMCHANGED( ROW , DW_2.OBJECT.LINE_TYPE , DW_2.OBJECT.LINE_TYPE[ROW])										
				
				DW_2.SETITEM( ROW , 'RECEIPT_DATE' , F_T_SYSDATE() )
				DW_2.SETITEM( ROW , 'RECEIPT_SEQUENCE' , LVDB_RCV_ISS_SEQ )
				
				if Gvs_material_receipt_auto_confirm = 'Y' then					
					dw_2.object.confirm_yn[row] = 'Y'
					dw_2.object.confirm_date[row] = f_t_sysdate()
				else
					dw_2.object.confirm_yn[row] = 'N'
				end if 
				
			
				
				if cbx_auto_invoice.checked = true then 
					DW_2.OBJECT.invoice_no[ROW] = string(F_T_SYSDATE(),'yyyymmdd')+string(LVDB_RCV_ISS_SEQ)
				end if 
					
				DW_2.SETITEM( ROW , 'CURRENCY' , GVS_CURRENCY )
				DW_2.SETITEM( ROW , 'DELIVERY' , '2')		
				DW_2.SETITEM( ROW , 'MFS' , '*')			
				DW_2.SETITEM( ROW , 'ORDER_NO' , '*')			
				DW_2.SETITEM( ROW , 'LOCATION_CODE' , string(dw_1.object.location_code[dw_1.getrow()] ))			
				if Gvs_mfs_replace_location_code = 'Y' then 
					DW_2.SETITEM( ROW , 'MATERIAL_MFS' ,string(dw_1.object.location_code[dw_1.getrow()] ))			
				else
					DW_2.SETITEM( ROW , 'MATERIAL_MFS' , '*')								
				end if 
				DW_2.SETITEM( ROW , 'EXCHANGE_RATE' ,1)							
				DW_2.SETITEM( ROW , 'RECEIPT_DEFICIT' , '1' )
				DW_2.SETITEM( ROW , 'RECEIPT_STATUS' , 'N' ) //$$HEX5$$85c7e0acc1c0dcd02000$$ENDHEX$$N $$HEX3$$15c8c1c02000$$ENDHEX$$, C $$HEX2$$e8cd8cc1$$ENDHEX$$
				DW_2.SETITEM( ROW , 'VIRTUAL_RECEIPT_YN' , 'N' ) //$$HEX6$$00ac85c7e0ac20006cad84bd$$ENDHEX$$
				DW_2.OBJECT.RECEIPT_LOT_NO[ROW] = lvs_receipt_lot_no
				DW_2.OBJECT.INTERFACE_YN[ROW] = 'N'
				DW_2.OBJECT.ORDER_TYPE[ROW] = 'M'		
				
			else
				
				if Gvs_material_receipt_auto_confirm = 'Y' then					
					dw_2.object.confirm_yn[row] = 'Y'
					dw_2.object.confirm_date[row] = f_t_sysdate()
				else
					dw_2.object.confirm_yn[row] = 'N'
				end if 
								
				DW_2.SETITEM( ROW , 'SUPPLIER_CODE' , ddlb_supplier_code.text )
				DW_2.SETITEM( ROW , 'RECEIPT_DATE' , F_T_SYSDATE() )
				DW_2.SETITEM( ROW , 'RECEIPT_SEQUENCE' , LVDB_RCV_ISS_SEQ )
				
				//==============================
				//
				//==============================
				if cbx_auto_invoice.checked = true then 
					DW_2.OBJECT.invoice_no[ROW] = string(F_T_SYSDATE(),'yyyymmdd')+string(LVDB_RCV_ISS_SEQ)
					
				else
					
				end if 				
				
				
				DW_2.SETITEM( ROW , 'CURRENCY' , GVS_CURRENCY )
				DW_2.SETITEM( ROW , 'DELIVERY' , '2')		
				DW_2.SETITEM( ROW , 'MFS' , '*')			
				DW_2.SETITEM( ROW , 'ORDER_NO' , '*')			
		//		DW_2.SETITEM( ROW , 'LOCATION_CODE' , '*')			
		//		DW_2.SETITEM( ROW , 'MATERIAL_MFS' , '*')			
				DW_2.SETITEM( ROW , 'EXCHANGE_RATE' ,1)							
				DW_2.SETITEM( ROW , 'RECEIPT_DEFICIT' , '1' )
				DW_2.SETITEM( ROW , 'RECEIPT_STATUS' , 'N' ) //$$HEX5$$85c7e0acc1c0dcd02000$$ENDHEX$$N $$HEX3$$15c8c1c02000$$ENDHEX$$, C $$HEX2$$e8cd8cc1$$ENDHEX$$
				DW_2.SETITEM( ROW , 'VIRTUAL_RECEIPT_YN' , 'N' ) //$$HEX6$$00ac85c7e0ac20006cad84bd$$ENDHEX$$
				DW_2.OBJECT.RECEIPT_LOT_NO[ROW] = lvs_receipt_lot_no
				DW_2.OBJECT.INTERFACE_YN[ROW] = 'N'
				DW_2.OBJECT.ORDER_TYPE[ROW] = 'M'	
				
			end if 
			
			if cbx_recycle_item.checked = true then 
				DW_2.OBJECT.RECEIPT_TYPE[ROW] = 'R'		// $$HEX5$$acc75cd6a9c685c7e0ac$$ENDHEX$$
			ELSE
				DW_2.SETITEM( ROW , 'RECEIPT_TYPE' , 'E' )	 // $$HEX5$$30aec0d085c7e0ac2000$$ENDHEX$$E , $$HEX6$$15c8c1c085c7e0ac20002000$$ENDHEX$$N						
			end if

//			if Gvs_use_material_mfs = 'Y' then 
//				dw_2.object.material_mfs[row] = '*'
//			else
//				dw_2.object.material_mfs[row] = '*'
//				dw_2.object.material_mfs.Edit.DisplayOnly = true
//			end if			
			
  		      DW_2.SETFOCUS()
		      F_MSG_MDI_HELP( F_MSG_ST(152 ))
			 
			 dw_2.setcolumn( 'receipt_qty')
			 
	case 'APPEND'		

			
	case 'DELETE'
		
		  	if DW_2.AcceptText() = -1 then
				return
			end if
			
			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
			IF MSG = 1 THEN
				Gvl_row_deleted = DW_2.GetRow()			
				DW_2.DELETEROW(Gvl_row_deleted)		
				DW_2.SetFocus()
				ROW = DW_2.GetRow()
				DW_2.ScrollToRow(row)
				DW_2.SetColumn(1)
			END IF		 
			
   case 'UPDATE'

//=============================================				
// Account System Interface 
//=============================================				

		if Gvs_interface_yn = 'N' then
			
				IF DW_2.UPDATE() < 0  THEN
				  	 ROLLBACK;
					 RETURN
				ELSE					
					
					COMMIT;
					F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
					F_RETRIEVE()				 
				end if
			
		else

				do
					i++
						//=================================
						// interface
						// return : work_no
						//=================================
						
//						lvi_return = sqlca.f_interface_receipt(   dw_2.object.receipt_date[i] , &
//																			dw_2.object.receipt_sequence[i], &
//																			'1' , &
//																			dw_2.object.line_type[i] , &									
//																			dw_2.object.supplier_code[i],  &
//																			dw_2.object.receipt_qty[i] * dw_2.object.unit_price[i] * dw_2.object.exchange_rate[i] , &
//																			dw_2.object.receipt_qty[i] * dw_2.object.unit_price[i],  &
//																			dw_2.object.exchange_rate[i], &
//																			dw_2.object.currency[i], &
//																			Gvs_user_id,&
//																			f_t_sysdate(),  &
//																			0 , &
//																			Gvi_organization_id ) ;
//																			
//																			
//						
//						if f_sql_check() < 0 then
//							return
//						end if ;
						
						if lvi_return < 0 then 
							Messagebox("Notify" , "Intrface Error")
							rollback;
							return
						elseif lvi_return  = 0 then
						else
							
									dw_2.object.interface_date[i] = f_t_sysdate()
									dw_2.object.interface_yn[i] = 'Y'
									dw_2.object.interface_work_no[i] = lvi_return
							
						end if					
					    j++
				loop until i = dw_2.rowcount( )
				dw_2.reset()
		end if		
//=============================================				

		     if j > 0 or i > 0 then 
					
				IF DW_2.UPDATE() < 0  THEN
				  	 ROLLBACK;
					 RETURN
				ELSE					
					
					//$$HEX20$$acc75cd6a9c6200085c7e0ac200074c7e0ac200090c7d9b320009ccde0ac7cc72000bdacb0c62000$$ENDHEX$$
					IF GVS_MATERIAL_RECYCLE_AUTO_ISSUE = 'Y' and  cbx_recycle_item.CHECKED = TRUE THEN 
						
						datetime lvdt_receipt_date
						double lvdb_sequence
						string lvs_line_code , lvs_workstage_code
						
						//===================================
						//
						//===================================						
						lvs_line_code  = tab_1.tabpage_1.ddlb_line_code.getcode( )
						lvs_workstage_code = tab_1.tabpage_1.ddlb_workstage_code.getcode( )
						
						if  lvs_line_code = '' or lvs_line_code= '%' or lvs_workstage_code = '' or lvs_workstage_code = '%' then
							Messagebox("Notify" , "Line code / Wortkstage Code Invalid!")
							return
						end if
						
						f_mat_receipt_auto_issue(  lvdt_receipt_date , lvdb_sequence , lvs_line_code , lvs_workstage_code ) 	 //$$HEX12$$68d518c2b4b0a9c6c6c54cc7200074c7c4d6200094cd00ac$$ENDHEX$$
						
					END IF 
					
					
					COMMIT;
					F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
					F_RETRIEVE()				 
				end if
			END IF

	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_other_receipt_master
integer y = 604
end type

type dw_4 from w_main_root`dw_4 within w_mat_other_receipt_master
integer y = 604
integer width = 3273
integer height = 928
boolean titlebar = true
string dataobject = "d_mat_receipt_invoice_rpt"
end type

type dw_3 from w_main_root`dw_3 within w_mat_other_receipt_master
integer y = 604
integer width = 3273
integer height = 928
boolean titlebar = true
string title = "Material Receipt List"
string dataobject = "d_mat_receipt_hst"
end type

type dw_2 from w_main_root`dw_2 within w_mat_other_receipt_master
integer x = 3282
integer y = 604
integer width = 1376
integer height = 2004
boolean titlebar = true
string dataobject = "d_mat_receipt_mst"
boolean hscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::clicked;call super::clicked;STRING LVS_ITEM_CODE , LVS_SUPPLIER_CODE

IF dwo.name = 'b_supplier' then 
	
	THIS.ACCEPTTEXT()
	LVS_ITEM_CODE = THIS.OBJECT.ITEM_CODE[ROW]
	
	OPENWITHPARM(W_MAT_SUPPLIER_BY_ITEM_CODE_POPUP,LVS_ITEM_CODE)
	
	IF MESSAGE.STRINGPARM = '' THEN 
	ELSE	
		
		THIS.OBJECT.SUPPLIER_CODE[ROW]  = MESSAGE.STRINGPARM
		TRIGGER EVENT ITEMCHANGED( ROW , THIS.OBJECT.SUPPLIER_CODE , THIS.OBJECT.SUPPLIER_CODE[ROW])		
		THIS.OBJECT.ITEM_CODE[ROW]  = 	Gst_return.gvs_return[2] 	
		TRIGGER EVENT ITEMCHANGED( ROW , THIS.OBJECT.item_code , THIS.OBJECT.item_code[ROW])						
		
		THIS.OBJECT.LINE_TYPE[ROW]  = 	Gst_return.gvs_return[3] 	
		TRIGGER EVENT ITEMCHANGED( ROW , THIS.OBJECT.LINE_TYPE , THIS.OBJECT.LINE_TYPE[ROW])					
		
	END IF
	
ELSEIF dwo.name = 'b_cost' then 	
	
	STRING lvs_set_item_code

	if THIS.getrow() < 1 then return
	
	lvs_set_item_code    = THIS.object.item_code[this.getrow()]
	if lvs_set_item_code = '' or isnull(lvs_set_item_code) then return
	
//	openwithparm( w_des_bom_cost_query_popup , lvs_set_item_code )
	
ELSEIF DWO.NAME = 'b_item' THEN 
	
    THIS.ACCEPTTEXT()
	LVS_SUPPLIER_CODE = THIS.OBJECT.SUPPLIER_CODE[ROW]
	Gst_return.Gvs_return[1]       = THIS.OBJECT.ITEM_CODE[ROW]
	
	OPENWITHPARM(W_MAT_UNIT_PRICE_POPUP,LVS_SUPPLIER_CODE)
	
	IF Gst_return.Gvb_return  = false THEN 
	ELSE	

		
		THIS.OBJECT.SUPPLIER_CODE[ROW]  = Gst_return.Gvs_return[2]

		THIS.OBJECT.ITEM_CODE[ROW]  = Gst_return.Gvs_return[4] 
		TRIGGER EVENT ITEMCHANGED( ROW , THIS.OBJECT.item_code , THIS.OBJECT.item_code[ROW])				
		
		THIS.OBJECT.DELIVERY[ROW]  = Gst_return.Gvs_return[5]
		THIS.OBJECT.LINE_TYPE[ROW]  = Gst_return.Gvs_return[6]
		TRIGGER EVENT ITEMCHANGED( ROW , THIS.OBJECT.line_type , THIS.OBJECT.line_type[ROW])	


	END IF	
		
END IF
end event

event dw_2::itemchanged;call super::itemchanged;DECIMAL LVF_UNIT_PRICE , LVF_MATERIAL_COST
string lvs_item_code , lvs_line_type , lvs_supplier_code
int lvi_count

IF DWO.NAME = 'location_code'  and gvs_material_mfs_replace_location_code = "Y"  THEN 

		THIS.OBJECT.MATERIAL_MFS[ROW] = THIS.OBJECT.LOCATION_CODE[ROW] 

ELSEIF DWO.NAME = 'supplier_code' THEN 
	
  IF F_CHECK_SUPPLIER_EXISTS( DATA ) < 1 then 
		F_MSGBOX(9042) //$$HEX19$$70ac98b720c12000c8b9a4c230d12000f8bbf1b45db8200070ac98b720c1200085c7c8b2e4b2$$ENDHEX$$
		THIS.OBJECT.SUPPLIER_CODE[ROW] = ''
		THIS.SETCOLUMN('supplier_code')
 		RETURN 1
	END IF	
   
	THIS.OBJECT.ITEM_CODE[ROW] = ''

ELSEIF DWO.NAME = 'item_code' THEN 
	
		IF F_CHECK_ITEM_EXISTS( DATA , f_t_sysdate() ) < 1 then 
			F_MSGBOX(9041) //$$HEX16$$80bd88d4c8b9a4c230d12000f8bbf1b45db8200080bd88d4200085c7c8b2e4b2$$ENDHEX$$
			THIS.OBJECT.ITEM_CODE[ROW] = ''
			THIS.SETCOLUMN('item_code')
			RETURN 1
		END IF		
		
		IF F_GET_ITEM_AUTO_ISSUE_YN(data,Gvi_organization_id) = 'Y' then
			
			THIS.OBJECT.MATERIAL_MFS[ROW] = '*'
	
		end if
		
ELSEIF DWO.NAME = 'line_type' or DWO.NAME = 'item_code'  or  DWO.NAME = 'supplier_code'  THEN 	
	
	THIS.OBJECT.DELIVERY[ROW] = ''
	THIS.OBJECT.CURRENCY[ROW]   = ''
	THIS.OBJECT.UNIT_PRICE[ROW] = 0 
	THIS.OBJECT.EXCHANGE_RATE[ROW]            = 0
	THIS.OBJECT.RECEIPT_AMT[ROW]                  = 0
	THIS.OBJECT.FOREIGN_RECEIPT_AMT[ROW] = 0
	THIS.OBJECT.MATERIAL_COST_AMT[ROW]     = 0
	
			IF DATA = 'M' THEN // $$HEX28$$6cad85c720c715d674c7200034bbc1c0acc009ae200078c7bdacb0c62000200085c7e0ac200098ccacb9200060d518c22000c6c54cc72000$$ENDHEX$$
			
				MESSAGEBOX("Notify" , "Free Subcontract Can`t Receipt. Use Free Subcontract Receipt Window")
				THIS.OBJECT.LINE_TYPE[ROW] = ''		
				RETURN 0
					
			ELSEIF  DATA = 'P' then 
				
				THIS.OBJECT.TARIFF_RATE[ROW] = f_get_tariff_rate( string(THIS.OBJECT.ITEM_CODE[ROW]))
				
			END IF	
		
			if Gvs_unit_price_check_yn = "Y" then //$$HEX9$$6cade4b9e8b200ac2000b4cc6cd074ba2000$$ENDHEX$$
				LVF_UNIT_PRICE = F_GET_ITEM_UNIT_PRICE_CONFIRM( this.object.supplier_code[row] , this.object.item_code[row] , this.object.line_type[row] , f_t_sysdate() )			
				
				IF LVF_UNIT_PRICE < 0 THEN 
					RETURN 0
				END IF
				
				IF LVF_UNIT_PRICE = 0 THEN 
					RETURN 0
				END IF		
				
				THIS.OBJECT.UNIT_PRICE[ROW] = LVF_UNIT_PRICE
				THIS.OBJECT.CURRENCY[ROW]   = Gst_return.Gvs_return[1]
				THIS.OBJECT.DELIVERY[ROW]     = Gst_return.gvs_return[2]	
				THIS.OBJECT.EXCHANGE_RATE[ROW]     = gst_return.gvf_return[1] 			
				
			else //$$HEX13$$6cade4b9e8b200ac200018c2d9b385c725b8200074c774ba2000$$ENDHEX$$
				THIS.OBJECT.UNIT_PRICE[ROW] = LVF_UNIT_PRICE
				THIS.OBJECT.CURRENCY[ROW]   = Gvs_currency
				THIS.OBJECT.DELIVERY[ROW]     = '2'
				THIS.OBJECT.EXCHANGE_RATE[ROW]     = 1
			end if 
//==================================================		
// $$HEX32$$85c725b81cb420007cb778c72000c0d085c7200058d5e0ac200088d4a9ba2000c8b9a4c230d120007cb778c7c0d085c744c7200044be50ad20005cd5e4b22000$$ENDHEX$$
//==================================================		
//		lvs_item_code = this.object.item_code[row]
//		select line_type 
//		into :lvs_line_type
//		from id_item
//		where item_code = :lvs_item_code
//		    and organization_id = :gvi_organization_id ;
//		
//		IF F_SQL_CHECK() < 0 THEN 
//	          RETURN 
//          END IF
//			 
//		 if lvs_line_type <> DATA then
//			F_MSGBOX1(9011,"Line Type Invalid")
//		end if
		
//==================================================		
//		
//==================================================		
ELSEIF DWO.NAME = 'receipt_qty' THEN
        
		IF   THIS.OBJECT.CURRENCY[ROW] = Gvs_currency THEN 
			THIS.OBJECT.FOREIGN_RECEIPT_AMT[ROW] = 0
		ELSE
			THIS.OBJECT.FOREIGN_RECEIPT_AMT[ROW] = THIS.OBJECT.UNIT_PRICE[ROW] * THIS.OBJECT.RECEIPT_QTY[ROW]
		END IF
		 
		THIS.OBJECT.RECEIPT_AMT[ROW]                  = THIS.OBJECT.UNIT_PRICE[ROW] * THIS.OBJECT.RECEIPT_QTY[ROW] * THIS.OBJECT.EXCHANGE_RATE[ROW] 
		THIS.OBJECT.TARIFF_AMT[ROW]                    = ROUND(THIS.OBJECT.RECEIPT_AMT[ROW]  * THIS.OBJECT.TARIFF_RATE[ROW]  / 100 , 3 )
		THIS.OBJECT.MATERIAL_COST_AMT[ROW]     = THIS.OBJECT.MATERIAL_COST[ROW] * THIS.OBJECT.RECEIPT_QTY[ROW]

    
	 
	 
elseif 	 DWO.NAME = 'INVOICE_NO' THEN
	
//========================================
//  invoice no check
//  $$HEX32$$a1c154d6e8b2200088bc38d6200000ac200074c7f8bb200085c7e0ac200015c8f4bcd0c52000e4b4b4c5200088c794b2c0c9200080acacc020005cd5e4b22000$$ENDHEX$$.
//========================================
	lvi_count = 0;
	
	lvs_item_code = this.object.item_code[row]
	lvs_supplier_code = this.object.supplier_code[row]
	
	select count(*) into :lvi_count 
	from im_item_receipt 
   where item_code = :lvs_item_code
	  and supplier_code = :lvs_supplier_code
	  and receipt_date >= trunc(sysdate -30)
	  and invoice_no = :data
      and organization_id = :gvi_organization_id ;
		
		  if f_sql_check() < 0 then 
			return 1
		  end if 
		  
	if lvi_count > 0 then 
		f_msgbox1(813 , lvs_item_code +" "+lvs_supplier_code )
		return 1
	end if 		
	
END IF


end event

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'origin_supplier_code' then 
	open(w_com_supplier_popup)
	if message.stringparm = '' then 
	else
		this.object.origin_supplier_code[row] = message.stringparm
		IF ivs_modify_security = 'Y' THEN 
			F_SET_SECURITY_ROW( THIS , ROW , 'MODIFY' )
		END IF		
//		this.trigger event itemchanged(row, this.object.origin_supplier_code, this.object.origin_supplier_code[row])
		
	end if
end if 
end event

type dw_1 from w_main_root`dw_1 within w_mat_other_receipt_master
integer y = 604
integer width = 3273
integer height = 928
boolean titlebar = true
string title = "Material Inventory List"
string dataobject = "d_mat_curr_inventory_4_etc_receipt_lst"
end type

event dw_1::itemchanged;call super::itemchanged;if dwo.name = 'receipt_qty' then 
	
	this.object.check_yn[row] = 'Y'
	
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_other_receipt_master
end type

type uo_dateset from uo_ymd_calendar within w_mat_other_receipt_master
event destroy ( )
integer x = 1696
integer y = 160
integer taborder = 30
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_other_receipt_master
event destroy ( )
integer x = 2112
integer y = 160
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type ddlb_item_code from uo_item_code within w_mat_other_receipt_master
integer x = 649
integer y = 160
integer width = 539
integer taborder = 20
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_other_receipt_master
integer x = 649
integer y = 80
integer width = 539
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_4 from so_statictext within w_mat_other_receipt_master
integer x = 1701
integer y = 80
integer width = 814
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Date"
end type

type rb_arrival from so_radiobutton within w_mat_other_receipt_master
integer x = 46
integer y = 80
integer width = 562
boolean bringtotop = true
integer weight = 700
string text = "Inventory List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true 
dw_2.bringtotop = true 
selected_data_window = dw_1



end event

type rb_receipt from so_radiobutton within w_mat_other_receipt_master
integer x = 46
integer y = 184
integer width = 562
boolean bringtotop = true
integer weight = 700
string text = "Receipt List"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3


end event

type ddlb_supplier_code from uo_supplier_code within w_mat_other_receipt_master
integer x = 1189
integer y = 160
integer width = 498
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mat_other_receipt_master
integer x = 1189
integer y = 80
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type cbx_recycle_item from so_checkbox within w_mat_other_receipt_master
integer x = 3035
integer y = 356
integer width = 544
boolean bringtotop = true
integer weight = 700
string text = "Recycle Item"
end type

type cbx_use_material_mfs from so_checkbox within w_mat_other_receipt_master
integer x = 3035
integer y = 440
integer width = 544
integer height = 80
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Use Material MFS"
end type

event constructor;call super::constructor;if Gvs_use_material_mfs = 'Y' then 
	this.checked = true 
else
	this.checked = false
end if
end event

type rb_all from so_radiobutton within w_mat_other_receipt_master
integer x = 4224
integer y = 80
integer width = 549
boolean bringtotop = true
integer weight = 700
string text = "All"
end type

event clicked;call super::clicked;dw_1.setfilter( '')
dw_1.filter( )
end event

type rb_gt from so_radiobutton within w_mat_other_receipt_master
integer x = 4224
integer y = 192
integer width = 549
boolean bringtotop = true
integer weight = 700
string text = "Inventory Qty > 0"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter('inventory_qty > 0 ')
dw_1.filter( )
end event

type sle_material_mfs from so_singlelineedit within w_mat_other_receipt_master
integer x = 2523
integer y = 160
integer width = 443
integer height = 84
integer taborder = 80
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

type material_mfs_t from so_statictext within w_mat_other_receipt_master
integer x = 2523
integer y = 88
integer width = 443
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "Material MFS"
end type

type tab_1 from tab within w_mat_other_receipt_master
event create ( )
event destroy ( )
integer y = 304
integer width = 2999
integer height = 288
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean fixedwidth = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2962
integer height = 160
long backcolor = 12632256
string text = "Process"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Regenerate5!"
long picturemaskcolor = 12632256
cbx_2 cbx_2
cb_2 cb_2
ddlb_workstage_code ddlb_workstage_code
st_7 st_7
st_6 st_6
ddlb_line_code ddlb_line_code
cbx_1 cbx_1
end type

on tabpage_1.create
this.cbx_2=create cbx_2
this.cb_2=create cb_2
this.ddlb_workstage_code=create ddlb_workstage_code
this.st_7=create st_7
this.st_6=create st_6
this.ddlb_line_code=create ddlb_line_code
this.cbx_1=create cbx_1
this.Control[]={this.cbx_2,&
this.cb_2,&
this.ddlb_workstage_code,&
this.st_7,&
this.st_6,&
this.ddlb_line_code,&
this.cbx_1}
end on

on tabpage_1.destroy
destroy(this.cbx_2)
destroy(this.cb_2)
destroy(this.ddlb_workstage_code)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.ddlb_line_code)
destroy(this.cbx_1)
end on

type cbx_2 from so_checkbox within tabpage_1
integer x = 27
integer y = 88
integer width = 741
integer height = 64
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Unit Price Check YN"
end type

event constructor;call super::constructor;if Gvs_unit_price_check_yn = 'Y' then 
	this.checked = true
else
	this.checked = false
	
end if 
end event

type cb_2 from commandbutton within tabpage_1
integer x = 2533
integer y = 64
integer width = 402
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Copy"
end type

event clicked;Datetime lvdt_null
setnull(lvdt_null)
if f_object_role_check() = false then return 

msg = f_msgbox1(1161 , this.text)
if msg = 1 then 
else
	return
end if

if dw_2.rowcount() < 1 then return 

dw_2.rowscopy(1, 1, Primary!, dw_2, 1, Primary!)

dw_2.object.receipt_sequence[1] = f_get_sequence( 'SEQ_MAT_RECEIPT')
dw_2.object.receipt_qty[1] = 0 


end event

type ddlb_workstage_code from uo_workstage_code_all within tabpage_1
integer x = 1856
integer y = 76
integer taborder = 70
boolean bringtotop = true
end type

type st_7 from so_statictext within tabpage_1
integer x = 1856
integer y = 4
integer width = 631
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Workstage Code"
end type

type st_6 from so_statictext within tabpage_1
integer x = 1225
integer y = 4
integer width = 626
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type ddlb_line_code from uo_line_code within tabpage_1
integer x = 1225
integer y = 76
integer width = 626
integer taborder = 60
boolean bringtotop = true
end type

type cbx_1 from so_checkbox within tabpage_1
integer x = 27
integer y = 16
integer width = 741
integer height = 64
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Recycle Auto Issue"
end type

event clicked;call super::clicked;if GVS_MATERIAL_RECYCLE_AUTO_ISSUE = 'Y' then
	
	this.checked = true
else
	this.checked = false
end if
end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2962
integer height = 160
long backcolor = 15780518
string text = "Print"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Print!"
long picturemaskcolor = 12632256
st_2 st_2
em_copy em_copy
cb_preview cb_preview
cb_print cb_print
cbx_dialog cbx_dialog
end type

on tabpage_2.create
this.st_2=create st_2
this.em_copy=create em_copy
this.cb_preview=create cb_preview
this.cb_print=create cb_print
this.cbx_dialog=create cbx_dialog
this.Control[]={this.st_2,&
this.em_copy,&
this.cb_preview,&
this.cb_print,&
this.cbx_dialog}
end on

on tabpage_2.destroy
destroy(this.st_2)
destroy(this.em_copy)
destroy(this.cb_preview)
destroy(this.cb_print)
destroy(this.cbx_dialog)
end on

type st_2 from so_statictext within tabpage_2
integer x = 32
integer y = 56
integer width = 311
integer height = 56
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Print Copy"
end type

type em_copy from so_editmask within tabpage_2
integer x = 357
integer y = 44
integer width = 311
integer taborder = 70
boolean bringtotop = true
string text = "1"
string mask = "##0"
boolean spin = true
end type

type cb_preview from so_commandbutton within tabpage_2
integer x = 677
integer y = 32
integer width = 361
integer height = 108
integer taborder = 70
boolean bringtotop = true
string text = "Preview"
end type

event clicked;call super::clicked;if rb_receipt.checked = true then 
	if  ivs_preview_yn = 'Y' THEN 
		ivs_preview_yn = 'N' 	
		dw_3.bringtotop = TRUE
	else
		ivs_preview_yn = 'Y' 	
		dw_4.bringtotop = TRUE	
		
		dw_4.retrieve( dw_3.object.receipt_lot_no[dw_3.getrow()] , gvi_organization_id )
			  
		if dw_4.Describe("DataWindow.Print.Preview") = '!' or dw_4.Describe("DataWindow.Print.Preview") = '?' then
		else
			 dw_4.Modify("DataWindow.Print.Preview=yes")
			dw_4.Modify("DataWindow.Print.Preview.Rulers=yes")
		end if		
	end if
end if
	
end event

type cb_print from so_commandbutton within tabpage_2
integer x = 1042
integer y = 32
integer width = 361
integer height = 108
integer taborder = 110
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;Int		i, lvi_cnt , rows

If dw_5.rowcount() < 1 Then Return

		lvi_cnt = Integer(em_copy.text)
		If lvi_cnt > 0 Then
			If rb_receipt.checked = True Then
				For i = 1 To lvi_cnt
					
					if cbx_dialog.checked = true then 
						dw_4.print(false, True)
					else
						dw_4.print(false, False)						
					end if
				Next
			End If
		End If

end event

type cbx_dialog from so_checkbox within tabpage_2
integer x = 1422
integer y = 40
integer width = 393
boolean bringtotop = true
integer weight = 700
long backcolor = 15780518
string text = "Show Dialog"
end type

type cbx_auto_invoice from so_checkbox within w_mat_other_receipt_master
integer x = 3035
integer y = 516
integer width = 544
integer height = 80
boolean bringtotop = true
integer weight = 700
string text = "Auto Invoice"
boolean checked = true
end type

type ddlb_location_code from uo_basecode within w_mat_other_receipt_master
integer x = 2971
integer y = 156
integer width = 640
integer taborder = 80
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type st_5 from so_statictext within w_mat_other_receipt_master
integer x = 2971
integer y = 80
integer width = 640
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Code"
end type

type pb_1 from so_commandbutton within w_mat_other_receipt_master
integer x = 3712
integer y = 324
integer taborder = 40
boolean bringtotop = true
string text = "Batch Receipt"
end type

event clicked;call super::clicked;Decimal lvf_receipt_qty
long ROW  , i = 1 
double LVDB_RCV_ISS_SEQ
String lvs_receipt_lot_no

if f_object_role_check() = false then return 

if dw_1.rowcount() < 1 then return 
msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else 
	return 
end if 

for i = 1 to dw_1.rowcount()
	
	if dw_1.object.check_yn[i] =  'Y'  then 
	else 
		continue 
	end if 	
	
	ROW= dw_2.insertrow(0)
	dw_2.scrolltorow(ROW)
	f_set_security_row(dw_2, ROW, 'ALL')

	//$$HEX34$$acc75cd6a9c6200085c7e0ac00ac200044c5c8b274ba1cc1200011d625b8acc0200054cfdcb400ac2000c6c594b2bdacb0c694b22000bdace0ac200054badcc2c0c92000$$ENDHEX$$
	if dw_1.object.supplier_code[i] = '*' AND cbx_recycle_item.checked = FALSE then
		f_msgbox1(111 ,  f_get_dual_lang_text( Gvs_language , "SUPPLIER CODE"))
	end if 
	
	DW_2.OBJECT.SUPPLIER_CODE[ROW] = DW_1.OBject.SUPPLIER_CODE[i]
	DW_2.OBJECT.ITEM_CODE[ROW] = DW_1.OBject.ITEM_CODE[i]

	DW_2.TRIGGER EVENT ITEMCHANGED( ROW , DW_2.OBJECT.item_code , DW_2.OBJECT.item_code[ROW])						
	DW_2.OBJECT.LINE_TYPE[ROW] = DW_1.OBject.LINE_TYPE[i]
	DW_2.TRIGGER EVENT ITEMCHANGED( ROW , DW_2.OBJECT.LINE_TYPE , DW_2.OBJECT.LINE_TYPE[ROW])										
	
	DW_2.SETITEM( ROW , 'RECEIPT_DATE' , F_T_SYSDATE() )
	dw_2.object.receipt_sequence[row] = double(f_get_sequence('seq_mat_receipt'))	

	if Gvs_material_receipt_auto_confirm = 'Y' then
		
		dw_2.object.confirm_yn[row] = 'Y'
		dw_2.object.confirm_date[row] = f_t_sysdate()
	else
		dw_2.object.confirm_yn[row] = 'N'
	end if 
	
	if cbx_auto_invoice.checked = true then 
		DW_2.OBJECT.invoice_no[ROW] = string(F_T_SYSDATE(),'yyyymmdd')+string(LVDB_RCV_ISS_SEQ)
		lvs_receipt_lot_no = string(F_T_SYSDATE(),'yyyymmdd')+string(LVDB_RCV_ISS_SEQ)
	end if 
		
	DW_2.SETITEM( ROW , 'CURRENCY' , GVS_CURRENCY )
	DW_2.SETITEM( ROW , 'DELIVERY' , '2')		
	DW_2.SETITEM( ROW , 'MFS' , '*')			
	DW_2.SETITEM( ROW , 'ORDER_NO' , '*')			
	
	DW_2.SETITEM( ROW , 'LOCATION_CODE' , string(dw_1.object.location_code[i] ))			
	DW_2.SETITEM( ROW , 'MATERIAL_MFS' ,string(dw_1.object.MATERIAL_MFS[i] ))			

	DW_2.SETITEM( ROW , 'EXCHANGE_RATE' ,1)							
	//==============================================
     if 	dw_1.object.receipt_qty[i] < 0 THEN 
		dw_2.object.receipt_deficit[ROW] = '2'		
	else
		dw_2.object.receipt_deficit[ROW] = '1'
	end if
	
	DW_2.SETITEM( ROW , 'RECEIPT_STATUS' , 'N' ) //$$HEX5$$85c7e0acc1c0dcd02000$$ENDHEX$$N $$HEX3$$15c8c1c02000$$ENDHEX$$, C $$HEX2$$e8cd8cc1$$ENDHEX$$
	DW_2.SETITEM( ROW , 'VIRTUAL_RECEIPT_YN' , 'N' ) //$$HEX6$$00ac85c7e0ac20006cad84bd$$ENDHEX$$
	DW_2.OBJECT.RECEIPT_LOT_NO[ROW] = lvs_receipt_lot_no
	DW_2.OBJECT.INTERFACE_YN[ROW] = 'N'
	DW_2.OBJECT.ORDER_TYPE[ROW] = 'M'	
	dw_2.object.receipt_type[row] = 'E'
	DW_2.OBJECT.RECEIPT_QTY[ROW] = DW_1.OBject.RECEIPT_QTY[i]
	DW_2.TRIGGER EVENT ITEMCHANGED( ROW , DW_2.OBJECT.RECEIPT_QTY , string(DW_2.OBJECT.RECEIPT_QTY[ROW]))
next
end event

type pb_2 from so_commandbutton within w_mat_other_receipt_master
integer x = 3712
integer y = 452
integer taborder = 50
boolean bringtotop = true
string text = "Import From Excel"
end type

event clicked;call super::clicked;open(w_mat_material_receipt_excel_form_popup)
end event

type sle_invoice_no from so_singlelineedit within w_mat_other_receipt_master
integer x = 3621
integer y = 156
integer width = 526
integer height = 84
integer taborder = 90
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
//STRING LVS_VALUE , LVS_COLUMN
//
//DW_3.SETFILTER('')
//DW_3.FILTER()
//
//LVS_COLUMN = 'RECEIPT_LOT_NO'
//IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
//	RETURN 
//END IF
//
//IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
//    DW_3.SETFILTER('')
//    DW_3.FILTER()	
//    RETURN
//ELSE
//	LVS_VALUE = '%'+this.text+'%'
//END IF
//
//DW_3.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
//DW_3.FILTER()
//F_MSG_MDI_HELP( STRING( DW_3.ROWCOUNT() ) + " Found" )
end event

type st_invoice_no from so_statictext within w_mat_other_receipt_master
integer x = 3621
integer y = 76
integer width = 526
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Invoice No"
end type

type gb_2 from so_groupbox within w_mat_other_receipt_master
integer x = 626
integer width = 3552
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_other_receipt_master
integer x = 9
integer width = 613
integer height = 300
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_5 from so_groupbox within w_mat_other_receipt_master
integer x = 4187
integer width = 645
integer height = 300
integer taborder = 60
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type

type gb_4 from so_groupbox within w_mat_other_receipt_master
integer x = 3013
integer y = 300
integer width = 613
integer height = 300
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Option"
end type


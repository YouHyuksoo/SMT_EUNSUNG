HA$PBExportHeader$w_mat_inventory_check_master.srw
$PBExportComments$Material Inventory Check Master
forward
global type w_mat_inventory_check_master from w_main_root
end type
type st_1 from so_statictext within w_mat_inventory_check_master
end type
type ddlb_item_code from uo_item_code within w_mat_inventory_check_master
end type
type em_yyyymm from uo_ym within w_mat_inventory_check_master
end type
type st_2 from so_statictext within w_mat_inventory_check_master
end type
type cb_check from so_commandbutton within w_mat_inventory_check_master
end type
type rb_inventory_list from so_radiobutton within w_mat_inventory_check_master
end type
type rb_adjust_list from so_radiobutton within w_mat_inventory_check_master
end type
type st_5 from so_statictext within w_mat_inventory_check_master
end type
type cbx_show_dialog from so_checkbox within w_mat_inventory_check_master
end type
type em_1 from so_editmask within w_mat_inventory_check_master
end type
type cb_preview from so_commandbutton within w_mat_inventory_check_master
end type
type cb_print from so_commandbutton within w_mat_inventory_check_master
end type
type cb_1 from so_commandbutton within w_mat_inventory_check_master
end type
type cbx_check_qty_auto_set from checkbox within w_mat_inventory_check_master
end type
type cbx_regenerate from checkbox within w_mat_inventory_check_master
end type
type cbx_inventory_close from checkbox within w_mat_inventory_check_master
end type
type ddlb_location_code from uo_basecode within w_mat_inventory_check_master
end type
type st_4 from so_statictext within w_mat_inventory_check_master
end type
type cb_2 from so_commandbutton within w_mat_inventory_check_master
end type
type ddlb_customer_code from uo_customer_code_name within w_mat_inventory_check_master
end type
type st_3 from so_statictext within w_mat_inventory_check_master
end type
type sle_material_mfs from so_singlelineedit within w_mat_inventory_check_master
end type
type st_6 from so_statictext within w_mat_inventory_check_master
end type
type gb_1 from so_groupbox within w_mat_inventory_check_master
end type
type gb_2 from so_groupbox within w_mat_inventory_check_master
end type
type gb_3 from so_groupbox within w_mat_inventory_check_master
end type
type gb_4 from so_groupbox within w_mat_inventory_check_master
end type
end forward

global type w_mat_inventory_check_master from w_main_root
integer width = 4919
integer height = 2824
string title = "Material Inventory Check"
st_1 st_1
ddlb_item_code ddlb_item_code
em_yyyymm em_yyyymm
st_2 st_2
cb_check cb_check
rb_inventory_list rb_inventory_list
rb_adjust_list rb_adjust_list
st_5 st_5
cbx_show_dialog cbx_show_dialog
em_1 em_1
cb_preview cb_preview
cb_print cb_print
cb_1 cb_1
cbx_check_qty_auto_set cbx_check_qty_auto_set
cbx_regenerate cbx_regenerate
cbx_inventory_close cbx_inventory_close
ddlb_location_code ddlb_location_code
st_4 st_4
cb_2 cb_2
ddlb_customer_code ddlb_customer_code
st_3 st_3
sle_material_mfs sle_material_mfs
st_6 st_6
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_mat_inventory_check_master w_mat_inventory_check_master

type variables
string ivs_preview_yn
end variables

on w_mat_inventory_check_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_item_code=create ddlb_item_code
this.em_yyyymm=create em_yyyymm
this.st_2=create st_2
this.cb_check=create cb_check
this.rb_inventory_list=create rb_inventory_list
this.rb_adjust_list=create rb_adjust_list
this.st_5=create st_5
this.cbx_show_dialog=create cbx_show_dialog
this.em_1=create em_1
this.cb_preview=create cb_preview
this.cb_print=create cb_print
this.cb_1=create cb_1
this.cbx_check_qty_auto_set=create cbx_check_qty_auto_set
this.cbx_regenerate=create cbx_regenerate
this.cbx_inventory_close=create cbx_inventory_close
this.ddlb_location_code=create ddlb_location_code
this.st_4=create st_4
this.cb_2=create cb_2
this.ddlb_customer_code=create ddlb_customer_code
this.st_3=create st_3
this.sle_material_mfs=create sle_material_mfs
this.st_6=create st_6
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_item_code
this.Control[iCurrent+3]=this.em_yyyymm
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cb_check
this.Control[iCurrent+6]=this.rb_inventory_list
this.Control[iCurrent+7]=this.rb_adjust_list
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.cbx_show_dialog
this.Control[iCurrent+10]=this.em_1
this.Control[iCurrent+11]=this.cb_preview
this.Control[iCurrent+12]=this.cb_print
this.Control[iCurrent+13]=this.cb_1
this.Control[iCurrent+14]=this.cbx_check_qty_auto_set
this.Control[iCurrent+15]=this.cbx_regenerate
this.Control[iCurrent+16]=this.cbx_inventory_close
this.Control[iCurrent+17]=this.ddlb_location_code
this.Control[iCurrent+18]=this.st_4
this.Control[iCurrent+19]=this.cb_2
this.Control[iCurrent+20]=this.ddlb_customer_code
this.Control[iCurrent+21]=this.st_3
this.Control[iCurrent+22]=this.sle_material_mfs
this.Control[iCurrent+23]=this.st_6
this.Control[iCurrent+24]=this.gb_1
this.Control[iCurrent+25]=this.gb_2
this.Control[iCurrent+26]=this.gb_3
this.Control[iCurrent+27]=this.gb_4
end on

on w_mat_inventory_check_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_item_code)
destroy(this.em_yyyymm)
destroy(this.st_2)
destroy(this.cb_check)
destroy(this.rb_inventory_list)
destroy(this.rb_adjust_list)
destroy(this.st_5)
destroy(this.cbx_show_dialog)
destroy(this.em_1)
destroy(this.cb_preview)
destroy(this.cb_print)
destroy(this.cb_1)
destroy(this.cbx_check_qty_auto_set)
destroy(this.cbx_regenerate)
destroy(this.cbx_inventory_close)
destroy(this.ddlb_location_code)
destroy(this.st_4)
destroy(this.cb_2)
destroy(this.ddlb_customer_code)
destroy(this.st_3)
destroy(this.sle_material_mfs)
destroy(this.st_6)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
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
Ivs_resize_type                      = 'NORMAL'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )


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
F_MENU_CONTROL('DATA_CONTROL_MODIFY' , TRUE)  // All Data Control





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
			if rb_inventory_list.checked = true then 
				
				dw_1.setredraw(  false)
				
				dw_1.retrieve(em_yyyymm.text, ddlb_item_code.text() + '%', ddlb_location_code.getcode( )+'%' , sle_material_mfs.text+'%' ,   gvi_organization_id)
				dw_1.setredraw(  true)
else
				dw_2.retrieve( f_get_first_day_by_month(em_yyyymm.text)  , f_get_last_day_by_month(em_yyyymm.text) , ddlb_item_code.text() + '%',  gvi_organization_id)				
			end if
		
//	case 'INSERT'
//		
//			DW_2.ENABLED = TRUE
//			ROW = DW_2.INSERTROW(DW_2.GETROW())
//			DW_2.SCROLLTOROW(ROW)
//			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')
//			dw_2.object.dateset[row] = f_t_sysdate()
//			dw_2.object.dateend[row] = date('2999-12-31')
//			
//	case 'APPEND'		
//			DW_2.ENABLED = TRUE
//			ROW = DW_2.INSERTROW(DW_2.GETROW())
//			DW_2.SCROLLTOROW(ROW)
//			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')	
//			dw_2.object.dateset[row] = f_t_sysdate()
//			dw_2.object.dateend[row] = date('2999-12-31')
//			
//	case 'DELETE'
//		
//		  	if DW_1.AcceptText() = -1 then
//				return
//			end if
//			
//			MSG = F_MSGBOX(1003)  //$$HEX8$$adc01cc858d5dcc2a0acb5c2c8b24cae$$ENDHEX$$?
//			IF MSG = 1 THEN
//				Gvl_row_deleted = DW_1.GetRow()			
//				DW_1.DELETEROW(Gvl_row_deleted)		
//				DW_1.SetFocus()
//				ROW = DW_1.GetRow()
//				DW_1.ScrollToRow(row)
//				DW_1.SetColumn(1)
//			END IF
	case 'UPDATE'
		
			IF DW_1.UPDATE() < 0  THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
             //  F_RETRIEVE()
	case else
end choose

end event

type dw_5 from w_main_root`dw_5 within w_mat_inventory_check_master
integer y = 588
end type

type dw_4 from w_main_root`dw_4 within w_mat_inventory_check_master
integer y = 588
end type

type dw_3 from w_main_root`dw_3 within w_mat_inventory_check_master
integer y = 588
integer width = 4535
integer height = 2208
boolean titlebar = true
string dataobject = "d_mat_inventory_check_rpt"
end type

type dw_2 from w_main_root`dw_2 within w_mat_inventory_check_master
integer y = 588
integer width = 4535
integer height = 2208
boolean titlebar = true
string title = "Adjust List"
string dataobject = "d_mat_issue_by_adjust_lst"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

event dw_2::rbuttondown;call super::rbuttondown;if dwo.name = 'supplier_code' then 
	open(w_com_supplier_popup)
	if message.stringparm = '' then 
	else
		this.object.supplier_code[row] = message.stringparm
		
	end if 
end if 
end event

type dw_1 from w_main_root`dw_1 within w_mat_inventory_check_master
integer y = 588
integer width = 4535
integer height = 1948
boolean titlebar = true
string title = "Material Inventory Check List"
string dataobject = "d_mat_inventory_check_lst"
end type

event dw_1::itemchanged;if dwo.name = 'check_inventory_qty' then 
	this.object.difference_qty[row] = this.object.inventory_qty[row] -  this.object.check_inventory_qty[row] 
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mat_inventory_check_master
end type

type st_1 from so_statictext within w_mat_inventory_check_master
integer x = 1161
integer y = 96
integer width = 494
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_inventory_check_master
integer x = 1161
integer y = 164
integer width = 494
integer taborder = 20
boolean bringtotop = true
end type

type em_yyyymm from uo_ym within w_mat_inventory_check_master
integer x = 832
integer y = 160
integer taborder = 20
boolean bringtotop = true
end type

type st_2 from so_statictext within w_mat_inventory_check_master
integer x = 832
integer y = 96
integer width = 325
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "YYYYMM"
end type

type cb_check from so_commandbutton within w_mat_inventory_check_master
integer x = 3077
integer y = 396
integer width = 448
integer height = 112
integer taborder = 30
boolean bringtotop = true
string text = "Adjust"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 
if dw_1.rowcount() < 1 then return 

long   lvl_seq, i , j 
string lvs_location_code, lvs_item_code , lvs_deficit , lvs_material_mfs , lvs_line_type , lvs_yyyymm  , lvs_inventory_type
decimal lvf_qty , lvf_inventory_price


msg = f_msgbox1(1161,this.text)
if msg  = 1 then 
else 
	return 
end if 

dw_1.accepttext()
lvs_yyyymm = em_yyyymm.text

//if dw_1.update() < 0 then 
//	Messagebox("Error" , "Data Save Error")
//	return
//end if 

open(w_progress_popup)
w_progress_popup.f_set_range( 1 , dw_1.rowcount( ))
w_progress_popup.f_setstep(1)

for i = 1 to dw_1.rowcount() 
	
	if dw_1.object.difference_qty[i] <> 0  then 
		
		lvl_seq = f_get_sequence('seq_mat_issue')
		
		lvs_location_code = dw_1.object.location_code[i]
		
		lvf_qty = dw_1.object.difference_qty[i] 
		
		lvs_item_code = dw_1.object.item_code[i]
		lvs_material_mfs= dw_1.object.material_mfs[i]
		lvs_line_type= dw_1.object.line_type[i]
//		lvf_inventory_price = dw_1.object.inventory_price[i]

//======================================================
//
//======================================================
         select inventory_type into :lvs_inventory_type 
		 from im_item_inventory
	   where material_mfs  = :lvs_material_mfs 
		   and organization_id = :gvi_organization_id  ;
			
		if f_sql_check() <  0 then 
			return 
		end if 			
		
		IF lvf_qty >  0 THEN 

			lvs_deficit =  '3'
					
		//====================================================
		// $$HEX13$$9ccde0ac200044c6ccb820000cd598b7f8ad200024c115c82000$$ENDHEX$$
		//====================================================
			UPDATE IM_ITEM_RECEIPT_BARCODE
					SET  receipt_compare_yn = 'Y' , 
					        ISSUE_COMPARE_YN = 'Y' ,
							ISSUE_COMPARE_DATE =  F_GET_INVENTORY_CLOSE_DATE(:lvs_yyyymm , 'END' , :gvi_organization_id )  , 
							ISSUE_COMPARE_BY = 'ADJUST' ,
							ISSUE_RETURN_YN = 'N' ,
							FEEDING_YN = 'Y' 
							
			  WHERE  LOT_NO = :lvs_material_mfs
					  AND  ITEM_CODE = :LVS_ITEM_CODE
					 AND ORGANIZATION_ID = :GVI_ORganization_id ;
					 
			  if f_sql_check() <  0 then 
				return 
		      end if 			
			
			
		ELSE
			lvs_deficit =  '4'			
			
			UPDATE IM_ITEM_RECEIPT_BARCODE
					SET    receipt_compare_yn = 'Y' , 
					         ISSUE_COMPARE_YN = 'N' ,
							ISSUE_COMPARE_DATE = NULL  , 
							ISSUE_COMPARE_BY = NULL ,
							ISSUE_RETURN_YN = 'Y' ,
							ISSUE_RETURN_DATE =  F_GET_INVENTORY_CLOSE_DATE(:lvs_yyyymm , 'END' , :gvi_organization_id )  ,
							FEEDING_YN = 'N' ,
							FEEDING_DATE = NULL // MSL $$HEX37$$08cdfcac2000dcc204ac2000c4acb0c0dcc22000acc0a9c6200018b4c0bb5cb8200070c815c8200018c288bdd0c5200058c75cd5200083ac40c7200008cd30ae54d62000dcc2b4d02000$$ENDHEX$$
			  WHERE  LOT_NO = :lvs_material_mfs
					  AND  ITEM_CODE = :LVS_ITEM_CODE
					 AND ORGANIZATION_ID = :GVI_ORganization_id ;
					 
			  if f_sql_check() <  0 then 
				return 
		      end if 						
			
		END IF
		
	  INSERT INTO IM_ITEM_ISSUE  
				( ISSUE_DATE,   
				  ISSUE_SEQUENCE,   
				  ORGANIZATION_ID,   
				  MFS,   
				  ITEM_CODE,   
				  LOCATION_CODE,   
				  ITEM_TYPE,   
				  LINE_CODE,   
				  WORKSTAGE_CODE,   
				  ISSUE_DEFICIT,   
				  ISSUE_QTY,   
				  ISSUE_STATUS,   
				  ISSUE_AMT,   
				  ISSUE_ACCOUNT,   
				  LINE_TYPE,   
				  COMMENTS,   
				  ISSUE_PRICE,   
				  VIRTUAL_RECEIPT_YN,   
				  ISSUE_TYPE,   
				  SUPPLIER_CODE,   
				  WORK_ORDER_NO,   
				  ENTER_DATE,   
				  ENTER_BY,   
				  LAST_MODIFY_DATE,   
				  LAST_MODIFY_BY,   
				  MACHINE_CODE,   
				  INVOICE_NO,   
				  MADE_BY,   
				  PARENT_ITEM_CODE,   
				  MATERIAL_MFS, 
				  INVENTORY_TYPE )  
			  
      VALUES ( F_GET_INVENTORY_CLOSE_DATE(:lvs_yyyymm , 'END' , :gvi_organization_id ) ,
				  :lvl_seq ,  
				  :gvi_organization_id,   
				  :lvs_material_mfs , //MFS,   
				  :lvs_item_code , //ITEM_CODE,   
				  :lvs_location_code , //LOCATION_CODE,   
				  'T' , //ITEM_TYPE,   
				  '*',   
				  '*',   
				  :lvs_deficit , //ISSUE_DEFICIT,   
				  :lvf_qty ,    //ISSUE_QTY,   
				  'N' , //ISSUE_STATUS,   
				   :lvf_inventory_price * :lvf_qty ,  //ISSUE_AMT,   
				  'M009' , //ISSUE_ACCOUNT,   $$HEX7$$acc7e0ac70c815c82000c4ac15c8$$ENDHEX$$
				  :LVS_LINE_TYPE , //LINE_TYPE,   
				  'INVENTORY ADJUST' , //'COMMENTS,   
				  :lvf_inventory_price , //ISSUE_PRICE,   
				  'N' , //VIRTUAL_RECEIPT_YN,   
				  'E' , //ISSUE_TYPE,   
				  '*' , //SUPPLIER_CODE,   
				  0 , //WORK_ORDER_NO,   
				   F_GET_INVENTORY_CLOSE_DATE(:lvs_yyyymm , 'LAST' , :gvi_organization_id )  , //ENTER_DATE,   
				  :GVS_USER_ID , //ENTER_BY,   
				  SYSDATE , //LAST_MODIFY_DATE,   
				  :GVS_USER_ID , //LAST_MODIFY_BY,   
				  '*' , //MACHINE_CODE,   
				  '*' , //INVOICE_NO,   
				  '*' ,  //MADE_BY,   
				  '*' ,  //PARENT_ITEM_CODE,   
				  :lvs_material_mfs , //MATERIAL_MFS		
				  :lvs_inventory_type
) ;				  

		if f_sql_check() < 0 then 
			Close(w_progress_popup)
			return 
		end if
		
		dw_1.object.inventory_qty[i] = dw_1.object.check_inventory_qty[i]
		dw_1.object.difference_qty[i] = dw_1.object.check_inventory_qty[i] - 	dw_1.object.inventory_qty[i]
	//	dw_1.object.inventory_amt[i] = dw_1.object.check_inventory_qty[i] * dw_1.object.inventory_price[i] 
		
		j++
	else
		continue
	end if 
	
	w_progress_popup.f_stepit()
next
Close(w_progress_popup)

//update im_item_inventory_check  set inventory_amt = inventory_qty * inventory_price
//where close_yyyymm = :lvs_yyyymm
//and organization_id = :gvi_organization_id ;
//
//if f_sql_check() < 0 then return 

//if j > 0 then 
//	msg = f_msgbox1(9014,string(j))
//	if msg = 1 then 
//		if dw_1.update() < 0 then 
//			rollback ; 
//			f_msg_mdi_help(f_msg_st(9026))
//		else
			commit ; 
			f_msg_mdi_help(f_msg_st(170))
//			f_retrieve()
//		end if 
//	else 
//		rollback ; 
//		f_msg_mdi_help(f_msg_st(9026))
//	end if 
//end if
	
////=================================
//// $$HEX8$$acc7e0ac2000c8b910ac2000e4c289d5$$ENDHEX$$
////=================================
//if cbx_inventory_close.checked = true then 
//	
	int lvi_return 
	lvs_yyyymm = em_yyyymm.text
	
	lvi_return = f_mat_inventory_close_location(lvs_yyyymm)
	if lvi_return < 0  then 	
		messagebox('Notify','The process of company inventory close is failure, please try it again.')
		rollback ; 
	else 
	
		commit ; 
		f_msgbox( 170)	
	end if 
		
//end if
			
end event

type rb_inventory_list from so_radiobutton within w_mat_inventory_check_master
integer x = 105
integer y = 84
integer width = 567
boolean bringtotop = true
integer weight = 700
string text = "Inventory List"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
selected_data_window = dw_1
end event

type rb_adjust_list from so_radiobutton within w_mat_inventory_check_master
integer x = 105
integer y = 200
integer width = 567
boolean bringtotop = true
integer weight = 700
string text = "Adjust List"
end type

event clicked;call super::clicked;dw_2.bringtotop = true
selected_data_window = dw_2
end event

type st_5 from so_statictext within w_mat_inventory_check_master
integer x = 3621
integer y = 100
integer width = 343
integer height = 56
boolean bringtotop = true
integer weight = 700
boolean enabled = false
string text = "Print Copy"
end type

type cbx_show_dialog from so_checkbox within w_mat_inventory_check_master
integer x = 3653
integer y = 184
integer width = 389
boolean bringtotop = true
integer weight = 700
string text = "Show Dialog"
end type

type em_1 from so_editmask within w_mat_inventory_check_master
integer x = 4064
integer y = 76
integer width = 265
integer height = 84
integer taborder = 40
boolean bringtotop = true
string text = "1"
string mask = "#"
boolean spin = true
double increment = 1
end type

type cb_preview from so_commandbutton within w_mat_inventory_check_master
integer x = 4357
integer y = 64
integer width = 375
integer height = 112
integer taborder = 40
boolean bringtotop = true
string text = "Preview"
end type

event clicked;call super::clicked;      IF ivs_preview_yn = 'Y' THEN 
		   ivs_preview_yn = 'N' 	
		   dw_1.bringtotop = TRUE
	ELSE
	   ivs_preview_yn = 'Y' 	
	   dw_3.bringtotop = TRUE
	  	
       dw_3.retrieve(em_yyyymm.text, ddlb_item_code.text() + '%',  gvi_organization_id)
	   if dw_3.getrow() < 1 then return			 
		
		if dw_3.Describe("DataWindow.Print.Preview") = '!' or dw_3.Describe("DataWindow.Print.Preview") = '?' then
		else
			dw_3.Modify("DataWindow.Print.Preview=yes")
			dw_3.Modify("DataWindow.Print.Preview.Rulers=yes")
		end if

	     f_set_preview_zoom( selected_window , 	dw_3 )
		
	END IF


end event

type cb_print from so_commandbutton within w_mat_inventory_check_master
integer x = 4357
integer y = 180
integer width = 375
integer height = 112
integer taborder = 50
boolean bringtotop = true
string text = "Print"
end type

event clicked;call super::clicked;Int		i, lvi_cnt 
	
	    dw_3.retrieve(em_yyyymm.text, ddlb_item_code.text() + '%',  gvi_organization_id)
	    If dw_3.rowcount() < 1 Then Return

		lvi_cnt = Integer(em_1.text)
		If lvi_cnt > 0 Then
	
				For i = 1 To lvi_cnt
					
					if cbx_show_dialog.checked = true then 
						dw_3.print(false, True)
					else
						dw_3.print(false, False)						
					end if
				Next
		End If

end event

type cb_1 from so_commandbutton within w_mat_inventory_check_master
integer x = 2181
integer y = 396
integer width = 448
integer height = 112
integer taborder = 30
boolean bringtotop = true
string text = "Generate"
end type

event clicked;call super::clicked;if f_object_role_check() = false then return 

string lvs_yyyymm, lvs_item_code , lvs_check_qty_auto_set , lvs_customer_code
int lvi_cnt

lvs_yyyymm = em_yyyymm.text 
lvs_item_code = ddlb_item_code.text() + '%'
lvs_customer_code = ddlb_customer_code.getcode()+'%' 

msg = f_msgbox1(1161,lvs_yyyymm+' : '+this.text)
if msg = 1 then 
else 
	return 
end if 

if cbx_check_qty_auto_set.checked = true THEN
	lvs_check_qty_auto_set = 'Y'
else
	lvs_check_qty_auto_set = 'N'	
end if

//================================================
//
//================================================
     select count(*)
  	    into  :lvi_cnt
	  from im_item_inventory_close
	where  close_yyyymm = :lvs_yyyymm 
	   and item_code like :lvs_item_code 
	    and organization_id = :gvi_organization_id
	//    and item_code in ( select item_code from id_item where customer_code like :lvs_customer_code ) 	
	 ; 
	
	if f_sql_check() < 0 then return 
	if lvi_cnt < 1 then 
		messagebox('Notify','This item is not found in the item inventory close mfs Master.')
		return 
	end if 

//================================================
//
//================================================	
STRING LVS_CLOSE_YYYYMM 

LVS_CLOSE_YYYYMM = em_yyyymm.text 
LVS_CUSTOMER_CODE = DDLB_CUSTOMER_CODE.GETCODE()+'%' 

DELETE FROM IM_ITEM_INVENTORY_CHECK_EXCEL 
WHERE CLOSE_YYYYMM     = :LVS_CLOSE_YYYYMM 
 //    AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE CUSTOMER_CODE LIKE :LVS_CUSTOMER_CODE ) 
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	  
if f_sql_check() < 0 then
	return 
end if 

  INSERT INTO IM_ITEM_INVENTORY_CHECK_EXCEL  
         ( CLOSE_YYYYMM,   
           ITEM_CODE,   
           LINE_TYPE,   
           MATERIAL_MFS,   
           ORGANIZATION_ID,   
           CHECK_INVENTORY_QTY,   
           LOCATION_CODE )  
  SELECT CHECK_YYYYMM,   
           ITEM_CODE,   
           F_GET_LINE_TYPE_FROM_ITEM( ITEM_CODE , ORGANIZATION_ID ) ,   
           LOT_NO,   
           ORGANIZATION_ID,   
           BARCODE_QTY  ,   
           LOCATION_CODE 
 FROM IM_ITEM_INVENTORY_CHECK_BCD
WHERE CHECK_YYYYMM = :LVS_CLOSE_YYYYMM 
//    AND ITEM_CODE IN ( SELECT ITEM_CODE FROM ID_ITEM WHERE CUSTOMER_CODE LIKE :LVS_CUSTOMER_CODE ) 
    AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	
if f_sql_check() < 0 then
	return 
end if 

//commit ;
	
//================================================
//
//================================================
if Gvs_material_mfs_replace_location_code =  'Y'  then
		if cbx_regenerate.checked = true then	
			//================================================
			//
			//================================================
		   delete from im_item_inventory_check 
		   where close_yyyymm = :lvs_yyyymm 
			  and  organization_id = :gvi_organization_id
		//	  and item_code in ( select item_code from id_item where customer_code like :lvs_customer_code ) 
		; 
			  
			if f_sql_check() < 0 then return 
			
			insert into im_item_inventory_check 
					  (close_yyyymm,                              
					material_mfs , 
					item_code,                                    
					inventory_hold,                              
					line_type,
					inventory_qty,                                
					check_inventory_qty,                   
					inventory_price,
					inventory_amt,                               
					location_code,                              
					comments,                                      
					organization_id,
					enter_by,                                        
					enter_date,                                    
					last_modify_by,
					last_modify_date)
			select  :lvs_yyyymm,                               
					location_code  , //material_mfs ,  
					a.item_code,                                 
					'N',                               
					a.line_type,
					sum(a.mm_inventory_qty),   
					sum(decode(:lvs_check_qty_auto_set , 'Y',    a.mm_inventory_qty , 0 )),
					avg(a.mm_avg_price),
					sum(a.mm_inventory_amt),  
					location_code,                           
					'*' ,                                   
					:gvi_organization_id, 
					:gvs_user_id,                                 
					sysdate,                                       
					:gvs_user_id,
					 sysdate
			from    im_item_inventory_close_mfs a 
			  where a.item_code like :lvs_item_code 
				 and a.close_yyyymm = :lvs_yyyymm
				 and a.organization_id = :gvi_organization_id 
			//	 and a.item_code in ( select item_code from id_item where customer_code like :lvs_customer_code ) 	
			group by a.close_yyyymm,a.item_code,a.line_type,a.location_code ,a.organization_id, a.material_mfs ;
			
			if f_sql_check() < 0 then return 
			
				if sqlca.sqlnrows = 0 then
					f_msg_mdi_help('No data fouond')
					rollback;
				else
					msg = f_msgbox(1170)
					if msg = 1 then
						f_msg_mdi_help('Processed Complete')
						commit;
					else
						f_msg_mdi_help('Processed Cancel!')
						rollback;
					end if 
				end if 
			
			else
				
			//================================================
			//
			//================================================
			insert into im_item_inventory_check 
					  (close_yyyymm,                              
					material_mfs , 
					item_code,                                    
					inventory_hold,                              
					line_type,
					inventory_qty,                                
					check_inventory_qty,                   
					inventory_price,
					inventory_amt,                               
					location_code,                              
					comments,                                      
					organization_id,
					enter_by,                                        
					enter_date,                                    
					last_modify_by,
					last_modify_date)
			select  :lvs_yyyymm,                               
					location_code  , //material_mfs ,  
					a.item_code,                                 
					'N',                               
					a.line_type,
					sum(a.mm_inventory_qty),   
					0,
					avg(a.mm_avg_price),
					sum(a.mm_inventory_amt),  
					location_code ,
					'*' ,                                   
					:gvi_organization_id, 
					:gvs_user_id,                                 
					sysdate,                                       
					:gvs_user_id,
					sysdate
			    from im_item_inventory_close_mfs a 
			  where a.item_code like :lvs_item_code 
				 and a.close_yyyymm = :lvs_yyyymm
				 and a.organization_id = :gvi_organization_id 
			//	 and a.item_code in ( select item_code from id_item where customer_code like :lvs_customer_code ) 	
				 and ( a.close_yyyymm , a.item_code , a.line_type , a.location_code ,a.material_mfs ,  a.organization_id )
				  not in ( select b.close_yyyymm , b.item_code , b.line_type , b.location_code, b.material_mfs , b.organization_id 
									  from im_item_inventory_check b
							where b.close_yyyymm =   :lvs_yyyymm
								and b.organization_id = :gvi_organization_id 
							//	and item_code in ( select item_code from id_item where customer_code like :lvs_customer_code )
							)
									  
			group by a.close_yyyymm,a.item_code,a.line_type,a.location_code ,a.material_mfs , a.organization_id ;
			
			if f_sql_check() < 0 then return 
			
			//====================================================
			//
			//====================================================
			update im_item_inventory_check a 
					set a.inventory_qty = ( select b.mm_inventory_qty
					                                   from im_item_inventory_close_mfs b 
												 where a.close_yyyymm =:lvs_yyyymm
													and b.close_yyyymm =:lvs_yyyymm
													and a.close_yyyymm = b.close_yyyymm											
													and a.item_code= b.item_code 
													and a.line_type = b.line_type
												     and a.material_mfs = b.material_mfs 
													and a.location_code = b.location_code
													and a.organization_id = b.organization_id
												//	and a.item_code in ( select item_code from id_item where customer_code like :lvs_customer_code ) 	
												) 
			where ( a.close_yyyymm , a.item_code , a.line_type , a.location_code , a.material_mfs , a.organization_id )
			  in ( select b.close_yyyymm , b.item_code , b.line_type , b.location_code , b.material_mfs , b.organization_id 
						 from  im_item_inventory_close_mfs b 
					    where a.close_yyyymm =:lvs_yyyymm
						and b.close_yyyymm = :lvs_yyyymm
						and a.close_yyyymm = b.close_yyyymm	
						and a.item_code= b.item_code 
						and a.line_type = b.line_type
						and a.material_mfs = b.material_mfs 
						and a.location_code = b.location_code
						and a.organization_id = b.organization_id
			//			and a.item_code in ( select item_code from id_item where customer_code like :lvs_customer_code ) 	
						) ;
				  
				if f_sql_check() < 0 then return 
			
					update im_item_inventory_check a 
					set inventory_amt = inventory_qty * inventory_price
					where close_yyyymm = :lvs_yyyymm
					and organization_id = :gvi_organization_id 
			//		and item_code in ( select item_code from id_item where customer_code like :lvs_customer_code ) 	
					;
				if f_sql_check() < 0 then return 
			
				msg = f_msgbox(1170)
				if msg = 1 then
					f_msg_mdi_help('Processed Complete')
					commit;
				else
					f_msg_mdi_help('Processed Cancel!')
					rollback;
				end if 
			
		end if 
//=================================================
// $$HEX18$$90c7acc71cc870c888bc38d67cb92000f8ad00b35cb82000acc0a9c660d5bdacb0c62000$$ENDHEX$$
//=================================================

else
			if cbx_regenerate.checked = true then	
			//================================================
			//
			//================================================
			delete from im_item_inventory_check 
			where        close_yyyymm = :lvs_yyyymm 
			  and           organization_id = :gvi_organization_id
	//		  and item_code in ( select item_code from id_item where customer_code like :lvs_customer_code ) 
	      ; 
			if f_sql_check() < 0 then return 
			
			insert into im_item_inventory_check 
					  (close_yyyymm,                              
					material_mfs , 
					item_code,                                    
					inventory_hold,                              
					line_type,
					inventory_qty,                                
					check_inventory_qty,                   
					inventory_price,
					inventory_amt,                               
					location_code,                              
					comments,                                      
					organization_id,
					enter_by,                                        
					enter_date,                                    
					last_modify_by,
					last_modify_date)
			select  :lvs_yyyymm,                               
					material_mfs ,  
					a.item_code,                                 
					'N',                               
					a.line_type,
					sum(a.mm_inventory_qty),   
					sum(decode(:lvs_check_qty_auto_set , 'Y',    a.mm_inventory_qty , 0 )),
					avg(a.mm_avg_price),
					sum(a.mm_inventory_amt),  
					max(location_code),                           
					'*' ,                                   
					:gvi_organization_id, 
					:gvs_user_id,                                 
					sysdate,                                       
					:gvs_user_id,
					sysdate
			from    im_item_inventory_close_mfs a 
			where  a.item_code like :lvs_item_code 
				 and  a.close_yyyymm = :lvs_yyyymm
				 and  a.organization_id = :gvi_organization_id 
			//	 and a.item_code in ( select item_code from id_item where customer_code like :lvs_customer_code ) 	
			group by a.close_yyyymm,a.item_code,a.line_type,a.material_mfs , a.location_code ,  a.organization_id ;
			
			if f_sql_check() < 0 then return 
			
				if sqlca.sqlnrows = 0 then
					f_msg_mdi_help('No data fouond')
					rollback;
				else
					msg = f_msgbox(1170)
					if msg = 1 then
						f_msg_mdi_help('Processed Complete')
						commit;
					else
						f_msg_mdi_help('Processed Cancel!')
						rollback;
					end if 
				end if 
			
			else // $$HEX10$$acc7ddc031c174c7200044c5ccb2bdacb0c62000$$ENDHEX$$
				
			//================================================
			//
			//================================================
			insert into im_item_inventory_check 
					  (close_yyyymm,                              
					material_mfs , 
					item_code,                                    
					inventory_hold,                              
					line_type,
					inventory_qty,                                
					check_inventory_qty,                   
					inventory_price,
					inventory_amt,                               
					location_code,                              
					comments,                                      
					organization_id,
					enter_by,                                        
					enter_date,                                    
					last_modify_by,
					last_modify_date)
			select  :lvs_yyyymm,                               
					material_mfs ,  
					a.item_code,                                 
					'N',                               
					a.line_type,
					sum(a.mm_inventory_qty),   
					0,
					avg(a.mm_avg_price),
					sum(a.mm_inventory_amt),  
					max(location_code) ,
					'*' ,                                   
					:gvi_organization_id, 
					:gvs_user_id,                                 
					sysdate,                                       
					:gvs_user_id,
					sysdate
			from    im_item_inventory_close_mfs a 
			where  a.item_code like :lvs_item_code 
				 and a.close_yyyymm = :lvs_yyyymm
				 and a.organization_id = :gvi_organization_id 
				 and a.item_code in ( select item_code from id_item where customer_code like :lvs_customer_code ) 	
				 and ( a.close_yyyymm , a.item_code , a.line_type , a.location_code , a.material_mfs , a.organization_id )
				  not in ( select b.close_yyyymm , b.item_code , b.line_type ,  b.location_code , b.material_mfs, b.organization_id 
						       from im_item_inventory_check b
							where b.close_yyyymm =   :lvs_yyyymm
								and b.organization_id = :gvi_organization_id
						//		and b.item_code in ( select item_code from id_item where customer_code like :lvs_customer_code ) 
						)
									  
			group by a.close_yyyymm,a.item_code,a.line_type,a.material_mfs , a.location_code ,a.organization_id ;
			if f_sql_check() < 0 then return 
			//====================================================
			//
			//====================================================
			update im_item_inventory_check a 
					set a.inventory_qty = ( select b.mm_inventory_qty from im_item_inventory_close_mfs b 
																 where a.close_yyyymm =:lvs_yyyymm
													and b.close_yyyymm =:lvs_yyyymm
													and a.close_yyyymm = b.close_yyyymm											
															and a.item_code= b.item_code 
													and a.line_type = b.line_type
												   and a.material_mfs = b.material_mfs 
													and a.location_code = b.location_code
													and a.organization_id = b.organization_id
											//		and a.item_code in ( select item_code from id_item where customer_code like :lvs_customer_code )
											) 
			where ( a.close_yyyymm , a.item_code , a.line_type , a.material_mfs , a.location_code , a.organization_id )
			  in ( select b.close_yyyymm , b.item_code , b.line_type , b.material_mfs , b.location_code , b.organization_id 
					from  im_item_inventory_close_mfs b 
					where a.close_yyyymm =:lvs_yyyymm
					and b.close_yyyymm = :lvs_yyyymm
					and a.close_yyyymm = b.close_yyyymm	
					and a.item_code= b.item_code 
					and a.line_type = b.line_type
					and a.material_mfs = b.material_mfs 
					and a.location_code = b.location_code
					and a.organization_id = b.organization_id 
				//	and a.item_code in ( select item_code from id_item where customer_code like :lvs_customer_code ) 	
				) ;
				  
				if f_sql_check() < 0 then return 
			
			update im_item_inventory_check a set inventory_amt = inventory_qty * inventory_price
			where close_yyyymm = :lvs_yyyymm
			and organization_id = :gvi_organization_id
		//	and item_code in ( select item_code from id_item where customer_code like :lvs_customer_code ) 
		;
				if f_sql_check() < 0 then return 
			
				msg = f_msgbox(1170)
				if msg = 1 then
					f_msg_mdi_help('Processed Complete')
					commit;
				else
					f_msg_mdi_help('Processed Cancel!')
					rollback;
				end if 
			
		END IF 
	
end if 
f_retrieve()
end event

type cbx_check_qty_auto_set from checkbox within w_mat_inventory_check_master
integer x = 55
integer y = 432
integer width = 745
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Check QTY Auto Set"
end type

type cbx_regenerate from checkbox within w_mat_inventory_check_master
integer x = 718
integer y = 432
integer width = 658
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "ReGenerate"
boolean checked = true
end type

type cbx_inventory_close from checkbox within w_mat_inventory_check_master
integer x = 1390
integer y = 436
integer width = 745
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inventory Close"
boolean checked = true
end type

type ddlb_location_code from uo_basecode within w_mat_inventory_check_master
integer x = 1659
integer y = 164
integer width = 535
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type st_4 from so_statictext within w_mat_inventory_check_master
integer x = 1659
integer y = 96
integer width = 535
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Code"
end type

type cb_2 from so_commandbutton within w_mat_inventory_check_master
integer x = 2629
integer y = 396
integer width = 448
integer height = 112
integer taborder = 40
boolean bringtotop = true
string text = "Sync With Excel"
end type

event clicked;call super::clicked;long i , lvl_excel_qty
STRING LVS_YYYYMM , LVS_ITEM_CODE , LVS_MATERIAL_MFS , LVS_LOCATION_CODE , LVS_LINE_TYPE 

LVS_YYYYMM = em_yyyymm.text 

if dw_1.getrow() < 1 then return

			//==========================================================
			//
			//==========================================================
			do
				i++
				if isnull(dw_1.object.excel_check_inventory_qty[i]) then
					CONTINUE 
				else
//					lvl_excel_qty = dw_1.object.excel_check_inventory_qty[i]
//					lvs_item_code= dw_1.object.item_code[i]
//					lvs_material_mfs =  dw_1.object.material_mfs[i]
//					lvs_line_type =  dw_1.object.line_type[i]
//					lvs_location_code =  dw_1.object.location_code[i]
//					
//					update IM_ITEM_INVENTORY_CHECK 
//					     set check_inventory_qty = :lvl_excel_qty
//					 where close_yyyymm =  :lvs_yyyymm
//					    and item_code = :lvs_item_code
//						and material_mfs = :lvs_MATERIAL_MFS
//						and line_type = :lvs_LINE_TYPE
//						and location_code = :lvs_LOCATION_CODE
//						and organization_id = :gvi_organization_id  ;
//						
//					if f_sql_check() < 0 then 
//						return 
//					end if 
//					
					dw_1.object.check_inventory_qty[i] = dw_1.object.excel_check_inventory_qty[i]
//					
				end if 
//				
				dw_1.trigger event itemchanged( i, dw_1.object.check_inventory_qty , string(dw_1.object.check_inventory_qty[i]) )
				

				F_MSG_MDI_HELP(STRING(I) )
				
			loop until i = dw_1.rowcount( )
			commit ;
			//==========================================================
			//
			//==========================================================

end event

type ddlb_customer_code from uo_customer_code_name within w_mat_inventory_check_master
integer x = 2208
integer y = 160
integer width = 667
integer taborder = 60
boolean bringtotop = true
end type

type st_3 from so_statictext within w_mat_inventory_check_master
integer x = 2208
integer y = 96
integer width = 667
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Customer Code"
end type

type sle_material_mfs from so_singlelineedit within w_mat_inventory_check_master
integer x = 2885
integer y = 164
integer taborder = 60
boolean bringtotop = true
end type

type st_6 from so_statictext within w_mat_inventory_check_master
integer x = 2889
integer y = 96
integer height = 60
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Material MFS"
end type

type gb_1 from so_groupbox within w_mat_inventory_check_master
integer x = 9
integer width = 736
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_mat_inventory_check_master
integer y = 336
integer width = 4517
integer height = 216
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_3 from so_groupbox within w_mat_inventory_check_master
integer x = 759
integer width = 2656
integer height = 320
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_4 from so_groupbox within w_mat_inventory_check_master
integer x = 3598
integer width = 1184
integer height = 320
integer taborder = 90
integer weight = 700
long textcolor = 16711680
string text = "Invoice Print"
end type


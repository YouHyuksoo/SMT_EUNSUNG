HA$PBExportHeader$w_des_item_master.srw
$PBExportComments$$$HEX6$$80bd88d42000c8b9a4c230d1$$ENDHEX$$
forward
global type w_des_item_master from w_main_root
end type
type uo_item from uo_item_code within w_des_item_master
end type
type st_5 from so_statictext within w_des_item_master
end type
type st_4 from so_statictext within w_des_item_master
end type
type sle_1 from so_singlelineedit within w_des_item_master
end type
type ddlb_line_type from uo_line_type within w_des_item_master
end type
type st_6 from so_statictext within w_des_item_master
end type
type tab_1 from tab within w_des_item_master
end type
type tabpage_4 from userobject within tab_1
end type
type cb_4 from so_commandbutton within tabpage_4
end type
type st_11 from so_statictext within tabpage_4
end type
type ddlb_before_customer from uo_supplier_code within tabpage_4
end type
type ddlb_after_customer from uo_supplier_code within tabpage_4
end type
type st_10 from so_statictext within tabpage_4
end type
type cb_2 from so_commandbutton within tabpage_4
end type
type st_7 from so_statictext within tabpage_4
end type
type ddlb_after_supplier from uo_supplier_code within tabpage_4
end type
type ddlb_before_supplier from uo_supplier_code within tabpage_4
end type
type st_2 from so_statictext within tabpage_4
end type
type tabpage_4 from userobject within tab_1
cb_4 cb_4
st_11 st_11
ddlb_before_customer ddlb_before_customer
ddlb_after_customer ddlb_after_customer
st_10 st_10
cb_2 cb_2
st_7 st_7
ddlb_after_supplier ddlb_after_supplier
ddlb_before_supplier ddlb_before_supplier
st_2 st_2
end type
type tabpage_10 from userobject within tab_1
end type
type cb_keyitem_list from so_commandbutton within tabpage_10
end type
type pb_3 from so_commandbutton within tabpage_10
end type
type pb_2 from so_commandbutton within tabpage_10
end type
type pb_1 from so_commandbutton within tabpage_10
end type
type tabpage_10 from userobject within tab_1
cb_keyitem_list cb_keyitem_list
pb_3 pb_3
pb_2 pb_2
pb_1 pb_1
end type
type tab_1 from tab within w_des_item_master
tabpage_4 tabpage_4
tabpage_10 tabpage_10
end type
type tab_item from tab within w_des_item_master
end type
type tabpage_5 from userobject within tab_item
end type
type dw_6 from so_datawindow within tabpage_5
end type
type tabpage_5 from userobject within tab_item
dw_6 dw_6
end type
type tabpage_6 from userobject within tab_item
end type
type dw_7 from so_datawindow within tabpage_6
end type
type tabpage_6 from userobject within tab_item
dw_7 dw_7
end type
type tabpage_8 from userobject within tab_item
end type
type cb_6 from so_commandbutton within tabpage_8
end type
type cb_5 from so_commandbutton within tabpage_8
end type
type dw_9 from so_datawindow within tabpage_8
end type
type tabpage_8 from userobject within tab_item
cb_6 cb_6
cb_5 cb_5
dw_9 dw_9
end type
type tabpage_9 from userobject within tab_item
end type
type cbx_1 from so_checkbox within tabpage_9
end type
type cb_9 from so_commandbutton within tabpage_9
end type
type cb_7 from so_commandbutton within tabpage_9
end type
type p_image from so_picture within tabpage_9
end type
type cbx_show_image from so_checkbox within tabpage_9
end type
type tabpage_9 from userobject within tab_item
cbx_1 cbx_1
cb_9 cb_9
cb_7 cb_7
p_image p_image
cbx_show_image cbx_show_image
end type
type tab_item from tab within w_des_item_master
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_8 tabpage_8
tabpage_9 tabpage_9
end type
type ddlb_item_division from uo_item_division within w_des_item_master
end type
type st_12 from so_statictext within w_des_item_master
end type
type st_3 from so_statictext within w_des_item_master
end type
type ddlb_model_name from uo_model_name_ddlb within w_des_item_master
end type
type sle_is_new_yn from so_singlelineedit within w_des_item_master
end type
type st_13 from so_statictext within w_des_item_master
end type
type ddlb_supplier_code from uo_supplier_name_code within w_des_item_master
end type
type st_1 from so_statictext within w_des_item_master
end type
type ddlb_customer_code from uo_customer_code_name within w_des_item_master
end type
type st_14 from so_statictext within w_des_item_master
end type
type sle_part_no from so_singlelineedit within w_des_item_master
end type
type st_15 from so_statictext within w_des_item_master
end type
type sle_item_spec from so_singlelineedit within w_des_item_master
end type
type st_8 from so_statictext within w_des_item_master
end type
type gb_where_condition from so_groupbox within w_des_item_master
end type
end forward

global type w_des_item_master from w_main_root
integer width = 5440
integer height = 2708
string title = "Item Master"
uo_item uo_item
st_5 st_5
st_4 st_4
sle_1 sle_1
ddlb_line_type ddlb_line_type
st_6 st_6
tab_1 tab_1
tab_item tab_item
ddlb_item_division ddlb_item_division
st_12 st_12
st_3 st_3
ddlb_model_name ddlb_model_name
sle_is_new_yn sle_is_new_yn
st_13 st_13
ddlb_supplier_code ddlb_supplier_code
st_1 st_1
ddlb_customer_code ddlb_customer_code
st_14 st_14
sle_part_no sle_part_no
st_15 st_15
sle_item_spec sle_item_spec
st_8 st_8
gb_where_condition gb_where_condition
end type
global w_des_item_master w_des_item_master

on w_des_item_master.create
int iCurrent
call super::create
this.uo_item=create uo_item
this.st_5=create st_5
this.st_4=create st_4
this.sle_1=create sle_1
this.ddlb_line_type=create ddlb_line_type
this.st_6=create st_6
this.tab_1=create tab_1
this.tab_item=create tab_item
this.ddlb_item_division=create ddlb_item_division
this.st_12=create st_12
this.st_3=create st_3
this.ddlb_model_name=create ddlb_model_name
this.sle_is_new_yn=create sle_is_new_yn
this.st_13=create st_13
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_1=create st_1
this.ddlb_customer_code=create ddlb_customer_code
this.st_14=create st_14
this.sle_part_no=create sle_part_no
this.st_15=create st_15
this.sle_item_spec=create sle_item_spec
this.st_8=create st_8
this.gb_where_condition=create gb_where_condition
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_item
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.sle_1
this.Control[iCurrent+5]=this.ddlb_line_type
this.Control[iCurrent+6]=this.st_6
this.Control[iCurrent+7]=this.tab_1
this.Control[iCurrent+8]=this.tab_item
this.Control[iCurrent+9]=this.ddlb_item_division
this.Control[iCurrent+10]=this.st_12
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.ddlb_model_name
this.Control[iCurrent+13]=this.sle_is_new_yn
this.Control[iCurrent+14]=this.st_13
this.Control[iCurrent+15]=this.ddlb_supplier_code
this.Control[iCurrent+16]=this.st_1
this.Control[iCurrent+17]=this.ddlb_customer_code
this.Control[iCurrent+18]=this.st_14
this.Control[iCurrent+19]=this.sle_part_no
this.Control[iCurrent+20]=this.st_15
this.Control[iCurrent+21]=this.sle_item_spec
this.Control[iCurrent+22]=this.st_8
this.Control[iCurrent+23]=this.gb_where_condition
end on

on w_des_item_master.destroy
call super::destroy
destroy(this.uo_item)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.sle_1)
destroy(this.ddlb_line_type)
destroy(this.st_6)
destroy(this.tab_1)
destroy(this.tab_item)
destroy(this.ddlb_item_division)
destroy(this.st_12)
destroy(this.st_3)
destroy(this.ddlb_model_name)
destroy(this.sle_is_new_yn)
destroy(this.st_13)
destroy(this.ddlb_supplier_code)
destroy(this.st_1)
destroy(this.ddlb_customer_code)
destroy(this.st_14)
destroy(this.sle_part_no)
destroy(this.st_15)
destroy(this.sle_item_spec)
destroy(this.st_8)
destroy(this.gb_where_condition)
end on

event activate;call super::activate;/***************************************
* $$HEX17$$08c7c4b324c115c8d0c5200000ad5cd52000acc06dd544c720004bc105d35cd5e4b2$$ENDHEX$$
*
*
****************************************/
Gst_set.window_id            = this.classname() 
Gst_set.author                  = "JiSheng"
Gst_set.creation_date      = '20051101'
Gst_set.last_modify_date = '20051101'
Gst_set.Report_window    = False  // Report Window  True / Flase

/*****************************************
* Data WIndow Property
******************************************/
Ivs_resize_type    = 'MASTER_DETAIL_TAB'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'N' //Default
ivs_dw_3_use_focusindicator = 'N' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default

/****************************************
* Menu Property $$HEX6$$54ba74b2200078d5e4b4c1b9$$ENDHEX$$
*****************************************
* ADMIN     : ADMIN  ( $$HEX5$$04c8b4ccacc0a9c62000$$ENDHEX$$)
* $$HEX8$$00adacb9200020002000200020002000$$ENDHEX$$: MANAGE ( $$HEX8$$04c854ba74b2acc0a9c600aca5b22000$$ENDHEX$$)
* $$HEX7$$acc0a9c690c72000200020002000$$ENDHEX$$: GUEST  ( $$HEX11$$30ae08cd2000f1b45db8200070c88cd6200000aca5b2$$ENDHEX$$)
* $$HEX8$$70c88cd6200020002000200020002000$$ENDHEX$$: QUERY  ( $$HEX10$$15c8f4bc70c88cd6ccb9200000aca5b220002000$$ENDHEX$$)
* $$HEX5$$70b374c7c0d070c891c7$$ENDHEX$$: DATA_CONTROL  ( $$HEX12$$85c725b8200018c215c82000adc01cc8200024c115c82000$$ENDHEX$$)
* $$HEX7$$08b8ecd3b8d22000200020002000$$ENDHEX$$: REPORT ( $$HEX4$$08b8ecd3b8d22000$$ENDHEX$$, $$HEX5$$9ccd25b800adacb92000$$ENDHEX$$)
****************************************/

F_MENU_CONTROL('DATA_CONTROL' , TRUE)  // All Data Control

/****************************************
* 
****************************************/

end event

event ue_data_control;call super::ue_data_control;Long ROW
STRING LVS_SETYN
double lvdb_version
CHOOSE CASE Gvs_Ue_data_control
		
	CASE 'RETRIEVE'
		   
				DW_1.SETFILTER('')
				DW_1.FILTER()
				
				LVS_SETYN = '%'
				
				DW_1.RESET()
				TAB_ITEM.TABPAGE_5.DW_6.RESET()
				DW_1.RETRIEVE( UO_ITEM.TEXT()+'%' , ddlb_model_name.GETCODE()+'%'    , LVS_SETYN,  DDLB_LINE_TYPE.GETCODE()+'%' ,  ddlb_item_division.getcode( )+'%', sle_is_new_yn.text+'%' ,  ddlb_supplier_code.getcode( )+'%' ,   ddlb_customer_code.getcode()+'%' ,  GVI_ORGANIZATION_ID , sle_part_no.text+'%' , '%'+sle_item_spec.text+'%' )
				DW_1.SETFOCUS()

			
	CASE 'INSERT'
		
				TAB_ITEM.TABPAGE_5.DW_6.reset()
				ROW = TAB_ITEM.TABPAGE_5.DW_6.INSERTROW(TAB_ITEM.TABPAGE_5.DW_6.GETROW())
				TAB_ITEM.TABPAGE_5.DW_6.SCROLLTOROW(ROW)
				F_SET_SECURITY_ROW(TAB_ITEM.TABPAGE_5.DW_6 , ROW , 'ALL')
				TAB_ITEM.TABPAGE_5.DW_6.OBJECT.ITEM_CODE.PROTECT = 0
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM(ROW,'DATESET',F_T_SYSDATE())
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'DATEEND' , DATE('9999/12/31') )	
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'ABC_GRADE' , 'A')		
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'SET_ITEM_YN' , 'N')					
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'ITEM_TYPE' , 'T')								
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'AUTO_ISSUE_PLAN_YN' , 'Y')											
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'AUTO_ISSUE_YN' , 'N')														
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'AUTO_RECEIPT_YN' , 'N')																	
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'ITEM_CLASS' , '*') //DEFAULT
				
				TAB_ITEM.TABPAGE_5.DW_6.object.item_uom[row] = 'EA'			
				TAB_ITEM.TABPAGE_5.DW_6.object.line_code[row] = '*'
				TAB_ITEM.TABPAGE_5.DW_6.object.route_no[row] = '*'	
				TAB_ITEM.TABPAGE_5.DW_6.object.supplier_code[row] = '*'	
				
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'MSL_LEVEL' , '1') //DEFAULT
				
				
				TAB_ITEM.TABPAGE_5.DW_6.SETFOCUS()
				F_MSG_MDI_HELP ( F_MSG_ST(152)	 )
	CASE 'APPEND'

			
			if tab_item.selectedtab = 4 then //$$HEX6$$c4b374ba200085c725b82000$$ENDHEX$$
				
				if dw_1.getrow() < 1 then return
				
				ROW = TAB_ITEM.TABPAGE_8.DW_9.INSERTROW(TAB_ITEM.TABPAGE_8.DW_9.GETROW())
				TAB_ITEM.TABPAGE_8.DW_9.GROUPCALC()
				
				TAB_ITEM.TABPAGE_8.DW_9.SCROLLTOROW(ROW)
				F_SET_SECURITY_ROW(TAB_ITEM.TABPAGE_8.DW_9 , ROW , 'ALL')        
				
				lvdb_version = 1
				
				TAB_ITEM.TABPAGE_8.DW_9.object.DRAWING_NO[ROW] = dw_1.object.drawing_no[dw_1.getrow()]
				TAB_ITEM.TABPAGE_8.DW_9.object.version[ROW] = lvdb_version
				TAB_ITEM.TABPAGE_8.DW_9.object.item_code[ROW] = dw_1.object.item_code[dw_1.getrow()]
				TAB_ITEM.TABPAGE_8.DW_9.object.item_name[ROW] = dw_1.object.item_name[dw_1.getrow()]
				TAB_ITEM.TABPAGE_8.DW_9.object.item_spec[ROW] = dw_1.object.item_spec[dw_1.getrow()]
				TAB_ITEM.TABPAGE_8.DW_9.object.item_uom[ROW] = dw_1.object.item_uom[dw_1.getrow()]				
				TAB_ITEM.TABPAGE_8.DW_9.object.item_division[ROW] = dw_1.object.item_division[dw_1.getrow()]
				TAB_ITEM.TABPAGE_8.DW_9.object.item_class[ROW] = dw_1.object.item_class[dw_1.getrow()]				
				
			else
				TAB_ITEM.TABPAGE_5.DW_6.reset()
				ROW = TAB_ITEM.TABPAGE_5.DW_6.INSERTROW(TAB_ITEM.TABPAGE_5.DW_6.GETROW())
				TAB_ITEM.TABPAGE_5.DW_6.SCROLLTOROW(ROW)
				F_SET_SECURITY_ROW(TAB_ITEM.TABPAGE_5.DW_6 , ROW , 'ALL')
				TAB_ITEM.TABPAGE_5.DW_6.OBJECT.ITEM_CODE.PROTECT = 0
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM(ROW,'DATESET',F_T_SYSDATE())
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'DATEEND' , DATE('9999/12/31') )	
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'ABC_GRADE' , 'A')		
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'SET_ITEM_YN' , 'N')					
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'ITEM_TYPE' , 'T')								
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'AUTO_ISSUE_PLAN_YN' , 'Y')											
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'AUTO_ISSUE_YN' , 'N')														
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'AUTO_RECEIPT_YN' , 'N')																	
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'ITEM_CLASS' , '*') //DEFAULT
				
				TAB_ITEM.TABPAGE_5.DW_6.object.item_uom[row] = 'EA'			
				TAB_ITEM.TABPAGE_5.DW_6.object.line_code[row] = '*'
				TAB_ITEM.TABPAGE_5.DW_6.object.route_no[row] = '*'	
				TAB_ITEM.TABPAGE_5.DW_6.object.supplier_code[row] = '*'	
				
				TAB_ITEM.TABPAGE_5.DW_6.SETITEM( ROW , 'MSL_LEVEL' , '1') //DEFAULT
				
				
				TAB_ITEM.TABPAGE_5.DW_6.SETFOCUS()
				F_MSG_MDI_HELP ( F_MSG_ST(152)	 )			
			end if 
					   
	CASE 'DELETE'
		
			 IF DW_1.GETROW() < 1 THEN RETURN 
		  	 IF TAB_ITEM.TABPAGE_5.DW_6.GETROW() < 1 THEN RETURN 	
			   
			if TAB_ITEM.TABPAGE_5.DW_6.getrow() < 1 then return
			
			if TAB_ITEM.TABPAGE_5.DW_6.object.item_code[TAB_ITEM.TABPAGE_5.DW_6.getrow()] = '*' then
				//Mess agebox("Notify" , "Default Item Can`t Delete!")
				f_msg( "Default Item Can`t Delete!",'P')
				return
			end if			   
			  
			MSG = F_MSGBOX(1003) 
			IF MSG = 1 THEN

				GVL_ROW_DELETED = TAB_ITEM.TABPAGE_5.DW_6.GETROW()			
				TAB_ITEM.TABPAGE_5.DW_6.DELETEROW(GVL_ROW_DELETED)		
				TAB_ITEM.TABPAGE_5.DW_6.SETFOCUS()
				ROW = TAB_ITEM.TABPAGE_5.DW_6.GETROW()
				TAB_ITEM.TABPAGE_5.DW_6.SCROLLTOROW(ROW)
				TAB_ITEM.TABPAGE_5.DW_6.SETCOLUMN(1)
				
			END IF
			
	CASE 'UPDATE'
		
		DW_1.ACCEPTTEXT()
		IF DW_1.ModifiedCount() > 0 OR DW_1.DELETEDCOUNT() > 0 THEN
			IF dw_1.UPDATE() < 0 THEN
				ROLLBACK;
			ELSE
				COMMIT;
				F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF
		ELSE
		     	F_MSG_MDI_HELP("Modified Data Not Found")
		END IF		
		
		
		TAB_ITEM.TABPAGE_5.DW_6.ACCEPTTEXT()
			
		IF TAB_ITEM.TABPAGE_5.DW_6.UPDATE() < 0 THEN
			ROLLBACK;
		ELSE
			COMMIT;
			F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
		END IF
		
		TAB_ITEM.TABPAGE_6.DW_7.ACCEPTTEXT()
		
		IF TAB_ITEM.TABPAGE_6.DW_7.UPDATE() < 0 THEN
			ROLLBACK;
		ELSE
			COMMIT;
			F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
		END IF
		
		TAB_ITEM.TABPAGE_8.DW_9.ACCEPTTEXT()
			
		IF TAB_ITEM.TABPAGE_8.DW_9.UPDATE() < 0 THEN
			ROLLBACK;
		ELSE
			COMMIT;
			F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
		END IF		
		
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;IF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_TAB' THEN //12345_TAB
	
	dw_1.resize(width - dw_1.x -34, height - ( dw_1.y + tab_item.height +120 ))
	dw_2.resize(width - dw_2.x -34, height - ( dw_2.y + tab_item.height +120 ))	
	dw_3.resize(width - dw_3.x -34, height - ( dw_3.y + tab_item.height +120))	
	dw_4.resize(width - dw_4.x -34, height - ( dw_4.y + tab_item.height +120))		
	dw_5.resize(width - dw_5.x -34, height - ( dw_5.y + tab_item.height +120))	
	
	tab_item.y = dw_1.y + dw_1.HEIGHT
	tab_item.resize(width - tab_item.x -34, tab_item.height )	
	tab_item.tabpage_8.dw_9.width = 	  width  - tab_item.x - 34
END IF	  
	  

/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())

end event

event resize;call super::resize;IF UPPER(IVS_RESIZE_TYPE) = 'MASTER_DETAIL_TAB' THEN //12345_TAB
	
	dw_1.resize(newwidth  - dw_1.x , newheight - ( dw_1.y + tab_item.height ))
	dw_2.resize(newwidth  - dw_2.x , newheight - ( dw_2.y + tab_item.height ))		
	dw_3.resize(newwidth  - dw_3.x , newheight - ( dw_3.y + tab_item.height ))	
	dw_4.resize(newwidth  - dw_4.x , newheight - ( dw_4.y + tab_item.height ))	
	dw_5.resize(newwidth  - dw_5.x , newheight - ( dw_5.y + tab_item.height ))	
	

	tab_item.y = dw_1.y + dw_1.HEIGHT 
	tab_item.resize(newwidth  - tab_item.x , tab_item.height )		
     
     tab_item.tabpage_8.dw_9.width = 	  newwidth  - tab_item.x
	  
END IF	  
end event

event open;call super::open;//========================================
// Set Transaction
//========================================
tab_item.tabpage_5.dw_6.settransobject( sqlca)
tab_item.tabpage_6.dw_7.settransobject( sqlca)


tab_item.tabpage_8.dw_9.settransobject( sqlca)

//========================================
// dddw Init
//========================================
f_set_column_dddw( tab_item.tabpage_5.dw_6 )
f_set_column_dddw( tab_item.tabpage_6.dw_7 )

f_set_column_dddw( tab_item.tabpage_8.dw_9 )
//========================================
// Share Data
//========================================

tab_item.tabpage_5.dw_6.sharedata( tab_item.tabpage_6.dw_7 )

//========================================
// MSL LEVEL $$HEX7$$acc0a9c66cad84bd20001cc8b4c5$$ENDHEX$$
//========================================

if (Gvs_use_msl_level_value = "Y") then
    tab_item.tabpage_5.dw_6.modify("msl_max_time.edit.displayonly = YES")
end if

end event

type dw_5 from w_main_root`dw_5 within w_des_item_master
integer y = 584
integer height = 396
end type

type dw_4 from w_main_root`dw_4 within w_des_item_master
integer y = 584
integer height = 396
integer taborder = 20
end type

type dw_3 from w_main_root`dw_3 within w_des_item_master
integer y = 584
integer height = 396
integer taborder = 120
end type

type dw_2 from w_main_root`dw_2 within w_des_item_master
integer y = 584
integer height = 396
integer taborder = 0
end type

type dw_1 from w_main_root`dw_1 within w_des_item_master
integer y = 588
integer width = 5239
integer height = 884
integer taborder = 100
boolean titlebar = true
string title = "Item Master List"
string dataobject = "d_des_item_lst_tree"
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;blob lvb_blob , lvb_null
setnull(lvb_null)

if currentrow = 0 then return

tab_item.tabpage_5.dw_6.retrieve( dw_1.object.item_code[currentrow] , gvi_organization_id)
tab_item.tabpage_6.dw_7.retrieve( dw_1.object.item_code[currentrow] , gvi_organization_id)
tab_item.tabpage_8.dw_9.retrieve( dw_1.object.drawing_no[currentrow] , dw_1.object.item_code[currentrow] , '%' , '%' , gvi_organization_id )

dw_1.setfocus( )

if tab_item.tabpage_9.cbx_show_image.checked = true then 
	if currentrow < 1 then return
	lvb_blob = f_download_item_image(dw_1.object.item_code[currentrow]) 
	
	if isnull(lvb_blob) then
		tab_item.tabpage_9.p_image.visible = false
		tab_item.tabpage_9.p_image.setpicture( lvb_null )
	else
		tab_item.tabpage_9.p_image.visible = true
		tab_item.tabpage_9.p_image.setpicture( lvb_blob )
	end if 
else
end if 
end event

event dw_1::doubleclicked;call super::doubleclicked;if row = 0 then return

tab_item.tabpage_5.dw_6.retrieve( dw_1.object.item_code[ROW] , gvi_organization_id)
tab_item.tabpage_6.dw_7.retrieve( dw_1.object.rowid[row], gvi_organization_id)
//tab_item.tabpage_7.dw_8.retrieve( dw_1.object.rowid[row])
tab_item.tabpage_8.dw_9.retrieve( '%' , dw_1.object.item_code[row] , '%' , '%' , gvi_organization_id )
end event

event dw_1::rbuttondown;call super::rbuttondown;if dwo.name = 'supplier_code' then 
	open(w_com_supplier_popup)
	if message.stringparm = '' then 
	else
		this.object.supplier_code[row] = message.stringparm

	end if
end if 

if dwo.name = 'customer_code' then 
	open(w_com_customer_popup)
	if message.stringparm = '' then 
	else
		this.object.customer_code[row] = message.stringparm
	end if 
end if 
end event

type uo_tabpages from w_main_root`uo_tabpages within w_des_item_master
end type

type uo_item from uo_item_code within w_des_item_master
integer x = 1751
integer y = 148
integer width = 581
integer height = 764
integer taborder = 30
boolean bringtotop = true
end type

on uo_item.destroy
call uo_item_code::destroy
end on

type st_5 from so_statictext within w_des_item_master
integer x = 1751
integer y = 76
integer width = 581
integer height = 56
boolean bringtotop = true
boolean enabled = false
string text = "Item Code"
end type

type st_4 from so_statictext within w_des_item_master
integer x = 2341
integer y = 76
integer width = 507
integer height = 56
boolean bringtotop = true
string text = "Item Class"
end type

type sle_1 from so_singlelineedit within w_des_item_master
integer x = 2341
integer y = 148
integer width = 507
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

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'ITEM_CLASS'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

dw_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type ddlb_line_type from uo_line_type within w_des_item_master
integer x = 2853
integer y = 148
integer width = 443
integer taborder = 110
boolean bringtotop = true
end type

type st_6 from so_statictext within w_des_item_master
integer x = 2853
integer y = 76
integer width = 421
integer height = 56
boolean bringtotop = true
string text = "Line Type"
end type

type tab_1 from tab within w_des_item_master
event create ( )
event destroy ( )
integer x = 9
integer y = 304
integer width = 3680
integer height = 276
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_4 tabpage_4
tabpage_10 tabpage_10
end type

on tab_1.create
this.tabpage_4=create tabpage_4
this.tabpage_10=create tabpage_10
this.Control[]={this.tabpage_4,&
this.tabpage_10}
end on

on tab_1.destroy
destroy(this.tabpage_4)
destroy(this.tabpage_10)
end on

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3643
integer height = 148
long backcolor = 15780518
string text = "Supplier/Customer Change"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "EditStops!"
long picturemaskcolor = 12632256
cb_4 cb_4
st_11 st_11
ddlb_before_customer ddlb_before_customer
ddlb_after_customer ddlb_after_customer
st_10 st_10
cb_2 cb_2
st_7 st_7
ddlb_after_supplier ddlb_after_supplier
ddlb_before_supplier ddlb_before_supplier
st_2 st_2
end type

on tabpage_4.create
this.cb_4=create cb_4
this.st_11=create st_11
this.ddlb_before_customer=create ddlb_before_customer
this.ddlb_after_customer=create ddlb_after_customer
this.st_10=create st_10
this.cb_2=create cb_2
this.st_7=create st_7
this.ddlb_after_supplier=create ddlb_after_supplier
this.ddlb_before_supplier=create ddlb_before_supplier
this.st_2=create st_2
this.Control[]={this.cb_4,&
this.st_11,&
this.ddlb_before_customer,&
this.ddlb_after_customer,&
this.st_10,&
this.cb_2,&
this.st_7,&
this.ddlb_after_supplier,&
this.ddlb_before_supplier,&
this.st_2}
end on

on tabpage_4.destroy
destroy(this.cb_4)
destroy(this.st_11)
destroy(this.ddlb_before_customer)
destroy(this.ddlb_after_customer)
destroy(this.st_10)
destroy(this.cb_2)
destroy(this.st_7)
destroy(this.ddlb_after_supplier)
destroy(this.ddlb_before_supplier)
destroy(this.st_2)
end on

type cb_4 from so_commandbutton within tabpage_4
integer x = 3122
integer y = 44
integer width = 512
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "Customer Change"
end type

event clicked;call super::clicked;STRING  LVS_AFTER_customer , LVS_BEFORE_customer , LVS_ITEM_CODE , LVS_customer_CODE
Long i , LVI_COUNT
LVS_AFTER_customer  = ddlb_after_customer.text
LVS_BEFORE_customer= ddlb_before_customer.text

if LVS_BEFORE_customer  = '' or LVS_BEFORE_customer = '%' then
   Return
end if 

if LVS_AFTER_customer  = '' or LVS_AFTER_customer = '%' then
   Return
end if 

if LVS_AFTER_customer =  LVS_BEFORE_customer then
   Return
end if 

MSG = F_MSGBOX1( 1161 ,LVS_BEFORE_customer+'  => '+ LVS_AFTER_customer+'   ' +THIS.TEXT )
IF MSG = 1 THEN 
ELSE
	RETURN
END IF


//==================================================
//
//==================================================
DO
i++

		if dw_1.object.check_yn[i] = 'Y' then
			LVS_ITEM_CODE = dw_1.object.item_code[i]
			LVS_customer_CODE = dw_1.object.customer_code[i]
		else
			continue
		end if
		
		if LVS_customer_CODE <> LVS_BEFORE_customer then
			continue
		end if 
		

		UPDATE ID_ITEM SET customer_CODE = :LVS_AFTER_customer
		  WHERE customer_CODE   = :LVS_BEFORE_customer
			  AND ITEM_CODE             = :LVS_ITEM_CODE
			AND customer_CODE     = :LVS_customer_CODE
			  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		
		IF F_SQL_CHECK() < 0 THEN 
			RETURN
		END IF

LOOP UNTIL i = dw_1.rowcount( )


MSG = F_MSGBOX( 1170 )

IF MSG = 1 THEN 
	COMMIT ;
	F_MSG_MDI_HELP( F_MSG_ST( 170) )
	f_retrieve()
ELSE
	ROLLBACK ;
END IF
end event

type st_11 from so_statictext within tabpage_4
integer x = 1815
integer width = 667
integer height = 56
boolean bringtotop = true
long backcolor = 15780518
string text = "Before Customer"
end type

type ddlb_before_customer from uo_supplier_code within tabpage_4
integer x = 1815
integer y = 60
integer width = 681
integer taborder = 80
boolean bringtotop = true
end type

type ddlb_after_customer from uo_supplier_code within tabpage_4
integer x = 2496
integer y = 60
integer width = 617
integer taborder = 70
boolean bringtotop = true
end type

type st_10 from so_statictext within tabpage_4
integer x = 2501
integer width = 617
integer height = 60
boolean bringtotop = true
long backcolor = 15780518
string text = "After Customer"
end type

type cb_2 from so_commandbutton within tabpage_4
integer x = 1307
integer y = 44
integer height = 100
integer taborder = 60
boolean bringtotop = true
string text = "Supplier Change"
end type

event clicked;call super::clicked;STRING  LVS_AFTER_SUPPLIER , LVS_BEFORE_SUPPLIER , LVS_ITEM_CODE , LVS_SUPPLIER_CODE
Long i , LVI_COUNT
LVS_AFTER_SUPPLIER  = ddlb_after_supplier.text
LVS_BEFORE_SUPPLIER= ddlb_before_supplier.text

if LVS_BEFORE_SUPPLIER  = '' or LVS_BEFORE_SUPPLIER = '%' then
   Return
end if 

if LVS_AFTER_SUPPLIER  = '' or LVS_AFTER_SUPPLIER = '%' then
   Return
end if 

if LVS_AFTER_SUPPLIER =  LVS_BEFORE_SUPPLIER then
   Return
end if 

MSG = F_MSGBOX1( 1161 ,LVS_BEFORE_SUPPLIER+'  => '+ LVS_AFTER_SUPPLIER+'   ' +THIS.TEXT )
IF MSG = 1 THEN 
ELSE
	RETURN
END IF


//==================================================
//
//==================================================
DO
i++

		if dw_1.object.check_yn[i] = 'Y' then
			LVS_ITEM_CODE = dw_1.object.item_code[i]
			LVS_SUPPLIER_CODE = dw_1.object.supplier_code[i]
		else
			continue
		end if
		
		if LVS_SUPPLIER_CODE <> LVS_BEFORE_SUPPLIER then
			continue
		end if 
		

		UPDATE ID_ITEM SET SUPPLIER_CODE = :LVS_AFTER_SUPPLIER
		  WHERE SUPPLIER_CODE   = :LVS_BEFORE_SUPPLIER
			  AND ITEM_CODE             = :LVS_ITEM_CODE
			AND SUPPLIER_CODE     = :LVS_SUPPLIER_CODE
			  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
		
		IF F_SQL_CHECK() < 0 THEN 
			RETURN
		END IF

LOOP UNTIL i = dw_1.rowcount( )


MSG = F_MSGBOX( 1170 )

IF MSG = 1 THEN 
	COMMIT ;
	F_MSG_MDI_HELP( F_MSG_ST( 170) )
	f_retrieve()
ELSE
	ROLLBACK ;
END IF
end event

type st_7 from so_statictext within tabpage_4
integer x = 690
integer y = 8
integer width = 617
integer height = 60
boolean bringtotop = true
long backcolor = 15780518
string text = "After Supplier"
end type

type ddlb_after_supplier from uo_supplier_code within tabpage_4
integer x = 686
integer y = 68
integer width = 617
integer taborder = 60
boolean bringtotop = true
end type

type ddlb_before_supplier from uo_supplier_code within tabpage_4
integer x = 5
integer y = 68
integer width = 681
integer taborder = 70
boolean bringtotop = true
end type

type st_2 from so_statictext within tabpage_4
integer x = 5
integer y = 8
integer width = 667
integer height = 56
boolean bringtotop = true
long backcolor = 15780518
string text = "Before Supplier"
end type

type tabpage_10 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3643
integer height = 148
long backcolor = 12632256
string text = "Excel"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Custom004!"
long picturemaskcolor = 12632256
cb_keyitem_list cb_keyitem_list
pb_3 pb_3
pb_2 pb_2
pb_1 pb_1
end type

on tabpage_10.create
this.cb_keyitem_list=create cb_keyitem_list
this.pb_3=create pb_3
this.pb_2=create pb_2
this.pb_1=create pb_1
this.Control[]={this.cb_keyitem_list,&
this.pb_3,&
this.pb_2,&
this.pb_1}
end on

on tabpage_10.destroy
destroy(this.cb_keyitem_list)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.pb_1)
end on

type cb_keyitem_list from so_commandbutton within tabpage_10
integer x = 1897
integer y = 8
integer width = 645
integer height = 128
integer taborder = 60
boolean bringtotop = true
string text = "LG KeyItem List"
end type

event clicked;call super::clicked;openwithparm(w_mat_keyitem_popup , this ) 

uo_item.text = message.stringparm

end event

type pb_3 from so_commandbutton within tabpage_10
integer x = 590
integer y = 12
integer width = 681
integer height = 128
integer taborder = 60
string text = "Import From Excel BOM"
end type

event clicked;call super::clicked;open(w_des_bom_excel_form_lg_4_item_popup)
end event

type pb_2 from so_commandbutton within tabpage_10
integer x = 1358
integer y = 8
integer width = 521
integer height = 128
integer taborder = 60
string text = "Set MSL/Location"
end type

event clicked;call super::clicked;open(w_mat_item_set_msl_location_popup)
end event

type pb_1 from so_commandbutton within tabpage_10
integer x = 59
integer y = 12
integer width = 521
integer height = 128
integer taborder = 50
string text = "Import From Excel"
end type

event clicked;call super::clicked;open(w_des_item_excel_form_popup)
end event

type tab_item from tab within w_des_item_master
integer y = 1476
integer width = 5243
integer height = 928
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
boolean fixedwidth = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean powertips = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_8 tabpage_8
tabpage_9 tabpage_9
end type

on tab_item.create
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_8=create tabpage_8
this.tabpage_9=create tabpage_9
this.Control[]={this.tabpage_5,&
this.tabpage_6,&
this.tabpage_8,&
this.tabpage_9}
end on

on tab_item.destroy
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_8)
destroy(this.tabpage_9)
end on

type tabpage_5 from userobject within tab_item
integer x = 18
integer y = 112
integer width = 5207
integer height = 800
long backcolor = 12632256
string text = "Item Master"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "EditDataTabular!"
long picturemaskcolor = 536870912
dw_6 dw_6
end type

on tabpage_5.create
this.dw_6=create dw_6
this.Control[]={this.dw_6}
end on

on tabpage_5.destroy
destroy(this.dw_6)
end on

type dw_6 from so_datawindow within tabpage_5
integer x = 5
integer y = 12
integer width = 5202
integer height = 788
integer taborder = 20
string dataobject = "d_des_item_mst"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;DATETIME 	LVD_DATESET , LVD_DATEEND
STRING lvs_code_type, lvs_code_name, lvs_code_value  // MSL$$HEX5$$00ad28b82000c0bc18c2$$ENDHEX$$

if	row <= 0 then return

if dwo.name = 'set_item_yn' then
	//$$HEX24$$5ccd85c880bd88d47cc7bdacb0c62000fcd3a9ba6cad84bd44c720001cc888d43cc75cb8200090c7d9b3200024c115c8$$ENDHEX$$
		if data = 'Y' then
			this.object.item_division[row] = 'F' 
			this.object.item_type[row] = 'T' 			
			this.object.line_type[row] = 'T' 						
		end if
end if

if dwo.name = 'dateset' or dwo.name =  'dateend' then 
	  
	DW_2.ACCEPTTEXT()
	LVD_DATESET = DW_2.GETITEMDATETIME( row , 'dateset' )
	LVD_DATEEND = DW_2.GETITEMDATETIME( row , 'dateend' )
	
	IF LVD_DATESET >  LVD_DATEEND THEN		
		DW_2.OBJECT.DATESET[ROW] = ''
		DW_2.OBJECT.DATEEND[ROW] = ''
		//MESS AGEBOX("Notify" , "Dateend Must Greate then Dateset" )
		f_msg("Dateend Must Greate then Dateset",'P')
		RETURN 1 
	END IF		
				
end if 


if dwo.name = 'line_type' then
	
	if data = 'T'  and this.object.set_item_yn[row] = 'Y'  then // $$HEX11$$90c791c7200074c7e0ac20005ccd85c874c774ba2000$$ENDHEX$$
		
		this.object.item_division[row] = 'F'
		
	elseif data = 'T'  and this.object.set_item_yn[row] = 'N'  then //$$HEX11$$90c791c774c7e0ac200018bc1cc888d474c774ba2000$$ENDHEX$$

		this.object.item_division[row] = 'W'		
		
	elseif data = 'F'  then //$$HEX5$$34bbc1c0acc009ae2000$$ENDHEX$$
		
		this.object.item_division[row] = 'R'		
	else
		this.object.item_division[row] = 'R'				
	end if
end if 

// MSL Level$$HEX5$$d0c5200000b35cd52000$$ENDHEX$$MSL MAX Value$$HEX2$$44c72000$$ENDHEX$$Setting

if dwo.name = 'msl_level' then
			 
   lvs_code_type   = 'MSL LEVEL'
   lvs_code_name   = this.object.msl_level[row]
   lvs_code_value  = f_get_basecode_value(lvs_code_type, lvs_code_name)

   this.object.msl_max_time[row] = long(lvs_code_value)

end if
end event

event rbuttondown;call super::rbuttondown;if dwo.name = 'supplier_code' then 
	open(w_com_supplier_popup)
	if message.stringparm = '' then 
	else
		this.object.supplier_code[row] = message.stringparm

	end if
end if 

if dwo.name = 'customer_code' then 
	open(w_com_customer_popup)
	if message.stringparm = '' then 
	else
		this.object.customer_code[row] = message.stringparm
	end if 
end if 
end event

event clicked;call super::clicked;if dwo.name = 'b_new' then 
	
	open( w_des_new_item_popup_es)
	if Gst_return.gvb_return = true then
		this.object.item_code[row] = message.stringparm
	end if 
	
end if
end event

type tabpage_6 from userobject within tab_item
integer x = 18
integer y = 112
integer width = 5207
integer height = 800
long backcolor = 12632256
string text = "Extra Information"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "CreateTable5!"
long picturemaskcolor = 12632256
dw_7 dw_7
end type

on tabpage_6.create
this.dw_7=create dw_7
this.Control[]={this.dw_7}
end on

on tabpage_6.destroy
destroy(this.dw_7)
end on

type dw_7 from so_datawindow within tabpage_6
integer y = 24
integer width = 4942
integer height = 612
integer taborder = 70
string dataobject = "d_des_item_4_extra_mst"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;
string lvs_pcb_coating_type

if dwo.name = 'height' or dwo.name = 'width' or dwo.name = 'length' then
	
	this.object.cbm[row] = dec(this.object.height[row]) + dec(this.object.width[row]) + dec(this.object.length[row])
	
end if 

// PCB Coating Type $$HEX5$$d0c5200030b57cb72000$$ENDHEX$$PCB Coating Max Day $$HEX2$$7cb92000$$ENDHEX$$Setting

if dwo.name = 'pcb_coating_type' then
			 
   lvs_pcb_coating_type   = this.object.pcb_coating_type[row]

   if ( lvs_pcb_coating_type = 'OSP' ) then
	 
        this.object.pcb_coating_max_day[row] = 90
		  
   elseif ( lvs_pcb_coating_type = 'HASL' or  lvs_pcb_coating_type = 'TIN' or  lvs_pcb_coating_type = 'GOLD' ) then
		 
		     this.object.pcb_coating_max_day[row] = 180
		
   else
		
   end if
		  
end if
end event

type tabpage_8 from userobject within tab_item
integer x = 18
integer y = 112
integer width = 5207
integer height = 800
long backcolor = 12632256
string text = "Drawing File"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Animation!"
long picturemaskcolor = 536870912
cb_6 cb_6
cb_5 cb_5
dw_9 dw_9
end type

on tabpage_8.create
this.cb_6=create cb_6
this.cb_5=create cb_5
this.dw_9=create dw_9
this.Control[]={this.cb_6,&
this.cb_5,&
this.dw_9}
end on

on tabpage_8.destroy
destroy(this.cb_6)
destroy(this.cb_5)
destroy(this.dw_9)
end on

type cb_6 from so_commandbutton within tabpage_8
integer x = 453
integer y = 8
integer width = 430
integer height = 116
integer taborder = 30
boolean bringtotop = true
string text = "View Drawig"
end type

event clicked;if DW_9.getrow() < 1 then 
	return
end if

Long Lvl_return
String  lvs_file_name
if DW_9.getrow() < 1 then return 

Lvl_return =  f_download_drawing ( String(DW_9.object.drawing_no[DW_9.getrow()]) , DW_9.object.item_code[DW_9.getrow()]  ,  DW_9.object.version[DW_9.getrow()])

if  Lvl_return > 0 then 

	lvs_file_name = Gvs_default_directory+"\Temp\"+DW_9.object.file_name[DW_9.getrow()] 
	
	IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
		RETURN
	END IF
	
	f_shell_execute_by_extention ( DW_9.object.file_name[DW_9.getrow()]  , '' ,Gvs_default_directory+'\Temp'  )
	
else
	
end if

Changedirectory(Gvs_default_directory)

end event

type cb_5 from so_commandbutton within tabpage_8
integer x = 18
integer y = 8
integer width = 430
integer height = 116
integer taborder = 40
boolean bringtotop = true
string text = "Upload Drawing"
end type

event clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN

int    li_FileNum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   LIB_FILE , b
double LVDB_VERSION
string is_filename, is_fullname , LVS_DRAWING_NO , LVS_ITEM_CODE
		
		IF  DW_9.GETROW() < 1 THEN 
			 RETURN
		END IF
		
		IF DW_9.UPDATE() < 0 THEN 
			RETURN
		END IF
		
		LVS_DRAWING_NO = DW_9.GETITEMSTRING( DW_9.GETROW() , "DRAWING_NO" )
		LVS_ITEM_CODE  = DW_9.GETITEMSTRING( DW_9.GETROW() , "ITEM_CODE" )
		LVDB_VERSION   = DW_9.OBJECT.VERSION[DW_9.GETROW()]
		
		IF LVS_DRAWING_NO ='' OR ISNULL(LVS_DRAWING_NO) THEN 
			RETURN
		END IF		
		
		if GetFileOpenName("Select File", is_fullname, is_filename, "DWG", &
			 + "DWG Files (*.dwg),*.DWG," &		 
			 + "GIF Files (*.gif),*.GIF," &
			 + "BMP Files (*.bmp),*.BMP," &			 
			 + "JPG Files (*.jpg),*.JPG," &
			 + "PPT Files (*.ppt),*.PPT," &			 
			 + "All Files (*.*), *.*") < 1 then return
		
		flen = FileLength(is_fullname)
		
		IF FLEN < 0 THEN 
			ROLLBACK;			
			F_MSGBOX1(9020 ,is_fullname )
			RETURN 
		END IF
		
		li_FileNum = FileOpen(is_fullname,  StreamMode!, Read!, LockRead!)
		
		IF li_FileNum <> -1 THEN
				
					SetPointer(HourGlass!)
					IF flen > 32765 THEN
					
							  IF Mod(flen, 32765) = 0 THEN
									loops = flen/32765
							  ELSE
									loops = (flen/32765) + 1
							  END IF
					ELSE
							  loops = 1
					END IF
					
					new_pos = 1
					FOR i = 1 to loops
							  bytes_read = FileRead(li_FileNum, b)
							  bytes_read_sum = bytes_read_sum + bytes_read
							  LIB_FILE = LIB_FILE + b
							  F_MSG_MDI_HELP( STRING(bytes_read_sum)+"/"+string(flen)+" Bytes Read" )
					NEXT
					
					FileClose(li_FileNum)
					
					
					select count(*) into :lvi_count
					  from ID_ENG_BOM_DRAWING
					 WHERE DRAWING_NO   = :LVS_DRAWING_NO 
					   AND ITEM_CODE    = :LVS_ITEM_CODE
					   AND VERSION = :LVDB_VERSION
						AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
						  
					IF F_SQL_CHECK() < 0 THEN 
						RETURN
					END IF				  
					
					if lvi_count = 0 then 
						ROLLBACK;									
						F_MSGBOX1( 9021 , is_filename ) 
						return
					end if
						  
					UPDATEBLOB ID_ENG_BOM_DRAWING SET DRAWING_IMAGE = :LIB_FILE 
					WHERE DRAWING_NO      = :LVS_DRAWING_NO
					  AND ITEM_CODE       = :LVS_ITEM_CODE
					  AND VERSION = :LVDB_VERSION
					  AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;

				  IF SQLCA.SQLNROWS > 0 THEN

				  ELSE
					  ROLLBACK ;
					  MESSAGEBOX("Error" , is_filename+f_msg(" File Upload To Database Failed",'S') )
					  RETURN
					  
				  END IF;
				  
					UPDATE ID_ENG_BOM_DRAWING SET FILE_NAME = :is_filename 
					WHERE DRAWING_NO      = :LVS_DRAWING_NO
					AND ITEM_CODE       = :LVS_ITEM_CODE
					AND VERSION = :LVDB_VERSION
					AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;				  
		
				  IF F_SQL_CHECK() < 0 THEN 
					  RETURN
				  END IF		  
				  
				  COMMIT ;
			         F_MSGBOX(9022)

		END IF
Changedirectory(Gvs_default_directory)
tab_item.tabpage_8.dw_9.retrieve( dw_1.object.drawing_no[dw_1.getrow()] , dw_1.object.item_code[dw_1.getrow()] , '%' , '%' , gvi_organization_id )
end event

type dw_9 from so_datawindow within tabpage_8
integer y = 132
integer width = 3643
integer height = 400
integer taborder = 30
string dataobject = "d_des_bom_drawing_4_item_master_tree"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;string			ls_hs_name, ls_hs_name_scrap
if 	dwo.name = 'hs_code' then 
	
	SELECT	CODE_MEAN_LOCAL
	INTO		:ls_hs_name
	FROM		ISYS_BASECODE
	WHERE	CODE_TYPE				=	'HS CODE'
	AND		CODE_NAME			=	:data
	AND		ORGANIZATION_ID	=	:gvi_organization_id
	;
	
	this.object.hs_name[row]	=	ls_hs_name
	
end if

if 	dwo.name = 'hs_code_scrap' then 
	
	ls_hs_name	=	this.object.hs_name[row]
	
	SELECT	CODE_MEAN_LOCAL
	INTO		:ls_hs_name_scrap
	FROM		ISYS_BASECODE
	WHERE	CODE_TYPE				=	'HS CODE SCRAP'
	AND		CODE_NAME			=	:data
	AND		ORGANIZATION_ID	=	:gvi_organization_id
	;
	
	this.object.hs_name_scrap[row]	=	ls_hs_name + ls_hs_name_scrap
end if

end event

type tabpage_9 from userobject within tab_item
integer x = 18
integer y = 112
integer width = 5207
integer height = 800
long backcolor = 12632256
string text = "Image"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Custom006!"
long picturemaskcolor = 12632256
cbx_1 cbx_1
cb_9 cb_9
cb_7 cb_7
p_image p_image
cbx_show_image cbx_show_image
end type

on tabpage_9.create
this.cbx_1=create cbx_1
this.cb_9=create cb_9
this.cb_7=create cb_7
this.p_image=create p_image
this.cbx_show_image=create cbx_show_image
this.Control[]={this.cbx_1,&
this.cb_9,&
this.cb_7,&
this.p_image,&
this.cbx_show_image}
end on

on tabpage_9.destroy
destroy(this.cbx_1)
destroy(this.cb_9)
destroy(this.cb_7)
destroy(this.p_image)
destroy(this.cbx_show_image)
end on

type cbx_1 from so_checkbox within tabpage_9
integer x = 1166
integer y = 132
integer width = 581
integer weight = 700
string text = "Show Origianal Size"
end type

event clicked;call super::clicked;if this.checked = true then 
	
	p_image.originalsize = true
else
	p_image.originalsize = false
	p_image.width  = 618
	p_image.height = 516
end if 
end event

type cb_9 from so_commandbutton within tabpage_9
integer x = 631
integer y = 124
integer height = 108
integer taborder = 50
string text = "Image Delete"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return

int    li_filenum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   lib_file , b
double lvdb_version
string is_filename, is_fullname , lvs_drawing_no , lvs_item_code
		
		if  dw_1.getrow() < 1 then 
			 return
		end if
			
		lvs_item_code  = dw_1.getitemstring( dw_1.getrow() , "item_code" )
	
		if lvs_item_code ='' or isnull(lvs_item_code) then 
			return
		end if		

					select count(*) into :lvi_count
					  from id_item_image
					 where item_code    = :lvs_item_code
						and organization_id = :gvi_organization_id ;
						  
					if f_sql_check() < 0 then 
						return
					end if				  
					
					if lvi_count = 1 then 
						
						delete from id_item_image 
						where item_code    = :lvs_item_code
						and organization_id = :gvi_organization_id ;
						
								  
						if f_sql_check() < 0 then 
							return
						end if				  
										
					end if
		  
				  commit ;
	f_msgbox(164)



end event

type cb_7 from so_commandbutton within tabpage_9
integer x = 631
integer y = 16
integer height = 108
integer taborder = 50
string text = "Image Upload"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return

int    li_filenum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   lib_file , b
double lvdb_version
string is_filename, is_fullname , lvs_drawing_no , lvs_item_code
		
		if  dw_1.getrow() < 1 then 
			 return
		end if
			
		lvs_item_code  = dw_1.getitemstring( dw_1.getrow() , "item_code" )
	
		if lvs_item_code ='' or isnull(lvs_item_code) then 
			return
		end if		
		
		if getfileopenname("select file", is_fullname, is_filename, "jpg", &
			 + "jpg files (*.jpg),*.jpg," &	
			 + "gif files (*.gif),*.gif," &
			 + "bmp files (*.bmp),*.bmp," &			 
			 + "all files (*.*), *.*") < 1 then return
		
		flen = filelength(is_fullname)
		
		if flen < 0 then 
			rollback;			
			f_msgbox1(9020 ,is_fullname )
			return 
		end if
		
		li_filenum = fileopen(is_fullname,  streammode!, read!, lockread!)
		
		if li_filenum <> -1 then
				
					setpointer(hourglass!)
					if flen > 32765 then
					
							  if mod(flen, 32765) = 0 then
									loops = flen/32765
							  else
									loops = (flen/32765) + 1
							  end if
					else
							  loops = 1
					end if
					
					new_pos = 1
					for i = 1 to loops
							  bytes_read = fileread(li_filenum, b)
							  bytes_read_sum = bytes_read_sum + bytes_read
							  lib_file = lib_file + b
							  f_msg_mdi_help( string(bytes_read_sum)+"/"+string(flen)+" bytes read" )
					next
					
					fileclose(li_filenum)
					
					select count(*) into :lvi_count
					  from id_item_image
					 where item_code    = :lvs_item_code
						and organization_id = :gvi_organization_id ;
						  
					if f_sql_check() < 0 then 
						return
					end if				  
					
					if lvi_count = 0 then 
						
						insert into id_item_image ( item_code , organization_id ) 
						   values ( :lvs_item_code , :gvi_organization_id ) ;
								  
						if f_sql_check() < 0 then 
							return
						end if				  
										
					end if
						  
					updateblob id_item_image set item_image = :lib_file 
					where item_code       = :lvs_item_code
					  and organization_id = :gvi_organization_id ;

				  if sqlca.sqlnrows > 0 then

				  else
					  rollback ;
					  messagebox("error" , is_filename+f_msg(" file upload to database failed",'S') )
					  return
				  end if;
			  
				  commit ;
			         f_msgbox(9022)

		end if
changedirectory(gvs_default_directory)

end event

type p_image from so_picture within tabpage_9
integer width = 617
integer height = 516
boolean originalsize = false
end type

type cbx_show_image from so_checkbox within tabpage_9
integer x = 1166
integer y = 20
integer width = 530
integer weight = 700
string text = "Show Image"
boolean checked = true
end type

event constructor;call super::constructor;IF GVS_SHOW_ITEM_IMAGE = 'Y' THEN 
    this.checked = true
else
	this.checked = false
end if
end event

type ddlb_item_division from uo_item_division within w_des_item_master
integer x = 3301
integer y = 148
integer width = 443
integer taborder = 20
boolean bringtotop = true
end type

type st_12 from so_statictext within w_des_item_master
integer x = 3287
integer y = 76
integer width = 443
integer height = 56
boolean bringtotop = true
string text = "Item Division"
end type

type st_3 from so_statictext within w_des_item_master
integer x = 1120
integer y = 76
integer width = 581
integer height = 56
boolean bringtotop = true
boolean enabled = false
string text = "Model Name"
end type

type ddlb_model_name from uo_model_name_ddlb within w_des_item_master
integer x = 1111
integer y = 148
integer width = 635
integer height = 1908
integer taborder = 20
boolean bringtotop = true
end type

type sle_is_new_yn from so_singlelineedit within w_des_item_master
integer x = 3749
integer y = 148
integer width = 274
integer height = 84
integer taborder = 60
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

type st_13 from so_statictext within w_des_item_master
integer x = 3744
integer y = 72
integer width = 274
integer height = 56
boolean bringtotop = true
string text = "Is New YN"
end type

type ddlb_supplier_code from uo_supplier_name_code within w_des_item_master
integer x = 599
integer y = 148
integer width = 507
integer height = 1752
integer taborder = 30
boolean bringtotop = true
end type

type st_1 from so_statictext within w_des_item_master
integer x = 603
integer y = 80
integer width = 507
integer height = 56
boolean bringtotop = true
string text = "Supplier Code"
end type

type ddlb_customer_code from uo_customer_code_name within w_des_item_master
integer x = 41
integer y = 148
integer width = 553
integer taborder = 30
boolean bringtotop = true
end type

type st_14 from so_statictext within w_des_item_master
integer x = 46
integer y = 80
integer width = 553
integer height = 56
boolean bringtotop = true
string text = "Customer Code"
end type

type sle_part_no from so_singlelineedit within w_des_item_master
integer x = 4032
integer y = 148
integer width = 622
integer height = 84
integer taborder = 30
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

type st_15 from so_statictext within w_des_item_master
integer x = 4027
integer y = 72
integer width = 622
integer height = 56
boolean bringtotop = true
string text = "Part No"
end type

type sle_item_spec from so_singlelineedit within w_des_item_master
integer x = 4663
integer y = 148
integer width = 535
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

type st_8 from so_statictext within w_des_item_master
integer x = 4658
integer y = 72
integer width = 535
integer height = 56
boolean bringtotop = true
string text = "Item Spec"
end type

type gb_where_condition from so_groupbox within w_des_item_master
integer width = 5221
integer height = 300
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


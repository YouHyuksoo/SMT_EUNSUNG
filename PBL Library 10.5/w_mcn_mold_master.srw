HA$PBExportHeader$w_mcn_mold_master.srw
$PBExportComments$Customer Infromation Manage
forward
global type w_mcn_mold_master from w_main_root
end type
type st_1 from so_statictext within w_mcn_mold_master
end type
type st_2 from so_statictext within w_mcn_mold_master
end type
type sle_model_name from so_singlelineedit within w_mcn_mold_master
end type
type st_3 from so_statictext within w_mcn_mold_master
end type
type sle_mold_spec from so_singlelineedit within w_mcn_mold_master
end type
type ddlb_item_code from uo_item_code within w_mcn_mold_master
end type
type st_4 from so_statictext within w_mcn_mold_master
end type
type rb_all from so_radiobutton within w_mcn_mold_master
end type
type rb_gt from so_radiobutton within w_mcn_mold_master
end type
type rb_1 from so_radiobutton within w_mcn_mold_master
end type
type cb_1 from so_commandbutton within w_mcn_mold_master
end type
type ddlb_mold_group from uo_basecode within w_mcn_mold_master
end type
type st_6 from so_statictext within w_mcn_mold_master
end type
type ddlb_mold_code from uo_mold_code within w_mcn_mold_master
end type
type cbx_auto_receipt_yn from so_checkbox within w_mcn_mold_master
end type
type cb_2 from so_commandbutton within w_mcn_mold_master
end type
type cb_7 from so_commandbutton within w_mcn_mold_master
end type
type cb_9 from so_commandbutton within w_mcn_mold_master
end type
type gb_2 from groupbox within w_mcn_mold_master
end type
type gb_4 from groupbox within w_mcn_mold_master
end type
type gb_1 from groupbox within w_mcn_mold_master
end type
end forward

global type w_mcn_mold_master from w_main_root
integer y = 256
integer width = 5367
integer height = 3104
string title = "Mold Master"
st_1 st_1
st_2 st_2
sle_model_name sle_model_name
st_3 st_3
sle_mold_spec sle_mold_spec
ddlb_item_code ddlb_item_code
st_4 st_4
rb_all rb_all
rb_gt rb_gt
rb_1 rb_1
cb_1 cb_1
ddlb_mold_group ddlb_mold_group
st_6 st_6
ddlb_mold_code ddlb_mold_code
cbx_auto_receipt_yn cbx_auto_receipt_yn
cb_2 cb_2
cb_7 cb_7
cb_9 cb_9
gb_2 gb_2
gb_4 gb_4
gb_1 gb_1
end type
global w_mcn_mold_master w_mcn_mold_master

on w_mcn_mold_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.sle_model_name=create sle_model_name
this.st_3=create st_3
this.sle_mold_spec=create sle_mold_spec
this.ddlb_item_code=create ddlb_item_code
this.st_4=create st_4
this.rb_all=create rb_all
this.rb_gt=create rb_gt
this.rb_1=create rb_1
this.cb_1=create cb_1
this.ddlb_mold_group=create ddlb_mold_group
this.st_6=create st_6
this.ddlb_mold_code=create ddlb_mold_code
this.cbx_auto_receipt_yn=create cbx_auto_receipt_yn
this.cb_2=create cb_2
this.cb_7=create cb_7
this.cb_9=create cb_9
this.gb_2=create gb_2
this.gb_4=create gb_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_model_name
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.sle_mold_spec
this.Control[iCurrent+6]=this.ddlb_item_code
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.rb_all
this.Control[iCurrent+9]=this.rb_gt
this.Control[iCurrent+10]=this.rb_1
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.ddlb_mold_group
this.Control[iCurrent+13]=this.st_6
this.Control[iCurrent+14]=this.ddlb_mold_code
this.Control[iCurrent+15]=this.cbx_auto_receipt_yn
this.Control[iCurrent+16]=this.cb_2
this.Control[iCurrent+17]=this.cb_7
this.Control[iCurrent+18]=this.cb_9
this.Control[iCurrent+19]=this.gb_2
this.Control[iCurrent+20]=this.gb_4
this.Control[iCurrent+21]=this.gb_1
end on

on w_mcn_mold_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_model_name)
destroy(this.st_3)
destroy(this.sle_mold_spec)
destroy(this.ddlb_item_code)
destroy(this.st_4)
destroy(this.rb_all)
destroy(this.rb_gt)
destroy(this.rb_1)
destroy(this.cb_1)
destroy(this.ddlb_mold_group)
destroy(this.st_6)
destroy(this.ddlb_mold_code)
destroy(this.cbx_auto_receipt_yn)
destroy(this.cb_2)
destroy(this.cb_7)
destroy(this.cb_9)
destroy(this.gb_2)
destroy(this.gb_4)
destroy(this.gb_1)
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
Ivs_resize_type    = 'MASTER_DETAIL_145F_23'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
ivs_dw_1_use_focusindicator = 'Y' //Focus Indicator Show / Hide Property
ivs_dw_2_use_focusindicator = 'Y' //Default
ivs_dw_3_use_focusindicator = 'Y' //Default
ivs_dw_4_use_focusindicator = 'N' //Default
ivs_dw_5_use_focusindicator = 'N' //Default


ivs_dw_2_selected_row_yn = 'Y'
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
STRING LVS_RCV_ISS_TYPE
CHOOSE CASE Gvs_Ue_DATA_control
	CASE 'RETRIEVE'
			DW_1.RESET( )
			DW_1.RETRIEVE(  ddlb_mold_code.text()+'%' ,ddlb_mold_group.getcode( )+'%' ,  gvi_organization_id )
			
	CASE	'INSERT'
		
			DW_1.RESET( )		
			DW_1.ENABLED = TRUE
			ROW = DW_1.INSERTROW(DW_1.GETROW())
			DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_1 , ROW ,'ALL')
			dw_1.object.mold_line_type[row] = 'G'			
			dw_1.object.drawing_no[row] = '*'						
			dw_1.object.mold_uom[row] = 'EA'									
			dw_1.object.mold_group[row] = '*'
			dw_1.object.supplier_code[row] = '*'			
			dw_1.object.item_unit_qty[row] = 0
			if cbx_auto_receipt_yn.checked = true then  
				dw_1.object.auto_receipt_yn[row] = 'Y'
			else
				dw_1.object.auto_receipt_yn[row] = 'N'				
			end if 
			dw_1.groupcalc( )
			
	CASE	'APPEND'
			DW_1.RESET( )		
			DW_1.ENABLED = TRUE
			ROW = DW_1.INSERTROW(0)
			DW_1.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_1 , ROW ,'ALL')
			dw_1.object.mold_line_type[row] = 'G'			
			dw_1.object.drawing_no[row] = '*'						
			dw_1.object.mold_uom[row] = 'EA'									
			dw_1.object.mold_group[row] = '*'
			dw_1.object.supplier_code[row] = '*'		
//			dw_1.object.item_unit_qty[row] = 0			
			if cbx_auto_receipt_yn.checked = true then  
				dw_1.object.auto_receipt_yn[row] = 'Y'
			else
				dw_1.object.auto_receipt_yn[row] = 'N'				
			end if 
			dw_1.groupcalc( )
				
			
	CASE	'DELETE'
//			if DW_1.AcceptText() = -1 then
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
					string lvs_mold_code
					if f_object_role_check() = false then return 
					if dw_1.getrow() < 1 then return
					
					lvs_mold_code = dw_1.object.mold_code[dw_1.getrow()]
					
					if lvs_mold_code= '' or isnull(lvs_mold_code) or lvs_mold_code = '%' then
							f_msgbox1( 102  , lvs_mold_code)
							return 
					end if
					
					msg =f_msgbox(1003)
					
					if msg=1 then


					    delete from IMCN_MOLD_UNIT_PRICE where mold_code = :lvs_mold_code and organization_id = :gvi_organization_id  ;						
					    delete from IMCN_MOLD_SHORT_HISTORY where mold_code = :lvs_mold_code and organization_id = :gvi_organization_id  ;						
					    delete from IMCN_MOLD_RENT where mold_code = :lvs_mold_code and organization_id = :gvi_organization_id  ;
						delete from imcn_mold_issue where mold_code = :lvs_mold_code and organization_id = :gvi_organization_id  ;						
						delete from imcn_mold_repair where mold_code = :lvs_mold_code and organization_id = :gvi_organization_id  ;
						delete from imcn_mold_receipt where mold_code = :lvs_mold_code and organization_id = :gvi_organization_id  ;
						delete from imcn_mold_inventory where mold_code = :lvs_mold_code and organization_id = :gvi_organization_id ;
						delete from imcn_mold where mold_code = :lvs_mold_code  and organization_id = :gvi_organization_id ;
						 
						if f_sql_check() < 0 then 
							return
						end if
						commit ;
					end if


	CASE 'UPDATE'

	         IF DW_5.UPDATE() < 0 OR DW_2.UPDATE() < 0 THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF

 		
	CASE ELSE
END CHOOSE

end event

event ue_post_open;call super::ue_post_open;
/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())


dw_1.sharedata( dw_5)
end event

type dw_5 from w_main_root`dw_5 within w_mcn_mold_master
integer x = 2729
integer y = 288
integer width = 1957
integer height = 1184
boolean titlebar = true
string dataobject = "d_mcn_mold_mst"
boolean maxbox = false
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event dw_5::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
dw_1.scrolltorow( currentrow)
end event

event dw_5::rbuttondown;call super::rbuttondown;if dwo.name = 'item_code' then 
	open(w_mat_item_popup)
	if gst_return.gvb_return = false then 
	else
		this.object.item_code[row] = gst_return.gvs_return[3] 
			
		IF ivs_modify_security = 'Y' THEN 
			F_SET_SECURITY_ROW( THIS , ROW , 'MODIFY' )
		END IF		
	end if 

end if 
end event

type dw_4 from w_main_root`dw_4 within w_mcn_mold_master
integer x = 5
integer y = 288
integer width = 2720
integer height = 1184
integer taborder = 80
boolean titlebar = true
string title = "Mold Bill List"
string dataobject = "d_mcn_mold_bill_lst"
end type

type dw_3 from w_main_root`dw_3 within w_mcn_mold_master
integer y = 1740
integer width = 4690
integer height = 740
integer taborder = 70
boolean titlebar = true
boolean resizable = true
end type

type dw_2 from w_main_root`dw_2 within w_mcn_mold_master
integer y = 1496
integer width = 4690
integer height = 984
integer taborder = 100
boolean titlebar = true
string title = "Mold Inventory"
string dataobject = "d_mcn_mold_inventory_4_mold_lst"
boolean resizable = true
end type

event dw_2::rowfocuschanged;//OVERRIDE
end event

event dw_2::clicked;call super::clicked;if dwo.name = 'b_del' then 
	
	msg =f_msgbox1(1161 , dwo.text )
	if msg = 1 then 
		this.deleterow( row)
		f_update()
	end if 
	
	
end if 
end event

event dw_2::rbuttondown;call super::rbuttondown;open( w_mcn_mold_location_popup)
if message.stringparm = '' or isnull(message.stringparm) then 
else
	this.object.mold_location_code[row] =message.stringparm
end if 

end event

type dw_1 from w_main_root`dw_1 within w_mcn_mold_master
integer x = 5
integer y = 288
integer width = 2720
integer height = 1184
boolean titlebar = true
string title = "Mold List"
string dataobject = "d_mcn_mold_lst_tree"
end type

event dw_1::rbuttondown;call super::rbuttondown;if dwo.name = 'supplier_code' then 	
	//open(w_com_mold_supplier_popup)	
	if  gst_return.gvb_return  = true then
	   this.object.supplier_code[row] = message.stringparm
	   gst_return.gvs_return[1]  = ''		
	end if
end if
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;if currentrow < 1 then return
dw_5.scrolltorow( currentrow)

dw_2.retrieve( dw_1.object.mold_code[currentrow] , dw_1.object.mold_version[currentrow]  , dw_1.object.mold_set_serial[currentrow] , dw_1.object.organization_id[currentrow]  )
end event

type uo_tabpages from w_main_root`uo_tabpages within w_mcn_mold_master
end type

type st_1 from so_statictext within w_mcn_mold_master
integer x = 37
integer y = 84
integer width = 722
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Mold Code"
end type

type st_2 from so_statictext within w_mcn_mold_master
integer x = 763
integer y = 84
integer width = 462
integer height = 64
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Mold Name"
end type

type sle_model_name from so_singlelineedit within w_mcn_mold_master
integer x = 763
integer y = 156
integer width = 462
integer height = 84
integer taborder = 20
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'MOLD_NAME'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    dw_1.SETFILTER('')
    dw_1.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+UPPER(this.text)+'%'
END IF

dw_1.SETFILTER( "UPPER("+LVS_COLUMN+")"  +" LIKE '"+LVS_VALUE+"'")
dw_1.FILTER()
F_MSG_MDI_HELP( STRING( dw_1.ROWCOUNT() ) + " Found" )
end event

type st_3 from so_statictext within w_mcn_mold_master
integer x = 1225
integer y = 84
integer width = 457
integer height = 64
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Mold Spec"
end type

type sle_mold_spec from so_singlelineedit within w_mcn_mold_master
integer x = 1230
integer y = 156
integer width = 457
integer height = 84
integer taborder = 30
boolean bringtotop = true
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

dw_1.SETFILTER('')
dw_1.FILTER()

LVS_COLUMN = 'MOLD_SPEC'
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

type ddlb_item_code from uo_item_code within w_mcn_mold_master
integer x = 1691
integer y = 156
integer width = 439
integer taborder = 40
boolean bringtotop = true
end type

type st_4 from so_statictext within w_mcn_mold_master
integer x = 1691
integer y = 80
integer width = 434
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Mold Material"
end type

type rb_all from so_radiobutton within w_mcn_mold_master
integer x = 3867
integer y = 68
integer width = 594
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter( '')
dw_1.filter( )
end event

type rb_gt from so_radiobutton within w_mcn_mold_master
integer x = 3867
integer y = 156
integer width = 594
boolean bringtotop = true
integer weight = 700
string text = "Remain Value > 0"
end type

event clicked;call super::clicked;dw_1.setfilter('remain_value > 0 ')
dw_1.filter( )
end event

type rb_1 from so_radiobutton within w_mcn_mold_master
integer x = 4443
integer y = 156
integer width = 594
boolean bringtotop = true
integer weight = 700
string text = "Remain Value <= 0"
end type

event clicked;call super::clicked;dw_1.setfilter('remain_value <= 0 ')
dw_1.filter( )
end event

type cb_1 from so_commandbutton within w_mcn_mold_master
integer x = 2880
integer y = 52
integer width = 448
integer height = 108
integer taborder = 30
boolean bringtotop = true
string text = "Generate Item"
end type

event clicked;call super::clicked;MSG = F_MSGBOX1( 1161 , THIS.TEXT)
IF MSG = 1 THEN 
ELSE
	RETURN
END IF 
  INSERT INTO ID_ITEM  
         ( ITEM_CODE,   
           ORGANIZATION_ID,   
           ITEM_SPEC,   
           ITEM_UOM,   
           ITEM_CLASS,   
           ITEM_TYPE,   
           VIRTUAL_RECEIPT_YN,   
           ITEM_NAME,   
           LINE_TYPE,   
           ROUTE_NO,   
           BARCODE,   
           ABC_GRADE,   
           ENTER_DATE,   
           RAW_MATERIAL,   
           SAFETY_INVENTORY,   
           WORK_BAD_RATE,   
           TRANSFER_UOM,   
           MANUFACTURE_LEADTIME,   
           ORDER_CYCLE,   
           ORDER_RULE,   
           HS_CODE,   
           ENTER_BY,   
           SVC_CODE,   
           CAPACITY,   
           LAST_MODIFY_DATE,   
           LENGTH,   
           LAST_MODIFY_BY,   
           DATESET,   
           DATEEND,   
           SET_ITEM_YN,   
           SPECIAL_PROPERTY,   
           LAYER,   
           PART_NO,   
           HEIGHT,   
           WEIGHT,   
           DRAWING_NO,   
           GRADIENT,   
           DENSITY,   
           ITEM_DIVISION,   
           ISSUE_PACKING_QTY,   
           INNER_DIAMETER,   
           OUTER_DIAMETER,   
           WIDTH,   
           HS_NAME,   
           HS_SPEC,   
           HS_CODE_SCRAP,   
           HS_NAME_SCRAP,   
           HS_SPEC_SCRAP,   
           TRANSFER_YN,   
           LINE_CODE,   
           TARIFF_RATE,   
           SUPPLIER_CODE,   
           CUSTOMER_CODE,   
           MODEL_NAME,   
           MODEL_SUFFIX,   
           AUTO_ISSUE_YN,   
           AUTO_RECEIPT_YN,   
           AUTO_ISSUE_PLAN_YN,   
           BUY_PRICE,   
           SALE_PRICE,   
           SALE_PRICE_APPLY_TYPE,   
           GROSS_WEIGHT,   
           CBM,   
           BARCODE2,   
           EHMS_YN,   
           EHMS_STATUS,   
           MATERIAL_TYPE,   
           PURCHASE_GROUP,   
           PHANTOM_CODE,   
           SUPPLY_TYPE )  
SELECT MOLD_CODE,   
           ORGANIZATION_ID,   
           NVL(MOLD_SPEC,'*') ,   
           NVL(MOLD_UOM,  'EA') , 
           MOLD_GROUP,   
           'T' ITEM_TYPE,   
           'N' VIRTUAL_RECEIPT_YN,   
           NVL(MOLD_NAME,  '*') ,  
           'G' LINE_TYPE,   
           '*' ROUTE_NO,   
           '*' BARCODE,   
           'A' ABC_GRADE,   
           SYSDATE ENTER_DATE,   
           '*' RAW_MATERIAL,   
           0 SAFETY_INVENTORY,   
           0 WORK_BAD_RATE,   
           'EA' TRANSFER_UOM,   
           0 MANUFACTURE_LEADTIME,   
           0 ORDER_CYCLE,   
           'M' ORDER_RULE,   
           '*' HS_CODE,   
           :GVS_USER_ID ENTER_BY,   
           '*' SVC_CODE,   
           0 CAPACITY,   
           SYSDATE LAST_MODIFY_DATE,   
           0 LENGTH,   
           :GVS_USER_ID LAST_MODIFY_BY,   
           TRUNC(SYSDATE) DATESET,   
           TO_DATE( '99991231' , 'YYYYMMDD') DATEEND,   
           'N' SET_ITEM_YN,   
           '*' SPECIAL_PROPERTY,   
           0 LAYER,   
           '*' PART_NO,   
           0 HEIGHT,   
           0 WEIGHT,   
           NULL DRAWING_NO,   
           NULL GRADIENT,   
           NULL DENSITY,   
           '*' ITEM_DIVISION,   
           0 ISSUE_PACKING_QTY,   
           0 INNER_DIAMETER,   
           0 OUTER_DIAMETER,   
           0 WIDTH,   
           NULL  HS_NAME,   
           NULL HS_SPEC,   
           NULL HS_CODE_SCRAP,   
           NULL HS_NAME_SCRAP,   
           NULL HS_SPEC_SCRAP,   
           'N' TRANSFER_YN,   
           '*' LINE_CODE,   
           0 TARIFF_RATE,   
           '*' SUPPLIER_CODE,   
           '*' CUSTOMER_CODE,   
           NULL MODEL_NAME,   
           NULL MODEL_SUFFIX,   
           'N' AUTO_ISSUE_YN,   
           'N' AUTO_RECEIPT_YN,   
           'Y' AUTO_ISSUE_PLAN_YN,   
           0 BUY_PRICE,   
           0 SALE_PRICE,   
           'N' SALE_PRICE_APPLY_TYPE,   
           0 GROSS_WEIGHT,   
           0 CBM,   
           '*' BARCODE2,   
           NULL EHMS_YN,   
           NULL EHMS_STATUS,   
           NULL MATERIAL_TYPE,   
           NULL PURCHASE_GROUP,   
           NULL PHANTOM_CODE,   
           NULL SUPPLY_TYPE
 FROM IMCN_MOLD
 WHERE ( MOLD_CODE , ORGANIZATION_ID ) NOT IN ( SELECT ITEM_CODE , ORGANIZATION_ID FROM ID_ITEM WHERE ORGANIZATION_ID = :GVI_ORGANIZATION_ID ) 
     AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
	  
IF F_SQL_CHECK() < 0 THEN 
	RETURN 
ELSE
	COMMIT ;
END IF 
end event

type ddlb_mold_group from uo_basecode within w_mcn_mold_master
integer x = 2139
integer y = 156
integer width = 681
integer height = 952
integer taborder = 100
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;this.redraw( 'MOLD GROUP')
end event

event selectionchanged;call super::selectionchanged;f_retrieve()
end event

type st_6 from so_statictext within w_mcn_mold_master
integer x = 2139
integer y = 68
integer width = 681
integer height = 76
boolean bringtotop = true
integer weight = 700
string text = "Mold Group"
end type

type ddlb_mold_code from uo_mold_code within w_mcn_mold_master
integer x = 37
integer y = 156
integer width = 722
integer height = 2084
integer taborder = 30
boolean bringtotop = true
end type

type cbx_auto_receipt_yn from so_checkbox within w_mcn_mold_master
integer x = 3342
integer y = 52
integer width = 421
integer height = 80
boolean bringtotop = true
string text = "Auto Receipt"
end type

type cb_2 from so_commandbutton within w_mcn_mold_master
boolean visible = false
integer x = 5079
integer y = 32
integer width = 448
integer height = 108
integer taborder = 40
boolean bringtotop = true
string text = "Image Batch Upload"
end type

event clicked;call super::clicked;UINT			lui_file
Blob			lb_filecontents , ib_filecontents
string			ls_filename , lvs_file_name , lvs_mold_code
long 			ll_length
int				li_loops,		i  , K 

if getfileopenname( "Select File", lvs_file_name, ls_filename, "JPG", "JPG Files(*.JPG), *.JPG" ) = 1 then
else
	return 
end if 

do 
	
	K++
	
	lvs_mold_code = dw_1.object.mold_code[K]
	lvs_file_name  =  string(long(mid(lvs_mold_code, 5,4))) +'.jpg'
	
	ib_filecontents = Blob( space(0) )
	ll_length = filelength(lvs_file_name)
	
	if ll_length <= 0 then 
		continue 
	end if 
	
	
	lui_file = fileopen( lvs_file_name, StreamMode! )
	
	if	ll_length > 32765 then
		if	mod(ll_length, 32765) = 0 then
			li_loops = ll_length/32765
		else
			li_loops = (ll_length/32765) + 1
		end if
	else
		li_loops = 1
	end if
/***********************************************
* file$$HEX6$$44c720007dc7b4c51cc12000$$ENDHEX$$picture control$$HEX2$$d0c52000$$ENDHEX$$display.
***********************************************/
	for i = 1 to li_loops
		fileread( lui_file, lb_filecontents )
		ib_filecontents = ib_filecontents + lb_filecontents 
	next

	fileclose( lui_file )	
	
	
	
	updateBLOB imcn_mold set mold_image = :ib_filecontents
	where mold_code = :lvs_mold_code  ;
	
     COMMIT ; 

/*****************************************************************************************
*                             End of Script
*****************************************************************************************/
  YIELD()
  
  F_MSG_MDI_HELP(STRING(K))
loop until K = dw_1.rowcount( )
end event

type cb_7 from so_commandbutton within w_mcn_mold_master
integer x = 2880
integer y = 148
integer width = 448
integer height = 112
integer taborder = 30
boolean bringtotop = true
string text = "Image Upload"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return

int    li_filenum , loops, i , lvi_count
long   flen, bytes_read , bytes_read_sum , new_pos
blob   lib_file , b
double lvdb_version   , lvdb_set_serial

string is_filename, is_fullname , lvs_drawing_no , lvs_mold_code
		
		if  dw_1.getrow() < 1 then 
			 return
		end if
			
			lvs_mold_code  = dw_1.getitemstring( dw_1.getrow() , "mold_code" )
	
		if lvs_mold_code ='' or isnull(lvs_mold_code) then 
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
					
//					update imcn_mold set jig_image_file_name = :is_filename 
//					       where mold_code       = :lvs_mold_code
//					          and organization_id = :gvi_organization_id ;
//								 
//					if f_sql_check() < 0 then 
//						return
//					end if 
										  
					updateblob imcn_mold set jig_image = :lib_file 
					       where mold_code       = :lvs_mold_code
					          and organization_id = :gvi_organization_id ;

				  if sqlca.sqlnrows > 0 then

				  else
					  rollback ;
					  messagebox("error" , is_filename+" file upload to database failed "+sqlca.sqlerrtext )
					  return
				  end if;

				  commit ;
			         f_msgbox(9022)
		end if
changedirectory(gvs_default_directory)
end event

type cb_9 from so_commandbutton within w_mcn_mold_master
integer x = 3319
integer y = 148
integer width = 448
integer height = 112
integer taborder = 40
boolean bringtotop = true
string text = "Image Delete"
end type

event clicked;call super::clicked;if f_object_role_check() = false then  return
string lvs_mold_code
blob lblob_null

setnull(lblob_null)

lblob_null = blob(' ')

int lvi_count
				if  dw_1.getrow() < 1 then 
					 return
				end if
			
				lvs_mold_code  = dw_1.getitemstring( dw_1.getrow() , "mold_code" )
				if lvs_mold_code ='' or isnull(lvs_mold_code) then 
					return
				end if		
				
					updateblob  imcn_mold set jig_image = :lblob_null
					where mold_code  = :lvs_mold_code
					  and organization_id   = :gvi_organization_id ;

					if f_sql_check() < 0 then 
						return 
					else
						commit ;
						f_msgbox(9022)
					end if 
changedirectory(gvs_default_directory)

end event

type gb_2 from groupbox within w_mcn_mold_master
integer width = 2839
integer height = 272
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Where Condition"
end type

type gb_4 from groupbox within w_mcn_mold_master
integer x = 3790
integer width = 1262
integer height = 272
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Filter"
end type

type gb_1 from groupbox within w_mcn_mold_master
integer x = 2843
integer width = 933
integer height = 272
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Process"
end type


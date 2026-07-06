HA$PBExportHeader$w_com_supplier_master.srw
$PBExportComments$Customer Infromation Manage
forward
global type w_com_supplier_master from w_main_root
end type
type st_1 from so_statictext within w_com_supplier_master
end type
type ddlb_business_category from uo_basecode within w_com_supplier_master
end type
type st_2 from so_statictext within w_com_supplier_master
end type
type ddlb_supplier_code from uo_supplier_code within w_com_supplier_master
end type
type rb_list from so_radiobutton within w_com_supplier_master
end type
type rb_document from so_radiobutton within w_com_supplier_master
end type
type st_14 from statictext within w_com_supplier_master
end type
type sle_item_name from singlelineedit within w_com_supplier_master
end type
type tab_1 from tab within w_com_supplier_master
end type
type tabpage_1 from userobject within tab_1
end type
type cbx_all from so_checkbox within tabpage_1
end type
type cbx_owns from so_checkbox within tabpage_1
end type
type st_9 from so_statictext within tabpage_1
end type
type ddlb_to_org from uo_orz_id within tabpage_1
end type
type ddlb_from_org from uo_orz_id within tabpage_1
end type
type st_8 from so_statictext within tabpage_1
end type
type cb_3 from so_commandbutton within tabpage_1
end type
type tabpage_1 from userobject within tab_1
cbx_all cbx_all
cbx_owns cbx_owns
st_9 st_9
ddlb_to_org ddlb_to_org
ddlb_from_org ddlb_from_org
st_8 st_8
cb_3 cb_3
end type
type tabpage_2 from userobject within tab_1
end type
type cb_open from so_commandbutton within tabpage_2
end type
type cb_attach from so_commandbutton within tabpage_2
end type
type cb_update from so_commandbutton within tabpage_2
end type
type cb_delete from so_commandbutton within tabpage_2
end type
type cb_insert from so_commandbutton within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_open cb_open
cb_attach cb_attach
cb_update cb_update
cb_delete cb_delete
cb_insert cb_insert
end type
type tab_1 from tab within w_com_supplier_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type gb_1 from groupbox within w_com_supplier_master
end type
type gb_3 from groupbox within w_com_supplier_master
end type
end forward

global type w_com_supplier_master from w_main_root
integer y = 256
integer width = 5550
integer height = 3208
string title = "Supplier Manage"
st_1 st_1
ddlb_business_category ddlb_business_category
st_2 st_2
ddlb_supplier_code ddlb_supplier_code
rb_list rb_list
rb_document rb_document
st_14 st_14
sle_item_name sle_item_name
tab_1 tab_1
gb_1 gb_1
gb_3 gb_3
end type
global w_com_supplier_master w_com_supplier_master

on w_com_supplier_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_business_category=create ddlb_business_category
this.st_2=create st_2
this.ddlb_supplier_code=create ddlb_supplier_code
this.rb_list=create rb_list
this.rb_document=create rb_document
this.st_14=create st_14
this.sle_item_name=create sle_item_name
this.tab_1=create tab_1
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_business_category
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.ddlb_supplier_code
this.Control[iCurrent+5]=this.rb_list
this.Control[iCurrent+6]=this.rb_document
this.Control[iCurrent+7]=this.st_14
this.Control[iCurrent+8]=this.sle_item_name
this.Control[iCurrent+9]=this.tab_1
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_3
end on

on w_com_supplier_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_business_category)
destroy(this.st_2)
destroy(this.ddlb_supplier_code)
destroy(this.rb_list)
destroy(this.rb_document)
destroy(this.st_14)
destroy(this.sle_item_name)
destroy(this.tab_1)
destroy(this.gb_1)
destroy(this.gb_3)
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
Ivs_resize_type    = 'MASTER_DETAIL_145_23'        // Resize Data Window Property ( NORMAL , MASTER_DETAIL )
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
STRING LVS_RCV_ISS_TYPE
CHOOSE CASE Gvs_Ue_DATA_control
	CASE 'RETRIEVE'

 			DW_1.RETRIEVE( ddlb_supplier_code.TEXT+'%'  , ddlb_business_category.getcode()+'%' , gvi_organization_id )

	CASE	'INSERT'
		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(DW_2.GETROW())
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')				
			
//			DW_2.setitem(ROW , 'vendor_id' , f_get_max_vendor_id( 'S')) //CUSTOMER MAX
			DW_2.setitem(ROW , 'dateset' , f_sysdate())
			DW_2.setitem(ROW , 'dateend' , date('9999/12/31'))		
			DW_2.setitem(ROW , 'business_status' , 'A')			
//			DW_2.setitem(ROW , 'business_category' , 'S')						
			DW_2.setitem(ROW , 'business_type' , 'S')						

	CASE	'APPEND'
		
			DW_2.ENABLED = TRUE
			ROW = DW_2.INSERTROW(0)
			DW_2.SCROLLTOROW(ROW)
			F_SET_SECURITY_ROW(DW_2 , ROW ,'ALL')	
//			DW_2.setitem(ROW , 'vendor_id' , f_get_max_vendor_id( 'S')) //CUSTOMER MAX			
			DW_2.setitem(ROW , 'dateset' , f_sysdate())
			DW_2.setitem(ROW , 'dateend' , date('9999/12/31'))						
			DW_2.setitem(ROW , 'business_status' , 'A')			
//			DW_2.setitem(ROW , 'business_category' , 'S')									
			DW_2.setitem(ROW , 'business_type' , 'S')									

			
	CASE	'DELETE'
			if DW_2.AcceptText() = -1 then
				return
			end if
			
			if dw_2.getrow() < 1 then return
			
			if dw_2.object.supplier_code[dw_2.getrow()] = '*' then
				//Mes sagebox("Notify" , "Default Supplier Can`t Delete!")
				f_msg( "Default Supplier Can`t Delete!",'P') 
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

	CASE 'UPDATE'

	         IF DW_2.UPDATE() < 0 THEN
			  	 ROLLBACK;
			ELSE
				 COMMIT;
	                F_RETRIEVE()				 
				 F_MSG_MDI_HELP( "Update Complete" )//$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
			END IF

 		
	CASE ELSE
END CHOOSE


end event

event ue_post_open;call super::ue_post_open;/****************************************
* $$HEX15$$08c7c4b358c7d0c5200000b35cd5200004d55cb87cd3f0d2200024c115c8$$ENDHEX$$
*****************************************/
WF_SET_WINDOW_PROPERTY(this.classname())
end event

type dw_5 from w_main_root`dw_5 within w_com_supplier_master
integer y = 332
end type

type dw_4 from w_main_root`dw_4 within w_com_supplier_master
integer y = 332
integer taborder = 80
end type

type dw_3 from w_main_root`dw_3 within w_com_supplier_master
integer y = 1464
integer width = 4599
integer height = 1108
integer taborder = 70
boolean titlebar = true
string title = "Supplier Document"
string dataobject = "d_com_supplier_document"
boolean resizable = true
end type

type dw_2 from w_main_root`dw_2 within w_com_supplier_master
integer y = 1464
integer width = 4599
integer height = 1108
integer taborder = 100
string title = "Sale Price Confirm"
string dataobject = "d_com_supplier_mst"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_com_supplier_master
integer y = 332
integer width = 4608
integer height = 1128
boolean titlebar = true
string title = "Supplier List"
string dataobject = "d_com_supplier_lst"
borderstyle borderstyle = styleraised!
end type

event dw_1::doubleclicked;call super::doubleclicked;IF	ROW < 1	THEN	RETURN

IF RB_LIST.CHECKED = TRUE THEN 
	DW_2.RETRIEVE( DW_1.GETITEMSTRING( ROW, 'SUPPLIER_CODE' ) , GVI_ORGANIZATION_ID )
	DW_1.SETFOCUS()
ELSE
	DW_3.RETRIEVE( DW_1.GETITEMSTRING( ROW, 'SUPPLIER_CODE' ) , GVI_ORGANIZATION_ID )
	DW_1.SETFOCUS()	
END IF
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF	CURRENTROW < 1	THEN	RETURN

IF rb_list.CHECKED = TRUE THEN 
	DW_2.RETRIEVE( DW_1.GETITEMSTRING( CURRENTROW, 'SUPPLIER_CODE' ) , GVI_ORGANIZATION_ID )
	DW_1.SETFOCUS()
ELSE
	DW_3.RETRIEVE( DW_1.GETITEMSTRING( CURRENTROW, 'SUPPLIER_CODE' ) , GVI_ORGANIZATION_ID )
	DW_1.SETFOCUS()	
END IF


end event

type uo_tabpages from w_main_root`uo_tabpages within w_com_supplier_master
end type

type st_1 from so_statictext within w_com_supplier_master
integer x = 722
integer y = 84
integer width = 485
integer height = 48
boolean bringtotop = true
boolean enabled = false
string text = "Supplier Code"
end type

type ddlb_business_category from uo_basecode within w_com_supplier_master
integer x = 1211
integer y = 156
integer width = 539
integer height = 676
integer taborder = 20
boolean bringtotop = true
end type

event getfocus;call super::getfocus;this.redraw( 'BUSINESS CATEGORY')
end event

type st_2 from so_statictext within w_com_supplier_master
integer x = 1211
integer y = 84
integer width = 539
integer height = 48
boolean bringtotop = true
boolean enabled = false
string text = "Business Category"
end type

type ddlb_supplier_code from uo_supplier_code within w_com_supplier_master
integer x = 722
integer y = 156
integer width = 485
integer taborder = 20
boolean bringtotop = true
end type

type rb_list from so_radiobutton within w_com_supplier_master
integer x = 59
integer y = 72
integer width = 590
boolean bringtotop = true
string text = "Supplier List"
boolean checked = true
end type

event clicked;call super::clicked;dw_2.bringtotop = true 
selected_data_window = dw_2

tab_1.tabpage_2.cb_insert.enabled = false
tab_1.tabpage_2.cb_attach.enabled = false
tab_1.tabpage_2.cb_delete.enabled = false
tab_1.tabpage_2.cb_update.enabled = false
tab_1.tabpage_2.cb_open.enabled = false
end event

type rb_document from so_radiobutton within w_com_supplier_master
integer x = 59
integer y = 172
integer width = 590
boolean bringtotop = true
string text = "Supplier Document"
end type

event clicked;call super::clicked;dw_3.bringtotop = true 
selected_data_window = dw_3


tab_1.tabpage_2.cb_insert.enabled = true
tab_1.tabpage_2.cb_attach.enabled = true
tab_1.tabpage_2.cb_delete.enabled = true
tab_1.tabpage_2.cb_update.enabled = true
tab_1.tabpage_2.cb_open.enabled = true


IF DW_1.GETROW() < 1 THEN 
	RETURN
END IF
DW_3.RETRIEVE( DW_1.GETITEMSTRING( DW_1.GETROW(), 'SUPPLIER_CODE' ) , GVI_ORGANIZATION_ID )
DW_1.SETFOCUS()	
end event

type st_14 from statictext within w_com_supplier_master
integer x = 1755
integer y = 88
integer width = 530
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Document Keyword"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_item_name from singlelineedit within w_com_supplier_master
event ue_editchange pbm_enchange
integer x = 1755
integer y = 156
integer width = 530
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "h_beam.cur"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

DW_3.SETFILTER('')
DW_3.FILTER()

LVS_COLUMN = 'DOCUMENT_KEYWORD'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    DW_3.SETFILTER('')
    DW_3.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_3.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_3.FILTER()
F_MSG_MDI_HELP( STRING( DW_3.ROWCOUNT() ) + " Found" )
end event

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

type tab_1 from tab within w_com_supplier_master
event create ( )
event destroy ( )
integer x = 2322
integer y = 12
integer width = 2080
integer height = 280
integer taborder = 20
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
integer width = 2043
integer height = 152
long backcolor = 15780518
string text = "Transfer"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Synchronizer!"
long picturemaskcolor = 12632256
cbx_all cbx_all
cbx_owns cbx_owns
st_9 st_9
ddlb_to_org ddlb_to_org
ddlb_from_org ddlb_from_org
st_8 st_8
cb_3 cb_3
end type

on tabpage_1.create
this.cbx_all=create cbx_all
this.cbx_owns=create cbx_owns
this.st_9=create st_9
this.ddlb_to_org=create ddlb_to_org
this.ddlb_from_org=create ddlb_from_org
this.st_8=create st_8
this.cb_3=create cb_3
this.Control[]={this.cbx_all,&
this.cbx_owns,&
this.st_9,&
this.ddlb_to_org,&
this.ddlb_from_org,&
this.st_8,&
this.cb_3}
end on

on tabpage_1.destroy
destroy(this.cbx_all)
destroy(this.cbx_owns)
destroy(this.st_9)
destroy(this.ddlb_to_org)
destroy(this.ddlb_from_org)
destroy(this.st_8)
destroy(this.cb_3)
end on

type cbx_all from so_checkbox within tabpage_1
integer x = 32
integer y = 80
integer width = 389
integer height = 60
long backcolor = 15780518
string text = "All"
end type

type cbx_owns from so_checkbox within tabpage_1
integer x = 32
integer y = 12
integer width = 389
integer height = 64
long backcolor = 15780518
string text = "Own~'s"
boolean checked = true
end type

type st_9 from so_statictext within tabpage_1
integer x = 1070
integer y = 4
integer width = 590
integer height = 60
boolean bringtotop = true
long backcolor = 15780518
string text = "To"
end type

type ddlb_to_org from uo_orz_id within tabpage_1
integer x = 1070
integer y = 60
integer width = 590
integer taborder = 90
boolean bringtotop = true
end type

type ddlb_from_org from uo_orz_id within tabpage_1
integer x = 457
integer y = 60
integer width = 603
integer taborder = 80
boolean bringtotop = true
end type

type st_8 from so_statictext within tabpage_1
integer x = 462
integer width = 603
integer height = 60
boolean bringtotop = true
long backcolor = 15780518
string text = "From"
end type

type cb_3 from so_commandbutton within tabpage_1
integer x = 1682
integer y = 32
integer width = 361
integer height = 108
integer taborder = 70
boolean bringtotop = true
string text = "Sync"
end type

event clicked;call super::clicked;LONG  i
INT LVI_FROM_ORG , LVI_TO_ORG , lvi_count
STRING lvs_own_supplier_code

LVI_FROM_ORG = INTEGER( DDLB_FROM_ORG.GETCODE( ) )
LVI_TO_ORG = INTEGER( DDLB_TO_ORG.GETCODE( ) )

msg = f_msgbox1( 1161 , this.text)
if msg = 1 then
else
	return
end if

//====================================
//
//====================================

if cbx_owns.checked = true then 

	 lvs_own_supplier_code = f_get_supplier_code_oneself(LVI_FROM_ORG)
	
	if lvs_own_supplier_code = '' or isnull(lvs_own_supplier_code) then
		
		//Mess agebox("Notify" , "Own's Supplier Code not found!")
		f_msg("Own's Supplier Code not found!",'P')
		return
	end if
	
	SELECT COUNT(*) INTO :LVI_COUNT
	  FROM "ICOM_SUPPLIER"  
      WHERE ORGANIZATION_ID = 	  :LVI_TO_ORG
  	    AND SUPPLIER_CODE = :lvs_own_supplier_code ;
	  
	IF F_SQL_CHECK() < 0 THEN 
		RETURN
	END IF 
	
	IF LVI_COUNT > 0 THEN 
		
		MESSAGEBOX("Notify" , lvs_own_supplier_code+ '  ' + f_msg( "Already Exists Please Check Again",'S') )
		
		return
		
	END IF
	  

	  INSERT INTO "ICOM_SUPPLIER"  
         ( "SUPPLIER_CODE",   
           "ORGANIZATION_ID",   
           "SUPPLIER_NAME",   
           "DATEEND",   
           "DATESET",   
           "SUPPLIER_NAME_ENG",   
           "BUSINESS_NO",   
           "BUSINESS_CATEGORY",   
           "BUSINESS_STATUS",   
           "BUSINESS_TYPE",   
           "SUPPLIER_CHARGE_NAME",   
           "PAYMENT_TYPE",   
           "BANK_ACCOUNT",   
           "BANK_ADDRESS",   
           "OWNER_NAME",   
           "BANK_ADDRESS_ENG",   
           "ADDRESS",   
           "BANK_NAME",   
           "TEL_NO",   
           "BANK_NAME_ENG",   
           "FAX_NO",   
           "ENTER_DATE",   
           "EMPLOYEE_QTY",   
           "ENTER_BY",   
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY",   
           "HANDPHONE_NO",   
           "HOME_PAGE",   
           "EMAIL_ADDRESS",   
           "FOUND_DATE",   
           "CUSTOM_CODE",   
           "VIRTUAL_RECEIPT_YN",   
           "BUSINESS_TAX_NO",   
           "PAYMENT_CYCLE",   
           "TRADE_TYPE",   
           "TRADE_CODE",   
           "NATION_CODE" )  
     SELECT "ICOM_SUPPLIER"."SUPPLIER_CODE",   
            :LVI_TO_ORG , //"ICOM_SUPPLIER"."ORGANIZATION_ID",   
            "ICOM_SUPPLIER"."SUPPLIER_NAME",   
            "ICOM_SUPPLIER"."DATEEND",   
            "ICOM_SUPPLIER"."DATESET",   
            "ICOM_SUPPLIER"."SUPPLIER_NAME_ENG",   
            "ICOM_SUPPLIER"."BUSINESS_NO",   
            "ICOM_SUPPLIER"."BUSINESS_CATEGORY",   
            "ICOM_SUPPLIER"."BUSINESS_STATUS",   
            'S' , //"ICOM_SUPPLIER"."BUSINESS_TYPE",   
            "ICOM_SUPPLIER"."SUPPLIER_CHARGE_NAME",   
            "ICOM_SUPPLIER"."PAYMENT_TYPE",   
            "ICOM_SUPPLIER"."BANK_ACCOUNT",   
            "ICOM_SUPPLIER"."BANK_ADDRESS",   
            "ICOM_SUPPLIER"."OWNER_NAME",   
            "ICOM_SUPPLIER"."BANK_ADDRESS_ENG",   
            "ICOM_SUPPLIER"."ADDRESS",   
            "ICOM_SUPPLIER"."BANK_NAME",   
            "ICOM_SUPPLIER"."TEL_NO",   
            "ICOM_SUPPLIER"."BANK_NAME_ENG",   
            "ICOM_SUPPLIER"."FAX_NO",   
            "ICOM_SUPPLIER"."ENTER_DATE",   
            "ICOM_SUPPLIER"."EMPLOYEE_QTY",   
            "ICOM_SUPPLIER"."ENTER_BY",   
            "ICOM_SUPPLIER"."LAST_MODIFY_DATE",   
            "ICOM_SUPPLIER"."LAST_MODIFY_BY",   
            "ICOM_SUPPLIER"."HANDPHONE_NO",   
            "ICOM_SUPPLIER"."HOME_PAGE",   
            "ICOM_SUPPLIER"."EMAIL_ADDRESS",   
            "ICOM_SUPPLIER"."FOUND_DATE",   
            "ICOM_SUPPLIER"."CUSTOM_CODE",   
            "ICOM_SUPPLIER"."VIRTUAL_RECEIPT_YN",   
            "ICOM_SUPPLIER"."BUSINESS_TAX_NO",   
            "ICOM_SUPPLIER"."PAYMENT_CYCLE",   
            "ICOM_SUPPLIER"."TRADE_TYPE",   
            "ICOM_SUPPLIER"."TRADE_CODE",   
            "ICOM_SUPPLIER"."NATION_CODE"  
       FROM "ICOM_SUPPLIER"  
WHERE SUPPLIER_CODE = :lvs_own_supplier_code
    AND ORGANIZATION_ID = 		:LVI_FROM_ORG  ;

	
	IF F_SQL_CHECK() < 0 THEN 
		RETURN
	END IF 
end if 

//===================================
//
//===================================

if cbx_all.checked = true then 

	  INSERT INTO "ICOM_SUPPLIER"  
         ( "SUPPLIER_CODE",   
           "ORGANIZATION_ID",   
           "SUPPLIER_NAME",   
           "DATEEND",   
           "DATESET",   
           "SUPPLIER_NAME_ENG",   
           "BUSINESS_NO",   
           "BUSINESS_CATEGORY",   
           "BUSINESS_STATUS",   
           "BUSINESS_TYPE",   
           "SUPPLIER_CHARGE_NAME",   
           "PAYMENT_TYPE",   
           "BANK_ACCOUNT",   
           "BANK_ADDRESS",   
           "OWNER_NAME",   
           "BANK_ADDRESS_ENG",   
           "ADDRESS",   
           "BANK_NAME",   
           "TEL_NO",   
           "BANK_NAME_ENG",   
           "FAX_NO",   
           "ENTER_DATE",   
           "EMPLOYEE_QTY",   
           "ENTER_BY",   
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY",   
           "HANDPHONE_NO",   
           "HOME_PAGE",   
           "EMAIL_ADDRESS",   
           "FOUND_DATE",   
           "CUSTOM_CODE",   
           "VIRTUAL_RECEIPT_YN",   
           "BUSINESS_TAX_NO",   
           "PAYMENT_CYCLE",   
           "TRADE_TYPE",   
           "TRADE_CODE",   
           "NATION_CODE" )  
     SELECT "ICOM_SUPPLIER"."SUPPLIER_CODE",   
            :LVI_TO_ORG , //"ICOM_SUPPLIER"."ORGANIZATION_ID",   
            "ICOM_SUPPLIER"."SUPPLIER_NAME",   
            "ICOM_SUPPLIER"."DATEEND",   
            "ICOM_SUPPLIER"."DATESET",   
            "ICOM_SUPPLIER"."SUPPLIER_NAME_ENG",   
            "ICOM_SUPPLIER"."BUSINESS_NO",   
            "ICOM_SUPPLIER"."BUSINESS_CATEGORY",   
            "ICOM_SUPPLIER"."BUSINESS_STATUS",   
            'S' , //"ICOM_SUPPLIER"."BUSINESS_TYPE",   
            "ICOM_SUPPLIER"."SUPPLIER_CHARGE_NAME",   
            "ICOM_SUPPLIER"."PAYMENT_TYPE",   
            "ICOM_SUPPLIER"."BANK_ACCOUNT",   
            "ICOM_SUPPLIER"."BANK_ADDRESS",   
            "ICOM_SUPPLIER"."OWNER_NAME",   
            "ICOM_SUPPLIER"."BANK_ADDRESS_ENG",   
            "ICOM_SUPPLIER"."ADDRESS",   
            "ICOM_SUPPLIER"."BANK_NAME",   
            "ICOM_SUPPLIER"."TEL_NO",   
            "ICOM_SUPPLIER"."BANK_NAME_ENG",   
            "ICOM_SUPPLIER"."FAX_NO",   
            "ICOM_SUPPLIER"."ENTER_DATE",   
            "ICOM_SUPPLIER"."EMPLOYEE_QTY",   
            "ICOM_SUPPLIER"."ENTER_BY",   
            "ICOM_SUPPLIER"."LAST_MODIFY_DATE",   
            "ICOM_SUPPLIER"."LAST_MODIFY_BY",   
            "ICOM_SUPPLIER"."HANDPHONE_NO",   
            "ICOM_SUPPLIER"."HOME_PAGE",   
            "ICOM_SUPPLIER"."EMAIL_ADDRESS",   
            "ICOM_SUPPLIER"."FOUND_DATE",   
            "ICOM_SUPPLIER"."CUSTOM_CODE",   
            "ICOM_SUPPLIER"."VIRTUAL_RECEIPT_YN",   
            "ICOM_SUPPLIER"."BUSINESS_TAX_NO",   
            "ICOM_SUPPLIER"."PAYMENT_CYCLE",   
            "ICOM_SUPPLIER"."TRADE_TYPE",   
            "ICOM_SUPPLIER"."TRADE_CODE",   
            "ICOM_SUPPLIER"."NATION_CODE"  
       FROM "ICOM_SUPPLIER"  
     WHERE SUPPLIER_CODE  not in ( select supplier_code  from ICOM_SUPPLIER where organization_id = :lvi_to_org )
          AND ORGANIZATION_ID = 		:LVI_FROM_ORG  ;

	
	IF F_SQL_CHECK() < 0 THEN 
		RETURN
	END IF 
end if 

//====================================	  
MSG = F_MSGBOX1( 9014  , String(sqlca.sqlnrows) )
IF MSG = 1 THEN 
	COMMIT ;
ELSE
	ROLLBACK;
END IF
end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2043
integer height = 152
long backcolor = 15780518
string text = "Documents"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "DosEdit5!"
long picturemaskcolor = 536870912
cb_open cb_open
cb_attach cb_attach
cb_update cb_update
cb_delete cb_delete
cb_insert cb_insert
end type

on tabpage_2.create
this.cb_open=create cb_open
this.cb_attach=create cb_attach
this.cb_update=create cb_update
this.cb_delete=create cb_delete
this.cb_insert=create cb_insert
this.Control[]={this.cb_open,&
this.cb_attach,&
this.cb_update,&
this.cb_delete,&
this.cb_insert}
end on

on tabpage_2.destroy
destroy(this.cb_open)
destroy(this.cb_attach)
destroy(this.cb_update)
destroy(this.cb_delete)
destroy(this.cb_insert)
end on

type cb_open from so_commandbutton within tabpage_2
integer x = 1413
integer y = 16
integer width = 347
integer height = 112
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string text = "Open"
end type

event clicked;call super::clicked;if dw_3.getrow() < 1 then 
	return
end if

Long Lvl_return
String  lvs_file_name
if dw_3.getrow() < 1 then return 

Lvl_return =  f_download_supplier_document ( String(dw_3.object.supplier_code[dw_3.getrow()]) , Double(dw_3.object.sequence[dw_3.getrow()] ) )

if  Lvl_return > 0 then 

	lvs_file_name = getcurrentdirectory()+"\Temp\"+dw_3.object.document_name[dw_3.getrow()] 
	
	IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
		RETURN
	END IF
	
	f_shell_execute_by_extention ( dw_3.object.document_name[dw_3.getrow()]  , '' , getcurrentdirectory()+'\Temp'  )
	
else
	
end if

end event

type cb_attach from so_commandbutton within tabpage_2
integer x = 1061
integer y = 16
integer width = 347
integer height = 112
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string text = "Attach"
end type

event clicked;call super::clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
		int    li_FileNum , loops, i , lvi_count
		long   flen, bytes_read , bytes_read_sum , new_pos
		blob   LIB_FILE , b
		string is_filename, is_fullname , LVS_SUPPLIER_CODE , LVS_ITEM_CODE
		double LVDB_SEQUENCE
		
		IF  DW_3.GETROW() < 1 THEN 
			 RETURN
		END IF
		
		LVS_SUPPLIER_CODE = DW_3.GETITEMSTRING( DW_3.GETROW() , "SUPPLIER_CODE" )
		LVDB_SEQUENCE        = DW_3.GETITEMnumber( DW_3.GETROW() , "SEQUENCE" )		

		IF LVS_SUPPLIER_CODE ='' OR ISNULL(LVS_SUPPLIER_CODE) THEN 
			RETURN
		END IF
		
		if GetFileOpenName("Select File", &
			 is_fullname, is_filename, "PPT", &
			 + "PPT Files (*.PPT),*.PPT," &
			 + "XLS Files (*.XLS),*.XLS," &
			 + "DOC Files (*.DOC),*.DOC," &			 
			 + "All Files (*.*), *.*") < 1 then return
		
		flen = FileLength(is_fullname)
		
		IF FLEN < 0 THEN 
			changedirectory(Gvs_default_directory)		
			F_MSGBOX1(9020 ,is_fullname )
			//("Error" , is_fullname+" File Length Unknown")
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
					  from ICOM_SUPPLIER_DOCUMENT
					 WHERE SUPPLIER_CODE   = :LVS_SUPPLIER_CODE 
					   AND SEQUENCE               = :LVDB_SEQUENCE
					   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
						  
					IF F_SQL_CHECK() < 0 THEN 
						changedirectory(Gvs_default_directory)		
						RETURN
					END IF				  
					
					if lvi_count = 0 then 
						changedirectory(Gvs_default_directory)		 
						F_MSGBOX1( 9021 , is_filename ) 
						//("Error", is_filename+" File Name Not Found !" )
						return
					end if
						  
					UPDATEBLOB ICOM_SUPPLIER_DOCUMENT SET DOCUMENT_DATA = :LIB_FILE 
					WHERE SUPPLIER_CODE   = :LVS_SUPPLIER_CODE 
					   AND SEQUENCE = :LVDB_SEQUENCE
					   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
						
					  IF F_SQL_CHECK() < 0 THEN 
						 changedirectory(Gvs_default_directory)		
						  RETURN
					  END IF						
						
					UPDATE ICOM_SUPPLIER_DOCUMENT SET DOCUMENT_NAME = :is_filename 
					WHERE SUPPLIER_CODE   = :LVS_SUPPLIER_CODE 
					   AND SEQUENCE = :LVDB_SEQUENCE
					   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;						
						
					  IF F_SQL_CHECK() < 0 THEN 
						  changedirectory(Gvs_default_directory)								
						  RETURN
					  END IF						
					 
				
				  COMMIT ;
				  
				  IF SQLCA.SQLNROWS > 0 THEN
					  changedirectory(Gvs_default_directory)							
		 			  F_MSG_MDI_HELP( F_MSG_ST(9022) ) 
					  DW_3.RETRIEVE( DW_1.GETITEMSTRING( DW_1.GETROW(), 'SUPPLIER_CODE' ) , GVI_ORGANIZATION_ID )
					  DW_1.SETFOCUS()							
				  ELSE
					  f_msgbox1( 157 , is_filename )   //("Error" , is_filename+"File Upload To Database Failed" )
					  
				  END IF;
		END IF
		
changedirectory(Gvs_default_directory)		
end event

type cb_update from so_commandbutton within tabpage_2
integer x = 709
integer y = 16
integer width = 347
integer height = 112
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string text = "Update"
end type

event clicked;call super::clicked;MSG = F_MSGBOX1( 9014 , STRING(DW_3.ModifiedCount()) )
IF MSG = 1 THEN 	
	IF DW_3.UPDATE() < 0 THEN 
		ROLLBACK ;
		f_msg_mdi_help(f_msg_st(9026))
	ELSE
		COMMIT ;
		 F_MSG_MDI_HELP ( F_MSG_ST(170)	 ) //$$HEX14$$31c1f5ac01c83cc75cb8200000c8a5c7200018b4c8c5b5c2c8b2e4b2$$ENDHEX$$"
		 F_RETRIEVE()		 
	END IF	
END IF
end event

type cb_delete from so_commandbutton within tabpage_2
integer x = 357
integer y = 16
integer width = 347
integer height = 112
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string text = "Delete"
end type

event clicked;call super::clicked;if dw_3.getrow() < 1 then 
	return
end if

dw_3.deleterow( dw_3.getrow())
end event

type cb_insert from so_commandbutton within tabpage_2
integer x = 5
integer y = 16
integer width = 347
integer height = 112
integer taborder = 20
boolean bringtotop = true
boolean enabled = false
string text = "Insert"
end type

event clicked;call super::clicked;LONG ROW 
IF DW_1.GETROW() <  1 THEN 
	RETURN
END IF

ROW = DW_3.INSERTROW( 0 )
DW_3.OBJECT.SUPPLIER_CODE[ROW] = DW_1.OBJECT.SUPPLIER_CODE[DW_1.GETROW()]
DW_3.OBJECT.SEQUENCE[ROW] = F_GET_SEQUENCE('SEQ_SUPPLIER_DOCUMENT') 
DW_3.OBJECT.REG_DATE[ROW] = F_T_SYSDATE()
F_SET_SECURITY_ROW( DW_3 , ROW , 'ALL')

end event

type gb_1 from groupbox within w_com_supplier_master
integer x = 695
integer width = 1618
integer height = 284
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

type gb_3 from groupbox within w_com_supplier_master
integer width = 695
integer height = 288
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Category"
end type


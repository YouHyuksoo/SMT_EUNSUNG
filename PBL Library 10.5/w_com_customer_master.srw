HA$PBExportHeader$w_com_customer_master.srw
$PBExportComments$Customer Infromation Manage
forward
global type w_com_customer_master from w_main_root
end type
type st_1 from so_statictext within w_com_customer_master
end type
type ddlb_business_category from uo_basecode within w_com_customer_master
end type
type st_2 from so_statictext within w_com_customer_master
end type
type ddlb_customer_code from uo_customer_code within w_com_customer_master
end type
type rb_list from so_radiobutton within w_com_customer_master
end type
type rb_document from so_radiobutton within w_com_customer_master
end type
type st_4 from so_statictext within w_com_customer_master
end type
type sle_1 from so_singlelineedit within w_com_customer_master
end type
type tab_1 from tab within w_com_customer_master
end type
type tabpage_1 from userobject within tab_1
end type
type ddlb_to_org from uo_orz_id within tabpage_1
end type
type st_9 from so_statictext within tabpage_1
end type
type st_8 from so_statictext within tabpage_1
end type
type ddlb_from_org from uo_orz_id within tabpage_1
end type
type cb_3 from so_commandbutton within tabpage_1
end type
type tabpage_1 from userobject within tab_1
ddlb_to_org ddlb_to_org
st_9 st_9
st_8 st_8
ddlb_from_org ddlb_from_org
cb_3 cb_3
end type
type tabpage_2 from userobject within tab_1
end type
type cb_insert from so_commandbutton within tabpage_2
end type
type cb_delete from so_commandbutton within tabpage_2
end type
type cb_update from so_commandbutton within tabpage_2
end type
type cb_attach from so_commandbutton within tabpage_2
end type
type cb_open from so_commandbutton within tabpage_2
end type
type tabpage_2 from userobject within tab_1
cb_insert cb_insert
cb_delete cb_delete
cb_update cb_update
cb_attach cb_attach
cb_open cb_open
end type
type tab_1 from tab within w_com_customer_master
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type gb_1 from groupbox within w_com_customer_master
end type
type gb_3 from groupbox within w_com_customer_master
end type
end forward

global type w_com_customer_master from w_main_root
integer y = 256
integer height = 3000
string title = "Customer Manage"
st_1 st_1
ddlb_business_category ddlb_business_category
st_2 st_2
ddlb_customer_code ddlb_customer_code
rb_list rb_list
rb_document rb_document
st_4 st_4
sle_1 sle_1
tab_1 tab_1
gb_1 gb_1
gb_3 gb_3
end type
global w_com_customer_master w_com_customer_master

on w_com_customer_master.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_business_category=create ddlb_business_category
this.st_2=create st_2
this.ddlb_customer_code=create ddlb_customer_code
this.rb_list=create rb_list
this.rb_document=create rb_document
this.st_4=create st_4
this.sle_1=create sle_1
this.tab_1=create tab_1
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_business_category
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.ddlb_customer_code
this.Control[iCurrent+5]=this.rb_list
this.Control[iCurrent+6]=this.rb_document
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.sle_1
this.Control[iCurrent+9]=this.tab_1
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_3
end on

on w_com_customer_master.destroy
call super::destroy
destroy(this.st_1)
destroy(this.ddlb_business_category)
destroy(this.st_2)
destroy(this.ddlb_customer_code)
destroy(this.rb_list)
destroy(this.rb_document)
destroy(this.st_4)
destroy(this.sle_1)
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
STRING LVS_RCV_ISS_TYPE , lvs_sale_charge
CHOOSE CASE Gvs_Ue_DATA_control
	CASE 'RETRIEVE'

				if Gvs_use_sale_charge_condition = 'Y' and Gvi_user_level < 8 then
					lvs_sale_charge = Gvs_user_id
				else
					lvs_sale_charge = '%'
				end if
				
 			DW_1.RETRIEVE( ddlb_customer_code.TEXT+'%'  , ddlb_business_category.getcode()+'%' , lvs_sale_charge , gvi_organization_id )
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
			DW_2.setitem(ROW , 'business_type' , 'C')			
			DW_2.setitem(ROW , 'sale_charge' , gvs_user_id)	

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
			DW_2.setitem(ROW , 'business_type' , 'C')	
			DW_2.setitem(ROW , 'sale_charge' , gvs_user_id)	

			
	CASE	'DELETE'
			if DW_2.AcceptText() = -1 then
				return
			end if
			
			if dw_2.getrow() < 1 then return
			
			if dw_2.object.customer_code[dw_2.getrow()] = '*' then
				//Mes sagebox("Notify" , "Default Customer Can`t Delete!")
				f_msg( "Default Customer Can`t Delete!","P")
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

type dw_5 from w_main_root`dw_5 within w_com_customer_master
integer y = 316
end type

type dw_4 from w_main_root`dw_4 within w_com_customer_master
integer y = 316
integer taborder = 80
end type

type dw_3 from w_main_root`dw_3 within w_com_customer_master
integer y = 1244
integer width = 4599
integer height = 908
integer taborder = 70
boolean titlebar = true
string title = "Customer Document List"
string dataobject = "d_com_customer_document"
end type

type dw_2 from w_main_root`dw_2 within w_com_customer_master
integer y = 1244
integer width = 4599
integer height = 1136
integer taborder = 100
string title = "Sale Price Confirm"
string dataobject = "d_com_custom_mst"
boolean hscrollbar = false
boolean vscrollbar = false
boolean hsplitscroll = false
boolean livescroll = false
end type

type dw_1 from w_main_root`dw_1 within w_com_customer_master
integer y = 316
integer width = 4599
integer height = 924
boolean titlebar = true
string title = "Customer List"
string dataobject = "d_com_customer_lst"
borderstyle borderstyle = styleraised!
end type

event dw_1::doubleclicked;call super::doubleclicked;IF	ROW < 1	THEN	RETURN

IF RB_LIST.CHECKED = TRUE THEN 
	DW_2.RETRIEVE( DW_1.GETITEMSTRING( ROW, 'ROWID' ))
	DW_1.SETFOCUS()
ELSE
	DW_3.RETRIEVE( DW_1.GETITEMSTRING( ROW, 'CUSTOMER_CODE' ) , GVI_ORGANIZATION_ID )
	DW_1.SETFOCUS()	
END IF
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;IF	CURRENTROW < 1	THEN	RETURN

IF RB_LIST.CHECKED = TRUE THEN 
	DW_2.RETRIEVE( DW_1.GETITEMSTRING( CURRENTROW, 'ROWID' ))
	DW_1.SETFOCUS()
ELSE
	DW_3.RETRIEVE( DW_1.GETITEMSTRING( CURRENTROW, 'CUSTOMER_CODE' ) , GVI_ORGANIZATION_ID )
	DW_1.SETFOCUS()	
END IF
end event

type uo_tabpages from w_main_root`uo_tabpages within w_com_customer_master
end type

type st_1 from so_statictext within w_com_customer_master
integer x = 754
integer y = 76
integer width = 581
integer height = 60
boolean bringtotop = true
boolean enabled = false
string text = "Customer Code"
end type

type ddlb_business_category from uo_basecode within w_com_customer_master
integer x = 1339
integer y = 144
integer width = 581
integer height = 676
integer taborder = 20
boolean bringtotop = true
end type

event getfocus;call super::getfocus;this.redraw( 'BUSINESS CATEGORY')
end event

type st_2 from so_statictext within w_com_customer_master
integer x = 1339
integer y = 76
integer width = 581
integer height = 60
boolean bringtotop = true
boolean enabled = false
string text = "Business Category"
end type

type ddlb_customer_code from uo_customer_code within w_com_customer_master
integer x = 754
integer y = 144
integer width = 581
integer taborder = 20
boolean bringtotop = true
end type

type rb_list from so_radiobutton within w_com_customer_master
integer x = 46
integer y = 72
integer width = 617
boolean bringtotop = true
string text = "Customer List"
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

type rb_document from so_radiobutton within w_com_customer_master
integer x = 46
integer y = 172
integer width = 617
boolean bringtotop = true
string text = "Customer Document"
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
DW_3.RETRIEVE( DW_1.GETITEMSTRING( DW_1.GETROW(), 'CUSTOMER_CODE' ) , GVI_ORGANIZATION_ID )
DW_1.SETFOCUS()	
end event

type st_4 from so_statictext within w_com_customer_master
integer x = 1925
integer y = 76
integer width = 485
integer height = 60
boolean bringtotop = true
long textcolor = 16711680
boolean enabled = false
string text = "Customer Name"
end type

type sle_1 from so_singlelineedit within w_com_customer_master
integer x = 1925
integer y = 144
integer width = 485
integer height = 84
integer taborder = 70
boolean bringtotop = true
textcase textcase = upper!
end type

event ue_editchange;call super::ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

LVS_COLUMN = "CUSTOMER_NAME"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	DW_1.SETFILTER('')
	DW_1.FILTER()
	RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_1.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_1.FILTER()
F_MSG_MDI_HELP( STRING( DW_1.ROWCOUNT() ) + " Found")
end event

type tab_1 from tab within w_com_customer_master
event create ( )
event destroy ( )
integer x = 2432
integer width = 1979
integer height = 288
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
integer x = 18
integer y = 112
integer width = 1943
integer height = 160
long backcolor = 12632256
string text = "Trnasfer"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Synchronizer!"
long picturemaskcolor = 536870912
ddlb_to_org ddlb_to_org
st_9 st_9
st_8 st_8
ddlb_from_org ddlb_from_org
cb_3 cb_3
end type

on tabpage_1.create
this.ddlb_to_org=create ddlb_to_org
this.st_9=create st_9
this.st_8=create st_8
this.ddlb_from_org=create ddlb_from_org
this.cb_3=create cb_3
this.Control[]={this.ddlb_to_org,&
this.st_9,&
this.st_8,&
this.ddlb_from_org,&
this.cb_3}
end on

on tabpage_1.destroy
destroy(this.ddlb_to_org)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.ddlb_from_org)
destroy(this.cb_3)
end on

type ddlb_to_org from uo_orz_id within tabpage_1
integer x = 1221
integer y = 76
integer width = 722
integer taborder = 60
boolean bringtotop = true
end type

type st_9 from so_statictext within tabpage_1
integer x = 1225
integer y = 16
integer width = 722
integer height = 68
boolean bringtotop = true
string text = "To"
end type

type st_8 from so_statictext within tabpage_1
integer x = 494
integer y = 12
integer width = 722
integer height = 68
boolean bringtotop = true
string text = "From"
end type

type ddlb_from_org from uo_orz_id within tabpage_1
integer x = 489
integer y = 76
integer width = 722
integer taborder = 50
boolean bringtotop = true
end type

type cb_3 from so_commandbutton within tabpage_1
integer y = 44
integer width = 480
integer height = 112
integer taborder = 80
boolean bringtotop = true
integer weight = 400
string text = "Sync Customer"
end type

event clicked;call super::clicked;INT LVI_FROM_ORG , LVI_TO_ORG

LVI_FROM_ORG = INTEGER( DDLB_FROM_ORG.GETCODE( ) )
LVI_TO_ORG = INTEGER( DDLB_TO_ORG.GETCODE( ) )

msg = f_msgbox1( 1161 , this.text)
if msg = 1 then
else
	return
end if

  INSERT INTO "ICOM_CUSTOMER"  
         ( "CUSTOMER_CODE",   
           "ORGANIZATION_ID",   
           "CUSTOMER_NAME",   
           "CUSTOMER_NAME_ENG",   
           "BUSINESS_NO",   
           "BUSINESS_TAX_NO",   
           "BUSINESS_CATEGORY",   
           "BUSINESS_STATUS",   
           "BUSINESS_TYPE",   
           "PAYMENT_TYPE",   
           "CREDIT_GRADE",   
           "BANK_ACCOUNT",   
           "BANK_ADDRESS",   
           "CUSTOMER_CHARGE_NAME",   
           "OWNER_NAME",   
           "BANK_ADDRESS_ENG",   
           "ADDRESS",   
           "BANK_NAME",   
           "TEL_NO",   
           "BANK_NAME_ENG",   
           "PAYMENT_CYCLE",   
           "FAX_NO",   
           "ENTER_DATE",   
           "EMPLOYEE_QTY",   
           "ENTER_BY",   
           "LAST_MODIFY_DATE",   
           "LAST_MODIFY_BY",   
           "DATESET",   
           "DATEEND",   
           "HANDPHONE_NO",   
           "HOME_PAGE",   
           "EMAIL_ADDRESS",   
           "FOUND_DATE",   
           "CREDIT_AMOUNT",   
           "TRADE_TYPE",   
           "TRADE_CODE",   
           "NATION_CODE",   
           "PAYMENT_CONDITION" )  
     SELECT "ICOM_CUSTOMER"."CUSTOMER_CODE",   
             :LVI_TO_ORG ,
            "ICOM_CUSTOMER"."CUSTOMER_NAME",   
            "ICOM_CUSTOMER"."CUSTOMER_NAME_ENG",   
            "ICOM_CUSTOMER"."BUSINESS_NO",   
            "ICOM_CUSTOMER"."BUSINESS_TAX_NO",   
            "ICOM_CUSTOMER"."BUSINESS_CATEGORY",   
            "ICOM_CUSTOMER"."BUSINESS_STATUS",   
            "ICOM_CUSTOMER"."BUSINESS_TYPE",   
            "ICOM_CUSTOMER"."PAYMENT_TYPE",   
            "ICOM_CUSTOMER"."CREDIT_GRADE",   
            "ICOM_CUSTOMER"."BANK_ACCOUNT",   
            "ICOM_CUSTOMER"."BANK_ADDRESS",   
            "ICOM_CUSTOMER"."CUSTOMER_CHARGE_NAME",   
            "ICOM_CUSTOMER"."OWNER_NAME",   
            "ICOM_CUSTOMER"."BANK_ADDRESS_ENG",   
            "ICOM_CUSTOMER"."ADDRESS",   
            "ICOM_CUSTOMER"."BANK_NAME",   
            "ICOM_CUSTOMER"."TEL_NO",   
            "ICOM_CUSTOMER"."BANK_NAME_ENG",   
            "ICOM_CUSTOMER"."PAYMENT_CYCLE",   
            "ICOM_CUSTOMER"."FAX_NO",   
            "ICOM_CUSTOMER"."ENTER_DATE",   
            "ICOM_CUSTOMER"."EMPLOYEE_QTY",   
            "ICOM_CUSTOMER"."ENTER_BY",   
            "ICOM_CUSTOMER"."LAST_MODIFY_DATE",   
            "ICOM_CUSTOMER"."LAST_MODIFY_BY",   
            "ICOM_CUSTOMER"."DATESET",   
            "ICOM_CUSTOMER"."DATEEND",   
            "ICOM_CUSTOMER"."HANDPHONE_NO",   
            "ICOM_CUSTOMER"."HOME_PAGE",   
            "ICOM_CUSTOMER"."EMAIL_ADDRESS",   
            "ICOM_CUSTOMER"."FOUND_DATE",   
            "ICOM_CUSTOMER"."CREDIT_AMOUNT",   
            "ICOM_CUSTOMER"."TRADE_TYPE",   
            "ICOM_CUSTOMER"."TRADE_CODE",   
            "ICOM_CUSTOMER"."NATION_CODE",   
            "ICOM_CUSTOMER"."PAYMENT_CONDITION"  
       FROM "ICOM_CUSTOMER" 
   WHERE ORGANIZATION_ID  = 		 :LVI_FROM_ORG
	  AND CUSTOMER_CODE NOT IN ( SELECT CUSTOMER_CODE FROM ICOM_CUSTOMER WHERE ORGANIZATION_ID  =  :LVI_TO_ORG ) ;
	  
IF F_SQL_CHECK() < 0 THEN 
	RETURN
ELSE
	
	MSG = F_MSGBOX1( 9014  , String(sqlca.sqlnrows) )
	IF MSG = 1 THEN 
		COMMIT ;
	ELSE
		ROLLBACK;
	END IF
END IF 
		 
		 


end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 1943
integer height = 160
long backcolor = 12632256
string text = "Document"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
string picturename = "Report5!"
long picturemaskcolor = 536870912
cb_insert cb_insert
cb_delete cb_delete
cb_update cb_update
cb_attach cb_attach
cb_open cb_open
end type

on tabpage_2.create
this.cb_insert=create cb_insert
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.cb_attach=create cb_attach
this.cb_open=create cb_open
this.Control[]={this.cb_insert,&
this.cb_delete,&
this.cb_update,&
this.cb_attach,&
this.cb_open}
end on

on tabpage_2.destroy
destroy(this.cb_insert)
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.cb_attach)
destroy(this.cb_open)
end on

type cb_insert from so_commandbutton within tabpage_2
integer x = 46
integer y = 24
integer width = 311
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer weight = 400
boolean enabled = false
string text = "Insert"
end type

event clicked;call super::clicked;LONG ROW 
IF DW_1.GETROW() <  1 THEN 
	RETURN
END IF

ROW = DW_3.INSERTROW( 0 )
DW_3.OBJECT.CUSTOMER_CODE[ROW] = DW_1.OBJECT.CUSTOMER_CODE[DW_1.GETROW()]
DW_3.OBJECT.SEQUENCE[ROW] = F_GET_SEQUENCE('SEQ_CUSTOMER_DOCUMENT') 
DW_3.OBJECT.REG_DATE[ROW] = F_T_SYSDATE()
F_SET_SECURITY_ROW( DW_3 , ROW , 'ALL')

end event

type cb_delete from so_commandbutton within tabpage_2
integer x = 352
integer y = 24
integer width = 311
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer weight = 400
boolean enabled = false
string text = "Delete"
end type

event clicked;call super::clicked;if dw_3.getrow() < 1 then 
	return
end if

dw_3.deleterow( dw_3.getrow())
end event

type cb_update from so_commandbutton within tabpage_2
integer x = 658
integer y = 24
integer width = 311
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer weight = 400
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

type cb_attach from so_commandbutton within tabpage_2
integer x = 969
integer y = 24
integer width = 311
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer weight = 400
boolean enabled = false
string text = "Attach"
end type

event clicked;call super::clicked;IF F_OBJECT_ROLE_CHECK() = FALSE THEN  RETURN
		int    li_FileNum , loops, i , lvi_count
		long   flen, bytes_read , bytes_read_sum , new_pos
		blob   LIB_FILE , b
		string is_filename, is_fullname , LVS_CUSTOMER_CODE , LVS_ITEM_CODE
		double LVDB_SEQUENCE
		
		IF  DW_3.GETROW() < 1 THEN 
			 RETURN
		END IF
		
		LVS_CUSTOMER_CODE = DW_3.GETITEMSTRING( DW_3.GETROW() , "CUSTOMER_CODE" )
		LVDB_SEQUENCE          = DW_3.GETITEMnumber( DW_3.GETROW() , "SEQUENCE" )		

		IF LVS_CUSTOMER_CODE ='' OR ISNULL(LVS_CUSTOMER_CODE) THEN 
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
					  from ICOM_CUSTOMER_DOCUMENT
					 WHERE CUSTOMER_CODE   = :LVS_CUSTOMER_CODE 
					   AND SEQUENCE                 = :LVDB_SEQUENCE
					   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
						  
					IF F_SQL_CHECK() < 0 THEN 
						changedirectory(Gvs_default_directory)		
						RETURN
					END IF				  
					
					if lvi_count = 0 then 
						changedirectory(Gvs_default_directory)		
						F_MSGBOX1( 9021 , LVS_CUSTOMER_CODE+'  '+string(LVDB_SEQUENCE) ) 
						//("Error", is_filename+" File Name Not Found !" )
						return
					end if
										  
					UPDATEBLOB ICOM_CUSTOMER_DOCUMENT SET DOCUMENT_DATA = :LIB_FILE 
					WHERE CUSTOMER_CODE   = :LVS_CUSTOMER_CODE 
					   AND SEQUENCE = :LVDB_SEQUENCE
					   AND ORGANIZATION_ID = :GVI_ORGANIZATION_ID ;
						
					  IF F_SQL_CHECK() < 0 THEN 
						changedirectory(Gvs_default_directory)		
						  RETURN
					  END IF						
						
					UPDATE ICOM_CUSTOMER_DOCUMENT SET DOCUMENT_NAME = :is_filename 
					WHERE CUSTOMER_CODE   = :LVS_CUSTOMER_CODE 
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
					DW_3.RETRIEVE( DW_1.GETITEMSTRING( DW_1.GETROW(), 'CUSTOMER_CODE' ) , GVI_ORGANIZATION_ID )
					DW_1.SETFOCUS()							
				  ELSE
					  f_msgbox1( 157 , is_filename )   //("Error" , is_filename+"File Upload To Database Failed" )
					  
				  END IF;
		END IF
changedirectory(Gvs_default_directory)				
end event

type cb_open from so_commandbutton within tabpage_2
integer x = 1280
integer y = 24
integer width = 311
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer weight = 400
boolean enabled = false
string text = "Open"
end type

event clicked;call super::clicked;if dw_3.getrow() < 1 then 
	return
end if

Long Lvl_return
String  lvs_file_name
if dw_3.getrow() < 1 then return 

Lvl_return =  f_download_customer_document ( String(dw_3.object.customer_code[dw_3.getrow()]) , Double(dw_3.object.sequence[dw_3.getrow()] ) )

if  Lvl_return > 0 then 

	lvs_file_name = getcurrentdirectory()+"\Temp\"+dw_3.object.document_name[dw_3.getrow()] 
	
	IF lvs_file_name = '' OR ISNULL(lvs_file_name) THEN 
		RETURN
	END IF
	
	f_shell_execute_by_extention ( dw_3.object.document_name[dw_3.getrow()]  , '' , getcurrentdirectory()+'\Temp'  )
	
else
	
end if

end event

type gb_1 from groupbox within w_com_customer_master
integer x = 699
integer width = 1728
integer height = 288
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

type gb_3 from groupbox within w_com_customer_master
integer width = 695
integer height = 288
integer taborder = 50
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


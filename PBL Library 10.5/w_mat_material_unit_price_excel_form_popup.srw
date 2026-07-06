HA$PBExportHeader$w_mat_material_unit_price_excel_form_popup.srw
$PBExportComments$$$HEX8$$90c7acc785c7e0acd1c540c191c5ddc2$$ENDHEX$$
forward
global type w_mat_material_unit_price_excel_form_popup from w_popup_root
end type
type cb_delete from so_commandbutton within w_mat_material_unit_price_excel_form_popup
end type
type cb_update from so_commandbutton within w_mat_material_unit_price_excel_form_popup
end type
type cb_insert from so_commandbutton within w_mat_material_unit_price_excel_form_popup
end type
type cb_2 from so_commandbutton within w_mat_material_unit_price_excel_form_popup
end type
type pb_1 from so_commandbutton within w_mat_material_unit_price_excel_form_popup
end type
type gb_3 from so_groupbox within w_mat_material_unit_price_excel_form_popup
end type
end forward

global type w_mat_material_unit_price_excel_form_popup from w_popup_root
integer width = 4128
integer height = 1956
string title = "Plan Master Insert Form Popup"
cb_delete cb_delete
cb_update cb_update
cb_insert cb_insert
cb_2 cb_2
pb_1 pb_1
gb_3 gb_3
end type
global w_mat_material_unit_price_excel_form_popup w_mat_material_unit_price_excel_form_popup

type variables
datawindow idw_datawindow
end variables

on w_mat_material_unit_price_excel_form_popup.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.cb_insert=create cb_insert
this.cb_2=create cb_2
this.pb_1=create pb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.cb_update
this.Control[iCurrent+3]=this.cb_insert
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.gb_3
end on

on w_mat_material_unit_price_excel_form_popup.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.cb_insert)
destroy(this.cb_2)
destroy(this.pb_1)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)

end event

event key;call super::key;if key = keyf2! then 
   cb_insert.triggerevent(clicked!)
elseif key = keyf3! then 
   cb_delete.triggerevent(clicked!)   
	
elseif key = keyf6! then 
   cb_update.triggerevent(clicked!)
   
end if
end event

event activate;call super::activate;ivs_resize_type = 'DEFAULT'
end event

event ue_post_open;call super::ue_post_open;dw_2.SETTRANSOBJECT(SQLCA)


end event

type p_title from w_popup_root`p_title within w_mat_material_unit_price_excel_form_popup
integer width = 4110
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
end type

type cb_sort from w_popup_root`cb_sort within w_mat_material_unit_price_excel_form_popup
integer x = 1024
integer y = 0
integer taborder = 40
end type

type cb_close from w_popup_root`cb_close within w_mat_material_unit_price_excel_form_popup
boolean visible = true
integer x = 3739
integer y = 248
integer width = 352
integer height = 128
integer taborder = 0
end type

event cb_close::clicked;close(parent)
end event

type st_msg from w_popup_root`st_msg within w_mat_material_unit_price_excel_form_popup
boolean visible = true
integer y = 420
integer width = 4110
integer weight = 400
end type

type dw_1 from w_popup_root`dw_1 within w_mat_material_unit_price_excel_form_popup
boolean visible = true
integer y = 516
integer width = 2217
integer height = 1324
integer taborder = 20
boolean titlebar = true
string title = "Item Receipt List"
string dataobject = "d_mat_buy_price_mst"
boolean controlmenu = true
end type

event dw_1::rbuttondown;call super::rbuttondown;decimal lvf_dc_rate , lvf_dc_sale_price

if dwo.name = 'item_code' then 
	
   //  openwithparm( w_sal_sale_price_popup , string(this.object.item_code[row]))
	  
	if gst_return.gvb_return = true then 
		
		this.object.item_code[row] = message.stringparm
		trigger event itemchanged( row , dwo, string( this.object.item_code[row] ) )		
		
	 //======================================================
	 // $$HEX8$$e0ac1dacc4bc200060d578c728c72000$$ENDHEX$$/ $$HEX17$$18c2fcc8c4bc200060d578c728c744c72000e4b2dcc2200001c8a9c65cd5e4b22000$$ENDHEX$$
	 //======================================================
	 lvf_dc_rate = f_get_order_dc_rate( this.object.customer_code[row] , this.object.customer_order_no_origin[row]	, this.object.customer_order_no[row]	)
	 //======================================================
	 lvf_dc_sale_price = Gst_return.gvf_return[1] * lvf_dc_rate			
	 
		this.object.product_sale_price_origin[row] =  Gst_return.gvf_return[1] 
		this.object.product_sale_price[row] = lvf_dc_sale_price
		this.object.sale_currency[row] = Gst_return.gvs_return[1]
		this.object.customer_code[row] = Gst_return.gvs_return[2]
		trigger event itemchanged( row , dwo, string( this.object.customer_code[row] ) )		
		this.object.product_line_type[row] = Gst_return.gvs_return[3]		
		   
		Gst_return.gvf_return[1] = 0
		Gst_return.gvs_return[1] = ''
		Gst_return.gvs_return[2] = ''
		Gst_return.gvs_return[3] = ''		

	else
	end if
	  
elseif dwo.name = 'customer_code' then 

//	openwithparm(w_sal_sale_price_popup , string(this.object.item_code[row] ))
	if gst_return.gvb_return = true then 
		
		this.object.customer_code[row] = gst_return.gvs_return[2]
		
		trigger event itemchanged( row , dwo, string( this.object.customer_code[row] ) )
	end if 
	
end if

if dwo.name = 'mfs' THEN 
	
//	openwithparm(w_sal_product_inventory_popup , string(this.object.item_code[row]))
	
	if gst_return.gvb_return = true then
		
		this.object.mfs[this.getrow()]           = message.stringparm
		this.object.item_code[this.getrow()] = gst_return.gvs_return[1]
		gst_return.gvs_return[1] = ''

	end if 
	
end if 
end event

event dw_1::itemchanged;call super::itemchanged;DECIMAL LVF_UNIT_PRICE , LVF_MATERIAL_COST
string lvs_item_code , lvs_line_type


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
			
				//MESS AGEBOX("Notify" , "Free Subcontract Can`t Receipt. Use Free Subcontract Receipt Window")
				f_msg("Free Subcontract Can`t Receipt. Use Free Subcontract Receipt Window",'P')
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
    
END IF


end event

type dw_2 from w_popup_root`dw_2 within w_mat_material_unit_price_excel_form_popup
boolean visible = true
integer x = 2226
integer y = 516
integer width = 1874
integer height = 1324
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mat_material_unit_price_excel_popup"
boolean controlmenu = true
end type

event dw_2::constructor;//override
end event

type dw_3 from w_popup_root`dw_3 within w_mat_material_unit_price_excel_form_popup
integer y = 856
integer taborder = 50
end type

type cb_delete from so_commandbutton within w_mat_material_unit_price_excel_form_popup
integer x = 741
integer y = 256
integer width = 352
boolean bringtotop = true
string text = "Delete [F3]"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 
dw_1.deleterow( dw_1.getrow())
end event

type cb_update from so_commandbutton within w_mat_material_unit_price_excel_form_popup
integer x = 1097
integer y = 256
integer width = 352
integer taborder = 30
boolean bringtotop = true
string text = "Update [F6]"
boolean default = true
end type

event clicked;if dw_1.update( ) < 0 then 
	rollback ;
else
	commit ;
	f_msgbox(170)
end if 
end event

type cb_insert from so_commandbutton within w_mat_material_unit_price_excel_form_popup
integer x = 384
integer y = 256
integer width = 352
integer taborder = 10
boolean bringtotop = true
string text = "Insert [F2]"
end type

event clicked;call super::clicked;Decimal lvf_unit_price
long n = 1  , i = 1 

if dw_2.rowcount() < 1 then return 

msg = f_msgbox1(1161,this.text)
if msg = 1 then 
else 
	return 
end if 

for i = 1 to dw_2.rowcount()
	
	n = dw_1.insertrow(0)
	dw_1.scrolltorow(n)
	f_set_security_row(dw_1, n, 'ALL')
	
	if dw_2.object.supplier_code[i] = '*' then
		f_msgbox1(111 ,  f_get_dual_lang_text( Gvs_language , "SUPPLIER CODE"))
	end if 
	
	DW_1.OBJECT.SUPPLIER_CODE[n] = DW_2.OBject.SUPPLIER_CODE[i]
	DW_1.OBJECT.ITEM_CODE[n] = DW_2.OBject.ITEM_CODE[i]
	DW_1.OBJECT.LINE_TYPE[n] = DW_2.OBject.LINE_TYPE[i]
	DW_1.OBJECT.CURRENCY[n] = DW_2.OBject.CURRENCY[i]	
	DW_1.OBJECT.DELIVERY[n] = DW_2.OBject.DELIVERY[i]		
	DW_1.OBJECT.UNIT_PRICE[n] = DW_2.OBject.UNIT_PRICE[i]			
	
	DW_1.OBJECT.dateset[n] = DW_2.OBject.dateset[i]			
	DW_1.OBJECT.dateend[n] = DW_2.OBject.dateend[i]				
	
	dw_1.object.price_type[n] = 'F'
	dw_1.object.price_change_reason[n] = 'N'						
//	dw_1.object.currency[n] = Gvs_currency
	
	IF Gvs_item_buy_price_auto_confirm = 'Y' then
		dw_1.object.price_change_confirm_yn[n] = 'Y'									
		dw_1.object.confirm_by[n] = Gvs_user_id
		dw_1.object.confirm_date[n] = f_t_sysdate()			
	else
		dw_1.object.price_change_confirm_yn[n] = 'N'													
	end if
	
	st_msg.text = string(n)+" / "+string(dw_2.rowcount())
	
next

//=================================================
//
//=================================================

//msg = f_msgbox(1170)
MSG = 1 
if msg = 1 then 
   if dw_1.update( ) < 0 then 
	  rollback;
   else
	   commit ;
	   f_msgbox(170)
		DW_1.RESET()
		DW_2.RESET()		
	end if
else
	return
end if 
end event

type cb_2 from so_commandbutton within w_mat_material_unit_price_excel_form_popup
integer x = 27
integer y = 256
integer width = 352
integer taborder = 50
boolean bringtotop = true
string text = "Excel Paste"
end type

event clicked;call super::clicked;string lvs_supplier_code , lvs_item_code
long i , lvi_count

//msg= f_msgbox1(1161 , this.text)
//if msg = 1 then 
//else
//	return
//end if
dw_2.reset()
dw_2.importclipboard( )
//=========================================
//
//=========================================

if dw_2.rowcount( ) < 1 then return 

open(w_progress_popup)
w_progress_popup.f_set_range( 1,  dw_2.rowcount( ) )
w_progress_popup.f_setstep(1)
										
do
	i++
	
	lvs_supplier_code  = dw_2.object.supplier_code[i]
	lvs_item_code = dw_2.object.item_code[i]
	
	select count(*) into :lvi_count from icom_supplier 
	where supplier_code = :lvs_supplier_code
	     and organization_id = :gvi_organization_id ;
		  
		  if f_sql_check() < 0 then 
			close(w_progress_popup)
			return
		  end if 
		  
	if lvi_count < 1 then 
		close(w_progress_popup)
		f_msgbox1(815 , string(i)+"  "+lvs_supplier_code )
		return 
	end if 
	
	
	lvi_count = 0
	select count(*) into :lvi_count from id_item
	where item_code = :lvs_item_code
	     and organization_id = :gvi_organization_id ;
		  
		  if f_sql_check() < 0 then 
			close(w_progress_popup)
			return
		  end if 
		  
	if lvi_count < 1 then 
		close(w_progress_popup)
		f_msgbox1(815 , string(i)+"  "+lvs_item_code )
		
		return 
	end if 		
	w_progress_popup.f_stepit()
	
loop until i = dw_2.rowcount( )

close(w_progress_popup)


end event

type pb_1 from so_commandbutton within w_mat_material_unit_price_excel_form_popup
integer x = 3383
integer y = 248
integer width = 352
integer taborder = 40
boolean bringtotop = true
string text = "Save Form"
end type

event clicked;call super::clicked;string     docname, named 
Long iret

SETPOINTER(HOURGLASS!)		
iret = GetFileSaveName("Select Excel File ("+dw_2.classname()+")" , docname, named, "xls", "Excel Files (*.xls),*.xls")		

IF iret =1 THEN 
	
	     dw_2.insertrow( 0)
		uf_save_dw_as_excel( dw_2  , docname )
ELSE
	RETURN
END IF
		

end event

type gb_3 from so_groupbox within w_mat_material_unit_price_excel_form_popup
integer y = 176
integer width = 4110
integer height = 240
long textcolor = 16711680
string text = "Process"
end type


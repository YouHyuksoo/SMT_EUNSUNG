HA$PBExportHeader$w_des_item_excel_form_popup.srw
$PBExportComments$$$HEX4$$d1c540c191c5ddc2$$ENDHEX$$
forward
global type w_des_item_excel_form_popup from w_popup_root
end type
type cb_delete from so_commandbutton within w_des_item_excel_form_popup
end type
type cb_update from so_commandbutton within w_des_item_excel_form_popup
end type
type cb_insert from so_commandbutton within w_des_item_excel_form_popup
end type
type cb_2 from so_commandbutton within w_des_item_excel_form_popup
end type
type pb_1 from so_commandbutton within w_des_item_excel_form_popup
end type
type gb_3 from so_groupbox within w_des_item_excel_form_popup
end type
end forward

global type w_des_item_excel_form_popup from w_popup_root
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
global w_des_item_excel_form_popup w_des_item_excel_form_popup

type variables
datawindow idw_datawindow
end variables

on w_des_item_excel_form_popup.create
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

on w_des_item_excel_form_popup.destroy
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

type p_title from w_popup_root`p_title within w_des_item_excel_form_popup
integer width = 4110
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
end type

type cb_sort from w_popup_root`cb_sort within w_des_item_excel_form_popup
integer x = 1024
integer y = 0
integer taborder = 40
end type

type cb_close from w_popup_root`cb_close within w_des_item_excel_form_popup
boolean visible = true
integer x = 3739
integer y = 248
integer width = 352
integer height = 128
integer taborder = 0
end type

event cb_close::clicked;close(parent)
end event

type st_msg from w_popup_root`st_msg within w_des_item_excel_form_popup
boolean visible = true
integer y = 420
integer width = 4110
integer weight = 400
end type

type dw_1 from w_popup_root`dw_1 within w_des_item_excel_form_popup
boolean visible = true
integer y = 516
integer width = 4105
integer height = 1324
integer taborder = 20
boolean titlebar = true
string title = "Item Receipt List"
string dataobject = "d_des_item_import_excel"
boolean controlmenu = true
end type

event dw_1::rbuttondown;call super::rbuttondown;


end event

event dw_1::itemchanged;call super::itemchanged;


end event

type dw_2 from w_popup_root`dw_2 within w_des_item_excel_form_popup
boolean visible = true
integer y = 516
integer width = 1874
integer height = 1324
integer taborder = 0
boolean titlebar = true
boolean controlmenu = true
end type

event dw_2::constructor;//override
end event

type dw_3 from w_popup_root`dw_3 within w_des_item_excel_form_popup
integer y = 856
integer taborder = 50
end type

type cb_delete from so_commandbutton within w_des_item_excel_form_popup
integer x = 741
integer y = 260
integer width = 352
boolean bringtotop = true
string text = "Delete [F3]"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 
dw_1.deleterow( dw_1.getrow())
end event

type cb_update from so_commandbutton within w_des_item_excel_form_popup
integer x = 1097
integer y = 260
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
end if 
end event

type cb_insert from so_commandbutton within w_des_item_excel_form_popup
integer x = 384
integer y = 256
integer width = 352
integer taborder = 10
boolean bringtotop = true
string text = "Insert [F2]"
end type

event clicked;call super::clicked;dw_1.insertrow(0)
//Decimal lvf_unit_price
//long n = 1  , i = 1 
//
//if dw_2.rowcount() < 1 then return 
//
//msg = f_msgbox1(1161,this.text)
//if msg = 1 then 
//else 
//	return 
//end if 
//
//for i = 1 to dw_2.rowcount()
//	
//	n = dw_1.insertrow(0)
//	dw_1.scrolltorow(n)
//	f_set_security_row(dw_1, n, 'ALL')
//	
//	if dw_2.object.supplier_code[i] = '*' then
//		f_msgbox1(111 ,  f_get_dual_lang_text( Gvs_language , "SUPPLIER CODE"))
//	end if 
//	
//	DW_1.OBJECT.SUPPLIER_CODE[n] = DW_2.OBject.SUPPLIER_CODE[i]
//	DW_1.OBJECT.ITEM_CODE[n] = DW_2.OBject.ITEM_CODE[i]
//	DW_1.OBJECT.LINE_TYPE[n] = DW_2.OBject.LINE_TYPE[i]
//	DW_1.OBJECT.CURRENCY[n] = DW_2.OBject.CURRENCY[i]	
//	DW_1.OBJECT.DELIVERY[n] = DW_2.OBject.DELIVERY[i]		
//	DW_1.OBJECT.UNIT_PRICE[n] = DW_2.OBject.UNIT_PRICE[i]			
//	
//	DW_1.OBJECT.dateset[n] = DW_2.OBject.dateset[i]			
//	DW_1.OBJECT.dateend[n] = DW_2.OBject.dateend[i]				
//	
//	dw_1.object.price_type[n] = 'F'
//	dw_1.object.price_change_reason[n] = 'N'						
//	dw_1.object.currency[n] = Gvs_currency
//	
//	IF Gvs_item_buy_price_auto_confirm = 'Y' then
//		dw_1.object.price_change_confirm_yn[n] = 'Y'									
//		dw_1.object.confirm_by[n] = Gvs_user_id
//		dw_1.object.confirm_date[n] = f_t_sysdate()			
//	else
//		dw_1.object.price_change_confirm_yn[n] = 'N'													
//	end if
//	
//next
//
////=================================================
////
////=================================================
//
////msg = f_msgbox(1170)
//MSG = 1 
//if msg = 1 then 
//   if dw_1.update( ) < 0 then 
//	  rollback;
//   else
//	   commit ;
//	end if
//else
//	return
//end if 
end event

type cb_2 from so_commandbutton within w_des_item_excel_form_popup
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
dw_1.reset()
dw_1.importclipboard( )
//=========================================
//
//=========================================

if dw_1.rowcount( ) < 1 then return 

open(w_progress_popup)
w_progress_popup.f_set_range( 1,  dw_1.rowcount( ) )
w_progress_popup.f_setstep(1)
										
do
	i++
	
	lvs_supplier_code  = dw_1.object.supplier_code[i]
	lvs_item_code = dw_1.object.item_code[i]
	
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
		  
	if lvi_count > 0 then 
		close(w_progress_popup)
		f_msgbox1(815 , string(i)+"  "+lvs_item_code )
		
		return 
	end if 		
	w_progress_popup.f_stepit()
	
loop until i = dw_1.rowcount( )

close(w_progress_popup)


end event

type pb_1 from so_commandbutton within w_des_item_excel_form_popup
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
iret = GetFileSaveName("Select Excel File ("+dw_1.classname()+")" , docname, named, "xls", "Excel Files (*.xls),*.xls")		

IF iret =1 THEN 
	
	     dw_1.insertrow( 0)
		uf_save_dw_as_excel( dw_1  , docname )
ELSE
	RETURN
END IF
		

end event

type gb_3 from so_groupbox within w_des_item_excel_form_popup
integer y = 176
integer width = 4110
integer height = 240
long textcolor = 16711680
string text = "Process"
end type


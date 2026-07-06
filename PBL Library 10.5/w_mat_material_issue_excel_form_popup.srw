HA$PBExportHeader$w_mat_material_issue_excel_form_popup.srw
$PBExportComments$$$HEX8$$01c6c5c585c7e0acd1c540c191c5ddc2$$ENDHEX$$
forward
global type w_mat_material_issue_excel_form_popup from w_popup_root
end type
type cb_delete from so_commandbutton within w_mat_material_issue_excel_form_popup
end type
type cb_update from so_commandbutton within w_mat_material_issue_excel_form_popup
end type
type cb_insert from so_commandbutton within w_mat_material_issue_excel_form_popup
end type
type cb_2 from so_commandbutton within w_mat_material_issue_excel_form_popup
end type
type cbx_issue_type from checkbox within w_mat_material_issue_excel_form_popup
end type
type pb_1 from so_commandbutton within w_mat_material_issue_excel_form_popup
end type
type rb_cancel from radiobutton within w_mat_material_issue_excel_form_popup
end type
type rb_issue from radiobutton within w_mat_material_issue_excel_form_popup
end type
type gb_3 from so_groupbox within w_mat_material_issue_excel_form_popup
end type
end forward

global type w_mat_material_issue_excel_form_popup from w_popup_root
integer width = 4128
integer height = 1956
string title = "Plan Master Insert Form Popup"
cb_delete cb_delete
cb_update cb_update
cb_insert cb_insert
cb_2 cb_2
cbx_issue_type cbx_issue_type
pb_1 pb_1
rb_cancel rb_cancel
rb_issue rb_issue
gb_3 gb_3
end type
global w_mat_material_issue_excel_form_popup w_mat_material_issue_excel_form_popup

type variables
datawindow idw_datawindow
end variables

on w_mat_material_issue_excel_form_popup.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.cb_insert=create cb_insert
this.cb_2=create cb_2
this.cbx_issue_type=create cbx_issue_type
this.pb_1=create pb_1
this.rb_cancel=create rb_cancel
this.rb_issue=create rb_issue
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.cb_update
this.Control[iCurrent+3]=this.cb_insert
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.cbx_issue_type
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.rb_cancel
this.Control[iCurrent+8]=this.rb_issue
this.Control[iCurrent+9]=this.gb_3
end on

on w_mat_material_issue_excel_form_popup.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.cb_insert)
destroy(this.cb_2)
destroy(this.cbx_issue_type)
destroy(this.pb_1)
destroy(this.rb_cancel)
destroy(this.rb_issue)
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

type p_title from w_popup_root`p_title within w_mat_material_issue_excel_form_popup
integer width = 4110
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
end type

type cb_sort from w_popup_root`cb_sort within w_mat_material_issue_excel_form_popup
integer x = 1024
integer y = 0
integer taborder = 40
end type

type cb_close from w_popup_root`cb_close within w_mat_material_issue_excel_form_popup
boolean visible = true
integer x = 3739
integer y = 248
integer width = 352
integer height = 128
integer taborder = 0
end type

event cb_close::clicked;close(parent)
end event

type st_msg from w_popup_root`st_msg within w_mat_material_issue_excel_form_popup
boolean visible = true
integer y = 420
integer width = 4110
integer weight = 400
end type

type dw_1 from w_popup_root`dw_1 within w_mat_material_issue_excel_form_popup
boolean visible = true
integer y = 516
integer width = 2217
integer height = 1324
integer taborder = 20
boolean titlebar = true
string title = "Issue List"
string dataobject = "d_mat_mass_issue_lst"
boolean controlmenu = true
end type

type dw_2 from w_popup_root`dw_2 within w_mat_material_issue_excel_form_popup
boolean visible = true
integer x = 2226
integer y = 520
integer width = 1874
integer height = 1324
integer taborder = 0
string dataobject = "d_mat_material_issue_excel_popup"
boolean controlmenu = true
end type

event dw_2::constructor;//override
end event

type dw_3 from w_popup_root`dw_3 within w_mat_material_issue_excel_form_popup
integer y = 856
integer taborder = 50
end type

type cb_delete from so_commandbutton within w_mat_material_issue_excel_form_popup
integer x = 841
integer y = 256
integer width = 352
boolean bringtotop = true
string text = "Delete [F3]"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 
dw_1.deleterow( dw_1.getrow())
end event

type cb_update from so_commandbutton within w_mat_material_issue_excel_form_popup
integer x = 1198
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
end if 
end event

type cb_insert from so_commandbutton within w_mat_material_issue_excel_form_popup
integer x = 498
integer y = 256
integer width = 352
integer taborder = 10
boolean bringtotop = true
string text = "Insert [F2]"
end type

event clicked;call super::clicked;Decimal lvf_issue_qty
long n = 1  , i = 1 
double LVDB_ISSUE_INVOICE_NO
string lvs_item_code , lvs_line_type ,lvs_location_code

if dw_2.rowcount() < 1 then return 


for i = 1 to dw_2.rowcount()
	
	n = dw_1.insertrow(0)
	dw_1.scrolltorow(n)
	f_set_security_row(dw_1, n, 'ALL')
	
	dw_1.object.work_order_no[n] = '*'
	dw_1.object.issue_date[n] =  dw_2.object.issue_date[i]
	dw_1.object.issue_sequence[n] = double(f_get_sequence('seq_mat_issue'))
	
	dw_1.object.item_code[n]  = dw_2.object.item_code[i]
	dw_1.object.parent_item_code[n]  = dw_2.object.parent_item_code[i]	
	dw_1.object.item_type[n]   = 'T'
	dw_1.object.line_code[n]   = dw_2.object.line_code[i]
	dw_1.object.demand_qty[n]   = dw_2.object.demand_qty[i]
	
	dw_1.object.workstage_code[n] = '*'
	dw_1.object.machine_code[n] = '*'
	dw_1.object.supplier_code[n] = dw_2.object.supplier_code[i]	
	
	if dw_2.object.invoice_no[i] = '' then 
		LVDB_ISSUE_INVOICE_NO = F_GET_SEQUENCE('SEQ_ISSUE_INVOICE_SEQUENCE')
		dw_1.object.invoice_no[n] = string(LVDB_ISSUE_INVOICE_NO)
	else
		dw_1.object.invoice_no[n] = dw_2.object.invoice_no[i]
	end if 
	
	lvf_issue_qty = dw_2.object.issue_qty[i]
	//==============================================
	if rb_issue.checked = true then 
			dw_1.object.issue_deficit[n] = '3'	
			dw_1.object.issue_qty[n] =lvf_issue_qty			
	else
			dw_1.object.issue_deficit[n] = '4'					
			dw_1.object.issue_qty[n] =abs(lvf_issue_qty) * -1 
	end if

	dw_1.object.issue_status[n] = 'N'

		if cbx_issue_type.checked = true then
			dw_1.object.issue_type[n] = 'N' //$$HEX5$$15c8c1c09ccde0ac2000$$ENDHEX$$
		else
			dw_1.object.issue_type[n] = 'E' //$$HEX7$$30aec0d09ccde0ac200009000900$$ENDHEX$$
		end if

	dw_1.object.issue_account[n] = 'M001'
	dw_1.object.line_type[n] = dw_2.object.line_type[i]
	
	dw_1.object.mfs[n] = '*'
	if Gvs_material_mfs_replace_location_code = 'Y' then 
		dw_1.object.material_mfs[n] =	dw_2.object.location_code[i]			
	else
		dw_1.object.material_mfs[n] = '*' 
	end if 
	dw_1.object.location_code[n] = dw_2.object.location_code[i]
	
	
//	dw_1.object.issue_amt[n] = lvf_issue_qty * dw_1.object.inventory_price[i]
//	dw_1.object.issue_price[n]  = dw_1.object.inventory_price[i]	
	
	st_msg.text = string(i)+"/"+string(DW_2.ROWCOUNT( ))
next

//=================================================
//
//=================================================

//msg = f_msgbox(1170)
msg=1
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

type cb_2 from so_commandbutton within w_mat_material_issue_excel_form_popup
integer x = 27
integer y = 256
integer width = 448
integer taborder = 50
boolean bringtotop = true
string text = "Excel Paste"
end type

event clicked;call super::clicked;string lvs_line_code , lvs_item_code , lvs_supplier_code , lvs_line_type , lvs_location_code
long i , lvi_count , j , lvi_error_count
decimal lvd_issue_qty , lvd_inventory_qty

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
	
	lvs_line_code  = dw_2.object.line_code[i]
	lvs_item_code = dw_2.object.item_code[i]
	lvs_location_code = dw_2.object.location_code[i]
	lvs_line_type = dw_2.object.line_type[i]
	lvd_issue_qty = dw_2.object.issue_qty[i]

//=======================================	
	
	select count(*) into :lvi_count from ip_product_line 
	where line_code = :lvs_line_code
	     and organization_id = :gvi_organization_id ;
		  
		  if f_sql_check() < 0 then 
			close(w_progress_popup)
			return
		  end if 
		  
	if lvi_count < 1 then 
		close(w_progress_popup)
		f_msgbox1(815 , string(i)+"  "+lvs_line_code )
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
	
//========================================
//  issue inventory  check
//========================================
	
  lvi_count = 0;
  select sum(inventory_qty) into :lvd_inventory_qty
    from im_item_inventory
  where item_code = :lvs_item_code
     and location_code  = :lvs_location_code
	 and line_type = :lvs_line_type
	 and organization_id =:gvi_organization_id ;
	 
	 if f_sql_check() < 0 then
		close(w_progress_popup)
	     return
	end if
	
	if lvd_issue_qty >lvd_inventory_qty then
//		close(w_progress_popup)
		dw_2.selectrow(i , true)
		lvi_error_count++		
//		f_msgbox1(9040 , string(i)+"  "+lvs_item_code)
//		return
	end if
	
w_progress_popup.f_stepit()	
loop until i = dw_2.rowcount( )

close(w_progress_popup)
if lvi_error_count > 0 then
	f_msgbox1(9040 , string(i)+"  "+lvs_item_code)
	return
end if

end event

type cbx_issue_type from checkbox within w_mat_material_issue_excel_form_popup
integer x = 1614
integer y = 288
integer width = 489
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Normal Issue"
boolean checked = true
end type

type pb_1 from so_commandbutton within w_mat_material_issue_excel_form_popup
integer x = 3383
integer y = 248
integer width = 352
integer taborder = 40
boolean bringtotop = true
string text = "Save Form"
end type

event clicked;call super::clicked;//string     docname, named 
//Long iret
//
//SETPOINTER(HOURGLASS!)		
//iret = GetFileSaveName("Select Excel File ("+dw_2.classname()+")" , docname, named, "xls", "Excel Files (*.xls),*.xls")		
//
//IF iret =1 THEN 
//		uf_save_dw_as_excel( dw_2  , docname )
//ELSE
//	RETURN
//END IF
		
string     docname, named 
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

type rb_cancel from radiobutton within w_mat_material_issue_excel_form_popup
integer x = 2743
integer y = 288
integer width = 434
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Issue Cancel"
end type

type rb_issue from radiobutton within w_mat_material_issue_excel_form_popup
integer x = 2263
integer y = 288
integer width = 434
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Material Issue"
boolean checked = true
end type

type gb_3 from so_groupbox within w_mat_material_issue_excel_form_popup
integer y = 176
integer width = 4110
integer height = 240
long textcolor = 16711680
string text = "Process"
end type


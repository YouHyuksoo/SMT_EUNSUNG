HA$PBExportHeader$w_mat_inventory_close_excel_import_popup.srw
$PBExportComments$Popup Templet Window
forward
global type w_mat_inventory_close_excel_import_popup from w_popup_root
end type
type cb_update from so_commandbutton within w_mat_inventory_close_excel_import_popup
end type
type cb_2 from so_commandbutton within w_mat_inventory_close_excel_import_popup
end type
type em_close_yyymm from uo_ym within w_mat_inventory_close_excel_import_popup
end type
type st_1 from statictext within w_mat_inventory_close_excel_import_popup
end type
type pb_1 from so_commandbutton within w_mat_inventory_close_excel_import_popup
end type
type cbx_delete from so_checkbox within w_mat_inventory_close_excel_import_popup
end type
type gb_3 from so_groupbox within w_mat_inventory_close_excel_import_popup
end type
end forward

global type w_mat_inventory_close_excel_import_popup from w_popup_root
integer width = 3136
integer height = 1956
string title = "Plan Master Insert Form Popup"
cb_update cb_update
cb_2 cb_2
em_close_yyymm em_close_yyymm
st_1 st_1
pb_1 pb_1
cbx_delete cbx_delete
gb_3 gb_3
end type
global w_mat_inventory_close_excel_import_popup w_mat_inventory_close_excel_import_popup

type variables
datawindow idw_datawindow
end variables

on w_mat_inventory_close_excel_import_popup.create
int iCurrent
call super::create
this.cb_update=create cb_update
this.cb_2=create cb_2
this.em_close_yyymm=create em_close_yyymm
this.st_1=create st_1
this.pb_1=create pb_1
this.cbx_delete=create cbx_delete
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_update
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.em_close_yyymm
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.cbx_delete
this.Control[iCurrent+7]=this.gb_3
end on

on w_mat_inventory_close_excel_import_popup.destroy
call super::destroy
destroy(this.cb_update)
destroy(this.cb_2)
destroy(this.em_close_yyymm)
destroy(this.st_1)
destroy(this.pb_1)
destroy(this.cbx_delete)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)

end event

event activate;call super::activate;ivs_resize_type = 'DEFAULT'
end event

event ue_post_open;call super::ue_post_open;dw_2.SETTRANSOBJECT(SQLCA)


end event

type p_title from w_popup_root`p_title within w_mat_inventory_close_excel_import_popup
integer width = 3118
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
end type

type cb_sort from w_popup_root`cb_sort within w_mat_inventory_close_excel_import_popup
integer x = 1024
integer y = 0
integer taborder = 40
end type

type cb_close from w_popup_root`cb_close within w_mat_inventory_close_excel_import_popup
boolean visible = true
integer x = 2729
integer y = 248
integer width = 352
integer height = 128
integer taborder = 0
end type

event cb_close::clicked;close(parent)
end event

type st_msg from w_popup_root`st_msg within w_mat_inventory_close_excel_import_popup
boolean visible = true
integer y = 424
integer width = 3118
integer weight = 400
end type

type dw_1 from w_popup_root`dw_1 within w_mat_inventory_close_excel_import_popup
boolean visible = true
integer y = 512
integer width = 3118
integer height = 1352
integer taborder = 20
boolean titlebar = true
string title = "Master Plan"
string dataobject = "d_mat_item_inventory_close_excel_import_popup"
boolean controlmenu = true
end type

event dw_1::rbuttondown;call super::rbuttondown;if dwo.name = 'item_code' then 
	
	open(w_des_set_item_popup)
	if 	GST_RETURN.GVB_RETURN = TRUE then 
		this.object.item_code[row] = message.stringparm
		this.object.route_no[row] = Gst_return.Gvs_return[6] 
		this.object.line_code[row] = f_get_line_code_by_item( message.stringparm)
	else
	end if 
	
elseif dwo.name = 'customer_code' then 
	open(w_com_customer_popup)
	if 	GST_RETURN.GVB_RETURN = TRUE then 
		this.object.customer_code[row] = message.stringparm
	else
	end if 	
elseif dwo.name = 'mold_code' then 
	open(w_mcn_mold_popup)
	if 	GST_RETURN.GVB_RETURN = TRUE then 
		this.object.mold_code[row] = message.stringparm
		this.object.mold_version[row] = Gst_return.gvl_return[1]
		this.object.mold_set_serial[row] = Gst_return.gvl_return[2]
	else
	end if 			
end if 

end event

event dw_1::itemchanged;call super::itemchanged;if dwo.name = 'item_code' then
	
      this.accepttext( )	
	dw_1.object.line_code[row] = f_get_line_code_by_item( data)
	
end if 
end event

event dw_1::clicked;call super::clicked;if dwo.name = 'b_line' then 
	
	openwithparm( w_plan_line_workstage_popup , string(this.object.line_code[row]))
	if Gst_return.gvb_return = true then
		
		this.object.line_code[row] = message.stringparm
		this.object.workstage_code[row] = Gst_return.gvs_return[1]
		
	end if 
	
end if 
end event

type dw_2 from w_popup_root`dw_2 within w_mat_inventory_close_excel_import_popup
boolean visible = true
integer y = 512
integer width = 1874
integer height = 1324
integer taborder = 0
boolean controlmenu = true
end type

type dw_3 from w_popup_root`dw_3 within w_mat_inventory_close_excel_import_popup
integer y = 856
integer taborder = 50
end type

type cb_update from so_commandbutton within w_mat_inventory_close_excel_import_popup
integer x = 823
integer y = 256
integer width = 352
integer taborder = 30
boolean bringtotop = true
string text = "Save"
boolean default = true
end type

event clicked;if cbx_delete.checked = true then 
	
	delete from IM_ITEM_INVENTORY_CHECK_EXCEL 
			  where close_yyyymm = :em_close_yyymm.text 
				and organization_id = :gvi_organization_id ;
	if f_sql_check() < 0 then 
		return 
	end if 
	
else
	
end if 
//==============================================
//
//==============================================

msg= f_msgbox(1170)
if msg = 1 then
	open(w_progress_popup)
    w_progress_popup.f_set_range( 1,  dw_1.rowcount( ) )
    w_progress_popup.f_setstep(1)
	
   if dw_1.update( ) < 0 then 
     	rollback ;
   else
		w_progress_popup.f_stepit()
	commit ;
	f_msgbox(170)
	dw_1.reset()
   end if 
	close(w_progress_popup)
else
	return
end if


end event

type cb_2 from so_commandbutton within w_mat_inventory_close_excel_import_popup
integer x = 466
integer y = 256
integer width = 352
integer taborder = 50
boolean bringtotop = true
string text = "Excel Paste"
end type

event clicked;call super::clicked;string  lvs_close_yyyymm , lvs_item_code , lvs_line_type ,  lvs_location_code
long i , lvi_count , lvi_error_count

msg= f_msgbox1(1161 , this.text)
if msg = 1 then 
else
	return
end if
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
	lvs_close_yyyymm = dw_1.object.close_yyyymm[i]
	lvs_item_code = dw_1.object.item_code[i]
	lvs_line_type = dw_1.object.line_type[i]	
	lvs_location_code = dw_1.object.location_code[i]		

	lvi_count = 0
	select count(*) into :lvi_count from IM_ITEM_INVENTORY_CHECK
	where  close_yyyymm   = :lvs_close_yyyymm
	     and item_code         = :lvs_item_code
	     and line_type          = :lvs_line_type
		and location_code    = :lvs_location_code
	     and organization_id = :gvi_organization_id ;
		  
		  if f_sql_check() < 0 then 
			close(w_progress_popup)
			return
		  end if 
		  
	if lvi_count < 1 then 
		dw_1.object.error_yn[i] = 'Y'
		lvi_error_count ++
	end if 		
	w_progress_popup.f_stepit()
	
loop until i = dw_1.rowcount( )

close(w_progress_popup)

//if lvi_error_count > 0 then 
//
//	f_msg1(1175 , string(lvi_error_count))
//end if


end event

type em_close_yyymm from uo_ym within w_mat_inventory_close_excel_import_popup
integer x = 78
integer y = 316
integer taborder = 20
boolean bringtotop = true
end type

type st_1 from statictext within w_mat_inventory_close_excel_import_popup
integer x = 55
integer y = 248
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "Close YYYYMM"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_1 from so_commandbutton within w_mat_inventory_close_excel_import_popup
integer x = 2377
integer y = 252
integer width = 352
integer taborder = 40
boolean bringtotop = true
string text = "Save Form"
boolean default = true
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

type cbx_delete from so_checkbox within w_mat_inventory_close_excel_import_popup
integer x = 1189
integer y = 272
integer width = 535
boolean bringtotop = true
string text = "Delete And Insert"
boolean checked = true
end type

type gb_3 from so_groupbox within w_mat_inventory_close_excel_import_popup
integer y = 192
integer width = 3118
integer height = 224
long textcolor = 16711680
string text = "Process"
end type


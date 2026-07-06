HA$PBExportHeader$w_des_bom_replace_item_excel_form_popup.srw
$PBExportComments$$$HEX4$$d1c540c191c5ddc2$$ENDHEX$$
forward
global type w_des_bom_replace_item_excel_form_popup from w_popup_root
end type
type cb_delete from so_commandbutton within w_des_bom_replace_item_excel_form_popup
end type
type cb_update from so_commandbutton within w_des_bom_replace_item_excel_form_popup
end type
type cb_insert from so_commandbutton within w_des_bom_replace_item_excel_form_popup
end type
type cb_2 from so_commandbutton within w_des_bom_replace_item_excel_form_popup
end type
type pb_1 from so_commandbutton within w_des_bom_replace_item_excel_form_popup
end type
type gb_3 from so_groupbox within w_des_bom_replace_item_excel_form_popup
end type
end forward

global type w_des_bom_replace_item_excel_form_popup from w_popup_root
integer width = 4128
integer height = 2192
string title = "Plan Master Insert Form Popup"
cb_delete cb_delete
cb_update cb_update
cb_insert cb_insert
cb_2 cb_2
pb_1 pb_1
gb_3 gb_3
end type
global w_des_bom_replace_item_excel_form_popup w_des_bom_replace_item_excel_form_popup

type variables
datawindow idw_datawindow
end variables

on w_des_bom_replace_item_excel_form_popup.create
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

on w_des_bom_replace_item_excel_form_popup.destroy
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

type p_title from w_popup_root`p_title within w_des_bom_replace_item_excel_form_popup
integer width = 4110
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
end type

type cb_sort from w_popup_root`cb_sort within w_des_bom_replace_item_excel_form_popup
integer x = 1024
integer y = 0
integer taborder = 40
end type

type cb_close from w_popup_root`cb_close within w_des_bom_replace_item_excel_form_popup
boolean visible = true
integer x = 3739
integer y = 244
integer width = 352
integer height = 136
integer taborder = 0
end type

event cb_close::clicked;close(parent)
end event

type st_msg from w_popup_root`st_msg within w_des_bom_replace_item_excel_form_popup
boolean visible = true
integer y = 420
integer width = 4110
integer weight = 400
end type

type dw_1 from w_popup_root`dw_1 within w_des_bom_replace_item_excel_form_popup
boolean visible = true
integer x = 5
integer y = 516
integer width = 2007
integer height = 1544
integer taborder = 20
boolean titlebar = true
string title = "Replace Item Receipt List"
string dataobject = "d_des_bom_replace_lst"
boolean controlmenu = true
end type

type dw_2 from w_popup_root`dw_2 within w_des_bom_replace_item_excel_form_popup
boolean visible = true
integer x = 2011
integer y = 512
integer width = 2085
integer height = 1548
integer taborder = 0
boolean titlebar = true
string dataobject = "d_des_bom_replace_item_import_excel"
boolean controlmenu = true
end type

event dw_2::constructor;//override
end event

type dw_3 from w_popup_root`dw_3 within w_des_bom_replace_item_excel_form_popup
integer y = 856
integer taborder = 50
end type

type cb_delete from so_commandbutton within w_des_bom_replace_item_excel_form_popup
integer x = 741
integer y = 244
integer width = 352
integer height = 136
boolean bringtotop = true
string text = "Delete [F3]"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 
dw_1.deleterow( dw_1.getrow())
end event

type cb_update from so_commandbutton within w_des_bom_replace_item_excel_form_popup
integer x = 1097
integer y = 244
integer width = 352
integer height = 136
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

type cb_insert from so_commandbutton within w_des_bom_replace_item_excel_form_popup
integer x = 384
integer y = 244
integer width = 352
integer height = 136
integer taborder = 10
boolean bringtotop = true
string text = "Insert [F2]"
end type

event clicked;call super::clicked;long n = 1 , i ,j

if dw_2.rowcount( ) < 1 then return
//msg = f_msgbox1(1161 , this.text)\
msg = 1
if msg = 1 then
else
	return
end if

do
	i++
	
	n = dw_1.insertrow(0)
	dw_1.scrolltorow(n)
	f_set_security_row(dw_1 , n , 'ALL')
	
	dw_1.object.parent_item_code[n] = dw_2.object.parent_item_code[i]
	dw_1.object.child_item_code[n] = dw_2.object.child_item_code[i]
	dw_1.object.replace_item_code[n] = dw_2.object.replace_item_code[i]
	dw_1.object.item_unit_qty[n] = dw_2.object.item_unit_qty[i]
	dw_1.object.bom_location_code[n] = dw_2.object.bom_location_code[i]
	dw_1.object.dateset[n] = dw_2.object.dateset[i]
	dw_1.object.dateend[n] = dw_2.object.dateend[i]
	
	dw_1.object.replace_sequence[N] = 1
	dw_1.object.organization_id[n] = gvi_organization_id
	dw_1.object.item_unit_qty_ext[n] = dw_2.object.item_unit_qty[i]
	dw_1.object.workstage_code[n] = "0"
	
	j++
	st_msg.text = string(j)+"/"+string(dw_2.rowcount())
loop until i=dw_2.rowcount()

if dw_1.update() < 0 then 
	rollback;
else
	commit;
	f_msgbox(170) 
	DW_1.RESET()
	dw_2.reset()
end if


end event

type cb_2 from so_commandbutton within w_des_bom_replace_item_excel_form_popup
integer x = 27
integer y = 244
integer width = 352
integer height = 136
integer taborder = 50
boolean bringtotop = true
string text = "Excel Paste"
end type

event clicked;call super::clicked;string  lvs_parent_item_code ,  lvs_child_item_code , lvs_replace_item_code
long i , lvi_count
date lvd_dateset

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
	
	lvs_parent_item_code  = dw_2.object.parent_item_code[i]
	lvs_child_item_code = dw_2.object.child_item_code[i]
	
	select count(*) into :lvi_count from id_item 
	where  item_code = :lvs_parent_item_code
	     and organization_id = :gvi_organization_id ;
		  
		  if f_sql_check() < 0 then 
			close(w_progress_popup)
			return
		  end if 
		  
	if lvi_count < 0 then 
		close(w_progress_popup)
		f_msgbox1(815 , string(i)+"  "+lvs_parent_item_code )
		return 
	end if 
	
	lvi_count = 0
	select count(*) into :lvi_count from id_item
	where  item_code = :lvs_child_item_code
	     and organization_id = :gvi_organization_id ;
		  
		  if f_sql_check() < 0 then 
			close(w_progress_popup)
			return
		  end if 
		  
	if lvi_count < 0 then 
		close(w_progress_popup)
		f_msgbox1(815 , string(i)+"  "+lvs_child_item_code )		
		return 
	end if 		
	
	lvi_count = 0
	select count(*) into :lvi_count from id_item
	where  item_code = :lvs_replace_item_code
	   and  dateset  <= :lvd_dateset
	     and organization_id = :gvi_organization_id ;		  
		  
		  if f_sql_check() < 0 then 
			close(w_progress_popup)
			return
		  end if 
		  
	if lvi_count < 0 then 
		close(w_progress_popup)
		f_msgbox1(815 , string(i)+"  "+lvs_replace_item_code )
		
		return 
	end if 		
	w_progress_popup.f_stepit()
	
loop until i = dw_2.rowcount( )

close(w_progress_popup)



end event

type pb_1 from so_commandbutton within w_des_bom_replace_item_excel_form_popup
integer x = 1856
integer y = 244
integer width = 352
integer height = 136
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

type gb_3 from so_groupbox within w_des_bom_replace_item_excel_form_popup
integer y = 176
integer width = 4110
integer height = 240
long textcolor = 16711680
string text = "Process"
end type


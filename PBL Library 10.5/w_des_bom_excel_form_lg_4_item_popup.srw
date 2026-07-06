HA$PBExportHeader$w_des_bom_excel_form_lg_4_item_popup.srw
$PBExportComments$$$HEX4$$d1c540c191c5ddc2$$ENDHEX$$
forward
global type w_des_bom_excel_form_lg_4_item_popup from w_popup_root
end type
type cb_delete from so_commandbutton within w_des_bom_excel_form_lg_4_item_popup
end type
type cb_update from so_commandbutton within w_des_bom_excel_form_lg_4_item_popup
end type
type cb_insert from so_commandbutton within w_des_bom_excel_form_lg_4_item_popup
end type
type cb_2 from so_commandbutton within w_des_bom_excel_form_lg_4_item_popup
end type
type pb_1 from so_commandbutton within w_des_bom_excel_form_lg_4_item_popup
end type
type cbx_bom_create from checkbox within w_des_bom_excel_form_lg_4_item_popup
end type
type cbx_mfs_bom from checkbox within w_des_bom_excel_form_lg_4_item_popup
end type
type gb_1 from so_groupbox within w_des_bom_excel_form_lg_4_item_popup
end type
type gb_3 from so_groupbox within w_des_bom_excel_form_lg_4_item_popup
end type
end forward

global type w_des_bom_excel_form_lg_4_item_popup from w_popup_root
integer width = 4128
integer height = 2152
string title = "Plan Master Insert Form Popup"
cb_delete cb_delete
cb_update cb_update
cb_insert cb_insert
cb_2 cb_2
pb_1 pb_1
cbx_bom_create cbx_bom_create
cbx_mfs_bom cbx_mfs_bom
gb_1 gb_1
gb_3 gb_3
end type
global w_des_bom_excel_form_lg_4_item_popup w_des_bom_excel_form_lg_4_item_popup

type variables
datawindow idw_datawindow
end variables

forward prototypes
public function integer wf_save_lg ()
end prototypes

public function integer wf_save_lg ();string  lvs_parent_item_code ,  lvs_child_item_code , lvs_set_item_code , lvs_work_no , lvs_bom_create_yn
long i , lvi_count , j 

DELETE FROM ID_ENG_BOM_EXCEL_LG ;

if f_sql_check() < 0 then 
	return -1
end if 

if dw_1.update() < 0 then 
	rollback;
else
	commit;
	f_msgbox(170) 
	DW_1.RESET()
end if

dw_1.reset()
dw_1.importclipboard( )

//=========================================
//
//=========================================

if dw_1.rowcount( ) < 1 then return  -1

open(w_progress_popup)
w_progress_popup.f_set_range( 1,  dw_1.rowcount( ) )
w_progress_popup.f_setstep(1)
			
lvs_set_item_code  = dw_1.object.parent_part_no[1]			
lvs_work_no = string(f_sysdate() , 'yymmddhh24mmss')			

lvs_bom_create_yn = 'Y'	

do
	i++
		
	lvs_parent_item_code  = dw_1.object.parent_part_no[i]
	lvs_child_item_code = dw_1.object.part_no[i]
	
		select count(*) into :lvi_count 
		from id_eng_bom_workspace 
		where parent_item_code = :lvs_parent_item_code
		    and child_item_code = :lvs_child_item_code
		    and organization_id = :gvi_organization_id ;
		  
		if f_sql_check() < 0 then 
			close(w_progress_popup)
			return -1
		end if 
		  
		if lvi_count > 1 then 
				dw_1.selectrow(i , true)
			j++
		end if 
		
	dw_1.object.set_item_code[i] = lvs_set_item_code	
	dw_1.object.bom_create_yn[i] = lvs_bom_create_yn
	w_progress_popup.f_stepit()
	//========================================
	//
	//========================================
	
	dw_1.object.comments[i] =lvs_work_no
	
loop until i = dw_1.rowcount( )

close(w_progress_popup)

//==================================================
//
//==================================================
delete from id_eng_bom_workspace where item_code = :lvs_set_item_code ;

if j> 0 then
	f_msgbox(813 )
	return -1
end if

if dw_1.update() < 0 then 
	rollback;
	RETURN -1 
else
	commit;
	f_msgbox(170) 
	DW_1.RESET()
	RETURN 1 
end if

end function

on w_des_bom_excel_form_lg_4_item_popup.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.cb_insert=create cb_insert
this.cb_2=create cb_2
this.pb_1=create pb_1
this.cbx_bom_create=create cbx_bom_create
this.cbx_mfs_bom=create cbx_mfs_bom
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.cb_update
this.Control[iCurrent+3]=this.cb_insert
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.cbx_bom_create
this.Control[iCurrent+7]=this.cbx_mfs_bom
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_3
end on

on w_des_bom_excel_form_lg_4_item_popup.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.cb_insert)
destroy(this.cb_2)
destroy(this.pb_1)
destroy(this.cbx_bom_create)
destroy(this.cbx_mfs_bom)
destroy(this.gb_1)
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

type p_title from w_popup_root`p_title within w_des_bom_excel_form_lg_4_item_popup
integer width = 4110
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
end type

type cb_sort from w_popup_root`cb_sort within w_des_bom_excel_form_lg_4_item_popup
integer x = 1024
integer y = 0
integer taborder = 40
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_des_bom_excel_form_lg_4_item_popup
boolean visible = true
integer x = 3721
integer y = 304
integer width = 352
integer height = 128
integer taborder = 0
integer weight = 400
end type

event cb_close::clicked;close(parent)
end event

type st_msg from w_popup_root`st_msg within w_des_bom_excel_form_lg_4_item_popup
boolean visible = true
integer y = 508
integer width = 4110
integer weight = 400
end type

type dw_1 from w_popup_root`dw_1 within w_des_bom_excel_form_lg_4_item_popup
boolean visible = true
integer y = 608
integer width = 4105
integer height = 1468
integer taborder = 20
boolean titlebar = true
string title = "Item Receipt List"
string dataobject = "d_des_bom_import_excel_lcd"
boolean controlmenu = true
end type

type dw_2 from w_popup_root`dw_2 within w_des_bom_excel_form_lg_4_item_popup
boolean visible = true
integer y = 608
integer width = 4105
integer height = 1324
integer taborder = 0
boolean titlebar = true
boolean controlmenu = true
end type

event dw_2::constructor;//override
end event

type dw_3 from w_popup_root`dw_3 within w_des_bom_excel_form_lg_4_item_popup
integer y = 948
integer taborder = 50
end type

type cb_delete from so_commandbutton within w_des_bom_excel_form_lg_4_item_popup
integer x = 2619
integer y = 304
integer width = 352
integer height = 128
boolean bringtotop = true
integer weight = 400
string text = "Delete [F3]"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 
dw_1.deleterow( dw_1.getrow())
end event

type cb_update from so_commandbutton within w_des_bom_excel_form_lg_4_item_popup
integer x = 2981
integer y = 304
integer width = 352
integer height = 128
integer taborder = 30
boolean bringtotop = true
integer weight = 400
string text = "Update [F6]"
end type

event clicked;if dw_1.update( ) < 0 then 
	rollback ;
else
	commit ;
end if 
end event

type cb_insert from so_commandbutton within w_des_bom_excel_form_lg_4_item_popup
integer x = 2089
integer y = 304
integer width = 521
integer height = 128
integer taborder = 10
boolean bringtotop = true
integer weight = 400
string text = "Save"
end type

event clicked;call super::clicked;if dw_1.update() < 0 then 
	rollback;
else
	commit;
	f_msgbox(170) 
	DW_1.RESET()
end if

end event

type cb_2 from so_commandbutton within w_des_bom_excel_form_lg_4_item_popup
integer x = 1595
integer y = 304
integer width = 489
integer height = 128
integer taborder = 50
boolean bringtotop = true
integer weight = 400
string text = "Excel Paste"
end type

event clicked;call super::clicked;wf_save_lg() 

end event

type pb_1 from so_commandbutton within w_des_bom_excel_form_lg_4_item_popup
integer x = 3342
integer y = 304
integer width = 352
integer height = 128
integer taborder = 40
boolean bringtotop = true
integer weight = 400
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

type cbx_bom_create from checkbox within w_des_bom_excel_form_lg_4_item_popup
integer x = 64
integer y = 268
integer width = 439
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "BOM Create"
boolean checked = true
end type

type cbx_mfs_bom from checkbox within w_des_bom_excel_form_lg_4_item_popup
integer x = 64
integer y = 356
integer width = 439
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 12632256
string text = "MFS BOM Create"
boolean checked = true
end type

type gb_1 from so_groupbox within w_des_bom_excel_form_lg_4_item_popup
integer x = 1563
integer y = 224
integer width = 2528
integer height = 240
integer taborder = 50
long textcolor = 16711680
string text = "Process"
end type

type gb_3 from so_groupbox within w_des_bom_excel_form_lg_4_item_popup
integer x = 18
integer y = 184
integer width = 571
integer height = 292
integer taborder = 70
long textcolor = 16711680
string text = "Option"
end type


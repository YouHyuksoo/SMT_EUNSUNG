HA$PBExportHeader$w_des_bom_excel_form_lg_4_compare_popup.srw
$PBExportComments$$$HEX4$$d1c540c191c5ddc2$$ENDHEX$$
forward
global type w_des_bom_excel_form_lg_4_compare_popup from w_popup_root
end type
type cb_save from so_commandbutton within w_des_bom_excel_form_lg_4_compare_popup
end type
type cb_2 from so_commandbutton within w_des_bom_excel_form_lg_4_compare_popup
end type
type cb_save2 from so_commandbutton within w_des_bom_excel_form_lg_4_compare_popup
end type
type cb_3 from so_commandbutton within w_des_bom_excel_form_lg_4_compare_popup
end type
type gb_1 from so_groupbox within w_des_bom_excel_form_lg_4_compare_popup
end type
end forward

global type w_des_bom_excel_form_lg_4_compare_popup from w_popup_root
integer width = 5001
integer height = 2780
string title = "Plan Master Insert Form Popup"
cb_save cb_save
cb_2 cb_2
cb_save2 cb_save2
cb_3 cb_3
gb_1 gb_1
end type
global w_des_bom_excel_form_lg_4_compare_popup w_des_bom_excel_form_lg_4_compare_popup

type variables
datawindow idw_datawindow
end variables

forward prototypes
public function integer wf_save_lg ()
public function integer wf_save_lg2 ()
end prototypes

public function integer wf_save_lg ();string  lvs_parent_item_code ,  lvs_child_item_code , lvs_set_item_code , lvs_work_no , lvs_bom_create_yn , lvs_revision
long i , lvi_count , j  , lvdb_return

DELETE FROM ID_ENG_BOM_EXCEL_LG_CPR1 ;

if f_sql_check() < 0 then 
	return -1
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

do
	i++
		
	lvs_parent_item_code  = dw_1.object.parent_part_no[i]
	lvs_child_item_code = dw_1.object.part_no[i]
	
		
	dw_1.object.set_item_code[i]  = lvs_set_item_code	
	dw_1.object.bom_create_yn[i] = lvs_bom_create_yn
	w_progress_popup.f_stepit()
	//========================================
	//
	//========================================
	dw_1.object.comments[i] =lvs_work_no
	
loop until i = dw_1.rowcount( )

close(w_progress_popup)

msg = f_msgbox(1170)
if msg = 1 then 
	cb_save.triggerevent( clicked!)
end if 


end function

public function integer wf_save_lg2 ();string  lvs_parent_item_code ,  lvs_child_item_code , lvs_set_item_code , lvs_work_no , lvs_bom_create_yn , lvs_revision
long i , lvi_count , j  , lvdb_return

DELETE FROM ID_ENG_BOM_EXCEL_LG_CPR2 ;

if f_sql_check() < 0 then 
	return -1
end if 

dw_2.reset()
dw_2.importclipboard( )

//=========================================
//
//=========================================

if dw_2.rowcount( ) < 1 then return  -1

open(w_progress_popup)
w_progress_popup.f_set_range( 1,  dw_2.rowcount( ) )
w_progress_popup.f_setstep(1)
			
lvs_set_item_code  = dw_2.object.parent_part_no[1]			
lvs_work_no = string(f_sysdate() , 'yymmddhh24mmss')			

do
	i++
		
	lvs_parent_item_code  = dw_2.object.parent_part_no[i]
	lvs_child_item_code = dw_2.object.part_no[i]
		
	dw_2.object.set_item_code[i]  = lvs_set_item_code	
	dw_2.object.bom_create_yn[i] = lvs_bom_create_yn
	w_progress_popup.f_stepit()
	//========================================
	//
	//========================================
	dw_2.object.comments[i] =lvs_work_no
	
loop until i = dw_2.rowcount( )

close(w_progress_popup)

msg = f_msgbox(1170)
if msg = 1 then 
	cb_save2.triggerevent( clicked!)
end if 


end function

on w_des_bom_excel_form_lg_4_compare_popup.create
int iCurrent
call super::create
this.cb_save=create cb_save
this.cb_2=create cb_2
this.cb_save2=create cb_save2
this.cb_3=create cb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_save
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_save2
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.gb_1
end on

on w_des_bom_excel_form_lg_4_compare_popup.destroy
call super::destroy
destroy(this.cb_save)
destroy(this.cb_2)
destroy(this.cb_save2)
destroy(this.cb_3)
destroy(this.gb_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)

end event

event activate;call super::activate;ivs_resize_type = 'DEFAULT'
end event

event ue_post_open;call super::ue_post_open;dw_2.SETTRANSOBJECT(SQLCA)


end event

event close;call super::close;rollback;
end event

event closequery;call super::closequery;rollback;
end event

type p_title from w_popup_root`p_title within w_des_bom_excel_form_lg_4_compare_popup
integer width = 4965
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
end type

type cb_sort from w_popup_root`cb_sort within w_des_bom_excel_form_lg_4_compare_popup
integer x = 1024
integer y = 0
integer taborder = 40
end type

type cb_close from w_popup_root`cb_close within w_des_bom_excel_form_lg_4_compare_popup
boolean visible = true
integer x = 4590
integer y = 264
integer width = 352
integer height = 128
integer taborder = 0
end type

event cb_close::clicked;rollback;
close(parent)
end event

type st_msg from w_popup_root`st_msg within w_des_bom_excel_form_lg_4_compare_popup
boolean visible = true
integer y = 448
integer width = 4960
integer weight = 400
end type

type dw_1 from w_popup_root`dw_1 within w_des_bom_excel_form_lg_4_compare_popup
boolean visible = true
integer y = 544
integer width = 2331
integer height = 1152
integer taborder = 20
boolean titlebar = true
string title = "Item Receipt List"
string dataobject = "d_des_bom_import_excel_cpr1_lg"
boolean controlmenu = true
end type

type dw_2 from w_popup_root`dw_2 within w_des_bom_excel_form_lg_4_compare_popup
boolean visible = true
integer x = 2345
integer y = 544
integer width = 2624
integer height = 1152
integer taborder = 0
boolean titlebar = true
string dataobject = "d_des_bom_import_excel_cpr2_lg"
boolean controlmenu = true
end type

event dw_2::constructor;//override
end event

type dw_3 from w_popup_root`dw_3 within w_des_bom_excel_form_lg_4_compare_popup
integer y = 916
integer taborder = 50
end type

type cb_save from so_commandbutton within w_des_bom_excel_form_lg_4_compare_popup
integer x = 558
integer y = 268
integer width = 521
integer height = 128
integer taborder = 10
boolean bringtotop = true
string text = "Save"
end type

event clicked;call super::clicked;if dw_1.update() < 0 then 
	rollback;
else
	commit;
	f_msgbox(170) 
end if

end event

type cb_2 from so_commandbutton within w_des_bom_excel_form_lg_4_compare_popup
integer x = 64
integer y = 268
integer width = 489
integer height = 128
integer taborder = 50
boolean bringtotop = true
string text = "Excel Paste 1"
end type

event clicked;call super::clicked;wf_save_lg() 

end event

type cb_save2 from so_commandbutton within w_des_bom_excel_form_lg_4_compare_popup
integer x = 2926
integer y = 268
integer width = 521
integer height = 128
integer taborder = 20
boolean bringtotop = true
string text = "Save"
end type

event clicked;call super::clicked;if dw_2.update() < 0 then 
	rollback;
else
	commit;
	f_msgbox(170) 
end if

end event

type cb_3 from so_commandbutton within w_des_bom_excel_form_lg_4_compare_popup
integer x = 2432
integer y = 268
integer width = 489
integer height = 128
integer taborder = 20
boolean bringtotop = true
string text = "Excel Paste 2"
end type

event clicked;call super::clicked;Wf_save_lg2() 

end event

type gb_1 from so_groupbox within w_des_bom_excel_form_lg_4_compare_popup
integer x = 9
integer y = 188
integer width = 4960
integer height = 240
integer taborder = 50
long textcolor = 16711680
string text = "Process"
end type


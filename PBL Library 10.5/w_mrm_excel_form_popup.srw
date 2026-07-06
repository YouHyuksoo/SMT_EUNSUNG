HA$PBExportHeader$w_mrm_excel_form_popup.srw
$PBExportComments$$$HEX10$$90c7acc785c7e0acd1c540c191c5ddc20d000a00$$ENDHEX$$forward
global type w_mrm_excel_form_popup from w_popup_root
end type
type cb_delete from so_commandbutton within w_mrm_excel_form_popup
end type
type cb_update from so_commandbutton within w_mrm_excel_form_popup
end type
type cb_insert from so_commandbutton within w_mrm_excel_form_popup
end type
type cb_2 from so_commandbutton within w_mrm_excel_form_popup
end type
type pb_1 from so_commandbutton within w_mrm_excel_form_popup
end type
type em_mrm_version from so_editmask within w_mrm_excel_form_popup
end type
type st_1 from so_statictext within w_mrm_excel_form_popup
end type
type gb_3 from so_groupbox within w_mrm_excel_form_popup
end type
end forward

global type w_mrm_excel_form_popup from w_popup_root
integer width = 4128
integer height = 1956
string title = "Plan Master Insert Form Popup"
cb_delete cb_delete
cb_update cb_update
cb_insert cb_insert
cb_2 cb_2
pb_1 pb_1
em_mrm_version em_mrm_version
st_1 st_1
gb_3 gb_3
end type
global w_mrm_excel_form_popup w_mrm_excel_form_popup

type variables
datawindow idw_datawindow
end variables

on w_mrm_excel_form_popup.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.cb_insert=create cb_insert
this.cb_2=create cb_2
this.pb_1=create pb_1
this.em_mrm_version=create em_mrm_version
this.st_1=create st_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.cb_update
this.Control[iCurrent+3]=this.cb_insert
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.em_mrm_version
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.gb_3
end on

on w_mrm_excel_form_popup.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.cb_insert)
destroy(this.cb_2)
destroy(this.pb_1)
destroy(this.em_mrm_version)
destroy(this.st_1)
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

type p_title from w_popup_root`p_title within w_mrm_excel_form_popup
integer width = 4110
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
end type

type cb_sort from w_popup_root`cb_sort within w_mrm_excel_form_popup
integer x = 1024
integer y = 0
integer taborder = 40
end type

type cb_close from w_popup_root`cb_close within w_mrm_excel_form_popup
boolean visible = true
integer x = 3739
integer y = 248
integer width = 352
integer height = 128
integer taborder = 0
end type

event cb_close::clicked;close(parent)
end event

type st_msg from w_popup_root`st_msg within w_mrm_excel_form_popup
boolean visible = true
integer y = 420
integer width = 4110
integer weight = 400
end type

type dw_1 from w_popup_root`dw_1 within w_mrm_excel_form_popup
boolean visible = true
integer y = 516
integer width = 2217
integer height = 1324
integer taborder = 20
boolean titlebar = true
string title = "MrmList"
string dataobject = "d_mrm_lst"
boolean controlmenu = true
end type

type dw_2 from w_popup_root`dw_2 within w_mrm_excel_form_popup
boolean visible = true
integer x = 2217
integer y = 516
integer width = 1874
integer height = 1324
integer taborder = 0
boolean titlebar = true
string dataobject = "d_mrm_excel_popup"
boolean controlmenu = true
end type

event dw_2::constructor;//override
end event

type dw_3 from w_popup_root`dw_3 within w_mrm_excel_form_popup
integer y = 856
integer taborder = 50
end type

type cb_delete from so_commandbutton within w_mrm_excel_form_popup
integer x = 741
integer y = 248
integer width = 352
integer height = 144
boolean bringtotop = true
string text = "Delete [F3]"
end type

event clicked;call super::clicked;if dw_1.getrow() < 1 then return 
dw_1.deleterow( dw_1.getrow())
end event

type cb_update from so_commandbutton within w_mrm_excel_form_popup
integer x = 1097
integer y = 248
integer width = 352
integer height = 144
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

type cb_insert from so_commandbutton within w_mrm_excel_form_popup
integer x = 384
integer y = 248
integer width = 352
integer height = 144
integer taborder = 10
boolean bringtotop = true
string text = "Insert [F2]"
end type

event clicked;call super::clicked;Decimal lvf_issue_qty
long n = 1  , i = 1 
double LVDB_RCV_ISS_SEQ
sTRING lvs_receipt_lot_no

dw_2.setredraw( false)

if dw_2.rowcount() < 1 then return 
//lvs_receipt_lot_no= f_get_any_no( 'RECEIPT_LOT_NO')

for i = 1 to dw_2.rowcount()
	
	n = dw_1.insertrow(0)
	dw_1.scrolltorow(n)
	f_set_security_row(dw_1, n, 'ALL')

	
//	LVDB_RCV_ISS_SEQ = double(f_get_sequence('seq_mat_receipt'))	


	DW_1.OBJECT.MRM_NO[n] = DW_2.OBject.MRM_NO[i]

	DW_1.OBJECT.MODEL_NAME[n] = DW_2.OBJECT.MODEL_NAME[i] 
	DW_1.OBJECT.LEVEL_NO[n] = DW_2.OBJECT.LEVEL_NO[i] 
	DW_1.OBJECT.A_RANK_NO[n] = DW_2.OBJECT.A_RANK_NO[i] 
	DW_1.OBJECT.B_RANK_NO[n] = DW_2.OBJECT.B_RANK_NO[i] 
	DW_1.OBJECT.T_CODE[n] = DW_2.OBJECT.T_CODE[i] 
	DW_1.OBJECT.ASYMMETRY1[n] = DW_2.OBJECT.ASYMMETRY1[i] 
	DW_1.OBJECT.ASYMMETRY2[n] = DW_2.OBJECT.ASYMMETRY2[i] 
	DW_1.OBJECT.GROUP_ID[n] = DW_2.OBJECT.GROUP_ID[i] 
	DW_1.OBJECT.GROUP_ID2[n] = DW_2.OBJECT.GROUP_ID2[i] 	
	DW_1.OBJECT.MRM_VERSION[n] = INTEGER(EM_MRM_VERSION.TEXT)
	
	st_msg.text = string(i)+"/"+string(DW_2.ROWCOUNT( ))
next
//=================================================
//
//=================================================
dw_2.setredraw( true)
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

type cb_2 from so_commandbutton within w_mrm_excel_form_popup
integer x = 27
integer y = 248
integer width = 352
integer height = 144
integer taborder = 50
boolean bringtotop = true
string text = "Excel Paste"
end type

event clicked;call super::clicked;string lvs_supplier_code , lvs_item_code , lvs_line_type , lvs_invoice_no , LVS_LOCATION_CODE ,lvs_invoice_no_cond
long i , lvi_count  , lvi_error_count
datetime lvdt_dateset
dw_2.reset()
dw_2.importclipboard( )
//=========================================
//
//=========================================
//
//if dw_2.rowcount( ) < 1 then return 
//
//open(w_progress_popup)
//w_progress_popup.f_set_range( 1,  dw_2.rowcount( ) )
//w_progress_popup.f_setstep(1)
//										
//do
//	i++
//
//		
//
//	w_progress_popup.f_stepit()	
//loop until i = dw_2.rowcount( )
//close(w_progress_popup)



end event

type pb_1 from so_commandbutton within w_mrm_excel_form_popup
integer x = 3383
integer y = 248
integer width = 352
integer height = 128
integer taborder = 40
boolean bringtotop = true
string text = "Save Form"
end type

event clicked;call super::clicked;string     docname, named 
Long iret

SETPOINTER(HOURGLASS!)		
iret = GetFileSaveName("Select Excel File ("+dw_2.classname()+")" , docname, named, "xls", "Excel Files (*.xls),*.xls")		

IF iret =1 THEN 
	     dw_2.insertrow(0)
		 uf_save_dw_as_excel( dw_2  , docname )
ELSE
	RETURN
END IF
		

end event

type em_mrm_version from so_editmask within w_mrm_excel_form_popup
integer x = 2107
integer y = 276
integer taborder = 40
boolean bringtotop = true
string text = "1"
boolean spin = true
double increment = 1
string minmax = "1~~100"
end type

type st_1 from so_statictext within w_mrm_excel_form_popup
integer x = 1659
integer y = 280
integer width = 430
boolean bringtotop = true
string text = "MRM Version"
alignment alignment = right!
end type

type gb_3 from so_groupbox within w_mrm_excel_form_popup
integer y = 176
integer width = 4110
integer height = 240
long textcolor = 16711680
string text = "Process"
end type


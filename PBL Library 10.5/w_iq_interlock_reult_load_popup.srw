HA$PBExportHeader$w_iq_interlock_reult_load_popup.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_iq_interlock_reult_load_popup from w_popup_root
end type
type cb_retrieve from commandbutton within w_iq_interlock_reult_load_popup
end type
type cb_1 from commandbutton within w_iq_interlock_reult_load_popup
end type
type cb_2 from commandbutton within w_iq_interlock_reult_load_popup
end type
type cb_3 from commandbutton within w_iq_interlock_reult_load_popup
end type
type cb_save_form from so_commandbutton within w_iq_interlock_reult_load_popup
end type
type gb_3 from so_groupbox within w_iq_interlock_reult_load_popup
end type
end forward

global type w_iq_interlock_reult_load_popup from w_popup_root
integer width = 5010
integer height = 2156
string title = "BOM Excel Load Popup"
cb_retrieve cb_retrieve
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
cb_save_form cb_save_form
gb_3 gb_3
end type
global w_iq_interlock_reult_load_popup w_iq_interlock_reult_load_popup

on w_iq_interlock_reult_load_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_save_form=create cb_save_form
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.cb_save_form
this.Control[iCurrent+6]=this.gb_3
end on

on w_iq_interlock_reult_load_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_save_form)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)


end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_iq_interlock_reult_load_popup
integer width = 4343
integer height = 188
long backcolor = 16777215
end type

type cb_sort from w_popup_root`cb_sort within w_iq_interlock_reult_load_popup
integer x = 2025
integer y = 276
integer height = 156
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_iq_interlock_reult_load_popup
boolean visible = true
integer x = 1682
integer y = 280
integer height = 156
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_iq_interlock_reult_load_popup
boolean visible = true
integer y = 484
integer width = 4343
end type

type dw_1 from w_popup_root`dw_1 within w_iq_interlock_reult_load_popup
boolean visible = true
integer y = 576
integer width = 4347
integer height = 1304
integer taborder = 70
boolean titlebar = true
string title = "Excel BOM"
string dataobject = "d_iq_interlock_check_result_upload_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_iq_interlock_reult_load_popup
boolean visible = true
integer y = 584
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_iq_interlock_reult_load_popup
integer y = 864
end type

type cb_retrieve from commandbutton within w_iq_interlock_reult_load_popup
integer x = 334
integer y = 280
integer width = 274
integer height = 156
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE()
end event

type cb_1 from commandbutton within w_iq_interlock_reult_load_popup
integer x = 50
integer y = 280
integer width = 274
integer height = 156
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Paste"
end type

event clicked;

msg = f_msgbox1(1161 , this.text )
if msg =1 then 
	dw_1.reset()
	dw_1.importclipboard( )
end if 
end event

type cb_2 from commandbutton within w_iq_interlock_reult_load_popup
integer x = 622
integer y = 280
integer width = 274
integer height = 156
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete"
end type

event clicked;if dw_1.getrow() < 1 then return
   dw_1.deleterow( dw_1.getrow())


end event

type cb_3 from commandbutton within w_iq_interlock_reult_load_popup
integer x = 910
integer y = 280
integer width = 274
integer height = 156
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save"
end type

event clicked;if dw_1.update() < 0 then 
	rollback;
else
	commit;
	f_msgbox(170) 
end if


end event

type cb_save_form from so_commandbutton within w_iq_interlock_reult_load_popup
integer x = 1326
integer y = 280
integer width = 357
integer height = 156
integer taborder = 100
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

type gb_3 from so_groupbox within w_iq_interlock_reult_load_popup
integer x = 14
integer y = 204
integer width = 2002
integer height = 264
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


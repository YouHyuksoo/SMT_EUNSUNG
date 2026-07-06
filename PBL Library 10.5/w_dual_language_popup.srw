HA$PBExportHeader$w_dual_language_popup.srw
$PBExportComments$(Supplier Query)-$$HEX5$$70ac98b798cc70c88cd6$$ENDHEX$$
forward
global type w_dual_language_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_dual_language_popup
end type
type sle_text from so_singlelineedit within w_dual_language_popup
end type
type st_2 from so_statictext within w_dual_language_popup
end type
type cb_1 from so_commandbutton within w_dual_language_popup
end type
type cb_2 from so_commandbutton within w_dual_language_popup
end type
type cb_3 from so_commandbutton within w_dual_language_popup
end type
type cbx_auto_reset from checkbox within w_dual_language_popup
end type
type cbx_auto_close from checkbox within w_dual_language_popup
end type
type gb_1 from so_groupbox within w_dual_language_popup
end type
type gb_2 from so_groupbox within w_dual_language_popup
end type
end forward

global type w_dual_language_popup from w_popup_root
integer width = 3186
integer height = 1552
string title = "Dual Language Popup"
cb_retrieve cb_retrieve
sle_text sle_text
st_2 st_2
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
cbx_auto_reset cbx_auto_reset
cbx_auto_close cbx_auto_close
gb_1 gb_1
gb_2 gb_2
end type
global w_dual_language_popup w_dual_language_popup

type variables

end variables

on w_dual_language_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.sle_text=create sle_text
this.st_2=create st_2
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cbx_auto_reset=create cbx_auto_reset
this.cbx_auto_close=create cbx_auto_close
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.sle_text
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.cbx_auto_reset
this.Control[iCurrent+8]=this.cbx_auto_close
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
end on

on w_dual_language_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.sle_text)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cbx_auto_reset)
destroy(this.cbx_auto_close)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)
SLE_TEXT.TEXT = MESSAGE.STRINGPARM
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_dual_language_popup
integer width = 3173
end type

type cb_sort from w_popup_root`cb_sort within w_dual_language_popup
boolean visible = true
integer x = 1463
integer y = 336
end type

type cb_close from w_popup_root`cb_close within w_dual_language_popup
boolean visible = true
integer x = 2839
integer y = 336
end type

type st_msg from w_popup_root`st_msg within w_dual_language_popup
boolean visible = true
integer y = 520
integer width = 3173
end type

type dw_1 from w_popup_root`dw_1 within w_dual_language_popup
boolean visible = true
integer y = 608
integer width = 3173
integer height = 860
string dataobject = "d_dual_language_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_dual_language_popup
boolean visible = true
integer y = 620
end type

type dw_3 from w_popup_root`dw_3 within w_dual_language_popup
integer y = 624
end type

type cb_retrieve from so_commandbutton within w_dual_language_popup
integer x = 1737
integer y = 336
integer width = 274
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(UPPER(sle_text.TEXT)+'%'  , GVI_ORGANIZATION_ID )
end event

type sle_text from so_singlelineedit within w_dual_language_popup
integer x = 32
integer y = 384
integer width = 791
integer taborder = 30
boolean bringtotop = true
textcase textcase = upper!
end type

type st_2 from so_statictext within w_dual_language_popup
integer x = 32
integer y = 292
integer width = 791
boolean bringtotop = true
integer weight = 700
string text = "TEXT"
end type

type cb_1 from so_commandbutton within w_dual_language_popup
integer x = 2007
integer y = 336
integer width = 274
integer height = 100
integer taborder = 80
boolean bringtotop = true
string text = "Insert"
end type

event clicked;call super::clicked;Int Lvi_row
lvi_row = dw_1.insertrow(0)
dw_1.setitem(  lvi_row , 'english_text' , Upper( sle_text.text ))
dw_1.setitem(  lvi_row , 'english_origin_text' , Upper( sle_text.text ))
dw_1.setitem(  lvi_row , 'local_text' , Upper( sle_text.text ))
dw_1.setitem(  lvi_row , 'korea_text' , Upper( sle_text.text ))
dw_1.setitem(  lvi_row , 'conver_chk' , 'Y')
f_set_security_row( dw_1 , lvi_row , 'ALL' ) 
end event

type cb_2 from so_commandbutton within w_dual_language_popup
integer x = 2281
integer y = 336
integer width = 274
integer height = 100
integer taborder = 90
boolean bringtotop = true
string text = "Delete"
end type

event clicked;call super::clicked;DW_1.DELETEROW( DW_1.GETROW() )
end event

type cb_3 from so_commandbutton within w_dual_language_popup
integer x = 2560
integer y = 336
integer width = 274
integer height = 100
integer taborder = 100
boolean bringtotop = true
string text = "Update"
boolean default = true
end type

event clicked;call super::clicked;IF DW_1.UPDATE() < 0 THEN 
	ROLLBACK ;
	
ELSE
	COMMIT ;


    SELECTED_WINDOW = W_MAIN_FRAME.GetActiveSheet()

	IF CBX_AUTO_RESET.CHECKED = TRUE THEN 
		
		f_msg_mdi_help( SELECTED_WINDOW.classname()+ "Language Change Done") 		
		F_RESET_DUAL_LANGUAGE ( SELECTED_WINDOW )
		
	END IF
	
	IF CBX_AUTO_CLOSE.CHECKED = TRUE THEN 
		CB_CLOSE.TRIGGEREVENT(CLICKED!)
	END IF

	F_MSG_MDI_HELP( F_MSG_ST( 170) ) 	
END IF


end event

type cbx_auto_reset from checkbox within w_dual_language_popup
integer x = 910
integer y = 308
integer width = 402
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
string text = "Auto Reset"
boolean checked = true
end type

type cbx_auto_close from checkbox within w_dual_language_popup
integer x = 910
integer y = 396
integer width = 402
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
string text = "Auto Close"
end type

type gb_1 from so_groupbox within w_dual_language_popup
integer x = 1417
integer y = 224
integer width = 1737
integer height = 288
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_dual_language_popup
integer y = 216
integer width = 855
integer height = 288
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


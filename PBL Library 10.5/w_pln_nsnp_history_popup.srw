HA$PBExportHeader$w_pln_nsnp_history_popup.srw
$PBExportComments$$$HEX8$$6cade4b9e8b200ac20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_pln_nsnp_history_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_pln_nsnp_history_popup
end type
type sle_line_code from so_singlelineedit within w_pln_nsnp_history_popup
end type
type st_mrm_no from statictext within w_pln_nsnp_history_popup
end type
type gb_2 from so_groupbox within w_pln_nsnp_history_popup
end type
type gb_3 from so_groupbox within w_pln_nsnp_history_popup
end type
end forward

global type w_pln_nsnp_history_popup from w_popup_root
integer width = 4448
integer height = 2232
string title = "Material Item Popup"
cb_retrieve cb_retrieve
sle_line_code sle_line_code
st_mrm_no st_mrm_no
gb_2 gb_2
gb_3 gb_3
end type
global w_pln_nsnp_history_popup w_pln_nsnp_history_popup

on w_pln_nsnp_history_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.sle_line_code=create sle_line_code
this.st_mrm_no=create st_mrm_no
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.sle_line_code
this.Control[iCurrent+3]=this.st_mrm_no
this.Control[iCurrent+4]=this.gb_2
this.Control[iCurrent+5]=this.gb_3
end on

on w_pln_nsnp_history_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.sle_line_code)
destroy(this.st_mrm_no)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)
sle_line_code.text = message.stringparm
cb_retrieve.triggerevent(clicked!)
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_pln_nsnp_history_popup
integer width = 4443
end type

type cb_sort from w_popup_root`cb_sort within w_pln_nsnp_history_popup
boolean visible = true
integer x = 3113
integer y = 304
integer width = 325
integer height = 164
integer weight = 400
end type

type cb_close from w_popup_root`cb_close within w_pln_nsnp_history_popup
boolean visible = true
integer x = 4069
integer y = 304
integer width = 325
integer height = 164
integer weight = 400
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_pln_nsnp_history_popup
boolean visible = true
integer x = 5
integer y = 556
integer width = 4448
end type

type dw_1 from w_popup_root`dw_1 within w_pln_nsnp_history_popup
boolean visible = true
integer y = 660
integer width = 4453
integer height = 1504
boolean titlebar = true
string title = "Material Item Inventory List"
string dataobject = "d_pln_product_nsnp_history_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_pln_nsnp_history_popup
integer y = 660
end type

type dw_3 from w_popup_root`dw_3 within w_pln_nsnp_history_popup
integer y = 736
end type

type cb_retrieve from so_commandbutton within w_pln_nsnp_history_popup
integer x = 3429
integer y = 304
integer width = 325
integer height = 164
integer taborder = 70
boolean bringtotop = true
integer weight = 400
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE( sle_line_code.text + '%'  , GVI_ORGANIZATION_ID )
end event

type sle_line_code from so_singlelineedit within w_pln_nsnp_history_popup
integer x = 64
integer y = 404
integer width = 631
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

type st_mrm_no from statictext within w_pln_nsnp_history_popup
integer x = 64
integer y = 324
integer width = 631
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Line Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_2 from so_groupbox within w_pln_nsnp_history_popup
integer x = 5
integer y = 216
integer width = 763
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_pln_nsnp_history_popup
integer x = 3090
integer y = 204
integer width = 1335
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


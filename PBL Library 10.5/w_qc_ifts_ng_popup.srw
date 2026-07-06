HA$PBExportHeader$w_qc_ifts_ng_popup.srw
$PBExportComments$(Item Query)-$$HEX6$$80bd88d470c88cd60d000a00$$ENDHEX$$forward
global type w_qc_ifts_ng_popup from w_popup_root
end type
type cb_select from commandbutton within w_qc_ifts_ng_popup
end type
type cb_retrieve from commandbutton within w_qc_ifts_ng_popup
end type
type st_27 from so_statictext within w_qc_ifts_ng_popup
end type
type sle_run_no from so_singlelineedit within w_qc_ifts_ng_popup
end type
type gb_1 from so_groupbox within w_qc_ifts_ng_popup
end type
type gb_2 from so_groupbox within w_qc_ifts_ng_popup
end type
end forward

global type w_qc_ifts_ng_popup from w_popup_root
integer width = 3785
integer height = 2156
string title = "LV Ng Popup"
cb_select cb_select
cb_retrieve cb_retrieve
st_27 st_27
sle_run_no sle_run_no
gb_1 gb_1
gb_2 gb_2
end type
global w_qc_ifts_ng_popup w_qc_ifts_ng_popup

on w_qc_ifts_ng_popup.create
int iCurrent
call super::create
this.cb_select=create cb_select
this.cb_retrieve=create cb_retrieve
this.st_27=create st_27
this.sle_run_no=create sle_run_no
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.st_27
this.Control[iCurrent+4]=this.sle_run_no
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.gb_2
end on

on w_qc_ifts_ng_popup.destroy
call super::destroy
destroy(this.cb_select)
destroy(this.cb_retrieve)
destroy(this.st_27)
destroy(this.sle_run_no)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)

SLE_RUN_NO.TEXT = message.stringparm

CB_RETRIEVE.TRIGGEREVENT(CLICKED!)

end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_qc_ifts_ng_popup
integer width = 3771
integer height = 188
long backcolor = 16777215
end type

type cb_sort from w_popup_root`cb_sort within w_qc_ifts_ng_popup
boolean visible = true
integer x = 2400
integer y = 280
integer width = 329
integer height = 156
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_qc_ifts_ng_popup
boolean visible = true
integer x = 3401
integer y = 280
integer width = 329
integer height = 156
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_qc_ifts_ng_popup
boolean visible = true
integer y = 484
integer width = 3771
end type

type dw_1 from w_popup_root`dw_1 within w_qc_ifts_ng_popup
boolean visible = true
integer y = 588
integer width = 3771
integer height = 1480
integer taborder = 70
boolean titlebar = true
string title = "NG List"
string dataobject = "d_qc_machine_inspect_ng_data_popup_ifts"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

type dw_2 from w_popup_root`dw_2 within w_qc_ifts_ng_popup
boolean visible = true
integer y = 772
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_qc_ifts_ng_popup
integer y = 864
end type

type cb_select from commandbutton within w_qc_ifts_ng_popup
integer x = 3067
integer y = 280
integer width = 329
integer height = 156
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select"
end type

type cb_retrieve from commandbutton within w_qc_ifts_ng_popup
integer x = 2734
integer y = 280
integer width = 329
integer height = 156
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
boolean default = true
end type

event clicked;DW_1.RETRIEVE( SLE_RUN_NO.TEXT, GVI_ORGANIZATION_ID )
end event

type st_27 from so_statictext within w_qc_ifts_ng_popup
integer x = 37
integer y = 280
integer width = 617
integer height = 72
boolean bringtotop = true
long textcolor = 16711680
string text = "Run No"
end type

type sle_run_no from so_singlelineedit within w_qc_ifts_ng_popup
integer x = 37
integer y = 344
integer width = 617
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
textcase textcase = upper!
end type

type gb_1 from so_groupbox within w_qc_ifts_ng_popup
integer y = 200
integer width = 686
integer height = 284
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_qc_ifts_ng_popup
integer x = 2359
integer y = 200
integer width = 1413
integer height = 284
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


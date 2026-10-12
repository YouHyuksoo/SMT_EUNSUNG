HA$PBExportHeader$w_pln_smd_run_card_popup.srw
$PBExportComments$SMD $$HEX5$$91c7c5c5c0c9dcc22000$$ENDHEX$$popup $$HEX1$$3dcc$$ENDHEX$$
forward
global type w_pln_smd_run_card_popup from w_popup_root
end type
type cb_select from commandbutton within w_pln_smd_run_card_popup
end type
type cb_retrieve from commandbutton within w_pln_smd_run_card_popup
end type
type uo_dateset from uo_ymd_calendar within w_pln_smd_run_card_popup
end type
type st_6 from statictext within w_pln_smd_run_card_popup
end type
type st_27 from so_statictext within w_pln_smd_run_card_popup
end type
type ddlb_line_code from uo_line_code within w_pln_smd_run_card_popup
end type
type gb_1 from so_groupbox within w_pln_smd_run_card_popup
end type
type gb_2 from so_groupbox within w_pln_smd_run_card_popup
end type
end forward

global type w_pln_smd_run_card_popup from w_popup_root
integer width = 3785
integer height = 2156
string title = "Assembly Run No Master Popup"
cb_select cb_select
cb_retrieve cb_retrieve
uo_dateset uo_dateset
st_6 st_6
st_27 st_27
ddlb_line_code ddlb_line_code
gb_1 gb_1
gb_2 gb_2
end type
global w_pln_smd_run_card_popup w_pln_smd_run_card_popup

on w_pln_smd_run_card_popup.create
int iCurrent
call super::create
this.cb_select=create cb_select
this.cb_retrieve=create cb_retrieve
this.uo_dateset=create uo_dateset
this.st_6=create st_6
this.st_27=create st_27
this.ddlb_line_code=create ddlb_line_code
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.uo_dateset
this.Control[iCurrent+4]=this.st_6
this.Control[iCurrent+5]=this.st_27
this.Control[iCurrent+6]=this.ddlb_line_code
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_pln_smd_run_card_popup.destroy
call super::destroy
destroy(this.cb_select)
destroy(this.cb_retrieve)
destroy(this.uo_dateset)
destroy(this.st_6)
destroy(this.st_27)
destroy(this.ddlb_line_code)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;
string lvs_line_code

dw_1.settransobject(sqlca)
lvs_line_code = MESSAGE.STRINGPARM

IF ( len(lvs_line_code) > 0 ) THEN
	 ddlb_line_code.selectitem(  lvs_line_code, 1)
END IF


CB_RETRIEVE.TRIGGEREVENT(CLICKED!)

end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_pln_smd_run_card_popup
integer width = 3771
integer height = 188
long backcolor = 16777215
end type

type cb_sort from w_popup_root`cb_sort within w_pln_smd_run_card_popup
boolean visible = true
integer x = 2400
integer y = 280
integer width = 329
integer height = 156
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_pln_smd_run_card_popup
boolean visible = true
integer x = 3401
integer y = 280
integer width = 329
integer height = 156
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_pln_smd_run_card_popup
boolean visible = true
integer y = 484
integer width = 3771
end type

type dw_1 from w_popup_root`dw_1 within w_pln_smd_run_card_popup
boolean visible = true
integer y = 588
integer width = 3771
integer height = 1480
integer taborder = 70
boolean titlebar = true
string title = "Run No  List"
string dataobject = "d_pln_smd_run_card_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

type dw_2 from w_popup_root`dw_2 within w_pln_smd_run_card_popup
boolean visible = true
integer y = 772
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_pln_smd_run_card_popup
integer y = 864
end type

type cb_select from commandbutton within w_pln_smd_run_card_popup
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
boolean default = true
end type

event clicked;IF DW_1.GETROW() = 0  THEN 
	gst_return.gvb_return = false
	RETURN -1
END IF

gst_return.gvb_return = true 

MESSAGE.STRINGPARM= DW_1.GETITEMSTRING( DW_1.GETROW() , 'RUN_NO')

CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type cb_retrieve from commandbutton within w_pln_smd_run_card_popup
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
end type

event clicked;
DW_1.RETRIEVE( UO_DATESET.TEXT(), ddlb_line_code.getcode()+'%' , GVI_ORGANIZATION_ID )
end event

type uo_dateset from uo_ymd_calendar within w_pln_smd_run_card_popup
integer x = 37
integer y = 348
integer width = 402
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type st_6 from statictext within w_pln_smd_run_card_popup
integer x = 480
integer y = 280
integer width = 631
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "$$HEX2$$7cb778c7$$ENDHEX$$"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_27 from so_statictext within w_pln_smd_run_card_popup
integer x = 37
integer y = 280
integer width = 402
integer height = 72
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "$$HEX4$$c4ac8dd67cc790c7$$ENDHEX$$"
end type

type ddlb_line_code from uo_line_code within w_pln_smd_run_card_popup
integer x = 480
integer y = 348
integer taborder = 70
boolean bringtotop = true
end type

type gb_1 from so_groupbox within w_pln_smd_run_card_popup
integer y = 200
integer width = 1774
integer height = 284
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_pln_smd_run_card_popup
integer x = 2359
integer y = 200
integer width = 1413
integer height = 284
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


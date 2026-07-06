HA$PBExportHeader$w_plan_run_no_status_popup.srw
$PBExportComments$$$HEX10$$f9b2d4c6c4ac8dd61cc888bc20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_plan_run_no_status_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_plan_run_no_status_popup
end type
type sle_run_no from so_singlelineedit within w_plan_run_no_status_popup
end type
type st_2 from so_statictext within w_plan_run_no_status_popup
end type
type st_1 from so_statictext within w_plan_run_no_status_popup
end type
type sle_1 from so_singlelineedit within w_plan_run_no_status_popup
end type
type gb_2 from so_groupbox within w_plan_run_no_status_popup
end type
type gb_3 from so_groupbox within w_plan_run_no_status_popup
end type
end forward

global type w_plan_run_no_status_popup from w_popup_root
integer width = 4443
integer height = 2048
string title = "Lot Trace List"
cb_retrieve cb_retrieve
sle_run_no sle_run_no
st_2 st_2
st_1 st_1
sle_1 sle_1
gb_2 gb_2
gb_3 gb_3
end type
global w_plan_run_no_status_popup w_plan_run_no_status_popup

type variables

end variables

on w_plan_run_no_status_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.sle_run_no=create sle_run_no
this.st_2=create st_2
this.st_1=create st_1
this.sle_1=create sle_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.sle_run_no
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_1
this.Control[iCurrent+6]=this.gb_2
this.Control[iCurrent+7]=this.gb_3
end on

on w_plan_run_no_status_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.sle_run_no)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)
ivs_mousemove_yn = 'N'
//========================
//$$HEX3$$70c88cd62000$$ENDHEX$$
//========================
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

event ue_post_open;call super::ue_post_open;sle_run_no.text = message.stringparm
cb_retrieve.triggerevent(clicked!)
end event

type p_title from w_popup_root`p_title within w_plan_run_no_status_popup
integer width = 4425
end type

type cb_sort from w_popup_root`cb_sort within w_plan_run_no_status_popup
boolean visible = true
integer x = 3323
integer y = 8
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_plan_run_no_status_popup
boolean visible = true
integer x = 3109
integer y = 300
integer width = 421
integer height = 180
integer taborder = 0
end type

type st_msg from w_popup_root`st_msg within w_plan_run_no_status_popup
boolean visible = true
integer x = 5
integer y = 564
integer width = 4425
end type

type dw_1 from w_popup_root`dw_1 within w_plan_run_no_status_popup
boolean visible = true
integer x = 5
integer y = 656
integer width = 4434
integer height = 1112
integer taborder = 0
boolean titlebar = true
string dataobject = "d_product_run_card_io_out_status_popup"
end type

type dw_2 from w_popup_root`dw_2 within w_plan_run_no_status_popup
boolean visible = true
integer x = 5
integer y = 656
integer taborder = 0
boolean titlebar = true
boolean controlmenu = true
end type

type dw_3 from w_popup_root`dw_3 within w_plan_run_no_status_popup
integer x = 5
integer y = 656
integer taborder = 0
end type

type cb_retrieve from so_commandbutton within w_plan_run_no_status_popup
integer x = 2551
integer y = 300
integer width = 421
integer height = 180
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;	dw_1.RETRIEVE(  sle_run_no.text+'%' , GVI_ORGANIZATION_ID )

end event

type sle_run_no from so_singlelineedit within w_plan_run_no_status_popup
integer x = 64
integer y = 372
integer width = 622
integer height = 96
integer taborder = 10
boolean bringtotop = true
textcase textcase = upper!
end type

event getfocus;call super::getfocus;this.selecttext(1 , len(this.text))
end event

type st_2 from so_statictext within w_plan_run_no_status_popup
integer x = 64
integer y = 300
integer width = 622
integer height = 60
boolean bringtotop = true
integer textsize = -10
long textcolor = 16777215
string text = "Run No"
end type

type st_1 from so_statictext within w_plan_run_no_status_popup
integer x = 690
integer y = 300
integer width = 622
integer height = 60
boolean bringtotop = true
integer textsize = -10
long textcolor = 16777215
string text = "Serial No"
end type

type sle_1 from so_singlelineedit within w_plan_run_no_status_popup
integer x = 690
integer y = 372
integer width = 622
integer height = 96
integer taborder = 20
boolean bringtotop = true
textcase textcase = upper!
end type

event modified;call super::modified;sle_run_no.text = f_get_run_no_by_serial( this.text) 
//==================================
//
//==================================
if sle_run_no.text <> '' then 
	cb_retrieve.triggerevent(clicked!)
else
	this.selecttext( 1,100)
	st_msg.text = "No Data Found"
end if

end event

type gb_2 from so_groupbox within w_plan_run_no_status_popup
integer x = 32
integer y = 196
integer width = 1335
integer height = 336
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_plan_run_no_status_popup
integer x = 2455
integer y = 204
integer width = 1166
integer height = 336
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


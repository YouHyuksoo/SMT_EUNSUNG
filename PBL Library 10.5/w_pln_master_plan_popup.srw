HA$PBExportHeader$w_pln_master_plan_popup.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_pln_master_plan_popup from w_popup_root
end type
type cb_select from commandbutton within w_pln_master_plan_popup
end type
type cb_retrieve from commandbutton within w_pln_master_plan_popup
end type
type ddlb_item_code from uo_item_code within w_pln_master_plan_popup
end type
type st_3 from so_statictext within w_pln_master_plan_popup
end type
type st_1 from so_statictext within w_pln_master_plan_popup
end type
type ddlb_mfs from uo_mfs_this_month within w_pln_master_plan_popup
end type
type st_5 from so_statictext within w_pln_master_plan_popup
end type
type ddlb_line_code from uo_line_code within w_pln_master_plan_popup
end type
type sle_model_name from singlelineedit within w_pln_master_plan_popup
end type
type st_6 from statictext within w_pln_master_plan_popup
end type
type st_4 from so_statictext within w_pln_master_plan_popup
end type
type uo_dateset from uo_ymd_calendar within w_pln_master_plan_popup
end type
type uo_dateend from uo_ymd_calendar within w_pln_master_plan_popup
end type
type rb_2 from so_radiobutton within w_pln_master_plan_popup
end type
type rb_3 from so_radiobutton within w_pln_master_plan_popup
end type
type rb_4 from so_radiobutton within w_pln_master_plan_popup
end type
type rb_5 from so_radiobutton within w_pln_master_plan_popup
end type
type ddlb_plan_status from uo_basecode within w_pln_master_plan_popup
end type
type st_2 from statictext within w_pln_master_plan_popup
end type
type gb_2 from so_groupbox within w_pln_master_plan_popup
end type
type gb_1 from so_groupbox within w_pln_master_plan_popup
end type
end forward

global type w_pln_master_plan_popup from w_popup_root
integer width = 4795
integer height = 2156
string title = "Item Master Popup"
cb_select cb_select
cb_retrieve cb_retrieve
ddlb_item_code ddlb_item_code
st_3 st_3
st_1 st_1
ddlb_mfs ddlb_mfs
st_5 st_5
ddlb_line_code ddlb_line_code
sle_model_name sle_model_name
st_6 st_6
st_4 st_4
uo_dateset uo_dateset
uo_dateend uo_dateend
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
ddlb_plan_status ddlb_plan_status
st_2 st_2
gb_2 gb_2
gb_1 gb_1
end type
global w_pln_master_plan_popup w_pln_master_plan_popup

on w_pln_master_plan_popup.create
int iCurrent
call super::create
this.cb_select=create cb_select
this.cb_retrieve=create cb_retrieve
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_1=create st_1
this.ddlb_mfs=create ddlb_mfs
this.st_5=create st_5
this.ddlb_line_code=create ddlb_line_code
this.sle_model_name=create sle_model_name
this.st_6=create st_6
this.st_4=create st_4
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.ddlb_plan_status=create ddlb_plan_status
this.st_2=create st_2
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.ddlb_item_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.ddlb_mfs
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.ddlb_line_code
this.Control[iCurrent+9]=this.sle_model_name
this.Control[iCurrent+10]=this.st_6
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.uo_dateset
this.Control[iCurrent+13]=this.uo_dateend
this.Control[iCurrent+14]=this.rb_2
this.Control[iCurrent+15]=this.rb_3
this.Control[iCurrent+16]=this.rb_4
this.Control[iCurrent+17]=this.rb_5
this.Control[iCurrent+18]=this.ddlb_plan_status
this.Control[iCurrent+19]=this.st_2
this.Control[iCurrent+20]=this.gb_2
this.Control[iCurrent+21]=this.gb_1
end on

on w_pln_master_plan_popup.destroy
call super::destroy
destroy(this.cb_select)
destroy(this.cb_retrieve)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.ddlb_mfs)
destroy(this.st_5)
destroy(this.ddlb_line_code)
destroy(this.sle_model_name)
destroy(this.st_6)
destroy(this.st_4)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.ddlb_plan_status)
destroy(this.st_2)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event open;call super::open;dw_1.settransobject(sqlca)
//
SLE_MODEL_NAME.TEXT = message.stringparm
//SLE_RUN_NO.TEXT = w_product_run_card.sle_run_no.text
CB_RETRIEVE.TRIGGEREVENT(CLICKED!)

end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_pln_master_plan_popup
integer width = 4782
integer height = 188
long backcolor = 16777215
end type

type cb_sort from w_popup_root`cb_sort within w_pln_master_plan_popup
integer x = 3666
integer y = 312
integer height = 128
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_pln_master_plan_popup
boolean visible = true
integer x = 4384
integer y = 312
integer width = 370
integer height = 164
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_pln_master_plan_popup
boolean visible = true
integer y = 580
integer width = 4782
end type

type dw_1 from w_popup_root`dw_1 within w_pln_master_plan_popup
boolean visible = true
integer y = 676
integer width = 4782
integer height = 1304
integer taborder = 70
boolean titlebar = true
string title = "Master Plan List"
string dataobject = "d_pln_master_plan_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

event dw_1::clicked;//OVERDIRDE
end event

type dw_2 from w_popup_root`dw_2 within w_pln_master_plan_popup
boolean visible = true
integer y = 676
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_pln_master_plan_popup
integer y = 676
end type

type cb_select from commandbutton within w_pln_master_plan_popup
integer x = 4018
integer y = 312
integer width = 370
integer height = 164
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

MESSAGE.STRINGPARM  = STRING(DW_1.OBJECT.MFS[DW_1.GETROW()])

Gst_return.Gvl_return[1] = DW_1.OBJECT.LOT_QTY[DW_1.GETROW()]
IF Gst_return.Gvl_return[1] = 0 or isnull(Gst_return.Gvl_return[1] ) then 
	return
end if 

gst_return.gvb_return = true
CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )


end event

type cb_retrieve from commandbutton within w_pln_master_plan_popup
integer x = 3653
integer y = 312
integer width = 370
integer height = 164
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;	dw_1.RETRIEVE(  uo_dateset.text() ,uo_dateend.text() ,  ddlb_item_code.text+'%' ,ddlb_line_code.getcode()+'%' , ddlb_mfs.text+'%' ,sle_model_name.text+'%' , ddlb_plan_status.getcode()+'%' , GVI_ORGANIZATION_ID )
end event

type ddlb_item_code from uo_item_code within w_pln_master_plan_popup
integer x = 873
integer y = 352
integer width = 594
integer taborder = 60
boolean bringtotop = true
end type

type st_3 from so_statictext within w_pln_master_plan_popup
integer x = 873
integer y = 284
integer width = 594
integer height = 56
boolean bringtotop = true
string text = "Item Code"
end type

type st_1 from so_statictext within w_pln_master_plan_popup
integer x = 1481
integer y = 284
integer width = 416
integer height = 56
boolean bringtotop = true
string text = "Line Code"
end type

type ddlb_mfs from uo_mfs_this_month within w_pln_master_plan_popup
integer x = 1920
integer y = 352
integer width = 494
integer height = 944
integer taborder = 70
boolean bringtotop = true
end type

type st_5 from so_statictext within w_pln_master_plan_popup
integer x = 1920
integer y = 284
integer width = 494
integer height = 56
boolean bringtotop = true
string text = "MFS"
end type

type ddlb_line_code from uo_line_code within w_pln_master_plan_popup
integer x = 1481
integer y = 352
integer width = 425
integer taborder = 70
boolean bringtotop = true
boolean hscrollbar = false
end type

type sle_model_name from singlelineedit within w_pln_master_plan_popup
event ue_editchange pbm_enchange
integer x = 2418
integer y = 352
integer width = 576
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_6 from statictext within w_pln_master_plan_popup
integer x = 2418
integer y = 284
integer width = 576
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Model Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from so_statictext within w_pln_master_plan_popup
integer x = 37
integer y = 272
integer width = 814
integer height = 68
boolean bringtotop = true
string text = "Plan Date"
end type

type uo_dateset from uo_ymd_calendar within w_pln_master_plan_popup
event destroy ( )
integer x = 37
integer y = 352
integer taborder = 70
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_pln_master_plan_popup
event destroy ( )
integer x = 448
integer y = 352
integer taborder = 80
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type rb_2 from so_radiobutton within w_pln_master_plan_popup
integer x = 50
integer y = 460
integer width = 334
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Today"
end type

event clicked;call super::clicked;uo_dateend.settext( string(f_t_sysdate()) )
end event

type rb_3 from so_radiobutton within w_pln_master_plan_popup
integer x = 334
integer y = 460
integer width = 315
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "1 Week"
end type

event clicked;call super::clicked;uo_dateend.settext( string(f_v_sysdate(-7)) )
end event

type rb_4 from so_radiobutton within w_pln_master_plan_popup
integer x = 654
integer y = 460
integer width = 315
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "2 Week"
end type

event clicked;call super::clicked;uo_dateend.settext( string(f_v_sysdate(-14)) )
end event

type rb_5 from so_radiobutton within w_pln_master_plan_popup
integer x = 969
integer y = 460
integer width = 315
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "4 Week"
end type

event clicked;call super::clicked;uo_dateend.settext( string(f_v_sysdate(-28)) )
end event

type ddlb_plan_status from uo_basecode within w_pln_master_plan_popup
integer x = 3003
integer y = 352
integer width = 558
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;this.redraw( 'PLAN STATUS')
this.selectitemno(6)

end event

type st_2 from statictext within w_pln_master_plan_popup
integer x = 3008
integer y = 288
integer width = 544
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Plan Status"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_2 from so_groupbox within w_pln_master_plan_popup
integer x = 3639
integer y = 192
integer width = 1134
integer height = 364
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_1 from so_groupbox within w_pln_master_plan_popup
integer y = 196
integer width = 3639
integer height = 360
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


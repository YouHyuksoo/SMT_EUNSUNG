HA$PBExportHeader$w_des_model_master_popup.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_des_model_master_popup from w_popup_root
end type
type cb_select from commandbutton within w_des_model_master_popup
end type
type cb_retrieve from commandbutton within w_des_model_master_popup
end type
type st_2 from statictext within w_des_model_master_popup
end type
type sle_item_code from singlelineedit within w_des_model_master_popup
end type
type ddlb_model_name from uo_model_name_ddlb within w_des_model_master_popup
end type
type st_9 from so_statictext within w_des_model_master_popup
end type
type st_1 from statictext within w_des_model_master_popup
end type
type uo_dateend from uo_ymd_calendar within w_des_model_master_popup
end type
type gb_1 from so_groupbox within w_des_model_master_popup
end type
type gb_2 from so_groupbox within w_des_model_master_popup
end type
end forward

global type w_des_model_master_popup from w_popup_root
integer width = 4302
integer height = 2156
string title = "Model Master Popup"
cb_select cb_select
cb_retrieve cb_retrieve
st_2 st_2
sle_item_code sle_item_code
ddlb_model_name ddlb_model_name
st_9 st_9
st_1 st_1
uo_dateend uo_dateend
gb_1 gb_1
gb_2 gb_2
end type
global w_des_model_master_popup w_des_model_master_popup

on w_des_model_master_popup.create
int iCurrent
call super::create
this.cb_select=create cb_select
this.cb_retrieve=create cb_retrieve
this.st_2=create st_2
this.sle_item_code=create sle_item_code
this.ddlb_model_name=create ddlb_model_name
this.st_9=create st_9
this.st_1=create st_1
this.uo_dateend=create uo_dateend
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_item_code
this.Control[iCurrent+5]=this.ddlb_model_name
this.Control[iCurrent+6]=this.st_9
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.uo_dateend
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
end on

on w_des_model_master_popup.destroy
call super::destroy
destroy(this.cb_select)
destroy(this.cb_retrieve)
destroy(this.st_2)
destroy(this.sle_item_code)
destroy(this.ddlb_model_name)
destroy(this.st_9)
destroy(this.st_1)
destroy(this.uo_dateend)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)



end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

event ue_post_open;call super::ue_post_open;CB_RETRIEVE.TRIGGEREVENT(CLICKED!)
SLE_ITEM_CODE.SETFOCUS()
end event

type p_title from w_popup_root`p_title within w_des_model_master_popup
integer width = 4311
end type

type cb_sort from w_popup_root`cb_sort within w_des_model_master_popup
boolean visible = true
integer x = 3026
integer y = 272
integer width = 279
integer height = 144
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_des_model_master_popup
boolean visible = true
integer x = 3968
integer y = 272
integer width = 279
integer height = 144
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_des_model_master_popup
boolean visible = true
integer y = 484
integer width = 4315
end type

type dw_1 from w_popup_root`dw_1 within w_des_model_master_popup
boolean visible = true
integer y = 576
integer width = 4306
integer height = 1304
integer taborder = 70
boolean titlebar = true
string title = "Model Master List"
string dataobject = "d_des_model_master_popup"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
CB_SELECT.TRIGGEREVENT(CLICKED!)
end event

type dw_2 from w_popup_root`dw_2 within w_des_model_master_popup
boolean visible = true
integer y = 772
integer taborder = 0
end type

type dw_3 from w_popup_root`dw_3 within w_des_model_master_popup
integer y = 784
end type

type cb_select from commandbutton within w_des_model_master_popup
integer x = 3584
integer y = 272
integer width = 279
integer height = 144
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

MESSAGE.STRINGPARM= DW_1.GETITEMSTRING( DW_1.GETROW() , 'model_name')
Gst_return.Gvs_return[1] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'smt_model_name')
Gst_return.Gvs_return[2] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'master_model_name')

//------------------------------------------------------------------------------------------------
// 2016/10/27 SHS, $$HEX17$$ddc0b0c0c4ac8dd6200091c731c144c7200004c774d520008dc131c1200094cd00ac$$ENDHEX$$
//------------------------------------------------------------------------------------------------
Gst_return.Gvs_return[3] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'model_suffix')
Gst_return.Gvs_return[4] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'item_code')
Gst_return.Gvs_return[5] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'part_no')
Gst_return.Gvs_return[6] = DW_1.GETITEMSTRING( DW_1.GETROW() , 'customer_code')

CLOSEWITHRETURN(PARENT , MESSAGE.STRINGPARM )
end event

type cb_retrieve from commandbutton within w_des_model_master_popup
integer x = 3305
integer y = 272
integer width = 279
integer height = 144
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE(   ddlb_model_name.GETCODE()+'%' , SLE_ITEM_CODE.TEXT+'%' , GVI_ORGANIZATION_ID, uo_dateend.text()  )
end event

type st_2 from statictext within w_des_model_master_popup
integer x = 731
integer y = 280
integer width = 585
integer height = 52
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
string text = "Item Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_item_code from singlelineedit within w_des_model_master_popup
event ue_editchange pbm_enchange
integer x = 731
integer y = 344
integer width = 585
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
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_editchange;STRING LVS_item_name
DW_1.SETFILTER('')
DW_1.FILTER()

IF THIS.TEXT = '' THEN 
	
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()	
	RETURN 
ELSE
	LVS_item_name = '%'+this.text+'%'
END IF

DW_1.SETFILTER("item_code LIKE '"+LVS_item_name+"'")
DW_1.FILTER()

end event

type ddlb_model_name from uo_model_name_ddlb within w_des_model_master_popup
integer x = 82
integer y = 344
integer width = 635
integer taborder = 60
boolean bringtotop = true
end type

type st_9 from so_statictext within w_des_model_master_popup
integer x = 78
integer y = 280
integer width = 645
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Model Name"
end type

type st_1 from statictext within w_des_model_master_popup
integer x = 1303
integer y = 280
integer width = 585
integer height = 52
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
string text = "Model DateEnd"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_dateend from uo_ymd_calendar within w_des_model_master_popup
event destroy ( )
integer x = 1399
integer y = 344
integer height = 88
integer taborder = 40
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type gb_1 from so_groupbox within w_des_model_master_popup
integer y = 196
integer width = 1906
integer height = 284
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_des_model_master_popup
integer x = 2949
integer y = 188
integer width = 1335
integer height = 276
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


HA$PBExportHeader$w_sal_shipping_lot_master_popup.srw
$PBExportComments$(Item Query)-$$HEX4$$80bd88d470c88cd6$$ENDHEX$$
forward
global type w_sal_shipping_lot_master_popup from w_popup_root
end type
type cb_select from commandbutton within w_sal_shipping_lot_master_popup
end type
type cb_retrieve from commandbutton within w_sal_shipping_lot_master_popup
end type
type sle_lot_no from so_singlelineedit within w_sal_shipping_lot_master_popup
end type
type st_2 from so_statictext within w_sal_shipping_lot_master_popup
end type
type gb_1 from so_groupbox within w_sal_shipping_lot_master_popup
end type
type gb_2 from so_groupbox within w_sal_shipping_lot_master_popup
end type
end forward

global type w_sal_shipping_lot_master_popup from w_popup_root
integer width = 3438
integer height = 2088
string title = "Shipping Lot Master Popup"
string ivs_resize_type = "DEFAULT"
cb_select cb_select
cb_retrieve cb_retrieve
sle_lot_no sle_lot_no
st_2 st_2
gb_1 gb_1
gb_2 gb_2
end type
global w_sal_shipping_lot_master_popup w_sal_shipping_lot_master_popup

on w_sal_shipping_lot_master_popup.create
int iCurrent
call super::create
this.cb_select=create cb_select
this.cb_retrieve=create cb_retrieve
this.sle_lot_no=create sle_lot_no
this.st_2=create st_2
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.sle_lot_no
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.gb_2
end on

on w_sal_shipping_lot_master_popup.destroy
call super::destroy
destroy(this.cb_select)
destroy(this.cb_retrieve)
destroy(this.sle_lot_no)
destroy(this.st_2)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;IVS_RESIZE_TYPE = 'DEFAULT' 
dw_1.settransobject(sqlca)

sle_lot_no.text = message.stringparm 

CB_RETRIEVE.TRIGGEREVENT(CLICKED!)


end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

event resize;//
end event

event ue_post_open;call super::ue_post_open;IVS_RESIZE_TYPE = 'DEFAULT' 
end event

event activate;call super::activate;IVS_RESIZE_TYPE = 'DEFAULT' 
end event

type p_title from w_popup_root`p_title within w_sal_shipping_lot_master_popup
integer width = 3419
integer height = 188
long backcolor = 16777215
end type

type cb_sort from w_popup_root`cb_sort within w_sal_shipping_lot_master_popup
integer x = 722
integer y = 252
integer width = 329
integer height = 156
integer taborder = 0
end type

type cb_close from w_popup_root`cb_close within w_sal_shipping_lot_master_popup
boolean visible = true
integer x = 3054
integer y = 272
integer width = 329
integer height = 156
integer taborder = 0
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_sal_shipping_lot_master_popup
boolean visible = true
integer y = 484
integer width = 3429
end type

type dw_1 from w_popup_root`dw_1 within w_sal_shipping_lot_master_popup
boolean visible = true
integer y = 576
integer width = 3429
integer height = 720
integer taborder = 70
boolean titlebar = true
string title = "Master"
string dataobject = "d_sal_shipping_lot_master_popup"
boolean border = false
end type

type dw_2 from w_popup_root`dw_2 within w_sal_shipping_lot_master_popup
boolean visible = true
integer y = 1304
integer width = 3419
integer height = 700
integer taborder = 0
boolean titlebar = true
string title = "Detail"
string dataobject = "d_sal_shipping_lot_detial_popup"
boolean border = false
end type

type dw_3 from w_popup_root`dw_3 within w_sal_shipping_lot_master_popup
integer y = 864
end type

type cb_select from commandbutton within w_sal_shipping_lot_master_popup
boolean visible = false
integer x = 2354
integer y = 264
integer width = 329
integer height = 156
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Process"
boolean default = true
end type

type cb_retrieve from commandbutton within w_sal_shipping_lot_master_popup
integer x = 2720
integer y = 272
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

event clicked;DW_1.RETRIEVE(sle_lot_no.text + '%' ,  GVI_ORGANIZATION_ID )
DW_2.RETRIEVE(sle_lot_no.text ,  GVI_ORGANIZATION_ID )


end event

type sle_lot_no from so_singlelineedit within w_sal_shipping_lot_master_popup
integer x = 69
integer y = 356
integer width = 521
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer weight = 700
long backcolor = 16777215
textcase textcase = upper!
end type

type st_2 from so_statictext within w_sal_shipping_lot_master_popup
integer x = 69
integer y = 272
integer width = 521
boolean bringtotop = true
string text = "Lot No"
end type

type gb_1 from so_groupbox within w_sal_shipping_lot_master_popup
integer x = 27
integer y = 196
integer width = 622
integer height = 276
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_2 from so_groupbox within w_sal_shipping_lot_master_popup
integer x = 2697
integer y = 196
integer width = 722
integer height = 276
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


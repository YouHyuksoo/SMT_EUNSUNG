HA$PBExportHeader$w_mat_free_subcontract_invoice_no_popup.srw
forward
global type w_mat_free_subcontract_invoice_no_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_mat_free_subcontract_invoice_no_popup
end type
type cb_select from so_commandbutton within w_mat_free_subcontract_invoice_no_popup
end type
type sle_supplier_name from so_singlelineedit within w_mat_free_subcontract_invoice_no_popup
end type
type st_14 from so_statictext within w_mat_free_subcontract_invoice_no_popup
end type
type sle_item_code from singlelineedit within w_mat_free_subcontract_invoice_no_popup
end type
type st_3 from statictext within w_mat_free_subcontract_invoice_no_popup
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_free_subcontract_invoice_no_popup
end type
type st_4 from statictext within w_mat_free_subcontract_invoice_no_popup
end type
type uo_dateset from uo_ymd_calendar within w_mat_free_subcontract_invoice_no_popup
end type
type uo_dateend from uo_ymd_calendar within w_mat_free_subcontract_invoice_no_popup
end type
type st_2 from so_statictext within w_mat_free_subcontract_invoice_no_popup
end type
type gb_2 from so_groupbox within w_mat_free_subcontract_invoice_no_popup
end type
type gb_3 from so_groupbox within w_mat_free_subcontract_invoice_no_popup
end type
end forward

global type w_mat_free_subcontract_invoice_no_popup from w_popup_root
integer width = 3643
integer height = 2232
string title = "Material Item Popup"
cb_retrieve cb_retrieve
cb_select cb_select
sle_supplier_name sle_supplier_name
st_14 st_14
sle_item_code sle_item_code
st_3 st_3
ddlb_supplier_code ddlb_supplier_code
st_4 st_4
uo_dateset uo_dateset
uo_dateend uo_dateend
st_2 st_2
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_free_subcontract_invoice_no_popup w_mat_free_subcontract_invoice_no_popup

on w_mat_free_subcontract_invoice_no_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.sle_supplier_name=create sle_supplier_name
this.st_14=create st_14
this.sle_item_code=create sle_item_code
this.st_3=create st_3
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_4=create st_4
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_2=create st_2
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.sle_supplier_name
this.Control[iCurrent+4]=this.st_14
this.Control[iCurrent+5]=this.sle_item_code
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.ddlb_supplier_code
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.uo_dateset
this.Control[iCurrent+10]=this.uo_dateend
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_3
end on

on w_mat_free_subcontract_invoice_no_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.sle_supplier_name)
destroy(this.st_14)
destroy(this.sle_item_code)
destroy(this.st_3)
destroy(this.ddlb_supplier_code)
destroy(this.st_4)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_2)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)


end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

event ue_post_open;call super::ue_post_open;if isnull(message.stringparm) then
	ddlb_supplier_code.text = '%'
else
	ddlb_supplier_code.text = message.stringparm
end if 
cb_retrieve.triggerevent(CLICKED!)
end event

type p_title from w_popup_root`p_title within w_mat_free_subcontract_invoice_no_popup
integer width = 3625
end type

type cb_sort from w_popup_root`cb_sort within w_mat_free_subcontract_invoice_no_popup
boolean visible = true
integer x = 2487
integer y = 356
end type

type cb_close from w_popup_root`cb_close within w_mat_free_subcontract_invoice_no_popup
boolean visible = true
integer x = 3323
integer y = 356
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_mat_free_subcontract_invoice_no_popup
boolean visible = true
integer x = 5
integer y = 556
integer width = 3625
end type

type dw_1 from w_popup_root`dw_1 within w_mat_free_subcontract_invoice_no_popup
boolean visible = true
integer y = 660
integer width = 3625
integer height = 1504
boolean titlebar = true
string title = "Material Item Free Inventory List"
string dataobject = "d_mat_free_receipt_subcont_invoice_no_lst"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_mat_free_subcontract_invoice_no_popup
integer y = 660
end type

type dw_3 from w_popup_root`dw_3 within w_mat_free_subcontract_invoice_no_popup
integer y = 736
end type

type cb_retrieve from so_commandbutton within w_mat_free_subcontract_invoice_no_popup
integer x = 2766
integer y = 356
integer width = 274
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE( uo_dateset.text() , uo_dateend.text(), ddlb_supplier_code.text+'%' , sle_item_code.text + '%'  , GVI_ORGANIZATION_ID )
end event

type cb_select from so_commandbutton within w_mat_free_subcontract_invoice_no_popup
integer x = 3045
integer y = 356
integer width = 274
integer height = 100
integer taborder = 80
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;if dw_1.getrow() < 1 then 
	gst_return.gvb_return = false
	return -1 
end if 

gst_return.gvb_return = true 
message.stringparm = dw_1.object.invoice_no[dw_1.getrow()]
closewithreturn(parent , message.stringparm)



end event

type sle_supplier_name from so_singlelineedit within w_mat_free_subcontract_invoice_no_popup
integer x = 1929
integer y = 408
integer width = 421
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 700
string pointer = "HyperLink!"
textcase textcase = upper!
end type

event getfocus;this.selecttext( 1 , len( this.text) )
this.Borderstyle = styleraised!
end event

event losefocus;this.Borderstyle = styleLowered!
end event

event ue_editchange;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN = "ITEM_NAME"

IF ISNULL(LVS_COLUMN) OR LEN(LVS_COLUMN) = 0 THEN RETURN 

IVD_SELECTED_DATA_WINDOW.SETFILTER('')
IVD_SELECTED_DATA_WINDOW.FILTER()

IF THIS.TEXT = '' THEN 
	IVD_SELECTED_DATA_WINDOW.SETFILTER('')
	IVD_SELECTED_DATA_WINDOW.FILTER()
	RETURN
ELSE
	LVS_VALUE =  UPPER( '%'+this.text+'%' )
END IF

IVD_SELECTED_DATA_WINDOW.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
IVD_SELECTED_DATA_WINDOW.FILTER()

end event

type st_14 from so_statictext within w_mat_free_subcontract_invoice_no_popup
integer x = 1929
integer y = 336
integer width = 421
integer height = 52
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Item Name"
end type

type sle_item_code from singlelineedit within w_mat_free_subcontract_invoice_no_popup
event ue_editchange pbm_enchange
integer x = 1367
integer y = 408
integer width = 558
integer height = 84
integer taborder = 50
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

type st_3 from statictext within w_mat_free_subcontract_invoice_no_popup
integer x = 1367
integer y = 336
integer width = 558
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

type ddlb_supplier_code from uo_supplier_code within w_mat_free_subcontract_invoice_no_popup
integer x = 846
integer y = 408
integer width = 521
integer taborder = 20
boolean bringtotop = true
string text = "%"
end type

type st_4 from statictext within w_mat_free_subcontract_invoice_no_popup
integer x = 846
integer y = 332
integer width = 521
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
string text = "Supplier Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_dateset from uo_ymd_calendar within w_mat_free_subcontract_invoice_no_popup
event destroy ( )
integer x = 18
integer y = 408
integer taborder = 40
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_free_subcontract_invoice_no_popup
event destroy ( )
integer x = 434
integer y = 408
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_2 from so_statictext within w_mat_free_subcontract_invoice_no_popup
integer x = 23
integer y = 336
integer width = 814
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Issue Date"
end type

type gb_2 from so_groupbox within w_mat_free_subcontract_invoice_no_popup
integer y = 216
integer width = 2459
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_free_subcontract_invoice_no_popup
integer x = 2464
integer y = 216
integer width = 1152
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


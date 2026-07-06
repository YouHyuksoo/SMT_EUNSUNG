HA$PBExportHeader$w_mat_item_receipt_popup.srw
$PBExportComments$$$HEX8$$6cade4b9e8b200ac20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_mat_item_receipt_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_mat_item_receipt_popup
end type
type cb_select from so_commandbutton within w_mat_item_receipt_popup
end type
type st_3 from so_statictext within w_mat_item_receipt_popup
end type
type ddlb_item_code from uo_item_code within w_mat_item_receipt_popup
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_item_receipt_popup
end type
type st_1 from so_statictext within w_mat_item_receipt_popup
end type
type uo_dateset from uo_ymd_calendar within w_mat_item_receipt_popup
end type
type uo_dateend from uo_ymd_calendar within w_mat_item_receipt_popup
end type
type st_4 from so_statictext within w_mat_item_receipt_popup
end type
type ddlb_location_code_cond from uo_basecode within w_mat_item_receipt_popup
end type
type st_5 from so_statictext within w_mat_item_receipt_popup
end type
type sle_invoice_no from so_singlelineedit within w_mat_item_receipt_popup
end type
type st_invoice_no from so_statictext within w_mat_item_receipt_popup
end type
type gb_2 from so_groupbox within w_mat_item_receipt_popup
end type
type gb_3 from so_groupbox within w_mat_item_receipt_popup
end type
end forward

global type w_mat_item_receipt_popup from w_popup_root
integer width = 4197
integer height = 2232
string title = "Material Item Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_3 st_3
ddlb_item_code ddlb_item_code
ddlb_supplier_code ddlb_supplier_code
st_1 st_1
uo_dateset uo_dateset
uo_dateend uo_dateend
st_4 st_4
ddlb_location_code_cond ddlb_location_code_cond
st_5 st_5
sle_invoice_no sle_invoice_no
st_invoice_no st_invoice_no
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_item_receipt_popup w_mat_item_receipt_popup

on w_mat_item_receipt_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_3=create st_3
this.ddlb_item_code=create ddlb_item_code
this.ddlb_supplier_code=create ddlb_supplier_code
this.st_1=create st_1
this.uo_dateset=create uo_dateset
this.uo_dateend=create uo_dateend
this.st_4=create st_4
this.ddlb_location_code_cond=create ddlb_location_code_cond
this.st_5=create st_5
this.sle_invoice_no=create sle_invoice_no
this.st_invoice_no=create st_invoice_no
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.ddlb_item_code
this.Control[iCurrent+5]=this.ddlb_supplier_code
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.uo_dateset
this.Control[iCurrent+8]=this.uo_dateend
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.ddlb_location_code_cond
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.sle_invoice_no
this.Control[iCurrent+13]=this.st_invoice_no
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.gb_3
end on

on w_mat_item_receipt_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_3)
destroy(this.ddlb_item_code)
destroy(this.ddlb_supplier_code)
destroy(this.st_1)
destroy(this.uo_dateset)
destroy(this.uo_dateend)
destroy(this.st_4)
destroy(this.ddlb_location_code_cond)
destroy(this.st_5)
destroy(this.sle_invoice_no)
destroy(this.st_invoice_no)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)
//ddlb_item_code.text = message.stringparm
cb_retrieve.triggerevent(CLICKED!)

end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_mat_item_receipt_popup
integer width = 4174
end type

type cb_sort from w_popup_root`cb_sort within w_mat_item_receipt_popup
integer x = 2999
integer y = 340
integer height = 144
end type

type cb_close from w_popup_root`cb_close within w_mat_item_receipt_popup
boolean visible = true
integer x = 3799
integer y = 332
integer width = 352
integer height = 144
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_mat_item_receipt_popup
boolean visible = true
integer x = 5
integer y = 556
integer width = 4174
end type

type dw_1 from w_popup_root`dw_1 within w_mat_item_receipt_popup
boolean visible = true
integer y = 648
integer width = 4174
integer height = 1504
boolean titlebar = true
string title = "Material Item Receipt List"
string dataobject = "d_mat_receipt_hst1"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_mat_item_receipt_popup
integer y = 660
end type

type dw_3 from w_popup_root`dw_3 within w_mat_item_receipt_popup
integer y = 736
end type

type cb_retrieve from so_commandbutton within w_mat_item_receipt_popup
integer x = 3067
integer y = 332
integer width = 352
integer height = 144
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;dw_1.retrieve(ddlb_item_code.text() + '%', ddlb_supplier_code.text +'%' , uo_dateset.text() , uo_dateend.text() ,ddlb_location_code_cond.getcode()+'%' , '%'+sle_invoice_no.text+ '%'  , gvi_organization_id)
end event

type cb_select from so_commandbutton within w_mat_item_receipt_popup
integer x = 3433
integer y = 332
integer width = 352
integer height = 144
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
message.stringparm = dw_1.object.item_code[dw_1.getrow()]
gst_return.gvs_return[1] =  dw_1.object.material_mfs[dw_1.getrow()]
gst_return.gvs_return[2] = dw_1.object.item_name[dw_1.getrow()]
gst_return.gvs_return[3] = dw_1.object.item_spec[dw_1.getrow()]
gst_return.gvs_return[4] = dw_1.object.supplier_code[dw_1.getrow()]
gst_return.gvs_return[5] = dw_1.object.line_type[dw_1.getrow()]
gst_return.gvs_return[6] = dw_1.object.item_type[dw_1.getrow()]
gst_return.gvs_return[7] = dw_1.object.invoice_no[dw_1.getrow()]
gst_return.gvs_return[8] = dw_1.object.receipt_lot_no[dw_1.getrow()]
gst_return.gvs_return[9] = dw_1.object.location_code[dw_1.getrow()]
gst_return.gvl_return[1] = dw_1.object.receipt_qty[dw_1.getrow()]

closewithreturn(parent , message.stringparm)



end event

type st_3 from so_statictext within w_mat_item_receipt_popup
integer x = 878
integer y = 312
integer width = 517
boolean bringtotop = true
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_item_receipt_popup
integer x = 878
integer y = 392
integer width = 517
integer taborder = 30
boolean bringtotop = true
end type

type ddlb_supplier_code from uo_supplier_code within w_mat_item_receipt_popup
integer x = 1399
integer y = 392
integer width = 439
integer taborder = 40
boolean bringtotop = true
end type

type st_1 from so_statictext within w_mat_item_receipt_popup
integer x = 1399
integer y = 312
integer width = 439
boolean bringtotop = true
string text = "Supplier Code"
end type

type uo_dateset from uo_ymd_calendar within w_mat_item_receipt_popup
event destroy ( )
integer x = 37
integer y = 392
integer taborder = 50
boolean bringtotop = true
end type

on uo_dateset.destroy
call uo_ymd_calendar::destroy
end on

type uo_dateend from uo_ymd_calendar within w_mat_item_receipt_popup
event destroy ( )
integer x = 453
integer y = 392
integer taborder = 60
boolean bringtotop = true
end type

on uo_dateend.destroy
call uo_ymd_calendar::destroy
end on

type st_4 from so_statictext within w_mat_item_receipt_popup
integer x = 41
integer y = 312
integer width = 814
boolean bringtotop = true
string text = "Date"
end type

type ddlb_location_code_cond from uo_basecode within w_mat_item_receipt_popup
integer x = 1847
integer y = 392
integer width = 507
integer taborder = 70
boolean bringtotop = true
boolean allowedit = false
end type

event constructor;call super::constructor;this.redraw( 'MATERIAL LOCATION CODE')
end event

type st_5 from so_statictext within w_mat_item_receipt_popup
integer x = 1847
integer y = 324
integer width = 507
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 0
string text = "Location Code"
end type

type sle_invoice_no from so_singlelineedit within w_mat_item_receipt_popup
integer x = 2359
integer y = 392
integer width = 635
integer height = 84
integer taborder = 110
boolean bringtotop = true
integer weight = 700
string pointer = "h_beam.cur"
textcase textcase = upper!
end type

event modified;call super::modified;//=====================================
//LVS_COLUMN $$HEX7$$15c82cb860d52000eccefcb712ac$$ENDHEX$$
//=====================================
STRING LVS_VALUE , LVS_COLUMN

DW_3.SETFILTER('')
DW_3.FILTER()

LVS_COLUMN = 'RECEIPT_LOT_NO'
IF ISNULL(LVS_COLUMN) OR LENA(LVS_COLUMN) = 0 THEN 
	RETURN 
END IF

IF THIS.TEXT = '' OR ISNULL(THIS.TEXT) THEN 
    DW_3.SETFILTER('')
    DW_3.FILTER()	
    RETURN
ELSE
	LVS_VALUE = '%'+this.text+'%'
END IF

DW_3.SETFILTER( LVS_COLUMN  +" LIKE '"+LVS_VALUE+"'")
DW_3.FILTER()
F_MSG_MDI_HELP( STRING( DW_3.ROWCOUNT() ) + " Found" )
end event

type st_invoice_no from so_statictext within w_mat_item_receipt_popup
integer x = 2359
integer y = 308
integer width = 635
integer height = 56
boolean bringtotop = true
integer weight = 700
long textcolor = 16711680
string text = "Invoice No"
end type

type gb_2 from so_groupbox within w_mat_item_receipt_popup
integer x = 5
integer y = 216
integer width = 3008
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_item_receipt_popup
integer x = 3026
integer y = 216
integer width = 1152
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


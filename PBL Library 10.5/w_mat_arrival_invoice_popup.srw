HA$PBExportHeader$w_mat_arrival_invoice_popup.srw
$PBExportComments$Popup Templet Window
forward
global type w_mat_arrival_invoice_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_mat_arrival_invoice_popup
end type
type cb_select from so_commandbutton within w_mat_arrival_invoice_popup
end type
type st_goods_code from so_statictext within w_mat_arrival_invoice_popup
end type
type st_3 from so_statictext within w_mat_arrival_invoice_popup
end type
type st_1 from so_statictext within w_mat_arrival_invoice_popup
end type
type ddlb_supplier_code from uo_supplier_code within w_mat_arrival_invoice_popup
end type
type uo_date from uo_ymd_calendar within w_mat_arrival_invoice_popup
end type
type sle_invoice_no from so_singlelineedit within w_mat_arrival_invoice_popup
end type
type cb_setup from so_commandbutton within w_mat_arrival_invoice_popup
end type
type gb_1 from so_groupbox within w_mat_arrival_invoice_popup
end type
type gb_2 from so_groupbox within w_mat_arrival_invoice_popup
end type
end forward

global type w_mat_arrival_invoice_popup from w_popup_root
integer width = 3259
integer height = 2412
string title = "Goods Master Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_goods_code st_goods_code
st_3 st_3
st_1 st_1
ddlb_supplier_code ddlb_supplier_code
uo_date uo_date
sle_invoice_no sle_invoice_no
cb_setup cb_setup
gb_1 gb_1
gb_2 gb_2
end type
global w_mat_arrival_invoice_popup w_mat_arrival_invoice_popup

on w_mat_arrival_invoice_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_goods_code=create st_goods_code
this.st_3=create st_3
this.st_1=create st_1
this.ddlb_supplier_code=create ddlb_supplier_code
this.uo_date=create uo_date
this.sle_invoice_no=create sle_invoice_no
this.cb_setup=create cb_setup
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_goods_code
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.ddlb_supplier_code
this.Control[iCurrent+7]=this.uo_date
this.Control[iCurrent+8]=this.sle_invoice_no
this.Control[iCurrent+9]=this.cb_setup
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_2
end on

on w_mat_arrival_invoice_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_goods_code)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.ddlb_supplier_code)
destroy(this.uo_date)
destroy(this.sle_invoice_no)
destroy(this.cb_setup)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;
dw_1.settransobject(sqlca)
ddlb_supplier_code.text = gst_return.gvs_return[1]
sle_invoice_no.text = gst_return.gvs_return[2]
uo_date.text = gst_return.gvs_return[3]

 cb_retrieve.triggerevent(clicked!)

end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

event ue_post_open;call super::ue_post_open;uo_date.settext(gst_return.gvs_return[3])
end event

type p_title from w_popup_root`p_title within w_mat_arrival_invoice_popup
integer width = 3237
end type

type cb_sort from w_popup_root`cb_sort within w_mat_arrival_invoice_popup
boolean visible = true
integer x = 1829
integer y = 320
end type

type cb_close from w_popup_root`cb_close within w_mat_arrival_invoice_popup
boolean visible = true
integer x = 2912
integer y = 320
end type

type st_msg from w_popup_root`st_msg within w_mat_arrival_invoice_popup
boolean visible = true
integer x = 5
integer y = 520
integer width = 3237
end type

type dw_1 from w_popup_root`dw_1 within w_mat_arrival_invoice_popup
boolean visible = true
integer y = 620
integer width = 3237
integer height = 1696
string dataobject = "d_mat_arrival_rpt"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_mat_arrival_invoice_popup
boolean visible = true
integer y = 760
end type

type dw_3 from w_popup_root`dw_3 within w_mat_arrival_invoice_popup
integer y = 632
end type

type cb_retrieve from so_commandbutton within w_mat_arrival_invoice_popup
integer x = 2098
integer y = 320
integer width = 274
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;//DW_1.RETRIEVE(  ddlb_supplier_code.text + '%' ,sle_invoice_no.text + '%' ,GVI_ORGANIZATION_ID )
DW_1.RETRIEVE( sle_invoice_no.text + '%' ,GVI_ORGANIZATION_ID )

end event

type cb_select from so_commandbutton within w_mat_arrival_invoice_popup
integer x = 2638
integer y = 320
integer width = 274
integer height = 100
integer taborder = 80
boolean bringtotop = true
string text = "Print"
boolean default = true
end type

event clicked;dw_1.print()




end event

type st_goods_code from so_statictext within w_mat_arrival_invoice_popup
integer x = 663
integer y = 312
integer width = 530
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Invoice No"
end type

type st_3 from so_statictext within w_mat_arrival_invoice_popup
integer x = 59
integer y = 312
integer width = 599
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Supplier Code"
end type

type st_1 from so_statictext within w_mat_arrival_invoice_popup
integer x = 1202
integer y = 312
integer width = 407
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Date"
end type

type ddlb_supplier_code from uo_supplier_code within w_mat_arrival_invoice_popup
integer x = 64
integer y = 384
integer width = 599
integer taborder = 20
boolean bringtotop = true
end type

type uo_date from uo_ymd_calendar within w_mat_arrival_invoice_popup
integer x = 1207
integer y = 384
integer taborder = 30
boolean bringtotop = true
end type

on uo_date.destroy
call uo_ymd_calendar::destroy
end on

type sle_invoice_no from so_singlelineedit within w_mat_arrival_invoice_popup
integer x = 667
integer y = 384
integer width = 530
integer height = 84
integer taborder = 40
boolean bringtotop = true
end type

type cb_setup from so_commandbutton within w_mat_arrival_invoice_popup
integer x = 2368
integer y = 320
integer width = 274
integer height = 100
integer taborder = 80
boolean bringtotop = true
string text = "Setup"
end type

event clicked;call super::clicked;printsetup()

end event

type gb_1 from so_groupbox within w_mat_arrival_invoice_popup
integer x = 1737
integer y = 200
integer width = 1490
integer height = 312
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_mat_arrival_invoice_popup
integer x = 5
integer y = 200
integer width = 1691
integer height = 312
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


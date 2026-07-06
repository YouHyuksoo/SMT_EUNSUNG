HA$PBExportHeader$w_plan_master_popup.srw
$PBExportComments$$$HEX10$$f9b2d4c6c4ac8dd61cc888bc20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_plan_master_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_plan_master_popup
end type
type cb_select from so_commandbutton within w_plan_master_popup
end type
type st_yyyymm from so_statictext within w_plan_master_popup
end type
type em_yyyymm from uo_ym within w_plan_master_popup
end type
type ddlb_item_code from uo_item_code within w_plan_master_popup
end type
type st_3 from so_statictext within w_plan_master_popup
end type
type st_1 from so_statictext within w_plan_master_popup
end type
type ddlb_mfs from uo_mfs_this_month within w_plan_master_popup
end type
type st_5 from so_statictext within w_plan_master_popup
end type
type rb_master_plan from so_radiobutton within w_plan_master_popup
end type
type rb_assembly_plan from so_radiobutton within w_plan_master_popup
end type
type ddlb_line_code from uo_line_code within w_plan_master_popup
end type
type sle_customer_order_no from so_singlelineedit within w_plan_master_popup
end type
type st_2 from so_statictext within w_plan_master_popup
end type
type gb_1 from so_groupbox within w_plan_master_popup
end type
type gb_2 from so_groupbox within w_plan_master_popup
end type
type gb_3 from so_groupbox within w_plan_master_popup
end type
end forward

global type w_plan_master_popup from w_popup_root
integer width = 3653
integer height = 2048
string title = "Plan Master Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_yyyymm st_yyyymm
em_yyyymm em_yyyymm
ddlb_item_code ddlb_item_code
st_3 st_3
st_1 st_1
ddlb_mfs ddlb_mfs
st_5 st_5
rb_master_plan rb_master_plan
rb_assembly_plan rb_assembly_plan
ddlb_line_code ddlb_line_code
sle_customer_order_no sle_customer_order_no
st_2 st_2
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_plan_master_popup w_plan_master_popup

type variables

end variables

on w_plan_master_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_yyyymm=create st_yyyymm
this.em_yyyymm=create em_yyyymm
this.ddlb_item_code=create ddlb_item_code
this.st_3=create st_3
this.st_1=create st_1
this.ddlb_mfs=create ddlb_mfs
this.st_5=create st_5
this.rb_master_plan=create rb_master_plan
this.rb_assembly_plan=create rb_assembly_plan
this.ddlb_line_code=create ddlb_line_code
this.sle_customer_order_no=create sle_customer_order_no
this.st_2=create st_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_yyyymm
this.Control[iCurrent+4]=this.em_yyyymm
this.Control[iCurrent+5]=this.ddlb_item_code
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.ddlb_mfs
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.rb_master_plan
this.Control[iCurrent+11]=this.rb_assembly_plan
this.Control[iCurrent+12]=this.ddlb_line_code
this.Control[iCurrent+13]=this.sle_customer_order_no
this.Control[iCurrent+14]=this.st_2
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_2
this.Control[iCurrent+17]=this.gb_3
end on

on w_plan_master_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_yyyymm)
destroy(this.em_yyyymm)
destroy(this.ddlb_item_code)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.ddlb_mfs)
destroy(this.st_5)
destroy(this.rb_master_plan)
destroy(this.rb_assembly_plan)
destroy(this.ddlb_line_code)
destroy(this.sle_customer_order_no)
destroy(this.st_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)


if upperbound(Gst_return.gvs_return[]) > 0 then

	sle_customer_order_no.text = Gst_return.gvs_return[1]
else
end if

cb_retrieve.triggerevent(CLICKED!)
ivs_mousemove_yn = 'N'
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_plan_master_popup
integer width = 3625
end type

type cb_sort from w_popup_root`cb_sort within w_plan_master_popup
boolean visible = true
integer x = 2469
integer y = 364
end type

type cb_close from w_popup_root`cb_close within w_plan_master_popup
boolean visible = true
integer x = 3305
integer y = 364
end type

type st_msg from w_popup_root`st_msg within w_plan_master_popup
boolean visible = true
integer x = 5
integer y = 564
integer width = 3625
end type

type dw_1 from w_popup_root`dw_1 within w_plan_master_popup
boolean visible = true
integer y = 856
integer width = 3625
integer height = 1112
boolean titlebar = true
string title = "Master Plan List"
string dataobject = "d_pln_master_plan_popup"
boolean controlmenu = true
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_plan_master_popup
boolean visible = true
integer y = 856
integer width = 3625
integer height = 1112
boolean titlebar = true
string title = "Assembly Plan List"
string dataobject = "d_pln_assembly_plan_popup"
boolean controlmenu = true
end type

type dw_3 from w_popup_root`dw_3 within w_plan_master_popup
integer y = 856
end type

type cb_retrieve from so_commandbutton within w_plan_master_popup
integer x = 2747
integer y = 364
integer width = 274
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;if rb_master_plan.checked = true then 
	dw_1.RETRIEVE(  em_yyyymm.text , ddlb_item_code.text+'%' ,ddlb_line_code.getcode()+'%' , ddlb_mfs.text+'%' ,  sle_customer_order_no.text+'%' , GVI_ORGANIZATION_ID )
else
	dw_2.RETRIEVE(  em_yyyymm.text , ddlb_item_code.text+'%' ,ddlb_line_code.getcode()+'%' , ddlb_mfs.text+'%' ,  GVI_ORGANIZATION_ID )	
end if
end event

type cb_select from so_commandbutton within w_plan_master_popup
integer x = 3026
integer y = 364
integer width = 274
integer height = 100
integer taborder = 80
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;if ivd_selected_data_window.getrow() < 1 then 
	gst_return.gvb_return = false
	return -1 
end if 

gst_return.gvb_return = true 
gst_return.gvs_return[1] = ivd_selected_data_window.object.mfs[ivd_selected_data_window.getrow()]
gst_return.gvs_return[2] = ivd_selected_data_window.object.item_code[ivd_selected_data_window.getrow()]
gst_return.gvs_return[3] = ivd_selected_data_window.object.item_name[ivd_selected_data_window.getrow()]
gst_return.gvs_return[4] = ivd_selected_data_window.object.item_spec[ivd_selected_data_window.getrow()]
gst_return.gvs_return[5] = ivd_selected_data_window.object.item_uom[ivd_selected_data_window.getrow()]
 
close(parent)



end event

type st_yyyymm from so_statictext within w_plan_master_popup
integer x = 37
integer y = 340
integer width = 325
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "YYYYMM"
end type

type em_yyyymm from uo_ym within w_plan_master_popup
integer x = 37
integer y = 408
integer taborder = 30
boolean bringtotop = true
end type

type ddlb_item_code from uo_item_code within w_plan_master_popup
integer x = 366
integer y = 412
integer width = 594
integer taborder = 50
boolean bringtotop = true
end type

type st_3 from so_statictext within w_plan_master_popup
integer x = 366
integer y = 352
integer width = 594
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_1 from so_statictext within w_plan_master_popup
integer x = 960
integer y = 344
integer width = 448
integer height = 64
boolean bringtotop = true
integer weight = 700
string text = "Line Code"
end type

type ddlb_mfs from uo_mfs_this_month within w_plan_master_popup
integer x = 1413
integer y = 412
integer width = 494
integer taborder = 60
boolean bringtotop = true
end type

type st_5 from so_statictext within w_plan_master_popup
integer x = 1413
integer y = 328
integer width = 494
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "MFS"
end type

type rb_master_plan from so_radiobutton within w_plan_master_popup
integer x = 64
integer y = 724
boolean bringtotop = true
integer weight = 700
string text = "Master Plan"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.bringtotop = true
ivd_selected_data_window = dw_1

end event

type rb_assembly_plan from so_radiobutton within w_plan_master_popup
integer x = 677
integer y = 724
boolean bringtotop = true
integer weight = 700
string text = "Assembly Plan"
end type

event clicked;call super::clicked;dw_2.bringtotop = true
ivd_selected_data_window = dw_1
end event

type ddlb_line_code from uo_line_code within w_plan_master_popup
integer x = 960
integer y = 412
integer width = 457
integer taborder = 60
boolean bringtotop = true
end type

type sle_customer_order_no from so_singlelineedit within w_plan_master_popup
integer x = 1911
integer y = 412
integer height = 84
integer taborder = 70
boolean bringtotop = true
end type

type st_2 from so_statictext within w_plan_master_popup
integer x = 1911
integer y = 328
integer height = 72
boolean bringtotop = true
integer weight = 700
string text = "Customer Order No Origin"
end type

type gb_1 from so_groupbox within w_plan_master_popup
integer y = 660
integer width = 1239
integer height = 176
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Category"
end type

type gb_2 from so_groupbox within w_plan_master_popup
integer x = 5
integer y = 224
integer width = 2423
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_plan_master_popup
integer x = 2455
integer y = 224
integer width = 1166
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type


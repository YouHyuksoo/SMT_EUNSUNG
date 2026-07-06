HA$PBExportHeader$w_sal_work_cost_popup.srw
$PBExportComments$$$HEX10$$f9b2d4c6c4ac8dd61cc888bc20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_sal_work_cost_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_sal_work_cost_popup
end type
type cb_select from so_commandbutton within w_sal_work_cost_popup
end type
type st_3 from so_statictext within w_sal_work_cost_popup
end type
type st_2 from statictext within w_sal_work_cost_popup
end type
type ddlb_customer_code from uo_customer_code within w_sal_work_cost_popup
end type
type uo_set_item from uo_set_item_code within w_sal_work_cost_popup
end type
type gb_1 from so_groupbox within w_sal_work_cost_popup
end type
type gb_2 from so_groupbox within w_sal_work_cost_popup
end type
end forward

global type w_sal_work_cost_popup from w_popup_root
integer width = 3643
integer height = 2052
string title = "Sale Price Master Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_3 st_3
st_2 st_2
ddlb_customer_code ddlb_customer_code
uo_set_item uo_set_item
gb_1 gb_1
gb_2 gb_2
end type
global w_sal_work_cost_popup w_sal_work_cost_popup

on w_sal_work_cost_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_3=create st_3
this.st_2=create st_2
this.ddlb_customer_code=create ddlb_customer_code
this.uo_set_item=create uo_set_item
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.ddlb_customer_code
this.Control[iCurrent+6]=this.uo_set_item
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_sal_work_cost_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.ddlb_customer_code)
destroy(this.uo_set_item)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;dw_1.settransobject(sqlca)

uo_set_item.settext(message.stringparm)

cb_retrieve.triggerevent(CLICKED!)
IVS_MOUSEMOVE_YN = 'N'
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
	
end if
end event

type p_title from w_popup_root`p_title within w_sal_work_cost_popup
integer width = 3625
end type

type cb_sort from w_popup_root`cb_sort within w_sal_work_cost_popup
boolean visible = true
integer x = 2469
integer y = 360
end type

type cb_close from w_popup_root`cb_close within w_sal_work_cost_popup
boolean visible = true
integer x = 3305
integer y = 360
end type

event cb_close::clicked;call super::clicked;gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_sal_work_cost_popup
boolean visible = true
integer x = 5
integer y = 560
integer width = 3625
end type

type dw_1 from w_popup_root`dw_1 within w_sal_work_cost_popup
boolean visible = true
integer y = 648
integer width = 3625
integer height = 1312
boolean titlebar = true
string title = "Sale Work Cost List"
string dataobject = "d_sal_work_cost_popup_tree"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_sal_work_cost_popup
boolean visible = true
integer y = 800
end type

type dw_3 from w_popup_root`dw_3 within w_sal_work_cost_popup
integer y = 680
end type

type cb_retrieve from so_commandbutton within w_sal_work_cost_popup
integer x = 2747
integer y = 360
integer width = 274
integer height = 100
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;SETPOINTER(HOURGLASS!)
DW_1.RETRIEVE( uo_set_item.text()+ '%' , ddlb_customer_code.text+'%' , GVI_ORGANIZATION_ID )
end event

type cb_select from so_commandbutton within w_sal_work_cost_popup
integer x = 3026
integer y = 360
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
Gst_return.gvf_return[1]= dw_1.object.PRODUCT_WORK_COST[dw_1.getrow()]
Gst_return.gvs_return[1] =  dw_1.object.work_currency[dw_1.getrow( )]

close(parent)



end event

type st_3 from so_statictext within w_sal_work_cost_popup
integer x = 82
integer y = 320
integer width = 512
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_2 from statictext within w_sal_work_cost_popup
integer x = 1312
integer y = 320
integer width = 457
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Customer Code"
alignment alignment = center!
boolean focusrectangle = false
end type

type ddlb_customer_code from uo_customer_code within w_sal_work_cost_popup
integer x = 1303
integer y = 396
integer taborder = 30
boolean bringtotop = true
end type

type uo_set_item from uo_set_item_code within w_sal_work_cost_popup
event destroy ( )
integer x = 69
integer y = 396
integer width = 1225
integer height = 84
integer taborder = 40
boolean bringtotop = true
end type

on uo_set_item.destroy
call uo_set_item_code::destroy
end on

type gb_1 from so_groupbox within w_sal_work_cost_popup
integer x = 2382
integer y = 220
integer width = 1239
integer height = 328
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_sal_work_cost_popup
integer x = 5
integer y = 220
integer width = 1961
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type


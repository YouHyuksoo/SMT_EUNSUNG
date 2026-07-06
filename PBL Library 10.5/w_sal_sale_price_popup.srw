HA$PBExportHeader$w_sal_sale_price_popup.srw
$PBExportComments$$$HEX10$$f9b2d4c6c4ac8dd61cc888bc20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_sal_sale_price_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_sal_sale_price_popup
end type
type cb_select from so_commandbutton within w_sal_sale_price_popup
end type
type st_3 from so_statictext within w_sal_sale_price_popup
end type
type st_2 from statictext within w_sal_sale_price_popup
end type
type ddlb_customer_code from uo_customer_code within w_sal_sale_price_popup
end type
type rb_6 from so_radiobutton within w_sal_sale_price_popup
end type
type rb_5 from so_radiobutton within w_sal_sale_price_popup
end type
type rb_goods from so_radiobutton within w_sal_sale_price_popup
end type
type rb_4 from so_radiobutton within w_sal_sale_price_popup
end type
type rb_1 from so_radiobutton within w_sal_sale_price_popup
end type
type ddlb_item_code from uo_item_code within w_sal_sale_price_popup
end type
type gb_1 from so_groupbox within w_sal_sale_price_popup
end type
type gb_2 from so_groupbox within w_sal_sale_price_popup
end type
type gb_3 from so_groupbox within w_sal_sale_price_popup
end type
end forward

global type w_sal_sale_price_popup from w_popup_root
integer width = 4123
integer height = 2052
string title = "Sale Price Master Popup"
cb_retrieve cb_retrieve
cb_select cb_select
st_3 st_3
st_2 st_2
ddlb_customer_code ddlb_customer_code
rb_6 rb_6
rb_5 rb_5
rb_goods rb_goods
rb_4 rb_4
rb_1 rb_1
ddlb_item_code ddlb_item_code
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_sal_sale_price_popup w_sal_sale_price_popup

type variables

end variables

on w_sal_sale_price_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_3=create st_3
this.st_2=create st_2
this.ddlb_customer_code=create ddlb_customer_code
this.rb_6=create rb_6
this.rb_5=create rb_5
this.rb_goods=create rb_goods
this.rb_4=create rb_4
this.rb_1=create rb_1
this.ddlb_item_code=create ddlb_item_code
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.ddlb_customer_code
this.Control[iCurrent+6]=this.rb_6
this.Control[iCurrent+7]=this.rb_5
this.Control[iCurrent+8]=this.rb_goods
this.Control[iCurrent+9]=this.rb_4
this.Control[iCurrent+10]=this.rb_1
this.Control[iCurrent+11]=this.ddlb_item_code
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.gb_3
end on

on w_sal_sale_price_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.ddlb_customer_code)
destroy(this.rb_6)
destroy(this.rb_5)
destroy(this.rb_goods)
destroy(this.rb_4)
destroy(this.rb_1)
destroy(this.ddlb_item_code)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)

ddlb_item_code.text =message.stringparm

cb_retrieve.triggerevent(CLICKED!)
IVS_MOUSEMOVE_YN = 'N'
end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_sal_sale_price_popup
integer width = 4105
end type

type cb_sort from w_popup_root`cb_sort within w_sal_sale_price_popup
boolean visible = true
integer x = 2944
integer y = 328
integer height = 128
end type

type cb_close from w_popup_root`cb_close within w_sal_sale_price_popup
boolean visible = true
integer x = 3781
integer y = 328
integer height = 128
end type

event cb_close::clicked;gst_return.gvb_return = false
Close(parent)
end event

type st_msg from w_popup_root`st_msg within w_sal_sale_price_popup
boolean visible = true
integer x = 5
integer y = 560
integer width = 4105
end type

type dw_1 from w_popup_root`dw_1 within w_sal_sale_price_popup
boolean visible = true
integer x = 5
integer y = 652
integer width = 4105
integer height = 1312
boolean titlebar = true
string title = "Product Sale Price List"
string dataobject = "d_sal_sale_price_popup_tree"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_sal_sale_price_popup
boolean visible = true
integer y = 800
end type

type dw_3 from w_popup_root`dw_3 within w_sal_sale_price_popup
integer y = 656
end type

type cb_retrieve from so_commandbutton within w_sal_sale_price_popup
integer x = 3223
integer y = 328
integer width = 274
integer height = 128
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;string lvs_sale_charge
SETPOINTER(HOURGLASS!)
				
				if Gvs_use_sale_charge_condition = 'Y' and Gvi_user_level < 8 then
					lvs_sale_charge = Gvs_user_id
				else
					lvs_sale_charge = '%'
				end if
DW_1.RETRIEVE( ddlb_item_code.text+ '%' , ddlb_customer_code.text+'%' , lvs_sale_charge , GVI_ORGANIZATION_ID )
end event

type cb_select from so_commandbutton within w_sal_sale_price_popup
integer x = 3502
integer y = 328
integer width = 274
integer height = 128
integer taborder = 80
boolean bringtotop = true
string text = "Select"
boolean default = true
end type

event clicked;if dw_1.getrow() < 1 then 
	gst_return.gvb_return = false
	return -1 
end if 

if dw_1.object.price_change_confirm_yn[dw_1.getrow()] = 'N' then
	f_msgbox1(822 , f_get_dual_lang_text( Gvs_language,  "Confirm") )
	return 
end if 

gst_return.gvb_return = true 
message.stringparm = dw_1.object.item_code[dw_1.getrow()]
Gst_return.gvf_return[1]= dw_1.object.product_sale_price[dw_1.getrow()]

Gst_return.gvs_return[1] =  dw_1.object.sale_currency[dw_1.getrow( )]
Gst_return.gvs_return[2] =  dw_1.object.customer_code[dw_1.getrow( )]
Gst_return.gvs_return[3] =  dw_1.object.product_line_type[dw_1.getrow( )]

Gst_return.gvs_return[4] =  dw_1.object.item_name[dw_1.getrow( )]
Gst_return.gvs_return[5] =  dw_1.object.item_spec[dw_1.getrow( )]
//Gst_return.gvs_return[6] =  dw_1.object.item_uom[dw_1.getrow( )]



//================================================
// $$HEX8$$18c29ccd200010d3e4b900aca9ac2000$$ENDHEX$$
//================================================
if gvs_product_sale_price_type = 'F' then //$$HEX33$$e0ac1dac44c720006cad84bd58d5c0c920004ac5e0ac200010d300ac15c8f4bc58c7200018c29ccd2000b4b018c200aca9ac3cc75cb8200010d3e4b920b44cb52000$$ENDHEX$$
	Gst_return.gvf_return[2]= dw_1.object.foreign_sale_price[dw_1.getrow()]
	Gst_return.gvs_return[4] =  dw_1.object.foreign_sale_currency[dw_1.getrow( )]
else
	Gst_return.gvf_return[2]= dw_1.object.product_sale_price[dw_1.getrow()]
	Gst_return.gvs_return[4] =  dw_1.object.sale_currency[dw_1.getrow( )]	
end if 

closewithreturn(parent , message.stringparm)



end event

type st_3 from so_statictext within w_sal_sale_price_popup
integer x = 87
integer y = 328
integer width = 558
integer height = 60
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type st_2 from statictext within w_sal_sale_price_popup
integer x = 649
integer y = 332
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

type ddlb_customer_code from uo_customer_code within w_sal_sale_price_popup
integer x = 649
integer y = 408
integer taborder = 30
boolean bringtotop = true
end type

type rb_6 from so_radiobutton within w_sal_sale_price_popup
integer x = 1801
integer y = 308
integer width = 325
boolean bringtotop = true
integer weight = 700
string text = "All"
boolean checked = true
end type

event clicked;call super::clicked;dw_1.setfilter('')
dw_1.filter()
end event

type rb_5 from so_radiobutton within w_sal_sale_price_popup
integer x = 1801
integer y = 412
integer width = 325
boolean bringtotop = true
integer weight = 700
string text = "Material"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'R' ")
dw_1.filter()
end event

type rb_goods from so_radiobutton within w_sal_sale_price_popup
integer x = 2139
integer y = 412
integer width = 329
boolean bringtotop = true
integer weight = 700
string text = "Goods"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'G' ")
dw_1.filter()
end event

type rb_4 from so_radiobutton within w_sal_sale_price_popup
integer x = 2478
integer y = 308
integer width = 334
boolean bringtotop = true
integer weight = 700
string text = "Assembly"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'W")
dw_1.filter()
end event

type rb_1 from so_radiobutton within w_sal_sale_price_popup
integer x = 2139
integer y = 308
integer width = 329
boolean bringtotop = true
integer weight = 700
string text = "Product"
end type

event clicked;call super::clicked;dw_1.setfilter("item_division = 'F' ")
dw_1.filter()
end event

type ddlb_item_code from uo_item_code within w_sal_sale_price_popup
integer x = 87
integer y = 408
integer width = 558
integer taborder = 30
boolean bringtotop = true
end type

type gb_1 from so_groupbox within w_sal_sale_price_popup
integer x = 2866
integer y = 220
integer width = 1239
integer height = 328
integer taborder = 30
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

type gb_2 from so_groupbox within w_sal_sale_price_popup
integer x = 5
integer y = 220
integer width = 1170
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_sal_sale_price_popup
integer x = 1742
integer y = 220
integer width = 1115
integer height = 328
integer taborder = 40
integer weight = 700
long textcolor = 16711680
string text = "Filter"
end type


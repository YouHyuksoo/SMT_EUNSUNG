HA$PBExportHeader$uo_product_item_code.sru
$PBExportComments$Item Code
forward
global type uo_product_item_code from dropdownlistbox
end type
type st_vendor from structure within uo_product_item_code
end type
end forward

type st_vendor from structure
	string		vendor_name
	string		vendor_name_eng
end type

global type uo_product_item_code from dropdownlistbox
integer width = 521
integer height = 724
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "Help!"
long textcolor = 33554432
boolean allowedit = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
event ue_editchange pbm_cbneditchange
end type
global uo_product_item_code uo_product_item_code

type variables

end variables

forward prototypes
public function string text ()
end prototypes

event ue_editchange;IF GVS_ITEM_SEARCH_YN = 'Y' THEN
	
	if Len(this.text) = 0 then
	else
			openwithparm(w_item_search_flat , this.text)
			this.text = message.stringparm
	end if 
END IF
end event

public function string text ();RETURN upper(THIS.TEXT)
end function

on uo_product_item_code.create
end on

on uo_product_item_code.destroy
end on

event rbuttondown;

//openwithparm(w_des_product_item_popup , UPPER(this.text))

//if gst_return.gvb_return = true then 
//   this.text = MESSAGE.STRINGPARM 
//end if
end event


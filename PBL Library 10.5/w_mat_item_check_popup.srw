HA$PBExportHeader$w_mat_item_check_popup.srw
$PBExportComments$$$HEX8$$6cade4b9e8b200ac20c1ddd01dd3c5c5$$ENDHEX$$
forward
global type w_mat_item_check_popup from w_popup_root
end type
type cb_retrieve from so_commandbutton within w_mat_item_check_popup
end type
type cb_select from so_commandbutton within w_mat_item_check_popup
end type
type st_item_code from so_statictext within w_mat_item_check_popup
end type
type ddlb_item_code from uo_item_code within w_mat_item_check_popup
end type
type gb_2 from so_groupbox within w_mat_item_check_popup
end type
type gb_3 from so_groupbox within w_mat_item_check_popup
end type
end forward

global type w_mat_item_check_popup from w_popup_root
integer width = 4123
integer height = 2232
string title = "Item Check Popup"
string ivs_resize_type = "DEFAULT"
cb_retrieve cb_retrieve
cb_select cb_select
st_item_code st_item_code
ddlb_item_code ddlb_item_code
gb_2 gb_2
gb_3 gb_3
end type
global w_mat_item_check_popup w_mat_item_check_popup

on w_mat_item_check_popup.create
int iCurrent
call super::create
this.cb_retrieve=create cb_retrieve
this.cb_select=create cb_select
this.st_item_code=create st_item_code
this.ddlb_item_code=create ddlb_item_code
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.cb_select
this.Control[iCurrent+3]=this.st_item_code
this.Control[iCurrent+4]=this.ddlb_item_code
this.Control[iCurrent+5]=this.gb_2
this.Control[iCurrent+6]=this.gb_3
end on

on w_mat_item_check_popup.destroy
call super::destroy
destroy(this.cb_retrieve)
destroy(this.cb_select)
destroy(this.st_item_code)
destroy(this.ddlb_item_code)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;dw_1.settransobject(sqlca)
ddlb_item_code.text = message.stringparm
cb_retrieve.triggerevent(CLICKED!)

end event

event key;call super::key;if key = keyf1! then 
   cb_retrieve.triggerevent(clicked!)
end if
end event

type p_title from w_popup_root`p_title within w_mat_item_check_popup
integer width = 4128
end type

type cb_sort from w_popup_root`cb_sort within w_mat_item_check_popup
boolean visible = true
integer x = 2606
integer y = 304
integer width = 343
integer height = 180
end type

type cb_close from w_popup_root`cb_close within w_mat_item_check_popup
boolean visible = true
integer x = 3662
integer y = 304
integer width = 343
integer height = 180
end type

event cb_close::clicked;call super::clicked;Gst_return.gvb_return = false
end event

type st_msg from w_popup_root`st_msg within w_mat_item_check_popup
boolean visible = true
integer x = 5
integer y = 556
integer width = 4128
end type

type dw_1 from w_popup_root`dw_1 within w_mat_item_check_popup
boolean visible = true
integer y = 648
integer width = 4128
integer height = 716
boolean titlebar = true
string title = "Unit Price List"
string dataobject = "d_mat_unit_price_popup_4_check_lst"
end type

event dw_1::doubleclicked;call super::doubleclicked;IF ROW = 0  THEN 
	RETURN -1
END IF
cb_select.triggerevent(clicked!)
end event

type dw_2 from w_popup_root`dw_2 within w_mat_item_check_popup
boolean visible = true
integer y = 1376
integer width = 4128
integer height = 768
boolean titlebar = true
string title = "Material Item List"
string dataobject = "d_mat_item_popup_4_check_tree"
end type

type dw_3 from w_popup_root`dw_3 within w_mat_item_check_popup
integer y = 668
end type

type cb_retrieve from so_commandbutton within w_mat_item_check_popup
integer x = 2962
integer y = 304
integer width = 343
integer height = 180
integer taborder = 70
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;DW_1.RETRIEVE( ddlb_item_code.text + '%' , GVI_ORGANIZATION_ID )
DW_2.RETRIEVE( ddlb_item_code.text + '%' , GVI_ORGANIZATION_ID )
end event

type cb_select from so_commandbutton within w_mat_item_check_popup
integer x = 3310
integer y = 304
integer width = 343
integer height = 180
integer taborder = 80
boolean bringtotop = true
string text = "Save"
boolean default = true
end type

event clicked;if dw_2.update() < 0 then 
	rollback ;
else
	commit ;
end if 


end event

type st_item_code from so_statictext within w_mat_item_check_popup
integer x = 32
integer y = 332
integer width = 622
integer height = 68
boolean bringtotop = true
integer weight = 700
string text = "Item Code"
end type

type ddlb_item_code from uo_item_code within w_mat_item_check_popup
integer x = 32
integer y = 404
integer width = 622
integer taborder = 20
boolean bringtotop = true
end type

type gb_2 from so_groupbox within w_mat_item_check_popup
integer x = 9
integer y = 216
integer width = 699
integer height = 328
integer taborder = 10
integer weight = 700
long textcolor = 16711680
string text = "Where Condition"
end type

type gb_3 from so_groupbox within w_mat_item_check_popup
integer x = 2537
integer y = 216
integer width = 1522
integer height = 328
integer taborder = 20
integer weight = 700
long textcolor = 16711680
string text = "Process"
end type

